#define MAX_OUTPUTS 0xFFu
#define barrier(x) mem_fence(x)
#define PLATFORM 2

#define OPENCL_PLATFORM_UNKNOWN 0
#define OPENCL_PLATFORM_NVIDIA  1
#define OPENCL_PLATFORM_AMD		2

#define ACCESSES 64
#define THREADS_PER_HASH (128 / 16)
#define HASHES_PER_LOOP (WORKSIZE / THREADS_PER_HASH)

#define FNV_PRIME	0x01000193

__constant uint2 const Keccak_f1600_RC[24] = {
	(uint2)(0x00000001, 0x00000000),
	(uint2)(0x00008082, 0x00000000),
	(uint2)(0x0000808a, 0x80000000),
	(uint2)(0x80008000, 0x80000000),
	(uint2)(0x0000808b, 0x00000000),
	(uint2)(0x80000001, 0x00000000),
	(uint2)(0x80008081, 0x80000000),
	(uint2)(0x00008009, 0x80000000),
	(uint2)(0x0000008a, 0x00000000),
	(uint2)(0x00000088, 0x00000000),
	(uint2)(0x80008009, 0x00000000),
	(uint2)(0x8000000a, 0x00000000),
	(uint2)(0x8000808b, 0x00000000),
	(uint2)(0x0000008b, 0x80000000),
	(uint2)(0x00008089, 0x80000000),
	(uint2)(0x00008003, 0x80000000),
	(uint2)(0x00008002, 0x80000000),
	(uint2)(0x00000080, 0x80000000),
	(uint2)(0x0000800a, 0x00000000),
	(uint2)(0x8000000a, 0x80000000),
	(uint2)(0x80008081, 0x80000000),
	(uint2)(0x00008080, 0x80000000),
	(uint2)(0x80000001, 0x00000000),
	(uint2)(0x80008008, 0x80000000),
};

#if PLATFORM == OPENCL_PLATFORM_NVIDIA && COMPUTE >= 35
static inline uint2 ROL2(const uint2 a, const int offset) {
	uint2 result;
	if (offset >= 32) {
		asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.x) : "r"(a.x), "r"(a.y), "r"(offset));
		asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.y) : "r"(a.y), "r"(a.x), "r"(offset));
	}
	else {
		asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.x) : "r"(a.y), "r"(a.x), "r"(offset));
		asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.y) : "r"(a.x), "r"(a.y), "r"(offset));
	}
	return result;
}
#elif PLATFORM == OPENCL_PLATFORM_AMD

#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

static inline uint2 ROL2(const uint2 vv, const int r)
{
	if (r <= 32)
	{
		return amd_bitalign((vv).xy, (vv).yx, 32 - r);
	}
	else
	{
		return amd_bitalign((vv).yx, (vv).xy, 64 - r);
	}
}
#else
static inline uint2 ROL2(const uint2 v, const int n)
{
	uint2 result;
	if (n <= 32)
	{
		result.y = ((v.y << (n)) | (v.x >> (32 - n)));
		result.x = ((v.x << (n)) | (v.y >> (32 - n)));
	}
	else
	{
		result.y = ((v.x << (n - 32)) | (v.y >> (64 - n)));
		result.x = ((v.y << (n - 32)) | (v.x >> (64 - n)));
	}
	return result;
}
#endif

#define chi(a, n, t) \
do { \
	(a)[(n)+0] = bitselect((t)[(n) + 0] ^ (t)[(n) + 2], (t)[(n) + 0], (t)[(n) + 1]); \
	(a)[(n)+1] = bitselect((t)[(n) + 1] ^ (t)[(n) + 3], (t)[(n) + 1], (t)[(n) + 2]); \
	(a)[(n)+2] = bitselect((t)[(n) + 2] ^ (t)[(n) + 4], (t)[(n) + 2], (t)[(n) + 3]); \
	(a)[(n)+3] = bitselect((t)[(n) + 3] ^ (t)[(n) + 0], (t)[(n) + 3], (t)[(n) + 4]); \
	(a)[(n)+4] = bitselect((t)[(n) + 4] ^ (t)[(n) + 1], (t)[(n) + 4], (t)[(n) + 0]); \
} while (0);

