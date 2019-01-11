/*
 * X16R/S kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2014  phm
 * Copyright (c) 2014 Girino Vey
 * Copyright (c) 2018 brianmct (optimizations)
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

#ifndef X16_CL
#define X16_CL

#define DEBUG(x)

#if __ENDIAN_LITTLE__
  #define SPH_LITTLE_ENDIAN 1
#else
  #warning "big endian is not tested and probably would fail"
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

#define SPH_ECHO_64 1
#define SPH_KECCAK_64 1
#define SPH_JH_64 1
#define SPH_SIMD_NOCOPY 0
#define SPH_KECCAK_NOCOPY 0
#define SPH_SMALL_FOOTPRINT_GROESTL 0
#define SPH_GROESTL_BIG_ENDIAN 0
#define SPH_CUBEHASH_UNROLL 4
#define CUBEHASH_FORCED_UNROLL 4

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
ulong ROTL64_2(const uint2 vv, const int r) { return as_ulong((amd_bitalign((vv).yx, (vv).xy, 32 - (r - 32)))); }

#define WOLF_JH_64BIT 1

#include "blake.cl"
#include "wolf-bmw.cl"
#include "wolf-groestl.cl"
#include "jh.cl"
#include "wolf-jh.cl"
#include "keccak.cl"
#include "wolf-skein.cl"
#include "luffa.cl"
#include "cubehash.cl"
#include "wolf-cubehash.cl"
#include "wolf-shavite.cl"
#include "wolf-aes.cl"
#include "simd-f.cl"
#include "echo-f.cl"
#include "hamsi.cl"
#include "fugue.cl"
#include "wolf-shabal.cl"
#include "whirlpool.cl"
#include "wolf-sha512.cl"

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

#define SHL(x, n) ((x) << (n))
#define SHR(x, n) ((x) >> (n))

typedef union {
  unsigned char h1[64];
  uint h4[16];
  ulong h8[8];
} hash_t;

#ifndef WORKSIZE
#define WORKSIZE 64
#endif

// blake64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // blake

  sph_u64 V0 = BLAKE_IV512[0], V1 = BLAKE_IV512[1], V2 = BLAKE_IV512[2], V3 = BLAKE_IV512[3];
  sph_u64 V4 = BLAKE_IV512[4], V5 = BLAKE_IV512[5], V6 = BLAKE_IV512[6], V7 = BLAKE_IV512[7];

  sph_u64 V8 = CB0, V9 = CB1, VA = CB2, VB = CB3;
  sph_u64 VC = 0x452821E638D01177UL, VD = 0xBE5466CF34E90E6CUL, VE = CB6, VF = CB7;

  sph_u64 M0, M1, M2, M3, M4, M5, M6, M7;
  sph_u64 M8, M9, MA, MB, MC, MD, ME, MF;

  M0 = SWAP8(hash->h8[0]);
  M1 = SWAP8(hash->h8[1]);
  M2 = SWAP8(hash->h8[2]);
  M3 = SWAP8(hash->h8[3]);
  M4 = SWAP8(hash->h8[4]);
  M5 = SWAP8(hash->h8[5]);
  M6 = SWAP8(hash->h8[6]);
  M7 = SWAP8(hash->h8[7]);
  M8 = 0x8000000000000000;
  M9 = 0;
  MA = 0;
  MB = 0;
  MC = 0;
  MD = 1;
  ME = 0;
  MF = 0x200;

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

// blake80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global unsigned char* block, __global hash_t* hashes)
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

// bmw64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search3(__global hash_t* hashes)
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

// bmw80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global ulong* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
	
	// bmw
	ulong msg[16] = { 0 };
	
	#pragma unroll
	for(int i = 0; i < 19; ++i) ((uint *)msg)[i] = ((__global uint *)block)[i];
	
	((uint *)msg)[19] = get_global_id(0);
	
	msg[10] = 0x80UL;
	msg[15] = 0x280UL;
	
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

// groestl64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global hash_t* hashes)
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

// groestl80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search6(__global ulong* block, __global hash_t* hashes)
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
	
	//#pragma unroll
	//for(int i = 0; i < 9; ++i) M[i] = block[i];
	
	M_0 = block[0];
    M_1 = block[1];
    M_2 = block[2];
    M_3 = block[3];
    M_4 = block[4];
    M_5 = block[5];
    M_6 = block[6];
    M_7 = block[7];
	M_8 = block[8];
	
	M_9 = (block[9] & 0xffffffff) ^ ((ulong)gid << 32);
	M_10 = 0x80UL;
	M_15 = 0x0100000000000000UL;
	
	//#pragma unroll
	//for(int i = 0; i < 16; ++i) G[i] = M[i];
	
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
		//ulong H[16], H2[16];
		
		//#pragma unroll
		//for(int x = 0; x < 16; ++x)
		//{
		//	H[x] = G[x] ^ PC64(x << 4, i);
		//	H2[x] = M[x] ^ QC64(x << 4, i);
		//}
		
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
	
	//#pragma unroll
	//for(int i = 0; i < 16; ++i) G[i] ^= M[i];
	
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
		//#pragma unroll
		//for(int x = 0; x < 16; ++x)
			//H[x] = G[x] ^ PC64(x << 4, i); //G[x] ^ as_uint2(PC64((x << 4), i)); //(uint2)(G[x].s0 ^ ((x << 4) | i), G[x].s1);
			
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

// jh64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search7(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  JH_CHUNK_TYPE evnhi = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x17AA003E964BD16FUL), JH_BASE_TYPE_CAST(0x1E806F53C1A01D89UL), JH_BASE_TYPE_CAST(0x694AE34105E66901UL), JH_BASE_TYPE_CAST(0x56F8B19DECF657CFUL));
	JH_CHUNK_TYPE evnlo = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x43D5157A052E6A63UL), JH_BASE_TYPE_CAST(0x806D2BEA6B05A92AUL), JH_BASE_TYPE_CAST(0x5AE66F2E8E8AB546UL), JH_BASE_TYPE_CAST(0x56B116577C8806A7UL));
	JH_CHUNK_TYPE oddhi = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x0BEF970C8D5E228AUL), JH_BASE_TYPE_CAST(0xA6BA7520DBCC8E58UL), JH_BASE_TYPE_CAST(0x243C84C1D0A74710UL), JH_BASE_TYPE_CAST(0xFB1785E6DFFCC2E3UL));
	JH_CHUNK_TYPE oddlo = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x61C3B3F2591234E9UL), JH_BASE_TYPE_CAST(0xF73BF8BA763A0FA9UL), JH_BASE_TYPE_CAST(0x99C15A2DB1716E3BUL), JH_BASE_TYPE_CAST(0x4BDD8CCC78465A54UL));
	
	#ifdef WOLF_JH_64BIT
	
	evnhi.s0 ^= JH_BASE_TYPE_CAST(hash->h8[0]);
	evnlo.s0 ^= JH_BASE_TYPE_CAST(hash->h8[1]);
	oddhi.s0 ^= JH_BASE_TYPE_CAST(hash->h8[2]);
	oddlo.s0 ^= JH_BASE_TYPE_CAST(hash->h8[3]);
	evnhi.s1 ^= JH_BASE_TYPE_CAST(hash->h8[4]);
	evnlo.s1 ^= JH_BASE_TYPE_CAST(hash->h8[5]);
	oddhi.s1 ^= JH_BASE_TYPE_CAST(hash->h8[6]);
	oddlo.s1 ^= JH_BASE_TYPE_CAST(hash->h8[7]);
	
	#else
	
	evnhi.lo.lo ^= JH_BASE_TYPE_CAST(hash->h8[0]);
	evnlo.lo.lo ^= JH_BASE_TYPE_CAST(hash->h8[1]);
	oddhi.lo.lo ^= JH_BASE_TYPE_CAST(hash->h8[2]);
	oddlo.lo.lo ^= JH_BASE_TYPE_CAST(hash->h8[3]);
	evnhi.lo.hi ^= JH_BASE_TYPE_CAST(hash->h8[4]);
	evnlo.lo.hi ^= JH_BASE_TYPE_CAST(hash->h8[5]);
	oddhi.lo.hi ^= JH_BASE_TYPE_CAST(hash->h8[6]);
	oddlo.lo.hi ^= JH_BASE_TYPE_CAST(hash->h8[7]);
	
	#endif
	
	for(bool flag = false;; flag++)
	{
		#pragma unroll
		for(int r = 0; r < 6; ++r)
		{
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 0));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 0));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 0));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 0));
						
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 0);
			
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 1));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 1));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 1));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 1));
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 1);
			
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 2));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 2));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 2));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 2));
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 2);
			
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 3));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 3));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 3));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 3));
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 3);
			
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 4));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 4));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 4));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 4));
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 4);
			
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 5));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 5));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 5));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 5));
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 5);
			
			evnhi = Sb_new(evnhi, Ceven_hi_new((r * 7) + 6));
			evnlo = Sb_new(evnlo, Ceven_lo_new((r * 7) + 6));
			oddhi = Sb_new(oddhi, Codd_hi_new((r * 7) + 6));
			oddlo = Sb_new(oddlo, Codd_lo_new((r * 7) + 6));
			Lb_new(&evnhi, &oddhi);
			Lb_new(&evnlo, &oddlo);
			
			JH_RND(&oddhi, &oddlo, 6);
		}
				
		if(flag) break;
		
		#ifdef WOLF_JH_64BIT
		
		evnhi.s2 ^= JH_BASE_TYPE_CAST(hash->h8[0]);
		evnlo.s2 ^= JH_BASE_TYPE_CAST(hash->h8[1]);
		oddhi.s2 ^= JH_BASE_TYPE_CAST(hash->h8[2]);
		oddlo.s2 ^= JH_BASE_TYPE_CAST(hash->h8[3]);
		evnhi.s3 ^= JH_BASE_TYPE_CAST(hash->h8[4]);
		evnlo.s3 ^= JH_BASE_TYPE_CAST(hash->h8[5]);
		oddhi.s3 ^= JH_BASE_TYPE_CAST(hash->h8[6]);
		oddlo.s3 ^= JH_BASE_TYPE_CAST(hash->h8[7]);
		
		evnhi.s0 ^= JH_BASE_TYPE_CAST(0x80UL);
		oddlo.s1 ^= JH_BASE_TYPE_CAST(0x0002000000000000UL);
		
		#else
			
		evnhi.hi.lo ^= JH_BASE_TYPE_CAST(hash->h8[0]);
		evnlo.hi.lo ^= JH_BASE_TYPE_CAST(hash->h8[1]);
		oddhi.hi.lo ^= JH_BASE_TYPE_CAST(hash->h8[2]);
		oddlo.hi.lo ^= JH_BASE_TYPE_CAST(hash->h8[3]);
		evnhi.hi.hi ^= JH_BASE_TYPE_CAST(hash->h8[4]);
		evnlo.hi.hi ^= JH_BASE_TYPE_CAST(hash->h8[5]);
		oddhi.hi.hi ^= JH_BASE_TYPE_CAST(hash->h8[6]);
		oddlo.hi.hi ^= JH_BASE_TYPE_CAST(hash->h8[7]);
		
		evnhi.lo.lo ^= JH_BASE_TYPE_CAST(0x80UL);
		oddlo.lo.hi ^= JH_BASE_TYPE_CAST(0x0002000000000000UL);
		
		#endif
	}
	
	#ifdef WOLF_JH_64BIT
	
	evnhi.s2 ^= JH_BASE_TYPE_CAST(0x80UL);
	oddlo.s3 ^= JH_BASE_TYPE_CAST(0x2000000000000UL);
	
	hash->h8[0] = as_ulong(evnhi.s2);
	hash->h8[1] = as_ulong(evnlo.s2);
	hash->h8[2] = as_ulong(oddhi.s2);
	hash->h8[3] = as_ulong(oddlo.s2);
	hash->h8[4] = as_ulong(evnhi.s3);
	hash->h8[5] = as_ulong(evnlo.s3);
	hash->h8[6] = as_ulong(oddhi.s3);
	hash->h8[7] = as_ulong(oddlo.s3);
	
	#else
	
	evnhi.hi.lo ^= JH_BASE_TYPE_CAST(0x80UL);
	oddlo.hi.hi ^= JH_BASE_TYPE_CAST(0x2000000000000UL);
	
	hash->h8[0] = as_ulong(evnhi.hi.lo);
	hash->h8[1] = as_ulong(evnlo.hi.lo);
	hash->h8[2] = as_ulong(oddhi.hi.lo);
	hash->h8[3] = as_ulong(oddlo.hi.lo);
	hash->h8[4] = as_ulong(evnhi.hi.hi);
	hash->h8[5] = as_ulong(evnlo.hi.hi);
	hash->h8[6] = as_ulong(oddhi.hi.hi);
	hash->h8[7] = as_ulong(oddlo.hi.hi);
	
	#endif

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// jh80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search8(__global ulong* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
  ulong b9 = (block[9] & 0xffffffff) ^ ((ulong)gid << 32);

  sph_u64 h0h = C64e(0x6fd14b963e00aa17), h0l = C64e(0x636a2e057a15d543), h1h = C64e(0x8a225e8d0c97ef0b), h1l = C64e(0xe9341259f2b3c361), h2h = C64e(0x891da0c1536f801e), h2l = C64e(0x2aa9056bea2b6d80), h3h = C64e(0x588eccdb2075baa6), h3l = C64e(0xa90f3a76baf83bf7);
  sph_u64 h4h = C64e(0x0169e60541e34a69), h4l = C64e(0x46b58a8e2e6fe65a), h5h = C64e(0x1047a7d0c1843c24), h5l = C64e(0x3b6e71b12d5ac199), h6h = C64e(0xcf57f6ec9db1f856), h6l = C64e(0xa706887c5716b156), h7h = C64e(0xe3c2fcdfe68517fb), h7l = C64e(0x545a4678cc8cdd4b);
  sph_u64 tmp;

  h0h ^= block[0];
  h0l ^= block[1];
  h1h ^= block[2];
  h1l ^= block[3];
  h2h ^= block[4];
  h2l ^= block[5];
  h3h ^= block[6];
  h3l ^= block[7];

  E8;

  h4h ^= block[0];
  h4l ^= block[1];
  h5h ^= block[2];
  h5l ^= block[3];
  h6h ^= block[4];
  h6l ^= block[5];
  h7h ^= block[6];
  h7l ^= block[7];

  h0h ^= block[8];
  h0l ^= b9;
  h1h ^= 0x80;

  E8;

  h4h ^= block[8];
  h4l ^= b9;
  h5h ^= 0x80;

  h3l ^= 0x8002000000000000UL;

  E8;

  h7l ^= 0x8002000000000000UL;

  hash->h8[0] = h4h;
  hash->h8[1] = h4l;
  hash->h8[2] = h5h;
  hash->h8[3] = h5l;
  hash->h8[4] = h6h;
  hash->h8[5] = h6l;
  hash->h8[6] = h7h;
  hash->h8[7] = h7l;

  barrier(CLK_GLOBAL_MEM_FENCE);
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

// keccak64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search9(__global hash_t* hashes)
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

// keccak80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search10(__global ulong* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
  sph_u64 a00 = 0, a01 = 0, a02 = 0, a03 = 0, a04 = 0;
  sph_u64 a10 = 0, a11 = 0, a12 = 0, a13 = 0, a14 = 0;
  sph_u64 a20 = 0, a21 = 0, a22 = 0, a23 = 0, a24 = 0;
  sph_u64 a30 = 0, a31 = 0, a32 = 0, a33 = 0, a34 = 0;
  sph_u64 a40 = 0, a41 = 0, a42 = 0, a43 = 0, a44 = 0;

  a10 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a20 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a31 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a22 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a23 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a04 = SPH_C64(0xFFFFFFFFFFFFFFFF);

  a00 ^= block[0];
  a10 ^= block[1];
  a20 ^= block[2];
  a30 ^= block[3];
  a40 ^= block[4];
  a01 ^= block[5];
  a11 ^= block[6];
  a21 ^= block[7];
  a31 ^= block[8];
  KECCAK_F_1600;

  a00 ^= (block[9] & 0xffffffff) ^ ((ulong)gid << 32);
  a10 ^= 1;
  a31 ^= 0x8000000000000000UL;
  KECCAK_F_1600;


  // Finalize the "lane complement"
  a10 = ~a10;
  a20 = ~a20;

  hash->h8[0] = a00;
  hash->h8[1] = a10;
  hash->h8[2] = a20;
  hash->h8[3] = a30;
  hash->h8[4] = a40;
  hash->h8[5] = a01;
  hash->h8[6] = a11;
  hash->h8[7] = a21;

  barrier(CLK_GLOBAL_MEM_FENCE);
}


// skein64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search11(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);
	
	const ulong8 m = vload8(0, hash->h8);
	
	const ulong8 h = (ulong8)(	0x4903ADFF749C51CEUL, 0x0D95DE399746DF03UL, 0x8FD1934127C79BCEUL, 0x9A255629FF352CB1UL,
								0x5DB62599DF6CA7B0UL, 0xEABE394CA9D5C3F4UL, 0x991112C71A75B523UL, 0xAE18A40B660FCC33UL);
	
	const ulong t[3] = { 0x40UL, 0xF000000000000000UL, 0xF000000000000040UL }, t2[3] = { 0x08UL, 0xFF00000000000000UL, 0xFF00000000000008UL };
		
	ulong8 p = Skein512Block(m, h, 0xCAB2076D98173EC4UL, t);
	
	const ulong8 h2 = m ^ p;
	p = (ulong8)(0);
	const ulong h8 = h2.s0 ^ h2.s1 ^ h2.s2 ^ h2.s3 ^ h2.s4 ^ h2.s5 ^ h2.s6 ^ h2.s7 ^ SKEIN_KS_PARITY;
	
	p = Skein512Block(p, h2, h8, t2);
	
	vstore8(p, 0, hash->h8);
	
	barrier(CLK_GLOBAL_MEM_FENCE);
}

// skein80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search12(__global ulong* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  ulong8 m = vload8(0, block);

  const ulong8 h = (ulong8)(  0x4903ADFF749C51CEUL, 0x0D95DE399746DF03UL, 0x8FD1934127C79BCEUL, 0x9A255629FF352CB1UL,
                0x5DB62599DF6CA7B0UL, 0xEABE394CA9D5C3F4UL, 0x991112C71A75B523UL, 0xAE18A40B660FCC33UL);

  const ulong t[3] = { 0x40UL, 0x7000000000000000UL, 0x7000000000000040UL },
       t1[3] = { 0x50UL, 0xB000000000000000UL, 0xB000000000000050UL },
       t2[3] = { 0x08UL, 0xFF00000000000000UL, 0xFF00000000000008UL };

  ulong8 p = Skein512Block(m, h, 0xCAB2076D98173EC4UL, t);

  ulong8 h2 = m ^ p;

  m = (ulong8)(block[8], (block[9] & 0x00000000FFFFFFFF) ^ ((ulong)(gid) << 32), 0UL, 0UL, 0UL, 0UL, 0UL, 0UL);
  ulong h8 = h2.s0 ^ h2.s1 ^ h2.s2 ^ h2.s3 ^ h2.s4 ^ h2.s5 ^ h2.s6 ^ h2.s7 ^ SKEIN_KS_PARITY;

  p = Skein512Block(m, h2, h8, t1);

  h2 = m ^ p;

  p = (ulong8)(0);
  h8 = h2.s0 ^ h2.s1 ^ h2.s2 ^ h2.s3 ^ h2.s4 ^ h2.s5 ^ h2.s6 ^ h2.s7 ^ SKEIN_KS_PARITY;

  p = Skein512Block(p, h2, h8, t2);

  vstore8(p, 0, hash->h8);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// luffa64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search13(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // luffa

  sph_u32 V00 = SPH_C32(0x6d251e69), V01 = SPH_C32(0x44b051e0), V02 = SPH_C32(0x4eaa6fb4), V03 = SPH_C32(0xdbf78465), V04 = SPH_C32(0x6e292011), V05 = SPH_C32(0x90152df4), V06 = SPH_C32(0xee058139), V07 = SPH_C32(0xdef610bb);
  sph_u32 V10 = SPH_C32(0xc3b44b95), V11 = SPH_C32(0xd9d2f256), V12 = SPH_C32(0x70eee9a0), V13 = SPH_C32(0xde099fa3), V14 = SPH_C32(0x5d9b0557), V15 = SPH_C32(0x8fc944b3), V16 = SPH_C32(0xcf1ccf0e), V17 = SPH_C32(0x746cd581);
  sph_u32 V20 = SPH_C32(0xf7efc89d), V21 = SPH_C32(0x5dba5781), V22 = SPH_C32(0x04016ce5), V23 = SPH_C32(0xad659c05), V24 = SPH_C32(0x0306194f), V25 = SPH_C32(0x666d1836), V26 = SPH_C32(0x24aa230a), V27 = SPH_C32(0x8b264ae7);
  sph_u32 V30 = SPH_C32(0x858075d5), V31 = SPH_C32(0x36d79cce), V32 = SPH_C32(0xe571f7d7), V33 = SPH_C32(0x204b1f67), V34 = SPH_C32(0x35870c6a), V35 = SPH_C32(0x57e9e923), V36 = SPH_C32(0x14bcb808), V37 = SPH_C32(0x7cde72ce);
  sph_u32 V40 = SPH_C32(0x6c68e9be), V41 = SPH_C32(0x5ec41e22), V42 = SPH_C32(0xc825b7c7), V43 = SPH_C32(0xaffb4363), V44 = SPH_C32(0xf5df3999), V45 = SPH_C32(0x0fc688f1), V46 = SPH_C32(0xb07224cc), V47 = SPH_C32(0x03e86cea);

  DECL_TMP8(M);

  M0 = DEC32E(hash->h4[0]);
  M1 = DEC32E(hash->h4[1]);
  M2 = DEC32E(hash->h4[2]);
  M3 = DEC32E(hash->h4[3]);
  M4 = DEC32E(hash->h4[4]);
  M5 = DEC32E(hash->h4[5]);
  M6 = DEC32E(hash->h4[6]);
  M7 = DEC32E(hash->h4[7]);

  for(uint i = 0; i < 5; i++) {
    MI5;
    LUFFA_P5;

    if(i == 0) {
      M0 = DEC32E(hash->h4[8]);
      M1 = DEC32E(hash->h4[9]);
      M2 = DEC32E(hash->h4[10]);
      M3 = DEC32E(hash->h4[11]);
      M4 = DEC32E(hash->h4[12]);
      M5 = DEC32E(hash->h4[13]);
      M6 = DEC32E(hash->h4[14]);
      M7 = DEC32E(hash->h4[15]);
    }
    else if(i == 1) {
      M0 = 0x80000000;
      M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    }
    else if(i == 2)
      M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    else if(i == 3) {
      hash->h4[0] = ENC32E(V00 ^ V10 ^ V20 ^ V30 ^ V40);
      hash->h4[1] = ENC32E(V01 ^ V11 ^ V21 ^ V31 ^ V41);
      hash->h4[2] = ENC32E(V02 ^ V12 ^ V22 ^ V32 ^ V42);
      hash->h4[3] = ENC32E(V03 ^ V13 ^ V23 ^ V33 ^ V43);
      hash->h4[4] = ENC32E(V04 ^ V14 ^ V24 ^ V34 ^ V44);
      hash->h4[5] = ENC32E(V05 ^ V15 ^ V25 ^ V35 ^ V45);
      hash->h4[6] = ENC32E(V06 ^ V16 ^ V26 ^ V36 ^ V46);
      hash->h4[7] = ENC32E(V07 ^ V17 ^ V27 ^ V37 ^ V47);
    }
  }

  hash->h4[8] =  ENC32E(V00 ^ V10 ^ V20 ^ V30 ^ V40);
  hash->h4[9] =  ENC32E(V01 ^ V11 ^ V21 ^ V31 ^ V41);
  hash->h4[10] = ENC32E(V02 ^ V12 ^ V22 ^ V32 ^ V42);
  hash->h4[11] = ENC32E(V03 ^ V13 ^ V23 ^ V33 ^ V43);
  hash->h4[12] = ENC32E(V04 ^ V14 ^ V24 ^ V34 ^ V44);
  hash->h4[13] = ENC32E(V05 ^ V15 ^ V25 ^ V35 ^ V45);
  hash->h4[14] = ENC32E(V06 ^ V16 ^ V26 ^ V36 ^ V46);
  hash->h4[15] = ENC32E(V07 ^ V17 ^ V27 ^ V37 ^ V47);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// luffa80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search14(__global uint* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  sph_u32 V00 = SPH_C32(0x6d251e69), V01 = SPH_C32(0x44b051e0), V02 = SPH_C32(0x4eaa6fb4), V03 = SPH_C32(0xdbf78465), V04 = SPH_C32(0x6e292011), V05 = SPH_C32(0x90152df4), V06 = SPH_C32(0xee058139), V07 = SPH_C32(0xdef610bb);
  sph_u32 V10 = SPH_C32(0xc3b44b95), V11 = SPH_C32(0xd9d2f256), V12 = SPH_C32(0x70eee9a0), V13 = SPH_C32(0xde099fa3), V14 = SPH_C32(0x5d9b0557), V15 = SPH_C32(0x8fc944b3), V16 = SPH_C32(0xcf1ccf0e), V17 = SPH_C32(0x746cd581);
  sph_u32 V20 = SPH_C32(0xf7efc89d), V21 = SPH_C32(0x5dba5781), V22 = SPH_C32(0x04016ce5), V23 = SPH_C32(0xad659c05), V24 = SPH_C32(0x0306194f), V25 = SPH_C32(0x666d1836), V26 = SPH_C32(0x24aa230a), V27 = SPH_C32(0x8b264ae7);
  sph_u32 V30 = SPH_C32(0x858075d5), V31 = SPH_C32(0x36d79cce), V32 = SPH_C32(0xe571f7d7), V33 = SPH_C32(0x204b1f67), V34 = SPH_C32(0x35870c6a), V35 = SPH_C32(0x57e9e923), V36 = SPH_C32(0x14bcb808), V37 = SPH_C32(0x7cde72ce);
  sph_u32 V40 = SPH_C32(0x6c68e9be), V41 = SPH_C32(0x5ec41e22), V42 = SPH_C32(0xc825b7c7), V43 = SPH_C32(0xaffb4363), V44 = SPH_C32(0xf5df3999), V45 = SPH_C32(0x0fc688f1), V46 = SPH_C32(0xb07224cc), V47 = SPH_C32(0x03e86cea);

  DECL_TMP8(M);

  M0 = DEC32E(block[0]);
  M1 = DEC32E(block[1]);
  M2 = DEC32E(block[2]);
  M3 = DEC32E(block[3]);
  M4 = DEC32E(block[4]);
  M5 = DEC32E(block[5]);
  M6 = DEC32E(block[6]);
  M7 = DEC32E(block[7]);

  for(uint i = 0; i < 5; i++) {
    MI5;
    LUFFA_P5;

    if(i == 0) {
      M0 = DEC32E(block[8]);
      M1 = DEC32E(block[9]);
      M2 = DEC32E(block[10]);
      M3 = DEC32E(block[11]);
      M4 = DEC32E(block[12]);
      M5 = DEC32E(block[13]);
      M6 = DEC32E(block[14]);
      M7 = DEC32E(block[15]);
    }
    else if(i == 1) {
      M0 = DEC32E(block[16]);
      M1 = DEC32E(block[17]);
      M2 = DEC32E(block[18]);
      M3 = DEC32E(gid);
      M4 = 0x80000000;
      M5 = M6 = M7 = 0;
    }
    else if(i == 2)
      M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    else if(i == 3) {
      hash->h4[0] = ENC32E(V00 ^ V10 ^ V20 ^ V30 ^ V40);
      hash->h4[1] = ENC32E(V01 ^ V11 ^ V21 ^ V31 ^ V41);
      hash->h4[2] = ENC32E(V02 ^ V12 ^ V22 ^ V32 ^ V42);
      hash->h4[3] = ENC32E(V03 ^ V13 ^ V23 ^ V33 ^ V43);
      hash->h4[4] = ENC32E(V04 ^ V14 ^ V24 ^ V34 ^ V44);
      hash->h4[5] = ENC32E(V05 ^ V15 ^ V25 ^ V35 ^ V45);
      hash->h4[6] = ENC32E(V06 ^ V16 ^ V26 ^ V36 ^ V46);
      hash->h4[7] = ENC32E(V07 ^ V17 ^ V27 ^ V37 ^ V47);
    }
  }

  hash->h4[8] =  ENC32E(V00 ^ V10 ^ V20 ^ V30 ^ V40);
  hash->h4[9] =  ENC32E(V01 ^ V11 ^ V21 ^ V31 ^ V41);
  hash->h4[10] = ENC32E(V02 ^ V12 ^ V22 ^ V32 ^ V42);
  hash->h4[11] = ENC32E(V03 ^ V13 ^ V23 ^ V33 ^ V43);
  hash->h4[12] = ENC32E(V04 ^ V14 ^ V24 ^ V34 ^ V44);
  hash->h4[13] = ENC32E(V05 ^ V15 ^ V25 ^ V35 ^ V45);
  hash->h4[14] = ENC32E(V06 ^ V16 ^ V26 ^ V36 ^ V46);
  hash->h4[15] = ENC32E(V07 ^ V17 ^ V27 ^ V37 ^ V47);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// cubehash64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search15(__global hash_t* hashes)
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

// cubehash80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search16(__global uint* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  sph_u32 x0 = SPH_C32(0x2AEA2A61), x1 = SPH_C32(0x50F494D4), x2 = SPH_C32(0x2D538B8B), x3 = SPH_C32(0x4167D83E);
  sph_u32 x4 = SPH_C32(0x3FEE2313), x5 = SPH_C32(0xC701CF8C), x6 = SPH_C32(0xCC39968E), x7 = SPH_C32(0x50AC5695);
  sph_u32 x8 = SPH_C32(0x4D42C787), x9 = SPH_C32(0xA647A8B3), xa = SPH_C32(0x97CF0BEF), xb = SPH_C32(0x825B4537);
  sph_u32 xc = SPH_C32(0xEEF864D2), xd = SPH_C32(0xF22090C4), xe = SPH_C32(0xD0E5CD33), xf = SPH_C32(0xA23911AE);
  sph_u32 xg = SPH_C32(0xFCD398D9), xh = SPH_C32(0x148FE485), xi = SPH_C32(0x1B017BEF), xj = SPH_C32(0xB6444532);
  sph_u32 xk = SPH_C32(0x6A536159), xl = SPH_C32(0x2FF5781C), xm = SPH_C32(0x91FA7934), xn = SPH_C32(0x0DBADEA9);
  sph_u32 xo = SPH_C32(0xD65C8A2B), xp = SPH_C32(0xA5A70E75), xq = SPH_C32(0xB1C62456), xr = SPH_C32(0xBC796576);
  sph_u32 xs = SPH_C32(0x1921C8F7), xt = SPH_C32(0xE7989AF1), xu = SPH_C32(0x7795D246), xv = SPH_C32(0xD43E3B44);

  x0 ^= block[0];
  x1 ^= block[1];
  x2 ^= block[2];
  x3 ^= block[3];
  x4 ^= block[4];
  x5 ^= block[5];
  x6 ^= block[6];
  x7 ^= block[7];

  for (int i = 0; i < 13; i ++) {
    SIXTEEN_ROUNDS;

    if (i == 0) {
      x0 ^= block[8];
      x1 ^= block[9];
      x2 ^= block[10];
      x3 ^= block[11];
      x4 ^= block[12];
      x5 ^= block[13];
      x6 ^= block[14];
      x7 ^= block[15];
    }
    else if (i == 1) {
      x0 ^= block[16];
      x1 ^= block[17];
      x2 ^= block[18];
      x3 ^= gid;
      x4 ^= 0x80;
    }
    else if (i == 2)
      xv ^= SPH_C32(1);
  }

  hash->h4[0] = x0;
  hash->h4[1] = x1;
  hash->h4[2] = x2;
  hash->h4[3] = x3;
  hash->h4[4] = x4;
  hash->h4[5] = x5;
  hash->h4[6] = x6;
  hash->h4[7] = x7;
  hash->h4[8] = x8;
  hash->h4[9] = x9;
  hash->h4[10] = xa;
  hash->h4[11] = xb;
  hash->h4[12] = xc;
  hash->h4[13] = xd;
  hash->h4[14] = xe;
  hash->h4[15] = xf;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// shavite64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search17(__global hash_t* hashes)
{
	__local uint AES0[256], AES1[256], AES2[256], AES3[256];
	
	uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
	
	const int step = get_local_size(0);
	
	#pragma unroll
	for(int i = get_local_id(0); i < 256; i += step)
	{
		const uint tmp = AES0_C[i];
		AES0[i] = tmp;
		AES1[i] = rotate(tmp, 8U);
		AES2[i] = rotate(tmp, 16U);
		AES3[i] = rotate(tmp, 24U);
	}
	
	const uint4 h[4] = {(uint4)(0x72FCCDD8, 0x79CA4727, 0x128A077B, 0x40D55AEC), (uint4)(0xD1901A06, 0x430AE307, 0xB29F5CD1, 0xDF07FBFC), \
						(uint4)(0x8E45D73D, 0x681AB538, 0xBDE86578, 0xDD577E47), (uint4)(0xE275EADE, 0x502D9FCD, 0xB9357178, 0x022A4B9A) };
	
	uint4 rk[8] = { (uint4)(0) }, p[4] = { h[0], h[1], h[2], h[3] };
	
	((uint16 *)rk)[0] = vload16(0, hash->h4);
	rk[4].s0 = 0x80;
	rk[6].s3 = 0x2000000;
	rk[7].s3 = 0x2000000;
	mem_fence(CLK_LOCAL_MEM_FENCE);
	
	#pragma unroll 1
	for(int r = 0; r < 3; ++r)
	{
		if(r == 0)
		{
			p[0] = Shavite_AES_4Round(AES0, AES1, AES2, AES3, p[1] ^ rk[0], &(rk[1]), p[0]);
			p[2] = Shavite_AES_4Round(AES0, AES1, AES2, AES3, p[3] ^ rk[4], &(rk[5]), p[2]);
		}
		#pragma unroll 1
		for(int y = 0; y < 2; ++y)
		{
			rk[0] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[0], rk[7]);
			rk[0].s03 ^= ((!y && !r) ? (uint2)(0x200, 0xFFFFFFFF) : (uint2)(0));
			uint4 x = rk[0] ^ (y != 1 ? p[0] : p[2]);
			rk[1] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[1], rk[0]);
			rk[1].s3 ^= (!y && r == 1 ? 0xFFFFFDFFU : 0);	// ~(0x200)
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[1]);
			rk[2] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[2], rk[1]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[2]);
			rk[3] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[3], rk[2]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[3]);
			if(y != 1) p[3] = AES_Round(AES0, AES1, AES2, AES3, x, p[3]);
			else p[1] = AES_Round(AES0, AES1, AES2, AES3, x, p[1]);
			
			rk[4] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[4], rk[3]);
			x = rk[4] ^ (y != 1 ? p[2] : p[0]);
			rk[5] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[5], rk[4]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[5]);
			rk[6] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[6], rk[5]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[6]);
			rk[7] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[7], rk[6]);
			rk[7].s23 ^= ((!y && r == 2) ? (uint2)(0x200, 0xFFFFFFFF) : (uint2)(0));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[7]);
			if(y != 1) p[1] = AES_Round(AES0, AES1, AES2, AES3, x, p[1]);
			else p[3] = AES_Round(AES0, AES1, AES2, AES3, x, p[3]);
						
			rk[0] ^= shuffle2(rk[6], rk[7], (uint4)(1, 2, 3, 4));
			x = rk[0] ^ (!y ? p[3] : p[1]);
			rk[1] ^= shuffle2(rk[7], rk[0], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[1]);
			rk[2] ^= shuffle2(rk[0], rk[1], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[2]);
			rk[3] ^= shuffle2(rk[1], rk[2], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[3]);
			if(!y) p[2] = AES_Round(AES0, AES1, AES2, AES3, x, p[2]);
			else p[0] = AES_Round(AES0, AES1, AES2, AES3, x, p[0]);
					
			rk[4] ^= shuffle2(rk[2], rk[3], (uint4)(1, 2, 3, 4));
			x = rk[4] ^ (!y ? p[1] : p[3]);
			rk[5] ^= shuffle2(rk[3], rk[4], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[5]);
			rk[6] ^= shuffle2(rk[4], rk[5], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[6]);
			rk[7] ^= shuffle2(rk[5], rk[6], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[7]);
			if(!y) p[0] = AES_Round(AES0, AES1, AES2, AES3, x, p[0]);
			else p[2] = AES_Round(AES0, AES1, AES2, AES3, x, p[2]);
		}
		if(r == 2)
		{
			rk[0] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[0], rk[7]);
			uint4 x = rk[0] ^ p[0];
			rk[1] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[1], rk[0]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[1]);
			rk[2] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[2], rk[1]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[2]);
			rk[3] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[3], rk[2]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[3]);
			p[3] = AES_Round(AES0, AES1, AES2, AES3, x, p[3]);
			
			rk[4] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[4], rk[3]);
			x = rk[4] ^ p[2];
			rk[5] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[5], rk[4]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[5]);
			rk[6] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[6], rk[5]);
			rk[6].s13 ^= (uint2)(0x200, 0xFFFFFFFF);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[6]);
			rk[7] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[7], rk[6]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[7]);
			p[1] = AES_Round(AES0, AES1, AES2, AES3, x, p[1]);
		}
	}
	
	// h[0] ^ p[2], h[1] ^ p[3], h[2] ^ p[0], h[3] ^ p[1]
	for(int i = 0; i < 4; ++i) vstore4(h[i] ^ p[(i + 2) & 3], i, hash->h4);
	
	barrier(CLK_GLOBAL_MEM_FENCE);
}

// shavite80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search18(__global uint* block, __global hash_t* hashes)
{
	__local uint AES0[256], AES1[256], AES2[256], AES3[256];
	
	uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
	
	const int step = get_local_size(0);
	
	#pragma unroll
	for(int i = get_local_id(0); i < 256; i += step)
	{
		const uint tmp = AES0_C[i];
		AES0[i] = tmp;
		AES1[i] = rotate(tmp, 8U);
		AES2[i] = rotate(tmp, 16U);
		AES3[i] = rotate(tmp, 24U);
	}
	
	const uint4 h[4] = {(uint4)(0x72FCCDD8, 0x79CA4727, 0x128A077B, 0x40D55AEC), (uint4)(0xD1901A06, 0x430AE307, 0xB29F5CD1, 0xDF07FBFC), \
						(uint4)(0x8E45D73D, 0x681AB538, 0xBDE86578, 0xDD577E47), (uint4)(0xE275EADE, 0x502D9FCD, 0xB9357178, 0x022A4B9A) };
	
	uint4 rk[8] = { (uint4)(0) }, p[4] = { h[0], h[1], h[2], h[3] };
	
	//((uint16 *)rk)[0] = vload16(0, block);
	rk[0] = (uint4) {block[0], block[1], block[2], block[3]};
	rk[1] = (uint4) {block[4], block[5], block[6], block[7]};
	rk[2] = (uint4) {block[8], block[9], block[10], block[11]};
	rk[3] = (uint4) {block[12], block[13], block[14], block[15]};
	rk[4] = (uint4) {block[16],block[17],block[18], gid};
	rk[5].s0 = 0x80;
	rk[6].s3 = 0x2800000;
	rk[7].s3 = 0x2000000;
	barrier(CLK_LOCAL_MEM_FENCE);
	
	#pragma unroll 1
	for(int r = 0; r < 3; ++r)
	{
		if(r == 0)
		{
			p[0] = Shavite_AES_4Round(AES0, AES1, AES2, AES3, p[1] ^ rk[0], &(rk[1]), p[0]);
			p[2] = Shavite_AES_4Round(AES0, AES1, AES2, AES3, p[3] ^ rk[4], &(rk[5]), p[2]);
		}
		#pragma unroll 1
		for(int y = 0; y < 2; ++y)
		{
			rk[0] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[0], rk[7]);
			rk[0].s03 ^= ((!y && !r) ? (uint2)(0x280, 0xFFFFFFFF) : (uint2)(0));
			uint4 x = rk[0] ^ (y != 1 ? p[0] : p[2]);
			rk[1] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[1], rk[0]);
			rk[1].s3 ^= (!y && r == 1 ? ~(0x280) : 0);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[1]);
			rk[2] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[2], rk[1]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[2]);
			rk[3] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[3], rk[2]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[3]);
			if(y != 1) p[3] = AES_Round(AES0, AES1, AES2, AES3, x, p[3]);
			else p[1] = AES_Round(AES0, AES1, AES2, AES3, x, p[1]);
			
			rk[4] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[4], rk[3]);
			x = rk[4] ^ (y != 1 ? p[2] : p[0]);
			rk[5] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[5], rk[4]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[5]);
			rk[6] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[6], rk[5]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[6]);
			rk[7] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[7], rk[6]);
			rk[7].s23 ^= ((!y && r == 2) ? (uint2)(0x280, 0xFFFFFFFF) : (uint2)(0));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[7]);
			if(y != 1) p[1] = AES_Round(AES0, AES1, AES2, AES3, x, p[1]);
			else p[3] = AES_Round(AES0, AES1, AES2, AES3, x, p[3]);
						
			rk[0] ^= shuffle2(rk[6], rk[7], (uint4)(1, 2, 3, 4));
			x = rk[0] ^ (!y ? p[3] : p[1]);
			rk[1] ^= shuffle2(rk[7], rk[0], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[1]);
			rk[2] ^= shuffle2(rk[0], rk[1], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[2]);
			rk[3] ^= shuffle2(rk[1], rk[2], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[3]);
			if(!y) p[2] = AES_Round(AES0, AES1, AES2, AES3, x, p[2]);
			else p[0] = AES_Round(AES0, AES1, AES2, AES3, x, p[0]);
					
			rk[4] ^= shuffle2(rk[2], rk[3], (uint4)(1, 2, 3, 4));
			x = rk[4] ^ (!y ? p[1] : p[3]);
			rk[5] ^= shuffle2(rk[3], rk[4], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[5]);
			rk[6] ^= shuffle2(rk[4], rk[5], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[6]);
			rk[7] ^= shuffle2(rk[5], rk[6], (uint4)(1, 2, 3, 4));
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[7]);
			if(!y) p[0] = AES_Round(AES0, AES1, AES2, AES3, x, p[0]);
			else p[2] = AES_Round(AES0, AES1, AES2, AES3, x, p[2]);
		}
		if(r == 2)
		{
			rk[0] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[0], rk[7]);
			uint4 x = rk[0] ^ p[0];
			rk[1] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[1], rk[0]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[1]);
			rk[2] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[2], rk[1]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[2]);
			rk[3] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[3], rk[2]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[3]);
			p[3] = AES_Round(AES0, AES1, AES2, AES3, x, p[3]);
			
			rk[4] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[4], rk[3]);
			x = rk[4] ^ p[2];
			rk[5] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[5], rk[4]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[5]);
			rk[6] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[6], rk[5]);
			rk[6].s13 ^= (uint2)(0x280, 0xFFFFFFFF);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[6]);
			rk[7] = Shavite_Key_Expand(AES0, AES1, AES2, AES3, rk[7], rk[6]);
			x = AES_Round(AES0, AES1, AES2, AES3, x, rk[7]);
			p[1] = AES_Round(AES0, AES1, AES2, AES3, x, p[1]);
		}
	}
	
	// h[0] ^ p[2], h[1] ^ p[3], h[2] ^ p[0], h[3] ^ p[1]
	for(int i = 0; i < 4; ++i) vstore4(h[i] ^ p[(i + 2) & 3], i, hash->h4);
	
	barrier(CLK_GLOBAL_MEM_FENCE);
}

// simd64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search19(__global hash_t* hashes)
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

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// simd80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search20(__global uint* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  __local sph_s32 yoff[256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  for (int i = init; i < 256; i += step)
    yoff[i] = yoff_b_n[i];

  barrier(CLK_LOCAL_MEM_FENCE);

  // simd
  s32 q[256];
  unsigned char x[128];
  for (unsigned int i = 0; i < 80; i += 8)
    *(ulong*)(&x[i]) = ((__global const ulong*)block)[i/8];
  *(uint*)(&x[76]) = gid;
  for (unsigned int i = 80; i < 128; i += 8)
    *(ulong*)(&x[i]) = 0;
	
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

  FFT256_80(0, 1, 0, ll1);
  for (int i = 0; i < 256; i ++) {
    const s32 tq = REDS1(REDS1(q[i] + yoff[i]));
    q[i] = select(tq - 257, tq, tq <= 128);
  }

  A0 ^= block[0];
  A1 ^= block[1];
  A2 ^= block[2];
  A3 ^= block[3];
  A4 ^= block[4];
  A5 ^= block[5];
  A6 ^= block[6];
  A7 ^= block[7];
  B0 ^= block[8];
  B1 ^= block[9];
  B2 ^= block[10];
  B3 ^= block[11];
  B4 ^= block[12];
  B5 ^= block[13];
  B6 ^= block[14];
  B7 ^= block[15];
  C0 ^= block[16];
  C1 ^= block[17];
  C2 ^= block[18];
  C3 ^= gid;

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

  #define q SIMD_Q_80

  A0 ^= 0x280;

  ONE_ROUND_BIG(0_, 0,  3, 23, 17, 27);
  ONE_ROUND_BIG(1_, 1, 28, 19, 22,  7);
  ONE_ROUND_BIG(2_, 2, 29,  9, 15,  5);
  ONE_ROUND_BIG(3_, 3,  4, 13, 10, 25);

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

  #undef q

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

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// echo64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search21(__global hash_t* hashes)
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

// echo80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search22(__global ulong* block, __global hash_t* hashes)
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
  W0 = (uint4)(0xc2031f3a, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W1 = (uint4)(0x428a9633, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W2 = (uint4)(0xe2eaf6f3, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W3 = (uint4)(0xc9f3efc1, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W4 = (uint4)(0x56869a2b, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W5 = (uint4)(0x789c801f, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W6 = (uint4)(0x81cbd7b1, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W7 = (uint4)(0x4a7b67ca, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W13 = (uint4)(0x83d3d3ab, 0xea6f7e7e, 0xbd7731bd, 0x8a8a1968);
  W14 = (uint4)(0x5d99993f, 0x6b23b3b3, 0xcf93a7cf, 0x9d9d3751);
  W15 = (uint4)(0x57706cdc, 0xe4736c70, 0xf53fa165, 0xd6be2d00);

  //((uint16 *)W)[2] = vload16(0, hash->h4);
  W8.x = as_uint2(block[0]).s0;
  W8.y = as_uint2(block[0]).s1;
  W8.z = as_uint2(block[1]).s0;
  W8.w = as_uint2(block[1]).s1;
  W9.x = as_uint2(block[2]).s0;
  W9.y = as_uint2(block[2]).s1;
  W9.z = as_uint2(block[3]).s0;
  W9.w = as_uint2(block[3]).s1;
  W10.x = as_uint2(block[4]).s0;
  W10.y = as_uint2(block[4]).s1;
  W10.z = as_uint2(block[5]).s0;
  W10.w = as_uint2(block[5]).s1;
  W11.x = as_uint2(block[6]).s0;
  W11.y = as_uint2(block[6]).s1;
  W11.z = as_uint2(block[7]).s0;
  W11.w = as_uint2(block[7]).s1;
  W12.x = as_uint2(block[8]).s0;
  W12.y = as_uint2(block[8]).s1;
  W12.z = as_uint2(block[9]).s0;
  W12.w = gid;

  barrier(CLK_LOCAL_MEM_FENCE);

  tmp = Echo_AES_Round_Small(AES0, W8);
  tmp.s0 ^= 8 | 0x280;
  W8 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W9);
  tmp.s0 ^= 9 | 0x280;
  W9 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W10);
  tmp.s0 ^= 10 | 0x280;
  W10 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W11);
  tmp.s0 ^= 11 | 0x280;
  W11 = Echo_AES_Round_Small(AES0, tmp);
  tmp = Echo_AES_Round_Small(AES0, W12);
  tmp.s0 ^= 12 | 0x280;
  W12 = Echo_AES_Round_Small(AES0, tmp);

  BigShiftRows(W);
  BigMixColumns(W);

  #pragma unroll 1
  for(uint k0 = 16; k0 < 160; k0 += 16) {
      BigSubBytesSmall80(AES0, W, k0);
      BigShiftRows(W);
      BigMixColumns(W);
  }

  //#pragma unroll
  //for(int i = 0; i < 4; ++i)
  //  vstore4(vload4(i, hash->h4) ^ W[i] ^ W[i + 8] ^ (uint4)(512, 0, 0, 0), i, hash->h4);
 hash->h4[0 ] = as_uint2(block[0]).s0  ^ W0.x ^ W8.x  ^ 512;
 hash->h4[1 ] = as_uint2(block[0]).s1  ^ W0.y ^ W8.y  ^ 0;
 hash->h4[2 ] = as_uint2(block[1]).s0  ^ W0.z ^ W8.z  ^ 0;
 hash->h4[3 ] = as_uint2(block[1]).s1  ^ W0.w ^ W8.w  ^ 0;
 hash->h4[4 ] = as_uint2(block[2]).s0  ^ W1.x ^ W9.x  ^ 512;
 hash->h4[5 ] = as_uint2(block[2]).s1  ^ W1.y ^ W9.y  ^ 0;
 hash->h4[6 ] = as_uint2(block[3]).s0  ^ W1.z ^ W9.z  ^ 0;
 hash->h4[7 ] = as_uint2(block[3]).s1  ^ W1.w ^ W9.w  ^ 0;
 hash->h4[8 ] = as_uint2(block[4]).s0  ^ W2.x ^ W10.x ^ 512;
 hash->h4[9 ] = as_uint2(block[4]).s1  ^ W2.y ^ W10.y ^ 0;
 hash->h4[10] = as_uint2(block[5]).s0 ^ W2.z ^ W10.z ^ 0;
 hash->h4[11] = as_uint2(block[5]).s1 ^ W2.w ^ W10.w ^ 0;
 hash->h4[12] = as_uint2(block[6]).s0 ^ W3.x ^ W11.x ^ 512;
 hash->h4[13] = as_uint2(block[6]).s1 ^ W3.y ^ W11.y ^ 0;
 hash->h4[14] = as_uint2(block[7]).s0 ^ W3.z ^ W11.z ^ 0;
 hash->h4[15] = as_uint2(block[7]).s1 ^ W3.w ^ W11.w ^ 0;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// hamsi64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search23(__global hash_t* hashes)
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

// hamsi80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search24(__global ulong* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
  ulong input[10];

  #pragma unroll
  for (int i = 0; i < 9; i++)
    input[i] = block[i];

  input[9] = (block[9] & 0xffffffff) ^ ((ulong)gid << 32);

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

	sph_u32 c0 = HAMSI_IV512[0], c1 = HAMSI_IV512[1], c2 = HAMSI_IV512[2], c3 = HAMSI_IV512[3];
	sph_u32 c4 = HAMSI_IV512[4], c5 = HAMSI_IV512[5], c6 = HAMSI_IV512[6], c7 = HAMSI_IV512[7];
	sph_u32 c8 = HAMSI_IV512[8], c9 = HAMSI_IV512[9], cA = HAMSI_IV512[10], cB = HAMSI_IV512[11];
	sph_u32 cC = HAMSI_IV512[12], cD = HAMSI_IV512[13], cE = HAMSI_IV512[14], cF = HAMSI_IV512[15];
	sph_u32 m0, m1, m2, m3, m4, m5, m6, m7;
	sph_u32 m8, m9, mA, mB, mC, mD, mE, mF;
	sph_u32 h[16] = { c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, cA, cB, cC, cD, cE, cF };

  #define buf(u) ((unsigned char*)input)[i + u]

  for(int i = 0; i < 80; i += 8) {
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

  m0 = tp[0x310] ^ tp[0x3F0]; m1 = tp[0x311] ^ tp[0x3F1];
  m2 = tp[0x312] ^ tp[0x3F2]; m3 = tp[0x313] ^ tp[0x3F3];
  m4 = tp[0x314] ^ tp[0x3F4]; m5 = tp[0x315] ^ tp[0x3F5];
  m6 = tp[0x316] ^ tp[0x3F6]; m7 = tp[0x317] ^ tp[0x3F7];
  m8 = tp[0x318] ^ tp[0x3F8]; m9 = tp[0x319] ^ tp[0x3F9];
  mA = tp[0x31A] ^ tp[0x3FA]; mB = tp[0x31B] ^ tp[0x3FB];
  mC = tp[0x31C] ^ tp[0x3FC]; mD = tp[0x31D] ^ tp[0x3FD];
  mE = tp[0x31E] ^ tp[0x3FE]; mF = tp[0x31F] ^ tp[0x3FF];

  PF_BIG;
  T_BIG;

  for (unsigned u = 0; u < 16; u ++)
    hash->h4[u] = ENC32E(h[u]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// fugue64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search25(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  // mixtab
  __local sph_u32 mixtab0[256], mixtab1[256], mixtab2[256], mixtab3[256];
  int init = get_local_id(0);
  int step = get_local_size(0);
  for (int i = init; i < 256; i += step) {
    mixtab0[i] = mixtab0_c[i];
    mixtab1[i] = mixtab1_c[i];
    mixtab2[i] = mixtab2_c[i];
    mixtab3[i] = mixtab3_c[i];
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  sph_u32 S00, S01, S02, S03, S04, S05, S06, S07, S08, S09;
  sph_u32 S10, S11, S12, S13, S14, S15, S16, S17, S18, S19;
  sph_u32 S20, S21, S22, S23, S24, S25, S26, S27, S28, S29;
  sph_u32 S30, S31, S32, S33, S34, S35;

  ulong fc_bit_count = (sph_u64) 64 << 3;

  S00 = S01 = S02 = S03 = S04 = S05 = S06 = S07 = S08 = S09 = S10 = S11 = S12 = S13 = S14 = S15 = S16 = S17 = S18 = S19 = 0;
  S20 = SPH_C32(0x8807a57e); S21 = SPH_C32(0xe616af75); S22 = SPH_C32(0xc5d3e4db); S23 = SPH_C32(0xac9ab027);
  S24 = SPH_C32(0xd915f117); S25 = SPH_C32(0xb6eecc54); S26 = SPH_C32(0x06e8020b); S27 = SPH_C32(0x4a92efd1);
  S28 = SPH_C32(0xaac6e2c9); S29 = SPH_C32(0xddb21398); S30 = SPH_C32(0xcae65838); S31 = SPH_C32(0x437f203f);
  S32 = SPH_C32(0x25ea78e7); S33 = SPH_C32(0x951fddd6); S34 = SPH_C32(0xda6ed11d); S35 = SPH_C32(0xe13e3567);

  FUGUE512_3(DEC32E(hash->h4[0x0]), DEC32E(hash->h4[0x1]), DEC32E(hash->h4[0x2]));
  FUGUE512_3(DEC32E(hash->h4[0x3]), DEC32E(hash->h4[0x4]), DEC32E(hash->h4[0x5]));
  FUGUE512_3(DEC32E(hash->h4[0x6]), DEC32E(hash->h4[0x7]), DEC32E(hash->h4[0x8]));
  FUGUE512_3(DEC32E(hash->h4[0x9]), DEC32E(hash->h4[0xA]), DEC32E(hash->h4[0xB]));
  FUGUE512_3(DEC32E(hash->h4[0xC]), DEC32E(hash->h4[0xD]), DEC32E(hash->h4[0xE]));
  FUGUE512_3(DEC32E(hash->h4[0xF]), as_uint2(fc_bit_count).y, as_uint2(fc_bit_count).x);

  // apply round shift if necessary
  int i;

  for (i = 0; i < 32; i ++) {
    ROR3;
    CMIX36(S00, S01, S02, S04, S05, S06, S18, S19, S20);
    SMIX(S00, S01, S02, S03);
  }

  for (i = 0; i < 13; i ++) {
    S04 ^= S00;
    S09 ^= S00;
    S18 ^= S00;
    S27 ^= S00;
    ROR9;
    SMIX(S00, S01, S02, S03);
    S04 ^= S00;
    S10 ^= S00;
    S18 ^= S00;
    S27 ^= S00;
    ROR9;
    SMIX(S00, S01, S02, S03);
    S04 ^= S00;
    S10 ^= S00;
    S19 ^= S00;
    S27 ^= S00;
    ROR9;
    SMIX(S00, S01, S02, S03);
    S04 ^= S00;
    S10 ^= S00;
    S19 ^= S00;
    S28 ^= S00;
    ROR8;
    SMIX(S00, S01, S02, S03);
  }

  S04 ^= S00;
  S09 ^= S00;
  S18 ^= S00;
  S27 ^= S00;

  hash->h4[0] = ENC32E(S01);
  hash->h4[1] = ENC32E(S02);
  hash->h4[2] = ENC32E(S03);
  hash->h4[3] = ENC32E(S04);
  hash->h4[4] = ENC32E(S09);
  hash->h4[5] = ENC32E(S10);
  hash->h4[6] = ENC32E(S11);
  hash->h4[7] = ENC32E(S12);
  hash->h4[8] = ENC32E(S18);
  hash->h4[9] = ENC32E(S19);
  hash->h4[10] = ENC32E(S20);
  hash->h4[11] = ENC32E(S21);
  hash->h4[12] = ENC32E(S27);
  hash->h4[13] = ENC32E(S28);
  hash->h4[14] = ENC32E(S29);
  hash->h4[15] = ENC32E(S30);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// fugue80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search26(__global uint* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // mixtab
  __local sph_u32 mixtab0[256], mixtab1[256], mixtab2[256], mixtab3[256];
  int init = get_local_id(0);
  int step = get_local_size(0);
  for (int i = init; i < 256; i += step) {
    mixtab0[i] = mixtab0_c[i];
    mixtab1[i] = mixtab1_c[i];
    mixtab2[i] = mixtab2_c[i];
    mixtab3[i] = mixtab3_c[i];
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  // fugue
  sph_u32 S00, S01, S02, S03, S04, S05, S06, S07, S08, S09;
  sph_u32 S10, S11, S12, S13, S14, S15, S16, S17, S18, S19;
  sph_u32 S20, S21, S22, S23, S24, S25, S26, S27, S28, S29;
  sph_u32 S30, S31, S32, S33, S34, S35;

  uint fc_bit_count = 80 << 3;

  S00 = S01 = S02 = S03 = S04 = S05 = S06 = S07 = S08 = S09 = S10 = S11 = S12 = S13 = S14 = S15 = S16 = S17 = S18 = S19 = 0;
  S20 = SPH_C32(0x8807a57e); S21 = SPH_C32(0xe616af75); S22 = SPH_C32(0xc5d3e4db); S23 = SPH_C32(0xac9ab027);
  S24 = SPH_C32(0xd915f117); S25 = SPH_C32(0xb6eecc54); S26 = SPH_C32(0x06e8020b); S27 = SPH_C32(0x4a92efd1);
  S28 = SPH_C32(0xaac6e2c9); S29 = SPH_C32(0xddb21398); S30 = SPH_C32(0xcae65838); S31 = SPH_C32(0x437f203f);
  S32 = SPH_C32(0x25ea78e7); S33 = SPH_C32(0x951fddd6); S34 = SPH_C32(0xda6ed11d); S35 = SPH_C32(0xe13e3567);

  FUGUE512_3(DEC32E(block[0x0]), DEC32E(block[0x1]), DEC32E(block[0x2]));
  FUGUE512_3(DEC32E(block[0x3]), DEC32E(block[0x4]), DEC32E(block[0x5]));
  FUGUE512_3(DEC32E(block[0x6]), DEC32E(block[0x7]), DEC32E(block[0x8]));
  FUGUE512_3(DEC32E(block[0x9]), DEC32E(block[0xA]), DEC32E(block[0xB]));
  FUGUE512_3(DEC32E(block[0xC]), DEC32E(block[0xD]), DEC32E(block[0xE]));
  FUGUE512_3(DEC32E(block[0xF]), DEC32E(block[0x10]), DEC32E(block[0x11]));
  FUGUE512_4(DEC32E(block[0x12]), DEC32E(gid), 0, fc_bit_count);

  ROR3;
  ROR9;

  int i;

  for (i = 0; i < 32; i ++) {
    ROR3;
    CMIX36(S00, S01, S02, S04, S05, S06, S18, S19, S20);
    SMIX(S00, S01, S02, S03);
  }

  for (i = 0; i < 13; i ++) {
    S04 ^= S00;
    S09 ^= S00;
    S18 ^= S00;
    S27 ^= S00;
    ROR9;
    SMIX(S00, S01, S02, S03);
    S04 ^= S00;
    S10 ^= S00;
    S18 ^= S00;
    S27 ^= S00;
    ROR9;
    SMIX(S00, S01, S02, S03);
    S04 ^= S00;
    S10 ^= S00;
    S19 ^= S00;
    S27 ^= S00;
    ROR9;
    SMIX(S00, S01, S02, S03);
    S04 ^= S00;
    S10 ^= S00;
    S19 ^= S00;
    S28 ^= S00;
    ROR8;
    SMIX(S00, S01, S02, S03);
  }

  S04 ^= S00;
  S09 ^= S00;
  S18 ^= S00;
  S27 ^= S00;

  hash->h4[0] = ENC32E(S01);
  hash->h4[1] = ENC32E(S02);
  hash->h4[2] = ENC32E(S03);
  hash->h4[3] = ENC32E(S04);
  hash->h4[4] = ENC32E(S09);
  hash->h4[5] = ENC32E(S10);
  hash->h4[6] = ENC32E(S11);
  hash->h4[7] = ENC32E(S12);
  hash->h4[8] = ENC32E(S18);
  hash->h4[9] = ENC32E(S19);
  hash->h4[10] = ENC32E(S20);
  hash->h4[11] = ENC32E(S21);
  hash->h4[12] = ENC32E(S27);
  hash->h4[13] = ENC32E(S28);
  hash->h4[14] = ENC32E(S29);
  hash->h4[15] = ENC32E(S30);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// shabal64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search27(__global hash_t* hashes)
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

// shabal80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search28(__global uint* block, __global hash_t* hashes)
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
	M.s0 = block[0];
	M.s1 = block[1];
	M.s2 = block[2];
	M.s3 = block[3];
	M.s4 = block[4];
	M.s5 = block[5];
	M.s6 = block[6];
	M.s7 = block[7];
	M.s8 = block[8];
	M.s9 = block[9];
	M.sa = block[10];
	M.sb = block[11];
	M.sc = block[12];
	M.sd = block[13];
	M.se = block[14];
	M.sf = block[15];
	
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
	M.s0 = block[16];
	M.s1 = block[17];
	M.s2 = block[18];
	M.s3 = gid;
	M.s4 = 0x80;
	
	#pragma unroll 2
	for(int i = 0; i < 4; ++i)
	{
		SWAP_BC_V;
		
		// INPUT_BLOCK_ADD
		B.s0 = select(B.s0, B.s0 += M.s0, i==0);
		B.s1 = select(B.s1, B.s1 += M.s1, i==0);
		B.s2 = select(B.s2, B.s2 += M.s2, i==0);
		B.s3 = select(B.s3, B.s3 += M.s3, i==0);
		B.s4 = select(B.s4, B.s4 += M.s4, i==0);
		
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

// whirlpool64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search29(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  __local sph_u64 LT0[256], LT1[256], LT2[256], LT3[256], LT4[256], LT5[256], LT6[256], LT7[256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  for (int i = init; i < 256; i += step) {
    LT0[i] = plain_T0[i];
    LT1[i] = plain_T1[i];
    LT2[i] = plain_T2[i];
    LT3[i] = plain_T3[i];
    LT4[i] = plain_T4[i];
    LT5[i] = plain_T5[i];
    LT6[i] = plain_T6[i];
    LT7[i] = plain_T7[i];
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  // whirlpool
  volatile sph_u64 n0, n1, n2, n3, n4, n5, n6, n7;
  volatile sph_u64 h0, h1, h2, h3, h4, h5, h6, h7;
  sph_u64 state[8];

  n0 = (hash->h8[0]);
  n1 = (hash->h8[1]);
  n2 = (hash->h8[2]);
  n3 = (hash->h8[3]);
  n4 = (hash->h8[4]);
  n5 = (hash->h8[5]);
  n6 = (hash->h8[6]);
  n7 = (hash->h8[7]);

  h0 = h1 = h2 = h3 = h4 = h5 = h6 = h7 = 0;

  //#pragma unroll 10
  for (unsigned r = 0; r < 10; r ++) {
    volatile sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;

    ROUND_KSCHED(LT, h, tmp, plain_RC[r]);
    TRANSFER(h, tmp);
    ROUND_WENC(LT, n, h, tmp);
    TRANSFER(n, tmp);
  }

  state[0] = n0 ^ (hash->h8[0]);
  state[1] = n1 ^ (hash->h8[1]);
  state[2] = n2 ^ (hash->h8[2]);
  state[3] = n3 ^ (hash->h8[3]);
  state[4] = n4 ^ (hash->h8[4]);
  state[5] = n5 ^ (hash->h8[5]);
  state[6] = n6 ^ (hash->h8[6]);
  state[7] = n7 ^ (hash->h8[7]);

  n0 = 0x80;
  n7 = 0x2000000000000;

  h0 = state[0];
  h1 = state[1];
  h2 = state[2];
  h3 = state[3];
  h4 = state[4];
  h5 = state[5];
  h6 = state[6];
  h7 = state[7];

  n0 ^= h0;
  n1 = h1;
  n2 = h2;
  n3 = h3;
  n4 = h4;
  n5 = h5;
  n6 = h6;
  n7 ^= h7;

  //#pragma unroll 10
  for (unsigned r = 0; r < 10; r ++) {
    volatile sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;

    ROUND_KSCHED(LT, h, tmp, plain_RC[r]);
    TRANSFER(h, tmp);
    ROUND_WENC(LT, n, h, tmp);
    TRANSFER(n, tmp);
  }

  state[0] ^= n0 ^ 0x80;
  state[1] ^= n1;
  state[2] ^= n2;
  state[3] ^= n3;
  state[4] ^= n4;
  state[5] ^= n5;
  state[6] ^= n6;
  state[7] ^= n7 ^ 0x2000000000000;

  hash->h8[0] = state[0];
  hash->h8[1] = state[1];
  hash->h8[2] = state[2];
  hash->h8[3] = state[3];
  hash->h8[4] = state[4];
  hash->h8[5] = state[5];
  hash->h8[6] = state[6];
  hash->h8[7] = state[7];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// whirlpool80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search30(__global ulong* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);
  ulong b9 = (block[9] & 0xffffffff) ^ ((ulong)gid << 32);

  __local sph_u64 LT0[256], LT1[256], LT2[256], LT3[256], LT4[256], LT5[256], LT6[256], LT7[256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  for (int i = init; i < 256; i += step) {
    LT0[i] = plain_T0[i];
    LT1[i] = plain_T1[i];
    LT2[i] = plain_T2[i];
    LT3[i] = plain_T3[i];
    LT4[i] = plain_T4[i];
    LT5[i] = plain_T5[i];
    LT6[i] = plain_T6[i];
    LT7[i] = plain_T7[i];
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  volatile sph_u64 n0, n1, n2, n3, n4, n5, n6, n7;
  volatile sph_u64 h0, h1, h2, h3, h4, h5, h6, h7;
  sph_u64 state[8];

  n0 = block[0];
  n1 = block[1];
  n2 = block[2];
  n3 = block[3];
  n4 = block[4];
  n5 = block[5];
  n6 = block[6];
  n7 = block[7];

  h0 = h1 = h2 = h3 = h4 = h5 = h6 = h7 = 0;

  //#pragma unroll 10
  for (unsigned r = 0; r < 10; r ++) {
      volatile sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
      ROUND_KSCHED(LT, h, tmp, plain_RC[r]);
      TRANSFER(h, tmp);
      ROUND_WENC(LT, n, h, tmp);
      TRANSFER(n, tmp);
  }

  state[0] = n0 ^ block[0];
  state[1] = n1 ^ block[1];
  state[2] = n2 ^ block[2];
  state[3] = n3 ^ block[3];
  state[4] = n4 ^ block[4];
  state[5] = n5 ^ block[5];
  state[6] = n6 ^ block[6];
  state[7] = n7 ^ block[7];

  n0 = block[8];
  n1 = b9;
  n2 = 0x80;
  n3 = n4 = n5 = n6 = 0;
  n7 = 0x8002000000000000UL;

  h0 = state[0];
  h1 = state[1];
  h2 = state[2];
  h3 = state[3];
  h4 = state[4];
  h5 = state[5];
  h6 = state[6];
  h7 = state[7];

  n0 ^= h0;
  n1 ^= h1;
  n2 ^= h2;
  n3 ^= h3;
  n4 ^= h4;
  n5 ^= h5;
  n6 ^= h6;
  n7 ^= h7;

  //#pragma unroll 10
  for (unsigned r = 0; r < 10; r ++) {
      volatile sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
      ROUND_KSCHED(LT, h, tmp, plain_RC[r]);
      TRANSFER(h, tmp);
      ROUND_WENC(LT, n, h, tmp);
      TRANSFER(n, tmp);
  }

  state[0] ^= n0 ^ block[8];
  state[1] ^= n1 ^ b9;
  state[2] ^= n2 ^ 0x80;
  state[3] ^= n3;
  state[4] ^= n4;
  state[5] ^= n5;
  state[6] ^= n6;
  state[7] ^= n7 ^ 0x8002000000000000UL;

  hash->h8[0] = state[0];
  hash->h8[1] = state[1];
  hash->h8[2] = state[2];
  hash->h8[3] = state[3];
  hash->h8[4] = state[4];
  hash->h8[5] = state[5];
  hash->h8[6] = state[6];
  hash->h8[7] = state[7];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// sha512_64
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search31(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  sph_u64 W[16];
  sph_u64 SHA512Out[8];

  #pragma unroll
  for(int i = 0; i < 8; i++)
    W[i] = DEC64E(hash->h8[i]);

  W[8] = 0x8000000000000000UL;

  #pragma unroll
  for (int i = 9; i < 15; i++)
    W[i] = 0;

  W[15] = 0x0000000000000200UL;

  #pragma unroll
  for(int i = 0; i < 8; i++)
    SHA512Out[i] = SHA512_INIT[i];

  SHA512Block(W, SHA512Out);

  #pragma unroll
  for (int i = 0; i < 8; i++)
    hash->h8[i] = ENC64E(SHA512Out[i]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// sha512_80
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search32(__global unsigned char* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  sph_u64 W[16];
  sph_u64 SHA512Out[8];

  #pragma unroll
  for(int i = 0; i < 10; i++)
    W[i] = DEC64BE(block + i * 8);

  W[9] &= 0xFFFFFFFF00000000;
  W[9] ^= SWAP4(gid);
  W[10] = 0x8000000000000000UL;

  #pragma unroll
  for (int i = 11; i < 15; i++)
    W[i] = 0;

  W[15] = 0x0000000000000280UL;

  #pragma unroll
  for(int i = 0; i < 8; i++)
    SHA512Out[i] = SHA512_INIT[i];

  SHA512Block(W, SHA512Out);

  #pragma unroll
  for (int i = 0; i < 8; i++)
    hash->h8[i] = ENC64E(SHA512Out[i]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global hash_t* hashes, __global uint* output, const ulong target)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  bool result = (hash->h8[3] <= target);
  if (result) {
    uint i = atomic_inc(output+0xFF);
    if (i < 0xFF)
      output[i] = SWAP4(gid);
  }
}

#endif // X16_CL
