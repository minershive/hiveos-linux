/*
* "yescrypt" kernel implementation.
*
* ==========================(LICENSE BEGIN)============================
*
* Copyright (c) 2020  fancyIX
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
* @author   fancyIX
*/

#define ROTR32(a,b) (((a) >> (b)) | ((a) << (32 - b)))
#define ROTL(x, n)      (((x) << (n)) | ((x) >> (32 - (n))))
#define SWAP32(a)    (as_uint(as_uchar4(a).wzyx))
#define cuda_swab32(a) SWAP32(a)

static __constant uint c_K[64] = {
	0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5,
	0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174,
	0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
	0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967,
	0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85,
	0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
	0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3,
	0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, 0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2
};

#define xor3b(a,b,c) ((a) ^ (b) ^ (c))
#define xandx(a, b, c) ((((b) ^ (c)) & (a)) ^ (c))
#define andor32(a, b, c) (((b) & (c)) | (((b) | (c)) & (a)))

static uint inline bsg2_0(const uint x)
{
	return xor3b(ROTR32(x, 2), ROTR32(x, 13), ROTR32(x, 22));
}

static uint inline bsg2_1(const uint x)
{
	return xor3b(ROTR32(x, 6), ROTR32(x, 11), ROTR32(x, 25));
}

static uint inline ssg2_0(const uint x)
{
	return xor3b(ROTR32(x, 7), ROTR32(x, 18), (x >> 3));
}

static uint inline ssg2_1(const uint x)
{
	return xor3b(ROTR32(x, 17), ROTR32(x, 19), (x >> 10));
}

static void inline sha2_step1(uint a, uint b, uint c, uint *pd, uint e, uint f, uint g, uint *ph,
	uint in, const uint Kshared)
{
	*ph += bsg2_1(e) + xandx(e, f, g) + Kshared + in;
	*pd += *ph;
	*ph += bsg2_0(a) + andor32(a, b, c);
}

static void inline sha2_step2(uint a, uint b, uint c, uint *pd, uint e, uint f, uint g, uint *ph,
	uint* in, uint pc, const uint Kshared)
{
	in[pc] += ssg2_1(in[(pc - 2) & 0xF]) + in[(pc - 7) & 0xF] + ssg2_0(in[(pc - 15) & 0xF]);

	sha2_step1(a, b, c, pd, e, f, g, ph, in[pc], Kshared);
}

static inline void sha256_round_body(uint *in, uint *state)
{
	uint a = state[0];
	uint b = state[1];
	uint c = state[2];
	uint d = state[3];
	uint e = state[4];
	uint f = state[5];
	uint g = state[6];
	uint h = state[7];

	sha2_step1(a, b, c, &d, e, f, g, &h, in[0], c_K[0]);
	sha2_step1(h, a, b, &c, d, e, f, &g, in[1], c_K[1]);
	sha2_step1(g, h, a, &b, c, d, e, &f, in[2], c_K[2]);
	sha2_step1(f, g, h, &a, b, c, d, &e, in[3], c_K[3]);
	sha2_step1(e, f, g, &h, a, b, c, &d, in[4], c_K[4]);
	sha2_step1(d, e, f, &g, h, a, b, &c, in[5], c_K[5]);
	sha2_step1(c, d, e, &f, g, h, a, &b, in[6], c_K[6]);
	sha2_step1(b, c, d, &e, f, g, h, &a, in[7], c_K[7]);
	sha2_step1(a, b, c, &d, e, f, g, &h, in[8], c_K[8]);
	sha2_step1(h, a, b, &c, d, e, f, &g, in[9], c_K[9]);
	sha2_step1(g, h, a, &b, c, d, e, &f, in[10], c_K[10]);
	sha2_step1(f, g, h, &a, b, c, d, &e, in[11], c_K[11]);
	sha2_step1(e, f, g, &h, a, b, c, &d, in[12], c_K[12]);
	sha2_step1(d, e, f, &g, h, a, b, &c, in[13], c_K[13]);
	sha2_step1(c, d, e, &f, g, h, a, &b, in[14], c_K[14]);
	sha2_step1(b, c, d, &e, f, g, h, &a, in[15], c_K[15]);

#pragma unroll
	for (int i = 0; i < 3; i++)
	{
		sha2_step2(a, b, c, &d, e, f, g, &h, in, 0, c_K[16 + 16 * i]);
		sha2_step2(h, a, b, &c, d, e, f, &g, in, 1, c_K[17 + 16 * i]);
		sha2_step2(g, h, a, &b, c, d, e, &f, in, 2, c_K[18 + 16 * i]);
		sha2_step2(f, g, h, &a, b, c, d, &e, in, 3, c_K[19 + 16 * i]);
		sha2_step2(e, f, g, &h, a, b, c, &d, in, 4, c_K[20 + 16 * i]);
		sha2_step2(d, e, f, &g, h, a, b, &c, in, 5, c_K[21 + 16 * i]);
		sha2_step2(c, d, e, &f, g, h, a, &b, in, 6, c_K[22 + 16 * i]);
		sha2_step2(b, c, d, &e, f, g, h, &a, in, 7, c_K[23 + 16 * i]);
		sha2_step2(a, b, c, &d, e, f, g, &h, in, 8, c_K[24 + 16 * i]);
		sha2_step2(h, a, b, &c, d, e, f, &g, in, 9, c_K[25 + 16 * i]);
		sha2_step2(g, h, a, &b, c, d, e, &f, in, 10, c_K[26 + 16 * i]);
		sha2_step2(f, g, h, &a, b, c, d, &e, in, 11, c_K[27 + 16 * i]);
		sha2_step2(e, f, g, &h, a, b, c, &d, in, 12, c_K[28 + 16 * i]);
		sha2_step2(d, e, f, &g, h, a, b, &c, in, 13, c_K[29 + 16 * i]);
		sha2_step2(c, d, e, &f, g, h, a, &b, in, 14, c_K[30 + 16 * i]);
		sha2_step2(b, c, d, &e, f, g, h, &a, in, 15, c_K[31 + 16 * i]);
	}

	state[0] += a;
	state[1] += b;
	state[2] += c;
	state[3] += d;
	state[4] += e;
	state[5] += f;
	state[6] += g;
	state[7] += h;
}

