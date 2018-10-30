/* Phi kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2016 tpruvot
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
 * @author tpruvot 2016
 */

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
#else
  typedef unsigned long sph_u64;
#endif

#define SPH_64 1
#define SPH_64_TRUE 1

#define SPH_C32(x) ((sph_u32)(x ## U))
#define SPH_T32(x) (as_uint(x))
#define SPH_ROTL32(x, n) rotate(as_uint(x), as_uint(n))
#define SPH_ROTR32(x, n) SPH_ROTL32(x, (32 - (n)))

#define SPH_C64(x) ((sph_u64)(x ## UL))
#define SPH_T64(x) (as_ulong(x))
#define SPH_ROTL64(x, n) rotate(as_ulong(x), (n) & 0xFFFFFFFFFFFFFFFFUL)
#define SPH_ROTR64(x, n) SPH_ROTL64(x, (64 - (n)))

#define SPH_ECHO_64 1
#define SPH_JH_64 1
#define SPH_CUBEHASH_UNROLL 0

#pragma OPENCL EXTENSION cl_amd_media_ops : enable

#define VSWAP8(x)       (((x) >> 56) | (((x) >> 40) & 0x000000000000FF00UL) | (((x) >> 24) & 0x0000000000FF0000UL) \
          | (((x) >>  8) & 0x00000000FF000000UL) | (((x) <<  8) & 0x000000FF00000000UL) \
          | (((x) << 24) & 0x0000FF0000000000UL) | (((x) << 40) & 0x00FF000000000000UL) | (((x) << 56) & 0xFF00000000000000UL))

#define VSWAP4(x)       (((x) >> 24) | (((x) << 8) & 0x00FF0000) | (((x) >> 8) & 0x0000FF00) | (((x) << 24)))

ulong FAST_ROTL64_LO(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x, x.s10, 32 - y))); }
ulong FAST_ROTL64_HI(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x.s10, x, 32 - (y - 32)))); }

#define WOLF_JH_64BIT 1

#include "wolf-skein.cl"
#include "wolf-aes.cl"
#include "wolf-jh.cl"
#include "wolf-cubehash.cl"
#include "wolf-fugue.cl"
#include "gost-mod.cl"
#include "wolf-echo.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC64LE(x) SWAP8(*(const __global sph_u64 *) (x));
#else
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC64LE(x) (*(const __global sph_u64 *) (x));
#endif

#define SHL(x, n) ((x) << (n))
#define SHR(x, n) ((x) >> (n))

typedef union {
  unsigned char h1[64];
  unsigned short h2[32];
  uint h4[16];
  ulong h8[8];
} hash_t;

