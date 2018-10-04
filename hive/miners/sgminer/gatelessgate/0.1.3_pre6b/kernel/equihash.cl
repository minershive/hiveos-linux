// Gateless Gate, a Zcash miner
// Copyright 2016-2017 zawawa @ bitcointalk.org
//
// The initial version of this software was based on:
// SILENTARMY v5
// The MIT License (MIT) Copyright (c) 2016 Marc Bevand, Genoil, eXtremal
//
// This program is free software : you can redistribute it and / or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

#ifndef PARAM_N
#define PARAM_N				   200
#endif
#ifndef PARAM_K
#define PARAM_K			       9
#endif

#include "equihash-param.h"

#pragma OPENCL EXTENSION cl_khr_global_int32_base_atomics : enable
#ifdef AMD
#pragma OPENCL EXTENSION cl_amd_vec3 : enable
#endif
//#pragma OPENCL EXTENSION cl_ext_atomic_counters_32 : enable



/////////////////
// HASH TABLES //
/////////////////

/*
** With the new hash tables, each slot has this layout (length in bytes in parens):
**
** round 0, table 0: i(4) pad(0) Xi(24) pad(4)
** round 1, table 1: i(4) pad(3) Xi(20) pad(5)
** round 2, table 2: i(4) pad(0) Xi(19) pad(9)
** round 3, table 3: i(4) pad(3) Xi(15) pad(10)
** round 4, table 4: i(4) pad(0) Xi(14) pad(14)
** round 5, table 5: i(4) pad(3) Xi(10) pad(15)
** round 6, table 6: i(4) pad(0) Xi( 9) pad(19)
** round 7, table 7: i(4) pad(3) Xi( 5) pad(20)
** round 8, table 8: i(4) pad(0) Xi( 4) pad(24)
*/

typedef union {
    struct {
        uint xi[7];
        uint padding;
    } slot;
    uint8 ui8;
    uint4 ui4[2];
    uint2 ui2[4];
    uint  ui[8];
#ifdef AMD
    ulong3 ul3;
    uint3 ui3[2];
#endif
} slot_t;

typedef __global slot_t *global_pointer_to_slot_t;



/*
** OBSOLETE
** If xi0,xi1,xi2,xi3 are stored consecutively in little endian then they
** represent (hex notation, group of 5 hex digits are a group of PREFIX bits):
**   aa aa ab bb bb cc cc cd dd...  [round 0]
**         --------------------
**      ...ab bb bb cc cc cd dd...  [odd round]
**               --------------
**               ...cc cc cd dd...  [next even round]
**                        -----
** Bytes underlined are going to be stored in the slot. Preceding bytes
** (and possibly part of the underlined bytes, depending on NR_ROWS_LOG) are
** used to compute the row number.
**
** Round 0: xi0,xi1,xi2,xi3 is a 25-byte Xi (xi3: only the low byte matter)
** Round 1: xi0,xi1,xi2 is a 23-byte Xi (incl. the colliding PREFIX nibble)
** TODO: update lines below with padding nibbles
** Round 2: xi0,xi1,xi2 is a 20-byte Xi (xi2: only the low 4 bytes matter)
** Round 3: xi0,xi1,xi2 is a 17.5-byte Xi (xi2: only the low 1.5 bytes matter)
** Round 4: xi0,xi1 is a 15-byte Xi (xi1: only the low 7 bytes matter)
** Round 5: xi0,xi1 is a 12.5-byte Xi (xi1: only the low 4.5 bytes matter)
** Round 6: xi0,xi1 is a 10-byte Xi (xi1: only the low 2 bytes matter)
** Round 7: xi0 is a 7.5-byte Xi (xi0: only the low 7.5 bytes matter)
** Round 8: xi0 is a 5-byte Xi (xi0: only the low 5 bytes matter)
**
** Return 0 if successfully stored, or 1 if the row overflowed.
*/

__global char *get_slot_ptr(__global char *ht, uint round, uint row, uint slot)
{
#ifdef NVIDIA
    uint chunk_size_log = 4; 
    chunk_size_log += (_SLOT_LEN(round) == 8) ? 2 : (_SLOT_LEN(round) == 16) ? 1 : 0; 
    return ht + (slot >> chunk_size_log) * _NR_ROWS(round) * (1 << chunk_size_log)                 * _SLOT_LEN(round)
              +                            row             * (1 << chunk_size_log)                 * _SLOT_LEN(round)
              +                                              (slot & ((1 << chunk_size_log) - 1))  * _SLOT_LEN(round);
#else
        return ht + (row * _NR_SLOTS(round) + slot) * _SLOT_LEN(round);
#endif
}

__global uint *get_xi_ptr(__global char *ht, uint round, uint row, uint slot)
{
    return (__global uint *)get_slot_ptr(ht, round, row, slot);
}

__global uint *get_ref_ptr(__global char *ht, uint round, uint row, uint slot)
{
    return get_xi_ptr(ht, round, row, slot) + UINTS_IN_XI(round);
}

uint get_row(uint round, uint xi0)
{
    uint           row = 0;

    if (_NR_ROWS_LOG(round) == 12) {
        if (!(round % 2))
            row = (xi0 & 0xfff);
        else
            row = ((xi0 & 0x0f0f00) >> 8) | ((xi0 & 0xf0000000) >> 24);
    } else if (_NR_ROWS_LOG(round) == 13) {
        if (!(round % 2))
            row = (xi0 & 0x1fff);
        else
            row = ((xi0 & 0x1f0f00) >> 8) | ((xi0 & 0xf0000000) >> 24);
    }

    return row;
}

void get_row_counters_index(uint *row_counter_index, uint *row_counter_offset, uint row)
{
#ifdef OPTIM_FAST_INTEGER_DIVISION
    if (ROWS_PER_UINT == 3) {
        uint r = (0x55555555 * row + (row >> 1) - (row >> 3)) >> 30;
        *row_counter_index = (row - r) * 0xAAAAAAAB;
        *row_counter_offset = BITS_PER_ROW * r;
    } else if (ROWS_PER_UINT == 6) {
        uint r = (0x55555555 * row + (row >> 1) - (row >> 3)) >> 29;
        *row_counter_index = (row - r) * 0xAAAAAAAB * 2;
        *row_counter_offset = BITS_PER_ROW * r;
    } else
#endif
    {
        *row_counter_index = row / ROWS_PER_UINT;
        *row_counter_offset = BITS_PER_ROW * (row % ROWS_PER_UINT);
    }
}

