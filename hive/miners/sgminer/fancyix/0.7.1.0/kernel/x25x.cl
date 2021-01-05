/*
 * X25x kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2014  phm
 * Copyright (c) 2014 Girino Vey
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
 * @author   phm <phm@inbox.com>
 * @author   ccminer-x22i 2018
 * @author   lyclminer 2018
 * @author   fancyIX 2018
 */

#ifndef X25X_CL
#define X25X_CL

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
#define SPH_ROTR64(x, n)   SPH_ROTL64(x, (64 - (n)))
#define SPH_ROTL64(x, n) rotate(as_ulong(x), (n) & 0xFFFFFFFFFFFFFFFFUL)

#define SPH_C64(x)    ((sph_u64)(x ## UL))
#define SPH_T64(x) (as_ulong(x))

#define SPH_ECHO_64 1
#define SPH_KECCAK_64 1
#define SPH_JH_64 1
#define SPH_SIMD_NOCOPY 0
#define SPH_KECCAK_NOCOPY 0
#define SPH_SMALL_FOOTPRINT_GROESTL 0
#define SPH_GROESTL_BIG_ENDIAN 0
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

#include "lyra2v2ly.cl"

#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

ulong FAST_ROTL64_LO(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x, x.s10, 32 - y))); }
ulong FAST_ROTL64_HI(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x.s10, x, 32 - (y - 32)))); }
ulong ROTL64_1(const uint2 vv, const int r) { return as_ulong(amd_bitalign((vv).xy, (vv).yx, 32 - r)); }
ulong ROTL64_2(const uint2 vv, const int r) { return as_ulong((amd_bitalign((vv).yx, (vv).xy, 64 - r))); }

#define VSWAP8(x)	(((x) >> 56) | (((x) >> 40) & 0x000000000000FF00UL) | (((x) >> 24) & 0x0000000000FF0000UL) \
          | (((x) >>  8) & 0x00000000FF000000UL) | (((x) <<  8) & 0x000000FF00000000UL) \
          | (((x) << 24) & 0x0000FF0000000000UL) | (((x) << 40) & 0x00FF000000000000UL) | (((x) << 56) & 0xFF00000000000000UL))

#define WOLF_JH_64BIT 1


#include "wolf-aes.cl"
#include "blake.cl"
#include "wolf-bmw.cl"
#include "wolf-groestl.cl"
#include "wolf-jh.cl"
#include "keccak.cl"
#include "wolf-skein.cl"
#include "wolf-luffa.cl"
#include "wolf-cubehash.cl"
#include "wolf-shavite.cl"
#include "simd-f.cl"
#include "echo-f.cl"
#include "hamsi.cl"
#include "fugue.cl"
#include "wolf-shabal.cl"
#include "whirlpool.cl"
#include "wolf-sha512.cl"
#include "haval.cl"
#include "gost-mod-f.cl"
#include "swifftx.cl"
#include "tiger.cl"
#include "sha256f.cl"
#include "panama.cl"
#include "lane.cl"
#include "blake2s.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
#define SWAP32(a)    (as_uint(as_uchar4(a).wzyx))

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

#define X25X_HASH_ARRAY_SIZE 24

