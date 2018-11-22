/*
 * Allium kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 * Copyright (c) 2018 lenis0012
 * Copyright (c) 2018 fancyIX
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ===========================(LICENSE END)=============================
 *
 * @author   lenis0012 2018
 * @author   fancyIX 2018
 */

//#pragma OPENCL EXTENSION cl_amd_printf : enable

#ifndef ALLIUM_CL
#define ALLIUM_CL

#if __ENDIAN_LITTLE__
#define SPH_LITTLE_ENDIAN 1
#else
#define SPH_BIG_ENDIAN 1
#endif

#define SPH_UPTR sph_u64

typedef unsigned int sph_u32;
typedef int sph_s32;
#ifndef __OPENCL_VERSION__
typedef unsigned long long sph_u64;
typedef long long sph_s64;
#else
typedef unsigned long sph_u64;
typedef long sph_s64;
#endif

#define SPH_64 1
#define SPH_64_TRUE 1

#define SPH_C32(x)    ((sph_u32)(x ## U))
#define SPH_T32(x)    ((x) & SPH_C32(0xFFFFFFFF))

#define SPH_C64(x)    ((sph_u64)(x ## UL))
#define SPH_T64(x)    ((x) & SPH_C64(0xFFFFFFFFFFFFFFFF))

//#define SPH_ROTL32(x, n)   (((x) << (n)) | ((x) >> (32 - (n))))
//#define SPH_ROTR32(x, n)   (((x) >> (n)) | ((x) << (32 - (n))))
//#define SPH_ROTL64(x, n)   (((x) << (n)) | ((x) >> (64 - (n))))
//#define SPH_ROTR64(x, n)   (((x) >> (n)) | ((x) << (64 - (n))))

#define SPH_ROTL32(x,n) rotate(x,(uint)n)     //faster with driver 14.6
#define SPH_ROTR32(x,n) rotate(x,(uint)(32-n))
#define SPH_ROTL64(x,n) rotate(x,(ulong)n)
#define SPH_ROTR64(x,n) rotate(x,(ulong)(64-n))
static inline sph_u64 ror64(sph_u64 vw, unsigned a) {
	uint2 result;
	uint2 v = as_uint2(vw);
	unsigned n = (unsigned)(64 - a);
	if (n == 32) { return as_ulong((uint2)(v.y, v.x)); }
	if (n < 32) {
		result.y = ((v.y << (n)) | (v.x >> (32 - n)));
		result.x = ((v.x << (n)) | (v.y >> (32 - n)));
	}
	else {
		result.y = ((v.x << (n - 32)) | (v.y >> (64 - n)));
		result.x = ((v.y << (n - 32)) | (v.x >> (64 - n)));
	}
	return as_ulong(result);
}

#include "blake256.cl"
#include "groestl256.cl"
#include "cubehash.cl"
#include "keccak1600.cl"
#include "skein256.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
#define SWAP32(x) as_ulong(as_uint2(x).s10)

#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC64LE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC32LE(x) (*(const __global sph_u32 *) (x));
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC64LE(x) (*(const __global sph_u64 *) (x));
  #define DEC32LE(x) SWAP4(*(const __global sph_u32 *) (x));
#endif

#include "lyra2mdz.cl"

typedef union {
    uint h4[8];
    ulong h8[4];
    uint4 h16[2];
    ulong2 hl16[2];
    ulong4 h32;
} hash2_t;

typedef union {
    uint h4[32];
    ulong h8[16];
    uint4 h16[8];
    ulong2 hl16[8];
    ulong4 h32[4];
} lyraState_t;

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(
	 __global hash2_t* hashes,
	// precalc hash from fisrt part of message
	const uint h0,
	const uint h1,
	const uint h2,
	const uint h3,
	const uint h4,
	const uint h5,
	const uint h6,
	const uint h7,
	// last 12 bytes of original message
	const uint in16,
	const uint in17,
	const uint in18
)

