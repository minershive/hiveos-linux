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

#include "skein.cl"
#include "jh.cl"
#include "cubehash.cl"
#include "fugue.cl"
#include "gost-mod.cl"
#include "echo.cl"

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
__kernel void search(__global unsigned char* block, __global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // input skein 80

  sph_u64 M0, M1, M2, M3, M4, M5, M6, M7;
  sph_u64 M8, M9;

  M0 = DEC64LE(block + 0);
  M1 = DEC64LE(block + 8);
  M2 = DEC64LE(block + 16);
  M3 = DEC64LE(block + 24);
  M4 = DEC64LE(block + 32);
  M5 = DEC64LE(block + 40);
  M6 = DEC64LE(block + 48);
  M7 = DEC64LE(block + 56);
  M8 = DEC64LE(block + 64);
  M9 = DEC64LE(block + 72);
  ((uint*)&M9)[1] = SWAP4(gid);

  sph_u64 h0 = SPH_C64(0x4903ADFF749C51CE);
  sph_u64 h1 = SPH_C64(0x0D95DE399746DF03);
  sph_u64 h2 = SPH_C64(0x8FD1934127C79BCE);
  sph_u64 h3 = SPH_C64(0x9A255629FF352CB1);
  sph_u64 h4 = SPH_C64(0x5DB62599DF6CA7B0);
  sph_u64 h5 = SPH_C64(0xEABE394CA9D5C3F4);
  sph_u64 h6 = SPH_C64(0x991112C71A75B523);
  sph_u64 h7 = SPH_C64(0xAE18A40B660FCC33);

  // h8 = h0 ^ h1 ^ h2 ^ h3 ^ h4 ^ h5 ^ h6 ^ h7 ^ SPH_C64(0x1BD11BDAA9FC1A22);
  sph_u64 h8 = SPH_C64(0xcab2076d98173ec4);

  sph_u64 t0 = 64;
  sph_u64 t1 = SPH_C64(0x7000000000000000);
  sph_u64 t2 = SPH_C64(0x7000000000000040); // t0 ^ t1;

  sph_u64 p0 = M0;
  sph_u64 p1 = M1;
  sph_u64 p2 = M2;
  sph_u64 p3 = M3;
  sph_u64 p4 = M4;
  sph_u64 p5 = M5;
  sph_u64 p6 = M6;
  sph_u64 p7 = M7;

  TFBIG_4e(0);
  TFBIG_4o(1);
  TFBIG_4e(2);
  TFBIG_4o(3);
  TFBIG_4e(4);
  TFBIG_4o(5);
  TFBIG_4e(6);
  TFBIG_4o(7);
  TFBIG_4e(8);
  TFBIG_4o(9);
  TFBIG_4e(10);
  TFBIG_4o(11);
  TFBIG_4e(12);
  TFBIG_4o(13);
  TFBIG_4e(14);
  TFBIG_4o(15);
  TFBIG_4e(16);
  TFBIG_4o(17);
  TFBIG_ADDKEY(p0, p1, p2, p3, p4, p5, p6, p7, h, t, 18);

  h0 = M0 ^ p0;
  h1 = M1 ^ p1;
  h2 = M2 ^ p2;
  h3 = M3 ^ p3;
  h4 = M4 ^ p4;
  h5 = M5 ^ p5;
  h6 = M6 ^ p6;
  h7 = M7 ^ p7;

  // second part with nonce
  p0 = M8;
  p1 = M9;
  p2 = p3 = p4 = p5 = p6 = p7 = 0;
  t0 = 80;
  t1 = SPH_C64(0xB000000000000000);
  t2 = SPH_C64(0xB000000000000050); // t0 ^ t1;
  h8 = h0 ^ h1 ^ h2 ^ h3 ^ h4 ^ h5 ^ h6 ^ h7 ^ SPH_C64(0x1BD11BDAA9FC1A22);

  TFBIG_4e(0);
  TFBIG_4o(1);
  TFBIG_4e(2);
  TFBIG_4o(3);
  TFBIG_4e(4);
  TFBIG_4o(5);
  TFBIG_4e(6);
  TFBIG_4o(7);
  TFBIG_4e(8);
  TFBIG_4o(9);
  TFBIG_4e(10);
  TFBIG_4o(11);
  TFBIG_4e(12);
  TFBIG_4o(13);
  TFBIG_4e(14);
  TFBIG_4o(15);
  TFBIG_4e(16);
  TFBIG_4o(17);
  TFBIG_ADDKEY(p0, p1, p2, p3, p4, p5, p6, p7, h, t, 18);
  h0 = p0 ^ M8;
  h1 = p1 ^ M9;
  h2 = p2;
  h3 = p3;
  h4 = p4;
  h5 = p5;
  h6 = p6;
  h7 = p7;

  // close
  t0 = 8;
  t1 = SPH_C64(0xFF00000000000000);
  t2 = SPH_C64(0xFF00000000000008); // t0 ^ t1;
  h8 = h0 ^ h1 ^ h2 ^ h3 ^ h4 ^ h5 ^ h6 ^ h7 ^ SPH_C64(0x1BD11BDAA9FC1A22);

  p0 = p1 = p2 = p3 = p4 = p5 = p6 = p7 = 0;

  TFBIG_4e(0);
  TFBIG_4o(1);
  TFBIG_4e(2);
  TFBIG_4o(3);
  TFBIG_4e(4);
  TFBIG_4o(5);
  TFBIG_4e(6);
  TFBIG_4o(7);
  TFBIG_4e(8);
  TFBIG_4o(9);
  TFBIG_4e(10);
  TFBIG_4o(11);
  TFBIG_4e(12);
  TFBIG_4o(13);
  TFBIG_4e(14);
  TFBIG_4o(15);
  TFBIG_4e(16);
  TFBIG_4o(17);
  TFBIG_ADDKEY(p0, p1, p2, p3, p4, p5, p6, p7, h, t, 18);

  hash->h8[0] = p0;
  hash->h8[1] = p1;
  hash->h8[2] = p2;
  hash->h8[3] = p3;
  hash->h8[4] = p4;
  hash->h8[5] = p5;
  hash->h8[6] = p6;
  hash->h8[7] = p7;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // jh

  sph_u64 h0h = C64e(0x6fd14b963e00aa17), h0l = C64e(0x636a2e057a15d543), h1h = C64e(0x8a225e8d0c97ef0b), h1l = C64e(0xe9341259f2b3c361), h2h = C64e(0x891da0c1536f801e), h2l = C64e(0x2aa9056bea2b6d80), h3h = C64e(0x588eccdb2075baa6), h3l = C64e(0xa90f3a76baf83bf7);
  sph_u64 h4h = C64e(0x0169e60541e34a69), h4l = C64e(0x46b58a8e2e6fe65a), h5h = C64e(0x1047a7d0c1843c24), h5l = C64e(0x3b6e71b12d5ac199), h6h = C64e(0xcf57f6ec9db1f856), h6l = C64e(0xa706887c5716b156), h7h = C64e(0xe3c2fcdfe68517fb), h7l = C64e(0x545a4678cc8cdd4b);
  sph_u64 tmp;

  for(int i = 0; i < 2; i++)
  {
  if (i == 0)
  {
    h0h ^= (hash->h8[0]);
    h0l ^= (hash->h8[1]);
    h1h ^= (hash->h8[2]);
    h1l ^= (hash->h8[3]);
    h2h ^= (hash->h8[4]);
    h2l ^= (hash->h8[5]);
    h3h ^= (hash->h8[6]);
    h3l ^= (hash->h8[7]);
  }
  else if(i == 1)
  {
    h4h ^= (hash->h8[0]);
    h4l ^= (hash->h8[1]);
    h5h ^= (hash->h8[2]);
    h5l ^= (hash->h8[3]);
    h6h ^= (hash->h8[4]);
    h6l ^= (hash->h8[5]);
    h7h ^= (hash->h8[6]);
    h7l ^= (hash->h8[7]);

    h0h ^= 0x80;
    h3l ^= 0x2000000000000;
  }
  E8;
  }
  h4h ^= 0x80;
  h7l ^= 0x2000000000000;

  hash->h8[0] = (h4h);
  hash->h8[1] = (h4l);
  hash->h8[2] = (h5h);
  hash->h8[3] = (h5l);
  hash->h8[4] = (h6h);
  hash->h8[5] = (h6l);
  hash->h8[6] = (h7h);
  hash->h8[7] = (h7l);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  // cubehash.h1

  sph_u32 x0 = SPH_C32(0x2AEA2A61), x1 = SPH_C32(0x50F494D4), x2 = SPH_C32(0x2D538B8B), x3 = SPH_C32(0x4167D83E);
  sph_u32 x4 = SPH_C32(0x3FEE2313), x5 = SPH_C32(0xC701CF8C), x6 = SPH_C32(0xCC39968E), x7 = SPH_C32(0x50AC5695);
  sph_u32 x8 = SPH_C32(0x4D42C787), x9 = SPH_C32(0xA647A8B3), xa = SPH_C32(0x97CF0BEF), xb = SPH_C32(0x825B4537);
  sph_u32 xc = SPH_C32(0xEEF864D2), xd = SPH_C32(0xF22090C4), xe = SPH_C32(0xD0E5CD33), xf = SPH_C32(0xA23911AE);
  sph_u32 xg = SPH_C32(0xFCD398D9), xh = SPH_C32(0x148FE485), xi = SPH_C32(0x1B017BEF), xj = SPH_C32(0xB6444532);
  sph_u32 xk = SPH_C32(0x6A536159), xl = SPH_C32(0x2FF5781C), xm = SPH_C32(0x91FA7934), xn = SPH_C32(0x0DBADEA9);
  sph_u32 xo = SPH_C32(0xD65C8A2B), xp = SPH_C32(0xA5A70E75), xq = SPH_C32(0xB1C62456), xr = SPH_C32(0xBC796576);
  sph_u32 xs = SPH_C32(0x1921C8F7), xt = SPH_C32(0xE7989AF1), xu = SPH_C32(0x7795D246), xv = SPH_C32(0xD43E3B44);

  x0 ^= (hash->h4[0]);
  x1 ^= (hash->h4[1]);
  x2 ^= (hash->h4[2]);
  x3 ^= (hash->h4[3]);
  x4 ^= (hash->h4[4]);
  x5 ^= (hash->h4[5]);
  x6 ^= (hash->h4[6]);
  x7 ^= (hash->h4[7]);

  for (int i = 0; i < 13; i ++)
  {
  SIXTEEN_ROUNDS;

  if (i == 0)
  {
    x0 ^= (hash->h4[8]);
    x1 ^= (hash->h4[9]);
    x2 ^= (hash->h4[10]);
    x3 ^= (hash->h4[11]);
    x4 ^= (hash->h4[12]);
    x5 ^= (hash->h4[13]);
    x6 ^= (hash->h4[14]);
    x7 ^= (hash->h4[15]);
  }
  else if(i == 1)
    x0 ^= 0x80;
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

  ulong fc_bit_count = (sph_u64) 64 << 3;

  S00 = S01 = S02 = S03 = S04 = S05 = S06 = S07 = S08 = S09 = S10 = S11 = S12 = S13 = S14 = S15 = S16 = S17 = S18 = S19 = 0;
  S20 = SPH_C32(0x8807a57e); S21 = SPH_C32(0xe616af75); S22 = SPH_C32(0xc5d3e4db); S23 = SPH_C32(0xac9ab027);
  S24 = SPH_C32(0xd915f117); S25 = SPH_C32(0xb6eecc54); S26 = SPH_C32(0x06e8020b); S27 = SPH_C32(0x4a92efd1);
  S28 = SPH_C32(0xaac6e2c9); S29 = SPH_C32(0xddb21398); S30 = SPH_C32(0xcae65838); S31 = SPH_C32(0x437f203f);
  S32 = SPH_C32(0x25ea78e7); S33 = SPH_C32(0x951fddd6); S34 = SPH_C32(0xda6ed11d); S35 = SPH_C32(0xe13e3567);

  FUGUE512_3(SWAP4(hash->h4[0x0]), SWAP4(hash->h4[0x1]), SWAP4(hash->h4[0x2]));
  FUGUE512_3(SWAP4(hash->h4[0x3]), SWAP4(hash->h4[0x4]), SWAP4(hash->h4[0x5]));
  FUGUE512_3(SWAP4(hash->h4[0x6]), SWAP4(hash->h4[0x7]), SWAP4(hash->h4[0x8]));
  FUGUE512_3(SWAP4(hash->h4[0x9]), SWAP4(hash->h4[0xA]), SWAP4(hash->h4[0xB]));
  FUGUE512_3(SWAP4(hash->h4[0xC]), SWAP4(hash->h4[0xD]), SWAP4(hash->h4[0xE]));
  FUGUE512_3(SWAP4(hash->h4[0xF]), as_uint2(fc_bit_count).y, as_uint2(fc_bit_count).x);

  // apply round shift if necessary
  int i;

  for (i = 0; i < 32; i ++)
  {
    ROR3;
    CMIX36(S00, S01, S02, S04, S05, S06, S18, S19, S20);
    SMIX(S00, S01, S02, S03);
  }

  for (i = 0; i < 13; i ++)
  {
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

  hash->h4[0] = SWAP4(S01);
  hash->h4[1] = SWAP4(S02);
  hash->h4[2] = SWAP4(S03);
  hash->h4[3] = SWAP4(S04);
  hash->h4[4] = SWAP4(S09);
  hash->h4[5] = SWAP4(S10);
  hash->h4[6] = SWAP4(S11);
  hash->h4[7] = SWAP4(S12);
  hash->h4[8] = SWAP4(S18);
  hash->h4[9] = SWAP4(S19);
  hash->h4[10] = SWAP4(S20);
  hash->h4[11] = SWAP4(S21);
  hash->h4[12] = SWAP4(S27);
  hash->h4[13] = SWAP4(S28);
  hash->h4[14] = SWAP4(S29);
  hash->h4[15] = SWAP4(S30);

  barrier(CLK_GLOBAL_MEM_FENCE);
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

  __local sph_u32 AES0[256], AES1[256], AES2[256], AES3[256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  for (int i = init; i < 256; i += step)
  {
    AES0[i] = AES0_C[i];
    AES1[i] = AES1_C[i];
    AES2[i] = AES2_C[i];
    AES3[i] = AES3_C[i];
  }
  barrier(CLK_LOCAL_MEM_FENCE);

  // copies hashes to "hash"
  // echo
  sph_u64 W00, W01, W10, W11, W20, W21, W30, W31, W40, W41, W50, W51, W60, W61, W70, W71, W80, W81, W90, W91, WA0, WA1, WB0, WB1, WC0, WC1, WD0, WD1, WE0, WE1, WF0, WF1;
  sph_u64 Vb00, Vb01, Vb10, Vb11, Vb20, Vb21, Vb30, Vb31, Vb40, Vb41, Vb50, Vb51, Vb60, Vb61, Vb70, Vb71;
  Vb00 = Vb10 = Vb20 = Vb30 = Vb40 = Vb50 = Vb60 = Vb70 = 512UL;
  Vb01 = Vb11 = Vb21 = Vb31 = Vb41 = Vb51 = Vb61 = Vb71 = 0;

  sph_u32 K0 = 512;
  sph_u32 K1 = 0;
  sph_u32 K2 = 0;
  sph_u32 K3 = 0;

  W00 = Vb00;
  W01 = Vb01;
  W10 = Vb10;
  W11 = Vb11;
  W20 = Vb20;
  W21 = Vb21;
  W30 = Vb30;
  W31 = Vb31;
  W40 = Vb40;
  W41 = Vb41;
  W50 = Vb50;
  W51 = Vb51;
  W60 = Vb60;
  W61 = Vb61;
  W70 = Vb70;
  W71 = Vb71;
  W80 = hash->h8[0];
  W81 = hash->h8[1];
  W90 = hash->h8[2];
  W91 = hash->h8[3];
  WA0 = hash->h8[4];
  WA1 = hash->h8[5];
  WB0 = hash->h8[6];
  WB1 = hash->h8[7];
  WC0 = 0x80;
  WC1 = 0;
  WD0 = 0;
  WD1 = 0;
  WE0 = 0;
  WE1 = 0x200000000000000;
  WF0 = 0x200;
  WF1 = 0;

  for (unsigned u = 0; u < 10; u ++)
  BIG_ROUND;

  Vb00 ^= hash->h8[0] ^ W00 ^ W80;
  Vb01 ^= hash->h8[1] ^ W01 ^ W81;
  Vb10 ^= hash->h8[2] ^ W10 ^ W90;
  Vb11 ^= hash->h8[3] ^ W11 ^ W91;
  Vb20 ^= hash->h8[4] ^ W20 ^ WA0;
  Vb21 ^= hash->h8[5] ^ W21 ^ WA1;
  Vb30 ^= hash->h8[6] ^ W30 ^ WB0;
  Vb31 ^= hash->h8[7] ^ W31 ^ WB1;

  barrier(CLK_GLOBAL_MEM_FENCE);

  bool result = (Vb11 <= target);

  if (result)
      output[atomic_inc(output+0xFF)] = gid;
}
