/**
 * BLAKE256 14-round kernel
 *
 * Copyright 2015 Company Zero
 * A complete kernel re-write
 * with inspiration from the Golang BLAKE256 repo (github.com/dchest/blake256)
 */

/**
 * optimized by tpruvot 02/2016 :
 *
 * GTX 960 | (5s):735.3M (avg):789.3Mh/s
 * GTX 750 | (5s):443.3M (avg):476.8Mh/s
 * to
 * GTX 960 | (5s):875.0M (avg):899.2Mh/s
 * GTX 750 | (5s):523.1M (avg):536.8Mh/s
 */
#define ROTR(v,n) rotate(v,(uint)(32U-n))
#define ROTL(v,n) rotate(v, n)

#ifdef _AMD_OPENCL
#define SWAP(v)   rotate(v, 16U)
#define ROTR8(v)  rotate(v, 24U)
#else
#define SWAP(v)  as_uint(as_uchar4(v).zwxy)
#define ROTR8(v) as_uint(as_uchar4(v).yzwx)
#endif

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(
	volatile __global uint * restrict output,
	// Midstate
	const uint h0,
	const uint h1,
	const uint h2,
	const uint h3,
	const uint h4,
	const uint h5,
	const uint h6,
	const uint h7,

	// last 52 bytes of data
	const uint M0,
	const uint M1,
	const uint M2,
	// const uint M3 : nonce
	const uint M4,
	const uint M5,
	const uint M6,
	const uint M7,
	const uint M8,
	const uint M9,
	const uint MA,
	const uint MB,
	const uint MC
)
{
	/* Load the block header and padding */
	const uint M3 = get_global_id(0);
	const uint MD = 0x80000001UL;
	const uint ME = 0x00000000UL;
	const uint MF = 0x000005a0UL;

	const uint cst0 = 0x243F6A88UL;
	const uint cst1 = 0x85A308D3UL;
	const uint cst2 = 0x13198A2EUL;
	const uint cst3 = 0x03707344UL;
	const uint cst4 = 0xA4093822UL;
	const uint cst5 = 0x299F31D0UL;
	const uint cst6 = 0x082EFA98UL;
	const uint cst7 = 0xEC4E6C89UL;
	const uint cst8 = 0x452821E6UL;
	const uint cst9 = 0x38D01377UL;
	const uint cstA = 0xBE5466CFUL;
	const uint cstB = 0x34E90C6CUL;
	const uint cstC = 0xC0AC29B7UL;
	const uint cstD = 0xC97C50DDUL;
	const uint cstE = 0x3F84D5B5UL;
	const uint cstF = 0xB5470917UL;

	uint V0, V1, V2, V3, V4, V5, V6, V7;
	uint V8, V9, VA, VB, VC, VD, VE, VF;
	uint pre7;

	/* Load the midstate and initialize */
	V0 = h0;
	V1 = h1;
	V2 = h2;
	V3 = h3;
	V4 = h4;
	V5 = h5;
	V6 = h6;
	pre7 = V7 = h7;

	V8 = cst0;
	V9 = cst1;
	VA = cst2;
	VB = cst3;
	VC = 0xA4093D82UL;
	VD = 0x299F3470UL;
	VE = cst6;
	VF = cst7;

	/* 14 rounds */

	V0 = V0 + (M0 ^ cst1); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M2 ^ cst3); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M4 ^ cst5); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M6 ^ cst7); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M5 ^ cst4); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M7 ^ cst6); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M3 ^ cst2); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M1 ^ cst0); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M8 ^ cst9); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (MA ^ cstB); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (MC ^ cstD); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (ME ^ cstF); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (MD ^ cstC); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (MF ^ cstE); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (MB ^ cstA); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M9 ^ cst8); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (ME ^ cstA); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M4 ^ cst8); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M9 ^ cstF); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MD ^ cst6); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (MF ^ cst9); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M6 ^ cstD); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M8 ^ cst4); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (MA ^ cstE); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M1 ^ cstC); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M0 ^ cst2); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (MB ^ cst7); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M5 ^ cst3); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M7 ^ cstB); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M3 ^ cst5); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M2 ^ cst0); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (MC ^ cst1); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (MB ^ cst8); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (MC ^ cst0); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M5 ^ cst2); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MF ^ cstD); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M2 ^ cst5); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (MD ^ cstF); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M0 ^ cstC); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M8 ^ cstB); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (MA ^ cstE); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M3 ^ cst6); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M7 ^ cst1); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M9 ^ cst4); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M1 ^ cst7); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M4 ^ cst9); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M6 ^ cst3); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (ME ^ cstA); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (M7 ^ cst9); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M3 ^ cst1); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (MD ^ cstC); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MB ^ cstE); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (MC ^ cstD); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (ME ^ cstB); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M1 ^ cst3); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M9 ^ cst7); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M2 ^ cst6); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M5 ^ cstA); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M4 ^ cst0); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (MF ^ cst8); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M0 ^ cst4); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M8 ^ cstF); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (MA ^ cst5); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M6 ^ cst2); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (M9 ^ cst0); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M5 ^ cst7); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M2 ^ cst4); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MA ^ cstF); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M4 ^ cst2); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (MF ^ cstA); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M7 ^ cst5); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M0 ^ cst9); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (ME ^ cst1); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (MB ^ cstC); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M6 ^ cst8); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M3 ^ cstD); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M8 ^ cst6); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (MD ^ cst3); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (MC ^ cstB); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M1 ^ cstE); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (M2 ^ cstC); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M6 ^ cstA); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M0 ^ cstB); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M8 ^ cst3); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (MB ^ cst0); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M3 ^ cst8); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (MA ^ cst6); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (MC ^ cst2); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M4 ^ cstD); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M7 ^ cst5); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (MF ^ cstE); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M1 ^ cst9); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (ME ^ cstF); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M9 ^ cst1); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M5 ^ cst7); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (MD ^ cst4); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (MC ^ cst5); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M1 ^ cstF); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (ME ^ cstD); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M4 ^ cstA); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (MD ^ cstE); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (MA ^ cst4); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (MF ^ cst1); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M5 ^ cstC); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M0 ^ cst7); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M6 ^ cst3); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M9 ^ cst2); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M8 ^ cstB); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M2 ^ cst9); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (MB ^ cst8); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M3 ^ cst6); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M7 ^ cst0); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (MD ^ cstB); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M7 ^ cstE); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (MC ^ cst1); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M3 ^ cst9); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M1 ^ cstC); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M9 ^ cst3); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (ME ^ cst7); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (MB ^ cstD); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M5 ^ cst0); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (MF ^ cst4); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M8 ^ cst6); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M2 ^ cstA); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M6 ^ cst8); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (MA ^ cst2); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M4 ^ cstF); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M0 ^ cst5); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (M6 ^ cstF); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (ME ^ cst9); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (MB ^ cst3); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M0 ^ cst8); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M3 ^ cstB); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M8 ^ cst0); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M9 ^ cstE); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (MF ^ cst6); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (MC ^ cst2); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (MD ^ cst7); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M1 ^ cst4); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (MA ^ cst5); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M4 ^ cst1); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M5 ^ cstA); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M7 ^ cstD); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M2 ^ cstC); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (MA ^ cst2); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M8 ^ cst4); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M7 ^ cst6); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M1 ^ cst5); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M6 ^ cst7); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M5 ^ cst1); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M4 ^ cst8); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M2 ^ cstA); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (MF ^ cstB); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M9 ^ cstE); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M3 ^ cstC); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (MD ^ cst0); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (MC ^ cst3); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M0 ^ cstD); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (ME ^ cst9); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (MB ^ cstF); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (M0 ^ cst1); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M2 ^ cst3); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M4 ^ cst5); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (M6 ^ cst7); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M5 ^ cst4); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M7 ^ cst6); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M3 ^ cst2); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M1 ^ cst0); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M8 ^ cst9); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (MA ^ cstB); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (MC ^ cstD); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (ME ^ cstF); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (MD ^ cstC); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (MF ^ cstE); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (MB ^ cstA); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M9 ^ cst8); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (ME ^ cstA); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M4 ^ cst8); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M9 ^ cstF); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MD ^ cst6); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (MF ^ cst9); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (M6 ^ cstD); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M8 ^ cst4); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (MA ^ cstE); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M1 ^ cstC); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M0 ^ cst2); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (MB ^ cst7); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M5 ^ cst3); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M7 ^ cstB); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M3 ^ cst5); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M2 ^ cst0); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (MC ^ cst1); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (MB ^ cst8); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (MC ^ cst0); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (M5 ^ cst2); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MF ^ cstD); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (M2 ^ cst5); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (MD ^ cstF); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M0 ^ cstC); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M8 ^ cstB); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (MA ^ cstE); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M3 ^ cst6); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M7 ^ cst1); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (M9 ^ cst4); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M1 ^ cst7); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M4 ^ cst9); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (M6 ^ cst3); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (ME ^ cstA); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);
	V0 = V0 + (M7 ^ cst9); V0 = V0 + V4; VC = VC ^ V0; VC = SWAP(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 12U); V1 = V1 + (M3 ^ cst1); V1 = V1 + V5; VD = VD ^ V1; VD = SWAP(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 12U); V2 = V2 + (MD ^ cstC); V2 = V2 + V6; VE = VE ^ V2; VE = SWAP(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 12U); V3 = V3 + (MB ^ cstE); V3 = V3 + V7; VF = VF ^ V3; VF = SWAP(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 12U); V2 = V2 + (MC ^ cstD); V2 = V2 + V6; VE = VE ^ V2; VE = ROTR8(VE); VA = VA + VE; V6 = V6 ^ VA; V6 = ROTR(V6, 7U); V3 = V3 + (ME ^ cstB); V3 = V3 + V7; VF = VF ^ V3; VF = ROTR8(VF); VB = VB + VF; V7 = V7 ^ VB; V7 = ROTR(V7, 7U); V1 = V1 + (M1 ^ cst3); V1 = V1 + V5; VD = VD ^ V1; VD = ROTR8(VD); V9 = V9 + VD; V5 = V5 ^ V9; V5 = ROTR(V5, 7U); V0 = V0 + (M9 ^ cst7); V0 = V0 + V4; VC = VC ^ V0; VC = ROTR8(VC); V8 = V8 + VC; V4 = V4 ^ V8; V4 = ROTR(V4, 7U); V0 = V0 + (M2 ^ cst6); V0 = V0 + V5; VF = VF ^ V0; VF = SWAP(VF); VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 12U); V1 = V1 + (M5 ^ cstA); V1 = V1 + V6; VC = VC ^ V1; VC = SWAP(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 12U); V2 = V2 + (M4 ^ cst0); V2 = V2 + V7; VD = VD ^ V2; VD = SWAP(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 12U); V3 = V3 + (MF ^ cst8); V3 = V3 + V4; VE = VE ^ V3; VE = SWAP(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 12U); V2 = V2 + (M0 ^ cst4); V2 = V2 + V7; VD = VD ^ V2; VD = ROTR8(VD); V8 = V8 + VD; V7 = V7 ^ V8; V7 = ROTR(V7, 7U); V3 = V3 + (M8 ^ cstF); V3 = V3 + V4; VE = VE ^ V3; VE = ROTR8(VE); V9 = V9 + VE; V4 = V4 ^ V9; V4 = ROTR(V4, 7U); V1 = V1 + (MA ^ cst5); V1 = V1 + V6; VC = VC ^ V1; VC = ROTR8(VC); VB = VB + VC; V6 = V6 ^ VB; V6 = ROTR(V6, 7U); V0 = V0 + (M6 ^ cst2); V0 = V0 + V5; VF = VF ^ V0; VF = ROTR8(VF);/*VA = VA + VF; V5 = V5 ^ VA; V5 = ROTR(V5, 7U);*/

	/* The final chunks of the hash
	 * are calculated as:
	 * h0 = h0 ^ V0 ^ V8;
	 * h1 = h1 ^ V1 ^ V9;
	 * h2 = h2 ^ V2 ^ VA;
	 * h3 = h3 ^ V3 ^ VB;
	 * h4 = h4 ^ V4 ^ VC;
	 * h5 = h5 ^ V5 ^ VD;
	 * h6 = h6 ^ V6 ^ VE;
	 * h7 = h7 ^ V7 ^ VF;
	 *
	 * We just check if the last byte
	 * is zeroed and if it is, we tell
	 * cgminer that we've found a
	 * and to check it against the
	 * target.
	*/

	/* Debug code to help you assess the correctness
	 * of your hashing function in case someone decides
	 * to try to optimize.
	if (!((pre7 ^ V7 ^ VF) & 0xFFFF0000)) {
		printf("hash on gpu %x %x %x %x %x %x %x %x\n",
			h0 ^ V0 ^ V8,
			h1 ^ V1 ^ V9,
			h2 ^ V2 ^ VA,
			h3 ^ V3 ^ VB,
			h4 ^ V4 ^ VC,
			h5 ^ V5 ^ VD,
			h6 ^ V6 ^ VE,
			h7 ^ V7 ^ VF);
		printf("nonce for hash on gpu %x\n",
			nonce);
	}
	*/

	if (pre7 ^ V7 ^ VF) return;

	/* Push this share */
	output[output[0xFF]++] = M3;
}
