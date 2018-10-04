/*
 * XEVAN kernel implementation.
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

#ifndef XEVAN_CL
#define XEVAN_CL

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
#define SPH_COMPACT_BLAKE_64 0
#define SPH_LUFFA_PARALLEL 0
#define SPH_SMALL_FOOTPRINT_GROESTL 0
#define SPH_GROESTL_BIG_ENDIAN 0
#define SPH_CUBEHASH_UNROLL 0
#ifndef SPH_KECCAK_UNROLL
#define SPH_KECCAK_UNROLL   1
#endif
#ifndef SPH_HAMSI_EXPAND_BIG
  #define SPH_HAMSI_EXPAND_BIG 1
#endif

#ifndef WORKSIZE
#define WORKSIZE	64
#endif

#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

ulong FAST_ROTL64_LO(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x, x.s10, 32 - y))); }
ulong FAST_ROTL64_HI(const uint2 x, const uint y) { return(as_ulong(amd_bitalign(x.s10, x, 32 - (y - 32)))); }

#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#define VSWAP8(x)	(((x) >> 56) | (((x) >> 40) & 0x000000000000FF00UL) | (((x) >> 24) & 0x0000000000FF0000UL) \
          | (((x) >>  8) & 0x00000000FF000000UL) | (((x) <<  8) & 0x000000FF00000000UL) \
          | (((x) << 24) & 0x0000FF0000000000UL) | (((x) << 40) & 0x00FF000000000000UL) | (((x) << 56) & 0xFF00000000000000UL))


#define WOLF_JH_64BIT 1


#include "blake.cl"
#include "wolf-bmw.cl"
#include "wolf-groestl.cl"
#include "wolf-jh.cl"
#include "keccak.cl"
#include "skein.cl"
#include "luffa.cl"
#include "cubehash.cl"
#include "shavite.cl"
#include "simd.cl"
#include "echo.cl"
#include "hamsi.cl"
#include "fugue.cl"
#include "shabal.cl"
#include "whirlpool.cl"
#include "wolf-sha512.cl"
#include "haval.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC32LE(x) SWAP4(*(const __global sph_u32 *) (x));
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC32LE(x) (*(const __global sph_u32 *) (x));
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
#define WORKSIZE 256
#endif

void blake80kernel(__global unsigned char* block, uint gid, __global hash_t *hash)
{
  // blake
  sph_u64 H0 = SPH_C64(0x6A09E667F3BCC908), H1 = SPH_C64(0xBB67AE8584CAA73B);
  sph_u64 H2 = SPH_C64(0x3C6EF372FE94F82B), H3 = SPH_C64(0xA54FF53A5F1D36F1);
  sph_u64 H4 = SPH_C64(0x510E527FADE682D1), H5 = SPH_C64(0x9B05688C2B3E6C1F);
  sph_u64 H6 = SPH_C64(0x1F83D9ABFB41BD6B), H7 = SPH_C64(0x5BE0CD19137E2179);
  sph_u64 S0 = 0, S1 = 0, S2 = 0, S3 = 0;
  sph_u64 T0 = SPH_C64(80 << 3), T1 = 0;

  sph_u64 M0, M1, M2, M3, M4, M5, M6, M7;
  sph_u64 M8, M9, MA, MB, MC, MD, ME, MF;
  sph_u64 V0, V1, V2, V3, V4, V5, V6, V7;
  sph_u64 V8, V9, VA, VB, VC, VD, VE, VF;

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

  COMPRESS64;

  hash->h8[0] = H0;
  hash->h8[1] = H1;
  hash->h8[2] = H2;
  hash->h8[3] = H3;
  hash->h8[4] = H4;
  hash->h8[5] = H5;
  hash->h8[6] = H6;
  hash->h8[7] = H7;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void bmwkernel(__global hash_t *hash)
{
	// bmw
	ulong msg0[16] = { 0 }, msg1[16] = { 0 };

	#pragma unroll
	for(int i = 0; i < 8; ++i) msg0[i] = SWAP8(hash->h8[i]);

	msg1[0] = 0x80UL;
	msg1[15] = 1024UL;

	ulong h[16];

	for(int i = 0; i < 16; ++i) h[i] = BMW512_IV[i];

	BMW_Compression(msg0, h);
	BMW_Compression(msg1, msg0);

	for(int i = 0; i < 16; ++i) h[i] = BMW512_FINAL[i];

	BMW_Compression(msg1, h);

	#pragma unroll
	for(int i = 0; i < 8; ++i) hash->h8[i] = SWAP8(msg1[i + 8]);

	mem_fence(CLK_GLOBAL_MEM_FENCE);
}

#define GROESTL_RBTT(d, Hval, b0, b1, b2, b3, b4, b5, b6, b7)   do { \
	d = (T0[B64_0(Hval[b0])] ^ T1[B64_1(Hval[b1])] ^ T2[B64_2(Hval[b2])] ^ T3[B64_3(Hval[b3])] \
	^ as_ulong(as_uint2(T0[B64_4(Hval[b4])]).s10) ^ as_ulong(as_uint2(T1[B64_5(Hval[b5])]).s10) ^ as_ulong(as_uint2(T2[B64_6(Hval[b6])]).s10) ^ as_ulong(as_uint2(T3[B64_7(Hval[b7])]).s10)); \
	} while(0)

void GroestlPQ(ulong *HM, const ulong *H, const ulong *M, __local ulong *T0, __local ulong *T1, __local ulong *T2, __local ulong *T3)
{
	ulong QM[16];
	for(int i = 0; i < 16; ++i) HM[i] = H[i] ^ M[i];

	for(int i = 0; i < 16; ++i) QM[i] = M[i];

	for(int i = 0; i < 14; ++i)
	{
		ulong Tmp1[16], Tmp2[16];

		#pragma unroll
		for(int x = 0; x < 16; ++x)
		{
			Tmp1[x] = HM[x] ^ PC64(x << 4, i);
			Tmp2[x] = QM[x] ^ QC64(x << 4, i);
		}

		GROESTL_RBTT(HM[0], Tmp1, 0, 1, 2, 3, 4, 5, 6, 11);
		GROESTL_RBTT(HM[1], Tmp1, 1, 2, 3, 4, 5, 6, 7, 12);
		GROESTL_RBTT(HM[2], Tmp1, 2, 3, 4, 5, 6, 7, 8, 13);
		GROESTL_RBTT(HM[3], Tmp1, 3, 4, 5, 6, 7, 8, 9, 14);
		GROESTL_RBTT(HM[4], Tmp1, 4, 5, 6, 7, 8, 9, 10, 15);
		GROESTL_RBTT(HM[5], Tmp1, 5, 6, 7, 8, 9, 10, 11, 0);
		GROESTL_RBTT(HM[6], Tmp1, 6, 7, 8, 9, 10, 11, 12, 1);
		GROESTL_RBTT(HM[7], Tmp1, 7, 8, 9, 10, 11, 12, 13, 2);
		GROESTL_RBTT(HM[8], Tmp1, 8, 9, 10, 11, 12, 13, 14, 3);
		GROESTL_RBTT(HM[9], Tmp1, 9, 10, 11, 12, 13, 14, 15, 4);
		GROESTL_RBTT(HM[10], Tmp1, 10, 11, 12, 13, 14, 15, 0, 5);
		GROESTL_RBTT(HM[11], Tmp1, 11, 12, 13, 14, 15, 0, 1, 6);
		GROESTL_RBTT(HM[12], Tmp1, 12, 13, 14, 15, 0, 1, 2, 7);
		GROESTL_RBTT(HM[13], Tmp1, 13, 14, 15, 0, 1, 2, 3, 8);
		GROESTL_RBTT(HM[14], Tmp1, 14, 15, 0, 1, 2, 3, 4, 9);
		GROESTL_RBTT(HM[15], Tmp1, 15, 0, 1, 2, 3, 4, 5, 10);

		GROESTL_RBTT(QM[0], Tmp2, 1, 3, 5, 11, 0, 2, 4, 6);
		GROESTL_RBTT(QM[1], Tmp2, 2, 4, 6, 12, 1, 3, 5, 7);
		GROESTL_RBTT(QM[2], Tmp2, 3, 5, 7, 13, 2, 4, 6, 8);
		GROESTL_RBTT(QM[3], Tmp2, 4, 6, 8, 14, 3, 5, 7, 9);
		GROESTL_RBTT(QM[4], Tmp2, 5, 7, 9, 15, 4, 6, 8, 10);
		GROESTL_RBTT(QM[5], Tmp2, 6, 8, 10, 0, 5, 7, 9, 11);
		GROESTL_RBTT(QM[6], Tmp2, 7, 9, 11, 1, 6, 8, 10, 12);
		GROESTL_RBTT(QM[7], Tmp2, 8, 10, 12, 2, 7, 9, 11, 13);
		GROESTL_RBTT(QM[8], Tmp2, 9, 11, 13, 3, 8, 10, 12, 14);
		GROESTL_RBTT(QM[9], Tmp2, 10, 12, 14, 4, 9, 11, 13, 15);
		GROESTL_RBTT(QM[10], Tmp2, 11, 13, 15, 5, 10, 12, 14, 0);
		GROESTL_RBTT(QM[11], Tmp2, 12, 14, 0, 6, 11, 13, 15, 1);
		GROESTL_RBTT(QM[12], Tmp2, 13, 15, 1, 7, 12, 14, 0, 2);
		GROESTL_RBTT(QM[13], Tmp2, 14, 0, 2, 8, 13, 15, 1, 3);
		GROESTL_RBTT(QM[14], Tmp2, 15, 1, 3, 9, 14, 0, 2, 4);
		GROESTL_RBTT(QM[15], Tmp2, 0, 2, 4, 10, 15, 1, 3, 5);
	}

	for(int i = 0; i < 16; ++i) HM[i] ^= QM[i] ^ H[i];
}

void GroestlP(ulong *Out, const ulong *In, __local ulong *T0, __local ulong *T1, __local ulong *T2, __local ulong *T3)
{
	for(int i = 0; i < 16; ++i) Out[i] = In[i];

	for(int i = 0; i < 14; ++i)
	{
		ulong H[16];

		#pragma unroll
		for(int x = 0; x < 16; ++x)
			H[x] = Out[x] ^ PC64(x << 4, i);

		GROESTL_RBTT(Out[0], H, 0, 1, 2, 3, 4, 5, 6, 11);
		GROESTL_RBTT(Out[1], H, 1, 2, 3, 4, 5, 6, 7, 12);
		GROESTL_RBTT(Out[2], H, 2, 3, 4, 5, 6, 7, 8, 13);
		GROESTL_RBTT(Out[3], H, 3, 4, 5, 6, 7, 8, 9, 14);
		GROESTL_RBTT(Out[4], H, 4, 5, 6, 7, 8, 9, 10, 15);
		GROESTL_RBTT(Out[5], H, 5, 6, 7, 8, 9, 10, 11, 0);
		GROESTL_RBTT(Out[6], H, 6, 7, 8, 9, 10, 11, 12, 1);
		GROESTL_RBTT(Out[7], H, 7, 8, 9, 10, 11, 12, 13, 2);
		GROESTL_RBTT(Out[8], H, 8, 9, 10, 11, 12, 13, 14, 3);
		GROESTL_RBTT(Out[9], H, 9, 10, 11, 12, 13, 14, 15, 4);
		GROESTL_RBTT(Out[10], H, 10, 11, 12, 13, 14, 15, 0, 5);
		GROESTL_RBTT(Out[11], H, 11, 12, 13, 14, 15, 0, 1, 6);
		GROESTL_RBTT(Out[12], H, 12, 13, 14, 15, 0, 1, 2, 7);
		GROESTL_RBTT(Out[13], H, 13, 14, 15, 0, 1, 2, 3, 8);
		GROESTL_RBTT(Out[14], H, 14, 15, 0, 1, 2, 3, 4, 9);
		GROESTL_RBTT(Out[15], H, 15, 0, 1, 2, 3, 4, 5, 10);
	}
}

void GroestlCompress(ulong *State, ulong *Msg, __local ulong *T0, __local ulong *T1, __local ulong *T2, __local ulong *T3)
{
	ulong Output[16];

	GroestlPQ(Output, State, Msg, T0, T1, T2, T3);

	for(int i = 0; i < 16; ++i) State[i] = Output[i];
}

void groestlkernel(__global hash_t *hash)
{
	__local ulong T0[256], T1[256], T2[256], T3[256];

	for(int i = get_local_id(0); i < 256; i += WORKSIZE)
	{
		const ulong tmp = T0_G[i];
		T0[i] = tmp;
		T1[i] = rotate(tmp, 8UL);
		T2[i] = rotate(tmp, 16UL);
		T3[i] = rotate(tmp, 24UL);
	}

	barrier(CLK_LOCAL_MEM_FENCE);

	ulong M[16] = { 0 }, H[16] = { 0 }, H2[16];

	#pragma unroll
	for(int i = 0; i < 8; ++i) M[i] = SWAP8(hash->h8[i]);

	//M[8] = 0x80UL;
	//M[15] = 0x0100000000000000UL;

	H[15] = 0x0002000000000000UL;

	GroestlCompress(H, M, T0, T1, T2, T3);

	M[0] = 0x80UL;

	for(int i = 1; i < 15; ++i) M[i] = 0x00UL;

	M[15] = 0x0200000000000000UL;

	GroestlCompress(H, M, T0, T1, T2, T3);

	GroestlP(H2, H, T0, T1, T2, T3);

	vstore8(VSWAP8(((ulong8 *)H2)[1] ^ ((ulong8 *)H)[1]), 0, hash->h8);

	mem_fence(CLK_GLOBAL_MEM_FENCE);
}

void skeinkernel(__global hash_t *hash)
{
  // skein
  sph_u64 h0 = SPH_C64(0x4903ADFF749C51CE), h1 = SPH_C64(0x0D95DE399746DF03), h2 = SPH_C64(0x8FD1934127C79BCE), h3 = SPH_C64(0x9A255629FF352CB1), h4 = SPH_C64(0x5DB62599DF6CA7B0), h5 = SPH_C64(0xEABE394CA9D5C3F4), h6 = SPH_C64(0x991112C71A75B523), h7 = SPH_C64(0xAE18A40B660FCC33);
  sph_u64 m0, m1, m2, m3, m4, m5, m6, m7;
  sph_u64 bcount = 1;

  m0 = SWAP8(hash->h8[0]);
  m1 = SWAP8(hash->h8[1]);
  m2 = SWAP8(hash->h8[2]);
  m3 = SWAP8(hash->h8[3]);
  m4 = SWAP8(hash->h8[4]);
  m5 = SWAP8(hash->h8[5]);
  m6 = SWAP8(hash->h8[6]);
  m7 = SWAP8(hash->h8[7]);

  UBI_BIG(224, 0);

  bcount = 1;
  m0 = m1 = m2 = m3 = m4 = m5 = m6 = m7 = 0;

  UBI_BIG(352, 64);

  bcount = 0;
  m0 = m1 = m2 = m3 = m4 = m5 = m6 = m7 = 0;

  UBI_BIG(510, 8);

  hash->h8[0] = SWAP8(h0);
  hash->h8[1] = SWAP8(h1);
  hash->h8[2] = SWAP8(h2);
  hash->h8[3] = SWAP8(h3);
  hash->h8[4] = SWAP8(h4);
  hash->h8[5] = SWAP8(h5);
  hash->h8[6] = SWAP8(h6);
  hash->h8[7] = SWAP8(h7);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void jhkernel(__global hash_t *hash)
{
	JH_CHUNK_TYPE evnhi = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x17AA003E964BD16FUL), JH_BASE_TYPE_CAST(0x1E806F53C1A01D89UL), JH_BASE_TYPE_CAST(0x694AE34105E66901UL), JH_BASE_TYPE_CAST(0x56F8B19DECF657CFUL));
	JH_CHUNK_TYPE evnlo = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x43D5157A052E6A63UL), JH_BASE_TYPE_CAST(0x806D2BEA6B05A92AUL), JH_BASE_TYPE_CAST(0x5AE66F2E8E8AB546UL), JH_BASE_TYPE_CAST(0x56B116577C8806A7UL));
	JH_CHUNK_TYPE oddhi = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x0BEF970C8D5E228AUL), JH_BASE_TYPE_CAST(0xA6BA7520DBCC8E58UL), JH_BASE_TYPE_CAST(0x243C84C1D0A74710UL), JH_BASE_TYPE_CAST(0xFB1785E6DFFCC2E3UL));
	JH_CHUNK_TYPE oddlo = (JH_CHUNK_TYPE)(JH_BASE_TYPE_CAST(0x61C3B3F2591234E9UL), JH_BASE_TYPE_CAST(0xF73BF8BA763A0FA9UL), JH_BASE_TYPE_CAST(0x99C15A2DB1716E3BUL), JH_BASE_TYPE_CAST(0x4BDD8CCC78465A54UL));

	for(int i = 0; i < 3; ++i)
	{
		ulong input[8];

		if(i == 0)
		{
			#pragma unroll
			for(int x = 0; x < 8; ++x) input[x] = SWAP8(hash->h8[x]);
		}
		else if(i == 1)
		{
			for(int x = 0; x < 8; ++x) input[x] = 0x00UL;
		}
		else
		{
			input[0] = 0x80UL;
			input[7] = 0x0004000000000000UL;
			for(int x = 1; x < 7; ++x) input[x] = 0x00UL;
		}

		#ifdef WOLF_JH_64BIT

		evnhi.s0 ^= JH_BASE_TYPE_CAST(input[0]);
		evnlo.s0 ^= JH_BASE_TYPE_CAST(input[1]);
		oddhi.s0 ^= JH_BASE_TYPE_CAST(input[2]);
		oddlo.s0 ^= JH_BASE_TYPE_CAST(input[3]);
		evnhi.s1 ^= JH_BASE_TYPE_CAST(input[4]);
		evnlo.s1 ^= JH_BASE_TYPE_CAST(input[5]);
		oddhi.s1 ^= JH_BASE_TYPE_CAST(input[6]);
		oddlo.s1 ^= JH_BASE_TYPE_CAST(input[7]);

		#else

		evnhi.lo.lo ^= JH_BASE_TYPE_CAST(input[0]);
		evnlo.lo.lo ^= JH_BASE_TYPE_CAST(input[1]);
		oddhi.lo.lo ^= JH_BASE_TYPE_CAST(input[2]);
		oddlo.lo.lo ^= JH_BASE_TYPE_CAST(input[3]);
		evnhi.lo.hi ^= JH_BASE_TYPE_CAST(input[4]);
		evnlo.lo.hi ^= JH_BASE_TYPE_CAST(input[5]);
		oddhi.lo.hi ^= JH_BASE_TYPE_CAST(input[6]);
		oddlo.lo.hi ^= JH_BASE_TYPE_CAST(input[7]);

		#endif

		// E8

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

		#ifdef WOLF_JH_64BIT

		evnhi.s2 ^= JH_BASE_TYPE_CAST(input[0]);
		evnlo.s2 ^= JH_BASE_TYPE_CAST(input[1]);
		oddhi.s2 ^= JH_BASE_TYPE_CAST(input[2]);
		oddlo.s2 ^= JH_BASE_TYPE_CAST(input[3]);
		evnhi.s3 ^= JH_BASE_TYPE_CAST(input[4]);
		evnlo.s3 ^= JH_BASE_TYPE_CAST(input[5]);
		oddhi.s3 ^= JH_BASE_TYPE_CAST(input[6]);
		oddlo.s3 ^= JH_BASE_TYPE_CAST(input[7]);

		#else

		evnhi.hi.lo ^= JH_BASE_TYPE_CAST(input[0]);
		evnlo.hi.lo ^= JH_BASE_TYPE_CAST(input[1]);
		oddhi.hi.lo ^= JH_BASE_TYPE_CAST(input[2]);
		oddlo.hi.lo ^= JH_BASE_TYPE_CAST(input[3]);
		evnhi.hi.hi ^= JH_BASE_TYPE_CAST(input[4]);
		evnlo.hi.hi ^= JH_BASE_TYPE_CAST(input[5]);
		oddhi.hi.hi ^= JH_BASE_TYPE_CAST(input[6]);
		oddlo.hi.hi ^= JH_BASE_TYPE_CAST(input[7]);

		#endif
	}

	#ifdef WOLF_JH_64BIT

	hash->h8[0] = SWAP8(as_ulong(evnhi.s2));
	hash->h8[1] = SWAP8(as_ulong(evnlo.s2));
	hash->h8[2] = SWAP8(as_ulong(oddhi.s2));
	hash->h8[3] = SWAP8(as_ulong(oddlo.s2));
	hash->h8[4] = SWAP8(as_ulong(evnhi.s3));
	hash->h8[5] = SWAP8(as_ulong(evnlo.s3));
	hash->h8[6] = SWAP8(as_ulong(oddhi.s3));
	hash->h8[7] = SWAP8(as_ulong(oddlo.s3));

	#else

	hash->h8[0] = SWAP8(as_ulong(evnhi.hi.lo));
	hash->h8[1] = SWAP8(as_ulong(evnlo.hi.lo));
	hash->h8[2] = SWAP8(as_ulong(oddhi.hi.lo));
	hash->h8[3] = SWAP8(as_ulong(oddlo.hi.lo));
	hash->h8[4] = SWAP8(as_ulong(evnhi.hi.hi));
	hash->h8[5] = SWAP8(as_ulong(evnlo.hi.hi));
	hash->h8[6] = SWAP8(as_ulong(oddhi.hi.hi));
	hash->h8[7] = SWAP8(as_ulong(oddlo.hi.hi));

	#endif

	mem_fence(CLK_GLOBAL_MEM_FENCE);
}

void keccakkernel(__global hash_t *hash)
{
  // keccak
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

  a00 ^= SWAP8(hash->h8[0]);
  a10 ^= SWAP8(hash->h8[1]);
  a20 ^= SWAP8(hash->h8[2]);
  a30 ^= SWAP8(hash->h8[3]);
  a40 ^= SWAP8(hash->h8[4]);
  a01 ^= SWAP8(hash->h8[5]);
  a11 ^= SWAP8(hash->h8[6]);
  a21 ^= SWAP8(hash->h8[7]);
  KECCAK_F_1600;

  a21 ^= 0x1;
  a31 ^= 0x8000000000000000;
  KECCAK_F_1600;

  // Finalize the "lane complement"
  a10 = ~a10;
  a20 = ~a20;

  hash->h8[0] = SWAP8(a00);
  hash->h8[1] = SWAP8(a10);
  hash->h8[2] = SWAP8(a20);
  hash->h8[3] = SWAP8(a30);
  hash->h8[4] = SWAP8(a40);
  hash->h8[5] = SWAP8(a01);
  hash->h8[6] = SWAP8(a11);
  hash->h8[7] = SWAP8(a21);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void luffakernel(__global hash_t *hash)
{
  // luffa
  sph_u32 V00 = SPH_C32(0x6d251e69), V01 = SPH_C32(0x44b051e0), V02 = SPH_C32(0x4eaa6fb4), V03 = SPH_C32(0xdbf78465), V04 = SPH_C32(0x6e292011), V05 = SPH_C32(0x90152df4), V06 = SPH_C32(0xee058139), V07 = SPH_C32(0xdef610bb);
  sph_u32 V10 = SPH_C32(0xc3b44b95), V11 = SPH_C32(0xd9d2f256), V12 = SPH_C32(0x70eee9a0), V13 = SPH_C32(0xde099fa3), V14 = SPH_C32(0x5d9b0557), V15 = SPH_C32(0x8fc944b3), V16 = SPH_C32(0xcf1ccf0e), V17 = SPH_C32(0x746cd581);
  sph_u32 V20 = SPH_C32(0xf7efc89d), V21 = SPH_C32(0x5dba5781), V22 = SPH_C32(0x04016ce5), V23 = SPH_C32(0xad659c05), V24 = SPH_C32(0x0306194f), V25 = SPH_C32(0x666d1836), V26 = SPH_C32(0x24aa230a), V27 = SPH_C32(0x8b264ae7);
  sph_u32 V30 = SPH_C32(0x858075d5), V31 = SPH_C32(0x36d79cce), V32 = SPH_C32(0xe571f7d7), V33 = SPH_C32(0x204b1f67), V34 = SPH_C32(0x35870c6a), V35 = SPH_C32(0x57e9e923), V36 = SPH_C32(0x14bcb808), V37 = SPH_C32(0x7cde72ce);
  sph_u32 V40 = SPH_C32(0x6c68e9be), V41 = SPH_C32(0x5ec41e22), V42 = SPH_C32(0xc825b7c7), V43 = SPH_C32(0xaffb4363), V44 = SPH_C32(0xf5df3999), V45 = SPH_C32(0x0fc688f1), V46 = SPH_C32(0xb07224cc), V47 = SPH_C32(0x03e86cea);

  DECL_TMP8(M);

  M0 = hash->h4[1];
  M1 = hash->h4[0];
  M2 = hash->h4[3];
  M3 = hash->h4[2];
  M4 = hash->h4[5];
  M5 = hash->h4[4];
  M6 = hash->h4[7];
  M7 = hash->h4[6];

  for(uint i = 0; i < 7; i++)
  {
    MI5;
    LUFFA_P5;

    if(i == 0)
    {
      M0 = hash->h4[9];
      M1 = hash->h4[8];
      M2 = hash->h4[11];
      M3 = hash->h4[10];
      M4 = hash->h4[13];
      M5 = hash->h4[12];
      M6 = hash->h4[15];
      M7 = hash->h4[14];
    }
    else if(i == 1)
    {
      M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    }
    else if(i == 2)
    {
      M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    }
    else if(i == 3)
    {
      M0 = 0x80000000;
      M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    }
    else if(i == 4)
      M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
    else if(i == 5)
    {
      hash->h4[1] = V00 ^ V10 ^ V20 ^ V30 ^ V40;
      hash->h4[0] = V01 ^ V11 ^ V21 ^ V31 ^ V41;
      hash->h4[3] = V02 ^ V12 ^ V22 ^ V32 ^ V42;
      hash->h4[2] = V03 ^ V13 ^ V23 ^ V33 ^ V43;
      hash->h4[5] = V04 ^ V14 ^ V24 ^ V34 ^ V44;
      hash->h4[4] = V05 ^ V15 ^ V25 ^ V35 ^ V45;
      hash->h4[7] = V06 ^ V16 ^ V26 ^ V36 ^ V46;
      hash->h4[6] = V07 ^ V17 ^ V27 ^ V37 ^ V47;
    }
  }

  hash->h4[9] = V00 ^ V10 ^ V20 ^ V30 ^ V40;
  hash->h4[8] = V01 ^ V11 ^ V21 ^ V31 ^ V41;
  hash->h4[11] = V02 ^ V12 ^ V22 ^ V32 ^ V42;
  hash->h4[10] = V03 ^ V13 ^ V23 ^ V33 ^ V43;
  hash->h4[13] = V04 ^ V14 ^ V24 ^ V34 ^ V44;
  hash->h4[12] = V05 ^ V15 ^ V25 ^ V35 ^ V45;
  hash->h4[15] = V06 ^ V16 ^ V26 ^ V36 ^ V46;
  hash->h4[14] = V07 ^ V17 ^ V27 ^ V37 ^ V47;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void cubehashkernel(__global hash_t *hash)
{
  // cubehash.h1
  sph_u32 x0 = SPH_C32(0x2AEA2A61), x1 = SPH_C32(0x50F494D4), x2 = SPH_C32(0x2D538B8B), x3 = SPH_C32(0x4167D83E);
  sph_u32 x4 = SPH_C32(0x3FEE2313), x5 = SPH_C32(0xC701CF8C), x6 = SPH_C32(0xCC39968E), x7 = SPH_C32(0x50AC5695);
  sph_u32 x8 = SPH_C32(0x4D42C787), x9 = SPH_C32(0xA647A8B3), xa = SPH_C32(0x97CF0BEF), xb = SPH_C32(0x825B4537);
  sph_u32 xc = SPH_C32(0xEEF864D2), xd = SPH_C32(0xF22090C4), xe = SPH_C32(0xD0E5CD33), xf = SPH_C32(0xA23911AE);
  sph_u32 xg = SPH_C32(0xFCD398D9), xh = SPH_C32(0x148FE485), xi = SPH_C32(0x1B017BEF), xj = SPH_C32(0xB6444532);
  sph_u32 xk = SPH_C32(0x6A536159), xl = SPH_C32(0x2FF5781C), xm = SPH_C32(0x91FA7934), xn = SPH_C32(0x0DBADEA9);
  sph_u32 xo = SPH_C32(0xD65C8A2B), xp = SPH_C32(0xA5A70E75), xq = SPH_C32(0xB1C62456), xr = SPH_C32(0xBC796576);
  sph_u32 xs = SPH_C32(0x1921C8F7), xt = SPH_C32(0xE7989AF1), xu = SPH_C32(0x7795D246), xv = SPH_C32(0xD43E3B44);

  x0 ^= SWAP4(hash->h4[1]);
  x1 ^= SWAP4(hash->h4[0]);
  x2 ^= SWAP4(hash->h4[3]);
  x3 ^= SWAP4(hash->h4[2]);
  x4 ^= SWAP4(hash->h4[5]);
  x5 ^= SWAP4(hash->h4[4]);
  x6 ^= SWAP4(hash->h4[7]);
  x7 ^= SWAP4(hash->h4[6]);

  for (int i = 0; i < 15; i ++)
  {
    SIXTEEN_ROUNDS;

    if (i == 0)
    {
      x0 ^= SWAP4(hash->h4[9]);
      x1 ^= SWAP4(hash->h4[8]);
      x2 ^= SWAP4(hash->h4[11]);
      x3 ^= SWAP4(hash->h4[10]);
      x4 ^= SWAP4(hash->h4[13]);
      x5 ^= SWAP4(hash->h4[12]);
      x6 ^= SWAP4(hash->h4[15]);
      x7 ^= SWAP4(hash->h4[14]);
    }
    else if(i == 3)
      x0 ^= 0x80;
    else if (i == 4)
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

void shavitekernel(__global hash_t *hash, __local sph_u32 AES0[256], __local sph_u32 AES1[256], __local sph_u32 AES2[256], __local sph_u32 AES3[256])
{
	// shavite
	// IV
	sph_u32 h0 = SPH_C32(0x72FCCDD8), h1 = SPH_C32(0x79CA4727), h2 = SPH_C32(0x128A077B), h3 = SPH_C32(0x40D55AEC);
	sph_u32 h4 = SPH_C32(0xD1901A06), h5 = SPH_C32(0x430AE307), h6 = SPH_C32(0xB29F5CD1), h7 = SPH_C32(0xDF07FBFC);
	sph_u32 h8 = SPH_C32(0x8E45D73D), h9 = SPH_C32(0x681AB538), hA = SPH_C32(0xBDE86578), hB = SPH_C32(0xDD577E47);
	sph_u32 hC = SPH_C32(0xE275EADE), hD = SPH_C32(0x502D9FCD), hE = SPH_C32(0xB9357178), hF = SPH_C32(0x022A4B9A);

	// state
	sph_u32 rk00, rk01, rk02, rk03, rk04, rk05, rk06, rk07;
	sph_u32 rk08, rk09, rk0A, rk0B, rk0C, rk0D, rk0E, rk0F;
	sph_u32 rk10, rk11, rk12, rk13, rk14, rk15, rk16, rk17;
	sph_u32 rk18, rk19, rk1A, rk1B, rk1C, rk1D, rk1E, rk1F;

	sph_u32 sc_count0 = 0x400, sc_count1 = 0, sc_count2 = 0, sc_count3 = 0;

	rk00 = hash->h4[0];
	rk01 = hash->h4[1];
	rk02 = hash->h4[2];
	rk03 = hash->h4[3];
	rk04 = hash->h4[4];
	rk05 = hash->h4[5];
	rk06 = hash->h4[6];
	rk07 = hash->h4[7];
	rk08 = hash->h4[8];
	rk09 = hash->h4[9];
	rk0A = hash->h4[10];
	rk0B = hash->h4[11];
	rk0C = hash->h4[12];
	rk0D = hash->h4[13];
	rk0E = hash->h4[14];
	rk0F = hash->h4[15];
	rk10 = rk11 = rk12 = rk13 = rk14 = rk15 = rk16 = rk17 = 0;
	rk18 = rk19 = rk1A = rk1B = rk1C = rk1D = rk1E = rk1F = 0;


	bool flag = false;

	compress:

	c512(buf);
	if(flag) goto end;

	rk00 = 0x80;
	rk01 = rk02 = rk03 = rk04 = rk05 = rk06 = rk07 = 0;
	rk08 = rk09 = rk0A = rk0B = rk0C = rk0D = rk0E = rk0F = 0;
	rk10 = rk11 = rk12 = rk13 = rk14 = rk15 = rk16 = rk17 = rk18 = rk19 = rk1A = 0;
	rk1B = 0x4000000;
	rk1C = rk1D = rk1E = 0;
	rk1F = 0x2000000;
	sc_count0 = 0;

	flag = true;
	goto compress;

	end:

	hash->h4[0] = h0;
	hash->h4[1] = h1;
	hash->h4[2] = h2;
	hash->h4[3] = h3;
	hash->h4[4] = h4;
	hash->h4[5] = h5;
	hash->h4[6] = h6;
	hash->h4[7] = h7;
	hash->h4[8] = h8;
	hash->h4[9] = h9;
	hash->h4[10] = hA;
	hash->h4[11] = hB;
	hash->h4[12] = hC;
	hash->h4[13] = hD;
	hash->h4[14] = hE;
	hash->h4[15] = hF;

	barrier(CLK_GLOBAL_MEM_FENCE);
}

void simdkernel(__global hash_t *hash)
{
  // simd
  s32 q[256];
  unsigned char x[128];
  for(unsigned int i = 0; i < 64; i++)
    x[i] = hash->h1[i];
  for(unsigned int i = 64; i < 128; i++)
    x[i] = 0;

  u32 A0 = C32(0x0BA16B95), A1 = C32(0x72F999AD), A2 = C32(0x9FECC2AE), A3 = C32(0xBA3264FC), A4 = C32(0x5E894929), A5 = C32(0x8E9F30E5), A6 = C32(0x2F1DAA37), A7 = C32(0xF0F2C558);
  u32 B0 = C32(0xAC506643), B1 = C32(0xA90635A5), B2 = C32(0xE25B878B), B3 = C32(0xAAB7878F), B4 = C32(0x88817F7A), B5 = C32(0x0A02892B), B6 = C32(0x559A7550), B7 = C32(0x598F657E);
  u32 C0 = C32(0x7EEF60A1), C1 = C32(0x6B70E3E8), C2 = C32(0x9C1714D1), C3 = C32(0xB958E2A8), C4 = C32(0xAB02675E), C5 = C32(0xED1C014F), C6 = C32(0xCD8D65BB), C7 = C32(0xFDB7A257);
  u32 D0 = C32(0x09254899), D1 = C32(0xD699C7BC), D2 = C32(0x9019B6DC), D3 = C32(0x2B9022E4), D4 = C32(0x8FA14956), D5 = C32(0x21BF9BD3), D6 = C32(0xB94D0943), D7 = C32(0x6FFDDC22);

  FFT256(0, 1, 0, ll1);
  for (int i = 0; i < 256; i ++)
  {
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

  #define q SIMD_Q_128

  A0 ^= 0x400;

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

void echokernel(__global hash_t *hash, __local sph_u32 AES0[256], __local sph_u32 AES1[256], __local sph_u32 AES2[256], __local sph_u32 AES3[256])
{
	// echo
	sph_u64 W00, W01, W10, W11, W20, W21, W30, W31, W40, W41, W50, W51, W60, W61, W70, W71, W80, W81, W90, W91, WA0, WA1, WB0, WB1, WC0, WC1, WD0, WD1, WE0, WE1, WF0, WF1;
	sph_u64 Vb00, Vb01, Vb10, Vb11, Vb20, Vb21, Vb30, Vb31, Vb40, Vb41, Vb50, Vb51, Vb60, Vb61, Vb70, Vb71;
	Vb00 = Vb10 = Vb20 = Vb30 = Vb40 = Vb50 = Vb60 = Vb70 = 512UL;
	Vb01 = Vb11 = Vb21 = Vb31 = Vb41 = Vb51 = Vb61 = Vb71 = 0;

	sph_u32 K0 = 1024;
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
	WC0 = 0;
	WC1 = 0;
	WD0 = 0;
	WD1 = 0;
	WE0 = 0;
	WE1 = 0;
	WF0 = 0;
	WF1 = 0;

	#pragma unroll 1
	for (unsigned u = 0; u < 10; u++)
	{
		BIG_ROUND;
	}

	Vb00 ^= hash->h8[0] ^ W00 ^ W80;
	Vb01 ^= hash->h8[1] ^ W01 ^ W81;
	Vb10 ^= hash->h8[2] ^ W10 ^ W90;
	Vb11 ^= hash->h8[3] ^ W11 ^ W91;
	Vb20 ^= hash->h8[4] ^ W20 ^ WA0;
	Vb21 ^= hash->h8[5] ^ W21 ^ WA1;
	Vb30 ^= hash->h8[6] ^ W30 ^ WB0;
	Vb31 ^= hash->h8[7] ^ W31 ^ WB1;
	Vb40 ^= W40 ^ WC0;
	Vb41 ^= W41 ^ WC1;
	Vb50 ^= W50 ^ WD0;
	Vb51 ^= W51 ^ WD1;
	Vb60 ^= W60 ^ WE0;
	Vb61 ^= W61 ^ WE1;
	Vb70 ^= W70 ^ WF0;
	Vb71 ^= W71 ^ WF1;


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
	W80 = 0x80;
	W81 = W90 = W91 = WA0 = WA1 = WB0 = WB1 = WC0 = WC1 = WD0 = WD1 = WE0 = 0;
	WE1 = 0x200000000000000;
	WF0 = 0x400;
	WF1 = 0;
	K0 = K1 = K2 = K3 = 0;

	#pragma unroll 1
	for (unsigned u = 0; u < 10; u++)
	{
		BIG_ROUND;
	}

	Vb00 ^= 0x80 ^ W00 ^ W80;
	Vb01 ^= W01 ^ W81;
	Vb10 ^= W10 ^ W90;
	Vb11 ^= W11 ^ W91;
	Vb20 ^= W20 ^ WA0;
	Vb21 ^= W21 ^ WA1;
	Vb30 ^= W30 ^ WB0;
	Vb31 ^= W31 ^ WB1;

	hash->h8[0] = Vb00;
	hash->h8[1] = Vb01;
	hash->h8[2] = Vb10;
	hash->h8[3] = Vb11;
	hash->h8[4] = Vb20;
	hash->h8[5] = Vb21;
	hash->h8[6] = Vb30;
	hash->h8[7] = Vb31;

	barrier(CLK_GLOBAL_MEM_FENCE);


	/*
	__local uint AES0_WOLF[256], AES1_WOLF[256], AES2_WOLF[256], AES3_WOLF[256];

	const uint step = get_local_size(0);

	for(int i = get_local_id(0); i < 256; i += step)
	{
		const uint tmp = AES0_C[i];
		AES0_WOLF[i] = tmp;
		AES1_WOLF[i] = rotate(tmp, 8U);
		AES2_WOLF[i] = rotate(tmp, 16U);
		AES3_WOLF[i] = rotate(tmp, 24U);
	}

	// echo
	uint4 W[16];

	#pragma unroll
	for(int i = 0; i < 8; ++i) W[i] = (uint4)(512, 0, 0, 0);

	((uint16 *)W)[2] = vload16(0, hash->h4);

	//W[12] = (uint4)(0x80, 0, 0, 0);
	//W[13] = (uint4)(0, 0, 0, 0);
	//W[14] = (uint4)(0, 0, 0, 0x02000000);
	//W[15] = (uint4)(512, 0, 0, 0);

	W[12] = (uint4)(0, 0, 0, 0);
	W[13] = (uint4)(0, 0, 0, 0);
	W[14] = (uint4)(0, 0, 0, 0);
	W[15] = (uint4)(0, 0, 0, 0);

	mem_fence(CLK_LOCAL_MEM_FENCE);

	#pragma unroll 1
	for(uchar i = 0; i < 10; ++i)
	{
		BigSubBytes(AES0_WOLF, AES1_WOLF, AES2_WOLF, AES3_WOLF, W, i, 1024);
		BigShiftRows(W);
		BigMixColumns(W);
	}

	#pragma unroll
	for(int i = 0; i < 4; ++i) W[i] ^= vload4(i, hash->h4) ^  W[i + 8] ^ (uint4)(512U, 0, 0, 0);

	for(int i = 4; i < 8; ++i) W[i] ^= W[i + 8];

	uint4 tmp[4];

	((uint16 *)tmp)[0] = ((uint16 *)W)[0];

	((uint16 *)W)[2] = (uint16)(0U);
	((uint16 *)W)[3] = (uint16)(0U);

	W[8].s0 = 0x80;
	W[14] = (uint4)(0, 0, 0, 0x02000000);
	W[15] = (uint4)(1024, 0, 0, 0);

	#pragma unroll 1
	for(uchar i = 0; i < 10; ++i)
	{
		BigSubBytes(AES0_WOLF, AES1_WOLF, AES2_WOLF, AES3_WOLF, W, i, 0);
		BigShiftRows(W);
		BigMixColumns(W);
	}

	((uint16 *)W)[0] ^= ((uint16 *)tmp)[0] ^ ((uint16 *)W)[2];

	W[0].s0 ^= 0x80;

	for(int i = 0; i < 4; ++i) vstore4(W[i], i, hash->h4);
	barrier(CLK_GLOBAL_MEM_FENCE);
	*/
}