{
 uint gid = get_global_id(0);
  __global hash2_t *hash = &(hashes[gid-get_global_offset(0)]);

    sph_u32 h[8];
    sph_u32 m[16];
    sph_u32 v[16];

h[0]=h0;
h[1]=h1;
h[2]=h2;
h[3]=h3;
h[4]=h4;
h[5]=h5;
h[6]=h6;
h[7]=h7;
// compress 2nd round
 m[0] = in16;
 m[1] = in17;
 m[2] = in18;
 m[3] = SWAP4(gid);

	for (int i = 4; i < 16; i++) {m[i] = c_Padding[i];}

	for (int i = 0; i < 8; i++) {v[i] = h[i];}

	v[8] =  c_u256[0];
	v[9] =  c_u256[1];
	v[10] = c_u256[2];
	v[11] = c_u256[3];
	v[12] = c_u256[4] ^ 640;
	v[13] = c_u256[5] ^ 640;
	v[14] = c_u256[6];
	v[15] = c_u256[7];

	for (int r = 0; r < 14; r++) {
		GS(0, 4, 0x8, 0xC, 0x0);
		GS(1, 5, 0x9, 0xD, 0x2);
		GS(2, 6, 0xA, 0xE, 0x4);
		GS(3, 7, 0xB, 0xF, 0x6);
		GS(0, 5, 0xA, 0xF, 0x8);
		GS(1, 6, 0xB, 0xC, 0xA);
		GS(2, 7, 0x8, 0xD, 0xC);
		GS(3, 4, 0x9, 0xE, 0xE);
	}

	for (int i = 0; i < 16; i++) {
		int j = i & 7;
		h[j] ^= v[i];}

for (int i = 0; i < 8; i++) {hash->h4[i]=SWAP4(h[i]);}

barrier(CLK_LOCAL_MEM_FENCE);

}

// keccak256

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash2_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash2_t *hash = &(hashes[gid-get_global_offset(0)]);

 		sph_u64 keccak_gpu_state[25];

		for (int i = 0; i < 25; i++) {
			if (i < 4) { keccak_gpu_state[i] = hash->h8[i];
      } else {
      keccak_gpu_state[i] = 0;
      }
		}
		keccak_gpu_state[4] = 0x0000000000000001;
		keccak_gpu_state[16] = 0x8000000000000000;

		keccak_block(keccak_gpu_state);
		for (int i = 0; i < 4; i++) {hash->h8[i] = keccak_gpu_state[i];}
barrier(CLK_LOCAL_MEM_FENCE);

}

/// lyra2 p1 

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global uint* hashes, __global uchar* sharedDataBuf)
{
    int gid = get_global_id(0);

    __global hash2_t *hash = (__global hash2_t *)(hashes + (8* (gid-get_global_offset(0))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4  * 4) * (gid-get_global_offset(0))));

    ulong ttr;

    ulong2 state[8];
    // state0
    state[0] = hash->hl16[0];
    state[1] = hash->hl16[1];
    // state1
    state[2] = state[0];
    state[3] = state[1];
    // state2
    state[4] = (ulong2)(0x6a09e667f3bcc908UL, 0xbb67ae8584caa73bUL);
    state[5] = (ulong2)(0x3c6ef372fe94f82bUL, 0xa54ff53a5f1d36f1UL);
    // state3 (low,high,..
    state[6] = (ulong2)(0x510e527fade682d1UL, 0x9b05688c2b3e6c1fUL);
    state[7] = (ulong2)(0x1f83d9abfb41bd6bUL, 0x5be0cd19137e2179UL);

    // Absorbing salt, password and basil: this is the only place in which the block length is hard-coded to 512 bits
    for (int i = 0; i < 24; ++i)
    {
        roundLyra(state);
    }

    // state0
    lyraState->hl16[0] = state[0];
    lyraState->hl16[1] = state[1];
    // state1
    lyraState->hl16[2] = state[2];
    lyraState->hl16[3] = state[3];
    // state2
    lyraState->hl16[4] = state[4];
    lyraState->hl16[5] = state[5];
    // state3
    lyraState->hl16[6] = state[6];
    lyraState->hl16[7] = state[7];

    barrier(CLK_GLOBAL_MEM_FENCE);
}

/// lyra2 algo p2 


