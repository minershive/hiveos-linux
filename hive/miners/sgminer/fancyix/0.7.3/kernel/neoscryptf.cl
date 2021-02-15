/*
 * Copyright (c) 2020 fancyIX
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

// kernel code from Nanashi Meiyo-Meijin 1.7.6-r10 (July 2016)

#pragma OPENCL EXTENSION cl_amd_media_ops : enable

/*
__device__ uint2x4* W;
__device__ uint2x4* Tr;
__device__ uint2x4* Tr2;
__device__ uint2x4* Input;

__constant__ uint c_data[64];
__constant__ uint c_target[2];
__constant__ uint key_init[16];
__constant__ uint input_init[16];
*/

#define BLOCK_SIZE         64U
#define BLAKE2S_BLOCK_SIZE 64U
#define BLAKE2S_OUT_SIZE   32U

__constant uint8 BLAKE2S_IV_Vec = {
	0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
	0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19
};

__constant uint BLAKE2S_SIGMA[10][16] = {
	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
	{ 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
	{ 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
	{ 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
	{ 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
	{ 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
	{ 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
	{ 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
	{ 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
};

#define rotateR(x, n) rotate((uint)(x), (uint)(32 - (n)))

#define BLAKE_G(idx0, idx1, a, b, c, d, key) { \
	idx = BLAKE2S_SIGMA[idx0][idx1]; a += key[idx]; \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotateR(b^c, 12); \
	idx = BLAKE2S_SIGMA[idx0][idx1+1]; a += key[idx]; \
	a += b; d = rotate((uint)(d^a), (uint)24); \
	c += d; b = rotateR(b^c, 7); \
} 

#define BLAKE(a, b, c, d, key1,key2) { \
	a += key1; \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotateR(b^c, 12); \
	a += key2; \
	a += b; d = rotate((uint)(d^a), (uint)24); \
	c += d; b = rotateR(b^c, 7); \
}

#define BLAKE_G_PRE(idx0,idx1, a, b, c, d, key) { \
	a += key[idx0]; \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotateR(b^c, 12); \
	a += key[idx1]; \
	a += b; d = rotate((uint)(d^a), (uint)24); \
	c += d; b = rotateR(b^c, 7); \
}

#define BLAKE_G_PRE0(idx0,idx1, a, b, c, d, key) { \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotateR(b^c, 12); \
	a += b; d = rotate((uint)(d^a), (uint)24); \
	c += d; b = rotateR(b^c, 7); \
}

#define BLAKE_G_PRE1(idx0,idx1, a, b, c, d, key) { \
	a += key[idx0]; \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotateR(b^c, 12); \
	a += b; d = rotate((uint)(d^a), (uint)24); \
	c += d; b = rotateR(b^c, 7); \
}

#define BLAKE_G_PRE2(idx0,idx1, a, b, c, d, key) { \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotateR(b^c, 12); \
	a += key[idx1]; \
	a += b; d = rotate((uint)(d^a), (uint)24); \
	c += d; b = rotateR(b^c, 7); \
}

static inline
void Blake2S_v2(uint *out, const uint*  inout, const  uint * TheKey)
{
	uint16 V;
	uint8 tmpblock;

	V.hi = BLAKE2S_IV_Vec;
	V.lo = BLAKE2S_IV_Vec;
	V.lo.s0 ^= 0x01012020;

	// Copy input block for later
	tmpblock = V.lo;

	V.hi.s4 ^= BLAKE2S_BLOCK_SIZE;

	//	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
	BLAKE_G_PRE(0, 1, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE(2, 3, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE(4, 5, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE(6, 7, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE0(8, 9, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE0(10, 11, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE0(12, 13, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE0(14, 15, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
	BLAKE_G_PRE0(14, 10, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE1(4, 8, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE0(9, 15, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE2(13, 6, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE1(1, 12, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE(0, 2, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE2(11, 7, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE(5, 3, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
	BLAKE_G_PRE0(11, 8, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE2(12, 0, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE(5, 2, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE0(15, 13, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE0(10, 14, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE(3, 6, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE(7, 1, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE2(9, 4, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
	BLAKE_G_PRE1(7, 9, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE(3, 1, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE0(13, 12, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE0(11, 14, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE(2, 6, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE1(5, 10, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE(4, 0, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE0(15, 8, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
	BLAKE_G_PRE2(9, 0, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE(5, 7, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE(2, 4, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE0(10, 15, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE2(14, 1, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE0(11, 12, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE1(6, 8, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE1(3, 13, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
	BLAKE_G_PRE1(2, 12, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE1(6, 10, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE1(0, 11, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE2(8, 3, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE1(4, 13, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE(7, 5, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE0(15, 14, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE1(1, 9, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
	BLAKE_G_PRE2(12, 5, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE1(1, 15, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE0(14, 13, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE1(4, 10, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE(0, 7, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE(6, 3, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE2(9, 2, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE0(8, 11, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
	BLAKE_G_PRE0(13, 11, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE1(7, 14, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE2(12, 1, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE1(3, 9, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE(5, 0, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE2(15, 4, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE2(8, 6, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE(2, 10, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
	BLAKE_G_PRE1(6, 15, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE0(14, 9, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE2(11, 3, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE1(0, 8, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE2(12, 2, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE2(13, 7, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE(1, 4, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE2(10, 5, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);
	// { 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
	BLAKE_G_PRE2(10, 2, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, TheKey);
	BLAKE_G_PRE2(8, 4, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, TheKey);
	BLAKE_G_PRE(7, 6, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, TheKey);
	BLAKE_G_PRE(1, 5, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, TheKey);
	BLAKE_G_PRE0(15, 11, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, TheKey);
	BLAKE_G_PRE0(9, 14, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, TheKey);
	BLAKE_G_PRE1(3, 12, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, TheKey);
	BLAKE_G_PRE2(13, 0, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, TheKey);

	V.lo ^= V.hi;
	V.lo ^= tmpblock;

	V.hi = BLAKE2S_IV_Vec;
	tmpblock = V.lo;

	V.hi.s4 ^= 128;
	V.hi.s6 = ~V.hi.s6;

	// { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
	BLAKE_G_PRE(0, 1, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout);
	BLAKE_G_PRE(2, 3, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout);
	BLAKE_G_PRE(4, 5, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout);
	BLAKE_G_PRE(6, 7, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout);
	BLAKE_G_PRE(8, 9, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout);
	BLAKE_G_PRE(10, 11, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout);
	BLAKE_G_PRE(12, 13, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout);
	BLAKE_G_PRE(14, 15, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout);
	// { 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
	BLAKE_G_PRE(14, 10, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout);
	BLAKE_G_PRE(4, 8, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout);
	BLAKE_G_PRE(9, 15, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout);
	BLAKE_G_PRE(13, 6, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout);
	BLAKE_G_PRE(1, 12, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout);
	BLAKE_G_PRE(0, 2, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout);
	BLAKE_G_PRE(11, 7, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout);
	BLAKE_G_PRE(5, 3, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout);
	// { 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
	BLAKE_G_PRE(11, 8, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout);
	BLAKE_G_PRE(12, 0, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout);
	BLAKE_G_PRE(5, 2, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout);
	BLAKE_G_PRE(15, 13, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout);
	BLAKE_G_PRE(10, 14, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout);
	BLAKE_G_PRE(3, 6, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout);
	BLAKE_G_PRE(7, 1, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout);
	BLAKE_G_PRE(9, 4, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout);
	// { 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
	BLAKE_G_PRE(7, 9, V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout);
	BLAKE_G_PRE(3, 1, V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout);
	BLAKE_G_PRE(13, 12, V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout);
	BLAKE_G_PRE(11, 14, V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout);
	BLAKE_G_PRE(2, 6, V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout);
	BLAKE_G_PRE(5, 10, V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout);
	BLAKE_G_PRE(4, 0, V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout);
	BLAKE_G_PRE(15, 8, V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout);

	BLAKE(V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout[9], inout[0]);
	BLAKE(V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout[5], inout[7]);
	BLAKE(V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout[2], inout[4]);
	BLAKE(V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout[10], inout[15]);
	BLAKE(V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout[14], inout[1]);
	BLAKE(V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout[11], inout[12]);
	BLAKE(V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout[6], inout[8]);
	BLAKE(V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout[3], inout[13]);

	BLAKE(V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout[2], inout[12]);
	BLAKE(V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout[6], inout[10]);
	BLAKE(V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout[0], inout[11]);
	BLAKE(V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout[8], inout[3]);
	BLAKE(V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout[4], inout[13]);
	BLAKE(V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout[7], inout[5]);
	BLAKE(V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout[15], inout[14]);
	BLAKE(V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout[1], inout[9]);

	BLAKE(V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout[12], inout[5]);
	BLAKE(V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout[1], inout[15]);
	BLAKE(V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout[14], inout[13]);
	BLAKE(V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout[4], inout[10]);
	BLAKE(V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout[0], inout[7]);
	BLAKE(V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout[6], inout[3]);
	BLAKE(V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout[9], inout[2]);
	BLAKE(V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout[8], inout[11]);
	// 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10,
	BLAKE(V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout[13], inout[11]);
	BLAKE(V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout[7], inout[14]);
	BLAKE(V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout[12], inout[1]);
	BLAKE(V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout[3], inout[9]);
	BLAKE(V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout[5], inout[0]);
	BLAKE(V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout[15], inout[4]);
	BLAKE(V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout[8], inout[6]);
	BLAKE(V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout[2], inout[10]);
	// 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5,
	BLAKE(V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout[6], inout[15]);
	BLAKE(V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout[14], inout[9]);
	BLAKE(V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout[11], inout[3]);
	BLAKE(V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout[0], inout[8]);
	BLAKE(V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout[12], inout[2]);
	BLAKE(V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout[13], inout[7]);
	BLAKE(V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout[1], inout[4]);
	BLAKE(V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout[10], inout[5]);
	// 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0,
	BLAKE(V.lo.s0, V.lo.s4, V.hi.s0, V.hi.s4, inout[10], inout[2]);
	BLAKE(V.lo.s1, V.lo.s5, V.hi.s1, V.hi.s5, inout[8], inout[4]);
	BLAKE(V.lo.s2, V.lo.s6, V.hi.s2, V.hi.s6, inout[7], inout[6]);
	BLAKE(V.lo.s3, V.lo.s7, V.hi.s3, V.hi.s7, inout[1], inout[5]);
	BLAKE(V.lo.s0, V.lo.s5, V.hi.s2, V.hi.s7, inout[15], inout[11]);
	BLAKE(V.lo.s1, V.lo.s6, V.hi.s3, V.hi.s4, inout[9], inout[14]);
	BLAKE(V.lo.s2, V.lo.s7, V.hi.s0, V.hi.s5, inout[3], inout[12]);
	BLAKE(V.lo.s3, V.lo.s4, V.hi.s1, V.hi.s6, inout[13], inout[0]);

	V.lo ^= V.hi;
	V.lo ^= tmpblock;

	((uint8*)out)[0] = V.lo;
}

#define SHL32(a,n) (amd_bitalign((a), bitselect(0U,     (a), (amd_bitalign(0U, ~0U, (n)))), (32U - (n))))
#define SHR32(a,n) (amd_bitalign(0U,  bitselect((a),     0U, (amd_bitalign(0U, ~0U, (32U - (n))))), (n)))
#define SHFRC32(a,b,n) (amd_bitalign((b), bitselect((a),     (b), (amd_bitalign(0U, ~0U, (32U - (n))))), (n)))
#define SHFRC32S(a,b,n) (amd_bitalign((b), (a), (n)))

static inline
void fastkdf256_v2(const uint thread, const uint nonce, __local uint* s_data,
    __global uint *c_data, __global uint *input_init, __global uint8 *Input)
{
	const uint data18 = c_data[18];
	const uint data20 = c_data[0];
	uint input[16];
	uint key[16] = { 0 };
	uint qbuf, rbuf, bitbuf;

	__local uint* B = (__local uint*)&s_data[get_local_id(0) * 64U];
    #pragma unroll
    for (int i = 0; i < 4; i++) {
        ((__local uint16 *) (B))[i] = ((__global uint16 *) (c_data))[i];
    }

	B[19] = nonce;
	B[39] = nonce;
	B[59] = nonce;

	{
		uint bufidx = 0;
		#pragma unroll
		for (int x = 0; x < BLAKE2S_OUT_SIZE / 4; ++x)
		{
			uint bufhelper = (input_init[x] & 0x00ff00ff) + ((input_init[x] & 0xff00ff00) >> 8);
			bufhelper = bufhelper + (bufhelper >> 16);
			bufidx += bufhelper;
		}
		bufidx &= 0x000000ff;
		qbuf = bufidx >> 2;
		rbuf = bufidx & 3;
		bitbuf = rbuf << 3;

		uint temp[9];

		uint shifted;
		uint shift = 32U - bitbuf;
		shifted = SHL32(input_init[0], bitbuf);
		temp[0] = B[(0 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[0], input_init[1], shift);
		temp[1] = B[(1 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[1], input_init[2], shift);
		temp[2] = B[(2 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[2], input_init[3], shift);
		temp[3] = B[(3 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[3], input_init[4], shift);
		temp[4] = B[(4 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[4], input_init[5], shift);
		temp[5] = B[(5 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[5], input_init[6], shift);
		temp[6] = B[(6 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input_init[6], input_init[7], shift);
		temp[7] = B[(7 + qbuf) & 0x3f] ^ shifted;
		shifted = SHR32(input_init[7], shift);
		temp[8] = B[(8 + qbuf) & 0x3f] ^ shifted;

		uint a = c_data[qbuf & 0x3f], b;

		#pragma unroll
		for (int k = 0; k<16; k += 2)
		{
			b = c_data[(qbuf + k + 1) & 0x3f];
			input[k] = SHFRC32S(a, b, bitbuf);
			a = c_data[(qbuf + k + 2) & 0x3f];
			input[k + 1] = SHFRC32S(b, a, bitbuf);
		}

		const uint noncepos = 19 - qbuf % 20U;
		if (noncepos <= 16U && qbuf < 60U)
		{
			if (noncepos)
				input[noncepos - 1] = SHFRC32S(data18, nonce, bitbuf);
			if (noncepos != 16U)
				input[noncepos] = SHFRC32S(nonce, data20, bitbuf);
		}

		key[0] = SHFRC32S(temp[0], temp[1], bitbuf);
		key[1] = SHFRC32S(temp[1], temp[2], bitbuf);
		key[2] = SHFRC32S(temp[2], temp[3], bitbuf);
		key[3] = SHFRC32S(temp[3], temp[4], bitbuf);
		key[4] = SHFRC32S(temp[4], temp[5], bitbuf);
		key[5] = SHFRC32S(temp[5], temp[6], bitbuf);
		key[6] = SHFRC32S(temp[6], temp[7], bitbuf);
		key[7] = SHFRC32S(temp[7], temp[8], bitbuf);

        uint temp_out[8];
		Blake2S_v2(temp_out, input, key);
		#pragma unroll
		for (int ii = 0; ii < 8; ii++) {
			input[ii] = temp_out[ii];
		}

		#pragma unroll
		for (int k = 0; k < 9; k++)
			B[(k + qbuf) & 0x3f] = temp[k];
	}

	for (int i = 1; i < 31; i++)
	{
		uint bufidx = 0;
		#pragma unroll
		for (int x = 0; x < BLAKE2S_OUT_SIZE / 4; ++x)
		{
			uint bufhelper = (input[x] & 0x00ff00ff) + ((input[x] & 0xff00ff00) >> 8);
			bufhelper = bufhelper + (bufhelper >> 16);
			bufidx += bufhelper;
		}
		bufidx &= 0x000000ff;
		qbuf = bufidx >> 2;
		rbuf = bufidx & 3;
		bitbuf = rbuf << 3;

		uint temp[9];

		uint shifted;
		uint shift = 32U - bitbuf;
		shifted = SHL32(input[0], bitbuf);
		temp[0] = B[(0 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[0], input[1], shift);
		temp[1] = B[(1 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[1], input[2], shift);
		temp[2] = B[(2 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[2], input[3], shift);
		temp[3] = B[(3 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[3], input[4], shift);
		temp[4] = B[(4 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[4], input[5], shift);
		temp[5] = B[(5 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[5], input[6], shift);
		temp[6] = B[(6 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[6], input[7], shift);
		temp[7] = B[(7 + qbuf) & 0x3f] ^ shifted;
		shifted = SHR32(input[7], shift);
		temp[8] = B[(8 + qbuf) & 0x3f] ^ shifted;

		uint a = c_data[qbuf & 0x3f], b;

		#pragma unroll
		for (int k = 0; k<16; k += 2)
		{
			b = c_data[(qbuf + k + 1) & 0x3f];
			input[k] = SHFRC32S(a, b, bitbuf);
			a = c_data[(qbuf + k + 2) & 0x3f];
			input[k + 1] = SHFRC32S(b, a, bitbuf);
		}

		const uint noncepos = 19 - qbuf % 20U;
		if (noncepos <= 16U && qbuf < 60U)
		{
			if (noncepos)
				input[noncepos - 1] = SHFRC32S(data18, nonce, bitbuf);
			if (noncepos != 16U)
				input[noncepos] = SHFRC32S(nonce, data20, bitbuf);
		}

		key[0] = SHFRC32S(temp[0], temp[1], bitbuf);
		key[1] = SHFRC32S(temp[1], temp[2], bitbuf);
		key[2] = SHFRC32S(temp[2], temp[3], bitbuf);
		key[3] = SHFRC32S(temp[3], temp[4], bitbuf);
		key[4] = SHFRC32S(temp[4], temp[5], bitbuf);
		key[5] = SHFRC32S(temp[5], temp[6], bitbuf);
		key[6] = SHFRC32S(temp[6], temp[7], bitbuf);
		key[7] = SHFRC32S(temp[7], temp[8], bitbuf);

        uint temp_out[8];
		Blake2S_v2(temp_out, input, key);
		#pragma unroll
		for (int ii = 0; ii < 8; ii++) {
			input[ii] = temp_out[ii];
		}

		#pragma unroll
		for (int k = 0; k < 9; k++)
			B[(k + qbuf) & 0x3f] = temp[k];
	}

	{
		uint bufidx = 0;
		#pragma unroll
		for (int x = 0; x < BLAKE2S_OUT_SIZE / 4; ++x)
		{
			uint bufhelper = (input[x] & 0x00ff00ff) + ((input[x] & 0xff00ff00) >> 8);
			bufhelper = bufhelper + (bufhelper >> 16);
			bufidx += bufhelper;
		}
		bufidx &= 0x000000ff;
		qbuf = bufidx >> 2;
		rbuf = bufidx & 3;
		bitbuf = rbuf << 3;
	}

	uint8 output[8];
	#pragma unroll
	for (int i = 0; i<64; i++) {
		const uint a = (qbuf + i) & 0x3f, b = (qbuf + i + 1) & 0x3f;
		((uint*)output)[i] = SHFRC32S(B[a], B[b], bitbuf);
	}

	output[0] ^= ((uint8*)input)[0];
	#pragma unroll
	for (int i = 0; i<8; i++)
		output[i] ^= ((__global uint8*)c_data)[i];

	((uint*)output)[19] ^= nonce;
	((uint*)output)[39] ^= nonce;
	((uint*)output)[59] ^= nonce;;
	#pragma unroll
	for (int i = 0; i < 8; i++) {
		((__global uint8 *)(Input + 8U * thread))[i] = output[i];
	}
}

static inline
uint fastkdf32_v3(uint thread, const uint nonce, uint* const salt, __local uint* const s_data, __global uint *c_data)
{
	const uint cdata7 = c_data[7];
	const uint data18 = c_data[18];
	const uint data20 = c_data[0];

	__local uint* B0 = (__local uint*)&s_data[get_local_id(0) * 64U];
	#pragma unroll
    for (int i = 0; i < 4; i++) {
        ((__local uint16 *) (B0))[i] = ((uint16 *) (salt))[i];
    }

	uint input[BLAKE2S_BLOCK_SIZE / 4];
	((uint16*)input)[0] = ((__global uint16*)c_data)[0];

	uint key[BLAKE2S_BLOCK_SIZE / 4];
	((uint8*)key)[0] = ((uint8*)salt)[0];
	((uint4*)key)[2] = (uint4)(0, 0, 0, 0);
	((uint4*)key)[3] = (uint4)(0, 0, 0, 0);

	uint qbuf, rbuf, bitbuf;
	uint temp[9];

	#pragma nounroll
	for (int i = 0; i < 31; i++)
	{
		Blake2S_v2(input, input, key);

		uint bufidx = 0;
		#pragma unroll
		for (int x = 0; x < BLAKE2S_OUT_SIZE / 4; ++x)
		{
			uint bufhelper = (input[x] & 0x00ff00ff) + ((input[x] & 0xff00ff00) >> 8);
			bufhelper = bufhelper + (bufhelper >> 16);
			bufidx += bufhelper;
		}
		bufidx &= 0x000000ff;
		qbuf = bufidx >> 2;
		rbuf = bufidx & 3;
		bitbuf = rbuf << 3;

		uint shifted;
		uint shift = 32U - bitbuf;
		shifted = SHL32(input[0], bitbuf);
		temp[0] = B0[(0 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[0], input[1], shift);
		temp[1] = B0[(1 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[1], input[2], shift);
		temp[2] = B0[(2 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[2], input[3], shift);
		temp[3] = B0[(3 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[3], input[4], shift);
		temp[4] = B0[(4 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[4], input[5], shift);
		temp[5] = B0[(5 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[5], input[6], shift);
		temp[6] = B0[(6 + qbuf) & 0x3f] ^ shifted;
		shifted = SHFRC32(input[6], input[7], shift);
		temp[7] = B0[(7 + qbuf) & 0x3f] ^ shifted;
		shifted = SHR32(input[7], shift);
		temp[8] = B0[(8 + qbuf) & 0x3f] ^ shifted;

		uint a = c_data[qbuf & 0x3f], b;
		#pragma unroll
		for (int k = 0; k<16; k += 2)
		{
			b = c_data[(qbuf + k + 1) & 0x3f];
			input[k] = SHFRC32S(a, b, bitbuf);
			a = c_data[(qbuf + k + 2) & 0x3f];
			input[k + 1] = SHFRC32S(b, a, bitbuf);
		}

		const uint noncepos = 19U - qbuf % 20U;
		if (noncepos <= 16U && qbuf < 60U)
		{
			if (noncepos != 0)
				input[noncepos - 1] = SHFRC32S(data18, nonce, bitbuf);
			if (noncepos != 16U)
				input[noncepos] = SHFRC32S(nonce, data20, bitbuf);
		}

		key[0] = SHFRC32S(temp[0], temp[1], bitbuf);
		key[1] = SHFRC32S(temp[1], temp[2], bitbuf);
		key[2] = SHFRC32S(temp[2], temp[3], bitbuf);
		key[3] = SHFRC32S(temp[3], temp[4], bitbuf);
		key[4] = SHFRC32S(temp[4], temp[5], bitbuf);
		key[5] = SHFRC32S(temp[5], temp[6], bitbuf);
		key[6] = SHFRC32S(temp[6], temp[7], bitbuf);
		key[7] = SHFRC32S(temp[7], temp[8], bitbuf);

		#pragma unroll
		for (int k = 0; k < 9; k++) {
			B0[(k + qbuf) & 0x3f] = temp[k];
		}
	}

	Blake2S_v2(input, input, key);

	uint bufidx = 0;
	#pragma unroll
	for (int x = 0; x < BLAKE2S_OUT_SIZE / 4; ++x)
	{
		uint bufhelper = (input[x] & 0x00ff00ff) + ((input[x] & 0xff00ff00) >> 8);
		bufhelper = bufhelper + (bufhelper >> 16);
		bufidx += bufhelper;
	}
	bufidx &= 0x000000ff;
	qbuf = bufidx >> 2;
	rbuf = bufidx & 3;
	bitbuf = rbuf << 3;

	temp[7] = B0[(qbuf + 7) & 0x3f];
	temp[8] = B0[(qbuf + 8) & 0x3f];

	uint output;
	output = SHFRC32S(temp[7], temp[8], bitbuf);
	output ^= input[7] ^ cdata7;
	return output;
}

#define SALSA(a,b,c,d) { \
	t = rotate((uint)(a+d), (uint)( 7U)); b ^= t; \
	t = rotate((uint)(b+a), (uint)( 9U)); c ^= t; \
	t = rotate((uint)(c+b), (uint)(13U)); d ^= t; \
	t = rotate((uint)(d+c), (uint)(18U)); a ^= t; \
}

#define SALSA_CORE(state) { \
	uint t; \
	SALSA(state.x, state.y, state.z, state.w); \
		__asm ( \
          "s_nop 0\n" \
	      "s_nop 0\n" \
		  "v_mov_b32_dpp  %[d0], %[a0] quad_perm:[3,0,1,2]\n" \
	      "v_mov_b32_dpp  %[d1], %[a1] quad_perm:[2,3,0,1]\n" \
		  "v_mov_b32_dpp  %[d2], %[a2] quad_perm:[1,2,3,0]\n" \
		  "s_nop 0\n" \
          "s_nop 0" \
		  : [d0] "=v" (state.y), \
		    [d1] "=v" (state.z), \
			[d2] "=v" (state.w) \
		  : [a0] "0" (state.y), \
			[a1] "1" (state.z), \
			[a2] "2" (state.w)); \
	SALSA(state.x, state.w, state.z, state.y); \
		__asm ( \
          "s_nop 0\n" \
	      "s_nop 0\n" \
		  "v_mov_b32_dpp  %[d0], %[a0] quad_perm:[1,2,3,0]\n" \
	      "v_mov_b32_dpp  %[d1], %[a1] quad_perm:[2,3,0,1]\n" \
		  "v_mov_b32_dpp  %[d2], %[a2] quad_perm:[3,0,1,2]\n" \
		  "s_nop 0\n" \
          "s_nop 0" \
		  : [d0] "=v" (state.y), \
		    [d1] "=v" (state.z), \
			[d2] "=v" (state.w) \
		  : [a0] "0" (state.y), \
			[a1] "1" (state.z), \
			[a2] "2" (state.w)); \
}

uint4 salsa_small_scalar_rnd(const uint4 X)
{
	uint4 state = X;

	#pragma nounroll
	for (int i = 0; i < 10; i++) {
		SALSA_CORE(state);
	}

	return (X + state);
}

void inline neoscrypt_salsa(uint4 XV[4])
{
	uint4 temp;

	XV[0] = salsa_small_scalar_rnd(XV[0] ^ XV[3]);
	temp = salsa_small_scalar_rnd(XV[1] ^ XV[0]);
	XV[1] = salsa_small_scalar_rnd(XV[2] ^ temp);
	XV[3] = salsa_small_scalar_rnd(XV[3] ^ XV[1]);
	XV[2] = temp;
}

#define CHACHA_STEP(a,b,c,d) { \
	a += b; d = rotate((uint)(d^a), (uint)16); \
	c += d; b = rotate((uint)(b^c), (uint)12); \
	a += b; d = rotate((uint)(d^a), (uint)8); \
	c += d; b = rotate((uint)(b^c), (uint)7); \
}

#define CHACHA_CORE_PARALLEL(state)	{ \
	CHACHA_STEP(state.x, state.y, state.z, state.w); \
		__asm ( \
          "s_nop 0\n" \
	      "s_nop 0\n" \
		  "v_mov_b32_dpp  %[d0], %[a0] quad_perm:[1,2,3,0]\n" \
	      "v_mov_b32_dpp  %[d1], %[a1] quad_perm:[2,3,0,1]\n" \
		  "v_mov_b32_dpp  %[d2], %[a2] quad_perm:[3,0,1,2]\n" \
		  "s_nop 0\n" \
          "s_nop 0" \
		  : [d0] "=v" (state.y), \
		    [d1] "=v" (state.z), \
			[d2] "=v" (state.w) \
		  : [a0] "0" (state.y), \
			[a1] "1" (state.z), \
			[a2] "2" (state.w)); \
	CHACHA_STEP(state.x, state.y, state.z, state.w); \
		__asm ( \
          "s_nop 0\n" \
	      "s_nop 0\n" \
		  "v_mov_b32_dpp  %[d0], %[a0] quad_perm:[3,0,1,2]\n" \
	      "v_mov_b32_dpp  %[d1], %[a1] quad_perm:[2,3,0,1]\n" \
		  "v_mov_b32_dpp  %[d2], %[a2] quad_perm:[1,2,3,0]\n" \
		  "s_nop 0\n" \
          "s_nop 0" \
		  : [d0] "=v" (state.y), \
		    [d1] "=v" (state.z), \
			[d2] "=v" (state.w) \
		  : [a0] "0" (state.y), \
			[a1] "1" (state.z), \
			[a2] "2" (state.w)); \
}

uint4 inline chacha_small_parallel_rnd(const uint4 X)
{
	uint4 state = X;

	#pragma nounroll
	for (int i = 0; i < 10; i++) {
		CHACHA_CORE_PARALLEL(state);
	}
	return (X + state);
}

void inline neoscrypt_chacha(uint4 XV[4])
{
	uint4 temp;

	XV[0] = chacha_small_parallel_rnd(XV[0] ^ XV[3]);
	temp = chacha_small_parallel_rnd(XV[1] ^ XV[0]);
	XV[1] = chacha_small_parallel_rnd(XV[2] ^ temp);
	XV[3] = chacha_small_parallel_rnd(XV[3] ^ XV[1]);
	XV[2] = temp;
}

#define SHIFT 128U
#define TPB 32
#define TPB2 64

__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void neoscrypt_gpu_hash_start(__global uint *c_data, __global uint *input_init, __global uint8 *Input)
{
	__local uint s_data[64 * TPB2];

	const uint thread = get_global_id(0) - get_global_offset(0);
	const uint nonce = get_global_id(0);
	const uint ZNonce = nonce; //freaking morons !!!

	fastkdf256_v2(thread, ZNonce, s_data, c_data, input_init, Input);
}

__attribute__((reqd_work_group_size(8, 8, 1)))
__kernel void neoscrypt_gpu_hash_salsa1(__global uint8 *W, __global uint8 *Tr2, __global uint8 *Input)
{
	const uint thread =  (get_local_size(1) * (get_group_id(0) * 2 + (get_local_id(0) >> 2)) + get_local_id(1));
	const uint shift = SHIFT * 8U * (thread & (MAX_GLOBAL_THREADS - 1));
	const uint shiftTr = 8U * thread;

	uint4 Z[4];
	#pragma unroll
	for (int i = 0; i < 4; i++)
	{
		Z[i].x = *(((__global uint*)&(Input + shiftTr)[i * 2]) + ((0 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3));
		Z[i].y = *(((__global uint*)&(Input + shiftTr)[i * 2]) + ((1 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3));
		Z[i].z = *(((__global uint*)&(Input + shiftTr)[i * 2]) + ((2 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3));
		Z[i].w = *(((__global uint*)&(Input + shiftTr)[i * 2]) + ((3 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3));
	}

	#pragma nounroll
	for (int i = 0; i < 128; i++)
	{
		uint offset = MAX_GLOBAL_THREADS * i * 8U + 8U * (thread & (MAX_GLOBAL_THREADS - 1)); //shift + i * 8U;
		#pragma unroll
		for (int j = 0; j < 4; j++)
			((__global uint4*)(W + offset))[j * 4 + (get_local_id(0) & 3)] = Z[j];
		neoscrypt_salsa(Z);
	}

	#pragma nounroll
	for (int t = 0; t < 128; t++)
	{
		uint offset;
            __asm (
	            "s_nop 0\n"
		        "v_mov_b32_dpp  %[d], %[a] quad_perm:[0,0,0,0]\n"
		        "s_nop 0"
                : [d] "=v" (offset)
                : [a] "v" (Z[3].x));
		offset = MAX_GLOBAL_THREADS * (offset & 0x7F) * 8U + 8U * (thread & (MAX_GLOBAL_THREADS - 1)); //shift + (offset & 0x7F) * 8U;
		#pragma unroll
		for (int j = 0; j < 4; j++)
			Z[j] ^= ((__global uint4*)(W + offset))[j * 4 + (get_local_id(0) & 3)];
		neoscrypt_salsa(Z);
	}
	#pragma unroll
	for (int i = 0; i < 4; i++)
	{
		*((global uint*)&(Tr2 + shiftTr)[i * 2] + ((0 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3)) = Z[i].x;
		*((global uint*)&(Tr2 + shiftTr)[i * 2] + ((1 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3)) = Z[i].y;
		*((global uint*)&(Tr2 + shiftTr)[i * 2] + ((2 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3)) = Z[i].z;
		*((global uint*)&(Tr2 + shiftTr)[i * 2] + ((3 + (get_local_id(0) & 3)) & 3) * 4 + (get_local_id(0) & 3)) = Z[i].w;
	}
}

__attribute__((reqd_work_group_size(8, 8, 1)))
__kernel void neoscrypt_gpu_hash_chacha1(__global uint8 *W, __global uint8 *Tr, __global uint8 *Input)
{
	const uint thread = (get_local_size(1) * (get_group_id(0) * 2 + (get_local_id(0) >> 2)) + get_local_id(1));
	const uint shift = SHIFT * 8U * (thread & (MAX_GLOBAL_THREADS - 1));
	const uint shiftTr = 8U * thread;

	uint4 X[4];
	#pragma unroll
	for (int i = 0; i < 4; i++)
	{
		X[i].x = *((__global uint*)&(Input + shiftTr)[i * 2] + 0 * 4 + (get_local_id(0) & 3));
		X[i].y = *((__global uint*)&(Input + shiftTr)[i * 2] + 1 * 4 + (get_local_id(0) & 3));
		X[i].z = *((__global uint*)&(Input + shiftTr)[i * 2] + 2 * 4 + (get_local_id(0) & 3));
		X[i].w = *((__global uint*)&(Input + shiftTr)[i * 2] + 3 * 4 + (get_local_id(0) & 3));
	}

	#pragma nounroll
	for (int i = 0; i < 128; i++)
	{
		uint offset = MAX_GLOBAL_THREADS * i * 8U + 8U * (thread & (MAX_GLOBAL_THREADS - 1)); //shift + i * 8U;
		#pragma unroll
		for (int j = 0; j < 4; j++)
			((__global uint4*)(W + offset))[j * 4 + (get_local_id(0) & 3)] = X[j];
		neoscrypt_chacha(X);
	}

	#pragma nounroll
	for (int t = 0; t < 128; t++)
	{
		uint offset;
            __asm (
	            "s_nop 0\n"
		        "v_mov_b32_dpp  %[d], %[a] quad_perm:[0,0,0,0]\n"
		        "s_nop 0"
                : [d] "=v" (offset)
                : [a] "v" (X[3].x));
		offset = MAX_GLOBAL_THREADS * (offset & 0x7F) * 8U + 8U * (thread & (MAX_GLOBAL_THREADS - 1)); //shift + (offset & 0x7F) * 8U;
		#pragma unroll
		for (int j = 0; j < 4; j++)
			X[j] ^= ((__global uint4*)(W + offset))[j * 4 + (get_local_id(0) & 3)];
		neoscrypt_chacha(X);
	}

	#pragma unroll
	for (int i = 0; i < 4; i++)
	{
		*((__global uint*)&(Tr + shiftTr)[i * 2] + 0 * 4 + (get_local_id(0) & 3)) = X[i].x;
		*((__global uint*)&(Tr + shiftTr)[i * 2] + 1 * 4 + (get_local_id(0) & 3)) = X[i].y;
		*((__global uint*)&(Tr + shiftTr)[i * 2] + 2 * 4 + (get_local_id(0) & 3)) = X[i].z;
		*((__global uint*)&(Tr + shiftTr)[i * 2] + 3 * 4 + (get_local_id(0) & 3)) = X[i].w;
	}
}

__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void neoscrypt_gpu_hash_ending(__global uint *c_data, __global uint8 *Tr, __global uint8 *Tr2, __global uint *output, const uint target)
{
	__local uint s_data[64 * TPB2];

	const uint thread = get_global_id(0) - get_global_offset(0);
	const uint shiftTr = thread * 8U;
	const uint nonce = get_global_id(0);
	const uint ZNonce = nonce;

	uint8 Z[8];
	#pragma unroll
	for (int i = 0; i<8; i++)
		Z[i] = (Tr2 + shiftTr)[i] ^ (Tr + shiftTr)[i];

	uint outbuf = fastkdf32_v3(thread, ZNonce, (uint*)Z, s_data, c_data);

#define NEOSCRYPT_FOUND (0xFF)
#ifdef cl_khr_global_int32_base_atomics
    #define SETFOUND(nonce) output[atomic_add(&output[NEOSCRYPT_FOUND], 1)] = nonce
#else
    #define SETFOUND(nonce) output[output[NEOSCRYPT_FOUND]++] = nonce
#endif

    if(outbuf <= target) SETFOUND(nonce);
}
