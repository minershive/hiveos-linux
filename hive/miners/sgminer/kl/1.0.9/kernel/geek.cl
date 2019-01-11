/*
 * GEEK kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2014  phm
 * Copyright (c) 2014 Girino Vey
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
 * @author   phm <phm@inbox.com>
 */

#ifndef GEEK_CL
#define GEEK_CL

#define DEBUG(x)

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
#define SPH_T32(x) (as_uint(x))
#define SPH_ROTL32(x, n) rotate(as_uint(x), as_uint(n))
#define SPH_ROTR32(x, n)   SPH_ROTL32(x, (32 - (n)))

#define SPH_C64(x)    ((sph_u64)(x ## UL))
#define SPH_T64(x) (as_ulong(x))
#define SPH_ROTL64(x, n) rotate(as_ulong(x), (n) & 0xFFFFFFFFFFFFFFFFUL)
#define SPH_ROTR64(x, n)   SPH_ROTL64(x, (64 - (n)))

#define SPH_ECHO_64 1
#define SPH_KECCAK_64 1
#define SPH_JH_64 1
#define SPH_SIMD_NOCOPY 0
#define SPH_KECCAK_NOCOPY 0
#define SPH_SMALL_FOOTPRINT_GROESTL 0
#define SPH_GROESTL_BIG_ENDIAN 0
#define SPH_CUBEHASH_UNROLL 0

#ifndef SPH_COMPACT_BLAKE_64
  #define SPH_COMPACT_BLAKE_64 0
#endif
#ifndef SPH_LUFFA_PARALLEL
  #define SPH_LUFFA_PARALLEL 0
#endif
#ifndef SPH_KECCAK_UNROLL
  #define SPH_KECCAK_UNROLL 0
#endif
#define SPH_HAMSI_EXPAND_BIG 1

#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

ulong FAST_ROTL64_LO(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x, x.s10, 32 - y))); }
ulong FAST_ROTL64_HI(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x.s10, x, 32 - (y - 32)))); }
ulong ROTL64_1(const uint2 vv, const int r) { return as_ulong(amd_bitalign((vv).xy, (vv).yx, 32 - r)); }
ulong ROTL64_2(const uint2 vv, const int r) { return as_ulong((amd_bitalign((vv).yx, (vv).xy, 64 - r))); }

#include "blake.cl"
#include "wolf-bmw.cl"
#include "wolf-groestl.cl"
//#include "keccak.cl"
#include "wolf-cubehash.cl"
#include "wolf-aes.cl"
#include "simd-f.cl"
#include "echo-f.cl"
#include "hamsi.cl"
#include "wolf-shabal.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC32E(x) (x)
  #define DEC64BE(x) (*(const __global sph_u64 *) (x))
  #define DEC32LE(x) SWAP4(*(const __global sph_u32 *) (x))
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC32E(x) SWAP4(x)
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x))
  #define DEC32LE(x) (*(const __global sph_u32 *) (x))
#endif

#define ENC64E DEC64E
#define ENC32E DEC32E
#define ENC32E DEC32E


