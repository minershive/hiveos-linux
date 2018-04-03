#ifndef X11EVO_CL
#define X11EVO_CL

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
#define SPH_T32(x)    ((x) & SPH_C32(0xFFFFFFFF))
#define SPH_ROTL32(x, n)   SPH_T32(((x) << (n)) | ((x) >> (32 - (n))))
#define SPH_ROTR32(x, n)   SPH_ROTL32(x, (32 - (n)))

#define SPH_C64(x)    ((sph_u64)(x ## UL))
#define SPH_T64(x)    ((x) & SPH_C64(0xFFFFFFFFFFFFFFFF))
#define SPH_ROTL64(x, n)   SPH_T64(((x) << (n)) | ((x) >> (64 - (n))))
#define SPH_ROTR64(x, n)   SPH_ROTL64(x, (64 - (n)))

#define SPH_ECHO_64 1
#define SPH_KECCAK_64 1
#define SPH_JH_64 1
#define SPH_SIMD_NOCOPY 0
#define SPH_KECCAK_NOCOPY 0
#define SPH_SMALL_FOOTPRINT_GROESTL 0
#define SPH_GROESTL_BIG_ENDIAN 0
#define SPH_CUBEHASH_UNROLL 0
#define SPH_COMPACT_BLAKE_64 0
#define SPH_LUFFA_PARALLEL 0
#define SPH_KECCAK_UNROLL   0

#define SWAP_RESULT   do { \
	hash.h8[0] = SWAP8(hash.h8[0]); \
	hash.h8[1] = SWAP8(hash.h8[1]); \
	hash.h8[2] = SWAP8(hash.h8[2]); \
	hash.h8[3] = SWAP8(hash.h8[3]); \
	hash.h8[4] = SWAP8(hash.h8[4]); \
	hash.h8[5] = SWAP8(hash.h8[5]); \
	hash.h8[6] = SWAP8(hash.h8[6]); \
	hash.h8[7] = SWAP8(hash.h8[7]); \
	} while (0)


#include "blake.cl"
#include "bmw.cl"
#include "groestl.cl"
#include "jh.cl"
#include "keccak.cl"
#include "skein.cl"
#include "luffa.cl"
#include "cubehash.cl"
#include "shavite.cl"
#include "simd.cl"
#include "echo.cl"
#include "fugue.cl"
#include "hamsi.cl"
#include "shabal.cl"
#include "whirlpool.cl"
#include "wolf-sha512.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
	#define DEC32BE(x) (*(const __global sph_u32 *) (x))
	#define DEC64E(x) (x)
	#define DEC64BE(x) (*(const __global sph_u64 *) (x))
#else
  #define DEC32BE(x) SWAP4(*(const __global sph_u32 *) (x))
	#define DEC64E(x) SWAP8(x)
	#define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x))
#endif

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global unsigned char* block, volatile __global uint* output, const ulong target)
{
	uint gid = get_global_id(0);
	union {
		unsigned char h1[64];
		uint h4[16];
		ulong h8[8];
	} hash;

	__local sph_u32 AES0[256], AES1[256], AES2[256], AES3[256];
	__local sph_u32 mixtab0[256], mixtab1[256], mixtab2[256], mixtab3[256];
	int init = get_local_id(0);
	int step = get_local_size(0);
	for (int i = init; i < 256; i += step)
	{
		AES0[i] = AES0_C[i];
		AES1[i] = AES1_C[i];
		AES2[i] = AES2_C[i];
		AES3[i] = AES3_C[i];
		mixtab0[i] = mixtab0_c[i];
		mixtab1[i] = mixtab1_c[i];
		mixtab2[i] = mixtab2_c[i];
		mixtab3[i] = mixtab3_c[i];
	}
	barrier(CLK_LOCAL_MEM_FENCE);