#define sha256dev(a) sha256[thread * 8 + (a)]
#define Bdev(a, b) B[((a) * threads + thread) * 16 + (b)]

__attribute__((reqd_work_group_size(32, 1, 1)))
__kernel void yescrypt_gpu_hash_k0(__global const uint * restrict cpu_h, __global const uint* restrict input, __global uint* B, __global uint* sha256, const uint threads)
{
    int thread = get_global_id(0) % MAX_GLOBAL_THREADS;
    int r = 8;
    int p = 1;

    uint nonce = thread;
    uint in[16];
    uint result[16];
    uint state1[8], state2[8];
    uint passwd[8];
    uint  c_data[20];

    ((uint16 *)c_data)[0] = ((__global const uint16 *)input)[0];
	((uint4  *)c_data)[4] = ((__global const uint4  *)input)[4];
    for (int i = 0; i<20; i++) { c_data[i] = SWAP32(c_data[i]); }
    in[0] = c_data[16]; in[1] = c_data[17]; in[2] = c_data[18]; in[3] = nonce;
    in[5] = in[6] = in[7] = in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
    in[4] = 0x80000000; in[15] = 0x00000280;
    passwd[0] = cpu_h[0]; passwd[1] = cpu_h[1]; passwd[2] = cpu_h[2]; passwd[3] = cpu_h[3];
    passwd[4] = cpu_h[4]; passwd[5] = cpu_h[5]; passwd[6] = cpu_h[6]; passwd[7] = cpu_h[7];
    sha256_round_body(in, passwd);	// length = 80 * 8 = 640 = 0x280

    in[0] = passwd[0] ^ 0x36363636; in[1] = passwd[1] ^ 0x36363636; in[2] = passwd[2] ^ 0x36363636; in[3] = passwd[3] ^ 0x36363636;
    in[4] = passwd[4] ^ 0x36363636; in[5] = passwd[5] ^ 0x36363636; in[6] = passwd[6] ^ 0x36363636; in[7] = passwd[7] ^ 0x36363636;
    in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = in[15] = 0x36363636;
    state1[0] = 0x6A09E667; state1[1] = 0xBB67AE85; state1[2] = 0x3C6EF372; state1[3] = 0xA54FF53A;
    state1[4] = 0x510E527F; state1[5] = 0x9B05688C; state1[6] = 0x1F83D9AB; state1[7] = 0x5BE0CD19;
    sha256_round_body(in, state1);	// inner 64byte

    in[0] = passwd[0] ^ 0x5c5c5c5c; in[1] = passwd[1] ^ 0x5c5c5c5c; in[2] = passwd[2] ^ 0x5c5c5c5c; in[3] = passwd[3] ^ 0x5c5c5c5c;
    in[4] = passwd[4] ^ 0x5c5c5c5c; in[5] = passwd[5] ^ 0x5c5c5c5c; in[6] = passwd[6] ^ 0x5c5c5c5c; in[7] = passwd[7] ^ 0x5c5c5c5c;
    in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = in[15] = 0x5c5c5c5c;
    state2[0] = 0x6A09E667; state2[1] = 0xBB67AE85; state2[2] = 0x3C6EF372; state2[3] = 0xA54FF53A;
    state2[4] = 0x510E527F; state2[5] = 0x9B05688C; state2[6] = 0x1F83D9AB; state2[7] = 0x5BE0CD19;
    sha256_round_body(in, state2);	// outer 64byte

    in[0] = c_data[0]; in[1] = c_data[1]; in[2] = c_data[2]; in[3] = c_data[3];
    in[4] = c_data[4]; in[5] = c_data[5]; in[6] = c_data[6]; in[7] = c_data[7];
    in[8] = c_data[8]; in[9] = c_data[9]; in[10] = c_data[10]; in[11] = c_data[11];
    in[12] = c_data[12]; in[13] = c_data[13]; in[14] = c_data[14]; in[15] = c_data[15];
		sha256_round_body(in, state1);	// inner 128byte

#pragma unroll
    for (uint i = 0; i < 2 * r*p; i++) // 16
    {
        in[0] = c_data[16]; in[1] = c_data[17]; in[2] = c_data[18]; in[3] = nonce;
        in[4] = i * 2 + 1; in[5] = 0x80000000; in[15] = 0x000004A0;
        in[6] = in[7] = in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
        result[0] = state1[0]; result[1] = state1[1]; result[2] = state1[2]; result[3] = state1[3];
        result[4] = state1[4]; result[5] = state1[5]; result[6] = state1[6]; result[7] = state1[7];
        sha256_round_body(in, result + 0);	// inner length = 148 * 8 = 1184 = 0x4A0

        in[0] = result[0]; in[1] = result[1]; in[2] = result[2]; in[3] = result[3];
        in[4] = result[4]; in[5] = result[5]; in[6] = result[6]; in[7] = result[7];
        in[8] = 0x80000000; in[15] = 0x00000300;
        in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
        result[0] = state2[0]; result[1] = state2[1]; result[2] = state2[2]; result[3] = state2[3];
        result[4] = state2[4]; result[5] = state2[5]; result[6] = state2[6]; result[7] = state2[7];
        sha256_round_body(in, result + 0);	// outer length = 96 * 8 = 768 = 0x300

        in[0] = c_data[16]; in[1] = c_data[17]; in[2] = c_data[18]; in[3] = nonce;
        in[4] = i * 2 + 2; in[5] = 0x80000000; in[15] = 0x000004A0;
        in[6] = in[7] = in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
        result[8] = state1[0]; result[9] = state1[1]; result[10] = state1[2]; result[11] = state1[3];
        result[12] = state1[4]; result[13] = state1[5]; result[14] = state1[6]; result[15] = state1[7];
        sha256_round_body(in, result + 8);	// inner length = 148 * 8 = 1184 = 0x4A0

        in[0] = result[8]; in[1] = result[9]; in[2] = result[10]; in[3] = result[11];
        in[4] = result[12]; in[5] = result[13]; in[6] = result[14]; in[7] = result[15];
        in[8] = 0x80000000; in[15] = 0x00000300;
        in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
        result[8] = state2[0]; result[9] = state2[1]; result[10] = state2[2]; result[11] = state2[3];
        result[12] = state2[4]; result[13] = state2[5]; result[14] = state2[6]; result[15] = state2[7];
        sha256_round_body(in, result + 8);	// outer length = 96 * 8 = 768 = 0x300

        *(__global uint4*)&Bdev(i, 0) = (uint4)(cuda_swab32(result[0]), cuda_swab32(result[5]), cuda_swab32(result[10]), cuda_swab32(result[15]));
        *(__global uint4*)&Bdev(i, 4) = (uint4)(cuda_swab32(result[4]), cuda_swab32(result[9]), cuda_swab32(result[14]), cuda_swab32(result[3]));
        *(__global uint4*)&Bdev(i, 8) = (uint4)(cuda_swab32(result[8]), cuda_swab32(result[13]), cuda_swab32(result[2]), cuda_swab32(result[7]));
        *(__global uint4*)&Bdev(i, 12) = (uint4)(cuda_swab32(result[12]), cuda_swab32(result[1]), cuda_swab32(result[6]), cuda_swab32(result[11]));

        if (i == 0) {
            sha256dev(0) = result[0];
            sha256dev(1) = result[1];
            sha256dev(2) = result[2];
            sha256dev(3) = result[3];
            sha256dev(4) = result[4];
            sha256dev(5) = result[5];
            sha256dev(6) = result[6];
            sha256dev(7) = result[7];
        }
    }
}

