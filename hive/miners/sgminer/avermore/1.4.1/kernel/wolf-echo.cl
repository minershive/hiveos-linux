#ifndef WOLF_ECHO_CL
#define WOLF_ECHO_CL

// OpenCL Echo implementation functions by Wolf

#ifdef NO_AMD_OPS
	#define BYTE0(x)	((uchar)(x))
	#define BYTE1(x)	((uchar)(x >> 8))
	#define BYTE2(x)	((uchar)(x >> 16))
	#define BYTE3(x)	((uchar)(x >> 24))
#else
	#define BYTE0(x)	(amd_bfe((x), 0U, 8U))
	#define BYTE1(x)	(amd_bfe((x), 8U, 8U))
	#define BYTE2(x)	(amd_bfe((x), 16U, 8U))
	#define BYTE3(x)	(amd_bfe((x), 24U, 8U))
#endif

uint4 Echo_AES_Round(const __local uint *AES0, const __local uint *AES1, const __local uint *AES2, const __local uint *AES3, const uint4 X)
{
	uint4 Y;
	Y.s0 = AES0[(BYTE0(X.s0))] ^ AES1[BYTE1(X.s1)] ^ AES2[BYTE2(X.s2)] ^ AES3[BYTE3(X.s3)];
	Y.s1 = AES0[(BYTE0(X.s1))] ^ AES1[BYTE1(X.s2)] ^ AES2[BYTE2(X.s3)] ^ AES3[BYTE3(X.s0)];
	Y.s2 = AES0[(BYTE0(X.s2))] ^ AES1[BYTE1(X.s3)] ^ AES2[BYTE2(X.s0)] ^ AES3[BYTE3(X.s1)];
	Y.s3 = AES0[(BYTE0(X.s3))] ^ AES1[BYTE1(X.s0)] ^ AES2[BYTE2(X.s1)] ^ AES3[BYTE3(X.s2)];
	return(Y);
}

uint4 Echo_AES_Round_Small(const __local uint *AES0, const uint4 X)
{
	uint4 Y;
	Y.s0 = AES0[(BYTE0(X.s0))] ^ rotate(AES0[BYTE1(X.s1)], 8U) ^ rotate(AES0[BYTE2(X.s2)], 16U) ^ rotate(AES0[BYTE3(X.s3)], 24U);
	Y.s1 = AES0[(BYTE0(X.s1))] ^ rotate(AES0[BYTE1(X.s2)], 8U) ^ rotate(AES0[BYTE2(X.s3)], 16U) ^ rotate(AES0[BYTE3(X.s0)], 24U);
	Y.s2 = AES0[(BYTE0(X.s2))] ^ rotate(AES0[BYTE1(X.s3)], 8U) ^ rotate(AES0[BYTE2(X.s0)], 16U) ^ rotate(AES0[BYTE3(X.s1)], 24U);
	Y.s3 = AES0[(BYTE0(X.s3))] ^ rotate(AES0[BYTE1(X.s0)], 8U) ^ rotate(AES0[BYTE2(X.s1)], 16U) ^ rotate(AES0[BYTE3(X.s2)], 24U);
	return(Y);
}

void BigSubBytesSmall(const __local uint *restrict AES0, uint4 *restrict W, uint k0)
{
	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round_Small(AES0, W[x]);
		tmp.s0 ^= k0 | x | 0x200;
		W[x] = Echo_AES_Round_Small(AES0, tmp);
	}
}

void BigSubBytesSmall80(const __local uint *restrict AES0, uint4 *restrict W, uint k0)
{
	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round_Small(AES0, W[x]);
		tmp.s0 ^= (k0 | x) + 0x280;
		W[x] = Echo_AES_Round_Small(AES0, tmp);
	}
}

void BigSubBytes(const __local uint *restrict AES0, const __local uint *restrict AES1, const __local uint *restrict AES2, const __local uint *restrict AES3, uint4 *restrict W, uint k0)
{
	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round(AES0, AES1, AES2, AES3, W[x]);
		tmp.s0 ^= k0 | x | 0x200;
		W[x] = Echo_AES_Round(AES0, AES1, AES2, AES3, tmp);
	}
}

void BigSubBytes80(const __local uint *restrict AES0, const __local uint *restrict AES1, const __local uint *restrict AES2, const __local uint *restrict AES3, uint4 *restrict W, uint k0)
{
	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round(AES0, AES1, AES2, AES3, W[x]);
		tmp.s0 ^= (k0 | x) + 0x280;
		W[x] = Echo_AES_Round(AES0, AES1, AES2, AES3, tmp);
	}
}

void BigShiftRows(uint4 *WV)
{
	uint4 tmp = WV[1];
	WV[1] = WV[5];
	WV[5] = WV[9];
	WV[9] = WV[13];
	WV[13] = tmp;

	tmp = WV[2];
	WV[2] = WV[10];
	WV[10] = tmp;
	tmp = WV[6];
	WV[6] = WV[14];
	WV[14] = tmp;

	tmp = WV[3];
	WV[3] = WV[15];
	WV[15] = WV[11];
	WV[11] = WV[7];
	WV[7] = tmp;
}

void BigMixColumns(uint4 *WV)
{
	#pragma unroll
	for(int x = 0; x < 16; x += 4)
	{
		const uint4 a = WV[x], b = WV[x + 1], c = WV[x + 2], d = WV[x + 3];

		const uint4 ab = a ^ b;
		const uint4 bc = b ^ c;
		const uint4 cd = c ^ d;

		const uint4 t1 = ab & 0x80808080U;
		const uint4 t2 = bc & 0x80808080U;
		const uint4 t3 = cd & 0x80808080U;

		const uint4 abx = ((t1 >> 7) * 27) ^ ((ab ^ t1) << 1);
		const uint4 bcx = ((t2 >> 7) * 27) ^ ((bc ^ t2) << 1);
		const uint4 cdx = ((t3 >> 7) * 27) ^ ((cd ^ t3) << 1);

		WV[x] = abx ^ bc ^ d;
		WV[x + 1] = bcx ^ a ^ cd;
		WV[x + 2] = cdx ^ ab ^ d;
		WV[x + 3] = abx ^ bcx ^ cdx ^ ab ^ c;
	}
}

#endif
