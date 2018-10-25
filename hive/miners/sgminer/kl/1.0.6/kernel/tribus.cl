/*
 * TRIBUS kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2017 tpruvot
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
 */

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

#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

ulong FAST_ROTL64_LO(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x, x.s10, 32 - y))); }
ulong FAST_ROTL64_HI(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x.s10, x, 32 - (y - 32)))); }
ulong ROTL64_1(const uint2 vv, const int r) { return as_ulong(amd_bitalign((vv).xy, (vv).yx, 32 - r)); }
ulong ROTL64_2(const uint2 vv, const int r) { return as_ulong((amd_bitalign((vv).yx, (vv).xy, 64 - r))); }

#define SPH_ECHO_64 1
#define SPH_KECCAK_64 1
#define SPH_JH_64 1
#define SPH_KECCAK_NOCOPY 0

#ifndef SPH_KECCAK_UNROLL
  #define SPH_KECCAK_UNROLL 0
#endif

#include "jh.cl"
#include "keccak.cl"
#include "wolf-aes.cl"
#include "wolf-echo.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC64LE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC64LE(x) (*(const __global sph_u64 *) (x));
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
#endif

#define SHL(x, n) ((x) << (n))
#define SHR(x, n) ((x) >> (n))

#define CONST_EXP2  q[i+0] + SPH_ROTL64(q[i+1], 5)  + q[i+2] + SPH_ROTL64(q[i+3], 11) + \
                    q[i+4] + SPH_ROTL64(q[i+5], 27) + q[i+6] + SPH_ROTL64(q[i+7], 32) + \
                    q[i+8] + SPH_ROTL64(q[i+9], 37) + q[i+10] + SPH_ROTL64(q[i+11], 43) + \
                    q[i+12] + SPH_ROTL64(q[i+13], 53) + (SHR(q[i+14],1) ^ q[i+14]) + (SHR(q[i+15],2) ^ q[i+15])

typedef union {
   unsigned char h1[64];
   uint h4[16];
   ulong h8[8];
 } hash_t;
 	 
typedef union {
  unsigned char h1[16];
  uint  h4[4];
  ulong h8[2];
} hash16_t;


__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global sph_u64 *midstate, __global hash_t* hashes)
{
   uint gid = get_global_id(0);
  __global hash_t *out = &(hashes[gid-get_global_offset(0)]);

  // jh512 midstate
  sph_u64 h0h = DEC64LE(&midstate[0]);
  sph_u64 h0l = DEC64LE(&midstate[1]);
  sph_u64 h1h = DEC64LE(&midstate[2]);
  sph_u64 h1l = DEC64LE(&midstate[3]);
  sph_u64 h2h = DEC64LE(&midstate[4]);
  sph_u64 h2l = DEC64LE(&midstate[5]);
  sph_u64 h3h = DEC64LE(&midstate[6]);
  sph_u64 h3l = DEC64LE(&midstate[7]);

  sph_u64 h4h = DEC64LE(&midstate[0 + 8]);
  sph_u64 h4l = DEC64LE(&midstate[1 + 8]);
  sph_u64 h5h = DEC64LE(&midstate[2 + 8]);
  sph_u64 h5l = DEC64LE(&midstate[3 + 8]);
  sph_u64 h6h = DEC64LE(&midstate[4 + 8]);
  sph_u64 h6l = DEC64LE(&midstate[5 + 8]);
  sph_u64 h7h = DEC64LE(&midstate[6 + 8]);
  sph_u64 h7l = DEC64LE(&midstate[7 + 8]);

  // end of input data with nonce
  hash16_t hash;
  hash.h8[0] = DEC64LE(&midstate[16]);
  hash.h8[1] = DEC64LE(&midstate[17]);
  hash.h4[3] = gid;

  sph_u64 tmp;

  // Round 2 (16 bytes with nonce)
  h0h ^= hash.h8[0];
  h0l ^= hash.h8[1];
  h1h ^= 0x80U;
  E8;
  h4h ^= hash.h8[0];
  h4l ^= hash.h8[1];
  h5h ^= 0x80U;

  // Round 3 (close, 640 bits input)
  h3l ^= 0x8002000000000000UL;
  E8;
  h7l ^= 0x8002000000000000UL;

  out->h8[0] = h4h;
  out->h8[1] = h4l;
  out->h8[2] = h5h;
  out->h8[3] = h5l;
  out->h8[4] = h6h;
  out->h8[5] = h6l;
  out->h8[6] = h7h;
  out->h8[7] = h7l;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
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

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global hash_t* hashes, __global uint* output, const ulong target)
{
   uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  __local uint AES0[256];
  for(int i = get_local_id(0), step = get_local_size(0); i < 256; i += step)
    AES0[i] = AES0_C[i];

  uint4 W[16];

  // Precomp
  W[0] = (uint4)(0xe7e9f5f5, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[1] = (uint4)(0x14b8a457, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[2] = (uint4)(0xdbfde1dd, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[3] = (uint4)(0x9ac2dea3, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[4] = (uint4)(0x65978b09, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[5] = (uint4)(0xa4213d7e, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[6] = (uint4)(0x265f4382, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[7] = (uint4)(0x34514d9e, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);
  W[12] = (uint4)(0xb134347e, 0xea6f7e7e, 0xbd7731bd, 0x8a8a1968);
  W[13] = (uint4)(0x579f9f33, 0xfbfbfbfb, 0xfbfbfbfb, 0xefefd3c7);
  W[14] = (uint4)(0x2cb6b661, 0x6b23b3b3, 0xcf93a7cf, 0x9d9d3751);
  W[15] = (uint4)(0x01425eb8, 0xf5e7e9f5, 0xb3b36b23, 0xb3dbe7af);

  ((uint16 *)W)[2] = vload16(0, hash->h4);

  barrier(CLK_LOCAL_MEM_FENCE);

  #pragma unroll
	for(int x = 8; x < 12; ++x) {
		uint4 tmp;
		tmp = Echo_AES_Round_Small(AES0, W[x]);
		tmp.s0 ^= x | 0x200;
		W[x] = Echo_AES_Round_Small(AES0, tmp);
	}
  BigShiftRows(W);
  BigMixColumns(W);

  #pragma unroll 1
  for(uint k0 = 16; k0 < 160; k0 += 16) {
      BigSubBytesSmall(AES0, W, k0);
      BigShiftRows(W);
      BigMixColumns(W);
  }

  vstore4(vload4(1, hash->h4) ^ W[1] ^ W[9] ^ (uint4)(512, 0, 0, 0), 1, hash->h4);

  bool result = (hash->h8[3] <= target);

  if (result)
      output[output[0xFF]++] = SWAP4(gid);
}