__attribute__((reqd_work_group_size(32, 1, 1)))
__kernel void yescrypt_gpu_hash_k5(__global const uint* restrict input, __global uint* B, __global uint* sha256, __global uint* restrict output, const uint target, const uint threads)
{
	int thread = get_global_id(0) % MAX_GLOBAL_THREADS;
    int r = 8;
    int p = 1;

    const uint nonce = get_global_id(0);

    uint in[16];
    uint buf[8];

    uint state1[8];
    uint state2[8];

    uint  c_data[20];

    ((uint16 *)c_data)[0] = ((__global const uint16 *)input)[0];
	((uint4  *)c_data)[4] = ((__global const uint4  *)input)[4];
    for (int i = 0; i<20; i++) { c_data[i] = SWAP32(c_data[i]); }

    state1[0] = state2[0] = sha256dev(0);
    state1[1] = state2[1] = sha256dev(1);
    state1[2] = state2[2] = sha256dev(2);
    state1[3] = state2[3] = sha256dev(3);
    state1[4] = state2[4] = sha256dev(4);
    state1[5] = state2[5] = sha256dev(5);
    state1[6] = state2[6] = sha256dev(6);
    state1[7] = state2[7] = sha256dev(7);

    in[0] = state1[0] ^ 0x36363636; in[1] = state1[1] ^ 0x36363636; in[2] = state1[2] ^ 0x36363636; in[3] = state1[3] ^ 0x36363636;
    in[4] = state1[4] ^ 0x36363636; in[5] = state1[5] ^ 0x36363636; in[6] = state1[6] ^ 0x36363636; in[7] = state1[7] ^ 0x36363636;
    in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = in[15] = 0x36363636;
    state1[0] = 0x6A09E667; state1[1] = 0xBB67AE85; state1[2] = 0x3C6EF372; state1[3] = 0xA54FF53A;
    state1[4] = 0x510E527F; state1[5] = 0x9B05688C; state1[6] = 0x1F83D9AB; state1[7] = 0x5BE0CD19;
    sha256_round_body(in, state1);	// inner 64byte

    in[0] = state2[0] ^ 0x5c5c5c5c; in[1] = state2[1] ^ 0x5c5c5c5c; in[2] = state2[2] ^ 0x5c5c5c5c; in[3] = state2[3] ^ 0x5c5c5c5c;
    in[4] = state2[4] ^ 0x5c5c5c5c; in[5] = state2[5] ^ 0x5c5c5c5c; in[6] = state2[6] ^ 0x5c5c5c5c; in[7] = state2[7] ^ 0x5c5c5c5c;
    in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = in[15] = 0x5c5c5c5c;
    state2[0] = 0x6A09E667; state2[1] = 0xBB67AE85; state2[2] = 0x3C6EF372; state2[3] = 0xA54FF53A;
    state2[4] = 0x510E527F; state2[5] = 0x9B05688C; state2[6] = 0x1F83D9AB; state2[7] = 0x5BE0CD19;
    sha256_round_body(in, state2);	// outer 64byte

    for (uint i = 0; i < 2 * r * p; i++)
    {
        in[0] = Bdev(i, 0); in[1] = Bdev(i, 13); in[2] = Bdev(i, 10); in[3] = Bdev(i, 7);
        in[4] = Bdev(i, 4); in[5] = Bdev(i, 1); in[6] = Bdev(i, 14); in[7] = Bdev(i, 11);
        in[8] = Bdev(i, 8); in[9] = Bdev(i, 5); in[10] = Bdev(i, 2); in[11] = Bdev(i, 15);
        in[12] = Bdev(i, 12); in[13] = Bdev(i, 9); in[14] = Bdev(i, 6); in[15] = Bdev(i, 3);
        in[0] = cuda_swab32(in[0]); in[1] = cuda_swab32(in[1]); in[2] = cuda_swab32(in[2]); in[3] = cuda_swab32(in[3]);
        in[4] = cuda_swab32(in[4]); in[5] = cuda_swab32(in[5]); in[6] = cuda_swab32(in[6]); in[7] = cuda_swab32(in[7]);
        in[8] = cuda_swab32(in[8]); in[9] = cuda_swab32(in[9]); in[10] = cuda_swab32(in[10]); in[11] = cuda_swab32(in[11]);
        in[12] = cuda_swab32(in[12]); in[13] = cuda_swab32(in[13]); in[14] = cuda_swab32(in[14]); in[15] = cuda_swab32(in[15]);
        sha256_round_body(in, state1);	// inner 1088byte
    }

    in[0] = 0x00000001; in[1] = 0x80000000; in[15] = (64 + 128 * r * p + 4) * 8;
    in[2] = in[3] = in[4] = in[5] = in[6] = in[7] = in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
    sha256_round_body(in, state1);	// inner length = 1092 * 8 = 8736 = 0x2220

    in[0] = state1[0]; in[1] = state1[1]; in[2] = state1[2]; in[3] = state1[3];
    in[4] = state1[4]; in[5] = state1[5]; in[6] = state1[6]; in[7] = state1[7];
    in[8] = 0x80000000; in[15] = 0x00000300;
    in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
    buf[0] = state2[0]; buf[1] = state2[1]; buf[2] = state2[2]; buf[3] = state2[3];
    buf[4] = state2[4]; buf[5] = state2[5]; buf[6] = state2[6]; buf[7] = state2[7];
    sha256_round_body(in, buf);	// outer length = 96 * 8 = 768 = 0x300

                                //hmac and final sha
    in[0] = buf[0] ^ 0x36363636;
    in[1] = buf[1] ^ 0x36363636;
    in[2] = buf[2] ^ 0x36363636;
    in[3] = buf[3] ^ 0x36363636;
    in[4] = buf[4] ^ 0x36363636;
    in[5] = buf[5] ^ 0x36363636;
    in[6] = buf[6] ^ 0x36363636;
    in[7] = buf[7] ^ 0x36363636;
    in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = in[15] = 0x36363636;
    state1[0] = state2[0] = 0x6A09E667;
    state1[1] = state2[1] = 0xBB67AE85;
    state1[2] = state2[2] = 0x3C6EF372;
    state1[3] = state2[3] = 0xA54FF53A;
    state1[4] = state2[4] = 0x510E527F;
    state1[5] = state2[5] = 0x9B05688C;
    state1[6] = state2[6] = 0x1F83D9AB;
    state1[7] = state2[7] = 0x5BE0CD19;
    sha256_round_body(in, state1);	// inner 64byte

    in[0] = buf[0] ^ 0x5c5c5c5c;
    in[1] = buf[1] ^ 0x5c5c5c5c;
    in[2] = buf[2] ^ 0x5c5c5c5c;
    in[3] = buf[3] ^ 0x5c5c5c5c;
    in[4] = buf[4] ^ 0x5c5c5c5c;
    in[5] = buf[5] ^ 0x5c5c5c5c;
    in[6] = buf[6] ^ 0x5c5c5c5c;
    in[7] = buf[7] ^ 0x5c5c5c5c;
    in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = in[15] = 0x5c5c5c5c;
    sha256_round_body(in, state2);	// outer 64byte

    in[0] = c_data[0]; in[1] = c_data[1]; in[2] = c_data[2]; in[3] = c_data[3];
    in[4] = c_data[4]; in[5] = c_data[5]; in[6] = c_data[6]; in[7] = c_data[7];
    in[8] = c_data[8]; in[9] = c_data[9]; in[10] = c_data[10]; in[11] = c_data[11];
    in[12] = c_data[12]; in[13] = c_data[13]; in[14] = c_data[14]; in[15] = c_data[15];
    sha256_round_body(in, state1);	// inner length = 74 * 8 = 592 = 0x250

    in[0] = c_data[16]; in[1] = c_data[17]; in[2] = c_data[18]; in[3] = nonce;
    in[5] = in[6] = in[7] = in[8] = in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
    in[4] = 0x80000000; in[15] = 0x00000480;
    sha256_round_body(in, state1);	// length = 80 * 8 = 640 = 0x280

    in[0] = state1[0]; in[1] = state1[1]; in[2] = state1[2]; in[3] = state1[3];
    in[4] = state1[4]; in[5] = state1[5]; in[6] = state1[6]; in[7] = state1[7];
    in[8] = 0x80000000; in[15] = 0x00000300;
    in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
    sha256_round_body(in, state2);	// outer length = 96 * 8 = 768 = 0x300

    in[0] = state2[0]; in[1] = state2[1]; in[2] = state2[2]; in[3] = state2[3];
    in[4] = state2[4]; in[5] = state2[5]; in[6] = state2[6]; in[7] = state2[7];
    in[8] = 0x80000000; in[15] = 0x00000100;
    in[9] = in[10] = in[11] = in[12] = in[13] = in[14] = 0x00000000;
    buf[0] = 0x6A09E667; buf[1] = 0xBB67AE85; buf[2] = 0x3C6EF372; buf[3] = 0xA54FF53A;
    buf[4] = 0x510E527F; buf[5] = 0x9B05688C; buf[6] = 0x1F83D9AB; buf[7] = 0x5BE0CD19;
    sha256_round_body(in, buf);	// length = 32 * 8 = 256 = 0x100

    if (SWAP32(buf[7]) <= (target))
		output[atomic_inc(output + 0xFF)] = (nonce);

}