#ifdef OPTIM_UINT_ROW_COUNTERS

uint get_nr_slots(uint round, __global uint *row_counters, uint row_index)
{
    uint nr_slots = row_counters[row_index];
    nr_slots = min(nr_slots, (uint)_NR_SLOTS(round)); // handle possible overflow in last round
    return nr_slots;
}

uint get_nr_slots_local(uint round, __local uint *row_counters, uint row_index)
{
    uint nr_slots = row_counters[row_index];
    nr_slots = min(nr_slots, (uint)_NR_SLOTS(round)); // handle possible overflow in last round
    return nr_slots;
}

uint inc_row_counter(uint round, __global uint *row_counters, uint row_index)
{
    uint nr_slots = atomic_inc(row_counters + row_index);
#ifndef OPTIM_IGNORE_ROW_COUNTER_OVERFLOWS
    if (nr_slots >= _NR_SLOTS(round)) {
        // avoid overflows
        atomic_dec(row_counters + row_index);
    }
#endif
    return nr_slots;
}

uint inc_local_row_counter(uint round, __local uint *row_counters, uint row_index)
{
    uint nr_slots = atomic_inc(row_counters + row_index);
#ifndef OPTIM_IGNORE_ROW_COUNTER_OVERFLOWS
    if (nr_slots >= _NR_SLOTS(round)) {
        // avoid overflows
        atomic_dec(row_counters + row_index);
    }
#endif
    return nr_slots;
}

#else


uint get_nr_slots(uint round, __global uint *row_counters, uint row_index)
{
    uint row_counter_index, row_counter_offset, nr_slots;
    get_row_counters_index(&row_counter_index, &row_counter_offset, row_index);
    nr_slots = (row_counters[row_counter_index] >> row_counter_offset) & ROW_MASK;
    nr_slots = min(nr_slots, (uint)_NR_SLOTS(round)); // handle possible overflow in last round
    return nr_slots;
}

uint get_nr_slots_local(uint round, __local uint *row_counters, uint row_index)
{
    uint row_counter_index, row_counter_offset, nr_slots;
    get_row_counters_index(&row_counter_index, &row_counter_offset, row_index);
    nr_slots = (row_counters[row_counter_index] >> row_counter_offset) & ROW_MASK;
    nr_slots = min(nr_slots, (uint)_NR_SLOTS(round)); // handle possible overflow in last round
    return nr_slots;
}

uint inc_row_counter(uint round, __global uint *row_counters, uint row)
{
    uint row_counter_index, row_counter_offset;
    get_row_counters_index(&row_counter_index, &row_counter_offset, row);
    uint nr_slots = atomic_add(row_counters + row_counter_index, 1U << row_counter_offset);
    nr_slots = (nr_slots >> row_counter_offset) & ROW_MASK;
#ifndef OPTIM_IGNORE_ROW_COUNTER_OVERFLOWS
    if (nr_slots >= _NR_SLOTS(round)) {
        // avoid overflows
        atomic_sub(row_counters + row_counter_index, 1 << row_counter_offset);
    }
#endif
    return nr_slots;
}

uint inc_local_row_counter(uint round, __local uint *row_counters, uint row)
{
    uint row_counter_index, row_counter_offset;
    get_row_counters_index(&row_counter_index, &row_counter_offset, row);
    uint nr_slots = atomic_add(row_counters + row_counter_index, 1U << row_counter_offset);
    nr_slots = (nr_slots >> row_counter_offset) & ROW_MASK;
#ifndef OPTIM_IGNORE_ROW_COUNTER_OVERFLOWS
    if (nr_slots >= _NR_SLOTS(round)) {
        // avoid overflows
        atomic_sub(row_counters + row_counter_index, 1 << row_counter_offset);
    }
#endif
    return nr_slots;
}

#endif


/*
** Reset counters in a hash table.
*/

__kernel
void kernel_init_ht(uint device_thread, uint round, __global uint *hash_table, __global uint *row_counters_src, __global uint *row_counters_dst, __global sols_t *sols, __global potential_sols_t *potential_sols, __global uint *sync_flags)
{
#ifdef AMD_GCN_ASM
    __local volatile uint  gds_dummy_base[1];
    __local volatile uint *gds_dummy_src = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 1) % 2));
    __local volatile uint *gds_dummy_dst = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 0) % 2));
#endif
    if (get_global_id(0) < (_NR_ROWS(round) + ROWS_PER_UINT - 1) / ROWS_PER_UINT) {
#ifdef AMD_GCN_ASM
        gds_dummy_dst[get_global_id(0)] = 0;
#else
        row_counters_dst[get_global_id(0)] = 0;
#endif
    }
    if (!get_global_id(0))
        sols->nr = sols->likely_invalids = potential_sols->nr = sync_flags[0] = sync_flags[1] = 0;
}



/////////////
// ROUND 0 //
/////////////

__constant ulong blake_iv[] =
{
    0x6a09e667f3bcc908, 0xbb67ae8584caa73b,
    0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1,
    0x510e527fade682d1, 0x9b05688c2b3e6c1f,
    0x1f83d9abfb41bd6b, 0x5be0cd19137e2179,
};

#define mix_x_0(va, vb, vc, vd, x) \
    va = (va + vb + (x)); \
vd = rotate((vd ^ va), (ulong)64 - 32); \
vc = (vc + vd); \
vb = rotate((vb ^ vc), (ulong)64 - 24); \
va = (va + vb); \
vd = rotate((vd ^ va), (ulong)64 - 16); \
vc = (vc + vd); \
vb = rotate((vb ^ vc), (ulong)64 - 63);

#define mix_0_y(va, vb, vc, vd, y) \
    va = (va + vb); \
vd = rotate((vd ^ va), (ulong)64 - 32); \
vc = (vc + vd); \
vb = rotate((vb ^ vc), (ulong)64 - 24); \
va = (va + vb + (y)); \
vd = rotate((vd ^ va), (ulong)64 - 16); \
vc = (vc + vd); \
vb = rotate((vb ^ vc), (ulong)64 - 63);