__attribute__((reqd_work_group_size(4, 5, 1)))
__kernel void search3(__global uchar* sharedDataBuf)
{
  uint gid = get_global_id(1);
  __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4  * 4) * (gid-get_global_offset(1))));

  __local ulong roundPad[12 * 5];
  __local ulong *xchange = roundPad + get_local_id(1) * 4;

  //__global ulong *notepad = buffer + get_local_id(0) + 4 * SLOT;
  __local ulong notepadLDS[192 * 4 * 5];
  __local ulong *notepad = notepadLDS + LOCAL_LINEAR;
  const int player = get_local_id(0);

  ulong state[4];

  //-------------------------------------
  // Load Lyra state
  state[0] = (ulong)(lyraState->h8[player]);
  state[1] = (ulong)(lyraState->h8[player+4]);
  state[2] = (ulong)(lyraState->h8[player+8]);
  state[3] = (ulong)(lyraState->h8[player+12]);
  
  __local ulong *dst = notepad + HYPERMATRIX_COUNT;
  for (int loop = 0; loop < LYRA_ROUNDS; loop++) { // write columns and rows 'in order'
    dst -= STATE_BLOCK_COUNT; // but blocks backwards
    for(int cp = 0; cp < 3; cp++) dst[cp * REG_ROW_COUNT] = state[cp];
    round_lyra_4way(state, xchange);
  }
  make_hyper_one(state, xchange, notepad);
  make_next_hyper(1, 0, 2, state, roundPad, notepad);
  make_next_hyper(2, 1, 3, state, roundPad, notepad);
  make_next_hyper(3, 0, 4, state, roundPad, notepad);
  make_next_hyper(4, 3, 5, state, roundPad, notepad);
  make_next_hyper(5, 2, 6, state, roundPad, notepad);
  make_next_hyper(6, 1, 7, state, roundPad, notepad);

  uint modify;
  uint row = 0;
  uint pre = 7;

  __local uint *shorter = (__local uint*)roundPad;
  for (int i = 0; i < LYRA_ROUNDS; i++) {
    if(get_local_id(0) == 0) {
      shorter[get_local_id(1)] = (uint)(state[0] % 8);
    }
    barrier(CLK_LOCAL_MEM_FENCE); // nop
    modify = shorter[get_local_id(1)];
    hyper_xor(pre, modify, row, state, roundPad, notepad);
    pre = row;
    row = (row + 3) % 8;
  }
  
  notepad += HYPERMATRIX_COUNT * modify;
  for(int loop = 0; loop < 3; loop++) state[loop] ^= notepad[loop * REG_ROW_COUNT];

  //-------------------------------------
  // save lyra state    
  lyraState->h8[player] = state[0];
  lyraState->h8[player+4] = state[1];
  lyraState->h8[player+8] = state[2];
  lyraState->h8[player+12] = state[3];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// lyra2 p3

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global uint* hashes, __global uchar* sharedDataBuf)
{
    int gid = get_global_id(0);

    __global hash2_t *hash = (__global hash2_t *)(hashes + (8* (gid-get_global_offset(0))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4  * 4) * (gid-get_global_offset(0))));

    ulong ttr;

    ulong2 state[8];
    // 1. load lyra State
    state[0] = lyraState->hl16[0];
    state[1] = lyraState->hl16[1];
    state[2] = lyraState->hl16[2];
    state[3] = lyraState->hl16[3];
    state[4] = lyraState->hl16[4];
    state[5] = lyraState->hl16[5];
    state[6] = lyraState->hl16[6];
    state[7] = lyraState->hl16[7];

    // 2. rounds
    for (int i = 0; i < 12; ++i)
    {
        roundLyra(state);
    }

    // 3. store result
    hash->hl16[0] = state[0];
    hash->hl16[1] = state[1];
    
    barrier(CLK_GLOBAL_MEM_FENCE);
}

