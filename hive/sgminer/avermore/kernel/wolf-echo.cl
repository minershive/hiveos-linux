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

void BigSubBytesSmall(const __local uint *restrict AES0, uint4 *restrict W, uchar rnd)
{
	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round_Small(AES0, W[x]);
		tmp.s0 ^= (rnd << 4) + x + 512;
		W[x] = Echo_AES_Round_Small(AES0, tmp);
	}
}

void BigSubBytesSmall80(const __local uint *restrict AES0, uint4 *restrict W, uchar rnd)
{
	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round_Small(AES0, W[x]);
		tmp.s0 ^= (rnd << 4) + x + 640;
		W[x] = Echo_AES_Round_Small(AES0, tmp);
	}
}

//#if defined(WOLF_X11_CL)
#if 0
void BigSubBytes(const __local uint *restrict AES0, const __local uint *restrict AES1, const __local uint *restrict AES2, const __local uint *restrict AES3, uint *restrict W, uchar rnd)
#else
void BigSubBytes(const __local uint *restrict AES0, const __local uint *restrict AES1, const __local uint *restrict AES2, const __local uint *restrict AES3, uint4 *restrict W, uchar rnd)
#endif
{
	//#if defined(WOLF_X11_CL)
	#if 0

	#if defined(WOLF_X11_CL)
	#pragma unroll 8
	#else
	#pragma unroll 4
	#endif
	for(int x = 0; x < 16; ++x)
	{
		const uint idx = x << 2;
		uint tmp[4];

		#if defined(WOLF_X11_CL)
		#pragma unroll 2
		#else
		#pragma unroll
		#endif
		for(int i = 0; i < 4; ++i)
			tmp[i] = AES0[BYTE0(W[idx + i])] ^ AES1[BYTE1(W[idx + ((i + 1) & 3)])] ^ AES2[BYTE2(W[idx + ((i + 2) & 3)])] ^ AES3[BYTE3(W[idx + ((i + 3) & 3)])];

		tmp[0] ^= (rnd << 4) + x + 512;

		#if defined(WOLF_X11_CL)
		#pragma unroll 2
		#else
		#pragma unroll
		#endif
		for(int i = 0; i < 4; ++i)
			W[idx + i] = AES0[BYTE0(tmp[i])] ^ AES1[BYTE1(tmp[(i + 1) & 3])] ^ AES2[BYTE2(tmp[(i + 2) & 3])] ^ AES3[BYTE3(tmp[(i + 3) & 3])];
	}

	#else

	#pragma unroll
	for(int x = 0; x < 16; ++x)
	{
		uint4 tmp;
		tmp = Echo_AES_Round(AES0, AES1, AES2, AES3, W[x]);
		tmp.s0 ^= (rnd << 4) + x + 512;
		W[x] = Echo_AES_Round(AES0, AES1, AES2, AES3, tmp);
	}

	#endif
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

uint NewIdx(uint absidx, uint shiftamt)
{
	return((absidx + (shiftamt << 2)) & 15);
}

//#ifdef WOLF_X11_CL
#if 0
void BigMixColumns(uint *W)
#else
void BigMixColumns(uint4 *WV)
#endif
{
	//#ifdef WOLF_X11_CL
	#if 0
	for(int y = 0; y < 64; y += 16)
	{
		#pragma unroll
		for(int x = 0; x < 4; ++x)
		{
			const uint a = W[y + x];
			const uint b = W[y + x + 4];
			const uint c = W[y + x + 8];
			const uint d = W[y + x + 12];

			const uint ab = a ^ b;
			const uint bc = b ^ c;
			const uint cd = c ^ d;

			const uint t1 = ab & 0x80808080U;
			const uint t2 = bc & 0x80808080U;
			const uint t3 = cd & 0x80808080U;

			const uint abx = ((t1 >> 7) * 27) ^ ((ab ^ t1) << 1);
			const uint bcx = ((t2 >> 7) * 27) ^ ((bc ^ t2) << 1);
			const uint cdx = ((t3 >> 7) * 27) ^ ((cd ^ t3) << 1);

			W[y + x] = abx ^ bc ^ d;
			W[y + x + 4] = bcx ^ a ^ cd;
			W[y + x + 8] = cdx ^ ab ^ d;
			W[y + x + 12] = abx ^  bcx ^ cdx ^ ab ^ c;
		}
	}

	#else

	#pragma unroll
	for(int x = 0; x < 16; x += 4)
	{
		const uint4 a = WV[x], b = WV[x + 1], c = WV[x + 2], d = WV[x + 3];
		//const uint4 a = WV[NewIdx(x + 0, 0)], b = WV[NewIdx(x + 1, 1)], c = WV[NewIdx(x + 2, 2)], d = WV[NewIdx(x + 3, 3)];

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

	/*uint4 a[4], b[4], c[4], d[4];

	#pragma unroll
	for(int x = 0; x < 16; x += 4)
	{
		a[x >> 2] = WV[NewIdx(x + 0, 0)];
		b[x >> 2] = WV[NewIdx(x + 1, 1)];
		c[x >> 2] = WV[NewIdx(x + 2, 2)];
		d[x >> 2] = WV[NewIdx(x + 3, 3)];
	}

	#pragma unroll
	for(int x = 0; x < 16; x += 4)
	{
		const uint4 ab = a[x >> 2] ^ b[x >> 2];
		const uint4 bc = b[x >> 2] ^ c[x >> 2];
		const uint4 cd = c[x >> 2] ^ d[x >> 2];

		const uint4 t1 = ab & 0x80808080U;
		const uint4 t2 = bc & 0x80808080U;
		const uint4 t3 = cd & 0x80808080U;

		const uint4 abx = ((t1 >> 7) * 27) ^ ((ab ^ t1) << 1);
		const uint4 bcx = ((t2 >> 7) * 27) ^ ((bc ^ t2) << 1);
		const uint4 cdx = ((t3 >> 7) * 27) ^ ((cd ^ t3) << 1);

		WV[x] = abx ^ bc ^ d[x >> 2];
		WV[x + 1] = bcx ^ a[x >> 2] ^ cd;
		WV[x + 2] = cdx ^ ab ^ d[x >> 2];
		WV[x + 3] = abx ^ bcx ^ cdx ^ ab ^ c[x >> 2];
	}*/

	#endif
}

#endif
