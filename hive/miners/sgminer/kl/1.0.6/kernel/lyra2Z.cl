/*
 * Lyra2RE kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 * Copyright (c) 2014 djm34
 * Copyright (c) 2014 James Lovejoy
 * Copyright (c) 2017 djm34
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
 */
// typedef unsigned int uint;
#pragma OPENCL EXTENSION cl_amd_printf : enable

#ifndef LYRA2Z_CL
#define LYRA2Z_CL
/*
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
*/

#define memshift 3
#include "lyra2v16.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
//#define SWAP8(x) as_ulong(as_uchar8(x).s32107654)
/*
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
*/

#define rotr32(a, w, c) \
{ \
    a = ( w >> c ) | ( w << ( 32 - c ) ); \
}

#define blake32GS(a, b, c, d, x, y, mx, my) \
{ \
    v[a] += (mx ^ c_u256[y]) + v[b]; \
    v[d] ^= v[a]; \
    rotr32(v[d], v[d], 16U); \
    v[c] += v[d]; \
    v[b] ^= v[c]; \
    rotr32(v[b], v[b], 12U); \
 \
    v[a] += (my ^ c_u256[x]) + v[b]; \
    v[d] ^= v[a]; \
    rotr32(v[d], v[d], 8U); \
    v[c] += v[d]; \
    v[b] ^= v[c]; \
    rotr32(v[b], v[b], 7U); \
}

#define byteSwapU32(ret, val) \
{ \
    val = ((val << 8U) & 0xFF00FF00U ) | ((val >> 8U) & 0xFF00FFU ); \
    ret = (val << 16U) | (val >> 16U); \
}

typedef union {
  unsigned char h1[32];
  uint h4[8];
  ulong h8[4];
} hash_t;

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
 __global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (gid - get_global_offset(0))));