#undef sha256dev
#undef Bdev

static inline uint2 mad64(const uint a, const uint b, uint2 c)
{
    uint2 result;
    result.x = a * b;
    result.y = mul_hi(a, b);
    return as_uint2(as_ulong(result) + as_ulong(c));
}

#define bitselect(a, b, c) ((a) ^ ((c) & ((b) ^ (a))))

#define WarpShuffle(result, a, b, c) \
{ \
	uint thread = get_local_id(1) * get_local_size(0) + get_local_id(0); \
	uint threads = get_local_size(1) * get_local_size(0); \
	uint buf; \
 \
	barrier(CLK_LOCAL_MEM_FENCE); \
	buf = shared_mem[threads * 0 + thread]; \
	shared_mem[threads * 0 + thread] = a; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	result = shared_mem[0 * threads + bitselect(thread, b, c - 1)]; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	shared_mem[threads * 0 + thread] = buf; \
 \
}

#define WarpShuffle2(d0, d1, a0, a1, b0, b1, c) \
{ \
	uint thread = get_local_id(1) * get_local_size(0) + get_local_id(0); \
	uint threads = get_local_size(1) * get_local_size(0); \
	uint buf0, buf1; \
 \
	barrier(CLK_LOCAL_MEM_FENCE); \
	buf0 = shared_mem[threads * 0 + thread]; \
	buf1 = shared_mem[threads * 1 + thread]; \
	shared_mem[threads * 0 + thread] = a0; \
	shared_mem[threads * 1 + thread] = a1; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	d0 = shared_mem[0 * threads + bitselect(thread, b0, c - 1)]; \
	d1 = shared_mem[1 * threads + bitselect(thread, b1, c - 1)]; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	shared_mem[threads * 0 + thread] = buf0; \
	shared_mem[threads * 1 + thread] = buf1; \
}

