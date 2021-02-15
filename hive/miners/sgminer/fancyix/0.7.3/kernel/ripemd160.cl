#define RIPEMD160_IN(x) W[x]

// Round functions for RIPEMD-128 and RIPEMD-160.

#define F1(x, y, z)  	((x) ^ (y) ^ (z))
#define F2(x, y, z)   	((((y) ^ (z)) & (x)) ^ (z))
#define F3(x, y, z)   	(((x) | ~(y)) ^ (z))
#define F4(x, y, z)   	((((x) ^ (y)) & (z)) ^ (y))
#define F5(x, y, z)   	((x) ^ ((y) | ~(z)))

#define K11    0x00000000
#define K12    0x5A827999
#define K13    0x6ED9EBA1
#define K14    0x8F1BBCDC
#define K15    0xA953FD4E

#define K21    0x50A28BE6
#define K22    0x5C4DD124
#define K23    0x6D703EF3
#define K24    0x7A6D76E9
#define K25    0x00000000

const __constant uint RMD160_IV[5] = { 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0 };

#define RR(a, b, c, d, e, f, s, r, k)   do { \
		const uint rrtmp = a + f(b, c, d) + r + k; \
		a = amd_bitalign(rrtmp, rrtmp, 32U - (uint)s) + e; \
		c = amd_bitalign(c, c, 32U - 10U); \
	} while (0)