const uint c_u256[16] = {
        0x243F6A88U, 0x85A308D3U,
        0x13198A2EU, 0x03707344U,
        0xA4093822U, 0x299F31D0U,
        0x082EFA98U, 0xEC4E6C89U,
        0x452821E6U, 0x38D01377U,
        0xBE5466CFU, 0x34E90C6CU,
        0xC0AC29B7U, 0xC97C50DDU,
        0x3F84D5B5U, 0xB5470917U
    };

    uint h[8];
    uint v[16];
    
    h[0]=h0;
    h[1]=h1;
    h[2]=h2;
    h[3]=h3;
    h[4]=h4;
    h[5]=h5;
    h[6]=h6;
    h[7]=h7;
    uint nonce = SWAP4(gid);	
        
    for (int i = 0; i < 8; ++i)
        v[i] = h[i];
    
    v[8] =  0x243F6A88U;
    v[9] =  0x85A308D3U;
    v[10] = 0x13198A2EU;
    v[11] = 0x03707344U;
    v[12] = 0xA4093822U ^ 640U;
    v[13] = 0x299F31D0U ^ 640U;
    v[14] = 0x082EFA98U;
    v[15] = 0xEC4E6C89U;

    //  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
    blake32GS(0, 4, 0x8, 0xC, 0, 1,     in16, in17);
    blake32GS(1, 5, 0x9, 0xD, 2, 3,     in18, nonce);
    blake32GS(2, 6, 0xA, 0xE, 4, 5,     0x80000000U, 0U);
    blake32GS(3, 7, 0xB, 0xF, 6, 7,     0U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 8, 9,     0U, 0U);
    blake32GS(1, 6, 0xB, 0xC, 10, 11,   0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 12, 13,   0U, 1U);
    blake32GS(3, 4, 0x9, 0xE, 14, 15,   0U, 640U);

    //  { 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
    blake32GS(0, 4, 0x8, 0xC, 14, 10,   0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 4, 8,     0x80000000, 0U);
    blake32GS(2, 6, 0xA, 0xE, 9, 15,    0U, 640U);
    blake32GS(3, 7, 0xB, 0xF, 13, 6,    1U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 1, 12,    in17, 0U);
    blake32GS(1, 6, 0xB, 0xC, 0, 2,     in16, in18);
    blake32GS(2, 7, 0x8, 0xD, 11, 7,    0U, 0U);
    blake32GS(3, 4, 0x9, 0xE, 5, 3,     0U, nonce);

    //  { 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
    blake32GS(0, 4, 0x8, 0xC, 11, 8,    0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 12, 0,    0U, in16);
    blake32GS(2, 6, 0xA, 0xE, 5, 2,     0U, in18);
    blake32GS(3, 7, 0xB, 0xF, 15, 13,   640U, 1U);
    blake32GS(0, 5, 0xA, 0xF, 10, 14,   0U, 0U);
    blake32GS(1, 6, 0xB, 0xC, 3, 6,     nonce, 0U);
    blake32GS(2, 7, 0x8, 0xD, 7, 1,     0U, in17);
    blake32GS(3, 4, 0x9, 0xE, 9, 4,     0U, 0x80000000U);
    
    //  { 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
    blake32GS(0, 4, 0x8, 0xC, 7, 9,     0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 3, 1,     nonce, in17);
    blake32GS(2, 6, 0xA, 0xE, 13, 12,   1U, 0U);
    blake32GS(3, 7, 0xB, 0xF, 11, 14,   0U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 2, 6,     in18, 0U);
    blake32GS(1, 6, 0xB, 0xC, 5, 10,    0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 4, 0,     0x80000000U, in16);
    blake32GS(3, 4, 0x9, 0xE, 15, 8,    640U, 0U);

    //  { 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
    blake32GS(0, 4, 0x8, 0xC, 9, 0,     0U, in16);
    blake32GS(1, 5, 0x9, 0xD, 5, 7,     0U, 0U);
    blake32GS(2, 6, 0xA, 0xE, 2, 4,     in18, 0x80000000U);
    blake32GS(3, 7, 0xB, 0xF, 10, 15,   0U, 640U);
    blake32GS(0, 5, 0xA, 0xF, 14, 1,    0U, in17);
    blake32GS(1, 6, 0xB, 0xC, 11, 12,   0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 6, 8,     0U, 0U);
    blake32GS(3, 4, 0x9, 0xE, 3, 13,    nonce, 1U);
    
    //  { 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
    blake32GS(0, 4, 0x8, 0xC, 2, 12,    in18, 0U);
    blake32GS(1, 5, 0x9, 0xD, 6, 10,    0U, 0U);
    blake32GS(2, 6, 0xA, 0xE, 0, 11,    in16, 0U);
    blake32GS(3, 7, 0xB, 0xF, 8, 3,     0U, nonce);
    blake32GS(0, 5, 0xA, 0xF, 4, 13,    0x80000000U, 1U);
    blake32GS(1, 6, 0xB, 0xC, 7, 5,     0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 15, 14,   640U, 0U);
    blake32GS(3, 4, 0x9, 0xE, 1, 9,     in17, 0U);

    //  { 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
    blake32GS(0, 4, 0x8, 0xC, 12, 5,    0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 1, 15,    in17, 640U);
    blake32GS(2, 6, 0xA, 0xE, 14, 13,   0U, 1U);
    blake32GS(3, 7, 0xB, 0xF, 4, 10,    0x80000000U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 0, 7,     in16, 0U);
    blake32GS(1, 6, 0xB, 0xC, 6, 3,     0U, nonce);
    blake32GS(2, 7, 0x8, 0xD, 9, 2,     0U, in18);
    blake32GS(3, 4, 0x9, 0xE, 8, 11,    0U, 0U);

    //  { 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
    blake32GS(0, 4, 0x8, 0xC, 13, 11,   1U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 7, 14,    0U, 0U);
    blake32GS(2, 6, 0xA, 0xE, 12, 1,    0U, in17);
    blake32GS(3, 7, 0xB, 0xF, 3, 9,     nonce, 0U);
    blake32GS(0, 5, 0xA, 0xF, 5, 0,     0U, in16);
    blake32GS(1, 6, 0xB, 0xC, 15, 4,    640U, 0x80000000U);
    blake32GS(2, 7, 0x8, 0xD, 8, 6,     0U, 0U);
    blake32GS(3, 4, 0x9, 0xE, 2, 10,    in18, 0U);
  
    //  { 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
    blake32GS(0, 4, 0x8, 0xC, 6, 15,    0U, 640U);
    blake32GS(1, 5, 0x9, 0xD, 14, 9,    0U, 0U);
    blake32GS(2, 6, 0xA, 0xE, 11, 3,    0U, nonce);
    blake32GS(3, 7, 0xB, 0xF, 0, 8,     in16, 0U);
    blake32GS(0, 5, 0xA, 0xF, 12, 2,    0U, in18);
    blake32GS(1, 6, 0xB, 0xC, 13, 7,    1U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 1, 4,     in17, 0x80000000U);
    blake32GS(3, 4, 0x9, 0xE, 10, 5,    0U, 0U);
    
    //  { 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
    blake32GS(0, 4, 0x8, 0xC, 10, 2,    0U, in18);
    blake32GS(1, 5, 0x9, 0xD, 8, 4,     0U, 0x80000000U);
    blake32GS(2, 6, 0xA, 0xE, 7, 6,     0U, 0U);
    blake32GS(3, 7, 0xB, 0xF, 1, 5,     in17, 0U);
    blake32GS(0, 5, 0xA, 0xF, 15, 11,   640U, 0U);
    blake32GS(1, 6, 0xB, 0xC, 9, 14,    0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 3, 12,    nonce, 0U);
    blake32GS(3, 4, 0x9, 0xE, 13, 0,    1U, in16);
    
        
    //  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
    blake32GS(0, 4, 0x8, 0xC, 0, 1,     in16, in17);
    blake32GS(1, 5, 0x9, 0xD, 2, 3,     in18, nonce);
    blake32GS(2, 6, 0xA, 0xE, 4, 5,     0x80000000U, 0U);
    blake32GS(3, 7, 0xB, 0xF, 6, 7,     0U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 8, 9,     0U, 0U);
    blake32GS(1, 6, 0xB, 0xC, 10, 11,   0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 12, 13,   0U, 1U);
    blake32GS(3, 4, 0x9, 0xE, 14, 15,   0U, 640U);

    //  { 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
    blake32GS(0, 4, 0x8, 0xC, 14, 10,   0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 4, 8,     0x80000000, 0U);
    blake32GS(2, 6, 0xA, 0xE, 9, 15,    0U, 640U);
    blake32GS(3, 7, 0xB, 0xF, 13, 6,    1U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 1, 12,    in17, 0U);
    blake32GS(1, 6, 0xB, 0xC, 0, 2,     in16, in18);
    blake32GS(2, 7, 0x8, 0xD, 11, 7,    0U, 0U);
    blake32GS(3, 4, 0x9, 0xE, 5, 3,     0U, nonce);

    //  { 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
    blake32GS(0, 4, 0x8, 0xC, 11, 8,    0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 12, 0,    0U, in16);
    blake32GS(2, 6, 0xA, 0xE, 5, 2,     0U, in18);
    blake32GS(3, 7, 0xB, 0xF, 15, 13,   640U, 1U);
    blake32GS(0, 5, 0xA, 0xF, 10, 14,   0U, 0U);
    blake32GS(1, 6, 0xB, 0xC, 3, 6,     nonce, 0U);
    blake32GS(2, 7, 0x8, 0xD, 7, 1,     0U, in17);
    blake32GS(3, 4, 0x9, 0xE, 9, 4,     0U, 0x80000000U);
    
    //  { 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
    blake32GS(0, 4, 0x8, 0xC, 7, 9,     0U, 0U);
    blake32GS(1, 5, 0x9, 0xD, 3, 1,     nonce, in17);
    blake32GS(2, 6, 0xA, 0xE, 13, 12,   1U, 0U);
    blake32GS(3, 7, 0xB, 0xF, 11, 14,   0U, 0U);
    blake32GS(0, 5, 0xA, 0xF, 2, 6,     in18, 0U);
    blake32GS(1, 6, 0xB, 0xC, 5, 10,    0U, 0U);
    blake32GS(2, 7, 0x8, 0xD, 4, 0,     0x80000000U, in16);
    blake32GS(3, 4, 0x9, 0xE, 15, 8,    640U, 0U);


    h[0] ^= v[0] ^ v[8];
    h[1] ^= v[1] ^ v[9];
    h[2] ^= v[2] ^ v[10];
    h[3] ^= v[3] ^ v[11];
    h[4] ^= v[4] ^ v[12];
    h[5] ^= v[5] ^ v[13];
    h[6] ^= v[6] ^ v[14];
    h[7] ^= v[7] ^ v[15];
    
    for (int i = 0; i < 8; ++i)
    {
        byteSwapU32(h[i], h[i]);
    }
	
	for (int i=0;i<8;i++) {hash->h4[i]=h[i];}