#define WarpShuffle3(d0, d1, d2, a0, a1, a2, b0, b1, b2, c) \
{ \
	uint thread = get_local_id(1) * get_local_size(0) + get_local_id(0); \
	uint threads = get_local_size(1) * get_local_size(0); \
	uint buf0, buf1, buf2; \
 \
	barrier(CLK_LOCAL_MEM_FENCE); \
	buf0 = shared_mem[threads * 0 + thread]; \
	buf1 = shared_mem[threads * 1 + thread]; \
	buf2 = shared_mem[threads * 2 + thread]; \
	shared_mem[threads * 0 + thread] = a0; \
	shared_mem[threads * 1 + thread] = a1; \
	shared_mem[threads * 2 + thread] = a2; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	d0 = shared_mem[0 * threads + bitselect(thread, b0, c - 1)]; \
	d1 = shared_mem[1 * threads + bitselect(thread, b1, c - 1)]; \
	d2 = shared_mem[2 * threads + bitselect(thread, b2, c - 1)]; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	shared_mem[threads * 0 + thread] = buf0; \
	shared_mem[threads * 1 + thread] = buf1; \
	shared_mem[threads * 2 + thread] = buf2; \
}

#define WarpShuffle4(d0, d1, d2, d3, a0, a1, a2, a3, b0, b1, b2, b3, c) \
{ \
	uint thread = get_local_id(1) * get_local_size(0) + get_local_id(0); \
	uint threads = get_local_size(1) * get_local_size(0); \
	uint buf0, buf1, buf2, buf3; \
 \
	barrier(CLK_LOCAL_MEM_FENCE); \
	buf0 = shared_mem[threads * 0 + thread]; \
	buf1 = shared_mem[threads * 1 + thread]; \
	buf2 = shared_mem[threads * 2 + thread]; \
	buf3 = shared_mem[threads * 3 + thread]; \
	shared_mem[threads * 0 + thread] = a0; \
	shared_mem[threads * 1 + thread] = a1; \
	shared_mem[threads * 2 + thread] = a2; \
	shared_mem[threads * 3 + thread] = a3; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	d0 = shared_mem[0 * threads + bitselect(thread, b0, c - 1)]; \
	d1 = shared_mem[1 * threads + bitselect(thread, b1, c - 1)]; \
	d2 = shared_mem[2 * threads + bitselect(thread, b2, c - 1)]; \
	d3 = shared_mem[3 * threads + bitselect(thread, b3, c - 1)]; \
	barrier(CLK_LOCAL_MEM_FENCE); \
	shared_mem[threads * 0 + thread] = buf0; \
	shared_mem[threads * 1 + thread] = buf1; \
	shared_mem[threads * 2 + thread] = buf2; \
	shared_mem[threads * 3 + thread] = buf3; \
}