#define keccak_f1600_round(a, r) \
do { \
	uint2 t[25]; \
	uint2 u; \
 \
	t[0] = (a)[0] ^ (a)[5] ^ (a)[10] ^ (a)[15] ^ (a)[20]; \
	t[1] = (a)[1] ^ (a)[6] ^ (a)[11] ^ (a)[16] ^ (a)[21]; \
	t[2] = (a)[2] ^ (a)[7] ^ (a)[12] ^ (a)[17] ^ (a)[22]; \
	t[3] = (a)[3] ^ (a)[8] ^ (a)[13] ^ (a)[18] ^ (a)[23]; \
	t[4] = (a)[4] ^ (a)[9] ^ (a)[14] ^ (a)[19] ^ (a)[24]; \
	u = t[4] ^ ROL2(t[1], 1); \
	(a)[0] ^= u; \
	(a)[5] ^= u; \
	(a)[10] ^= u; \
	(a)[15] ^= u; \
	(a)[20] ^= u; \
	u = t[0] ^ ROL2(t[2], 1); \
	(a)[1] ^= u; \
	(a)[6] ^= u; \
	(a)[11] ^= u; \
	(a)[16] ^= u; \
	(a)[21] ^= u; \
	u = t[1] ^ ROL2(t[3], 1); \
	(a)[2] ^= u; \
	(a)[7] ^= u; \
	(a)[12] ^= u; \
	(a)[17] ^= u; \
	(a)[22] ^= u; \
	u = t[2] ^ ROL2(t[4], 1); \
	(a)[3] ^= u; \
	(a)[8] ^= u; \
	(a)[13] ^= u; \
	(a)[18] ^= u; \
	(a)[23] ^= u; \
	u = t[3] ^ ROL2(t[0], 1); \
	(a)[4] ^= u; \
	(a)[9] ^= u; \
	(a)[14] ^= u; \
	(a)[19] ^= u; \
	(a)[24] ^= u; \
 \
	t[0]  = (a)[0]; \
	t[10] = ROL2((a)[1], 1); \
	t[20] = ROL2((a)[2], 62); \
	t[5]  = ROL2((a)[3], 28); \
	t[15] = ROL2((a)[4], 27); \
	 \
	t[16] = ROL2((a)[5], 36); \
	t[1]  = ROL2((a)[6], 44); \
	t[11] = ROL2((a)[7], 6); \
	t[21] = ROL2((a)[8], 55); \
	t[6]  = ROL2((a)[9], 20); \
	 \
	t[7]  = ROL2((a)[10], 3); \
	t[17] = ROL2((a)[11], 10); \
	t[2]  = ROL2((a)[12], 43); \
	t[12] = ROL2((a)[13], 25); \
	t[22] = ROL2((a)[14], 39); \
	 \
	t[23] = ROL2((a)[15], 41); \
	t[8]  = ROL2((a)[16], 45); \
	t[18] = ROL2((a)[17], 15); \
	t[3]  = ROL2((a)[18], 21); \
	t[13] = ROL2((a)[19], 8); \
	 \
	t[14] = ROL2((a)[20], 18); \
	t[24] = ROL2((a)[21], 2); \
	t[9]  = ROL2((a)[22], 61); \
	t[19] = ROL2((a)[23], 56); \
	t[4]  = ROL2((a)[24], 14); \
	chi((a), 0, t); \
 \
	(a)[0] ^= Keccak_f1600_RC[(r)]; \
 \
	chi((a), 5, t); \
	chi((a), 10, t); \
	chi((a), 15, t); \
	chi((a), 20, t); \
} while (0);


#define PRAGMA(X) _Pragma(#X)
#define PRAGMA_UNROLL PRAGMA(unroll)
#define PRAGMA_NOUNROLL PRAGMA(nounroll)