// blake
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global unsigned char* block, __global hash_t* hashes)
{
    uint gid = get_global_id(0);
    __global hash_t *hash = &(hashes[X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

  sph_u64 V0 = BLAKE_IV512[0], V1 = BLAKE_IV512[1], V2 = BLAKE_IV512[2], V3 = BLAKE_IV512[3];
  sph_u64 V4 = BLAKE_IV512[4], V5 = BLAKE_IV512[5], V6 = BLAKE_IV512[6], V7 = BLAKE_IV512[7];
  sph_u64 V8 = CB0, V9 = CB1, VA = CB2, VB = CB3;
  sph_u64 VC = 0x452821E638D011F7UL, VD = 0xBE5466CF34E90EECUL, VE = CB6, VF = CB7;

  volatile sph_u64 M0, M1, M2, M3, M4, M5, M6, M7;
  volatile sph_u64 M8, M9, MA, MB, MC, MD, ME, MF;

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

// bmw
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
{
  ulong msg[16] = { 0 };
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[1 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	

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
	for(int i = 0; i < 8; ++i) hash1->h8[i] = msg[i + 8];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// groestl
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[1 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[2 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	

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
  hash1->h8[0] = M_0 ^ G_8;
  hash1->h8[1] = M_1 ^ G_9;
  hash1->h8[2] = M_2 ^ G_10;
  hash1->h8[3] = M_3 ^ G_11;
  hash1->h8[4] = M_4 ^ G_12;
  hash1->h8[5] = M_5 ^ G_13;
  hash1->h8[6] = M_6 ^ G_14;
  hash1->h8[7] = M_7 ^ G_15;
  barrier(CLK_GLOBAL_MEM_FENCE);
}

// skein
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search3(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[2 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[3 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
	
	const ulong8 m = vload8(0, hash->h8);
	
	const ulong8 h = (ulong8)(	0x4903ADFF749C51CEUL, 0x0D95DE399746DF03UL, 0x8FD1934127C79BCEUL, 0x9A255629FF352CB1UL,
								0x5DB62599DF6CA7B0UL, 0xEABE394CA9D5C3F4UL, 0x991112C71A75B523UL, 0xAE18A40B660FCC33UL);
	
	const ulong t[3] = { 0x40UL, 0xF000000000000000UL, 0xF000000000000040UL }, t2[3] = { 0x08UL, 0xFF00000000000000UL, 0xFF00000000000008UL };
		
	ulong8 p = Skein512Block(m, h, 0xCAB2076D98173EC4UL, t);
	
	const ulong8 h2 = m ^ p;
	p = (ulong8)(0);
	ulong h8 = h2.s0 ^ h2.s1 ^ h2.s2 ^ h2.s3 ^ h2.s4 ^ h2.s5 ^ h2.s6 ^ h2.s7 ^ 0x1BD11BDAA9FC1A22UL;
	
	p = Skein512Block(p, h2, h8, t2);
	//p = VSWAP8(p);
	
	vstore8(p, 0, hash1->h8);
	
	barrier(CLK_GLOBAL_MEM_FENCE);
}

// jh
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[3 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[4 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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
	
	hash1->h8[0] = as_ulong(evnhi.s2);
	hash1->h8[1] = as_ulong(evnlo.s2);
	hash1->h8[2] = as_ulong(oddhi.s2);
	hash1->h8[3] = as_ulong(oddlo.s2);
	hash1->h8[4] = as_ulong(evnhi.s3);
	hash1->h8[5] = as_ulong(evnlo.s3);
	hash1->h8[6] = as_ulong(oddhi.s3);
	hash1->h8[7] = as_ulong(oddlo.s3);
	
	#else
	
	evnhi.hi.lo ^= JH_BASE_TYPE_CAST(0x80UL);
	oddlo.hi.hi ^= JH_BASE_TYPE_CAST(0x2000000000000UL);
	
	hash1->h8[0] = as_ulong(evnhi.hi.lo);
	hash1->h8[1] = as_ulong(evnlo.hi.lo);
	hash1->h8[2] = as_ulong(oddhi.hi.lo);
	hash1->h8[3] = as_ulong(oddlo.hi.lo);
	hash1->h8[4] = as_ulong(evnhi.hi.hi);
	hash1->h8[5] = as_ulong(evnlo.hi.hi);
	hash1->h8[6] = as_ulong(oddhi.hi.hi);
	hash1->h8[7] = as_ulong(oddlo.hi.hi);
	
	#endif

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// keccak
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[4 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[5 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

  volatile sph_u64 a00 = 0, a01 = 0, a02 = 0, a03 = 0, a04 = 0;
  volatile sph_u64 a10 = 0, a11 = 0, a12 = 0, a13 = 0, a14 = 0;
  volatile sph_u64 a20 = 0, a21 = 0, a22 = 0, a23 = 0, a24 = 0;
  volatile sph_u64 a30 = 0, a31 = 0, a32 = 0, a33 = 0, a34 = 0;
  volatile sph_u64 a40 = 0, a41 = 0, a42 = 0, a43 = 0, a44 = 0;

  a10 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a20 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a31 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a22 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a23 = SPH_C64(0xFFFFFFFFFFFFFFFF);
  a04 = SPH_C64(0xFFFFFFFFFFFFFFFF);

  a00 ^= hash->h8[0];
  a10 ^= hash->h8[1];
  a20 ^= hash->h8[2];
  a30 ^= hash->h8[3];
  a40 ^= hash->h8[4];
  a01 ^= hash->h8[5];
  a11 ^= hash->h8[6];
  a21 ^= hash->h8[7];
  a31 ^= 0x8000000000000001;
  KECCAK_F_1600;

  // Finalize the "lane complement"
  a10 = ~a10;
  a20 = ~a20;

  hash1->h8[0] = a00;
  hash1->h8[1] = a10;
  hash1->h8[2] = a20;
  hash1->h8[3] = a30;
  hash1->h8[4] = a40;
  hash1->h8[5] = a01;
  hash1->h8[6] = a11;
  hash1->h8[7] = a21;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// luffa
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search6(__global hash_t* hashes)
{
   uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[5 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[6 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);
	
	uint8 V[5] =
	{
		(uint8)(0x6D251E69U, 0x44B051E0U, 0x4EAA6FB4U, 0xDBF78465U, 0x6E292011U, 0x90152DF4U, 0xEE058139U, 0xDEF610BBU),
		(uint8)(0xC3B44B95U, 0xD9D2F256U, 0x70EEE9A0U, 0xDE099FA3U, 0x5D9B0557U, 0x8FC944B3U, 0xCF1CCF0EU, 0x746CD581U),
		(uint8)(0xF7EFC89DU, 0x5DBA5781U, 0x04016CE5U, 0xAD659C05U, 0x0306194FU, 0x666D1836U, 0x24AA230AU, 0x8B264AE7U),
		(uint8)(0x858075D5U, 0x36D79CCEU, 0xE571F7D7U, 0x204B1F67U, 0x35870C6AU, 0x57E9E923U, 0x14BCB808U, 0x7CDE72CEU),
		(uint8)(0x6C68E9BEU, 0x5EC41E22U, 0xC825B7C7U, 0xAFFB4363U, 0xF5DF3999U, 0x0FC688F1U, 0xB07224CCU, 0x03E86CEAU)
	};
	
	#pragma unroll
	for(int i = 0; i < 8; ++i) hash1->h8[i] = SWAP8(hash->h8[i]);
	
	#pragma unroll
    for(int i = 0; i < 6; ++i)
    {
		uint8 M;
		switch(i)
		{
			case 0:
			case 1:
				M = shuffle(vload8(i, hash1->h4), (uint8)(1, 0, 3, 2, 5, 4, 7, 6));
				break;
			case 2:
			case 3:
				M = (uint8)(0);
				M.s0 = select(M.s0, 0x80000000, i==2);
				break;
			case 4:
			case 5:
				vstore8(shuffle(V[0] ^ V[1] ^ V[2] ^ V[3] ^ V[4], (uint8)(1, 0, 3, 2, 5, 4, 7, 6)), i & 1, hash1->h4);
		}
		if(i == 5) break;
		
		MessageInj(V, M);
		LuffaPerm(V);
    }
	
	#pragma unroll
	for(int i = 0; i < 8; ++i) hash1->h8[i] = SWAP8(hash1->h8[i]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// cubehash
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search7(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[6 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[7 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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
      vstore8(((ulong8 *)state)[0], 0, hash1->h8);
      break;
    }
    if(!i) ((ulong4 *)state)[0] ^= xor;
    state[0] ^= (i == 1) ? 0x80 : 0;
    state[31] ^= (i == 2) ? 1 : 0;
  }

  mem_fence(CLK_GLOBAL_MEM_FENCE);
}

// shavite
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search8(__global hash_t* hashes)
{
 __local uint AES0[256], AES1[256], AES2[256], AES3[256];
	
	uint gid = get_global_id(0);
 __global hash_t *hash = &(hashes[7 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[8 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);
	
	const int step = get_local_size(0);
	
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
	for(int i = 0; i < 4; ++i) vstore4(h[i] ^ p[(i + 2) & 3], i, hash1->h4);
	
	barrier(CLK_GLOBAL_MEM_FENCE);
}

// simd
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search9(__global hash_t* hashes)
{
    uint gid = get_global_id(0);
    __global hash_t *hash = &(hashes[8 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[9 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);
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
        s32 tq;

        tq = q[i] + yoff_b_n[i];
        tq = REDS2(tq);
        tq = REDS1(tq);
        tq = REDS1(tq);
        q[i] = (tq <= 128 ? tq : tq - 257);
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

    #define q SIMD_Q

    A0 ^= 0x200;

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

    hash1->h4[0] = A0;
    hash1->h4[1] = A1;
    hash1->h4[2] = A2;
    hash1->h4[3] = A3;
    hash1->h4[4] = A4;
    hash1->h4[5] = A5;
    hash1->h4[6] = A6;
    hash1->h4[7] = A7;
    hash1->h4[8] = B0;
    hash1->h4[9] = B1;
    hash1->h4[10] = B2;
    hash1->h4[11] = B3;
    hash1->h4[12] = B4;
    hash1->h4[13] = B5;
    hash1->h4[14] = B6;
    hash1->h4[15] = B7;

    barrier(CLK_GLOBAL_MEM_FENCE);
}

// echo
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search10(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[9 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[10 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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
 hash1->h4[0 ] = hash->h4[0]  ^ W0.x ^ W8.x  ^ 512;
 hash1->h4[1 ] = hash->h4[1]  ^ W0.y ^ W8.y  ^ 0;
 hash1->h4[2 ] = hash->h4[2]  ^ W0.z ^ W8.z  ^ 0;
 hash1->h4[3 ] = hash->h4[3]  ^ W0.w ^ W8.w  ^ 0;
 hash1->h4[4 ] = hash->h4[4]  ^ W1.x ^ W9.x  ^ 512;
 hash1->h4[5 ] = hash->h4[5]  ^ W1.y ^ W9.y  ^ 0;
 hash1->h4[6 ] = hash->h4[6]  ^ W1.z ^ W9.z  ^ 0;
 hash1->h4[7 ] = hash->h4[7]  ^ W1.w ^ W9.w  ^ 0;
 hash1->h4[8 ] = hash->h4[8]  ^ W2.x ^ W10.x ^ 512;
 hash1->h4[9 ] = hash->h4[9]  ^ W2.y ^ W10.y ^ 0;
 hash1->h4[10] = hash->h4[10] ^ W2.z ^ W10.z ^ 0;
 hash1->h4[11] = hash->h4[11] ^ W2.w ^ W10.w ^ 0;
 hash1->h4[12] = hash->h4[12] ^ W3.x ^ W11.x ^ 512;
 hash1->h4[13] = hash->h4[13] ^ W3.y ^ W11.y ^ 0;
 hash1->h4[14] = hash->h4[14] ^ W3.z ^ W11.z ^ 0;
 hash1->h4[15] = hash->h4[15] ^ W3.w ^ W11.w ^ 0;

  barrier(CLK_GLOBAL_MEM_FENCE);
}


// hamsi
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search11(__global hash_t* hashes)
{
   uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[10 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[11 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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
    hash1->h4[u] = ENC32E(h[u]);


  barrier(CLK_GLOBAL_MEM_FENCE);
}

// fugue
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search12(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[11 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[12 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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

  hash1->h4[0] = ENC32E(S01);
  hash1->h4[1] = ENC32E(S02);
  hash1->h4[2] = ENC32E(S03);
  hash1->h4[3] = ENC32E(S04);
  hash1->h4[4] = ENC32E(S09);
  hash1->h4[5] = ENC32E(S10);
  hash1->h4[6] = ENC32E(S11);
  hash1->h4[7] = ENC32E(S12);
  hash1->h4[8] = ENC32E(S18);
  hash1->h4[9] = ENC32E(S19);
  hash1->h4[10] = ENC32E(S20);
  hash1->h4[11] = ENC32E(S21);
  hash1->h4[12] = ENC32E(S27);
  hash1->h4[13] = ENC32E(S28);
  hash1->h4[14] = ENC32E(S29);
  hash1->h4[15] = ENC32E(S30);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// copy hash0->hash1

// shabal hash1
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search13(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[12 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[13 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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
	
	vstore16(B, 0, hash1->h4);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// copy hash1->hash2

// whirlpool hash2
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search14(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[13 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[14 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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

  // #pragma unroll 10
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

  // #pragma unroll 10
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

  hash1->h8[0] = state[0];
  hash1->h8[1] = state[1];
  hash1->h8[2] = state[2];
  hash1->h8[3] = state[3];
  hash1->h8[4] = state[4];
  hash1->h8[5] = state[5];
  hash1->h8[6] = state[6];
  hash1->h8[7] = state[7];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// copy hash2->hash3

// sha512 hash3
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search15(__global hash_t* hashes)
{
    uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[14 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[15 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

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
    hash1->h8[i] = ENC64E(SHA512Out[i]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// swifftx hash hash1 hash2 hash3
__attribute__((reqd_work_group_size(8, 32, 1)))
__kernel void search16(__global hash_t *hashes)
{
    uint gid = get_global_id(1);
    uint offset = get_global_offset(1);
    uint thread = gid - offset;
    uint tid = get_local_id(1);

    __global uint* in  = (__global uint* ) &(hashes[12 + X25X_HASH_ARRAY_SIZE * (thread)]);	
    __global uint* in1 = (__global uint* ) &(hashes[13 + X25X_HASH_ARRAY_SIZE * (thread)]);
    __global uint* in2 = (__global uint* ) &(hashes[14 + X25X_HASH_ARRAY_SIZE * (thread)]);
    __global uint* in3 = (__global uint* ) &(hashes[15 + X25X_HASH_ARRAY_SIZE * (thread)]);
    __global uint* out = (__global uint* ) &(hashes[16 + X25X_HASH_ARRAY_SIZE * (thread)]);

  __local uchar S_in[256 * SFT_NSLOT];
  __local unsigned char S_SBox[256];
  __local swift_int16_t S_fftTable[256 * EIGHTH_N];
  __local swift_int16_t S_As[3 * SFT_M * SFT_N];
  swift_int32_t S_sum[3*SFT_N/ SFT_NSTRIDE];
  __local swift_int32_t T_sum[8 * SFT_NSLOT];
  __local unsigned char S_intermediate[(SFT_N*3 + 8) * SFT_NSLOT];
  __local uchar S_carry[8 * SFT_NSLOT];
  swift_int32_t pairs[EIGHTH_N / 2 ];
  char S_multipliers[8];

  #pragma unroll
  for (int i = 0; i < 8; i++) {
    S_multipliers[i] = multipliers[i + (SFT_STRIDE << 3)];
  }

  const int blockSize = min(256, SFT_NSLOT); //blockDim.x;

  if (tid < 256) {
    #pragma unroll
    for (int i=0; i<(256/blockSize/8) && (tid % 8 == 0); i++) {
      ((__local ulong *)S_SBox)[SFT_STRIDE + SFT_NSTRIDE * (tid / 8 + blockSize * (i))] = ((__constant ulong *)SFT_SBox)[SFT_STRIDE + SFT_NSTRIDE * (tid / 8 + blockSize * (i))];
    }
#define SFT_IDX(i) (SFT_STRIDE + SFT_NSTRIDE * (tid + blockSize * (i)))
    #pragma unroll
    for (int i=0; i<(256 * EIGHTH_N)/blockSize/8/4; i++) {
      ((__local ulong *)S_fftTable)[SFT_IDX(i)] = ((__constant ulong *)fftTable)[SFT_IDX(i)];
    }
    #pragma unroll
    for (int i=0; i<(3 * SFT_M * SFT_N)/blockSize/8/4; i++) {
      ((__local ulong *)S_As)[SFT_IDX(i)] = ((__constant ulong *)As)[SFT_IDX(i)];
    }
    barrier(CLK_LOCAL_MEM_FENCE);
}

  {
    __global unsigned char* inptr = (__global unsigned char*)in;
    __global unsigned char* in1ptr = (__global unsigned char*)in1;
    __global unsigned char* in2ptr = (__global unsigned char*)in2;
    __global unsigned char* in3ptr = (__global unsigned char*)in3;
    __global unsigned char* outptr = (__global unsigned char*)out;
    e_ComputeSingleSWIFFTX_2(outptr, inptr, in1ptr, in2ptr, in3ptr, S_in, S_SBox, S_As, S_fftTable, S_multipliers, S_sum, S_intermediate, S_carry, pairs, T_sum);
   }
   barrier(CLK_LOCAL_MEM_FENCE);
}

// haval
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search17(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[16 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[17 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

  sph_u32 s0 = SPH_C32(0x243F6A88);
  sph_u32 s1 = SPH_C32(0x85A308D3);
  sph_u32 s2 = SPH_C32(0x13198A2E);
  sph_u32 s3 = SPH_C32(0x03707344);
  sph_u32 s4 = SPH_C32(0xA4093822);
  sph_u32 s5 = SPH_C32(0x299F31D0);
  sph_u32 s6 = SPH_C32(0x082EFA98);
  sph_u32 s7 = SPH_C32(0xEC4E6C89);

  sph_u32 X_var[32];

  for (int i = 0; i < 16; i++)
    X_var[i] = hash->h4[i];

  X_var[16] = 0x00000001U;
  X_var[17] = 0x00000000U;
  X_var[18] = 0x00000000U;
  X_var[19] = 0x00000000U;
  X_var[20] = 0x00000000U;
  X_var[21] = 0x00000000U;
  X_var[22] = 0x00000000U;
  X_var[23] = 0x00000000U;
  X_var[24] = 0x00000000U;
  X_var[25] = 0x00000000U;
  X_var[26] = 0x00000000U;
  X_var[27] = 0x00000000U;
  X_var[28] = 0x00000000U;
  X_var[29] = 0x40290000U;
  X_var[30] = 0x00000200U;
  X_var[31] = 0x00000000U;

#define A(x) X_var[x]
  CORE5(A);
#undef A

  hash1->h4[0] = s0;
  hash1->h4[1] = s1;
  hash1->h4[2] = s2;
  hash1->h4[3] = s3;
  hash1->h4[4] = s4;
  hash1->h4[5] = s5;
  hash1->h4[6] = s6;
  hash1->h4[7] = s7;

  // padding 0 for x22i
  hash1->h4[0 + 8] = 0;
  hash1->h4[1 + 8] = 0;
  hash1->h4[2 + 8] = 0;
  hash1->h4[3 + 8] = 0;
  hash1->h4[4 + 8] = 0;
  hash1->h4[5 + 8] = 0;
  hash1->h4[6 + 8] = 0;
  hash1->h4[7 + 8] = 0;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// tiger
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search18(__global uint *d_hash)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);

		__global ulong* in = (__global ulong*)(d_hash + 16 * (17 + X25X_HASH_ARRAY_SIZE * (gid - offset)));
        __global ulong* out = (__global ulong*)(d_hash + 16 * (18 + X25X_HASH_ARRAY_SIZE * (gid - offset)));
        
		volatile ulong buf[3], in2[8];
#pragma unroll
		for (int i = 0; i < 3; i++) buf[i] = III[i];

  int init = get_local_id(0);
  int step = get_local_size(0);
  __local ulong T1[256], T2[256], T3[256], T4[256];

  _Pragma("unroll") for(int j=init;j<256;j+=step) {
      T1[j] = TIGER_T1[j];
      T2[j] = TIGER_T2[j];
      T3[j] = TIGER_T3[j];
      T4[j] = TIGER_T4[j];
  }
  barrier(CLK_LOCAL_MEM_FENCE);
  volatile ulong t0, t1;
  volatile ulong A, B, C;
	volatile ulong X0, X1, X2, X3, X4, X5, X6, X7;

		TIGER_ROUND_BODY(in, buf);

		in2[0] = 1;
#pragma unroll
		for (int i = 1 ; i < 7; i++) in2[i] = 0;
		in2[7] = 0x200;
		TIGER_ROUND_BODY(in2, buf);
#pragma unroll
		for (int i = 0; i < 3; i++) out[i] = buf[i];

		// 0 padding for x22
#pragma unroll
		for (int i = 3; i < 8; i++) out[i] = 0;
}

// lyra2v2
// lyra2v2 p1
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search19(__global uint* hashes, __global uint* lyraStates)
{
    int gid = get_global_id(0);
    
    __global hashly_t *hash = (__global hashly_t *)(hashes + (8* ((18 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)))<<1)));
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (gid-get_global_offset(0))));

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
// lyra2v2 p2
__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void search20(__global uint* lyraStates)
{
     __local struct SharedState smState[64];

    int gid = (get_global_id(0)-get_global_offset(0)) >> 2;
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (gid)));

    ulong state[4];
    ulong ttr;
    ulong tmpRes;
    
    uint2 st2;

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
    
    // 0,1,2 : 3,4,5 : 6,7,8 : 9,10,11
    // 12,13,14 : 15,16,17 : 18,19,20 : 21,22,23
    // 24,25,26 : 27,28,29 : 30,31,32 : 33,34,35
    // 36,37,38 : 39,40,41 : 42,43,44 : 45,46,47
    
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

    smState[lIdx].s0 = state[0];
    barrier(CLK_LOCAL_MEM_FENCE);
    uint rowa = (uint)smState[gr4].s0 & 3;
    wanderIteration(36,37,38, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 0, 1, 2);
    wanderIteration(39,40,41, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 3, 4, 5);
    wanderIteration(42,43,44, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 6, 7, 8);
    wanderIteration(45,46,47, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 9,10,11);

    smState[lIdx].s0 = state[0];
    barrier(CLK_LOCAL_MEM_FENCE);
    rowa = (uint)smState[gr4].s0 & 3;
    wanderIteration(0, 1, 2, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 12,13,14);
    wanderIteration(3, 4, 5, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 15,16,17);
    wanderIteration(6, 7, 8, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 18,19,20);
    wanderIteration(9,10,11, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 21,22,23);

    smState[lIdx].s0 = state[0];
    barrier(CLK_LOCAL_MEM_FENCE);
    rowa = (uint)smState[gr4].s0 & 3;
    wanderIteration(12,13,14, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 24,25,26);
    wanderIteration(15,16,17, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 27,28,29);
    wanderIteration(18,19,20, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 30,31,32);
    wanderIteration(21,22,23, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 33,34,35);
    

    //------------------------------------
    // Wandering phase part2 (last iteration)
    smState[lIdx].s0 = state[0];
    barrier(CLK_LOCAL_MEM_FENCE);
    rowa = (uint)smState[gr4].s0 & 3;

    int i, j;
    ulong last[3];

    b0 = (rowa < 2)? lMatrix[0]: lMatrix[24];
    b1 = (rowa < 2)? lMatrix[12]: lMatrix[36];
    last[0] = ((rowa & 0x1U) < 1)? b0: b1;

    // st1
    b0 = (rowa < 2)? lMatrix[1]: lMatrix[25];
    b1 = (rowa < 2)? lMatrix[13]: lMatrix[37];
    last[1] = ((rowa & 0x1U) < 1)? b0: b1;

    // st2
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

    roundLyra_sm(state);
   
    smState[lIdx].s0 = state[0];
    smState[lIdx].s1 = state[1];
    smState[lIdx].s2 = state[2];
    barrier(CLK_LOCAL_MEM_FENCE);
    ulong Data0 = smState[gr4 + ((lIdx-1) & 3)].s0;
    ulong Data1 = smState[gr4 + ((lIdx-1) & 3)].s1;
    ulong Data2 = smState[gr4 + ((lIdx-1) & 3)].s2;  
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

    // 0,1,2 : 3,4,5 : 6,7,8 : 9,10,11
    // 12,13,14 : 15,16,17 : 18,19,20 : 21,22,23
    // 24,25,26 : 27,28,29 : 30,31,32 : 33,34,35
    // 36,37,38 : 39,40,41 : 42,43,44 : 45,46,47
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
    
    barrier(CLK_LOCAL_MEM_FENCE);
}
// lyra2v2 p3
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search21(__global uint* hashes, __global uint* lyraStates)
{
    int gid = get_global_id(0);

    __global hashly_t *hash = (__global hashly_t *)(hashes + (8* ((19 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)))<<1)));
    __global lyraState_t *lyraState = (__global lyraState_t *)(lyraStates + (32* (get_global_id(0)-get_global_offset(0))));

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
    hash++;
    hash->hl4[0] = 0;
    hash->hl4[1] = 0;
    
    barrier(CLK_LOCAL_MEM_FENCE);
}

// streebog
//gost streebog 64
__attribute__((reqd_work_group_size(256, 1, 1)))
__kernel void search22(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[19 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[20 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

  volatile sph_u64 message[8];
  __local sph_u64 out[8 * GOST_WORKSIZE];
  sph_u64 len = 512;

  __local sph_u64 lT[8][256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  _Pragma("unroll") for(int j=init;j<256;j+=step) {
      _Pragma("unroll") for (int i=0; i<8; i++) lT[i][j] = T[i][j];
  }
  barrier(CLK_LOCAL_MEM_FENCE);

  message[0] = (hash->h8[0]);
  message[1] = (hash->h8[1]);
  message[2] = (hash->h8[2]);
  message[3] = (hash->h8[3]);
  message[4] = (hash->h8[4]);
  message[5] = (hash->h8[5]);
  message[6] = (hash->h8[6]);
  message[7] = (hash->h8[7]);

  GOST_HASH_512(message, out);
  barrier(CLK_LOCAL_MEM_FENCE);

  hash1->h8[0] = (GOST_OUT(0));
  hash1->h8[1] = (GOST_OUT(1));
  hash1->h8[2] = (GOST_OUT(2));
  hash1->h8[3] = (GOST_OUT(3));
  hash1->h8[4] = (GOST_OUT(4));
  hash1->h8[5] = (GOST_OUT(5));
  hash1->h8[6] = (GOST_OUT(6));
  hash1->h8[7] = (GOST_OUT(7));

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// sha256

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search23(__global hash_t* hashes)
//__kernel void search23(__global hash_t* hashes, volatile __global uint* output, const ulong target)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[20 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);	
  __global hash_t *hash1 = &(hashes[21 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))]);

  uint temp1;
  uint W0 = SWAP32(hash->h4[0x0]);
  uint W1 = SWAP32(hash->h4[0x1]);
  uint W2 = SWAP32(hash->h4[0x2]);
  uint W3 = SWAP32(hash->h4[0x3]);
  uint W4 = SWAP32(hash->h4[0x4]);
  uint W5 = SWAP32(hash->h4[0x5]);
  uint W6 = SWAP32(hash->h4[0x6]);
  uint W7 = SWAP32(hash->h4[0x7]);
  uint W8 = SWAP32(hash->h4[0x8]);
  uint W9 = SWAP32(hash->h4[0x9]);
  uint W10 = SWAP32(hash->h4[0xA]);
  uint W11 = SWAP32(hash->h4[0xB]);
  uint W12 = SWAP32(hash->h4[0xC]);
  uint W13 = SWAP32(hash->h4[0xD]);
  uint W14 = SWAP32(hash->h4[0xE]);
  uint W15 = SWAP32(hash->h4[0xF]);

  uint v0 = 0x6A09E667;
  uint v1 = 0xBB67AE85;
  uint v2 = 0x3C6EF372;
  uint v3 = 0xA54FF53A;
  uint v4 = 0x510E527F;
  uint v5 = 0x9B05688C;
  uint v6 = 0x1F83D9AB;
  uint v7 = 0x5BE0CD19;

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, W0, 0x428A2F98 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, W1, 0x71374491 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, W2, 0xB5C0FBCF );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, W3, 0xE9B5DBA5 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, W4, 0x3956C25B );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, W5, 0x59F111F1 );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, W6, 0x923F82A4 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, W7, 0xAB1C5ED5 );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, W8, 0xD807AA98 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, W9, 0x12835B01 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, W10, 0x243185BE );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, W11, 0x550C7DC3 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, W12, 0x72BE5D74 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, W13, 0x80DEB1FE );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, W14, 0x9BDC06A7 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, W15, 0xC19BF174 );

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R0, 0xE49B69C1 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R1, 0xEFBE4786 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R2, 0x0FC19DC6 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R3, 0x240CA1CC );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R4, 0x2DE92C6F );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R5, 0x4A7484AA );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R6, 0x5CB0A9DC );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R7, 0x76F988DA );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R8, 0x983E5152 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R9, 0xA831C66D );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R10, 0xB00327C8 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R11, 0xBF597FC7 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R12, 0xC6E00BF3 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R13, 0xD5A79147 );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R14, 0x06CA6351 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R15, 0x14292967 );

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R0,  0x27B70A85 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R1,  0x2E1B2138 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R2,  0x4D2C6DFC );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R3,  0x53380D13 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R4,  0x650A7354 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R5,  0x766A0ABB );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R6,  0x81C2C92E );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R7,  0x92722C85 );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R8,  0xA2BFE8A1 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R9,  0xA81A664B );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R10, 0xC24B8B70 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R11, 0xC76C51A3 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R12, 0xD192E819 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R13, 0xD6990624 );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R14, 0xF40E3585 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R15, 0x106AA070 );

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R0,  0x19A4C116 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R1,  0x1E376C08 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R2,  0x2748774C );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R3,  0x34B0BCB5 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R4,  0x391C0CB3 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R5,  0x4ED8AA4A );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R6,  0x5B9CCA4F );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R7,  0x682E6FF3 );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R8,  0x748F82EE );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R9,  0x78A5636F );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R10, 0x84C87814 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R11, 0x8CC70208 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R12, 0x90BEFFFA );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R13, 0xA4506CEB );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_RD14, 0xBEF9A3F7 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_RD15, 0xC67178F2 );

  v0 += 0x6A09E667;
  uint s0 = v0;
  v1 += 0xBB67AE85;
  uint s1 = v1;
  v2 += 0x3C6EF372;
  uint s2 = v2;
  v3 += 0xA54FF53A;
  uint s3 = v3;
  v4 += 0x510E527F;
  uint s4 = v4;
  v5 += 0x9B05688C;
  uint s5 = v5;
  v6 += 0x1F83D9AB;
  uint s6 = v6;
  v7 += 0x5BE0CD19;
  uint s7 = v7;

  W0 = 0x80000000;
  W1 = 0;
  W2 = 0;
  W3 = 0;
  W4 = 0;
  W5 = 0;
  W6 = 0;
  W7 = 0;
  W8 = 0;
  W9 = 0;
  W10 = 0;
  W11 = 0;
  W12 = 0;
  W13 = 0;
  W14 = 0;
  W15 = 512;

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, W0, 0x428A2F98 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, W1, 0x71374491 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, W2, 0xB5C0FBCF );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, W3, 0xE9B5DBA5 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, W4, 0x3956C25B );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, W5, 0x59F111F1 );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, W6, 0x923F82A4 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, W7, 0xAB1C5ED5 );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, W8, 0xD807AA98 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, W9, 0x12835B01 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, W10, 0x243185BE );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, W11, 0x550C7DC3 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, W12, 0x72BE5D74 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, W13, 0x80DEB1FE );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, W14, 0x9BDC06A7 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, W15, 0xC19BF174 );

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R0, 0xE49B69C1 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R1, 0xEFBE4786 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R2, 0x0FC19DC6 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R3, 0x240CA1CC );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R4, 0x2DE92C6F );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R5, 0x4A7484AA );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R6, 0x5CB0A9DC );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R7, 0x76F988DA );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R8, 0x983E5152 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R9, 0xA831C66D );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R10, 0xB00327C8 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R11, 0xBF597FC7 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R12, 0xC6E00BF3 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R13, 0xD5A79147 );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R14, 0x06CA6351 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R15, 0x14292967 );

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R0,  0x27B70A85 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R1,  0x2E1B2138 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R2,  0x4D2C6DFC );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R3,  0x53380D13 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R4,  0x650A7354 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R5,  0x766A0ABB );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R6,  0x81C2C92E );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R7,  0x92722C85 );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R8,  0xA2BFE8A1 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R9,  0xA81A664B );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R10, 0xC24B8B70 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R11, 0xC76C51A3 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R12, 0xD192E819 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R13, 0xD6990624 );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R14, 0xF40E3585 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R15, 0x106AA070 );

  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R0,  0x19A4C116 );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R1,  0x1E376C08 );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R2,  0x2748774C );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R3,  0x34B0BCB5 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R4,  0x391C0CB3 );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R5,  0x4ED8AA4A );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_R6,  0x5B9CCA4F );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_R7,  0x682E6FF3 );
  SHA256_P( v0, v1, v2, v3, v4, v5, v6, v7, SHA256_R8,  0x748F82EE );
  SHA256_P( v7, v0, v1, v2, v3, v4, v5, v6, SHA256_R9,  0x78A5636F );
  SHA256_P( v6, v7, v0, v1, v2, v3, v4, v5, SHA256_R10, 0x84C87814 );
  SHA256_P( v5, v6, v7, v0, v1, v2, v3, v4, SHA256_R11, 0x8CC70208 );
  SHA256_P( v4, v5, v6, v7, v0, v1, v2, v3, SHA256_R12, 0x90BEFFFA );
  SHA256_P( v3, v4, v5, v6, v7, v0, v1, v2, SHA256_R13, 0xA4506CEB );
  SHA256_P( v2, v3, v4, v5, v6, v7, v0, v1, SHA256_RD14, 0xBEF9A3F7 );
  SHA256_P( v1, v2, v3, v4, v5, v6, v7, v0, SHA256_RD15, 0xC67178F2 );

  hash1->h4[0] = SWAP4(v0 + s0);
  hash1->h4[1] = SWAP4(v1 + s1);
  hash1->h4[2] = SWAP4(v2 + s2);
  hash1->h4[3] = SWAP4(v3 + s3);
  hash1->h4[4] = SWAP4(v4 + s4);
  hash1->h4[5] = SWAP4(v5 + s5);
  hash1->h4[6] = SWAP4(v6 + s6);
  hash1->h4[7] = SWAP4(v7 + s7);

  hash1->h4[8] = 0;
  hash1->h4[9] = 0;
  hash1->h4[10] = 0;
  hash1->h4[11] = 0;
  hash1->h4[12] = 0;
  hash1->h4[13] = 0;
  hash1->h4[14] = 0;
  hash1->h4[15] = 0;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// panama
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search24( __global uint *hashes )
{
	uint gid = get_global_id( 0 );
    __global uint* hash = hashes + 16 * (21 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)));
    __global uint* hash1 = hashes + 16 * (22 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)));

    sph_u32 buffer[32][8];
    sph_u32 state[17];
    int i, j;
    #pragma unroll
    for(i = 0; i < 32; i++)
    #pragma unroll
        for(j = 0; j < 8; j++)
            buffer[i][j] = 0;
    #pragma unroll
    for(i = 0; i < 17; i++)
        state[i] = 0;

    PANAMA_LVARS
    unsigned ptr0 = 0;