#define SALSA(a,b,c,d) { \
    b^=ROTL(a+d,  7);    \
    c^=ROTL(b+a,  9);    \
    d^=ROTL(c+b, 13);    \
    a^=ROTL(d+c, 18);     \
}

#define SALSA_CORE(x0, x1, x2, x3) { \
	uint t0, t1, t2, t3; \
	t0 = x0; t1 = x1; t2 = x2; t3 = x3; \
	for (int idx = 0; idx < 4; ++idx) { \
		SALSA(x0, x1, x2, x3); \
		WarpShuffle3(x1,x2,x3,x1,x2,x3,get_local_id(0) + 3,get_local_id(0) + 2,get_local_id(0) + 1,4);\
		SALSA(x0, x3, x2, x1); \
		WarpShuffle3(x1,x2,x3,x1,x2,x3,get_local_id(0) + 1,get_local_id(0) + 2,get_local_id(0) + 3,4);\
	} \
	x0 += t0; x1 += t1; x2 += t2; x3 += t3; \
}

#define Bdev(a, b) B[((a) * threads + thread) * 16 + (b) * 4 + get_local_id(0)]
#define Sdev(a, b) S[(thread_part_4 * 128 + (a)) * 16 + (b) * 4 + get_local_id(0)]

__attribute__((reqd_work_group_size(4, 8, 1)))
__kernel void yescrypt_gpu_hash_k1(__global uint* B, __global uint* S, const uint offset, const uint threads)
{
    uint thread_part_4 = (8 * get_group_id(0) + get_local_id(1));
	uint thread = thread_part_4 + offset;

    __local uint shared_mem[128];

    uint n, i, j;
    uint x[8];

    x[0] = Bdev(0, 0);
    x[1] = Bdev(0, 1);
    x[2] = Bdev(0, 2);
    x[3] = Bdev(0, 3);
    x[4] = Bdev(1, 0);
    x[5] = Bdev(1, 1);
    x[6] = Bdev(1, 2);
    x[7] = Bdev(1, 3);

    for (n = 1, i = 0; i < 64; i++)
    {
        /* 3: V_i <-- X */
        Sdev(i * 2 + 0, 0) = x[0];
        Sdev(i * 2 + 0, 1) = x[1];
        Sdev(i * 2 + 0, 2) = x[2];
        Sdev(i * 2 + 0, 3) = x[3];
        Sdev(i * 2 + 1, 0) = x[4];
        Sdev(i * 2 + 1, 1) = x[5];
        Sdev(i * 2 + 1, 2) = x[6];
        Sdev(i * 2 + 1, 3) = x[7];

        if (i > 1) {
            if ((i & (i - 1)) == 0) n = i;
            WarpShuffle(j, x[4], 0, 4);
            j &= (n - 1);
            j += i - n;

            x[0] ^= Sdev(j * 2 + 0, 0);
            x[1] ^= Sdev(j * 2 + 0, 1);
            x[2] ^= Sdev(j * 2 + 0, 2);
            x[3] ^= Sdev(j * 2 + 0, 3);
            x[4] ^= Sdev(j * 2 + 1, 0);
            x[5] ^= Sdev(j * 2 + 1, 1);
            x[6] ^= Sdev(j * 2 + 1, 2);
            x[7] ^= Sdev(j * 2 + 1, 3);
        }

        x[0] ^= x[4]; x[1] ^= x[5]; x[2] ^= x[6]; x[3] ^= x[7];
        SALSA_CORE(x[0], x[1], x[2], x[3]);
        x[4] ^= x[0]; x[5] ^= x[1]; x[6] ^= x[2]; x[7] ^= x[3];
        SALSA_CORE(x[4], x[5], x[6], x[7]);
    }

    Bdev(0, 0) = x[0];
    Bdev(0, 1) = x[1];
    Bdev(0, 2) = x[2];
    Bdev(0, 3) = x[3];
    Bdev(1, 0) = x[4];
    Bdev(1, 1) = x[5];
    Bdev(1, 2) = x[6];
    Bdev(1, 3) = x[7];
}