#define mix_0_0(va, vb, vc, vd) \
    va = (va + vb); \
vd = rotate((vd ^ va), (ulong)64 - 32); \
vc = (vc + vd); \
vb = rotate((vb ^ vc), (ulong)64 - 24); \
va = (va + vb); \
vd = rotate((vd ^ va), (ulong)64 - 16); \
vc = (vc + vd); \
vb = rotate((vb ^ vc), (ulong)64 - 63);

/*
** Execute round 0 (blake).
**
** Note: making the work group size less than or equal to the wavefront size
** allows the OpenCL compiler to remove the barrier() calls, see "2.2 Local
** Memory (LDS) Optimization 2-10" in:
** http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/opencl-optimization-guide/
*/

__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE_ROUND0, 1, 1)))
void kernel_round0(uint device_thread, __constant ulong *blake_state, __global char *ht,
    __global uint *row_counters, __global uint *sync_flags)
{
#ifdef AMD_GCN_ASM
    __local volatile uint gds_dummy_base[1];
    __local volatile uint *gds_dummy = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * device_thread * 2;
#endif

#if defined(AMD) && !defined(AMD_LEGACY) && !defined(__GCNMINC__)
    volatile ulong      v[16];
#else
    ulong               v[16];
#endif
    uint xi0, xi1, xi2, xi3, xi4, xi5, xi6;
    slot_t slot;
    ulong               h[7];

    uint input = get_global_id(0);

    // shift "i" to occupy the high 32 bits of the second ulong word in the
    // message block
    ulong word1 = (ulong)input << 32;
    // init vector v
    v[0] = blake_state[0];
    v[1] = blake_state[1];
    v[2] = blake_state[2];
    v[3] = blake_state[3];
    v[4] = blake_state[4];
    v[5] = blake_state[5];
    v[6] = blake_state[6];
    v[7] = blake_state[7];
    v[8] = blake_iv[0];
    v[9] = blake_iv[1];
    v[10] = blake_iv[2];
    v[11] = blake_iv[3];
    v[12] = blake_iv[4];
    v[13] = blake_iv[5];
    v[14] = blake_iv[6];
    v[15] = blake_iv[7];
    // mix in length of data
    v[12] ^= ZCASH_BLOCK_HEADER_LEN + 4 /* length of "i" */;
    // last block
    v[14] ^= (ulong)-1;

    mix_0_y(v[0], v[4], v[8], v[12], word1);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_x_0(v[0], v[5], v[10], v[15], word1);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);
    
    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_y(v[2], v[7], v[8], v[13], word1);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_y(v[1], v[5], v[9], v[13], word1);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_y(v[0], v[5], v[10], v[15], word1);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_x_0(v[3], v[4], v[9], v[14], word1);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_x_0(v[1], v[5], v[9], v[13], word1);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_y(v[2], v[6], v[10], v[14], word1);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_x_0(v[2], v[7], v[8], v[13], word1);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_x_0(v[3], v[7], v[11], v[15], word1);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_y(v[0], v[4], v[8], v[12], word1);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_x_0(v[0], v[5], v[10], v[15], word1);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    // compress v into the blake state; this produces the 50-byte hash
    // (two Xi values)
    h[0] = blake_state[0] ^ v[0] ^ v[8];
    h[1] = blake_state[1] ^ v[1] ^ v[9];
    h[2] = blake_state[2] ^ v[2] ^ v[10];
    h[3] = blake_state[3] ^ v[3] ^ v[11];
    h[4] = blake_state[4] ^ v[4] ^ v[12];
    h[5] = blake_state[5] ^ v[5] ^ v[13];
    h[6] = (blake_state[6] ^ v[6] ^ v[14]) & 0xffff;

    // store the two Xi values in the hash table
#if 0//defined(AMD)
#pragma unroll 1
    for (uint index = 0; index < 2; ++index) {
#else
#pragma unroll 2
    for (uint index = 0; index < 2; ++index) {
#endif

#if PARAM_N == 200 && PARAM_K == 9
        if (!index) {
            xi0 = h[0] & 0xffffffff; xi1 = h[0] >> 32;
            xi2 = h[1] & 0xffffffff; xi3 = h[1] >> 32;
            xi4 = h[2] & 0xffffffff; xi5 = h[2] >> 32;
            xi6 = h[3] & 0xffffffff;
        } else {
            xi0 = ((h[3] >> 8) | (h[4] << (64 - 8))) & 0xffffffff; xi1 = ((h[3] >> 8) | (h[4] << (64 - 8))) >> 32;
            xi2 = ((h[4] >> 8) | (h[5] << (64 - 8))) & 0xffffffff; xi3 = ((h[4] >> 8) | (h[5] << (64 - 8))) >> 32;
            xi4 = ((h[5] >> 8) | (h[6] << (64 - 8))) & 0xffffffff; xi5 = ((h[5] >> 8) | (h[6] << (64 - 8))) >> 32;
            xi6 = (h[6] >> 8) & 0xffffffff;
        }
#elif PARAM_N == 192 && PARAM_K == 7
        if (!index) {
            xi0 = h[0] & 0xffffffff; 
            xi1 = h[0] >> 32;
            xi2 = h[1] & 0xffffffff; 
            xi3 = 0;
            xi4 = 0; 
            xi5 = 0;
            xi6 = 0;
        } else {
            xi0 = h[1] >> 32;
            xi1 = h[2] & 0xffffffff; 
            xi2 = h[2] >> 32;
            xi3 = 0;
            xi4 = 0; 
            xi5 = 0;
            xi6 = 0;
        }
#else
#error "unsupported ZCASH_HASH_LEN"
#endif

        uint row = get_row(0, xi0);
#ifdef AMD_GCN_ASM
        uint nr_slots = inc_local_row_counter(0, gds_dummy, row);
#else
        uint nr_slots = inc_row_counter((0), row_counters, row);
#endif
        if (nr_slots < _NR_SLOTS(0)) {
            slot.slot.xi[0] = ((xi1 << 24) | (xi0 >> 8));
            slot.slot.xi[1] = ((xi2 << 24) | (xi1 >> 8));
            slot.slot.xi[2] = ((xi3 << 24) | (xi2 >> 8));
            slot.slot.xi[3] = ((xi4 << 24) | (xi3 >> 8));
            slot.slot.xi[4] = ((xi5 << 24) | (xi4 >> 8));
            slot.slot.xi[5] = ((xi6 << 24) | (xi5 >> 8));
            slot.slot.xi[UINTS_IN_XI(0)] = input * 2 + index;
            __global char *p = get_slot_ptr(ht, 0, row, nr_slots);
            *(__global uint8 *)p = slot.ui8;
        }
    }
}