barrier(CLK_LOCAL_MEM_FENCE);

}


/// lyra2 algo 


__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global uchar* hashes,__global uchar* matrix, __global uint* output, const ulong target)
{
 uint gid = get_global_id(0);
 // __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
  __global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (gid - get_global_offset(0))));
  __global ulong4 *DMatrix = (__global ulong4 *)(matrix + (4 * memshift * 8 * 8 * 8 * (gid - get_global_offset(0))));

//  uint offset = (4 * memshift * 4 * 4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS))/32;
  ulong4 state[4];
  
  state[0].x = hash->h8[0]; //password
  state[0].y = hash->h8[1]; //password
  state[0].z = hash->h8[2]; //password
  state[0].w = hash->h8[3]; //password
  state[1] = state[0];
  state[2] = (ulong4)(0x6a09e667f3bcc908UL, 0xbb67ae8584caa73bUL, 0x3c6ef372fe94f82bUL, 0xa54ff53a5f1d36f1UL);
  state[3] = (ulong4)(0x510e527fade682d1UL, 0x9b05688c2b3e6c1fUL, 0x1f83d9abfb41bd6bUL, 0x5be0cd19137e2179UL);
  for (int i = 0; i<12; i++) { round_lyra(state); } 

  state[0] ^= (ulong4)(0x20,0x20,0x20,0x08);
  state[1] ^= (ulong4)(0x08,0x08,0x80,0x0100000000000000);

  for (int i = 0; i<12; i++) { round_lyra(state); } 