#define keccak_f1600_no_absorb(a, out_size, isolate) \
do { \
PRAGMA_NOUNROLL \
	for (uint r = 0; r < 24; r++) \
	{ \
		keccak_f1600_round((a), r); \
	}  \
} while (0);

#define copy(dst, src, count) for (uint i = 0; i != count; ++i) { (dst)[i] = (src)[i]; }

#define fnv(x, y) ((x) * FNV_PRIME ^ (y))

#define fnv4(x, y) ((x) * FNV_PRIME ^ (y))

#define fnv_reduce(v) (fnv(fnv(fnv((v).x, (v).y), (v).z), (v).w))

typedef struct
{
	ulong ulongs[32 / sizeof(ulong)];
} hash32_t;

typedef struct
{
	uint4 uint4s[128 / sizeof(uint4)];
} hash128_t;

typedef union {
	uint4 uint4s[4];
	ulong ulongs[8];
	uint  uints[16];
} compute_hash_share;

#define ETH_SHFL_0(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_1(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_2(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_3(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_4(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_5(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_6(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_7(d, s)  \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "v" (s)); \
	}

#define ETH_SHFL_E0(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E1(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E2(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E3(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E4(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E5(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E6(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_E7(shuffle, state) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d1x], %[s1x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d1y], %[s1y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d2x], %[s2x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d2y], %[s2y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d3x], %[s3x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d3y], %[s3y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d4x], %[s4x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d4y], %[s4y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d5x], %[s5x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d5y], %[s5y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d6x], %[s6x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d6y], %[s6y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d7x], %[s7x] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "v_mov_b32_dpp  %[d7y], %[s7y] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y), \
            [d4x] "=&v" (shuffle[4].x), \
            [d4y] "=&v" (shuffle[4].y), \
            [d5x] "=&v" (shuffle[5].x), \
            [d5y] "=&v" (shuffle[5].y), \
            [d6x] "=&v" (shuffle[6].x), \
            [d6y] "=&v" (shuffle[6].y), \
            [d7x] "=&v" (shuffle[7].x), \
            [d7y] "=&v" (shuffle[7].y) \
		  : [s0x] "v" (as_uint2(state[0]).x), \
            [s0y] "v" (as_uint2(state[0]).y), \
            [s1x] "v" (as_uint2(state[1]).x), \
            [s1y] "v" (as_uint2(state[1]).y), \
            [s2x] "v" (as_uint2(state[2]).x), \
            [s2y] "v" (as_uint2(state[2]).y), \
            [s3x] "v" (as_uint2(state[3]).x), \
            [s3y] "v" (as_uint2(state[3]).y), \
            [s4x] "v" (as_uint2(state[4]).x), \
            [s4y] "v" (as_uint2(state[4]).y), \
            [s5x] "v" (as_uint2(state[5]).x), \
            [s5y] "v" (as_uint2(state[5]).y), \
            [s6x] "v" (as_uint2(state[6]).x), \
            [s6y] "v" (as_uint2(state[6]).y), \
            [s7x] "v" (as_uint2(state[7]).x), \
            [s7y] "v" (as_uint2(state[7]).y)); \
	}