// cubehash256

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global hash2_t* hashes)
{
	uint gid = get_global_id(0);
    __global hash2_t *hash = &(hashes[gid-get_global_offset(0)]);

	sph_u32 x0 = 0xEA2BD4B4; sph_u32 x1 = 0xCCD6F29F; sph_u32 x2 = 0x63117E71;
	sph_u32 x3 = 0x35481EAE; sph_u32 x4 = 0x22512D5B; sph_u32 x5 = 0xE5D94E63;
	sph_u32 x6 = 0x7E624131; sph_u32 x7 = 0xF4CC12BE; sph_u32 x8 = 0xC2D0B696;
	sph_u32 x9 = 0x42AF2070; sph_u32 xa = 0xD0720C35; sph_u32 xb = 0x3361DA8C;
	sph_u32 xc = 0x28CCECA4; sph_u32 xd = 0x8EF8AD83; sph_u32 xe = 0x4680AC00;
	sph_u32 xf = 0x40E5FBAB;

	sph_u32 xg = 0xD89041C3; sph_u32 xh = 0x6107FBD5;
	sph_u32 xi = 0x6C859D41; sph_u32 xj = 0xF0B26679; sph_u32 xk = 0x09392549;
	sph_u32 xl = 0x5FA25603; sph_u32 xm = 0x65C892FD; sph_u32 xn = 0x93CB6285;
	sph_u32 xo = 0x2AF2B5AE; sph_u32 xp = 0x9E4B4E60; sph_u32 xq = 0x774ABFDD;
	sph_u32 xr = 0x85254725; sph_u32 xs = 0x15815AEB; sph_u32 xt = 0x4AB6AAD6;
	sph_u32 xu = 0x9CDAF8AF; sph_u32 xv = 0xD6032C0A;

	x0 ^= (hash->h4[0]);
	x1 ^= (hash->h4[1]);
	x2 ^= (hash->h4[2]);
	x3 ^= (hash->h4[3]);
	x4 ^= (hash->h4[4]);
	x5 ^= (hash->h4[5]);
	x6 ^= (hash->h4[6]);
	x7 ^= (hash->h4[7]);


	SIXTEEN_ROUNDS;
	x0 ^= 0x80;
	SIXTEEN_ROUNDS;
	xv ^= 0x01;
	for (int i = 0; i < 10; ++i) SIXTEEN_ROUNDS;

	hash->h4[0] = x0;
	hash->h4[1] = x1;
	hash->h4[2] = x2;
	hash->h4[3] = x3;
	hash->h4[4] = x4;
	hash->h4[5] = x5;
	hash->h4[6] = x6;
	hash->h4[7] = x7;


	barrier(CLK_GLOBAL_MEM_FENCE);

}

/// lyra2 p1 

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search6(__global uint* hashes, __global uchar* sharedDataBuf)
{
    int gid = get_global_id(0);

    __global hash2_t *hash = (__global hash2_t *)(hashes + (8* (gid-get_global_offset(0))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4  * 4) * (gid-get_global_offset(0))));

    ulong ttr;

    ulong2 state[8];
    // state0
    state[0] = hash->hl16[0];
    state[1] = hash->hl16[1];
    // state1
    state[2] = state[0];
    state[3] = state[1];
    // state2
    state[4] = (ulong2)(0x6a09e667f3bcc908UL, 0xbb67ae8584caa73bUL);
    state[5] = (ulong2)(0x3c6ef372fe94f82bUL, 0xa54ff53a5f1d36f1UL);
    // state3 (low,high,..
    state[6] = (ulong2)(0x510e527fade682d1UL, 0x9b05688c2b3e6c1fUL);
    state[7] = (ulong2)(0x1f83d9abfb41bd6bUL, 0x5be0cd19137e2179UL);

    // Absorbing salt, password and basil: this is the only place in which the block length is hard-coded to 512 bits
    for (int i = 0; i < 24; ++i)
    {
        roundLyra(state);
    }

    // state0
    lyraState->hl16[0] = state[0];
    lyraState->hl16[1] = state[1];
    // state1
    lyraState->hl16[2] = state[2];
    lyraState->hl16[3] = state[3];
    // state2
    lyraState->hl16[4] = state[4];
    lyraState->hl16[5] = state[5];
    // state3
    lyraState->hl16[6] = state[6];
    lyraState->hl16[7] = state[7];

    barrier(CLK_GLOBAL_MEM_FENCE);
}

/// lyra2 algo p2 