/*
** XOR a pair of Xi values computed at "round - 1" and store the result in the
** hash table being built for "round". Note that when building the table for
** even rounds we need to skip 1 padding byte present in the "round - 1" table
** (the "0xAB" byte mentioned in the description at the top of this file.) But
** also note we can't load data directly past this byte because this would
** cause an unaligned memory access which is undefined per the OpenCL spec.
**
** Return 0 if successfully stored, or 1 if the row overflowed.
*/

uint xor_and_store(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi,
    __global uint *row_counters,
    __local uint *gds_dummy_base)
{
#ifdef AMD_GCN_ASM
    gds_dummy_base = 0;
    __local volatile uint *gds_dummy_src = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 1) % 2));
    __local volatile uint *gds_dummy_dst = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 0) % 2));
#endif
    uint ret = 0;
    uint xi0, xi1, xi2, xi3, xi4, xi5;

    slot_t slot;
    __global slot_t *p = 0;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 4) xi4 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 2) xi5 = *(ai += _NR_SLOTS(round - 1));

        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 4) xi4 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 2) xi5 ^= *(bi += _NR_SLOTS(round - 1));

        if (!(round & 0x1)) {
            // skip padding bytes
            xi0 = (xi0 >> 24) | (xi1 << (32 - 24));

            slot.slot.xi[0] = xi1;
            slot.slot.xi[1] = xi2;
            slot.slot.xi[2] = xi3;
            slot.slot.xi[3] = xi4;
            slot.slot.xi[4] = xi5;
        } else {
            slot.slot.xi[0] = ((xi1 << 24) | (xi0 >> 8));
            if (round <= 7) slot.slot.xi[1] = ((xi2 << 24) | (xi1 >> 8));
            if (round <= 6) slot.slot.xi[2] = ((xi3 << 24) | (xi2 >> 8));
            if (round <= 5) slot.slot.xi[3] = ((xi4 << 24) | (xi3 >> 8));
            if (round <= 3) slot.slot.xi[4] = ((xi5 << 24) | (xi4 >> 8));
            if (round <= 1) slot.slot.xi[5] = ((xi5 >> 8));
        }
        slot.slot.xi[UINTS_IN_XI(round)] = ENCODE_INPUTS(round - 1, row, slot_a, slot_b);

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            uint new_row = get_row(round, xi0);
#ifdef AMD_GCN_ASM
            uint new_slot_index = inc_local_row_counter(round, gds_dummy_dst, new_row);
#else
            uint new_slot_index = inc_row_counter(round, row_counters, new_row);
#endif
            if (new_slot_index >= _NR_SLOTS(round)) {
                ret = 1;
            } else {
                p = (__global slot_t *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
            }
        }
    }

    if (p) {
#ifdef OPTIM_8BYTE_WRITES
        if (round >= 8)
            *(__global uint2 *)p = slot.ui2[0];
        else
#endif
#ifdef OPTIM_12BYTE_WRITES
        if (round >= 7)
            *(__global uint3 *)p = slot.ui3[0];
        else
#endif
#ifdef OPTIM_16BYTE_WRITES
        if (round >= 6)
            *(__global uint4 *)p = slot.ui4[0];
        else
#endif
#ifdef OPTIM_24BYTE_WRITES
        if (round >= 2)
            *(__global ulong3 *)p = slot.ul3;
        else
#endif
            *(__global uint8 *)p = slot.ui8;
    }
    return ret;
}

uint parallel_xor_and_store(
    uint device_thread,
    uint round, 
    __global char *ht_src, 
    __global char *ht_dst,
    uint row,
    uint slot_a,
    uint slot_b,
    __local uint *ai,
    __local uint *bi,
    __global uint *row_counters,
    __local SLOT_INDEX_TYPE *new_slot_indexes,
    __local uint *gds_dummy_base)
{
#ifdef AMD_GCN_ASM
    gds_dummy_base = 0;
    __local volatile uint *gds_dummy_src = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 1) % 2));
    __local volatile uint *gds_dummy_dst = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 0) % 2));
#endif

    uint ret = 0;
    uint xi0, xi1, xi2, xi3, xi4, xi5;
    uint write_index = get_local_id(0) / THREADS_PER_WRITE(round);
    uint write_thread_index = get_local_id(0) % THREADS_PER_WRITE(round);

    slot_t slot;
    uint new_row;

    if (!write_thread_index)
        new_slot_indexes[write_index] = _NR_SLOTS(round);
    //barrier(CLK_LOCAL_MEM_FENCE);

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 4) xi4 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 2) xi5 = *(ai += _NR_SLOTS(round - 1));

        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 4) xi4 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 2) xi5 ^= *(bi += _NR_SLOTS(round - 1));

        if (!(round & 0x1)) {
            // skip padding bytes
            xi0 = (xi0 >> 24) | (xi1 << (32 - 24));

            slot.slot.xi[0] = xi1;
            slot.slot.xi[1] = xi2;
            slot.slot.xi[2] = xi3;
            slot.slot.xi[3] = xi4;
            slot.slot.xi[4] = xi5;
        } else {
            slot.slot.xi[0] = ((xi1 << 24) | (xi0 >> 8));
            if (round <= 7) slot.slot.xi[1] = ((xi2 << 24) | (xi1 >> 8));
            if (round <= 6) slot.slot.xi[2] = ((xi3 << 24) | (xi2 >> 8));
            if (round <= 5) slot.slot.xi[3] = ((xi4 << 24) | (xi3 >> 8));
            if (round <= 3) slot.slot.xi[4] = ((xi5 << 24) | (xi4 >> 8));
            if (round <= 1) slot.slot.xi[5] = ((xi5 >> 8));
        }
        slot.slot.xi[UINTS_IN_XI(round)] = ENCODE_INPUTS(round - 1, row, slot_a, slot_b);
        new_row = get_row(round, xi0);  

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if ((xi0 || xi1) && !write_thread_index) {
#ifdef AMD_GCN_ASM
            new_slot_indexes[write_index] = inc_local_row_counter(round, gds_dummy_dst, new_row);
#else
            new_slot_indexes[write_index] = inc_row_counter(round, row_counters, new_row);
#endif
        }
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    if (THREADS_PER_WRITE(round) == 2 && new_slot_indexes[write_index] < _NR_SLOTS(round)) {
        __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_indexes[write_index]) + write_thread_index;