#define ROUND1(a, b, c, d, e, f, s, r, k)  \
	RR(a ## 1, b ## 1, c ## 1, d ## 1, e ## 1, f, s, r, K1 ## k)

#define ROUND2(a, b, c, d, e, f, s, r, k)  \
	RR(a ## 2, b ## 2, c ## 2, d ## 2, e ## 2, f, s, r, K2 ## k)

/*
 * This macro defines the body for a RIPEMD-160 compression function
 * implementation. The "in" parameter should evaluate, when applied to a
 * numerical input parameter from 0 to 15, to an expression which yields
 * the corresponding input block. The "h" parameter should evaluate to
 * an array or pointer expression designating the array of 5 words which
 * contains the input and output of the compression function.
 */

//#define RIPEMD160_ROUND_BODY(in, h)   do { \
		uint A1, B1, C1, D1, E1; \
		uint A2, B2, C2, D2, E2; \
		uint tmp; \
 \
		A1 = A2 = (h)[0]; \
		B1 = B2 = (h)[1]; \
		C1 = C2 = (h)[2]; \
		D1 = D2 = (h)[3]; \
		E1 = E2 = (h)[4]; \
 \
		ROUND1(A, B, C, D, E, F1, 11, (in)[ 0],  1); \
		ROUND1(E, A, B, C, D, F1, 14, (in)[ 1],  1); \
		ROUND1(D, E, A, B, C, F1, 15, (in)[ 2],  1); \
		ROUND1(C, D, E, A, B, F1, 12, (in)[ 3],  1); \
		ROUND1(B, C, D, E, A, F1,  5, (in)[ 4],  1); \
		ROUND1(A, B, C, D, E, F1,  8, (in)[ 5],  1); \
		ROUND1(E, A, B, C, D, F1,  7, (in)[ 6],  1); \
		ROUND1(D, E, A, B, C, F1,  9, (in)[ 7],  1); \
		ROUND1(C, D, E, A, B, F1, 11, (in)[ 8],  1); \
		ROUND1(B, C, D, E, A, F1, 13, (in)[ 9],  1); \
		ROUND1(A, B, C, D, E, F1, 14, (in)[10],  1); \
		ROUND1(E, A, B, C, D, F1, 15, (in)[11],  1); \
		ROUND1(D, E, A, B, C, F1,  6, (in)[12],  1); \
		ROUND1(C, D, E, A, B, F1,  7, (in)[13],  1); \
		ROUND1(B, C, D, E, A, F1,  9, (in)[14],  1); \
		ROUND1(A, B, C, D, E, F1,  8, (in)[15],  1); \
 \
		ROUND1(E, A, B, C, D, F2,  7, (in)[ 7],  2); \
		ROUND1(D, E, A, B, C, F2,  6, (in)[ 4],  2); \
		ROUND1(C, D, E, A, B, F2,  8, (in)[13],  2); \
		ROUND1(B, C, D, E, A, F2, 13, (in)[ 1],  2); \
		ROUND1(A, B, C, D, E, F2, 11, (in)[10],  2); \
		ROUND1(E, A, B, C, D, F2,  9, (in)[ 6],  2); \
		ROUND1(D, E, A, B, C, F2,  7, (in)[15],  2); \
		ROUND1(C, D, E, A, B, F2, 15, (in)[ 3],  2); \
		ROUND1(B, C, D, E, A, F2,  7, (in)[12],  2); \
		ROUND1(A, B, C, D, E, F2, 12, (in)[ 0],  2); \
		ROUND1(E, A, B, C, D, F2, 15, (in)[ 9],  2); \
		ROUND1(D, E, A, B, C, F2,  9, (in)[ 5],  2); \
		ROUND1(C, D, E, A, B, F2, 11, (in)[ 2],  2); \
		ROUND1(B, C, D, E, A, F2,  7, (in)[14],  2); \
		ROUND1(A, B, C, D, E, F2, 13, (in)[11],  2); \
		ROUND1(E, A, B, C, D, F2, 12, (in)[ 8],  2); \
 \
		ROUND1(D, E, A, B, C, F3, 11, (in)[ 3],  3); \
		ROUND1(C, D, E, A, B, F3, 13, (in)[10],  3); \
		ROUND1(B, C, D, E, A, F3,  6, (in)[14],  3); \
		ROUND1(A, B, C, D, E, F3,  7, (in)[ 4],  3); \
		ROUND1(E, A, B, C, D, F3, 14, (in)[ 9],  3); \
		ROUND1(D, E, A, B, C, F3,  9, (in)[15],  3); \
		ROUND1(C, D, E, A, B, F3, 13, (in)[ 8],  3); \
		ROUND1(B, C, D, E, A, F3, 15, (in)[ 1],  3); \
		ROUND1(A, B, C, D, E, F3, 14, (in)[ 2],  3); \
		ROUND1(E, A, B, C, D, F3,  8, (in)[ 7],  3); \
		ROUND1(D, E, A, B, C, F3, 13, (in)[ 0],  3); \
		ROUND1(C, D, E, A, B, F3,  6, (in)[ 6],  3); \
		ROUND1(B, C, D, E, A, F3,  5, (in)[13],  3); \
		ROUND1(A, B, C, D, E, F3, 12, (in)[11],  3); \
		ROUND1(E, A, B, C, D, F3,  7, (in)[ 5],  3); \
		ROUND1(D, E, A, B, C, F3,  5, (in)[12],  3); \
 \
		ROUND1(C, D, E, A, B, F4, 11, (in)[ 1],  4); \
		ROUND1(B, C, D, E, A, F4, 12, (in)[ 9],  4); \
		ROUND1(A, B, C, D, E, F4, 14, (in)[11],  4); \
		ROUND1(E, A, B, C, D, F4, 15, (in)[10],  4); \
		ROUND1(D, E, A, B, C, F4, 14, (in)[ 0],  4); \
		ROUND1(C, D, E, A, B, F4, 15, (in)[ 8],  4); \
		ROUND1(B, C, D, E, A, F4,  9, (in)[12],  4); \
		ROUND1(A, B, C, D, E, F4,  8, (in)[ 4],  4); \
		ROUND1(E, A, B, C, D, F4,  9, (in)[13],  4); \
		ROUND1(D, E, A, B, C, F4, 14, (in)[ 3],  4); \
		ROUND1(C, D, E, A, B, F4,  5, (in)[ 7],  4); \
		ROUND1(B, C, D, E, A, F4,  6, (in)[15],  4); \
		ROUND1(A, B, C, D, E, F4,  8, (in)[14],  4); \
		ROUND1(E, A, B, C, D, F4,  6, (in)[ 5],  4); \
		ROUND1(D, E, A, B, C, F4,  5, (in)[ 6],  4); \
		ROUND1(C, D, E, A, B, F4, 12, (in)[ 2],  4); \
 \
		ROUND1(B, C, D, E, A, F5,  9, (in)[ 4],  5); \
		ROUND1(A, B, C, D, E, F5, 15, (in)[ 0],  5); \
		ROUND1(E, A, B, C, D, F5,  5, (in)[ 5],  5); \
		ROUND1(D, E, A, B, C, F5, 11, (in)[ 9],  5); \
		ROUND1(C, D, E, A, B, F5,  6, (in)[ 7],  5); \
		ROUND1(B, C, D, E, A, F5,  8, (in)[12],  5); \
		ROUND1(A, B, C, D, E, F5, 13, (in)[ 2],  5); \
		ROUND1(E, A, B, C, D, F5, 12, (in)[10],  5); \
		ROUND1(D, E, A, B, C, F5,  5, (in)[14],  5); \
		ROUND1(C, D, E, A, B, F5, 12, (in)[ 1],  5); \
		ROUND1(B, C, D, E, A, F5, 13, (in)[ 3],  5); \
		ROUND1(A, B, C, D, E, F5, 14, (in)[ 8],  5); \
		ROUND1(E, A, B, C, D, F5, 11, (in)[11],  5); \
		ROUND1(D, E, A, B, C, F5,  8, (in)[ 6],  5); \
		ROUND1(C, D, E, A, B, F5,  5, (in)[15],  5); \
		ROUND1(B, C, D, E, A, F5,  6, (in)[13],  5); \
 \
		ROUND2(A, B, C, D, E, F5,  8, (in)[ 5],  1); \
		ROUND2(E, A, B, C, D, F5,  9, (in)[14],  1); \
		ROUND2(D, E, A, B, C, F5,  9, (in)[ 7],  1); \
		ROUND2(C, D, E, A, B, F5, 11, (in)[ 0],  1); \
		ROUND2(B, C, D, E, A, F5, 13, (in)[ 9],  1); \
		ROUND2(A, B, C, D, E, F5, 15, (in)[ 2],  1); \
		ROUND2(E, A, B, C, D, F5, 15, (in)[11],  1); \
		ROUND2(D, E, A, B, C, F5,  5, (in)[ 4],  1); \
		ROUND2(C, D, E, A, B, F5,  7, (in)[13],  1); \
		ROUND2(B, C, D, E, A, F5,  7, (in)[ 6],  1); \
		ROUND2(A, B, C, D, E, F5,  8, (in)[15],  1); \
		ROUND2(E, A, B, C, D, F5, 11, (in)[ 8],  1); \
		ROUND2(D, E, A, B, C, F5, 14, (in)[ 1],  1); \
		ROUND2(C, D, E, A, B, F5, 14, (in)[10],  1); \
		ROUND2(B, C, D, E, A, F5, 12, (in)[ 3],  1); \
		ROUND2(A, B, C, D, E, F5,  6, (in)[12],  1); \
 \
		ROUND2(E, A, B, C, D, F4,  9, (in)[ 6],  2); \
		ROUND2(D, E, A, B, C, F4, 13, (in)[11],  2); \
		ROUND2(C, D, E, A, B, F4, 15, (in)[ 3],  2); \
		ROUND2(B, C, D, E, A, F4,  7, (in)[ 7],  2); \
		ROUND2(A, B, C, D, E, F4, 12, (in)[ 0],  2); \
		ROUND2(E, A, B, C, D, F4,  8, (in)[13],  2); \
		ROUND2(D, E, A, B, C, F4,  9, (in)[ 5],  2); \
		ROUND2(C, D, E, A, B, F4, 11, (in)[10],  2); \
		ROUND2(B, C, D, E, A, F4,  7, (in)[14],  2); \
		ROUND2(A, B, C, D, E, F4,  7, (in)[15],  2); \
		ROUND2(E, A, B, C, D, F4, 12, (in)[ 8],  2); \
		ROUND2(D, E, A, B, C, F4,  7, (in)[12],  2); \
		ROUND2(C, D, E, A, B, F4,  6, (in)[ 4],  2); \
		ROUND2(B, C, D, E, A, F4, 15, (in)[ 9],  2); \
		ROUND2(A, B, C, D, E, F4, 13, (in)[ 1],  2); \
		ROUND2(E, A, B, C, D, F4, 11, (in)[ 2],  2); \
 \
		ROUND2(D, E, A, B, C, F3,  9, (in)[15],  3); \
		ROUND2(C, D, E, A, B, F3,  7, (in)[ 5],  3); \
		ROUND2(B, C, D, E, A, F3, 15, (in)[ 1],  3); \
		ROUND2(A, B, C, D, E, F3, 11, (in)[ 3],  3); \
		ROUND2(E, A, B, C, D, F3,  8, (in)[ 7],  3); \
		ROUND2(D, E, A, B, C, F3,  6, (in)[14],  3); \
		ROUND2(C, D, E, A, B, F3,  6, (in)[ 6],  3); \
		ROUND2(B, C, D, E, A, F3, 14, (in)[ 9],  3); \
		ROUND2(A, B, C, D, E, F3, 12, (in)[11],  3); \
		ROUND2(E, A, B, C, D, F3, 13, (in)[ 8],  3); \
		ROUND2(D, E, A, B, C, F3,  5, (in)[12],  3); \
		ROUND2(C, D, E, A, B, F3, 14, (in)[ 2],  3); \
		ROUND2(B, C, D, E, A, F3, 13, (in)[10],  3); \
		ROUND2(A, B, C, D, E, F3, 13, (in)[ 0],  3); \
		ROUND2(E, A, B, C, D, F3,  7, (in)[ 4],  3); \
		ROUND2(D, E, A, B, C, F3,  5, (in)[13],  3); \
 \
		ROUND2(C, D, E, A, B, F2, 15, (in)[ 8],  4); \
		ROUND2(B, C, D, E, A, F2,  5, (in)[ 6],  4); \
		ROUND2(A, B, C, D, E, F2,  8, (in)[ 4],  4); \
		ROUND2(E, A, B, C, D, F2, 11, (in)[ 1],  4); \
		ROUND2(D, E, A, B, C, F2, 14, (in)[ 3],  4); \
		ROUND2(C, D, E, A, B, F2, 14, (in)[11],  4); \
		ROUND2(B, C, D, E, A, F2,  6, (in)[15],  4); \
		ROUND2(A, B, C, D, E, F2, 14, (in)[ 0],  4); \
		ROUND2(E, A, B, C, D, F2,  6, (in)[ 5],  4); \
		ROUND2(D, E, A, B, C, F2,  9, (in)[12],  4); \
		ROUND2(C, D, E, A, B, F2, 12, (in)[ 2],  4); \
		ROUND2(B, C, D, E, A, F2,  9, (in)[13],  4); \
		ROUND2(A, B, C, D, E, F2, 12, (in)[ 9],  4); \
		ROUND2(E, A, B, C, D, F2,  5, (in)[ 7],  4); \
		ROUND2(D, E, A, B, C, F2, 15, (in)[10],  4); \
		ROUND2(C, D, E, A, B, F2,  8, (in)[14],  4); \
 \
		ROUND2(B, C, D, E, A, F1,  8, (in)[12],  5); \
		ROUND2(A, B, C, D, E, F1,  5, (in)[15],  5); \
		ROUND2(E, A, B, C, D, F1, 12, (in)[10],  5); \
		ROUND2(D, E, A, B, C, F1,  9, (in)[ 4],  5); \
		ROUND2(C, D, E, A, B, F1, 12, (in)[ 1],  5); \
		ROUND2(B, C, D, E, A, F1,  5, (in)[ 5],  5); \
		ROUND2(A, B, C, D, E, F1, 14, (in)[ 8],  5); \
		ROUND2(E, A, B, C, D, F1,  6, (in)[ 7],  5); \
		ROUND2(D, E, A, B, C, F1,  8, (in)[ 6],  5); \
		ROUND2(C, D, E, A, B, F1, 13, (in)[ 2],  5); \
		ROUND2(B, C, D, E, A, F1,  6, (in)[13],  5); \
		ROUND2(A, B, C, D, E, F1,  5, (in)[14],  5); \
		ROUND2(E, A, B, C, D, F1, 15, (in)[ 0],  5); \
		ROUND2(D, E, A, B, C, F1, 13, (in)[ 3],  5); \
		ROUND2(C, D, E, A, B, F1, 11, (in)[ 9],  5); \
		ROUND2(B, C, D, E, A, F1, 11, (in)[11],  5); \
 \
		tmp = (h)[1] + C1 + D2; \
		(h)[1] = (h)[2] + D1 + E2; \
		(h)[2] = (h)[3] + E1 + A2; \
		(h)[3] = (h)[4] + A1 + B2; \
		(h)[4] = (h)[0] + B1 + C2; \
		(h)[0] = tmp; \
	} while (0)

void RIPEMD160_ROUND_BODY(uint *in, uint *h)
{
	uint A1, B1, C1, D1, E1;
	uint A2, B2, C2, D2, E2;
	uint tmp;

	A1 = A2 = (h)[0];
	B1 = B2 = (h)[1];
	C1 = C2 = (h)[2];
	D1 = D2 = (h)[3];
	E1 = E2 = (h)[4];

	ROUND1(A, B, C, D, E, F1, 11, (in)[ 0],  1);
	ROUND1(E, A, B, C, D, F1, 14, (in)[ 1],  1);
	ROUND1(D, E, A, B, C, F1, 15, (in)[ 2],  1);
	ROUND1(C, D, E, A, B, F1, 12, (in)[ 3],  1);
	ROUND1(B, C, D, E, A, F1,  5, (in)[ 4],  1);
	ROUND1(A, B, C, D, E, F1,  8, (in)[ 5],  1);
	ROUND1(E, A, B, C, D, F1,  7, (in)[ 6],  1);
	ROUND1(D, E, A, B, C, F1,  9, (in)[ 7],  1);
	ROUND1(C, D, E, A, B, F1, 11, (in)[ 8],  1);
	ROUND1(B, C, D, E, A, F1, 13, (in)[ 9],  1);
	ROUND1(A, B, C, D, E, F1, 14, (in)[10],  1);
	ROUND1(E, A, B, C, D, F1, 15, (in)[11],  1);
	ROUND1(D, E, A, B, C, F1,  6, (in)[12],  1);
	ROUND1(C, D, E, A, B, F1,  7, (in)[13],  1);
	ROUND1(B, C, D, E, A, F1,  9, (in)[14],  1);
	ROUND1(A, B, C, D, E, F1,  8, (in)[15],  1);

	ROUND1(E, A, B, C, D, F2,  7, (in)[ 7],  2);
	ROUND1(D, E, A, B, C, F2,  6, (in)[ 4],  2);
	ROUND1(C, D, E, A, B, F2,  8, (in)[13],  2);
	ROUND1(B, C, D, E, A, F2, 13, (in)[ 1],  2);
	ROUND1(A, B, C, D, E, F2, 11, (in)[10],  2);
	ROUND1(E, A, B, C, D, F2,  9, (in)[ 6],  2);
	ROUND1(D, E, A, B, C, F2,  7, (in)[15],  2);
	ROUND1(C, D, E, A, B, F2, 15, (in)[ 3],  2);
	ROUND1(B, C, D, E, A, F2,  7, (in)[12],  2);
	ROUND1(A, B, C, D, E, F2, 12, (in)[ 0],  2);
	ROUND1(E, A, B, C, D, F2, 15, (in)[ 9],  2);
	ROUND1(D, E, A, B, C, F2,  9, (in)[ 5],  2);
	ROUND1(C, D, E, A, B, F2, 11, (in)[ 2],  2);
	ROUND1(B, C, D, E, A, F2,  7, (in)[14],  2);
	ROUND1(A, B, C, D, E, F2, 13, (in)[11],  2);
	ROUND1(E, A, B, C, D, F2, 12, (in)[ 8],  2);

	ROUND1(D, E, A, B, C, F3, 11, (in)[ 3],  3);
	ROUND1(C, D, E, A, B, F3, 13, (in)[10],  3);
	ROUND1(B, C, D, E, A, F3,  6, (in)[14],  3);
	ROUND1(A, B, C, D, E, F3,  7, (in)[ 4],  3);
	ROUND1(E, A, B, C, D, F3, 14, (in)[ 9],  3);
	ROUND1(D, E, A, B, C, F3,  9, (in)[15],  3);
	ROUND1(C, D, E, A, B, F3, 13, (in)[ 8],  3);
	ROUND1(B, C, D, E, A, F3, 15, (in)[ 1],  3);
	ROUND1(A, B, C, D, E, F3, 14, (in)[ 2],  3);
	ROUND1(E, A, B, C, D, F3,  8, (in)[ 7],  3);
	ROUND1(D, E, A, B, C, F3, 13, (in)[ 0],  3);
	ROUND1(C, D, E, A, B, F3,  6, (in)[ 6],  3);
	ROUND1(B, C, D, E, A, F3,  5, (in)[13],  3);
	ROUND1(A, B, C, D, E, F3, 12, (in)[11],  3);
	ROUND1(E, A, B, C, D, F3,  7, (in)[ 5],  3);
	ROUND1(D, E, A, B, C, F3,  5, (in)[12],  3);

	ROUND1(C, D, E, A, B, F4, 11, (in)[ 1],  4);
	ROUND1(B, C, D, E, A, F4, 12, (in)[ 9],  4);
	ROUND1(A, B, C, D, E, F4, 14, (in)[11],  4);
	ROUND1(E, A, B, C, D, F4, 15, (in)[10],  4);
	ROUND1(D, E, A, B, C, F4, 14, (in)[ 0],  4);
	ROUND1(C, D, E, A, B, F4, 15, (in)[ 8],  4);
	ROUND1(B, C, D, E, A, F4,  9, (in)[12],  4);
	ROUND1(A, B, C, D, E, F4,  8, (in)[ 4],  4);
	ROUND1(E, A, B, C, D, F4,  9, (in)[13],  4);
	ROUND1(D, E, A, B, C, F4, 14, (in)[ 3],  4);
	ROUND1(C, D, E, A, B, F4,  5, (in)[ 7],  4);
	ROUND1(B, C, D, E, A, F4,  6, (in)[15],  4);
	ROUND1(A, B, C, D, E, F4,  8, (in)[14],  4);
	ROUND1(E, A, B, C, D, F4,  6, (in)[ 5],  4);
	ROUND1(D, E, A, B, C, F4,  5, (in)[ 6],  4);
	ROUND1(C, D, E, A, B, F4, 12, (in)[ 2],  4);

	ROUND1(B, C, D, E, A, F5,  9, (in)[ 4],  5);
	ROUND1(A, B, C, D, E, F5, 15, (in)[ 0],  5);
	ROUND1(E, A, B, C, D, F5,  5, (in)[ 5],  5);
	ROUND1(D, E, A, B, C, F5, 11, (in)[ 9],  5);
	ROUND1(C, D, E, A, B, F5,  6, (in)[ 7],  5);
	ROUND1(B, C, D, E, A, F5,  8, (in)[12],  5);
	ROUND1(A, B, C, D, E, F5, 13, (in)[ 2],  5);
	ROUND1(E, A, B, C, D, F5, 12, (in)[10],  5);
	ROUND1(D, E, A, B, C, F5,  5, (in)[14],  5);
	ROUND1(C, D, E, A, B, F5, 12, (in)[ 1],  5);
	ROUND1(B, C, D, E, A, F5, 13, (in)[ 3],  5);
	ROUND1(A, B, C, D, E, F5, 14, (in)[ 8],  5);
	ROUND1(E, A, B, C, D, F5, 11, (in)[11],  5);
	ROUND1(D, E, A, B, C, F5,  8, (in)[ 6],  5);
	ROUND1(C, D, E, A, B, F5,  5, (in)[15],  5);
	ROUND1(B, C, D, E, A, F5,  6, (in)[13],  5);

	ROUND2(A, B, C, D, E, F5,  8, (in)[ 5],  1);
	ROUND2(E, A, B, C, D, F5,  9, (in)[14],  1);
	ROUND2(D, E, A, B, C, F5,  9, (in)[ 7],  1);
	ROUND2(C, D, E, A, B, F5, 11, (in)[ 0],  1);
	ROUND2(B, C, D, E, A, F5, 13, (in)[ 9],  1);
	ROUND2(A, B, C, D, E, F5, 15, (in)[ 2],  1);
	ROUND2(E, A, B, C, D, F5, 15, (in)[11],  1);
	ROUND2(D, E, A, B, C, F5,  5, (in)[ 4],  1);
	ROUND2(C, D, E, A, B, F5,  7, (in)[13],  1);
	ROUND2(B, C, D, E, A, F5,  7, (in)[ 6],  1);
	ROUND2(A, B, C, D, E, F5,  8, (in)[15],  1);
	ROUND2(E, A, B, C, D, F5, 11, (in)[ 8],  1);
	ROUND2(D, E, A, B, C, F5, 14, (in)[ 1],  1);
	ROUND2(C, D, E, A, B, F5, 14, (in)[10],  1);
	ROUND2(B, C, D, E, A, F5, 12, (in)[ 3],  1);
	ROUND2(A, B, C, D, E, F5,  6, (in)[12],  1);

	ROUND2(E, A, B, C, D, F4,  9, (in)[ 6],  2);
	ROUND2(D, E, A, B, C, F4, 13, (in)[11],  2);
	ROUND2(C, D, E, A, B, F4, 15, (in)[ 3],  2);
	ROUND2(B, C, D, E, A, F4,  7, (in)[ 7],  2);
	ROUND2(A, B, C, D, E, F4, 12, (in)[ 0],  2);
	ROUND2(E, A, B, C, D, F4,  8, (in)[13],  2);
	ROUND2(D, E, A, B, C, F4,  9, (in)[ 5],  2);
	ROUND2(C, D, E, A, B, F4, 11, (in)[10],  2);
	ROUND2(B, C, D, E, A, F4,  7, (in)[14],  2);
	ROUND2(A, B, C, D, E, F4,  7, (in)[15],  2);
	ROUND2(E, A, B, C, D, F4, 12, (in)[ 8],  2);
	ROUND2(D, E, A, B, C, F4,  7, (in)[12],  2);
	ROUND2(C, D, E, A, B, F4,  6, (in)[ 4],  2);
	ROUND2(B, C, D, E, A, F4, 15, (in)[ 9],  2);
	ROUND2(A, B, C, D, E, F4, 13, (in)[ 1],  2);
	ROUND2(E, A, B, C, D, F4, 11, (in)[ 2],  2);

	ROUND2(D, E, A, B, C, F3,  9, (in)[15],  3);
	ROUND2(C, D, E, A, B, F3,  7, (in)[ 5],  3);
	ROUND2(B, C, D, E, A, F3, 15, (in)[ 1],  3);
	ROUND2(A, B, C, D, E, F3, 11, (in)[ 3],  3);
	ROUND2(E, A, B, C, D, F3,  8, (in)[ 7],  3);
	ROUND2(D, E, A, B, C, F3,  6, (in)[14],  3);
	ROUND2(C, D, E, A, B, F3,  6, (in)[ 6],  3);
	ROUND2(B, C, D, E, A, F3, 14, (in)[ 9],  3);
	ROUND2(A, B, C, D, E, F3, 12, (in)[11],  3);
	ROUND2(E, A, B, C, D, F3, 13, (in)[ 8],  3);
	ROUND2(D, E, A, B, C, F3,  5, (in)[12],  3);
	ROUND2(C, D, E, A, B, F3, 14, (in)[ 2],  3);
	ROUND2(B, C, D, E, A, F3, 13, (in)[10],  3);
	ROUND2(A, B, C, D, E, F3, 13, (in)[ 0],  3);
	ROUND2(E, A, B, C, D, F3,  7, (in)[ 4],  3);
	ROUND2(D, E, A, B, C, F3,  5, (in)[13],  3);

	ROUND2(C, D, E, A, B, F2, 15, (in)[ 8],  4);
	ROUND2(B, C, D, E, A, F2,  5, (in)[ 6],  4);
	ROUND2(A, B, C, D, E, F2,  8, (in)[ 4],  4);
	ROUND2(E, A, B, C, D, F2, 11, (in)[ 1],  4);
	ROUND2(D, E, A, B, C, F2, 14, (in)[ 3],  4);
	ROUND2(C, D, E, A, B, F2, 14, (in)[11],  4);
	ROUND2(B, C, D, E, A, F2,  6, (in)[15],  4);
	ROUND2(A, B, C, D, E, F2, 14, (in)[ 0],  4);
	ROUND2(E, A, B, C, D, F2,  6, (in)[ 5],  4);
	ROUND2(D, E, A, B, C, F2,  9, (in)[12],  4);
	ROUND2(C, D, E, A, B, F2, 12, (in)[ 2],  4);
	ROUND2(B, C, D, E, A, F2,  9, (in)[13],  4);
	ROUND2(A, B, C, D, E, F2, 12, (in)[ 9],  4);
	ROUND2(E, A, B, C, D, F2,  5, (in)[ 7],  4);
	ROUND2(D, E, A, B, C, F2, 15, (in)[10],  4);
	ROUND2(C, D, E, A, B, F2,  8, (in)[14],  4);

	ROUND2(B, C, D, E, A, F1,  8, (in)[12],  5);
	ROUND2(A, B, C, D, E, F1,  5, (in)[15],  5);
	ROUND2(E, A, B, C, D, F1, 12, (in)[10],  5);
	ROUND2(D, E, A, B, C, F1,  9, (in)[ 4],  5);
	ROUND2(C, D, E, A, B, F1, 12, (in)[ 1],  5);
	ROUND2(B, C, D, E, A, F1,  5, (in)[ 5],  5);
	ROUND2(A, B, C, D, E, F1, 14, (in)[ 8],  5);
	ROUND2(E, A, B, C, D, F1,  6, (in)[ 7],  5);
	ROUND2(D, E, A, B, C, F1,  8, (in)[ 6],  5);
	ROUND2(C, D, E, A, B, F1, 13, (in)[ 2],  5);
	ROUND2(B, C, D, E, A, F1,  6, (in)[13],  5);
	ROUND2(A, B, C, D, E, F1,  5, (in)[14],  5);
	ROUND2(E, A, B, C, D, F1, 15, (in)[ 0],  5);
	ROUND2(D, E, A, B, C, F1, 13, (in)[ 3],  5);
	ROUND2(C, D, E, A, B, F1, 11, (in)[ 9],  5);
	ROUND2(B, C, D, E, A, F1, 11, (in)[11],  5);

	tmp = (h)[1] + C1 + D2;
	(h)[1] = (h)[2] + D1 + E2;
	(h)[2] = (h)[3] + E1 + A2;
	(h)[3] = (h)[4] + A1 + B2;
	(h)[4] = (h)[0] + B1 + C2;
	(h)[0] = tmp;
}