#define INW1(i)   sph_dec32le_aligned( hash + (i))
#define INW2(i)   INW1(i)

    PANAMA_M17(PANAMA_RSTATE);
    PANAMA_STEP;

#undef INW1
#undef INW2
#define INW1(i)   sph_dec32le_aligned(hash + 8 + (i))
#define INW2(i)   INW1(i)
    PANAMA_STEP;
    PANAMA_M17(PANAMA_WSTATE);

#undef INW1
#undef INW2

#define INW1(i)   (sph_u32) (i == 0)
#define INW2(i)   INW1(i)

    PANAMA_M17(PANAMA_RSTATE);
    PANAMA_STEP;
    PANAMA_M17(PANAMA_WSTATE);

#undef INW1
#undef INW2

#define INW1(i)     INW_H1(PANAMA_INC ## i)
#define INW_H1(i)   INW_H2(i)
#define INW_H2(i)   a ## i
#define INW2(i)     buffer[ptr4][i]

    PANAMA_M17(PANAMA_RSTATE);
    #pragma unroll
    for(i = 0; i < 32; i++) {
        unsigned ptr4 = (ptr0 + 4) & 31;
        PANAMA_STEP;
    }
    PANAMA_M17(PANAMA_WSTATE);

#undef INW1
#undef INW_H1
#undef INW_H2
#undef INW2

	#pragma unroll
	for ( int i = 0; i < 8; i++ ) {
    hash1[ i ] = state[ i + 9 ];
    hash1[ i + 8] = 0;
  }

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// lane
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search25( __global uint *hashes )
{
	uint gid = get_global_id( 0 );
    __global uint* in = hashes + 16 * (22 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)));
    __global uint* out = hashes + 16 * (23 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)));
	uint tid = get_local_id(0);
  __local uint S_lane_T0[256];
  __local uint S_lane_T1[256];
  __local uint S_lane_T2[256];
  __local uint S_lane_T3[256];
  const int blockSize = min(256, WORKSIZE);
  if (tid < 256) {
    #pragma unroll
      for (int i=0; i<(256/blockSize); i++) {
         S_lane_T0[tid + i*blockSize] = lane_T0[tid + i*blockSize];
         S_lane_T1[tid + i*blockSize] = lane_T1[tid + i*blockSize];
         S_lane_T2[tid + i*blockSize] = lane_T2[tid + i*blockSize];
         S_lane_T3[tid + i*blockSize] = lane_T3[tid + i*blockSize];
      }
  }

	uint m[16];
	uint h[16] = { 0x9b603481, 0x1d5a931b, 0x69c4e6e0, 0x975e2681,
					0xb863ba53, 0x8d1be11b, 0x77340080, 0xd42c48a5,
					0x3a3a1d61, 0x1cf3a1c4, 0xf0a30347, 0x7e56a44a,
					0x9530ee60, 0xdadb05b6, 0x3ae3ac7c, 0xd732ac6a };
					
	volatile uint t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, ta, tb, tc, td, te, tf;
	volatile uint s00, s01, s02, s03, s04, s05, s06, s07, s08, s09, s0a, s0b, s0c, s0d, s0e, s0f;
	volatile uint s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s1a, s1b, s1c, s1d, s1e, s1f;
	volatile uint s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s2a, s2b, s2c, s2d, s2e, s2f;
	volatile uint s30, s31, s32, s33, s34, s35, s36, s37, s38, s39, s3a, s3b, s3c, s3d, s3e, s3f;
	volatile uint s40, s41, s42, s43, s44, s45, s46, s47, s48, s49, s4a, s4b, s4c, s4d, s4e, s4f;
	volatile uint s50, s51, s52, s53, s54, s55, s56, s57, s58, s59, s5a, s5b, s5c, s5d, s5e, s5f;
	volatile uint s60, s61, s62, s63, s64, s65, s66, s67, s68, s69, s6a, s6b, s6c, s6d, s6e, s6f;
	volatile uint s70, s71, s72, s73, s74, s75, s76, s77, s78, s79, s7a, s7b, s7c, s7d, s7e, s7f;
	
	#pragma unroll
	for ( int i = 0; i < 16; i++ ) m[ i ] = in[ i ];

	for ( int i = 0; i < 2; i++ )
	{
		uint ctrl = i == 0 ? 512 : 0;
		lane512_compress( m, h, ctrl );
		
		if ( i == 0 )
		{
			m[ 0 ] = 0;
			m[ 1 ] = 0x02000000;
			m[ 2 ] = 0;
			m[ 3 ] = 0;
			m[ 4 ] = 0;
			m[ 5 ] = 0;
			m[ 6 ] = 0;
			m[ 7 ] = 0;
			m[ 8 ] = 0;
			m[ 9 ] = 0;
			m[ 10 ] = 0;
			m[ 11 ] = 0;
			m[ 12 ] = 0;
			m[ 13 ] = 0;
			m[ 14 ] = 0;
			m[ 15 ] = 0;
		}
	}
	
	#pragma unroll
	for ( int i = 0; i < 16; i++ ) out[ i ] = SWAP4( h[ i ] );

  barrier(CLK_GLOBAL_MEM_FENCE);
}