#ifdef __GCNMINC__
        __asm("flat_store_dwordx4 %0, %1"
              :
              : "r" (p), "r" (write_thread_index ? slot.ui4[1] : slot.ui4[0]));
#else
        *p = slot.ui4[write_thread_index];
#endif
    } else if (THREADS_PER_WRITE(round) == 4 && new_slot_indexes[write_index] < _NR_SLOTS(round)) {
        __global uint2 *p = (__global uint2 *)get_slot_ptr(ht_dst, round, new_row, new_slot_indexes[write_index]) + write_thread_index;
        *p = slot.ui2[write_thread_index];
    }
    //barrier(CLK_LOCAL_MEM_FENCE);
    return ret;
}

#ifdef __GCNMINC__

uint parallel_xor_and_store_gcnminc(
    uint device_thread,
    uint round, 
    __global char *ht_src, 
    __global char *ht_dst,
    uint row,
    uint slot_a,
    uint slot_b,
    __local uint *ai,
    __local uint *bi,
    __global uint *row_counters,
    __local SLOT_INDEX_TYPE *new_slot_indexes,
    __local uint *gds_dummy_base)
{
#ifdef AMD_GCN_ASM
    gds_dummy_base = 0;
    __local volatile uint *gds_dummy_src = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 1) % 2));
    __local volatile uint *gds_dummy_dst = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 0) % 2));
#endif

    uint ret = 0;
    uint xi0, xi1, xi2, xi3, xi4, xi5;
    uint write_index = get_local_id(0) / THREADS_PER_WRITE(round);
    uint write_thread_index = get_local_id(0) % THREADS_PER_WRITE(round);

    slot_t slot;
    uint new_row;

    if (!write_thread_index)
        new_slot_indexes[write_index] = _NR_SLOTS(round);
    //barrier(CLK_LOCAL_MEM_FENCE);

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 4) xi4 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 2) xi5 = *(ai += _NR_SLOTS(round - 1));

        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 4) xi4 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 2) xi5 ^= *(bi += _NR_SLOTS(round - 1));

        if (!(round & 0x1)) {
            // skip padding bytes
            xi0 = (xi0 >> 24) | (xi1 << (32 - 24));

            slot.slot.xi[0] = xi1;
            slot.slot.xi[1] = xi2;
            slot.slot.xi[2] = xi3;
            slot.slot.xi[3] = xi4;
            slot.slot.xi[4] = xi5;
        } else {
            slot.slot.xi[0] = ((xi1 << 24) | (xi0 >> 8));
            if (round <= 7) slot.slot.xi[1] = ((xi2 << 24) | (xi1 >> 8));
            if (round <= 6) slot.slot.xi[2] = ((xi3 << 24) | (xi2 >> 8));
            if (round <= 5) slot.slot.xi[3] = ((xi4 << 24) | (xi3 >> 8));
            if (round <= 3) slot.slot.xi[4] = ((xi5 << 24) | (xi4 >> 8));
            if (round <= 1) slot.slot.xi[5] = ((xi5 >> 8));
        }
        slot.slot.xi[UINTS_IN_XI(round)] = ENCODE_INPUTS(round - 1, row, slot_a, slot_b);
        new_row = get_row(round, xi0);

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if ((xi0 || xi1) && !write_thread_index) {
#ifdef AMD_GCN_ASM
 
            new_slot_indexes[write_index] = inc_local_row_counter(round, gds_dummy_dst, new_row);
#else
            new_slot_indexes[write_index] = inc_row_counter(round, row_counters, new_row);
#endif
        }
    }

    barrier(CLK_LOCAL_MEM_FENCE);
    if (THREADS_PER_WRITE(round) == 2 && new_slot_indexes[write_index] < _NR_SLOTS(round)) {
        __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_indexes[write_index]) + write_thread_index;
#ifdef __GCNMINC__
        __asm("flat_store_dwordx4 %0, %1"
              :
              : "r" (p), "r" (write_thread_index ? slot.ui4[1] : slot.ui4[0]));
#else
        *(p + write_thread_index) = slot.ui4[write_thread_index];
#endif
    } else if (THREADS_PER_WRITE(round) == 4 && new_slot_indexes[write_index] < _NR_SLOTS(round)) {
        __global slot_t *p = (__global slot_t *)get_slot_ptr(ht_dst, round, new_row, new_slot_indexes[write_index]);
        *(((__global uint2 *)p) + write_thread_index) = slot.ui2[write_thread_index];
    }
    //barrier(CLK_LOCAL_MEM_FENCE);
    return ret;
}

#endif

/*
** Execute one Equihash round. Read from ht_src, XOR colliding pairs of Xi,
** store them in ht_dst. Each work group processes only one row at a time.
*/

void equihash_round(
    uint device_thread,
    uint round,
    __global char *ht_src,
    __global char *ht_dst,
    __global uint *debug,
    __local uint  *slot_cache,
    __local SLOT_INDEX_TYPE *collision_array_a,
    __local SLOT_INDEX_TYPE *collision_array_b,
    __local uint *nr_collisions,
    __global uint *rowCountersSrc,
    __global uint *rowCountersDst,
    __local uint *bin_first_slots,
    __local SLOT_INDEX_TYPE *bin_next_slots,
    __local SLOT_INDEX_TYPE *new_slot_indexes,
    __local uint *gds_dummy_base)
{
#ifdef AMD_GCN_ASM
    __local volatile uint *gds_dummy_src = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 1) % 2));
    __local volatile uint *gds_dummy_dst = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2 + ((round + 0) % 2));