#define ETH_SHFL_F(shuffle, thread_mix) \
    { \
		__asm ( \
		  "s_nop 1\n" \
		  "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0x], %[s0] dpp8:[0,0,0,0,0,0,0,0]\n" \
          "v_mov_b32_dpp  %[d0y], %[s0] dpp8:[1,1,1,1,1,1,1,1]\n" \
          "v_mov_b32_dpp  %[d1x], %[s0] dpp8:[2,2,2,2,2,2,2,2]\n" \
          "v_mov_b32_dpp  %[d1y], %[s0] dpp8:[3,3,3,3,3,3,3,3]\n" \
          "v_mov_b32_dpp  %[d2x], %[s0] dpp8:[4,4,4,4,4,4,4,4]\n" \
          "v_mov_b32_dpp  %[d2y], %[s0] dpp8:[5,5,5,5,5,5,5,5]\n" \
          "v_mov_b32_dpp  %[d3x], %[s0] dpp8:[6,6,6,6,6,6,6,6]\n" \
          "v_mov_b32_dpp  %[d3y], %[s0] dpp8:[7,7,7,7,7,7,7,7]\n" \
          "s_nop 1\n" \
		  "s_nop 1\n" \
		  : [d0x] "=&v" (shuffle[0].x), \
            [d0y] "=&v" (shuffle[0].y), \
            [d1x] "=&v" (shuffle[1].x), \
            [d1y] "=&v" (shuffle[1].y), \
            [d2x] "=&v" (shuffle[2].x), \
            [d2y] "=&v" (shuffle[2].y), \
            [d3x] "=&v" (shuffle[3].x), \
            [d3y] "=&v" (shuffle[3].y) \
		  : [s0] "v" (thread_mix)); \
	}

#if PLATFORM != OPENCL_PLATFORM_NVIDIA // use maxrregs on nv
__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
#endif
__kernel void search(
	__global uint* g_output,
	__global uint* g_header,
	__global uint* g_dag,
	ulong DAG_SIZE,
	ulong start_nonce,
	ulong target
	)
{
	uint gid = get_global_id(0) - get_global_offset(0);

	// Compute one init hash per work item.

	// sha3_512(header .. nonce)
	ulong state[25];
	#pragma unroll
	for (int i = 0; i < 4; i++) {
		state[i] = ((__global hash32_t*) g_header)->ulongs[i];
	}
	state[4] = start_nonce + gid;

#pragma unroll
	for (uint i = 6; i < 25; ++i)
	{
		state[i] = 0;
	}
	state[5] = 0x0000000000000001;
	state[8] = 0x8000000000000000;

	keccak_f1600_no_absorb((uint2*)state, 8, DAG_SIZE);
	
	// Threads work together in this phase in groups of 8.
	uint thread_id = gid % 8;
    uint mix_idx = thread_id % 4;

#pragma nounroll
	for (int i = 0; i < THREADS_PER_HASH; i++)
	{
        uint init0;
        uint offset;
        uint4 mix;

		// share init with other threads
        uint2 shuffle[8];
        if (i == 0) ETH_SHFL_E0(shuffle, state);
		if (i == 1) ETH_SHFL_E1(shuffle, state);
		if (i == 2) ETH_SHFL_E2(shuffle, state);
		if (i == 3) ETH_SHFL_E3(shuffle, state);
		if (i == 4) ETH_SHFL_E4(shuffle, state);
		if (i == 5) ETH_SHFL_E5(shuffle, state);
		if (i == 6) ETH_SHFL_E6(shuffle, state);
		if (i == 7) ETH_SHFL_E7(shuffle, state);
        if (mix_idx == 0)
            mix = (uint4) (shuffle[0].x, shuffle[0].y, shuffle[1].x, shuffle[1].y);
        if (mix_idx == 1)
            mix = (uint4) (shuffle[2].x, shuffle[2].y, shuffle[3].x, shuffle[3].y);
        if (mix_idx == 2)
            mix = (uint4) (shuffle[4].x, shuffle[4].y, shuffle[5].x, shuffle[5].y);
        if (mix_idx == 3)
            mix = (uint4) (shuffle[6].x, shuffle[6].y, shuffle[7].x, shuffle[7].y);

        ETH_SHFL_0(init0, shuffle[0].x);

#pragma unroll
		for (uint a = 0; a < ACCESSES; a += 4)
		{
			uint t = ((a >> 2) % (THREADS_PER_HASH));

#pragma unroll
			for (uint b = 0; b < 4; ++b)
			{
				uint x = init0 ^ (a + b);
				uint y = ((uint *)&mix)[b];
                offset = fnv(x, y) % (as_uint2(DAG_SIZE).x);
				if (t == 0) ETH_SHFL_0(offset, offset);
                if (t == 1) ETH_SHFL_1(offset, offset);
				if (t == 2) ETH_SHFL_2(offset, offset);
				if (t == 3) ETH_SHFL_3(offset, offset);
				if (t == 4) ETH_SHFL_4(offset, offset);
				if (t == 5) ETH_SHFL_5(offset, offset);
				if (t == 6) ETH_SHFL_6(offset, offset);
				if (t == 7) ETH_SHFL_7(offset, offset);
				uint4 z = ((__global hash128_t*) g_dag)[offset].uint4s[thread_id];
                mix = fnv4(mix, z);
			}
		}

        uint thread_mix = fnv_reduce(mix);
        ETH_SHFL_F(shuffle, thread_mix);

		if ((i == 0 && thread_id == 0) || 
		    (i == 1 && thread_id == 1) ||
			(i == 2 && thread_id == 2) ||
			(i == 3 && thread_id == 3) ||
			(i == 4 && thread_id == 4) ||
			(i == 5 && thread_id == 5) ||
			(i == 6 && thread_id == 6) ||
			(i == 7 && thread_id == 7))
        {
            // move mix into state:
            state[8] = as_ulong(shuffle[0]);
            state[9] = as_ulong(shuffle[1]);
            state[10] = as_ulong(shuffle[2]);
            state[11] = as_ulong(shuffle[3]);
        }
	}

#pragma unroll
	for (uint i = 13; i < 25; ++i)
	{
		state[i] = 0;
	}
	state[12] = 0x0000000000000001;
	state[16] = 0x8000000000000000;

	// keccak_256(keccak_512(header..nonce) .. mix);
	keccak_f1600_no_absorb((uint2*)state, 1, DAG_SIZE);

	if (as_ulong(as_uchar8(state[0]).s76543210) < target)
	{
		uint slot = min(MAX_OUTPUTS-1u, (g_output[MAX_OUTPUTS]));
		g_output[MAX_OUTPUTS]++;
		g_output[slot] = gid;
	}
}