#undef Bdev
#undef Sdev

#define Vdev(a, b) v[((a) * 16 + (b)) * 32]
#define Bdev(a) B[((a) * threads + thread) * 16 + get_local_id(0)]
#define Sdev(a) S[(thread_part_4 * 128 + (a)) * 16 + get_local_id(0)]
#define Shared(a) *(__local uint2*)&shared_mem[(get_local_id(1) * 512 + (a)) * 4 + (get_local_id(0) & 2)]

__attribute__((reqd_work_group_size(16, 2, 1)))
__kernel void yescrypt_gpu_hash_k2c_r8(__global uint* B, __global uint* S, __global uint* V, const uint offset1, const uint offset2, const uint threads)
{
    uint thread_part_16 = (2 * get_group_id(0) + get_local_id(1));
	uint thread_part_4 = thread_part_16 + offset1;
	uint thread = thread_part_16 + offset2;
	__local uint shared_mem[4096];

	const uint r = 8;
    const uint N = 2048;

	__global uint *v = &V[get_group_id(0) * N * r * 2 * 32 + get_local_id(1) * 16 + get_local_id(0)];

    uint n, i, j, k;
    uint x0, x1, x2, x3;
    uint2 buf;
    uint x[r * 2];

    for (k = 0; k < 128; k++)
        shared_mem[(get_local_id(1) * 128 + k) * 16 + get_local_id(0)] = Sdev(k);

#pragma unroll
    for (k = 0; k < r * 2; k++)
        x[k] = Bdev(k);

    for (n = 1, i = 0; i < 2048; i++) {
#pragma unroll
        for (k = 0; k < r * 2; k++) {
            x3 = x[k];
            Vdev(i, k) = x3;
        }

        if (i > 1) {
            if ((i & (i - 1)) == 0) n = i;
            WarpShuffle(j, x3, 0, 16);
            j &= (n - 1);
            j += i - n;

            for (k = 0; k < r * 2; k++) {
                x3 = x[k] ^ Vdev(j, k);
                x[k] = x3;
            }
        }

#pragma unroll
        for (k = 0; k < r * 2; k++) {
            x3 ^= x[k];
            WarpShuffle2(buf.x, buf.y, x3, x3, 0, 1, 2);
#pragma unroll
            for (j = 0; j < 6; j++) {
                WarpShuffle2(x0, x1, buf.x, buf.y, 0, 0, 4);
                x0 = ((x0 >> 4) & 255) + 0;
                x1 = ((x1 >> 4) & 255) + 256;
                buf = mad64(buf.x, buf.y, Shared(x0));
                buf ^= Shared(x1);
            }
            if (get_local_id(0) & 1) x3 = buf.y;
            else x3 = buf.x;

            x[k] = x3;
        }
        WarpShuffle4(x0, x1, x2, x3, x3, x3, x3, x3, 0 + (get_local_id(0) & 3), 4 + (get_local_id(0) & 3), 8 + (get_local_id(0) & 3), 12 + (get_local_id(0) & 3), 16);
        SALSA_CORE(x0, x1, x2, x3);
        if (get_local_id(0) < 4) x3 = x0;
        else if (get_local_id(0) < 8) x3 = x1;
        else if (get_local_id(0) < 12) x3 = x2;

        x[r * 2 - 1] = x3;
    }

#pragma unroll
    for (k = 0; k < r * 2; k++)
        Bdev(k) = x[k];
}