#define SWAP8_INPUT(x)   x
#define SWAP8_USELESS(x) x

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global ulong* block, __global ulong* midstate, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // input skein 80 midstate

  ulong8 h2 = vload8(0, midstate);

  ulong t1[3] = { 0x50UL, 0xB000000000000000UL, 0xB000000000000050UL },
        t2[3] = { 0x08UL, 0xFF00000000000000UL, 0xFF00000000000008UL };

  ulong8 m = (ulong8)(block[8], (block[9] & 0x00000000FFFFFFFF) | ((ulong)SWAP4(gid) << 32), 0UL, 0UL, 0UL, 0UL, 0UL, 0UL);
  ulong h8 = h2.s0 ^ h2.s1 ^ h2.s2 ^ h2.s3 ^ h2.s4 ^ h2.s5 ^ h2.s6 ^ h2.s7 ^ SKEIN_KS_PARITY;

  ulong8 p = Skein512Block(m, h2, h8, t1);

  h2 = m ^ p;

  p = (ulong8)(0);
  h8 = h2.s0 ^ h2.s1 ^ h2.s2 ^ h2.s3 ^ h2.s4 ^ h2.s5 ^ h2.s6 ^ h2.s7 ^ SKEIN_KS_PARITY;

  p = Skein512Block(p, h2, h8, t2);

  vstore8(p, 0, hash->h8);

  mem_fence(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // jh

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
      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 0));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 0));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 0));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 0));

      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

      JH_RND(&oddhi, &oddlo, 0);

      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 1));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 1));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 1));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 1));
      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

      JH_RND(&oddhi, &oddlo, 1);

      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 2));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 2));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 2));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 2));
      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

      JH_RND(&oddhi, &oddlo, 2);

      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 3));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 3));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 3));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 3));
      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

      JH_RND(&oddhi, &oddlo, 3);

      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 4));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 4));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 4));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 4));
      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

      JH_RND(&oddhi, &oddlo, 4);

      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 5));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 5));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 5));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 5));
      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

      JH_RND(&oddhi, &oddlo, 5);

      evnhi = Sb(evnhi, Ceven_hi((r * 7) + 6));
      evnlo = Sb(evnlo, Ceven_lo((r * 7) + 6));
      oddhi = Sb(oddhi, Codd_hi((r * 7) + 6));
      oddlo = Sb(oddlo, Codd_lo((r * 7) + 6));
      Lb(&evnhi, &oddhi);
      Lb(&evnlo, &oddlo);

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

  mem_fence(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global hash_t* hashes)
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

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search3(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  // mixtab
  __local sph_u32 mixtab0[256], mixtab1[256], mixtab2[256], mixtab3[256];
  int init = get_local_id(0);
  int step = get_local_size(0);
  for (int i = init; i < 256; i += step)
  {
    mixtab0[i] = mixtab0_c[i];
    mixtab1[i] = rotate(mixtab0_c[i], 24U);
    mixtab2[i] = rotate(mixtab0_c[i], 16U);
    mixtab3[i] = rotate(mixtab0_c[i], 8U);
  }
  // ha ez nincs akkor hibasan szamol
  barrier(CLK_LOCAL_MEM_FENCE);

  // fugue

  uint4 S[9] = { 0 };

  S[5] = vload4(0, IV512);
  S[6] = vload4(1, IV512);
  S[7] = vload4(2, IV512);
  S[8] = vload4(3, IV512);

  uint input[18];
  ((uint16 *)input)[0] = VSWAP4(vload16(0, hash->h4));
  input[16] = 0;
  input[17] = 0x200;

  mem_fence(CLK_LOCAL_MEM_FENCE);

  #pragma unroll
  for(int i = 0; i < 19; ++i)
  {
    if(i < 18) TIX4(input[i], S[0].s0, S[0].s1, S[1].s0, S[1].s3, S[2].s0, S[5].s2, S[6].s0, S[6].s3, S[7].s2);

    for(int x = 0; x < 8; ++x)
    {
      ROR3;
      CMIX36(S[0].s0, S[0].s1, S[0].s2, S[1].s0, S[1].s1, S[1].s2, S[4].s2, S[4].s3, S[5].s0);
      SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

      ROR3;
      CMIX36(S[0].s0, S[0].s1, S[0].s2, S[1].s0, S[1].s1, S[1].s2, S[4].s2, S[4].s3, S[5].s0);
      SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

      ROR3;
      CMIX36(S[0].s0, S[0].s1, S[0].s2, S[1].s0, S[1].s1, S[1].s2, S[4].s2, S[4].s3, S[5].s0);
      SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

      ROR3;
      CMIX36(S[0].s0, S[0].s1, S[0].s2, S[1].s0, S[1].s1, S[1].s2, S[4].s2, S[4].s3, S[5].s0);
      SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

      if(i != 18) break;
    }
  }

  #pragma unroll 4
  for(int i = 0; i < 12; ++i)
  {
    S[1].s0 ^= S[0].s0;
    S[2].s1 ^= S[0].s0;
    S[4].s2 ^= S[0].s0;
    S[6].s3 ^= S[0].s0;

    ROR9;
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

    S[1].s0 ^= S[0].s0;
    S[2].s2 ^= S[0].s0;
    S[4].s2 ^= S[0].s0;
    S[6].s3 ^= S[0].s0;

    ROR9;
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

    S[1].s0 ^= S[0].s0;
    S[2].s2 ^= S[0].s0;
    S[4].s3 ^= S[0].s0;
    S[6].s3 ^= S[0].s0;

    ROR9;
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

    S[1].s0 ^= S[0].s0;
    S[2].s2 ^= S[0].s0;
    S[4].s3 ^= S[0].s0;
    S[7].s0 ^= S[0].s0;

    ROR8;
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);
  }

  S[1].s0 ^= S[0].s0;
  S[2].s1 ^= S[0].s0;
  S[4].s2 ^= S[0].s0;
  S[6].s3 ^= S[0].s0;

  ROR9;
  SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

  S[1].s0 ^= S[0].s0;
  S[2].s2 ^= S[0].s0;
  S[4].s2 ^= S[0].s0;
  S[6].s3 ^= S[0].s0;

  ROR9;
  SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

  S[1].s0 ^= S[0].s0;
  S[2].s2 ^= S[0].s0;
  S[4].s3 ^= S[0].s0;
  S[6].s3 ^= S[0].s0;

  ROR9;
  SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

  S[1].s0 ^= S[0].s0;
  S[2].s2 ^= S[0].s0;
  S[4].s3 ^= S[0].s0;
  S[7].s0 ^= S[0].s0;

  ROR8;
  SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0]);

  S[1].s0 ^= S[0].s0;
  S[2].s1 ^= S[0].s0;
  S[4].s2 ^= S[0].s0;
  S[6].s3 ^= S[0].s0;

  hash->h4[0] = SWAP4(S[0].s1);
  hash->h4[1] = SWAP4(S[0].s2);
  hash->h4[2] = SWAP4(S[0].s3);
  hash->h4[3] = SWAP4(S[1].s0);
  hash->h4[4] = SWAP4(S[2].s1);
  hash->h4[5] = SWAP4(S[2].s2);
  hash->h4[6] = SWAP4(S[2].s3);
  hash->h4[7] = SWAP4(S[3].s0);
  hash->h4[8] = SWAP4(S[4].s2);
  hash->h4[9] = SWAP4(S[4].s3);
  hash->h4[10] = SWAP4(S[5].s0);
  hash->h4[11] = SWAP4(S[5].s1);
  hash->h4[12] = SWAP4(S[6].s3);
  hash->h4[13] = SWAP4(S[7].s0);
  hash->h4[14] = SWAP4(S[7].s1);
  hash->h4[15] = SWAP4(S[7].s2);

  mem_fence(CLK_GLOBAL_MEM_FENCE);

