/*
 * Lyra2RE kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 * Copyright (c) 2014 djm34
 * Copyright (c) 2014 James Lovejoy
 * Copyright (c) 2017 djm34
 * Copyright (c) 2018 KL0nLutiy
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
 * @author   djm34
 * @author   fancyIX 2018
 */
// typedef unsigned int uint;
//#pragma OPENCL EXTENSION cl_amd_printf : enable

#ifndef LYRA2Z_CL
#define LYRA2Z_CL


#if __ENDIAN_LITTLE__
#define SPH_LITTLE_ENDIAN 1
#else
#define SPH_BIG_ENDIAN 1
#endif

#define SPH_UPTR sph_u64

typedef unsigned int sph_u32;
typedef int sph_s32;
#ifndef __OPENCL_VERSION__
typedef unsigned long sph_u64;
typedef long  sph_s64;
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

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
#define SWAP32(x) as_ulong(as_uint2(x).s10)

#define memshift 3
#include "blake256.cl"
#include "lyra2mdz.cl"



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
	 __global uchar* hashes,
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
 __global hash2_t *hash = (__global hash2_t *)(hashes + (4 * sizeof(ulong)* (gid - get_global_offset(0))));


//  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

    unsigned int h[8];
	unsigned int m[16];
	unsigned int v[16];


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

for (int i=0;i<8;i++) {hash->h4[i]=SWAP4(h[i]);}

barrier(CLK_LOCAL_MEM_FENCE);

}

/// lyra2 p1 

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global uint* hashes, __global uchar* sharedDataBuf)
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
    for (int i = 0; i < 12; ++i)
    {
        roundLyra(state);
    }

    state[0].x ^= 0x20UL;
    state[0].y ^= 0x20UL;
    
    state[1].x ^= 0x20UL;
    state[1].y ^= 0x08UL;
    
    state[2].x ^= 0x08UL;
    state[2].y ^= 0x08UL;
    
    state[3].x ^= 0x80UL;
    state[3].y ^= 0x0100000000000000UL;
    
    for (int i = 0; i < 12; i++)
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
__kernel void search2(__global uchar* sharedDataBuf)
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
  uint prev = 7;
  uint iterator = 0;
  for (uint j = 0; j < LYRA_ROUNDS / 2; j++) {
    for (uint i = 0; i<LYRA_ROUNDS; i++) {
      local uint *shorter = (local uint*)roundPad;
      if(get_local_id(0) == 0) {
          shorter[get_local_id(1)] = (uint)(state[0] % 8);
      }
      barrier(CLK_LOCAL_MEM_FENCE); // nop
      modify = shorter[get_local_id(1)];
      hyper_xor(prev, modify, iterator, state, roundPad, notepad);
      prev = iterator;
      iterator = (iterator + 3) & 7;
    }
    for (uint i = 0; i<LYRA_ROUNDS; i++) {
      local uint *shorter = (local uint*)roundPad;
      if(get_local_id(0) == 0) {
          shorter[get_local_id(1)] = (uint)(state[0] % 8);
      }
      barrier(CLK_LOCAL_MEM_FENCE); // nop
      modify = shorter[get_local_id(1)];
      hyper_xor(prev, modify, iterator, state, roundPad, notepad);
      prev = iterator;
      iterator = (iterator - 1) & 7;
    }
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
__kernel void search3(__global uint* hashes, __global uchar* sharedDataBuf)
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

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global uchar* hashes, __global uint* output, const ulong target)
{
  uint gid = get_global_id(0);
 __global hash2_t *hash = (__global hash2_t *)(hashes + (4 * sizeof(ulong)* (gid - get_global_offset(0))));

  bool result = (hash->h8[3] <= target);
  if (result) {
	output[atomic_inc(output + 0xFF)] = SWAP4(gid);
  }
}



#endif // LYRA2Z_CL