__attribute__((reqd_work_group_size(16, 2, 1)))
__kernel void yescrypt_gpu_hash_k2c1_r8(__global uint* B, __global uint* S, __global uint* V, const uint offset1, const uint offset2, const uint threads)
{
    uint thread_part_16 = (2 * get_group_id(0) + get_local_id(1));
	uint thread_part_4 = thread_part_16 + offset1;
	uint thread = thread_part_16 + offset2;
	__local uint shared_mem[4096];

	const uint r = 8;
    const uint N = 2048;

	__global uint *v = &V[get_group_id(0) * N * r * 2 * 32 + get_local_id(1) * 16 + get_local_id(0)];

    uint j, k;
    uint x0, x1, x2, x3;
    uint2 buf;
    uint x[r * 2];

    for (k = 0; k < 128; k++)
        shared_mem[(get_local_id(1) * 128 + k) * 16 + get_local_id(0)] = Sdev(k);

#pragma unroll
    for (k = 0; k < r * 2; k++)
        x[k] = Bdev(k);

    for (uint z = 0; z < 684; z++)
    {
        WarpShuffle(j, x[r * 2 - 1], 0, 16);
        j &= (N - 1);

#pragma unroll
        for (k = 0; k < r * 2; k++)
            x[k] ^= Vdev(j, k);

#pragma unroll
        for (k = 0; k < r * 2; k++) {
            x3 = x[k];
            Vdev(j, k) = x3;
        }

#pragma unroll
        for (k = 0; k < r * 2; k++) {
            x3 ^= x[k];
            WarpShuffle2(buf.x, buf.y, x3, x3, 0, 1, 2);
#pragma unroll
            for (j = 0; j < 6; j++) {
                WarpShuffle2(x0, x1, buf.x, buf.y, 0, 0, 4);
                x0 = ((x0 >> 4) & 255) + 0;
                x1 = ((x1 >> 4) & 255) + 256;
                buf = mad64(buf.x, buf.y, Shared(x0));
                buf ^= Shared(x1);
            }
            if (get_local_id(0) & 1) x3 = buf.y;
            else x3 = buf.x;

            x[k] = x3;
        }
        WarpShuffle4(x0, x1, x2, x3, x3, x3, x3, x3, 0 + (get_local_id(0) & 3), 4 + (get_local_id(0) & 3), 8 + (get_local_id(0) & 3), 12 + (get_local_id(0) & 3), 16);
        SALSA_CORE(x0, x1, x2, x3);
        if (get_local_id(0) < 4) x3 = x0;
        else if (get_local_id(0) < 8) x3 = x1;
        else if (get_local_id(0) < 12) x3 = x2;

        x[r * 2 - 1] = x3;
    }

#pragma unroll
    for (k = 0; k < r * 2; k++)
        Bdev(k) = x[k];
}

#undef Vdev
#undef Bdev
#undef Sdev