typedef union _Node
{
	uint dwords[16];
	uint2 qwords[8];
	uint4 dqwords[4];
} Node;

static void SHA3_512(uint2 *s, uint isolate)
{
	uint2 st[25];
	
	for (uint i = 0; i < 8; ++i)
		st[i] = s[i];
	
	for (uint i = 8; i != 25; ++i)
    	st[i] = (uint2){ 0, 0 };
	
	((uint2 *)st)[8].x = 0x00000001;
	((uint2 *)st)[8].y = 0x80000000;
	keccak_f1600_no_absorb(st, 8, isolate);
	
	for (uint i = 0; i < 8; ++i)
		s[i] = st[i];
}

__kernel void GenerateDAG(uint start, __global const uint16 *_Cache, __global uint16 *_DAG, uint LIGHT_SIZE, uint isolate)
{
    __global const Node *Cache = (__global const Node *) _Cache;
    __global Node *DAG = (__global Node *) _DAG;
	uint NodeIdx = start + get_global_id(0);
	//if  (NodeIdx > DAG_SIZE) return;
	
	Node DAGNode = Cache[NodeIdx % LIGHT_SIZE];
	
	DAGNode.dwords[0] ^= NodeIdx;
	SHA3_512(DAGNode.qwords, isolate);

	for (uint i = 0; i < 256; ++i)
	{
		uint ParentIdx = fnv(NodeIdx ^ i, DAGNode.dwords[i & 15]) % LIGHT_SIZE;
		__global const Node *ParentNode = Cache + ParentIdx;
		
		#pragma unroll
		for (uint x = 0; x < 4; ++x)
		{
			DAGNode.dqwords[x] *= (uint4)(FNV_PRIME);
			DAGNode.dqwords[x] ^= ParentNode->dqwords[x];
		}
	}
	
	SHA3_512(DAGNode.qwords, isolate);
	DAG[NodeIdx] = DAGNode;
}

