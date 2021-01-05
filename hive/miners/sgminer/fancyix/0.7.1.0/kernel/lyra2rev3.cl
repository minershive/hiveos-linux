/*
 * Lyra2RE kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 * Copyright (c) 2014 djm34
 * Copyright (c) 2014 James Lovejoy
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
 * @author   CryptoGraphics ( CrGraphics@protonmail.com )
 * @author   fancyIX 2018
 */
// typedef unsigned int uint;
#pragma OPENCL EXTENSION cl_amd_printf : enable

#ifndef LYRA2REV3_CL
#define LYRA2REV3_CL

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

//#define SPH_ROTR64(l,n) ror64(l,n)
#define memshift 3
#include "blake256.cl"
#include "keccak1600.cl"
#include "skein256.cl"
#include "cubehash.cl"
#include "bmw256.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
//#define SWAP8(x) as_ulong(as_uchar8(x).s32107654)
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

#include "lyra2v3ly.cl"

typedef union {
  unsigned char h1[32];
  uint h4[8];
  ulong h8[4];
} hash_t;

typedef union {
    uint h[8];
    uint4 h4[2];
    ulong2 hl4[2];
    ulong4 h8;
} hashly_t;

typedef union {
    uint h[32];
    ulong h2[16];
    ulong2 hl4[8];
    uint4 h4[8];
    ulong4 h8[4];
} lyraState_t;

typedef union
{
    uint h[32];
    ulong h2[16];
    uint4 h4[8];
    ulong4 h8[4];
} LyraState;

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
 __global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));


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