#endif
    uint     i, j;

    // the mask is also computed to read data from the previous round
#define BIN_MASK(round)        ((((round) + 1) % 2) ? 0xf000 : 0xf0000)
#define BIN_MASK_OFFSET(round) ((((round) + 1) % 2) ? 3 * 4 : 4 * 4)

#define BIN_MASK2(round) ((_NR_ROWS_LOG(round) == 12) ? ((((round) + 1) % 2) ? 0x00f0 : 0xf000) : \
                                                        ((((round) + 1) % 2) ? 0x00e0 : 0xe000))
#define BIN_MASK2_OFFSET(round) ((_NR_ROWS_LOG(round) == 12) ? ((((round) + 1) % 2) ? 0 : 8) : \
                                                               ((((round) + 1) % 2) ? 1 : 9))

#define _NR_BINS_LOG(round) (PREFIX(PARAM_N, PARAM_K) - _NR_ROWS_LOG(round))
#define _NR_BINS(round) (1 << _NR_BINS_LOG(round))



    uint nr_slots = 0;
    uint assigned_row_index = get_group_id(0);
    if (assigned_row_index >= _NR_ROWS(round - 1))
        return;

#ifdef __GCNMINC__
    uint thread_index = 0;
    if (get_local_id(0) % 64 == 0)
        nr_slots = get_nr_slots(round - 1, rowCountersSrc, assigned_row_index);
    //barrier(CLK_LOCAL_MEM_FENCE);
    __asm("ds_bpermute_b32 %0, %1, %2\r\n"
          //"s_waitcnt lgkmcnt(0)"
          : "=v" (nr_slots) : "v" (thread_index), "0" (nr_slots));
#elif defined(AMD_GCN_ASM)
    if (get_local_id(0) == 0)
        *nr_collisions = nr_slots = get_nr_slots_local(round - 1, gds_dummy_src, assigned_row_index);
    barrier(CLK_LOCAL_MEM_FENCE);
    if (get_local_id(0))
        nr_slots = nr_collisions[0];
    barrier(CLK_LOCAL_MEM_FENCE);
#else
    if (get_local_id(0) == 0)
        nr_collisions[0] = nr_slots = get_nr_slots(round - 1, rowCountersSrc, assigned_row_index);
    barrier(CLK_LOCAL_MEM_FENCE);
    if (get_local_id(0))
        nr_slots = nr_collisions[0];
    barrier(CLK_LOCAL_MEM_FENCE);
