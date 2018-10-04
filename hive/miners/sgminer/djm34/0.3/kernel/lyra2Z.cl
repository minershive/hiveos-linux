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
#include "blake256.cl"
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
  __local ulong4 temp[24*WORKSIZE];
  
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

	  for (int j = 0; j < 3; j++)
		  temp[3*(7-i)+j+24* get_local_id(0)] = state[j];

	  round_lyra(state);
  }
 ///// reduceduplexrow1 ////////////
  reduceDuplexf_tmp(state,DMatrix,temp + 24 * get_local_id(0));
 
  reduceDuplexRowSetupf_pass1(1, 0, 2,state, DMatrix, temp + 24 * get_local_id(0));
  reduceDuplexRowSetupf_pass2(2, 1, 3, state,DMatrix, temp + 24 * get_local_id(0));
  reduceDuplexRowSetupf_pass1(3, 0, 4, state, DMatrix, temp + 24 * get_local_id(0));
  reduceDuplexRowSetupf_pass2(4, 3, 5, state, DMatrix, temp + 24 * get_local_id(0));
  reduceDuplexRowSetupf_pass1(5, 2, 6, state, DMatrix, temp + 24 * get_local_id(0));
  reduceDuplexRowSetupf_pass2(6, 1, 7, state, DMatrix, temp + 24 * get_local_id(0));


  uint rowa;
  uint prev = 7;
  uint iterator = 0;

for (uint j = 0; j < 4; j++) {

  for (uint i = 0; i<8; i++) {
	  rowa = state[0].x & 7;
	  reduceDuplexRowf_tmp(prev, rowa, iterator, state, DMatrix, temp + 24 * get_local_id(0));
	  prev = iterator;
	  iterator = (iterator + 3) & 7;
  }

  for (uint i = 0; i<8; i++) {
	  rowa = state[0].x & 7;
if (i==7 && j==3)
	  reduceDuplexRowf_tmp2(prev, rowa, iterator, state, DMatrix, temp + 24 * get_local_id(0));
else
	  reduceDuplexRowf_tmp(prev, rowa, iterator, state, DMatrix, temp + 24 * get_local_id(0));
	  prev = iterator;
	  iterator = (iterator - 1) & 7;
  }
}

  uint shift = (memshift * 8 * rowa);

  for (int j = 0; j < 3; j++)
	  state[j] ^= temp[j + 24 * get_local_id(0)]; //(DMatrix)[j+shift];

//  for (int j = 0; j < 3; j++)
//	  state[j] ^= temp[j];

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