// lyra2v3
// lyra2v3 p1
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global uint* hashes, __global uint* lyraStates)
{
    int gid = get_global_id(0);
    
    __global hashly_t *hash = (__global hashly_t *)(hashes + (8* ((get_global_id(0) % MAX_GLOBAL_THREADS))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (get_global_id(0) % MAX_GLOBAL_THREADS)));

    ulong ttr;

    ulong2 state[8];
    // state0
    state[0] = hash->hl4[0];
    state[1] = hash->hl4[1];
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
    state[1].y ^= 0x01UL;
    
    state[2].x ^= 0x04UL;
    state[2].y ^= 0x04UL;
    
    state[3].x ^= 0x80UL;
    state[3].y ^= 0x0100000000000000UL;
    
    for (int i = 0; i < 12; i++)
    {
        roundLyra(state);
    }
    
    // state0
    lyraState->hl4[0] = state[0];
    lyraState->hl4[1] = state[1];
    // state1
    lyraState->hl4[2] = state[2];
    lyraState->hl4[3] = state[3];
    // state2
    lyraState->hl4[4] = state[4];
    lyraState->hl4[5] = state[5];
    // state3
    lyraState->hl4[6] = state[6];
    lyraState->hl4[7] = state[7];

    barrier(CLK_LOCAL_MEM_FENCE);
}
// lyra2v3 p2
__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void search2(__global uint* lyraStates)
{
    __local struct SharedState smState[64];

    int gid = ((get_global_id(0) >> 2) % MAX_GLOBAL_THREADS);
    __global LyraState *lyraState = (__global LyraState *)(lyraStates + (32* (gid)));

    ulong state[4];
    ulong ttr;
    
    uint lIdx = (uint)get_local_id(0);
    uint gr4 = ((lIdx >> 2) << 2);
    
    //-------------------------------------
    // Load Lyra state
    state[0] = (ulong)(lyraState->h2[(lIdx & 3)]);
    state[1] = (ulong)(lyraState->h2[(lIdx & 3)+4]);
    state[2] = (ulong)(lyraState->h2[(lIdx & 3)+8]);
    state[3] = (ulong)(lyraState->h2[(lIdx & 3)+12]);

    //-------------------------------------
    ulong lMatrix[48];
    ulong state0[12];
    ulong state1[12];
    
    //------------------------------------
    // loop 1
    {
        state0[ 9] = state[0];
        state0[10] = state[1];
        state0[11] = state[2];
        
        roundLyra_sm(state);
        
        state0[6] = state[0];
        state0[7] = state[1];
        state0[8] = state[2];
        
        roundLyra_sm(state);
        
        state0[3] = state[0];
        state0[4] = state[1];
        state0[5] = state[2];
        
        roundLyra_sm(state);
        
        state0[0] = state[0];
        state0[1] = state[1];
        state0[2] = state[2];
        
        roundLyra_sm(state);
    }
    
    //------------------------------------
    // loop 2
    {
        state[0] ^= state0[0];
        state[1] ^= state0[1];
        state[2] ^= state0[2];
        roundLyra_sm(state);
        state1[ 9] = state0[0] ^ state[0];
        state1[10] = state0[1] ^ state[1];
        state1[11] = state0[2] ^ state[2];
        
        state[0] ^= state0[3];
        state[1] ^= state0[4];
        state[2] ^= state0[5];
        roundLyra_sm(state);
        state1[6] = state0[3] ^ state[0];
        state1[7] = state0[4] ^ state[1];
        state1[8] = state0[5] ^ state[2];
        
        state[0] ^= state0[6];
        state[1] ^= state0[7];
        state[2] ^= state0[8];
        roundLyra_sm(state);
        state1[3] = state0[6] ^ state[0];
        state1[4] = state0[7] ^ state[1];
        state1[5] = state0[8] ^ state[2];
        
        state[0] ^= state0[ 9];
        state[1] ^= state0[10];
        state[2] ^= state0[11];
        roundLyra_sm(state);
        state1[0] = state0[ 9] ^ state[0];
        state1[1] = state0[10] ^ state[1];
        state1[2] = state0[11] ^ state[2];
    }
    
    ulong state2[3];
    ulong t0,c0;
    loop3p1_iteration(0, 1, 2, 33,34,35);
    loop3p1_iteration(3, 4, 5, 30,31,32);
    loop3p1_iteration(6, 7, 8, 27,28,29);
    loop3p1_iteration(9,10,11, 24,25,26);

    loop3p2_iteration(0, 1, 2, 9,10,11, 45,46,47, 12,13,14);
    loop3p2_iteration(3, 4, 5, 6, 7, 8, 42,43,44, 15,16,17);
    loop3p2_iteration(6, 7, 8, 3, 4, 5, 39,40,41, 18,19,20);
    loop3p2_iteration(9,10,11, 0, 1, 2, 36,37,38, 21,22,23);

    ulong a_state1_0, a_state1_1, a_state1_2;
    ulong a_state2_0, a_state2_1, a_state2_2;
    ulong b0,b1;

    //------------------------------------
    // Wandering phase part 1
    uint rowa, index;
    index = smState[gr4].s[0];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;
    
    wanderIteration(36,37,38, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 0, 1, 2);
    wanderIteration(39,40,41, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 3, 4, 5);
    wanderIteration(42,43,44, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 6, 7, 8);
    wanderIteration(45,46,47, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 9,10,11);

    index = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;
    
    wanderIteration(0, 1, 2, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 12,13,14);
    wanderIteration(3, 4, 5, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 15,16,17);
    wanderIteration(6, 7, 8, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 18,19,20);
    wanderIteration(9,10,11, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 21,22,23);

    index = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;
    
    wanderIteration(12,13,14, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 24,25,26);
    wanderIteration(15,16,17, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 27,28,29);
    wanderIteration(18,19,20, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 30,31,32);
    wanderIteration(21,22,23, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 33,34,35);
    

    //------------------------------------
    // Wandering phase part 2 (last iteration)
    index = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;

    ulong last[3];

    b0 = (rowa < 2)? lMatrix[0]: lMatrix[24];
    b1 = (rowa < 2)? lMatrix[12]: lMatrix[36];
    last[0] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[1]: lMatrix[25];
    b1 = (rowa < 2)? lMatrix[13]: lMatrix[37];
    last[1] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[2]: lMatrix[26];
    b1 = (rowa < 2)? lMatrix[14]: lMatrix[38];
    last[2] = ((rowa & 0x1U) < 1)? b0: b1;


    t0 = lMatrix[24];
    c0 = last[0] + t0;
    state[0] ^= c0;
    
    t0 = lMatrix[25];
    c0 = last[1] + t0;
    state[1] ^= c0;
    
    t0 = lMatrix[26];
    c0 = last[2] + t0;
    state[2] ^= c0;

    roundLyra_sm_ext(state);
   
    ulong Data0 = smState[gr4 + ((lIdx+3) & 3)].s[0];
    ulong Data1 = smState[gr4 + ((lIdx+3) & 3)].s[1];
    ulong Data2 = smState[gr4 + ((lIdx+3) & 3)].s[2];  
    if((lIdx&3) == 0)
    {
        last[1] ^= Data0;
        last[2] ^= Data1;
        last[0] ^= Data2;
    }
    else
    {
        last[0] ^= Data0;
        last[1] ^= Data1;
        last[2] ^= Data2;
    }

    if(rowa == 3)
    {
        last[0] ^= state[0];
        last[1] ^= state[1];
        last[2] ^= state[2];
    }

    wanderIterationP2(27,28,29, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41);
    wanderIterationP2(30,31,32, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44);
    wanderIterationP2(33,34,35, 9,10,11, 21,22,23, 33,34,35, 45,46,47);

    state[0] ^= last[0];
    state[1] ^= last[1];
    state[2] ^= last[2];

    //-------------------------------------
    // save lyra state    
    lyraState->h2[(lIdx & 3)] = state[0];
    lyraState->h2[(lIdx & 3)+4] = state[1];
    lyraState->h2[(lIdx & 3)+8] = state[2];
    lyraState->h2[(lIdx & 3)+12] = state[3];
    
    barrier(CLK_GLOBAL_MEM_FENCE);
}
// lyra2v3 p3
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search3(__global uint* hashes, __global uint* lyraStates)
{
    int gid = get_global_id(0);

    __global hashly_t *hash = (__global hashly_t *)(hashes + (8* ((get_global_id(0) % MAX_GLOBAL_THREADS))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (get_global_id(0) % MAX_GLOBAL_THREADS)));

    ulong ttr;

    ulong2 state[8];
    // 1. load lyra State
    state[0] = lyraState->hl4[0];
    state[1] = lyraState->hl4[1];
    state[2] = lyraState->hl4[2];
    state[3] = lyraState->hl4[3];
    state[4] = lyraState->hl4[4];
    state[5] = lyraState->hl4[5];
    state[6] = lyraState->hl4[6];
    state[7] = lyraState->hl4[7];

    // 2. rounds
    for (int i = 0; i < 12; ++i)
    {
        roundLyra(state);
    }

    // 3. store result
    hash->hl4[0] = state[0];
    hash->hl4[1] = state[1];
    
    barrier(CLK_LOCAL_MEM_FENCE);
}

