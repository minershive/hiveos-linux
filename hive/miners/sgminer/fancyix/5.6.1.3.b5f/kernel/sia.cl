
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

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC32LE(x) SWAP4(*(const __global sph_u32 *) (x));
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC64LE(x) (*(const __global sph_u64 *) (x));
  #define DEC32LE(x) (*(const __global sph_u32 *) (x));
#endif

inline static uint2 ror64(const uint2 x, const uint y)
{
    return (uint2)(((x).x>>y)^((x).y<<(32-y)),((x).y>>y)^((x).x<<(32-y)));
}
inline static uint2 ror64_2(const uint2 x, const uint y)
{
    return (uint2)(((x).y>>(y-32))^((x).x<<(64-y)),((x).x>>(y-32))^((x).y<<(64-y)));
}
__constant static const uchar blake2b_sigma[12][16] = {
	{ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15 } ,
	{ 14, 10, 4,  8,  9,  15, 13, 6,  1,  12, 0,  2,  11, 7,  5,  3  } ,
	{ 11, 8,  12, 0,  5,  2,  15, 13, 10, 14, 3,  6,  7,  1,  9,  4  } ,
	{ 7,  9,  3,  1,  13, 12, 11, 14, 2,  6,  5,  10, 4,  0,  15, 8  } ,
	{ 9,  0,  5,  7,  2,  4,  10, 15, 14, 1,  11, 12, 6,  8,  3,  13 } ,
	{ 2,  12, 6,  10, 0,  11, 8,  3,  4,  13, 7,  5,  15, 14, 1,  9  } ,
	{ 12, 5,  1,  15, 14, 13, 4,  10, 0,  7,  6,  3,  9,  2,  8,  11 } ,
	{ 13, 11, 7,  14, 12, 1,  3,  9,  5,  0,  15, 4,  8,  6,  2,  10 } ,
	{ 6,  15, 14, 9,  11, 3,  0,  8,  12, 2,  13, 7,  1,  4,  10, 5  } ,
	{ 10, 2,  8,  4,  7,  6,  1,  5,  15, 11, 9,  14, 3,  12, 13, 0  } ,
	{ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15 } ,
	{ 14, 10, 4,  8,  9,  15, 13, 6,  1,  12, 0,  2,  11, 7,  5,  3  } };

__kernel void search(__global unsigned char* block, volatile __global uint* output, const ulong target) {
	sph_u32 gid = get_global_id(0);

	ulong m[16];
	m[0] = DEC64LE(block + 0);
	m[1] = DEC64LE(block + 8);
	m[2] = DEC64LE(block + 16);
	m[3] = DEC64LE(block + 24);
	m[4] = DEC64LE(block + 32);
	m[4] &= 0xFFFFFFFF00000000;
	m[4] ^= (gid);
	m[5] = DEC64LE(block + 40);
	m[6] = DEC64LE(block + 48);
	m[7] = DEC64LE(block + 56);
	m[8] = DEC64LE(block + 64);
	m[9] = DEC64LE(block + 72);
	m[10] = m[11] = m[12] = m[13] = m[14] = m[15] = 0;

	ulong v[16] = { 0x6a09e667f2bdc928, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1,
	                0x510e527fade682d1, 0x9b05688c2b3e6c1f, 0x1f83d9abfb41bd6b, 0x5be0cd19137e2179,
	                0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1,
	                0x510e527fade68281, 0x9b05688c2b3e6c1f, 0xe07c265404be4294, 0x5be0cd19137e2179 };

#define G(r,i,a,b,c,d) \
	a = a + b + m[ blake2b_sigma[r][2*i] ]; \
	((uint2*)&d)[0] = ((uint2*)&d)[0].yx ^ ((uint2*)&a)[0].yx; \
	c = c + d; \
	((uint2*)&b)[0] = ror64( ((uint2*)&b)[0] ^ ((uint2*)&c)[0], 24U); \
	a = a + b + m[ blake2b_sigma[r][2*i+1] ]; \
	((uint2*)&d)[0] = ror64( ((uint2*)&d)[0] ^ ((uint2*)&a)[0], 16U); \
	c = c + d; \
    ((uint2*)&b)[0] = ror64_2( ((uint2*)&b)[0] ^ ((uint2*)&c)[0], 63U);

#define ROUND(r)                    \
	G(r,0,v[ 0],v[ 4],v[ 8],v[12]); \
	G(r,1,v[ 1],v[ 5],v[ 9],v[13]); \
	G(r,2,v[ 2],v[ 6],v[10],v[14]); \
	G(r,3,v[ 3],v[ 7],v[11],v[15]); \
	G(r,4,v[ 0],v[ 5],v[10],v[15]); \
	G(r,5,v[ 1],v[ 6],v[11],v[12]); \
	G(r,6,v[ 2],v[ 7],v[ 8],v[13]); \
	G(r,7,v[ 3],v[ 4],v[ 9],v[14]);
	ROUND( 0 );
	ROUND( 1 );
	ROUND( 2 );
	ROUND( 3 );
	ROUND( 4 );
	ROUND( 5 );
	ROUND( 6 );
	ROUND( 7 );
	ROUND( 8 );
	ROUND( 9 );
	ROUND( 10 );
	ROUND( 11 );

#undef G
#undef ROUND

	bool result = (SWAP8(0x6a09e667f2bdc928 ^ v[0] ^ v[8]) <= target);
	if (result)
		output[output[0xFF]++] = SWAP4(gid);
}