// reducedsqueezedrow0
  uint ps1 = (memshift * 7);
//#pragma unroll 4
  for (int i = 0; i < 8; i++)
  {
	  uint s1 = ps1 - memshift * i;
	  for (int j = 0; j < 3; j++)
		  (DMatrix)[j+s1] = state[j];

	  round_lyra(state);
  }
 ///// reduceduplexrow1 ////////////
  reduceDuplexf(state,DMatrix);
 
  reduceDuplexRowSetupf(1, 0, 2,state, DMatrix);
  reduceDuplexRowSetupf(2, 1, 3, state,DMatrix);
  reduceDuplexRowSetupf(3, 0, 4, state, DMatrix);
  reduceDuplexRowSetupf(4, 3, 5, state, DMatrix);
  reduceDuplexRowSetupf(5, 2, 6, state, DMatrix);
  reduceDuplexRowSetupf(6, 1, 7, state, DMatrix);


  uint rowa;
  uint prev = 7;
  uint iterator = 0;

for (uint j = 0; j < 4; j++) {

  for (uint i = 0; i<8; i++) {
	  rowa = state[0].x & 7;
	  reduceDuplexRowf(prev, rowa, iterator, state, DMatrix);
	  prev = iterator;
	  iterator = (iterator + 3) & 7;
  }

  for (uint i = 0; i<8; i++) {
	  rowa = state[0].x & 7;
	  reduceDuplexRowf(prev, rowa, iterator, state, DMatrix);
	  prev = iterator;
	  iterator = (iterator - 1) & 7;
  }
}

  uint shift = (memshift * 8 * rowa);

  for (int j = 0; j < 3; j++)
	  state[j] ^= (DMatrix)[j+shift];

  for (int i = 0; i < 12; i++)
	  round_lyra(state);
//////////////////////////////////////


//  for (int i = 0; i<4; i++) {hash->h8[i] = ((ulong*)state)[i];} 
//barrier(CLK_LOCAL_MEM_FENCE);

bool result = (((ulong*)state)[3] <= target);
if (result) {
	output[atomic_inc(output + 0xFF)] = SWAP4(gid);
}

}



#endif // LYRA2Z_CL