// x25x shuffle

// NEW simple shuffle algorithm, instead of just reversing
#define X25X_SHUFFLE_BLOCKS (24 * 64 / 2)
#define X25X_SHUFFLE_ROUNDS 12

__constant static const ushort x25x_round_const[X25X_SHUFFLE_ROUNDS] = {
    0x142c, 0x5830, 0x678c, 0xe08c,
    0x3c67, 0xd50d, 0xb1d8, 0xecb2,
    0xd7ee, 0x6783, 0xfa6c, 0x4b9c
};

#define X25X_SHFL_GROUP_SIZE 21

__attribute__((reqd_work_group_size(X25X_SHFL_GROUP_SIZE, 1, 1)))
__kernel void search26( __global uint *hashes )
{
    uint gid = get_global_id( 0 );
    __global ushort* pblock_pointer = (__global ushort*) (hashes + 16 * (0 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0))));
    __local ushort block_pointer[X25X_SHUFFLE_BLOCKS * X25X_SHFL_GROUP_SIZE];
    ushort lid = (ushort) get_local_id( 0 );
    //#pragma unroll
    for (int i = 0; i < X25X_SHUFFLE_BLOCKS; i++) {
      (block_pointer)[i * X25X_SHFL_GROUP_SIZE + lid] = (pblock_pointer)[i];
    }
	for (int r = 0; r < X25X_SHUFFLE_ROUNDS; r++) {
		for (ushort i = 0; i < X25X_SHUFFLE_BLOCKS; i++) {
			ushort block_value = block_pointer[(X25X_SHUFFLE_BLOCKS - i - 1) * X25X_SHFL_GROUP_SIZE + lid];
      ushort round_value = (block_value / X25X_SHUFFLE_BLOCKS);
      round_value *= X25X_SHUFFLE_BLOCKS;
      block_value -= round_value;
      ushort shift = i & 15;
			block_pointer[i * X25X_SHFL_GROUP_SIZE + lid] ^= block_pointer[(block_value) * X25X_SHFL_GROUP_SIZE + lid] + (x25x_round_const[r] << (shift));
		}
	}
//#pragma unroll
    for (int i = 0; i < X25X_SHUFFLE_BLOCKS; i++) {
      (pblock_pointer)[i] = (block_pointer)[i * X25X_SHFL_GROUP_SIZE + lid];
    }

    barrier(CLK_GLOBAL_MEM_FENCE);
}

// blake2s
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search27(__global uint* hashes, volatile __global uint* output, const ulong target)
{
    uint gid = get_global_id( 0 );
    __global uint* input = hashes + 16 * (0 + X25X_HASH_ARRAY_SIZE * (gid-get_global_offset(0)));

	blake2s_state blake2_ctx;

	gpu_blake2s_init(&blake2_ctx, BLAKE2S_OUTBYTES);
	gpu_blake2s_update(&blake2_ctx, (__global uchar*) input);

	uint hash[8];
	gpu_blake2s_final(&blake2_ctx, hash);

	if (hash[7] <= as_uint2(target).y && hash[6] <= as_uint2(target).x) {
      output[output[0xFF]++] = SWAP32(gid);
	}
}

#endif // X25X_CL