// cubehash256

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global uchar* hashes)
{
	uint gid = get_global_id(0);
	__global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));


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


// lyra2v3
// lyra2v3 p1
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global uint* hashes, __global uint* lyraStates)
{
    int gid = get_global_id(0);
    
    __global hashly_t *hash = (__global hashly_t *)(hashes + (8* ((get_global_id(0) % MAX_GLOBAL_THREADS))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (get_global_id(0) % MAX_GLOBAL_THREADS)));

    ulong ttr;

    ulong2 state[8];
    // state0
    state[0] = hash->hl4[0];
    state[1] = hash->hl4[1];
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
    state[1].y ^= 0x01UL;
    
    state[2].x ^= 0x04UL;
    state[2].y ^= 0x04UL;
    
    state[3].x ^= 0x80UL;
    state[3].y ^= 0x0100000000000000UL;
    
    for (int i = 0; i < 12; i++)
    {
        roundLyra(state);
    }
    
    // state0
    lyraState->hl4[0] = state[0];
    lyraState->hl4[1] = state[1];
    // state1
    lyraState->hl4[2] = state[2];
    lyraState->hl4[3] = state[3];
    // state2
    lyraState->hl4[4] = state[4];
    lyraState->hl4[5] = state[5];
    // state3
    lyraState->hl4[6] = state[6];
    lyraState->hl4[7] = state[7];

    barrier(CLK_LOCAL_MEM_FENCE);
}
// lyra2v3 p2
__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void search6(__global uint* lyraStates)
{
    __local struct SharedState smState[64];

    int gid = ((get_global_id(0) >> 2) % MAX_GLOBAL_THREADS);
    __global LyraState *lyraState = (__global LyraState *)(lyraStates + (32* (gid)));

    ulong state[4];
    ulong ttr;
    
    uint lIdx = (uint)get_local_id(0);
    uint gr4 = ((lIdx >> 2) << 2);
    
    //-------------------------------------
    // Load Lyra state
    state[0] = (ulong)(lyraState->h2[(lIdx & 3)]);
    state[1] = (ulong)(lyraState->h2[(lIdx & 3)+4]);
    state[2] = (ulong)(lyraState->h2[(lIdx & 3)+8]);
    state[3] = (ulong)(lyraState->h2[(lIdx & 3)+12]);

    //-------------------------------------
    ulong lMatrix[48];
    ulong state0[12];
    ulong state1[12];
    
    //------------------------------------
    // loop 1
    {
        state0[ 9] = state[0];
        state0[10] = state[1];
        state0[11] = state[2];
        
        roundLyra_sm(state);
        
        state0[6] = state[0];
        state0[7] = state[1];
        state0[8] = state[2];
        
        roundLyra_sm(state);
        
        state0[3] = state[0];
        state0[4] = state[1];
        state0[5] = state[2];
        
        roundLyra_sm(state);
        
        state0[0] = state[0];
        state0[1] = state[1];
        state0[2] = state[2];
        
        roundLyra_sm(state);
    }
    
    //------------------------------------
    // loop 2
    {
        state[0] ^= state0[0];
        state[1] ^= state0[1];
        state[2] ^= state0[2];
        roundLyra_sm(state);
        state1[ 9] = state0[0] ^ state[0];
        state1[10] = state0[1] ^ state[1];
        state1[11] = state0[2] ^ state[2];
        
        state[0] ^= state0[3];
        state[1] ^= state0[4];
        state[2] ^= state0[5];
        roundLyra_sm(state);
        state1[6] = state0[3] ^ state[0];
        state1[7] = state0[4] ^ state[1];
        state1[8] = state0[5] ^ state[2];
        
        state[0] ^= state0[6];
        state[1] ^= state0[7];
        state[2] ^= state0[8];
        roundLyra_sm(state);
        state1[3] = state0[6] ^ state[0];
        state1[4] = state0[7] ^ state[1];
        state1[5] = state0[8] ^ state[2];
        
        state[0] ^= state0[ 9];
        state[1] ^= state0[10];
        state[2] ^= state0[11];
        roundLyra_sm(state);
        state1[0] = state0[ 9] ^ state[0];
        state1[1] = state0[10] ^ state[1];
        state1[2] = state0[11] ^ state[2];
    }
    
    ulong state2[3];
    ulong t0,c0;
    loop3p1_iteration(0, 1, 2, 33,34,35);
    loop3p1_iteration(3, 4, 5, 30,31,32);
    loop3p1_iteration(6, 7, 8, 27,28,29);
    loop3p1_iteration(9,10,11, 24,25,26);

    loop3p2_iteration(0, 1, 2, 9,10,11, 45,46,47, 12,13,14);
    loop3p2_iteration(3, 4, 5, 6, 7, 8, 42,43,44, 15,16,17);
    loop3p2_iteration(6, 7, 8, 3, 4, 5, 39,40,41, 18,19,20);
    loop3p2_iteration(9,10,11, 0, 1, 2, 36,37,38, 21,22,23);

    ulong a_state1_0, a_state1_1, a_state1_2;
    ulong a_state2_0, a_state2_1, a_state2_2;
    ulong b0,b1;

    //------------------------------------
    // Wandering phase part 1
    uint rowa, index;
    index = smState[gr4].s[0];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;
    
    wanderIteration(36,37,38, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 0, 1, 2);
    wanderIteration(39,40,41, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 3, 4, 5);
    wanderIteration(42,43,44, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 6, 7, 8);
    wanderIteration(45,46,47, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 9,10,11);

    index = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;
    
    wanderIteration(0, 1, 2, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 12,13,14);
    wanderIteration(3, 4, 5, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 15,16,17);
    wanderIteration(6, 7, 8, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 18,19,20);
    wanderIteration(9,10,11, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 21,22,23);

    index = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;
    
    wanderIteration(12,13,14, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 24,25,26);
    wanderIteration(15,16,17, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 27,28,29);
    wanderIteration(18,19,20, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 30,31,32);
    wanderIteration(21,22,23, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 33,34,35);
    

    //------------------------------------
    // Wandering phase part 2 (last iteration)
    index = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa  = smState[gr4 + (index & 3)].s[(index >> 2) & 0x3];
    rowa &= 0x3;

    ulong last[3];

    b0 = (rowa < 2)? lMatrix[0]: lMatrix[24];
    b1 = (rowa < 2)? lMatrix[12]: lMatrix[36];
    last[0] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[1]: lMatrix[25];
    b1 = (rowa < 2)? lMatrix[13]: lMatrix[37];
    last[1] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[2]: lMatrix[26];
    b1 = (rowa < 2)? lMatrix[14]: lMatrix[38];
    last[2] = ((rowa & 0x1U) < 1)? b0: b1;


    t0 = lMatrix[24];
    c0 = last[0] + t0;
    state[0] ^= c0;
    
    t0 = lMatrix[25];
    c0 = last[1] + t0;
    state[1] ^= c0;
    
    t0 = lMatrix[26];
    c0 = last[2] + t0;
    state[2] ^= c0;

    roundLyra_sm_ext(state);
   
    ulong Data0 = smState[gr4 + ((lIdx+3) & 3)].s[0];
    ulong Data1 = smState[gr4 + ((lIdx+3) & 3)].s[1];
    ulong Data2 = smState[gr4 + ((lIdx+3) & 3)].s[2];  
    if((lIdx&3) == 0)
    {
        last[1] ^= Data0;
        last[2] ^= Data1;
        last[0] ^= Data2;
    }
    else
    {
        last[0] ^= Data0;
        last[1] ^= Data1;
        last[2] ^= Data2;
    }

    if(rowa == 3)
    {
        last[0] ^= state[0];
        last[1] ^= state[1];
        last[2] ^= state[2];
    }

    wanderIterationP2(27,28,29, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41);
    wanderIterationP2(30,31,32, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44);
    wanderIterationP2(33,34,35, 9,10,11, 21,22,23, 33,34,35, 45,46,47);

    state[0] ^= last[0];
    state[1] ^= last[1];
    state[2] ^= last[2];

    //-------------------------------------
    // save lyra state    
    lyraState->h2[(lIdx & 3)] = state[0];
    lyraState->h2[(lIdx & 3)+4] = state[1];
    lyraState->h2[(lIdx & 3)+8] = state[2];
    lyraState->h2[(lIdx & 3)+12] = state[3];
    
    barrier(CLK_GLOBAL_MEM_FENCE);
}
// lyra2v3 p3
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search7(__global uint* hashes, __global uint* lyraStates)
{
    int gid = get_global_id(0);

    __global hashly_t *hash = (__global hashly_t *)(hashes + (8* ((get_global_id(0) % MAX_GLOBAL_THREADS))));
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (get_global_id(0) % MAX_GLOBAL_THREADS)));

    ulong ttr;

    ulong2 state[8];
    // 1. load lyra State
    state[0] = lyraState->hl4[0];
    state[1] = lyraState->hl4[1];
    state[2] = lyraState->hl4[2];
    state[3] = lyraState->hl4[3];
    state[4] = lyraState->hl4[4];
    state[5] = lyraState->hl4[5];
    state[6] = lyraState->hl4[6];
    state[7] = lyraState->hl4[7];

    // 2. rounds
    for (int i = 0; i < 12; ++i)
    {
        roundLyra(state);
    }

    // 3. store result
    hash->hl4[0] = state[0];
    hash->hl4[1] = state[1];
    
    barrier(CLK_LOCAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search8(__global uchar* hashes, __global uint* output, const ulong target)
{
	uint gid = get_global_id(0);
	__global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));

	uint dh[16] = {
		0x40414243, 0x44454647,
		0x48494A4B, 0x4C4D4E4F,
		0x50515253, 0x54555657,
		0x58595A5B, 0x5C5D5E5F,
		0x60616263, 0x64656667,
		0x68696A6B, 0x6C6D6E6F,
		0x70717273, 0x74757677,
		0x78797A7B, 0x7C7D7E7F
	};
	uint final_s[16] = {
		0xaaaaaaa0, 0xaaaaaaa1, 0xaaaaaaa2,
		0xaaaaaaa3, 0xaaaaaaa4, 0xaaaaaaa5,
		0xaaaaaaa6, 0xaaaaaaa7, 0xaaaaaaa8,
		0xaaaaaaa9, 0xaaaaaaaa, 0xaaaaaaab,
		0xaaaaaaac, 0xaaaaaaad, 0xaaaaaaae,
		0xaaaaaaaf
	};

	uint message[16];
	for (int i = 0; i<8; i++) message[i] = hash->h4[i];
	for (int i = 9; i<14; i++) message[i] = 0;
	message[8]= 0x80;
	message[14]=0x100;
	message[15]=0;

	Compression256(message, dh);
	Compression256(dh, final_s);
	barrier(CLK_LOCAL_MEM_FENCE);


	bool result = ( ((ulong*)final_s)[7] <= target);
	if (result) {
		output[atomic_inc(output + 0xFF)] = SWAP4(gid);
	}

}


#endif // LYRA2REV3_CL