void hamsikernel(__global hash_t *hash)
{
  // hamsi
  sph_u32 c0 = HAMSI_IV512[0], c1 = HAMSI_IV512[1], c2 = HAMSI_IV512[2], c3 = HAMSI_IV512[3];
  sph_u32 c4 = HAMSI_IV512[4], c5 = HAMSI_IV512[5], c6 = HAMSI_IV512[6], c7 = HAMSI_IV512[7];
  sph_u32 c8 = HAMSI_IV512[8], c9 = HAMSI_IV512[9], cA = HAMSI_IV512[10], cB = HAMSI_IV512[11];
  sph_u32 cC = HAMSI_IV512[12], cD = HAMSI_IV512[13], cE = HAMSI_IV512[14], cF = HAMSI_IV512[15];
  sph_u32 m0, m1, m2, m3, m4, m5, m6, m7;
  sph_u32 m8, m9, mA, mB, mC, mD, mE, mF;
  sph_u32 h[16] = { c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, cA, cB, cC, cD, cE, cF };

  #define buf(u) hash->h1[i + u]

  for(int i = 0; i < 64; i += 8)
  {
    INPUT_BIG;
    P_BIG;
    T_BIG;
  }

  #undef buf
  #define buf(u) 0

  for(int i = 0; i < 64; i += 8)
  {
    INPUT_BIG;
    P_BIG;
    T_BIG;
  }

  #undef buf
  #define buf(u) (u == 0 ? 0x80 : 0)

  INPUT_BIG;
  P_BIG;
  T_BIG;

  #undef buf
  #define buf(u) (u == 6 ? 4 : 0)

  INPUT_BIG;
  PF_BIG;
  T_BIG;

  for (unsigned u = 0; u < 16; u ++)
      hash->h4[u] = h[u];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void fuguekernel(__global hash_t *hash, __local sph_u32 mixtab0[256], __local sph_u32 mixtab1[256], __local sph_u32 mixtab2[256], __local sph_u32 mixtab3[256])
{
  // fugue
  sph_u32 S00, S01, S02, S03, S04, S05, S06, S07, S08, S09;
  sph_u32 S10, S11, S12, S13, S14, S15, S16, S17, S18, S19;
  sph_u32 S20, S21, S22, S23, S24, S25, S26, S27, S28, S29;
  sph_u32 S30, S31, S32, S33, S34, S35;

  ulong fc_bit_count = (sph_u64)128 << 3;

  S00 = S01 = S02 = S03 = S04 = S05 = S06 = S07 = S08 = S09 = S10 = S11 = S12 = S13 = S14 = S15 = S16 = S17 = S18 = S19 = 0;
  S20 = SPH_C32(0x8807a57e); S21 = SPH_C32(0xe616af75); S22 = SPH_C32(0xc5d3e4db); S23 = SPH_C32(0xac9ab027);
  S24 = SPH_C32(0xd915f117); S25 = SPH_C32(0xb6eecc54); S26 = SPH_C32(0x06e8020b); S27 = SPH_C32(0x4a92efd1);
  S28 = SPH_C32(0xaac6e2c9); S29 = SPH_C32(0xddb21398); S30 = SPH_C32(0xcae65838); S31 = SPH_C32(0x437f203f);
  S32 = SPH_C32(0x25ea78e7); S33 = SPH_C32(0x951fddd6); S34 = SPH_C32(0xda6ed11d); S35 = SPH_C32(0xe13e3567);

  FUGUE512_3((hash->h4[0x0]), (hash->h4[0x1]), (hash->h4[0x2]));
  FUGUE512_3((hash->h4[0x3]), (hash->h4[0x4]), (hash->h4[0x5]));
  FUGUE512_3((hash->h4[0x6]), (hash->h4[0x7]), (hash->h4[0x8]));
  FUGUE512_3((hash->h4[0x9]), (hash->h4[0xA]), (hash->h4[0xB]));
  FUGUE512_3((hash->h4[0xC]), (hash->h4[0xD]), (hash->h4[0xE]));
  FUGUE512_3((hash->h4[0xF]), (0x0), (0x0));
  FUGUE512_3((0x0), (0x0), (0x0));
  FUGUE512_3((0x0), (0x0), (0x0));
  FUGUE512_3((0x0), (0x0), (0x0));
  FUGUE512_3((0x0), (0x0), (0x0));
  FUGUE512_4((0x0), (0x0), as_uint2(fc_bit_count).y, as_uint2(fc_bit_count).x);

#define SWAP_3(a,b,c) { sph_u32 u = a; a = b; b = c; c = u; }
  SWAP_3(S00, S24, S12);
  SWAP_3(S01, S25, S13);
  SWAP_3(S02, S26, S14);
  SWAP_3(S03, S27, S15);
  SWAP_3(S04, S28, S16);
  SWAP_3(S05, S29, S17);
  SWAP_3(S06, S30, S18);
  SWAP_3(S07, S31, S19);
  SWAP_3(S08, S32, S20);
  SWAP_3(S09, S33, S21);
  SWAP_3(S10, S34, S22);
  SWAP_3(S11, S35, S23);

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

void shabalkernel(__global hash_t *hash)
{
  // shabal
  sph_u32 A00 = A_init_512[0], A01 = A_init_512[1], A02 = A_init_512[2], A03 = A_init_512[3], A04 = A_init_512[4], A05 = A_init_512[5], A06 = A_init_512[6], A07 = A_init_512[7],
    A08 = A_init_512[8], A09 = A_init_512[9], A0A = A_init_512[10], A0B = A_init_512[11];
  sph_u32 B0 = B_init_512[0], B1 = B_init_512[1], B2 = B_init_512[2], B3 = B_init_512[3], B4 = B_init_512[4], B5 = B_init_512[5], B6 = B_init_512[6], B7 = B_init_512[7],
    B8 = B_init_512[8], B9 = B_init_512[9], BA = B_init_512[10], BB = B_init_512[11], BC = B_init_512[12], BD = B_init_512[13], BE = B_init_512[14], BF = B_init_512[15];
  sph_u32 C0 = C_init_512[0], C1 = C_init_512[1], C2 = C_init_512[2], C3 = C_init_512[3], C4 = C_init_512[4], C5 = C_init_512[5], C6 = C_init_512[6], C7 = C_init_512[7],
    C8 = C_init_512[8], C9 = C_init_512[9], CA = C_init_512[10], CB = C_init_512[11], CC = C_init_512[12], CD = C_init_512[13], CE = C_init_512[14], CF = C_init_512[15];
  sph_u32 M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, MA, MB, MC, MD, ME, MF;
  sph_u32 Wlow = 1, Whigh = 0;

  M0 = hash->h4[0];
  M1 = hash->h4[1];
  M2 = hash->h4[2];
  M3 = hash->h4[3];
  M4 = hash->h4[4];
  M5 = hash->h4[5];
  M6 = hash->h4[6];
  M7 = hash->h4[7];
  M8 = hash->h4[8];
  M9 = hash->h4[9];
  MA = hash->h4[10];
  MB = hash->h4[11];
  MC = hash->h4[12];
  MD = hash->h4[13];
  ME = hash->h4[14];
  MF = hash->h4[15];

  INPUT_BLOCK_ADD;
  XOR_W;
  APPLY_P;
  INPUT_BLOCK_SUB;
  SWAP_BC;
  INCR_W;

  M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = M8 = M9 = MA = MB = MC = MD = ME = MF = 0;

  INPUT_BLOCK_ADD;
  XOR_W;
  APPLY_P;
  INPUT_BLOCK_SUB;
  SWAP_BC;
  INCR_W;

  M0 = 0x80;
  M1 = M2 = M3 = M4 = M5 = M6 = M7 = M8 = M9 = MA = MB = MC = MD = ME = MF = 0;

  INPUT_BLOCK_ADD;
  XOR_W;
  APPLY_P;

  for (unsigned i = 0; i < 3; i ++)
  {
    SWAP_BC;
    XOR_W;
    APPLY_P;
  }

  hash->h4[0] = B0;
  hash->h4[1] = B1;
  hash->h4[2] = B2;
  hash->h4[3] = B3;
  hash->h4[4] = B4;
  hash->h4[5] = B5;
  hash->h4[6] = B6;
  hash->h4[7] = B7;
  hash->h4[8] = B8;
  hash->h4[9] = B9;
  hash->h4[10] = BA;
  hash->h4[11] = BB;
  hash->h4[12] = BC;
  hash->h4[13] = BD;
  hash->h4[14] = BE;
  hash->h4[15] = BF;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void whirlpoolkernel(__global hash_t *hash, __local sph_u64 LT0[256], __local sph_u64 LT1[256], __local sph_u64 LT2[256], __local sph_u64 LT3[256],
                                            __local sph_u64 LT4[256], __local sph_u64 LT5[256], __local sph_u64 LT6[256], __local sph_u64 LT7[256])
{
  // whirlpool
  sph_u64 n0, n1, n2, n3, n4, n5, n6, n7;
  sph_u64 h0, h1, h2, h3, h4, h5, h6, h7;
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

  n0 ^= h0;
  n1 ^= h1;
  n2 ^= h2;
  n3 ^= h3;
  n4 ^= h4;
  n5 ^= h5;
  n6 ^= h6;
  n7 ^= h7;

  #pragma unroll 10
  for (unsigned r = 0; r < 10; r ++)
  {
    sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;

    ROUND_KSCHED(plain_T, h, tmp, plain_RC[r]);
    TRANSFER(h, tmp);
    ROUND_WENC(plain_T, n, h, tmp);
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

  n0 = n1 = n2 = n3 = n4 = n5 = n6 = n7 = 0;

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

#pragma unroll 10
  for (unsigned r = 0; r < 10; r++)
  {
    sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;

    ROUND_KSCHED(plain_T, h, tmp, plain_RC[r]);
    TRANSFER(h, tmp);
    ROUND_WENC(plain_T, n, h, tmp);
    TRANSFER(n, tmp);
  }

  state[0] = n0 ^ state[0];
  state[1] = n1 ^ state[1];
  state[2] = n2 ^ state[2];
  state[3] = n3 ^ state[3];
  state[4] = n4 ^ state[4];
  state[5] = n5 ^ state[5];
  state[6] = n6 ^ state[6];
  state[7] = n7 ^ state[7];

  n0 = 0x80;
  n1 = n2 = n3 = n4 = n5 = n6 = 0;
  n7 = 0x4000000000000;

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

  #pragma unroll 10
  for (unsigned r = 0; r < 10; r ++)
  {
    sph_u64 tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;

    ROUND_KSCHED(LT, h, tmp, plain_RC[r]);
    TRANSFER(h, tmp);
    ROUND_WENC(plain_T, n, h, tmp);
    TRANSFER(n, tmp);
  }

  state[0] ^= n0 ^ 0x80;
  state[1] ^= n1;
  state[2] ^= n2;
  state[3] ^= n3;
  state[4] ^= n4;
  state[5] ^= n5;
  state[6] ^= n6;
  state[7] ^= n7 ^ 0x4000000000000;

  for (unsigned i = 0; i < 8; i ++)
    hash->h8[i] = state[i];

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void sha512kernel(__global hash_t *hash)
{
  // sha512
  sph_u64 W[80];
  sph_u64 state[8];

  for (int i = 0; i < 8; i++)
    W[i] = SWAP8(hash->h8[i]);

  for (int i = 8; i < 16; i++)
    W[i] = 0;

  state[0] = SPH_C64(0x6A09E667F3BCC908);
  state[1] = SPH_C64(0xBB67AE8584CAA73B);
  state[2] = SPH_C64(0x3C6EF372FE94F82B);
  state[3] = SPH_C64(0xA54FF53A5F1D36F1);
  state[4] = SPH_C64(0x510E527FADE682D1);
  state[5] = SPH_C64(0x9B05688C2B3E6C1F);
  state[6] = SPH_C64(0x1F83D9ABFB41BD6B);
  state[7] = SPH_C64(0x5BE0CD19137E2179);

  SHA512Block(W, state);

  W[0] = 0x8000000000000000UL;
  W[1] = 0x0000000000000000UL;
  W[2] = 0x0000000000000000UL;
  W[3] = 0x0000000000000000UL;
  W[4] = 0x0000000000000000UL;
  W[5] = 0x0000000000000000UL;
  W[6] = 0x0000000000000000UL;
  W[7] = 0x0000000000000000UL;
  W[8] = 0x0000000000000000UL;
  W[9] = 0x0000000000000000UL;
  W[10] = 0x0000000000000000UL;
  W[11] = 0x0000000000000000UL;
  W[12] = 0x0000000000000000UL;
  W[13] = 0x0000000000000000UL;
  W[14] = 0x0000000000000000UL;
  W[15] = 0x0000000000000400UL;

  SHA512Block(W, state);

  for (int i = 0; i < 8; i++)
    hash->h8[i] = SWAP8(state[i]);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void havalkernel(__global hash_t *hash)
{
  // haval
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

  for (int i = 16; i < 32; i++)
    X_var[i] = 0;

#define A(x) X_var[x]
  CORE5(A);
#undef A

  X_var[0] = 0x00000001U;
  X_var[1] = 0x00000000U;
  X_var[2] = 0x00000000U;
  X_var[3] = 0x00000000U;
  X_var[4] = 0x00000000U;
  X_var[5] = 0x00000000U;
  X_var[6] = 0x00000000U;
  X_var[7] = 0x00000000U;
  X_var[8] = 0x00000000U;
  X_var[9] = 0x00000000U;
  X_var[10] = 0x00000000U;
  X_var[11] = 0x00000000U;
  X_var[12] = 0x00000000U;
  X_var[13] = 0x00000000U;
  X_var[14] = 0x00000000U;
  X_var[15] = 0x00000000U;
  X_var[16] = 0x00000000U;
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
  X_var[30] = 0x00000400U;
  X_var[31] = 0x00000000U;

#define A(x) X_var[x]
  CORE5(A);
#undef A

  hash->h4[0] = s0;
  hash->h4[1] = s1;
  hash->h4[2] = s2;
  hash->h4[3] = s3;
  hash->h4[4] = s4;
  hash->h4[5] = s5;
  hash->h4[6] = s6;
  hash->h4[7] = s7;
  hash->h8[4] = 0;
  hash->h8[5] = 0;
  hash->h8[6] = 0;
  hash->h8[7] = 0;

  barrier(CLK_GLOBAL_MEM_FENCE);
}

void blakekernel(__global hash_t *hash)
{
  // blake
  sph_u64 H0 = SPH_C64(0x6A09E667F3BCC908), H1 = SPH_C64(0xBB67AE8584CAA73B);
  sph_u64 H2 = SPH_C64(0x3C6EF372FE94F82B), H3 = SPH_C64(0xA54FF53A5F1D36F1);
  sph_u64 H4 = SPH_C64(0x510E527FADE682D1), H5 = SPH_C64(0x9B05688C2B3E6C1F);
  sph_u64 H6 = SPH_C64(0x1F83D9ABFB41BD6B), H7 = SPH_C64(0x5BE0CD19137E2179);
  sph_u64 S0 = 0, S1 = 0, S2 = 0, S3 = 0;
  sph_u64 T0 = 1024, T1 = 0;

  sph_u64 M0, M1, M2, M3, M4, M5, M6, M7;
  sph_u64 M8, M9, MA, MB, MC, MD, ME, MF;
  sph_u64 V0, V1, V2, V3, V4, V5, V6, V7;
  sph_u64 V8, V9, VA, VB, VC, VD, VE, VF;
  M0 = SWAP8(hash->h8[0]);
  M1 = SWAP8(hash->h8[1]);
  M2 = SWAP8(hash->h8[2]);
  M3 = SWAP8(hash->h8[3]);
  M4 = SWAP8(hash->h8[4]);
  M5 = SWAP8(hash->h8[5]);
  M6 = SWAP8(hash->h8[6]);
  M7 = SWAP8(hash->h8[7]);
  M8 = 0;
  M9 = 0;
  MA = 0;
  MB = 0;
  MC = 0;
  MD = 0;
  ME = 0;
  MF = 0;

  COMPRESS64;

  M0 = 0x8000000000000000;
  M1 = 0;
  M2 = 0;
  M3 = 0;
  M4 = 0;
  M5 = 0;
  M6 = 0;
  M7 = 0;
  M8 = 0;
  M9 = 0;
  MA = 0;
  MB = 0;
  MC = 0;
  MD = 1;
  ME = 0;
  MF = 0x400;

  T0 = 0;
  COMPRESS64;

  hash->h8[0] = H0;
  hash->h8[1] = H1;
  hash->h8[2] = H2;
  hash->h8[3] = H3;
  hash->h8[4] = H4;
  hash->h8[5] = H5;
  hash->h8[6] = H6;
  hash->h8[7] = H7;

  barrier(CLK_GLOBAL_MEM_FENCE);
}




__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global unsigned char* block, __global hash_t* hashes)
{
    uint gid = get_global_id(0);
    __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

    blake80kernel(block, gid, hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global hash_t* hashes)
{
 uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  bmwkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  groestlkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search3(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  skeinkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  jhkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  keccakkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search6(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  luffakernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search7(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  cubehashkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search8(__global hash_t* hashes)
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

  shavitekernel(hash, AES0, AES1, AES2, AES3);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search9(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  simdkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search10(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid - offset]);

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

  echokernel(hash, AES0, AES1, AES2, AES3);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search11(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  hamsikernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search12(__global hash_t* hashes)
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

  fuguekernel(hash, mixtab0, mixtab1, mixtab2, mixtab3);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search13(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  shabalkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search14(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  __local sph_u64 LT0[256], LT1[256], LT2[256], LT3[256], LT4[256], LT5[256], LT6[256], LT7[256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  for (int i = init; i < 256; i += step)
  {
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

  whirlpoolkernel(hash, LT0, LT1, LT2, LT3, LT4, LT5, LT6, LT7);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search15(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  sha512kernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search16(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  havalkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search17(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  blakekernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search18(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  bmwkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search19(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  groestlkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search20(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  skeinkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search21(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  jhkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search22(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  keccakkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search23(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  luffakernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search24(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  cubehashkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search25(__global hash_t* hashes)
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

  shavitekernel(hash, AES0, AES1, AES2, AES3);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search26(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  simdkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search27(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid - offset]);

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

  echokernel(hash, AES0, AES1, AES2, AES3);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search28(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  hamsikernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search29(__global hash_t* hashes)
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

  fuguekernel(hash, mixtab0, mixtab1, mixtab2, mixtab3);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search30(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  shabalkernel(hash);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search31(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  __local sph_u64 LT0[256], LT1[256], LT2[256], LT3[256], LT4[256], LT5[256], LT6[256], LT7[256];

  int init = get_local_id(0);
  int step = get_local_size(0);

  for (int i = init; i < 256; i += step)
  {
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

  whirlpoolkernel(hash, LT0, LT1, LT2, LT3, LT4, LT5, LT6, LT7);
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search32(__global hash_t* hashes)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  sha512kernel(hash);
}

// 1->1, haval
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search33(__global hash_t* hashes, __global uint* output, const ulong target)
{
  uint gid = get_global_id(0);
  uint offset = get_global_offset(0);
  __global hash_t *hash = &(hashes[gid-offset]);

  // nemswappolt bemenet(1)
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

  for (int i = 16; i < 32; i++)
    X_var[i] = 0;

#define A(x) X_var[x]
  CORE5(A);
#undef A

  X_var[0] = 0x00000001U;
  X_var[1] = 0x00000000U;
  X_var[2] = 0x00000000U;
  X_var[3] = 0x00000000U;
  X_var[4] = 0x00000000U;
  X_var[5] = 0x00000000U;
  X_var[6] = 0x00000000U;
  X_var[7] = 0x00000000U;
  X_var[8] = 0x00000000U;
  X_var[9] = 0x00000000U;
  X_var[10] = 0x00000000U;
  X_var[11] = 0x00000000U;
  X_var[12] = 0x00000000U;
  X_var[13] = 0x00000000U;
  X_var[14] = 0x00000000U;
  X_var[15] = 0x00000000U;
  X_var[16] = 0x00000000U;
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
  X_var[30] = 0x00000400U;
  X_var[31] = 0x00000000U;

#define A(x) X_var[x]
  CORE5(A);
#undef A

  bool result = (s7 <= (target >> 32));

  if (result)
    output[atomic_inc(output+0xFF)] = SWAP4(gid);

  barrier(CLK_GLOBAL_MEM_FENCE);
}

#endif // XEVAN_CL
