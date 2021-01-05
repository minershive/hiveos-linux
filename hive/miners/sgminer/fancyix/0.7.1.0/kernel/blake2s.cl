/*
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2019 fancyIX
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
 * @author   ccminer-blake2s 2019
 * @author   fancyIX 2019
 */



/* threads per block */
#define TPB 512

/* max count of found nonces in one call */
#define NBN 2

#define UINT32_MAX 4294967295
__constant
static uint extra_results[NBN] = { UINT32_MAX };

enum blake2s_constant
{
	BLAKE2S_BLOCKBYTES = 64,
	BLAKE2S_OUTBYTES   = 32,
	BLAKE2S_KEYBYTES   = 32,
	BLAKE2S_SALTBYTES  = 8,
	BLAKE2S_PERSONALBYTES = 8
};

typedef struct __blake2s_state
{
	uint h[8];
	uint t[2];
	uint f[2];
	uchar  buf[2 * BLAKE2S_BLOCKBYTES];
	size_t   buflen;
	uchar  last_node;
} blake2s_state;

typedef struct __blake2s_param
{
	uchar  digest_length; // 1
	uchar  key_length;    // 2
	uchar  fanout;        // 3
	uchar  depth;         // 4
	uint leaf_length;   // 8
	uchar  node_offset[6];// 14
	uchar  node_depth;    // 15
	uchar  inner_length;  // 16
	// uchar  reserved[0];
	uchar  salt[BLAKE2S_SALTBYTES]; // 24
	uchar  personal[BLAKE2S_PERSONALBYTES];  // 32
} blake2s_param;

inline
uint gpu_load32(const void *src) {
	return *(uint *)(src);
}

inline
void gpu_store32(void *dst, uint dw) {
	*(uint *)(dst) = dw;
}

inline
void gpu_store64(void *dst, ulong lw) {
	*(ulong *)(dst) = lw;
}

inline
ulong gpu_load48(const void *src)
{
	const uchar *p = (const uchar *)src;
	ulong w = *p++;
	w |= (ulong)(*p++) << 8;
	w |= (ulong)(*p++) << 16;
	w |= (ulong)(*p++) << 24;
	w |= (ulong)(*p++) << 32;
	w |= (ulong)(*p++) << 40;
	return w;
}

inline
void gpu_blake2s_set_lastnode(blake2s_state *S) {
	S->f[1] = ~0U;
}

inline
void gpu_blake2s_clear_lastnode(blake2s_state *S) {
	S->f[1] = 0U;
}

inline
void gpu_blake2s_increment_counter(blake2s_state *S, const uint inc)
{
	S->t[0] += inc;
	S->t[1] += ( S->t[0] < inc );
}

inline
void gpu_blake2s_set_lastblock(blake2s_state *S)
{
	if (S->last_node) gpu_blake2s_set_lastnode(S);
	S->f[0] = ~0U;
}

void gpu_blake2s_compress0(blake2s_state *S)
{
	uint m[16];
	uint v[16];

	const uint blake2s_IV[8] = {
		0x6A09E667UL, 0xBB67AE85UL, 0x3C6EF372UL, 0xA54FF53AUL,
		0x510E527FUL, 0x9B05688CUL, 0x1F83D9ABUL, 0x5BE0CD19UL
	};

	const uchar blake2s_sigma[10][16] = {
		{  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 },
		{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 },
		{ 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 },
		{  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 },
		{  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 },
		{  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 },
		{ 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 },
		{ 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 },
		{  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 },
		{ 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13 , 0 },
	};

	#pragma unroll
	for(int i = 0; i < 16; i++)
		m[i] = ((uint *)S->buf)[i];

	#pragma unroll
	for(int i = 0; i < 8; i++)
		v[i] = S->h[i];

	v[ 8] = blake2s_IV[0];
	v[ 9] = blake2s_IV[1];
	v[10] = blake2s_IV[2];
	v[11] = blake2s_IV[3];
	v[12] = S->t[0] ^ blake2s_IV[4];
	v[13] = S->t[1] ^ blake2s_IV[5];
	v[14] = S->f[0] ^ blake2s_IV[6];
	v[15] = S->f[1] ^ blake2s_IV[7];

	#define BLAKE2S_G(r,i,a,b,c,d) { \
		a += b + m[blake2s_sigma[r][2*i+0]]; \
		d = SPH_ROTR32(d ^ a, 16); \
		c = c + d; \
		b = SPH_ROTR32(b ^ c, 12); \
		a += b + m[blake2s_sigma[r][2*i+1]]; \
		d = SPH_ROTR32(d ^ a, 8); \
		c = c + d; \
		b = SPH_ROTR32(b ^ c, 7); \
	}

	#define BLAKE2S_ROUND(r) { \
		BLAKE2S_G(r,0,v[ 0],v[ 4],v[ 8],v[12]); \
		BLAKE2S_G(r,1,v[ 1],v[ 5],v[ 9],v[13]); \
		BLAKE2S_G(r,2,v[ 2],v[ 6],v[10],v[14]); \
		BLAKE2S_G(r,3,v[ 3],v[ 7],v[11],v[15]); \
		BLAKE2S_G(r,4,v[ 0],v[ 5],v[10],v[15]); \
		BLAKE2S_G(r,5,v[ 1],v[ 6],v[11],v[12]); \
		BLAKE2S_G(r,6,v[ 2],v[ 7],v[ 8],v[13]); \
		BLAKE2S_G(r,7,v[ 3],v[ 4],v[ 9],v[14]); \
	}

	BLAKE2S_ROUND( 0 );
	BLAKE2S_ROUND( 1 );
	BLAKE2S_ROUND( 2 );
	BLAKE2S_ROUND( 3 );
	BLAKE2S_ROUND( 4 );
	BLAKE2S_ROUND( 5 );
	BLAKE2S_ROUND( 6 );
	BLAKE2S_ROUND( 7 );
	BLAKE2S_ROUND( 8 );
	BLAKE2S_ROUND( 9 );

	#pragma unroll
	for(int i = 0; i < 8; i++)
		S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];