__attribute__((reqd_work_group_size(4, 5, 1)))
__kernel void search7(__global uchar* sharedDataBuf)
{
  uint gid = get_global_id(1);
  __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4  * 4) * (gid-get_global_offset(1))));

  __local ulong roundPad[12 * 5];
  __local ulong *xchange = roundPad + get_local_id(1) * 4;

  //__global ulong *notepad = buffer + get_local_id(0) + 4 * SLOT;
  __local ulong notepadLDS[192 * 4 * 5];
  __local ulong *notepad = notepadLDS + LOCAL_LINEAR;
  const int player = get_local_id(0);

  ulong state[4];

  //-------------------------------------
  // Load Lyra state
  state[0] = (ulong)(lyraState->h8[player]);
  state[1] = (ulong)(lyraState->h8[player+4]);
  state[2] = (ulong)(lyraState->h8[player+8]);
  state[3] = (ulong)(lyraState->h8[player+12]);
  
  __local ulong *dst = notepad + HYPERMATRIX_COUNT;
  for (int loop = 0; loop < LYRA_ROUNDS; loop++) { // write columns and rows 'in order'
    dst -= STATE_BLOCK_COUNT; // but blocks backwards
    for(int cp = 0; cp < 3; cp++) dst[cp * REG_ROW_COUNT] = state[cp];
    round_lyra_4way(state, xchange);
  }
  make_hyper_one(state, xchange, notepad);
  make_next_hyper(1, 0, 2, state, roundPad, notepad);
  make_next_hyper(2, 1, 3, state, roundPad, notepad);
  make_next_hyper(3, 0, 4, state, roundPad, notepad);
  make_next_hyper(4, 3, 5, state, roundPad, notepad);
  make_next_hyper(5, 2, 6, state, roundPad, notepad);
  make_next_hyper(6, 1, 7, state, roundPad, notepad);

  uint modify;
  uint row = 0;
  uint pre = 7;

  __local uint *shorter = (__local uint*)roundPad;
  for (int i = 0; i < LYRA_ROUNDS; i++) {
    if(get_local_id(0) == 0) {
      shorter[get_local_id(1)] = (uint)(state[0] % 8);
    }
    barrier(CLK_LOCAL_MEM_FENCE); // nop
    modify = shorter[get_local_id(1)];
    hyper_xor(pre, modify, row, state, roundPad, notepad);
    pre = row;
    row = (row + 3) % 8;
  }
  
  notepad += HYPERMATRIX_COUNT * modify;
  for(int loop = 0; loop < 3; loop++) state[loop] ^= notepad[loop * REG_ROW_COUNT];

  //-------------------------------------
  // save lyra state    
  lyraState->h8[player] = state[0];
  lyraState->h8[player+4] = state[1];
  lyraState->h8[player+8] = state[2];
  lyraState->h8[player+12] = state[3];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// lyra2 p3

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search8(__global uint* hashes, __global uchar* sharedDataBuf)
{
    int gid = get_global_id(0);

    __global hash2_t *hash = (__global hash2_t *)(hashes + (8* (gid-get_global_offset(0))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4  * 4) * (gid-get_global_offset(0))));

    ulong ttr;

    ulong2 state[8];
    // 1. load lyra State
    state[0] = lyraState->hl16[0];
    state[1] = lyraState->hl16[1];
    state[2] = lyraState->hl16[2];
    state[3] = lyraState->hl16[3];
    state[4] = lyraState->hl16[4];
    state[5] = lyraState->hl16[5];
    state[6] = lyraState->hl16[6];
    state[7] = lyraState->hl16[7];

    // 2. rounds
    for (int i = 0; i < 12; ++i)
    {
        roundLyra(state);
    }

    // 3. store result
    hash->hl16[0] = state[0];
    hash->hl16[1] = state[1];
    
    barrier(CLK_GLOBAL_MEM_FENCE);
}