#endif

    for (i = get_local_id(0); i < _NR_BINS(round - 1); i += get_local_size(0))
        bin_first_slots[i] = _NR_SLOTS(round - 1);
    for (i = get_local_id(0); i < _NR_SLOTS(round - 1); i += get_local_size(0))
        bin_next_slots[i] = _NR_SLOTS(round - 1);

    if (!get_local_id(0))
        *nr_collisions = 0;

    barrier(CLK_LOCAL_MEM_FENCE);

    // Perform a radix sort as slots get loaded into LDS.
    // Make sure all the work items in the work group enter the loop.
    for (i = get_local_id(0); i < nr_slots; i += get_local_size(0)) {
        uint slot_index = i;
        uint slot_cache_index = i;
#ifdef OPTIM_8BYTE_READS
        uint2 slot_data0, slot_data1, slot_data2;
        if (UINTS_IN_XI(round - 1) >= 1) slot_data0 = *((__global uint2 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 0);
        if (UINTS_IN_XI(round - 1) >= 3) slot_data1 = *((__global uint2 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 1);
        if (UINTS_IN_XI(round - 1) >= 5) slot_data2 = *((__global uint2 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 2);

        if (UINTS_IN_XI(round - 1) >= 1) slot_cache[0 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s0;
        if (UINTS_IN_XI(round - 1) >= 2) slot_cache[1 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s1;
        if (UINTS_IN_XI(round - 1) >= 3) slot_cache[2 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data1.s0;
        if (UINTS_IN_XI(round - 1) >= 4) slot_cache[3 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data1.s1;
        if (UINTS_IN_XI(round - 1) >= 5) slot_cache[4 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data2.s0;
        if (UINTS_IN_XI(round - 1) >= 6) slot_cache[5 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data2.s1;
        uint xi0 = slot_data0.s0;
#elif defined(OPTIM_16BYTE_READS)
        uint xi0;
        if (UINTS_IN_XI(round - 1) >= 5) {
            uint8 slot_data0;
            slot_data0 = *((__global uint8 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 0);

            if (UINTS_IN_XI(round - 1) >= 1) slot_cache[0 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s0;
            if (UINTS_IN_XI(round - 1) >= 2) slot_cache[1 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s1;
            if (UINTS_IN_XI(round - 1) >= 3) slot_cache[2 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s2;
            if (UINTS_IN_XI(round - 1) >= 4) slot_cache[3 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s3;
            if (UINTS_IN_XI(round - 1) >= 5) slot_cache[4 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s4;
            if (UINTS_IN_XI(round - 1) >= 6) slot_cache[5 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s5;
            xi0 = slot_data0.s0;
        } else {
            uint4 slot_data0;
            slot_data0 = *((__global uint4 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 0);
 
            if (UINTS_IN_XI(round - 1) >= 1) slot_cache[0 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s0;
            if (UINTS_IN_XI(round - 1) >= 2) slot_cache[1 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s1;
            if (UINTS_IN_XI(round - 1) >= 3) slot_cache[2 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s2;
            if (UINTS_IN_XI(round - 1) >= 4) slot_cache[3 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s3;
            xi0 = slot_data0.s0;
        }
#else
        uint xi[6];
        for (j = 0; j < UINTS_IN_XI(round - 1); ++j)
            xi[j] = *((__global uint *)get_xi_ptr(ht_src, round - 1, assigned_row_index, slot_index) + j);
        for (j = 0; j < UINTS_IN_XI(round - 1); ++j)
            slot_cache[j * _NR_SLOTS(round - 1) + slot_cache_index] = xi[j];
        uint xi0 = xi[0];
#endif

        uint slot_a_index = i;
        uint slot_b_index;
        uint bin_to_use =
            ((xi0 & BIN_MASK(round - 1)) >> BIN_MASK_OFFSET(round - 1))
            | ((xi0 & BIN_MASK2(round - 1)) >> BIN_MASK2_OFFSET(round - 1));
        bin_next_slots[i] = slot_b_index = atomic_xchg(&bin_first_slots[bin_to_use], i);

#define COLLISION_SEARCH\
        while (slot_b_index < _NR_SLOTS(round - 1)) {\
            uint coll_index = atomic_inc(nr_collisions);\
            if (coll_index >= _LDS_COLL_SIZE(round - 1))\
                break;\
            collision_array_a[coll_index] = slot_a_index;\
            collision_array_b[coll_index] = slot_b_index;\
            slot_b_index = bin_next_slots[slot_b_index];\
        }

#ifdef OPTIM_ON_THE_FLY_COLLISION_SEARCH 
        COLLISION_SEARCH
    }
#else
    }

    barrier(CLK_LOCAL_MEM_FENCE);

    for (uint slot_a_index = get_local_id(0); slot_a_index < _NR_SLOTS(round - 1); slot_a_index += get_local_size(0)) {
        uint slot_b_index = bin_next_slots[slot_a_index];
        COLLISION_SEARCH
    }
#endif

    barrier(CLK_LOCAL_MEM_FENCE);

    uint nr_collisions_copy = *nr_collisions;
    if (nr_collisions_copy >= _LDS_COLL_SIZE(round - 1))
        nr_collisions_copy = _LDS_COLL_SIZE(round - 1);
    while (nr_collisions_copy > 0) {
        uint collision, slot_index_a = _NR_SLOTS(round - 1), slot_index_b;
        __local uint *slot_cache_a, *slot_cache_b;
        uint write_index = get_local_id(0) / THREADS_PER_WRITE(round);
        if (write_index < nr_collisions_copy) {
            slot_index_a = collision_array_a[nr_collisions_copy - 1 - write_index];
            slot_index_b = collision_array_b[nr_collisions_copy - 1 - write_index];
            slot_cache_a = (__local uint *)&slot_cache[slot_index_a];
            slot_cache_b = (__local uint *)&slot_cache[slot_index_b];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
        if (THREADS_PER_WRITE(round) > 1) {
            parallel_xor_and_store(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_index_a, slot_index_b, slot_cache_a, slot_cache_b, rowCountersDst, new_slot_indexes, gds_dummy_base);
        } else {
            xor_and_store(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_index_a, slot_index_b, slot_cache_a, slot_cache_b, rowCountersDst, gds_dummy_base);
        }

        nr_collisions_copy -= min(nr_collisions_copy, (uint)get_local_size(0) / THREADS_PER_WRITE(round));
        barrier(CLK_LOCAL_MEM_FENCE);
    }
}

/*
** This defines kernel_round1, kernel_round2, ..., kernel_round8.
*/

#define KERNEL_ROUND(kernel_name, N) \
__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE, 1, 1))) \
void kernel_name(uint device_thread, __global char *ht_src, __global char *ht_dst, \
	__global uint *rowCountersSrc, __global uint *rowCountersDst, \
       	__global uint *debug) \
{ \
	__local uint  gds_dummy_base[1];\
    __local uint    slot_cache[ADJUSTED_LDS_ARRAY_SIZE(UINTS_IN_XI(N - 1) * _NR_SLOTS(N - 1))]; \
    __local SLOT_INDEX_TYPE collision_array_a[ADJUSTED_LDS_ARRAY_SIZE(_LDS_COLL_SIZE(N - 1))]; \
    __local SLOT_INDEX_TYPE collision_array_b[ADJUSTED_LDS_ARRAY_SIZE(_LDS_COLL_SIZE(N - 1))]; \
    __local uint    nr_collisions[1]; \
	__local uint    bin_first_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_BINS(N - 1))]; \
	__local SLOT_INDEX_TYPE bin_next_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS(N - 1))]; \
	__local SLOT_INDEX_TYPE new_slot_indexes[ADJUSTED_LDS_ARRAY_SIZE((THREADS_PER_WRITE(N) > 1) ? LOCAL_WORK_SIZE / THREADS_PER_WRITE(N) : 0)]; \
    equihash_round(device_thread, (N), ht_src, ht_dst, debug, slot_cache, collision_array_a, collision_array_b, \
	    nr_collisions, rowCountersSrc, rowCountersDst, bin_first_slots, bin_next_slots, new_slot_indexes, gds_dummy_base); \
}

KERNEL_ROUND(kernel_round1, 1)
KERNEL_ROUND(kernel_round2, 2)
KERNEL_ROUND(kernel_round3, 3)
KERNEL_ROUND(kernel_round4, 4)
KERNEL_ROUND(kernel_round5, 5)
KERNEL_ROUND(kernel_round6, 6)
KERNEL_ROUND(kernel_round7, 7)
KERNEL_ROUND(kernel_round8, 8)


void mark_potential_sol(__global potential_sols_t *potential_sols, uint ref0, uint ref1)
{
    uint sol_i = atomic_inc(&potential_sols->nr);
    if (sol_i >= MAX_POTENTIAL_SOLS)
        return;
    potential_sols->values[sol_i][0] = ref0;
    potential_sols->values[sol_i][1] = ref1;
}

/*
** Scan the hash tables to find Equihash solutions.
*/

__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE_POTENTIAL_SOLS, 1, 1)))
void kernel_potential_sols(
    uint device_thread,
    __global char *ht_src,
    __global potential_sols_t *potential_sols,
    __global uint *rowCountersSrc)
{
#ifdef AMD_GCN_ASM
    __local uint gds_dummy_base[1];
    __local volatile uint *gds_dummy_src = gds_dummy_base + (ROW_COUNTERS_SIZE / sizeof(uint)) * (device_thread * 2);
#endif
    __local uint refs[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS((PARAM_K - 1)))];
    __local uint data[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS((PARAM_K - 1)))];

    uint		nr_slots;
    uint		i, j;
    __global char	*p;
    uint		ref_i, ref_j;
    __local uint    bin_first_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_BINS((PARAM_K - 1)))];
    __local SLOT_INDEX_TYPE    bin_next_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS((PARAM_K - 1)))];

    uint assigned_row_index = get_group_id(0);
    if (assigned_row_index >= _NR_ROWS((PARAM_K - 1)))
        return;
    
    for (i = get_local_id(0); i < _NR_BINS((PARAM_K - 1)); i += get_local_size(0))
        bin_first_slots[i] = _NR_SLOTS((PARAM_K - 1));
    for (i = get_local_id(0); i < _NR_SLOTS((PARAM_K - 1)); i += get_local_size(0))
        bin_next_slots[i] = _NR_SLOTS((PARAM_K - 1));

    __local uint nr_slots_shared;
#ifdef __GCNMINC__
    uint thread_index = 0;
    if (get_local_id(0) % 64 == 0)
        nr_slots = get_nr_slots(PARAM_K - 1, rowCountersSrc, assigned_row_index);
    //barrier(CLK_LOCAL_MEM_FENCE);
    __asm("ds_bpermute_b32 %0, %1, %2\r\n"
          "s_waitcnt lgkmcnt(0)"
          : "=v" (nr_slots) : "v" (thread_index), "0" (nr_slots));
#elif defined(AMD_GCN_ASM)
    if (get_local_id(0) == 0)
        nr_slots_shared = nr_slots = get_nr_slots_local((PARAM_K - 1), gds_dummy_src, assigned_row_index);
    barrier(CLK_LOCAL_MEM_FENCE);
    if (get_local_id(0))
        nr_slots = nr_slots_shared;
#else
    if (get_local_id(0) == 0)
        nr_slots_shared = nr_slots = get_nr_slots((PARAM_K - 1), rowCountersSrc, assigned_row_index);
    barrier(CLK_LOCAL_MEM_FENCE);
    if (get_local_id(0))
        nr_slots = nr_slots_shared;
#endif

    barrier(CLK_LOCAL_MEM_FENCE);

    // in the final hash table, we are looking for a match on both the bits
    // part of the previous PREFIX colliding bits, and the last PREFIX bits.
    for (uint i = get_local_id(0); i < nr_slots; i += get_local_size(0)) {
        __global uint *p = (__global uint *)get_slot_ptr(ht_src, PARAM_K - 1, assigned_row_index, i);
        uint data_i = data[i] = *p++;
        uint ref_i  = refs[i] = *p;
        uint bin_to_use =
                ((data_i & BIN_MASK(PARAM_K - 1)) >> BIN_MASK_OFFSET(PARAM_K - 1))
            | ((data_i & BIN_MASK2(PARAM_K - 1)) >> BIN_MASK2_OFFSET(PARAM_K - 1));
        j = bin_next_slots[i] = atomic_xchg(&bin_first_slots[bin_to_use], i);
        
        while (j < nr_slots) {
            if (data_i == data[j])
                mark_potential_sol(potential_sols, refs[i], refs[j]);
            j = bin_next_slots[j];
        }
    }
}



__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE_SOLS, 1, 1)))
void kernel_sols(__global char *ht0,
    __global char *ht1,
    __global sols_t *sols,
    __global uint *rowCountersSrc,
    __global uint *rowCountersDst,
    __global char *ht2,
    __global char *ht3,
    __global char *ht4,
    __global char *ht5,
    __global char *ht6,
    __global char *ht7,
    __global char *ht8,
    __global potential_sols_t *potential_sols)
{
    __local uint	inputs_a[ADJUSTED_LDS_ARRAY_SIZE(1 << PARAM_K)], inputs_b[ADJUSTED_LDS_ARRAY_SIZE(1 << (PARAM_K - 1))];
    __global char	*htabs[] = { ht0, ht1, ht2, ht3, ht4, ht5, ht6, ht7, ht8 };

    if (get_group_id(0) < potential_sols->nr && get_group_id(0) < MAX_POTENTIAL_SOLS) {
        __local uint dup_counter;
        if (get_local_id(0) == 0) {
            dup_counter = 0;
            inputs_a[0] = potential_sols->values[get_group_id(0)][0];
            inputs_a[1] = potential_sols->values[get_group_id(0)][1];
        }
        barrier(CLK_LOCAL_MEM_FENCE);

        for (int round = 7; round >= 0; --round) {
            if (round % 2) {
                for (uint i = get_local_id(0); i < (1 << ((PARAM_K - 1) - round)); i += get_local_size(0)) {
                    inputs_b[i * 2 + 1] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_a[i]), DECODE_SLOT1(round, inputs_a[i]));
                    inputs_b[i * 2] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_a[i]), DECODE_SLOT0(round, inputs_a[i]));
                }
            } else {
                for (uint i = get_local_id(0); i < (1 << ((PARAM_K - 1) - round)); i += get_local_size(0)) {
                    inputs_a[i * 2 + 1] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_b[i]), DECODE_SLOT1(round, inputs_b[i]));
                    inputs_a[i * 2] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_b[i]), DECODE_SLOT0(round, inputs_b[i]));
                }
            }
            barrier(CLK_LOCAL_MEM_FENCE);
        }
        //barrier(CLK_LOCAL_MEM_FENCE);

        int	dup_to_watch = inputs_a[(1 << PARAM_K) - 1];
        uint j = 3 + get_local_id(0);
        if (inputs_a[j] == dup_to_watch)
            atomic_inc(&dup_counter);
        j += get_local_size(0);
        if (j < (1 << PARAM_K) - 2 && inputs_a[j] == dup_to_watch)
            atomic_inc(&dup_counter);
        barrier(CLK_LOCAL_MEM_FENCE);
        
        // solution appears valid, copy it to sols
        if (!dup_counter) {
            __local uint sol_i;
            if (!get_local_id(0))
                 sol_i = atomic_inc(&sols->nr);
            barrier(CLK_LOCAL_MEM_FENCE);
            if (sol_i < MAX_SOLS) {
                if (!get_local_id(0))
                    sols->valid[sol_i] = 1;
                sols->values[sol_i][get_local_id(0)] = inputs_a[get_local_id(0)];
                sols->values[sol_i][get_local_id(0) + get_local_size(0)] = inputs_a[get_local_id(0) + get_local_size(0)];
            }
        }
    }
}