#undef BLAKE2S_G
#undef BLAKE2S_ROUND
}

void inline blake2s_memcpy(blake2s_state *S, uint left, __global const uchar *src, uint len) {
	#pragma unroll
	for (int i = 0; i < len; i++) {
		(S->buf)[left + i] = (src)[i];
	}
}

void inline blake2s_memcpy2(blake2s_state *S) {
	#pragma unroll
	for (int i = 0; i < BLAKE2S_BLOCKBYTES; i++) {
		S->buf[i] = S->buf[BLAKE2S_BLOCKBYTES + i];
	}
}

inline
void gpu_blake2s_update(blake2s_state *S, __global const uchar *in)
{
	const int left = 0;
	size_t fill = 2 * BLAKE2S_BLOCKBYTES;
	blake2s_memcpy(S, left, in, fill);
	S->buflen += fill;
	gpu_blake2s_increment_counter(S, BLAKE2S_BLOCKBYTES);
	gpu_blake2s_compress0(S);
	blake2s_memcpy2(S);
	S->buflen -= BLAKE2S_BLOCKBYTES;
	in += fill;

	#pragma unroll
	for (int inlen = 64 * 24 - 2 * BLAKE2S_BLOCKBYTES; inlen > 0; )
	{
		const int left = BLAKE2S_BLOCKBYTES;
		size_t fill = 2 * BLAKE2S_BLOCKBYTES - left;
		if(inlen > fill)
		{
			blake2s_memcpy(S, left, in, fill); // Fill buffer
			S->buflen += fill;

			gpu_blake2s_increment_counter(S, BLAKE2S_BLOCKBYTES);
			gpu_blake2s_compress0(S); // Compress
			blake2s_memcpy2(S);
			S->buflen -= BLAKE2S_BLOCKBYTES;
			in += fill;
			inlen -= fill;
		}
		else // inlen <= fill
		{
			blake2s_memcpy(S, left, in, fill);
			S->buflen += (size_t) inlen; // Be lazy, do not compress
			in += inlen;
			inlen -= inlen;
		}
	}
}

inline
void gpu_blake2s_final(blake2s_state *S, uint *out)
{

	//if (S->buflen > BLAKE2S_BLOCKBYTES)
	{
		gpu_blake2s_increment_counter(S, BLAKE2S_BLOCKBYTES);
		gpu_blake2s_compress0(S);
		S->buflen -= BLAKE2S_BLOCKBYTES;
		blake2s_memcpy2(S);
	}

	gpu_blake2s_increment_counter(S, (uint)S->buflen);
	gpu_blake2s_set_lastblock(S);
	//memset(&S->buf[S->buflen], 0, 2 * BLAKE2S_BLOCKBYTES - S->buflen);
	//#pragma unroll
	//for (int i = 0; i < (BLAKE2S_BLOCKBYTES)/4; i++)
	//	gpu_store32(S->buf + BLAKE2S_BLOCKBYTES + (4*i), 0);
	gpu_blake2s_compress0(S);

	#pragma unroll
	for (int i = 0; i < 8; i++)
		out[i] = S->h[i];
}

/* init2 xors IV with input parameter block */
inline
void gpu_blake2s_init_param(blake2s_state *S, const blake2s_param *P)
{
	//blake2s_IV
	S->h[0] = 0x6A09E667UL;
	S->h[1] = 0xBB67AE85UL;
	S->h[2] = 0x3C6EF372UL;
	S->h[3] = 0xA54FF53AUL;
	S->h[4] = 0x510E527FUL;
	S->h[5] = 0x9B05688CUL;
	S->h[6] = 0x1F83D9ABUL;
	S->h[7] = 0x5BE0CD19UL;

	S->t[0] = 0; S->t[1] = 0;
	S->f[0] = 0; S->f[1] = 0;
	S->last_node = 0;

	S->buflen = 0;

	#pragma unroll
	for (int i = 0; i < sizeof(S->buf)/4; i++)
		gpu_store32(S->buf + (4*i), 0);

	uint *p = (uint*) P;

	/* IV XOR ParamBlock */
	#pragma unroll
	for (int i = 0; i < 8; i++)
		S->h[i] ^= gpu_load32(&p[i]);
}

// Sequential blake2s initialization
inline
void gpu_blake2s_init(blake2s_state *S, const uchar outlen)
{
	blake2s_param P[1];

	// if (!outlen || outlen > BLAKE2S_OUTBYTES) return;

	P->digest_length = outlen;
	P->key_length    = 0;
	P->fanout        = 1;
	P->depth         = 1;

	P->leaf_length = 0;
	gpu_store64(P->node_offset, 0);
	//P->node_depth    = 0;
	//P->inner_length  = 0;

	gpu_store64(&P->salt, 0);
	gpu_store64(&P->personal, 0);

	gpu_blake2s_init_param(S, P);
}

inline
void gpu_copystate(blake2s_state *dst, blake2s_state *src)
{
	ulong* d64 = (ulong*) dst;
	ulong* s64 = (ulong*) src;
	#pragma unroll
	for (int i=0; i < (32 + 16 + 2 * BLAKE2S_BLOCKBYTES)/8; i++)
		gpu_store64(&d64[i], s64[i]);
	dst->buflen = src->buflen;
	dst->last_node = src->last_node;
}