//skein256

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search9(__global hash2_t* hashes)
{
 uint gid = get_global_id(0);
  __global hash2_t *hash = &(hashes[gid-get_global_offset(0)]);

		sph_u64 h[9];
		sph_u64 t[3];
        sph_u64 dt0, dt1, dt2, dt3;
		sph_u64 p0, p1, p2, p3, p4, p5, p6, p7;
        h[8] = skein_ks_parity;

		for (int i = 0; i < 8; i++) {
			h[i] = SKEIN_IV512_256[i];
			h[8] ^= h[i];}

			t[0] = t12[0];
			t[1] = t12[1];
			t[2] = t12[2];

        dt0 = hash->h8[0];
        dt1 = hash->h8[1];
        dt2 = hash->h8[2];
        dt3 = hash->h8[3];

		p0 = h[0] + dt0;
		p1 = h[1] + dt1;
		p2 = h[2] + dt2;
		p3 = h[3] + dt3;
		p4 = h[4];
		p5 = h[5] + t[0];
		p6 = h[6] + t[1];
		p7 = h[7];

        #pragma unroll
		for (int i = 1; i < 19; i+=2) {Round_8_512(p0, p1, p2, p3, p4, p5, p6, p7, i);}
        p0 ^= dt0;
        p1 ^= dt1;
        p2 ^= dt2;
        p3 ^= dt3;

		h[0] = p0;
		h[1] = p1;
		h[2] = p2;
		h[3] = p3;
		h[4] = p4;
		h[5] = p5;
		h[6] = p6;
		h[7] = p7;
		h[8] = skein_ks_parity;

		for (int i = 0; i < 8; i++) {h[8] ^= h[i];}

		t[0] = t12[3];
		t[1] = t12[4];
		t[2] = t12[5];
		p5 += t[0];  //p5 already equal h[5]
		p6 += t[1];

        #pragma unroll
		for (int i = 1; i < 19; i+=2) {Round_8_512(p0, p1, p2, p3, p4, p5, p6, p7, i);}

		hash->h8[0]      = p0;
		hash->h8[1]      = p1;
		hash->h8[2]      = p2;
		hash->h8[3]      = p3;
	barrier(CLK_LOCAL_MEM_FENCE);

}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search10(__global hash2_t* hashes, __global uint* output, const ulong target)
{
// __local ulong T0[256], T1[256], T2[256], T3[256], T4[256], T5[256], T6[256], T7[256];
   // uint u   = get_local_id(0);
/*
for (uint u = get_local_id(0); u < 256; u += get_local_size(0)) {

  T0[u] = T0_G[u];
  T1[u] = T1_G[u];
  T2[u] = T2_G[u];
  T3[u] = T3_G[u];
  T4[u] = T4_G[u];
  T5[u] = T5_G[u];
  T6[u] = T6_G[u];
  T7[u] = T7_G[u];
 }
barrier(CLK_LOCAL_MEM_FENCE);

  T1[u] = SPH_ROTL64(T0[u], 8UL);
  T2[u] = SPH_ROTL64(T0[u], 16UL);
  T3[u] = SPH_ROTL64(T0[u], 24UL);
  T4[u] = SPH_ROTL64(T0[u], 32UL);
  T5[u] = SPH_ROTL64(T0[u], 40UL);
  T6[u] = SPH_ROTL64(T0[u], 48UL);
  T7[u] = SPH_ROTL64(T0[u], 56UL);

*/
	uint gid = get_global_id(0);

	__global hash2_t *hash = &(hashes[gid - get_global_offset(0)]);

    __private ulong message[8], state[8];
	__private ulong t[8];

	for (int u = 0; u < 4; u++) {message[u] = hash->h8[u];}

	message[4] = 0x80UL;
	message[5] = 0UL;
	message[6] = 0UL;
	message[7] = 0x0100000000000000UL;

	for (int u = 0; u < 8; u++) {state[u] = message[u];}
	state[7] ^= 0x0001000000000000UL;

	for (int r = 0; r < 10; r ++) {ROUND_SMALL_P(state, r);}		

	state[7] ^= 0x0001000000000000UL;

	for (int r = 0; r < 10; r ++) {ROUND_SMALL_Q(message, r);}		

	for (int u = 0; u < 8; u++) {state[u] ^= message[u];}
	message[7] = state[7];

	for (int r = 0; r < 9; r ++) {ROUND_SMALL_P(state, r);}
    uchar8 State;
	State.s0 = as_uchar8(state[7] ^ 0x79).s0;
	State.s1 = as_uchar8(state[0] ^ 0x09).s1;
	State.s2 = as_uchar8(state[1] ^ 0x19).s2;
	State.s3 = as_uchar8(state[2] ^ 0x29).s3;
	State.s4 = as_uchar8(state[3] ^ 0x39).s4;
	State.s5 = as_uchar8(state[4] ^ 0x49).s5;
	State.s6 = as_uchar8(state[5] ^ 0x59).s6;
	State.s7 = as_uchar8(state[6] ^ 0x69).s7;

		state[7] = T0_G[State.s0]
			   ^ R64(T0_G[State.s1],  8)
         ^ R64(T0_G[State.s2], 16)
			   ^ R64(T0_G[State.s3], 24)
			   ^     T4_G[State.s4]
			   ^ R64(T4_G[State.s5],  8)
			   ^ R64(T4_G[State.s6], 16)
			   ^ R64(T4_G[State.s7], 24) ^message[7];

//	t[7] ^= message[7];
	barrier(CLK_LOCAL_MEM_FENCE);

	bool result = ( state[7] <= target);
	if (result) {
		output[atomic_inc(output + 0xFF)] = SWAP4(gid);
	}
}

#endif // ALLIUM_CL