typedef union {
  unsigned char h1[64];
  uint h4[16];
  ulong h8[8];
} hash_t;

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global unsigned char* block, __global hash_t* hashes)
{
    uint gid = get_global_id(0);
    __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // blake

  sph_u64 V0 = BLAKE_IV512[0], V1 = BLAKE_IV512[1], V2 = BLAKE_IV512[2], V3 = BLAKE_IV512[3];
  sph_u64 V4 = BLAKE_IV512[4], V5 = BLAKE_IV512[5], V6 = BLAKE_IV512[6], V7 = BLAKE_IV512[7];
  sph_u64 V8 = CB0, V9 = CB1, VA = CB2, VB = CB3;
  sph_u64 VC = 0x452821E638D011F7UL, VD = 0xBE5466CF34E90EECUL, VE = CB6, VF = CB7;

  sph_u64 M0, M1, M2, M3, M4, M5, M6, M7;
  sph_u64 M8, M9, MA, MB, MC, MD, ME, MF;

  M0 = DEC64BE(block + 0);
  M1 = DEC64BE(block + 8);
  M2 = DEC64BE(block + 16);
  M3 = DEC64BE(block + 24);
  M4 = DEC64BE(block + 32);
  M5 = DEC64BE(block + 40);
  M6 = DEC64BE(block + 48);
  M7 = DEC64BE(block + 56);
  M8 = DEC64BE(block + 64);
  M9 = DEC64BE(block + 72);
  M9 &= 0xFFFFFFFF00000000;
  M9 ^= SWAP4(gid);
  MA = 0x8000000000000000;
  MB = 0;
  MC = 0;
  MD = 1;
  ME = 0;
  MF = 0x280;

  bool flag = false;
	rnds:
	ROUND_B(0);
	ROUND_B(1);
	ROUND_B(2);
	ROUND_B(3);
	ROUND_B(4);
	ROUND_B(5);
	if(flag) goto end;
	ROUND_B(6);
	ROUND_B(7);
	ROUND_B(8);
	ROUND_B(9);
	flag = true;
	goto rnds;

	end:

  hash->h8[0] = SWAP8(V0 ^ V8 ^ BLAKE_IV512[0]);
  hash->h8[1] = SWAP8(V1 ^ V9 ^ BLAKE_IV512[1]);
  hash->h8[2] = SWAP8(V2 ^ VA ^ BLAKE_IV512[2]);
  hash->h8[3] = SWAP8(V3 ^ VB ^ BLAKE_IV512[3]);
  hash->h8[4] = SWAP8(V4 ^ VC ^ BLAKE_IV512[4]);
  hash->h8[5] = SWAP8(V5 ^ VD ^ BLAKE_IV512[5]);
  hash->h8[6] = SWAP8(V6 ^ VE ^ BLAKE_IV512[6]);
  hash->h8[7] = SWAP8(V7 ^ VF ^ BLAKE_IV512[7]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
{
  ulong msg[16] = { 0 };
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);	

	#pragma unroll
	for(int i = 0; i < 8; ++i) msg[i] = hash->h8[i];

	msg[8] = 0x80UL;
	msg[15] = 512UL;
	
	#pragma unroll
	for(int i = 0; i < 2; ++i)
	{
		ulong h[16];
		for(int x = 0; x < 16; ++x) h[x] = ((i) ? BMW512_FINAL[x] : BMW512_IV[x]);
		BMW_Compression(msg, h);
	}
	
	#pragma unroll
	for(int i = 0; i < 8; ++i) hash->h8[i] = msg[i + 8];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global hash_t* hashes)
{
	uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  __local uint AES0[256];
  for(int i = get_local_id(0), step = get_local_size(0); i < 256; i += step)
    AES0[i] = AES0_C[i];

  volatile uint4 W0, W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12, W13, W14, W15;

    uint4 a, b, c, d;
    uint4 ab; 
    uint4 bc; 
    uint4 cd; 
    uint4 t1; 
    uint4 t2; 
    uint4 t3; 
    uint4 abx;
    uint4 bcx;
    uint4 cdx;
    uint4 tmp;
  // Precomp
  W0 = (uint4)(0xe7e9f5f5, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W1 = (uint4)(0x14b8a457, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W2 = (uint4)(0xdbfde1dd, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W3 = (uint4)(0x9ac2dea3, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W4 = (uint4)(0x65978b09, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W5 = (uint4)(0xa4213d7e, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W6 = (uint4)(0x265f4382, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W7 = (uint4)(0x34514d9e, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W12 = (uint4)(0xb134347e, 0xea6f7e7e, 0xbd7731bd, 0x8a8a1968);
  W13 = (uint4)(0x579f9f33, 0xfbfbfbfb, 0xfbfbfbfb, 0xefefd3c7);
  W14 = (uint4)(0x2cb6b661, 0x6b23b3b3, 0xcf93a7cf, 0x9d9d3751);
  W15 = (uint4)(0x01425eb8, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);

  //((uint16 *)W)[2] = vload16(0, hash->h4);
  W8.x = hash->h4[0];
  W8.y = hash->h4[1];
  W8.z = hash->h4[2];
  W8.w = hash->h4[3];
  W9.x = hash->h4[4];
  W9.y = hash->h4[5];
  W9.z = hash->h4[6];
  W9.w = hash->h4[7];
  W10.x = hash->h4[8];
  W10.y = hash->h4[9];
  W10.z = hash->h4[10];
  W10.w = hash->h4[11];
  W11.x = hash->h4[12];
  W11.y = hash->h4[13];
  W11.z = hash->h4[14];
  W11.w = hash->h4[15];

  barrier(CLK_LOCAL_MEM_FENCE);

  tmp = Echo_AES_Round_Small(AES0, W8);
  tmp.s0 ^= 8 | 0x200;
  W8 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W9);
  tmp.s0 ^= 9 | 0x200;
  W9 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W10);
  tmp.s0 ^= 10 | 0x200;
  W10 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W11);
  tmp.s0 ^= 11 | 0x200;
  W11 = Echo_AES_Round_Small(AES0, tmp);

  BigShiftRows(W);
  BigMixColumns(W);

  #pragma unroll 1
  for(uint k0 = 16; k0 < 160; k0 += 16) {
      BigSubBytesSmall(AES0, W, k0);
      BigShiftRows(W);
      BigMixColumns(W);
  }

  //#pragma unroll
  //for(int i = 0; i < 4; ++i)
  //  vstore4(vload4(i, hash->h4) ^ W[i] ^ W[i + 8] ^ (uint4)(512, 0, 0, 0), i, hash->h4);
 hash->h4[0 ] = hash->h4[0]  ^ W0.x ^ W8.x  ^ 512;
 hash->h4[1 ] = hash->h4[1]  ^ W0.y ^ W8.y  ^ 0;
 hash->h4[2 ] = hash->h4[2]  ^ W0.z ^ W8.z  ^ 0;
 hash->h4[3 ] = hash->h4[3]  ^ W0.w ^ W8.w  ^ 0;
 hash->h4[4 ] = hash->h4[4]  ^ W1.x ^ W9.x  ^ 512;
 hash->h4[5 ] = hash->h4[5]  ^ W1.y ^ W9.y  ^ 0;
 hash->h4[6 ] = hash->h4[6]  ^ W1.z ^ W9.z  ^ 0;
 hash->h4[7 ] = hash->h4[7]  ^ W1.w ^ W9.w  ^ 0;
 hash->h4[8 ] = hash->h4[8]  ^ W2.x ^ W10.x ^ 512;
 hash->h4[9 ] = hash->h4[9]  ^ W2.y ^ W10.y ^ 0;
 hash->h4[10] = hash->h4[10] ^ W2.z ^ W10.z ^ 0;
 hash->h4[11] = hash->h4[11] ^ W2.w ^ W10.w ^ 0;
 hash->h4[12] = hash->h4[12] ^ W3.x ^ W11.x ^ 512;
 hash->h4[13] = hash->h4[13] ^ W3.y ^ W11.y ^ 0;
 hash->h4[14] = hash->h4[14] ^ W3.z ^ W11.z ^ 0;
 hash->h4[15] = hash->h4[15] ^ W3.w ^ W11.w ^ 0;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search3(__global hash_t* hashes)
{
	uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

	// shabal
	uint16 A, B, C, M;
	uint Wlow = 1;
	
	A.s0 = A_init_512[0];
	A.s1 = A_init_512[1];
	A.s2 = A_init_512[2];
	A.s3 = A_init_512[3];
	A.s4 = A_init_512[4];
	A.s5 = A_init_512[5];
	A.s6 = A_init_512[6];
	A.s7 = A_init_512[7];
	A.s8 = A_init_512[8];
	A.s9 = A_init_512[9];
	A.sa = A_init_512[10];
	A.sb = A_init_512[11];
	
	B = vload16(0, B_init_512);
	C = vload16(0, C_init_512);
	M = vload16(0, hash->h4);
	
	// INPUT_BLOCK_ADD
	B += M;
	
	// XOR_W
	//do { A.s0 ^= Wlow; } while(0);
	A.s0 ^= Wlow;
	
	// APPLY_P
	B = rotate(B, 17U);
	SHABAL_PERM_V;
	
	uint16 tmpC1, tmpC2, tmpC3;
	
	tmpC1 = shuffle2(C, (uint16)0, (uint16)(11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 17, 17, 17, 17));
	tmpC2 = shuffle2(C, (uint16)0, (uint16)(15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 17, 17, 17, 17));
	tmpC3 = shuffle2(C, (uint16)0, (uint16)(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 17, 17, 17, 17));
	
	A += tmpC1 + tmpC2 + tmpC3;
		
	// INPUT_BLOCK_SUB
	C -= M;
	
	++Wlow;
	M = 0;
	M.s0 = 0x80;
	
	#pragma unroll 2
	for(int i = 0; i < 4; ++i)
	{
		SWAP_BC_V;
		
		// INPUT_BLOCK_ADD
		B.s0 = select(B.s0, B.s0 += M.s0, i==0);
		
		// XOR_W;
		A.s0 ^= Wlow;
		
		// APPLY_P
		B = rotate(B, 17U);
		SHABAL_PERM_V;
		
		if(i == 3) break;
		
		tmpC1 = shuffle2(C, (uint16)0, (uint16)(11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 17, 17, 17, 17));
		tmpC2 = shuffle2(C, (uint16)0, (uint16)(15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 17, 17, 17, 17));
		tmpC3 = shuffle2(C, (uint16)0, (uint16)(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 17, 17, 17, 17));
	
		A += tmpC1 + tmpC2 + tmpC3;
	}
	
	vstore16(B, 0, hash->h4);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  __local ulong T0[256], T1[256], T2[256], T3[256];
	
	#pragma unroll
	for(int i = get_local_id(0); i < 256; i += WORKSIZE)
	{
		const ulong tmp = T0_G[i];
		T0[i] = tmp;
		T1[i] = rotate(tmp, 8UL);
		T2[i] = rotate(tmp, 16UL);
		T3[i] = rotate(tmp, 24UL);
	}
	
	barrier(CLK_LOCAL_MEM_FENCE);
  volatile ulong M_0  = 0;
  volatile ulong M_1  = 0;
  volatile ulong M_2  = 0;
  volatile ulong M_3  = 0;
  volatile ulong M_4  = 0;
  volatile ulong M_5  = 0;
  volatile ulong M_6  = 0;
  volatile ulong M_7  = 0;
  volatile ulong M_8  = 0;
  volatile ulong M_9  = 0;
  volatile ulong M_10 = 0;
  volatile ulong M_11 = 0;
  volatile ulong M_12 = 0;
  volatile ulong M_13 = 0;
  volatile ulong M_14 = 0;
  volatile ulong M_15 = 0;
  volatile ulong G_0 ;
  volatile ulong G_1 ;
  volatile ulong G_2 ;
  volatile ulong G_3 ;
  volatile ulong G_4 ;
  volatile ulong G_5 ;
  volatile ulong G_6 ;
  volatile ulong G_7 ;
  volatile ulong G_8 ;
  volatile ulong G_9 ;
  volatile ulong G_10;
  volatile ulong G_11;
  volatile ulong G_12;
  volatile ulong G_13;
  volatile ulong G_14;
  volatile ulong G_15;

  ulong H[16], H2[16];

  M_0 = hash->h8[0];
  M_1 = hash->h8[1];
  M_2 = hash->h8[2];
  M_3 = hash->h8[3];
  M_4 = hash->h8[4];
  M_5 = hash->h8[5];
  M_6 = hash->h8[6];
  M_7 = hash->h8[7];
	
	M_8 = 0x80UL;
	M_15 = 0x0100000000000000UL;

  G_0  = M_0 ;
  G_1  = M_1 ;
  G_2  = M_2 ;
  G_3  = M_3 ;
  G_4  = M_4 ;
  G_5  = M_5 ;
  G_6  = M_6 ;
  G_7  = M_7 ;
  G_8  = M_8 ;
  G_9  = M_9 ;
  G_10 = M_10;
  G_11 = M_11;
  G_12 = M_12;
  G_13 = M_13;
  G_14 = M_14;
  G_15 = M_15;
	
	G_15 ^= 0x0002000000000000UL;
	
	#pragma nounroll
	for(int i = 0; i < 14; ++i)
	{
    H[0 ] = G_0  ^ PC64(0  << 4, i);
    H[1 ] = G_1  ^ PC64(1  << 4, i);
    H[2 ] = G_2  ^ PC64(2  << 4, i);
    H[3 ] = G_3  ^ PC64(3  << 4, i);
    H[4 ] = G_4  ^ PC64(4  << 4, i);
    H[5 ] = G_5  ^ PC64(5  << 4, i);
    H[6 ] = G_6  ^ PC64(6  << 4, i);
    H[7 ] = G_7  ^ PC64(7  << 4, i);
    H[8 ] = G_8  ^ PC64(8  << 4, i);
    H[9 ] = G_9  ^ PC64(9  << 4, i);
    H[10] = G_10 ^ PC64(10 << 4, i);
    H[11] = G_11 ^ PC64(11 << 4, i);
    H[12] = G_12 ^ PC64(12 << 4, i);
    H[13] = G_13 ^ PC64(13 << 4, i);
    H[14] = G_14 ^ PC64(14 << 4, i);
    H[15] = G_15 ^ PC64(15 << 4, i);

    H2[0 ] = M_0  ^ QC64(0  << 4, i);
    H2[1 ] = M_1  ^ QC64(1  << 4, i);
    H2[2 ] = M_2  ^ QC64(2  << 4, i);
    H2[3 ] = M_3  ^ QC64(3  << 4, i);
    H2[4 ] = M_4  ^ QC64(4  << 4, i);
    H2[5 ] = M_5  ^ QC64(5  << 4, i);
    H2[6 ] = M_6  ^ QC64(6  << 4, i);
    H2[7 ] = M_7  ^ QC64(7  << 4, i);
    H2[8 ] = M_8  ^ QC64(8  << 4, i);
    H2[9 ] = M_9  ^ QC64(9  << 4, i);
    H2[10] = M_10 ^ QC64(10 << 4, i);
    H2[11] = M_11 ^ QC64(11 << 4, i);
    H2[12] = M_12 ^ QC64(12 << 4, i);
    H2[13] = M_13 ^ QC64(13 << 4, i);
    H2[14] = M_14 ^ QC64(14 << 4, i);
    H2[15] = M_15 ^ QC64(15 << 4, i);
		
		GROESTL_RBTT(G_0, H, 0, 1, 2, 3, 4, 5, 6, 11);
		GROESTL_RBTT(G_1, H, 1, 2, 3, 4, 5, 6, 7, 12);
		GROESTL_RBTT(G_2, H, 2, 3, 4, 5, 6, 7, 8, 13);
		GROESTL_RBTT(G_3, H, 3, 4, 5, 6, 7, 8, 9, 14);
		GROESTL_RBTT(G_4, H, 4, 5, 6, 7, 8, 9, 10, 15);
		GROESTL_RBTT(G_5, H, 5, 6, 7, 8, 9, 10, 11, 0);
		GROESTL_RBTT(G_6, H, 6, 7, 8, 9, 10, 11, 12, 1);
		GROESTL_RBTT(G_7, H, 7, 8, 9, 10, 11, 12, 13, 2);
		GROESTL_RBTT(G_8, H, 8, 9, 10, 11, 12, 13, 14, 3);
		GROESTL_RBTT(G_9, H, 9, 10, 11, 12, 13, 14, 15, 4);
		GROESTL_RBTT(G_10, H, 10, 11, 12, 13, 14, 15, 0, 5);
		GROESTL_RBTT(G_11, H, 11, 12, 13, 14, 15, 0, 1, 6);
		GROESTL_RBTT(G_12, H, 12, 13, 14, 15, 0, 1, 2, 7);
		GROESTL_RBTT(G_13, H, 13, 14, 15, 0, 1, 2, 3, 8);
		GROESTL_RBTT(G_14, H, 14, 15, 0, 1, 2, 3, 4, 9);
		GROESTL_RBTT(G_15, H, 15, 0, 1, 2, 3, 4, 5, 10);
		
		GROESTL_RBTT(M_0, H2, 1, 3, 5, 11, 0, 2, 4, 6);
		GROESTL_RBTT(M_1, H2, 2, 4, 6, 12, 1, 3, 5, 7);
		GROESTL_RBTT(M_2, H2, 3, 5, 7, 13, 2, 4, 6, 8);
		GROESTL_RBTT(M_3, H2, 4, 6, 8, 14, 3, 5, 7, 9);
		GROESTL_RBTT(M_4, H2, 5, 7, 9, 15, 4, 6, 8, 10);
		GROESTL_RBTT(M_5, H2, 6, 8, 10, 0, 5, 7, 9, 11);
		GROESTL_RBTT(M_6, H2, 7, 9, 11, 1, 6, 8, 10, 12);
		GROESTL_RBTT(M_7, H2, 8, 10, 12, 2, 7, 9, 11, 13);
		GROESTL_RBTT(M_8, H2, 9, 11, 13, 3, 8, 10, 12, 14);
		GROESTL_RBTT(M_9, H2, 10, 12, 14, 4, 9, 11, 13, 15);
		GROESTL_RBTT(M_10, H2, 11, 13, 15, 5, 10, 12, 14, 0);
		GROESTL_RBTT(M_11, H2, 12, 14, 0, 6, 11, 13, 15, 1);
		GROESTL_RBTT(M_12, H2, 13, 15, 1, 7, 12, 14, 0, 2);
		GROESTL_RBTT(M_13, H2, 14, 0, 2, 8, 13, 15, 1, 3);
		GROESTL_RBTT(M_14, H2, 15, 1, 3, 9, 14, 0, 2, 4);
		GROESTL_RBTT(M_15, H2, 0, 2, 4, 10, 15, 1, 3, 5);
	}
	
  G_0  ^= M_0 ;
  G_1  ^= M_1 ;
  G_2  ^= M_2 ;
  G_3  ^= M_3 ;
  G_4  ^= M_4 ;
  G_5  ^= M_5 ;
  G_6  ^= M_6 ;
  G_7  ^= M_7 ;
  G_8  ^= M_8 ;
  G_9  ^= M_9 ;
  G_10 ^= M_10;
  G_11 ^= M_11;
  G_12 ^= M_12;
  G_13 ^= M_13;
  G_14 ^= M_14;
  G_15 ^= M_15;

	G_15 ^= 0x0002000000000000UL;
	
	//((ulong8 *)M)[0] = ((ulong8 *)G)[1];
  M_0  = G_8 ;
  M_1  = G_9 ;
  M_2  = G_10;
  M_3  = G_11;
  M_4  = G_12;
  M_5  = G_13;
  M_6  = G_14;
  M_7  = G_15;
	
	#pragma nounroll
	for(int i = 0; i < 14; ++i)
	{

    H[0 ] = G_0  ^ PC64(0  << 4, i);
    H[1 ] = G_1  ^ PC64(1  << 4, i);
    H[2 ] = G_2  ^ PC64(2  << 4, i);
    H[3 ] = G_3  ^ PC64(3  << 4, i);
    H[4 ] = G_4  ^ PC64(4  << 4, i);
    H[5 ] = G_5  ^ PC64(5  << 4, i);
    H[6 ] = G_6  ^ PC64(6  << 4, i);
    H[7 ] = G_7  ^ PC64(7  << 4, i);
    H[8 ] = G_8  ^ PC64(8  << 4, i);
    H[9 ] = G_9  ^ PC64(9  << 4, i);
    H[10] = G_10 ^ PC64(10 << 4, i);
    H[11] = G_11 ^ PC64(11 << 4, i);
    H[12] = G_12 ^ PC64(12 << 4, i);
    H[13] = G_13 ^ PC64(13 << 4, i);
    H[14] = G_14 ^ PC64(14 << 4, i);
    H[15] = G_15 ^ PC64(15 << 4, i);
			
		GROESTL_RBTT(G_0, H, 0, 1, 2, 3, 4, 5, 6, 11);
		GROESTL_RBTT(G_1, H, 1, 2, 3, 4, 5, 6, 7, 12);
		GROESTL_RBTT(G_2, H, 2, 3, 4, 5, 6, 7, 8, 13);
		GROESTL_RBTT(G_3, H, 3, 4, 5, 6, 7, 8, 9, 14);
		GROESTL_RBTT(G_4, H, 4, 5, 6, 7, 8, 9, 10, 15);
		GROESTL_RBTT(G_5, H, 5, 6, 7, 8, 9, 10, 11, 0);
		GROESTL_RBTT(G_6, H, 6, 7, 8, 9, 10, 11, 12, 1);
		GROESTL_RBTT(G_7, H, 7, 8, 9, 10, 11, 12, 13, 2);
		GROESTL_RBTT(G_8, H, 8, 9, 10, 11, 12, 13, 14, 3);
		GROESTL_RBTT(G_9, H, 9, 10, 11, 12, 13, 14, 15, 4);
		GROESTL_RBTT(G_10, H, 10, 11, 12, 13, 14, 15, 0, 5);
		GROESTL_RBTT(G_11, H, 11, 12, 13, 14, 15, 0, 1, 6);
		GROESTL_RBTT(G_12, H, 12, 13, 14, 15, 0, 1, 2, 7);
		GROESTL_RBTT(G_13, H, 13, 14, 15, 0, 1, 2, 3, 8);
		GROESTL_RBTT(G_14, H, 14, 15, 0, 1, 2, 3, 4, 9);
		GROESTL_RBTT(G_15, H, 15, 0, 1, 2, 3, 4, 5, 10);
	}
	
	//vstore8((((ulong8 *)M)[0] ^ ((ulong8 *)G)[1]), 0, hash->h8);
  hash->h8[0] = M_0 ^ G_8;
  hash->h8[1] = M_1 ^ G_9;
  hash->h8[2] = M_2 ^ G_10;
  hash->h8[3] = M_3 ^ G_11;
  hash->h8[4] = M_4 ^ G_12;
  hash->h8[5] = M_5 ^ G_13;
  hash->h8[6] = M_6 ^ G_14;
  hash->h8[7] = M_7 ^ G_15;
  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global hash_t* hashes)
{
	uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // cubehash.h1

  uint state[32] = {   0x2AEA2A61U, 0x50F494D4U, 0x2D538B8BU, 0x4167D83EU, 0x3FEE2313U, 0xC701CF8CU,
            0xCC39968EU, 0x50AC5695U, 0x4D42C787U, 0xA647A8B3U, 0x97CF0BEFU, 0x825B4537U,
            0xEEF864D2U, 0xF22090C4U, 0xD0E5CD33U, 0xA23911AEU, 0xFCD398D9U, 0x148FE485U,
            0x1B017BEFU, 0xB6444532U, 0x6A536159U, 0x2FF5781CU, 0x91FA7934U, 0x0DBADEA9U,
            0xD65C8A2BU, 0xA5A70E75U, 0xB1C62456U, 0xBC796576U, 0x1921C8F7U, 0xE7989AF1U, 
            0x7795D246U, 0xD43E3B44U };

  ((ulong4 *)state)[0] ^= vload4(0, hash->h8);
  ulong4 xor = vload4(1, hash->h8);

  #pragma unroll 2
  for(int i = 0; i < 14; ++i)
  {
    #pragma unroll 4
    for(int x = 0; x < 8; ++x)
    {
      CubeHashEvenRound(state);
      CubeHashOddRound(state);
    }

    if(i == 12)
    {
      vstore8(((ulong8 *)state)[0], 0, hash->h8);
      break;
    }
    if(!i) ((ulong4 *)state)[0] ^= xor;
    state[0] ^= (i == 1) ? 0x80 : 0;
    state[31] ^= (i == 2) ? 1 : 0;
  }

  mem_fence(CLK_GLOBAL_MEM_FENCE);
}

#define KECCAKF_1600_RNDC_0		(uint2)(0x00000001,0x00000000)
#define KECCAKF_1600_RNDC_1		(uint2)(0x00008082,0x00000000)
#define KECCAKF_1600_RNDC_2		(uint2)(0x0000808a,0x80000000)
#define KECCAKF_1600_RNDC_3		(uint2)(0x80008000,0x80000000)
#define KECCAKF_1600_RNDC_4		(uint2)(0x0000808b,0x00000000)
#define KECCAKF_1600_RNDC_5		(uint2)(0x80000001,0x00000000)
#define KECCAKF_1600_RNDC_6		(uint2)(0x80008081,0x80000000)
#define KECCAKF_1600_RNDC_7		(uint2)(0x00008009,0x80000000)
#define KECCAKF_1600_RNDC_8		(uint2)(0x0000008a,0x00000000)
#define KECCAKF_1600_RNDC_9		(uint2)(0x00000088,0x00000000)
#define KECCAKF_1600_RNDC_10	(uint2)(0x80008009,0x00000000)
#define KECCAKF_1600_RNDC_11	(uint2)(0x8000000a,0x00000000)
#define KECCAKF_1600_RNDC_12	(uint2)(0x8000808b,0x00000000)
#define KECCAKF_1600_RNDC_13	(uint2)(0x0000008b,0x80000000)
#define KECCAKF_1600_RNDC_14	(uint2)(0x00008089,0x80000000)
#define KECCAKF_1600_RNDC_15	(uint2)(0x00008003,0x80000000)
#define KECCAKF_1600_RNDC_16	(uint2)(0x00008002,0x80000000)
#define KECCAKF_1600_RNDC_17	(uint2)(0x00000080,0x80000000)
#define KECCAKF_1600_RNDC_18	(uint2)(0x0000800a,0x00000000)
#define KECCAKF_1600_RNDC_19	(uint2)(0x8000000a,0x80000000)
#define KECCAKF_1600_RNDC_20	(uint2)(0x80008081,0x80000000)
#define KECCAKF_1600_RNDC_21	(uint2)(0x00008080,0x80000000)
#define KECCAKF_1600_RNDC_22	(uint2)(0x80000001,0x00000000)
#define KECCAKF_1600_RNDC_23	(uint2)(0x80008008,0x80000000)


#define ROTL64_1_K(x, y) amd_bitalign((x), (x).s10, 32 - (y))
#define ROTL64_2_K(x, y) amd_bitalign((x).s10, (x), 32 - (y))

#define RND(i) \
    m0 = s0 ^ s5 ^ s10 ^ s15 ^ s20 ^ ROTL64_1_K(s2 ^ s7 ^ s12 ^ s17 ^ s22, 1);\
    m1 = s1 ^ s6 ^ s11 ^ s16 ^ s21 ^ ROTL64_1_K(s3 ^ s8 ^ s13 ^ s18 ^ s23, 1);\
    m2 = s2 ^ s7 ^ s12 ^ s17 ^ s22 ^ ROTL64_1_K(s4 ^ s9 ^ s14 ^ s19 ^ s24, 1);\
    m3 = s3 ^ s8 ^ s13 ^ s18 ^ s23 ^ ROTL64_1_K(s0 ^ s5 ^ s10 ^ s15 ^ s20, 1);\
    m4 = s4 ^ s9 ^ s14 ^ s19 ^ s24 ^ ROTL64_1_K(s1 ^ s6 ^ s11 ^ s16 ^ s21, 1);\
\
    m5 = s1^m0;\
\
    s0 ^= m4;\
    s1 = ROTL64_2_K(s6^m0, 12);\
    s6 = ROTL64_1_K(s9^m3, 20);\
    s9 = ROTL64_2_K(s22^m1, 29);\
    s22 = ROTL64_2_K(s14^m3, 7);\
    s14 = ROTL64_1_K(s20^m4, 18);\
    s20 = ROTL64_2_K(s2^m1, 30);\
    s2 = ROTL64_2_K(s12^m1, 11);\
    s12 = ROTL64_1_K(s13^m2, 25);\
    s13 = ROTL64_1_K(s19^m3,  8);\
    s19 = ROTL64_2_K(s23^m2, 24);\
    s23 = ROTL64_2_K(s15^m4, 9);\
    s15 = ROTL64_1_K(s4^m3, 27);\
    s4 = ROTL64_1_K(s24^m3, 14);\
    s24 = ROTL64_1_K(s21^m0,  2);\
    s21 = ROTL64_2_K(s8^m2, 23);\
    s8 = ROTL64_2_K(s16^m0, 13);\
    s16 = ROTL64_2_K(s5^m4, 4);\
    s5 = ROTL64_1_K(s3^m2, 28);\
    s3 = ROTL64_1_K(s18^m2, 21);\
    s18 = ROTL64_1_K(s17^m1, 15);\
    s17 = ROTL64_1_K(s11^m0, 10);\
    s11 = ROTL64_1_K(s7^m1,  6);\
    s7 = ROTL64_1_K(s10^m4,  3);\
    s10 = ROTL64_1_K(m5,  1);\
    \
    m5 = s0; m6 = s1; s0 = bitselect(s0^s2,s0,s1); s1 = bitselect(s1^s3,s1,s2); s2 = bitselect(s2^s4,s2,s3); s3 = bitselect(s3^m5,s3,s4); s4 = bitselect(s4^m6,s4,m5);\
    m5 = s5; m6 = s6; s5 = bitselect(s5^s7,s5,s6); s6 = bitselect(s6^s8,s6,s7); s7 = bitselect(s7^s9,s7,s8); s8 = bitselect(s8^m5,s8,s9); s9 = bitselect(s9^m6,s9,m5);\
    m5 = s10; m6 = s11; s10 = bitselect(s10^s12,s10,s11); s11 = bitselect(s11^s13,s11,s12); s12 = bitselect(s12^s14,s12,s13); s13 = bitselect(s13^m5,s13,s14); s14 = bitselect(s14^m6,s14,m5);\
    m5 = s15; m6 = s16; s15 = bitselect(s15^s17,s15,s16); s16 = bitselect(s16^s18,s16,s17); s17 = bitselect(s17^s19,s17,s18); s18 = bitselect(s18^m5,s18,s19); s19 = bitselect(s19^m6,s19,m5);\
    m5 = s20; m6 = s21; s20 = bitselect(s20^s22,s20,s21); s21 = bitselect(s21^s23,s21,s22); s22 = bitselect(s22^s24,s22,s23); s23 = bitselect(s23^m5,s23,s24); s24 = bitselect(s24^m6,s24,m5);\
    s0 ^= KECCAKF_1600_RNDC_ ## i;

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search6(__global hash_t* hashes)
{
    uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  volatile uint2 s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13;
  volatile uint2 s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24;

  s0 = as_uint2(hash->h8[0]);
  s1 = as_uint2(hash->h8[1]);
  s2 = as_uint2(hash->h8[2]);
  s3 = as_uint2(hash->h8[3]);
  s4 = as_uint2(hash->h8[4]);
  s5 = as_uint2(hash->h8[5]);
  s6 = as_uint2(hash->h8[6]);
  s7 = as_uint2(hash->h8[7]);
  s8 = (uint2)(1, 0x80000000U);
  s9 = s10 = s11 = s12 = s13 = s14 = s15 = s16 = 0;
  s17 = s18 = s19 = s20 = s21 = s22 = s23 = s24 = 0;

  volatile uint2 m0, m1, m2, m3, m4, m5, m6;

  RND(0);
  RND(1);
  RND(2);
  RND(3);
  RND(4);
  RND(5);
  RND(6);
  RND(7);
  RND(8);
  RND(9);
  RND(10);
  RND(11);
  RND(12);
  RND(13);
  RND(14);
  RND(15);
  RND(16);
  RND(17);
  RND(18);
  RND(19);
  RND(20);
  RND(21);
  RND(22);

  m0 = s0 ^ s5 ^ s10 ^ s15 ^ s20 ^ ROTL64_1_K(s2 ^ s7 ^ s12 ^ s17 ^ s22, 1);
  m1 = s1 ^ s6 ^ s11 ^ s16 ^ s21 ^ ROTL64_1_K(s3 ^ s8 ^ s13 ^ s18 ^ s23, 1);
  m2 = s2 ^ s7 ^ s12 ^ s17 ^ s22 ^ ROTL64_1_K(s4 ^ s9 ^ s14 ^ s19 ^ s24, 1);
  m3 = s3 ^ s8 ^ s13 ^ s18 ^ s23 ^ ROTL64_1_K(s0 ^ s5 ^ s10 ^ s15 ^ s20, 1);
  m4 = s4 ^ s9 ^ s14 ^ s19 ^ s24 ^ ROTL64_1_K(s1 ^ s6 ^ s11 ^ s16 ^ s21, 1);

  s0 ^= m4;
  s1 = ROTL64_2_K(s6  ^ m0, 12);
  s6 = ROTL64_1_K(s9  ^ m3, 20);
  s9 = ROTL64_2_K(s22 ^ m1, 29);
  s2 = ROTL64_2_K(s12 ^ m1, 11);
  s4 = ROTL64_1_K(s24 ^ m3, 14);
  s8 = ROTL64_2_K(s16 ^ m0, 13);
  s5 = ROTL64_1_K(s3  ^ m2, 28);
  s3 = ROTL64_1_K(s18 ^ m2, 21);
  s7 = ROTL64_1_K(s10 ^ m4,  3);

  m5 = s0; m6 = s1; s0 = bitselect(s0^s2,s0,s1); s1 = bitselect(s1^s3,s1,s2); s2 = bitselect(s2^s4,s2,s3); s3 = bitselect(s3^m5,s3,s4); s4 = bitselect(s4^m6,s4,m5);
  s5 = bitselect(s5^s7,s5,s6); s6 = bitselect(s6^s8,s6,s7); s7 = bitselect(s7^s9,s7,s8);

  s0 ^= KECCAKF_1600_RNDC_23;

  hash->h8[0] = as_ulong(s0);
  hash->h8[1] = as_ulong(s1);
  hash->h8[2] = as_ulong(s2);
  hash->h8[3] = as_ulong(s3);
  hash->h8[4] = as_ulong(s4);
  hash->h8[5] = as_ulong(s5);
  hash->h8[6] = as_ulong(s6);
  hash->h8[7] = as_ulong(s7);

  barrier(CLK_GLOBAL_MEM_FENCE);	
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search7(__global hash_t* hashes)
{
	uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  #ifdef INPUT_BIG_LOCAL
  #define CALL_INPUT_BIG_LOCAL INPUT_BIG_LOCAL
    __local sph_u32 T512_L[1024];
    __constant const sph_u32 *T512_C = &T512[0][0];

    int init = get_local_id(0);
    int step = get_local_size(0);
    for (int i = init; i < 1024; i += step)
      T512_L[i] = T512_C[i];

    barrier(CLK_LOCAL_MEM_FENCE);
  #else
    #define CALL_INPUT_BIG_LOCAL INPUT_BIG
  #endif

  volatile sph_u32 c0 = HAMSI_IV512[0], c1 = HAMSI_IV512[1], c2 = HAMSI_IV512[2], c3 = HAMSI_IV512[3];
  volatile sph_u32 c4 = HAMSI_IV512[4], c5 = HAMSI_IV512[5], c6 = HAMSI_IV512[6], c7 = HAMSI_IV512[7];
  volatile sph_u32 c8 = HAMSI_IV512[8], c9 = HAMSI_IV512[9], cA = HAMSI_IV512[10], cB = HAMSI_IV512[11];
  volatile sph_u32 cC = HAMSI_IV512[12], cD = HAMSI_IV512[13], cE = HAMSI_IV512[14], cF = HAMSI_IV512[15];
  volatile sph_u32 m0, m1, m2, m3, m4, m5, m6, m7;
  volatile sph_u32 m8, m9, mA, mB, mC, mD, mE, mF;
  sph_u32 h[16] = { c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, cA, cB, cC, cD, cE, cF };

  #define buf(u) hash->h1[i + u]

  for(int i = 0; i < 64; i += 8) {
    CALL_INPUT_BIG_LOCAL;
    P_BIG;
    T_BIG;
  }

  #undef buf
  #undef CALL_INPUT_BIG_LOCAL

  #ifdef INPUT_BIG_LOCAL
    __local sph_u32 *tp = &(T512_L[0]);
  #else
    __constant const sph_u32 *tp = &T512[0][0];
  #endif

  m0 = tp[0x70]; m1 = tp[0x71];
  m2 = tp[0x72]; m3 = tp[0x73];
  m4 = tp[0x74]; m5 = tp[0x75];
  m6 = tp[0x76]; m7 = tp[0x77];
  m8 = tp[0x78]; m9 = tp[0x79];
  mA = tp[0x7A]; mB = tp[0x7B];
  mC = tp[0x7C]; mD = tp[0x7D];
  mE = tp[0x7E]; mF = tp[0x7F];

  P_BIG;
  T_BIG;

  m0 = tp[0x310]; m1 = tp[0x311];
  m2 = tp[0x312]; m3 = tp[0x313];
  m4 = tp[0x314]; m5 = tp[0x315];
  m6 = tp[0x316]; m7 = tp[0x317];
  m8 = tp[0x318]; m9 = tp[0x319];
  mA = tp[0x31A]; mB = tp[0x31B];
  mC = tp[0x31C]; mD = tp[0x31D];
  mE = tp[0x31E]; mF = tp[0x31F];

  PF_BIG;
  T_BIG;
  
  #pragma unroll
  for (unsigned u = 0; u < 16; u ++)
    hash->h4[u] = ENC32E(h[u]);


  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search8(__global hash_t* hashes, __global uint* output, const ulong target)
{
	 uint gid = get_global_id(0);
    __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

    // simd
    volatile s32 q[256];
    __local unsigned char x[128 * WORKSIZE];
    uint tid = get_local_id(0);
    for(unsigned int i = 0; i < 64; i++)
  x[tid + WORKSIZE * i] = hash->h1[i];
    for(unsigned int i = 64; i < 128; i++)
  x[tid + WORKSIZE * i] = 0;

    __private volatile s32 m;
    __private volatile s32 n;
    __private volatile s32 t;
    __private volatile u32 tA0;
    __private volatile u32 tA1;
    __private volatile u32 tA2;
    __private volatile u32 tA3;
    __private volatile u32 tA4;
    __private volatile u32 tA5;
    __private volatile u32 tA6;
    __private volatile u32 tA7;
    s32 d1_0, d1_1, d1_2, d1_3, d1_4, d1_5, d1_6, d1_7;
    s32 d2_0, d2_1, d2_2, d2_3, d2_4, d2_5, d2_6, d2_7;
    s32 x0;
    s32 x1;
    s32 x2;
    s32 x3;
    s32 a0;
    s32 a1;
    s32 a2;
    s32 a3;
    s32 b0;
    s32 b1;
    s32 b2;
    s32 b3;

    u32 A0 = C32(0x0BA16B95), A1 = C32(0x72F999AD), A2 = C32(0x9FECC2AE), A3 = C32(0xBA3264FC), A4 = C32(0x5E894929), A5 = C32(0x8E9F30E5), A6 = C32(0x2F1DAA37), A7 = C32(0xF0F2C558);
    u32 B0 = C32(0xAC506643), B1 = C32(0xA90635A5), B2 = C32(0xE25B878B), B3 = C32(0xAAB7878F), B4 = C32(0x88817F7A), B5 = C32(0x0A02892B), B6 = C32(0x559A7550), B7 = C32(0x598F657E);
    u32 C0 = C32(0x7EEF60A1), C1 = C32(0x6B70E3E8), C2 = C32(0x9C1714D1), C3 = C32(0xB958E2A8), C4 = C32(0xAB02675E), C5 = C32(0xED1C014F), C6 = C32(0xCD8D65BB), C7 = C32(0xFDB7A257);
    u32 D0 = C32(0x09254899), D1 = C32(0xD699C7BC), D2 = C32(0x9019B6DC), D3 = C32(0x2B9022E4), D4 = C32(0x8FA14956), D5 = C32(0x21BF9BD3), D6 = C32(0xB94D0943), D7 = C32(0x6FFDDC22);

    FFT256(0, 1, 0, ll1);
	 #pragma unroll 256
    for (int i = 0; i < 256; i ++) {
	    const s32 tq = REDS1(REDS1(q[i] + yoff_b_n[i]));
		q[i] = select(tq - 257, tq, tq <= 128);
    }

    A0 ^= hash->h4[0];
    A1 ^= hash->h4[1];
    A2 ^= hash->h4[2];
    A3 ^= hash->h4[3];
    A4 ^= hash->h4[4];
    A5 ^= hash->h4[5];
    A6 ^= hash->h4[6];
    A7 ^= hash->h4[7];
    B0 ^= hash->h4[8];
    B1 ^= hash->h4[9];
    B2 ^= hash->h4[10];
    B3 ^= hash->h4[11];
    B4 ^= hash->h4[12];
    B5 ^= hash->h4[13];
    B6 ^= hash->h4[14];
    B7 ^= hash->h4[15];

    ONE_ROUND_BIG(0_, 0,  3, 23, 17, 27);
    ONE_ROUND_BIG(1_, 1, 28, 19, 22,  7);
    ONE_ROUND_BIG(2_, 2, 29,  9, 15,  5);
    ONE_ROUND_BIG(3_, 3,  4, 13, 10, 25);

    STEP_BIG(
        C32(0x0BA16B95), C32(0x72F999AD), C32(0x9FECC2AE), C32(0xBA3264FC),
        C32(0x5E894929), C32(0x8E9F30E5), C32(0x2F1DAA37), C32(0xF0F2C558),
        IF,  4, 13, PP8_4_);
    STEP_BIG(
        C32(0xAC506643), C32(0xA90635A5), C32(0xE25B878B), C32(0xAAB7878F),
        C32(0x88817F7A), C32(0x0A02892B), C32(0x559A7550), C32(0x598F657E),
        IF, 13, 10, PP8_5_);
    STEP_BIG(
        C32(0x7EEF60A1), C32(0x6B70E3E8), C32(0x9C1714D1), C32(0xB958E2A8),
        C32(0xAB02675E), C32(0xED1C014F), C32(0xCD8D65BB), C32(0xFDB7A257),
        IF, 10, 25, PP8_6_);
    STEP_BIG(
        C32(0x09254899), C32(0xD699C7BC), C32(0x9019B6DC), C32(0x2B9022E4),
        C32(0x8FA14956), C32(0x21BF9BD3), C32(0xB94D0943), C32(0x6FFDDC22),
        IF, 25,  4, PP8_0_);

    u32 COPY_A0 = A0, COPY_A1 = A1, COPY_A2 = A2, COPY_A3 = A3, COPY_A4 = A4, COPY_A5 = A5, COPY_A6 = A6, COPY_A7 = A7;
    u32 COPY_B0 = B0, COPY_B1 = B1, COPY_B2 = B2, COPY_B3 = B3, COPY_B4 = B4, COPY_B5 = B5, COPY_B6 = B6, COPY_B7 = B7;
    u32 COPY_C0 = C0, COPY_C1 = C1, COPY_C2 = C2, COPY_C3 = C3, COPY_C4 = C4, COPY_C5 = C5, COPY_C6 = C6, COPY_C7 = C7;
    u32 COPY_D0 = D0, COPY_D1 = D1, COPY_D2 = D2, COPY_D3 = D3, COPY_D4 = D4, COPY_D5 = D5, COPY_D6 = D6, COPY_D7 = D7;

    A0 ^= 0x200;

    ONE_ROUND_BIG_PRECOMP(0_, 0,  3, 23, 17, 27);
    ONE_ROUND_BIG_PRECOMP(1_, 1, 28, 19, 22,  7);
    ONE_ROUND_BIG_PRECOMP(2_, 2, 29,  9, 15,  5);
    ONE_ROUND_BIG_PRECOMP(3_, 3,  4, 13, 10, 25);
    STEP_BIG(
        COPY_A0, COPY_A1, COPY_A2, COPY_A3,
        COPY_A4, COPY_A5, COPY_A6, COPY_A7,
        IF,  4, 13, PP8_4_);
    STEP_BIG(
        COPY_B0, COPY_B1, COPY_B2, COPY_B3,
        COPY_B4, COPY_B5, COPY_B6, COPY_B7,
        IF, 13, 10, PP8_5_);
    STEP_BIG(
        COPY_C0, COPY_C1, COPY_C2, COPY_C3,
        COPY_C4, COPY_C5, COPY_C6, COPY_C7,
        IF, 10, 25, PP8_6_);
    STEP_BIG(
        COPY_D0, COPY_D1, COPY_D2, COPY_D3,
        COPY_D4, COPY_D5, COPY_D6, COPY_D7,
        IF, 25,  4, PP8_0_);

    hash->h4[0] = A0;
    hash->h4[1] = A1;
    hash->h4[2] = A2;
    hash->h4[3] = A3;
    hash->h4[4] = A4;
    hash->h4[5] = A5;
    hash->h4[6] = A6;
    hash->h4[7] = A7;
    hash->h4[8] = B0;
    hash->h4[9] = B1;
    hash->h4[10] = B2;
    hash->h4[11] = B3;
    hash->h4[12] = B4;
    hash->h4[13] = B5;
    hash->h4[14] = B6;
    hash->h4[15] = B7;
  
  bool result = (hash->h8[3] <= target);
  if (result)
    output[atomic_inc(output+0xFF)] = SWAP4(gid);  
}
#endif // GEEK_CL
