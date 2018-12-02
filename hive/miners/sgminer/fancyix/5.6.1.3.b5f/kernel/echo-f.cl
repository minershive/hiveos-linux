#ifndef FANCYIX_ECHO_CL
#define FANCYIX_ECHO_CL

// OpenCL Echo implementation functions by Wolf and modified by fancyIX

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

#define BigSubBytesSmall(AES0, W, k0) \
    tmp; \
	tmp = Echo_AES_Round_Small(AES0, W0 ); tmp.s0 ^= k0 | 0  | 0x200; W0  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W1 ); tmp.s0 ^= k0 | 1  | 0x200; W1  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W2 ); tmp.s0 ^= k0 | 2  | 0x200; W2  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W3 ); tmp.s0 ^= k0 | 3  | 0x200; W3  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W4 ); tmp.s0 ^= k0 | 4  | 0x200; W4  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W5 ); tmp.s0 ^= k0 | 5  | 0x200; W5  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W6 ); tmp.s0 ^= k0 | 6  | 0x200; W6  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W7 ); tmp.s0 ^= k0 | 7  | 0x200; W7  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W8 ); tmp.s0 ^= k0 | 8  | 0x200; W8  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W9 ); tmp.s0 ^= k0 | 9  | 0x200; W9  = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W10); tmp.s0 ^= k0 | 10 | 0x200; W10 = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W11); tmp.s0 ^= k0 | 11 | 0x200; W11 = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W12); tmp.s0 ^= k0 | 12 | 0x200; W12 = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W13); tmp.s0 ^= k0 | 13 | 0x200; W13 = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W14); tmp.s0 ^= k0 | 14 | 0x200; W14 = Echo_AES_Round_Small(AES0, tmp); \
    tmp = Echo_AES_Round_Small(AES0, W15); tmp.s0 ^= k0 | 15 | 0x200; W15 = Echo_AES_Round_Small(AES0, tmp);

#define BigShiftRows(W) \
	tmp = W1; \
	W1 = W5; \
	W5 = W9; \
	W9 = W13; \
	W13 = tmp; \
	tmp = W2; \
	W2 = W10; \
	W10 = tmp; \
	tmp = W6; \
	W6 = W14; \
	W14 = tmp; \
	tmp = W3; \
	W3 = W15; \
	W15 = W11; \
	W11 = W7; \
	W7 = tmp;

#define BigMixColumnsM(W, x0, x1, x2, x3) \
		a = W ## x0, b = W ## x1, c = W ## x2, d = W ## x3; \
		ab = a ^ b; \
		bc = b ^ c; \
		cd = c ^ d; \
		t1 = ab & 0x80808080U; \
		t2 = bc & 0x80808080U; \
		t3 = cd & 0x80808080U; \
		abx = ((t1 >> 7) * 27) ^ ((ab ^ t1) << 1); \
		bcx = ((t2 >> 7) * 27) ^ ((bc ^ t2) << 1); \
		cdx = ((t3 >> 7) * 27) ^ ((cd ^ t3) << 1); \
		W ## x0 = abx ^ bc ^ d; \
		W ## x1 = bcx ^ a ^ cd; \
		W ## x2 = cdx ^ ab ^ d; \
		W ## x3 = abx ^ bcx ^ cdx ^ ab ^ c;

#define BigMixColumns(W) \
	BigMixColumnsM(W, 0, 1, 2, 3); \
	BigMixColumnsM(W, 4, 5, 6, 7); \
	BigMixColumnsM(W, 8, 9, 10, 11); \
	BigMixColumnsM(W, 12, 13, 14, 15);

#endif