//  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // gost

    sph_u64 message[8], out[8];
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

    hash->h8[0] = (out[0]);
    hash->h8[1] = (out[1]);
    hash->h8[2] = (out[2]);
    hash->h8[3] = (out[3]);
    hash->h8[4] = (out[4]);
    hash->h8[5] = (out[5]);
    hash->h8[6] = (out[6]);
    hash->h8[7] = (out[7]);


  barrier(CLK_GLOBAL_MEM_FENCE);
}


__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global hash_t* hashes, __global uint* output, const ulong target)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  __local uint AES0[256];

  const uint step = get_local_size(0);

  AES0[get_local_id(0)] = AES0_C[get_local_id(0)];
  AES0[get_local_id(0) + 64] = AES0_C[get_local_id(0) + 64];
  AES0[get_local_id(0) + 128] = AES0_C[get_local_id(0) + 128];
  AES0[get_local_id(0) + 192] = AES0_C[get_local_id(0) + 192];
  // ez is kellett ide, kulonben szart csinal
  barrier(CLK_LOCAL_MEM_FENCE);

  // echo
  uint4 W[16];

  #pragma unroll
  for(int i = 0; i < 8; ++i) W[i] = (uint4)(512, 0, 0, 0);

  ((uint16 *)W)[2] = vload16(0, hash->h4);

  W[12] = (uint4)(0x80, 0, 0, 0);
  W[13] = (uint4)(0, 0, 0, 0);
  W[14] = (uint4)(0, 0, 0, 0x02000000);
  W[15] = (uint4)(512, 0, 0, 0);

  mem_fence(CLK_LOCAL_MEM_FENCE);

  #pragma unroll 1
  for(uchar i = 0; i < 10; ++i)
  {
    BigSubBytesSmall(AES0, W, i);
    BigShiftRows(W);
    BigMixColumns(W);
  }

  ulong h8 = hash->h8[3] ^ as_ulong(W[1].hi) ^ as_ulong(W[9].hi);

  bool result = (h8 <= target);

  if (result)
      output[atomic_inc(output+0xFF)] = gid;
}
