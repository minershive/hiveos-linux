/*
 * Copyright (c) 2014-2017 John Doering <ghostlander@phoenixcoin.org>
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


/* NeoScrypt(128, 2, 1) with Salsa20/20 and ChaCha20/20
 * Optimised for the AMD VLIW4 and VLIW5 architectures
 * v8b, 26-Dec-2017 */


#if (__ATI_RV770__) || (__ATI_RV730__) || (__ATI_RV710__)
/* AMD TeraScale with OpenCL / VLIW5 (all HD4000 series) */
#define OLD_VLIW 1
#endif

#if(__Cypress__) || (__Barts__) || (__Juniper__) || \
(__Turks__) || (__Caicos__) || (__Redwood__) || (__Cedar__) || \
(__BeaverCreek__) || (__WinterPark__) || (__Loveland__) || \
(__Cayman__) || (__Devastator__) || (__Scrapper__)
/* AMD TeraScale 2 / VLIW5 (all HD5000 series, most HD6000 series,
 * some HD83x0 and HD84x0 OEM cards);
 * AMD TeraScale 3 / VLIW4 (HD69x0, HD73x0, HD74x0, HD75x0, HD76x0,
 * HD83x0, HD84x0, HD85x0, HD86x0, R5 220, R5 235[X] cards and APUs) */
#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#endif

#define SALSA_SCALAR 0
#define CHACHA_SCALAR 0
#define BLAKE2S_SCALAR 0
#define FASTKDF_SCALAR 0
#define SALSA_UNROLL_LEVEL 4
#define CHACHA_UNROLL_LEVEL 4
#define BLAKE2S_COMPACT 0


/* Use amd_bitalign() because amd_bytealign() might be broken in old drivers */

/* 32-byte memcpy() of possibly unaligned memory to 4-byte aligned memory */
void neoscrypt_copy32(void *restrict dstp, const void *restrict srcp,
  uint offset) {
    uint *dst = (uint *) dstp;
    uint *src = (uint *) srcp;

#if (OLD_VLIW)
    offset <<= 3;
    uint roffset = 32U - offset;

    dst[0] = ((uint)((ulong)src[1] << roffset) | (src[0] >> offset));
    dst[1] = ((uint)((ulong)src[2] << roffset) | (src[1] >> offset));
    dst[2] = ((uint)((ulong)src[3] << roffset) | (src[2] >> offset));
    dst[3] = ((uint)((ulong)src[4] << roffset) | (src[3] >> offset));
    dst[4] = ((uint)((ulong)src[5] << roffset) | (src[4] >> offset));
    dst[5] = ((uint)((ulong)src[6] << roffset) | (src[5] >> offset));
    dst[6] = ((uint)((ulong)src[7] << roffset) | (src[6] >> offset));
    dst[7] = ((uint)((ulong)src[8] << roffset) | (src[7] >> offset));
#else
    offset = amd_bitalign(offset, offset, 29U);

    dst[0] = amd_bitalign(src[1], src[0], offset);
    dst[1] = amd_bitalign(src[2], src[1], offset);
    dst[2] = amd_bitalign(src[3], src[2], offset);
    dst[3] = amd_bitalign(src[4], src[3], offset);
    dst[4] = amd_bitalign(src[5], src[4], offset);
    dst[5] = amd_bitalign(src[6], src[5], offset);
    dst[6] = amd_bitalign(src[7], src[6], offset);
    dst[7] = amd_bitalign(src[8], src[7], offset);
#endif
}

/* 64-byte memcpy() of possibly unaligned memory to 4-byte aligned memory */
void neoscrypt_copy64(void *restrict dstp, const void *restrict srcp,
  uint offset) {
    uint *dst = (uint *) dstp;
    uint *src = (uint *) srcp;

#if (OLD_VLIW)
    offset <<= 3;
    uint roffset = 32U - offset;

    dst[0]  = ((uint)((ulong)src[1]  << roffset) | (src[0]  >> offset));
    dst[1]  = ((uint)((ulong)src[2]  << roffset) | (src[1]  >> offset));
    dst[2]  = ((uint)((ulong)src[3]  << roffset) | (src[2]  >> offset));
    dst[3]  = ((uint)((ulong)src[4]  << roffset) | (src[3]  >> offset));
    dst[4]  = ((uint)((ulong)src[5]  << roffset) | (src[4]  >> offset));
    dst[5]  = ((uint)((ulong)src[6]  << roffset) | (src[5]  >> offset));
    dst[6]  = ((uint)((ulong)src[7]  << roffset) | (src[6]  >> offset));
    dst[7]  = ((uint)((ulong)src[8]  << roffset) | (src[7]  >> offset));
    dst[8]  = ((uint)((ulong)src[9]  << roffset) | (src[8]  >> offset));
    dst[9]  = ((uint)((ulong)src[10] << roffset) | (src[9]  >> offset));
    dst[10] = ((uint)((ulong)src[11] << roffset) | (src[10] >> offset));
    dst[11] = ((uint)((ulong)src[12] << roffset) | (src[11] >> offset));
    dst[12] = ((uint)((ulong)src[13] << roffset) | (src[12] >> offset));
    dst[13] = ((uint)((ulong)src[14] << roffset) | (src[13] >> offset));
    dst[14] = ((uint)((ulong)src[15] << roffset) | (src[14] >> offset));
    dst[15] = ((uint)((ulong)src[16] << roffset) | (src[15] >> offset));
#else
    offset = amd_bitalign(offset, offset, 29U);

    dst[0]  = amd_bitalign(src[1],  src[0], offset);
    dst[1]  = amd_bitalign(src[2],  src[1], offset);
    dst[2]  = amd_bitalign(src[3],  src[2], offset);
    dst[3]  = amd_bitalign(src[4],  src[3], offset);
    dst[4]  = amd_bitalign(src[5],  src[4], offset);
    dst[5]  = amd_bitalign(src[6],  src[5], offset);
    dst[6]  = amd_bitalign(src[7],  src[6], offset);
    dst[7]  = amd_bitalign(src[8],  src[7], offset);
    dst[8]  = amd_bitalign(src[9],  src[8], offset);
    dst[9]  = amd_bitalign(src[10], src[9], offset);
    dst[10] = amd_bitalign(src[11], src[10], offset);
    dst[11] = amd_bitalign(src[12], src[11], offset);
    dst[12] = amd_bitalign(src[13], src[12], offset);
    dst[13] = amd_bitalign(src[14], src[13], offset);
    dst[14] = amd_bitalign(src[15], src[14], offset);
    dst[15] = amd_bitalign(src[16], src[15], offset);
#endif
}

/* 4-byte XOR of possibly unaligned memory to 4-byte aligned memory */
void neoscrypt_xor4_ua(uint *restrict dst, const uint *restrict src, uint offset) {
#if (OLD_VLIW)
    offset <<= 3;
    uint roffset = 32U - offset;
    dst[0] ^= ((uint)((ulong)src[1] << roffset) | (src[0] >> offset));
#else
    offset = amd_bitalign(offset, offset, 29U);
    dst[0] ^= amd_bitalign(src[1], src[0], offset);
#endif
}

/* 32-byte XOR of possibly unaligned memory to 4-byte aligned memory (iterated) */
void neoscrypt_xor32_ua_it(void *restrict dstp, const void *restrict srcp,
  uint offset, uint it) {
    uint *dst = (uint *) dstp;
    uint *src = (uint *) srcp;
    uint i;

#if (OLD_VLIW)
    offset <<= 3;
    uint roffset = 32U - offset;

    it <<= 3;
    for(i = 0; i < it; i += 8) {
        dst[i]     ^= ((uint)((ulong)src[i + 1] << roffset) | (src[i]     >> offset));
        dst[i + 1] ^= ((uint)((ulong)src[i + 2] << roffset) | (src[i + 1] >> offset));
        dst[i + 2] ^= ((uint)((ulong)src[i + 3] << roffset) | (src[i + 2] >> offset));
        dst[i + 3] ^= ((uint)((ulong)src[i + 4] << roffset) | (src[i + 3] >> offset));
        dst[i + 4] ^= ((uint)((ulong)src[i + 5] << roffset) | (src[i + 4] >> offset));
        dst[i + 5] ^= ((uint)((ulong)src[i + 6] << roffset) | (src[i + 5] >> offset));
        dst[i + 6] ^= ((uint)((ulong)src[i + 7] << roffset) | (src[i + 6] >> offset));
        dst[i + 7] ^= ((uint)((ulong)src[i + 8] << roffset) | (src[i + 7] >> offset));
    }
#else
    offset = amd_bitalign(offset, offset, 29U);

    it = amd_bitalign(it, it, 29U);

    for(i = 0; i < it; i += 8) {
        dst[i]     ^= amd_bitalign(src[i + 1], src[i],     offset);
        dst[i + 1] ^= amd_bitalign(src[i + 2], src[i + 1], offset);
        dst[i + 2] ^= amd_bitalign(src[i + 3], src[i + 2], offset);
        dst[i + 3] ^= amd_bitalign(src[i + 4], src[i + 3], offset);
        dst[i + 4] ^= amd_bitalign(src[i + 5], src[i + 4], offset);
        dst[i + 5] ^= amd_bitalign(src[i + 6], src[i + 5], offset);
        dst[i + 6] ^= amd_bitalign(src[i + 7], src[i + 6], offset);
        dst[i + 7] ^= amd_bitalign(src[i + 8], src[i + 7], offset);
    }
#endif
}

/* 32-byte XOR of 4-byte aligned memory to possibly unaligned memory */
void neoscrypt_xor32_au(void *restrict dstp, const void *restrict srcp,
  uint offset) {
    uint *dst = (uint *) dstp;
    uint *src = (uint *) srcp;
    uint roffset;

    /* OpenCL cannot shift uint by 32 to zero value */

#if (OLD_VLIW)
    offset <<= 3;
    roffset = 32U - offset;

    dst[0] ^= (src[0] << offset);
    dst[1] ^= ((src[1] << offset) | (uint)((ulong)src[0] >> roffset));
    dst[2] ^= ((src[2] << offset) | (uint)((ulong)src[1] >> roffset));
    dst[3] ^= ((src[3] << offset) | (uint)((ulong)src[2] >> roffset));
    dst[4] ^= ((src[4] << offset) | (uint)((ulong)src[3] >> roffset));
    dst[5] ^= ((src[5] << offset) | (uint)((ulong)src[4] >> roffset));
    dst[6] ^= ((src[6] << offset) | (uint)((ulong)src[5] >> roffset));
    dst[7] ^= ((src[7] << offset) | (uint)((ulong)src[6] >> roffset));
    dst[8] ^= (uint)((ulong)src[7] >> roffset);
#else
    offset = amd_bitalign(offset, offset, 29U);
    roffset = 32U - offset;
    uint mask = amd_bitalign(0U, ~0U, offset);

    dst[0] ^= amd_bitalign(src[0], bitselect(0U,     src[0], mask), roffset);
    dst[1] ^= amd_bitalign(src[1], bitselect(src[0], src[1], mask), roffset);
    dst[2] ^= amd_bitalign(src[2], bitselect(src[1], src[2], mask), roffset);
    dst[3] ^= amd_bitalign(src[3], bitselect(src[2], src[3], mask), roffset);
    dst[4] ^= amd_bitalign(src[4], bitselect(src[3], src[4], mask), roffset);
    dst[5] ^= amd_bitalign(src[5], bitselect(src[4], src[5], mask), roffset);
    dst[6] ^= amd_bitalign(src[6], bitselect(src[5], src[6], mask), roffset);
    dst[7] ^= amd_bitalign(src[7], bitselect(src[6], src[7], mask), roffset);
    dst[8] ^= amd_bitalign(0U,     bitselect(src[7], 0U,     mask), roffset);
#endif
}

void neoscrypt_copy256(void *restrict dstp, const void *restrict srcp) {
    ulong16 *dst = (ulong16 *) dstp;
    ulong16 *src = (ulong16 *) srcp;

    dst[0] = src[0];
    dst[1] = src[1];
}

void neoscrypt_xor256(void *restrict dstp, const void *restrict srcp) {
    ulong16 *dst = (ulong16 *) dstp;
    ulong16 *src = (ulong16 *) srcp;

    dst[0] ^= src[0];
    dst[1] ^= src[1];
}

/* 64-byte XOR based block swapper */
void neoscrypt_swap64(void *restrict blkAp, void *restrict blkBp) {
    uint16 *blkA = (uint16 *) blkAp;
    uint16 *blkB = (uint16 *) blkBp;

    blkA[0] ^= blkB[0];
    blkB[0] ^= blkA[0];
    blkA[0] ^= blkB[0];
}

/* 256-byte XOR based block swapper */
void neoscrypt_swap256(void *restrict blkAp, void *restrict blkBp) {
    ulong16 *blkA = (ulong16 *) blkAp;
    ulong16 *blkB = (ulong16 *) blkBp;

    blkA[0] ^= blkB[0];
    blkB[0] ^= blkA[0];
    blkA[0] ^= blkB[0];
    blkA[1] ^= blkB[1];
    blkB[1] ^= blkA[1];
    blkA[1] ^= blkB[1];
}


/* BLAKE2s */

/* Initialisation vector */
#if (OLD_VLIW)
const __constant uint8 blake2s_IV4[1] = {
#else
static const __constant uint8 blake2s_IV4[1] = {
#endif
    (uint8)(0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
            0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19)
};

#if (OLD_VLIW)
const __constant uint blake2s_sigma[10][16] = {
#else
static const __constant uint blake2s_sigma[10][16] = {
#endif
    {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 } ,
    { 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 } ,
    { 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 } ,
    {  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 } ,
    {  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 } ,
    {  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 } ,
    { 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 } ,
    { 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 } ,
    {  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 } ,
    { 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13 , 0 } ,
};

#define G(x, y, a, b, c, d) \
    a += b + m[blake2s_sigma[x][y]]; \
    d = rotate(d ^ a, 16U); \
    c += d; \
    b = rotate(b ^ c, 20U); \
    a += b + m[blake2s_sigma[x][y + 1]]; \
    d = rotate(d ^ a, 24U); \
    c += d; \
    b = rotate(b ^ c, 25U);

#define G1(x, a, b, c, d) \
    a += b + (uint4)(m[blake2s_sigma[x][0]], m[blake2s_sigma[x][2]], m[blake2s_sigma[x][4]], m[blake2s_sigma[x][6]]); \
    d = rotate(d ^ a, (uint4)(16, 16, 16, 16)); \
    c += d; \
    b = rotate(b ^ c, (uint4)(20, 20, 20, 20)); \
    a += b + (uint4)(m[blake2s_sigma[x][1]], m[blake2s_sigma[x][3]], m[blake2s_sigma[x][5]], m[blake2s_sigma[x][7]]); \
    d = rotate(d ^ a, (uint4)(24, 24, 24, 24)); \
    c += d; \
    b = rotate(b ^ c, (uint4)(25, 25, 25, 25));

#define G2(x, a, b, c, d) \
    a += b + (uint4)(m[blake2s_sigma[x][8]], m[blake2s_sigma[x][10]], m[blake2s_sigma[x][12]], m[blake2s_sigma[x][14]]); \
    d = rotate(d ^ a, (uint4)(16, 16, 16, 16)); \
    c += d; \
    b = rotate(b ^ c, (uint4)(20, 20, 20, 20)); \
    a += b + (uint4)(m[blake2s_sigma[x][9]], m[blake2s_sigma[x][11]], m[blake2s_sigma[x][13]], m[blake2s_sigma[x][15]]); \
    d = rotate(d ^ a, (uint4)(24, 24, 24, 24)); \
    c += d; \
    b = rotate(b ^ c, (uint4)(25, 25, 25, 25));


/* Salsa20/20 */

#define SALSA_CORE_SCALAR(Y) \
    Y.s4 ^= rotate(Y.s0 + Y.sc, 7U);  Y.s8 ^= rotate(Y.s4 + Y.s0, 9U);  \
    Y.sc ^= rotate(Y.s8 + Y.s4, 13U); Y.s0 ^= rotate(Y.sc + Y.s8, 18U); \
    Y.s9 ^= rotate(Y.s5 + Y.s1, 7U);  Y.sd ^= rotate(Y.s9 + Y.s5, 9U);  \
    Y.s1 ^= rotate(Y.sd + Y.s9, 13U); Y.s5 ^= rotate(Y.s1 + Y.sd, 18U); \
    Y.se ^= rotate(Y.sa + Y.s6, 7U);  Y.s2 ^= rotate(Y.se + Y.sa, 9U);  \
    Y.s6 ^= rotate(Y.s2 + Y.se, 13U); Y.sa ^= rotate(Y.s6 + Y.s2, 18U); \
    Y.s3 ^= rotate(Y.sf + Y.sb, 7U);  Y.s7 ^= rotate(Y.s3 + Y.sf, 9U);  \
    Y.sb ^= rotate(Y.s7 + Y.s3, 13U); Y.sf ^= rotate(Y.sb + Y.s7, 18U); \
    Y.s1 ^= rotate(Y.s0 + Y.s3, 7U);  Y.s2 ^= rotate(Y.s1 + Y.s0, 9U);  \
    Y.s3 ^= rotate(Y.s2 + Y.s1, 13U); Y.s0 ^= rotate(Y.s3 + Y.s2, 18U); \
    Y.s6 ^= rotate(Y.s5 + Y.s4, 7U);  Y.s7 ^= rotate(Y.s6 + Y.s5, 9U);  \
    Y.s4 ^= rotate(Y.s7 + Y.s6, 13U); Y.s5 ^= rotate(Y.s4 + Y.s7, 18U); \
    Y.sb ^= rotate(Y.sa + Y.s9, 7U);  Y.s8 ^= rotate(Y.sb + Y.sa, 9U);  \
    Y.s9 ^= rotate(Y.s8 + Y.sb, 13U); Y.sa ^= rotate(Y.s9 + Y.s8, 18U); \
    Y.sc ^= rotate(Y.sf + Y.se, 7U);  Y.sd ^= rotate(Y.sc + Y.sf, 9U);  \
    Y.se ^= rotate(Y.sd + Y.sc, 13U); Y.sf ^= rotate(Y.se + Y.sd, 18U);

#define SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3) \
    Y0 ^= rotate(Y3 + Y2, (uint4)( 7,  7,  7,  7)); \
    Y1 ^= rotate(Y0 + Y3, (uint4)( 9,  9,  9,  9)); \
    Y2 ^= rotate(Y1 + Y0, (uint4)(13, 13, 13, 13)); \
    Y3 ^= rotate(Y2 + Y1, (uint4)(18, 18, 18, 18)); \
    Y2 ^= rotate(Y3.wxyz + Y0.zwxy, (uint4)( 7,  7,  7,  7)); \
    Y1 ^= rotate(Y2.wxyz + Y3.zwxy, (uint4)( 9,  9,  9,  9)); \
    Y0 ^= rotate(Y1.wxyz + Y2.zwxy, (uint4)(13, 13, 13, 13)); \
    Y3 ^= rotate(Y0.wxyz + Y1.zwxy, (uint4)(18, 18, 18, 18));

void neoscrypt_salsa(uint16 *X) {
    uint i;

#if (SALSA_SCALAR)

    uint16 Y = X[0];

#if (SALSA_UNROLL_LEVEL == 1)

    for(i = 0; i < 10; i++) {
        SALSA_CORE_SCALAR(Y);
    }

#elif (SALSA_UNROLL_LEVEL == 2)

    for(i = 0; i < 5; i++) {
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
    }

#elif (SALSA_UNROLL_LEVEL == 3)

    for(i = 0; i < 4; i++) {
        SALSA_CORE_SCALAR(Y);
        if(i == 3) break;
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
    }

#elif (SALSA_UNROLL_LEVEL == 4)

    for(i = 0; i < 3; i++) {
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
        if(i == 2) break;
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
     }

#else

    for(i = 0; i < 2; i++) {
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
        SALSA_CORE_SCALAR(Y);
    }

#endif

    X[0] += Y;

#else /* SALSA_VECTOR */

    uint4 Y0 = (uint4)(X[0].s4, X[0].s9, X[0].se, X[0].s3);
    uint4 Y1 = (uint4)(X[0].s8, X[0].sd, X[0].s2, X[0].s7);
    uint4 Y2 = (uint4)(X[0].sc, X[0].s1, X[0].s6, X[0].sb);
    uint4 Y3 = (uint4)(X[0].s0, X[0].s5, X[0].sa, X[0].sf);

#if (SALSA_UNROLL_LEVEL == 1)

    for(i = 0; i < 10; i++) {
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#elif (SALSA_UNROLL_LEVEL == 2)

    for(i = 0; i < 5; i++) {
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#elif (SALSA_UNROLL_LEVEL == 3)

    for(i = 0; i < 4; i++) {
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        if(i == 3) break;
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#elif (SALSA_UNROLL_LEVEL == 4)

    for(i = 0; i < 3; i++) {
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        if(i == 2) break;
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
     }

#else

    for(i = 0; i < 2; i++) {
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        SALSA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#endif

    X[0] += (uint16)(Y3.x, Y2.y, Y1.z, Y0.w, Y0.x, Y3.y, Y2.z, Y1.w,
                     Y1.x, Y0.y, Y3.z, Y2.w, Y2.x, Y1.y, Y0.z, Y3.w);

#endif
}


/* ChaCha20/20 */

#define CHACHA_CORE_SCALAR(Y) \
    Y.s0 += Y.s4; Y.sc = rotate(Y.sc ^ Y.s0, 16U); \
    Y.s8 += Y.sc; Y.s4 = rotate(Y.s4 ^ Y.s8, 12U); \
    Y.s0 += Y.s4; Y.sc = rotate(Y.sc ^ Y.s0, 8U);  \
    Y.s8 += Y.sc; Y.s4 = rotate(Y.s4 ^ Y.s8, 7U);  \
    Y.s1 += Y.s5; Y.sd = rotate(Y.sd ^ Y.s1, 16U); \
    Y.s9 += Y.sd; Y.s5 = rotate(Y.s5 ^ Y.s9, 12U); \
    Y.s1 += Y.s5; Y.sd = rotate(Y.sd ^ Y.s1, 8U);  \
    Y.s9 += Y.sd; Y.s5 = rotate(Y.s5 ^ Y.s9, 7U);  \
    Y.s2 += Y.s6; Y.se = rotate(Y.se ^ Y.s2, 16U); \
    Y.sa += Y.se; Y.s6 = rotate(Y.s6 ^ Y.sa, 12U); \
    Y.s2 += Y.s6; Y.se = rotate(Y.se ^ Y.s2, 8U);  \
    Y.sa += Y.se; Y.s6 = rotate(Y.s6 ^ Y.sa, 7U);  \
    Y.s3 += Y.s7; Y.sf = rotate(Y.sf ^ Y.s3, 16U); \
    Y.sb += Y.sf; Y.s7 = rotate(Y.s7 ^ Y.sb, 12U); \
    Y.s3 += Y.s7; Y.sf = rotate(Y.sf ^ Y.s3, 8U);  \
    Y.sb += Y.sf; Y.s7 = rotate(Y.s7 ^ Y.sb, 7U);  \
    Y.s0 += Y.s5; Y.sf = rotate(Y.sf ^ Y.s0, 16U); \
    Y.sa += Y.sf; Y.s5 = rotate(Y.s5 ^ Y.sa, 12U); \
    Y.s0 += Y.s5; Y.sf = rotate(Y.sf ^ Y.s0, 8U);  \
    Y.sa += Y.sf; Y.s5 = rotate(Y.s5 ^ Y.sa, 7U);  \
    Y.s1 += Y.s6; Y.sc = rotate(Y.sc ^ Y.s1, 16U); \
    Y.sb += Y.sc; Y.s6 = rotate(Y.s6 ^ Y.sb, 12U); \
    Y.s1 += Y.s6; Y.sc = rotate(Y.sc ^ Y.s1, 8U);  \
    Y.sb += Y.sc; Y.s6 = rotate(Y.s6 ^ Y.sb, 7U);  \
    Y.s2 += Y.s7; Y.sd = rotate(Y.sd ^ Y.s2, 16U); \
    Y.s8 += Y.sd; Y.s7 = rotate(Y.s7 ^ Y.s8, 12U); \
    Y.s2 += Y.s7; Y.sd = rotate(Y.sd ^ Y.s2, 8U);  \
    Y.s8 += Y.sd; Y.s7 = rotate(Y.s7 ^ Y.s8, 7U);  \
    Y.s3 += Y.s4; Y.se = rotate(Y.se ^ Y.s3, 16U); \
    Y.s9 += Y.se; Y.s4 = rotate(Y.s4 ^ Y.s9, 12U); \
    Y.s3 += Y.s4; Y.se = rotate(Y.se ^ Y.s3, 8U);  \
    Y.s9 += Y.se; Y.s4 = rotate(Y.s4 ^ Y.s9, 7U);

#define CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3) \
    Y0 += Y1; Y3 = rotate(Y3 ^ Y0, (uint4)(16, 16, 16, 16)); \
    Y2 += Y3; Y1 = rotate(Y1 ^ Y2, (uint4)(12, 12, 12, 12)); \
    Y0 += Y1; Y3 = rotate(Y3 ^ Y0, (uint4)( 8,  8,  8,  8)); \
    Y2 += Y3; Y1 = rotate(Y1 ^ Y2, (uint4)( 7,  7,  7,  7)); \
    Y0 += Y1.yzwx; Y3 = rotate(Y3 ^ Y0.yzwx, (uint4)(16, 16, 16, 16)); \
    Y2 += Y3.yzwx; Y1 = rotate(Y1 ^ Y2.yzwx, (uint4)(12, 12, 12, 12)); \
    Y0 += Y1.yzwx; Y3 = rotate(Y3 ^ Y0.yzwx, (uint4)( 8,  8,  8,  8)); \
    Y2 += Y3.yzwx; Y1 = rotate(Y1 ^ Y2.yzwx, (uint4)( 7,  7,  7,  7));

void neoscrypt_chacha(uint16 *X) {
    uint i;

#if (CHACHA_SCALAR)

    uint16 Y = X[0];

#if (CHACHA_UNROLL_LEVEL == 1)

    for(i = 0; i < 10; i++) {
        CHACHA_CORE_SCALAR(Y);
    }

#elif (CHACHA_UNROLL_LEVEL == 2)

    for(i = 0; i < 5; i++) {
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
    }

#elif (CHACHA_UNROLL_LEVEL == 3)

    for(i = 0; i < 4; i++) {
        CHACHA_CORE_SCALAR(Y);
        if(i == 3) break;
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
    }

#elif (CHACHA_UNROLL_LEVEL == 4)

    for(i = 0; i < 3; i++) {
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
        if(i == 2) break;
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
     }

#else

    for(i = 0; i < 2; i++) {
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
        CHACHA_CORE_SCALAR(Y);
    }

#endif

    X[0] += Y;

#else /* CHACHA_VECTOR */

    uint4 Y0 = X[0].s0123, Y1 = X[0].s4567,
          Y2 = X[0].s89ab, Y3 = X[0].scdef;

#if (CHACHA_UNROLL_LEVEL == 1)

    for(i = 0; i < 10; i++) {
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#elif (CHACHA_UNROLL_LEVEL == 2)

    for(i = 0; i < 5; i++) {
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#elif (CHACHA_UNROLL_LEVEL == 3)

    for(i = 0; i < 4; i++) {
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        if(i == 3) break;
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#elif (CHACHA_UNROLL_LEVEL == 4)

    for(i = 0; i < 3; i++) {
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        if(i == 2) break;
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
     }

#else

    for(i = 0; i < 2; i++) {
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
        CHACHA_CORE_VECTOR(Y0, Y1, Y2, Y3);
    }

#endif

    X[0] += (uint16)(Y0, Y1, Y2, Y3);

#endif
}


/* For compatibility */
#if (WORKGROUPSIZE) && !(WORKSIZE)
#define WORKSIZE WORKGROUPSIZE
#endif

/* CodeXL only */
#if !(WORKSIZE)
#define WORKSIZE 128
#endif


/* FastKDF, a fast buffered key derivation function;
 * this algorithm makes extensive use of bytewise operations */

/* FastKDF (stretching) */
void neoscrypt_fastkdf_str(ulong16 *XZ) {

    uint i, bufptr, offset;

    uint4 *XZq = (uint4 *) &XZ[0];

    uint *Ai = (uint *)   &XZq[0];
    uint *Bi = (uint *)   &XZq[20];
    uint8 *T = (uint8 *)  &XZq[38];
    uint4 *t = (uint4 *)  &XZq[38];

    for(i = 0, bufptr = 0; i < 32; i++) {

        uint16 S;
        uint m[16];

        offset = bufptr & 0x03;
        neoscrypt_copy32(&m[0], &Bi[bufptr >> 2], offset);

        m[8]  = 0;
        m[9]  = 0;
        m[10] = 0;
        m[11] = 0;
        m[12] = 0;
        m[13] = 0;
        m[14] = 0;
        m[15] = 0;

        T[0] = blake2s_IV4[0];
        S.lo = S.hi = T[0];

        S.s0 ^= 0x01012020U;
        S.sc ^= 64U;

#if (BLAKE2S_COMPACT)

        for(uint z = 0; z < 2; z++) {

#pragma unroll
            for(uint j = 0; j < 10; j++) {
#if (BLAKE2S_SCALAR)
                G(j,  0, S.s0, S.s4, S.s8, S.sc);
                G(j,  2, S.s1, S.s5, S.s9, S.sd);
                G(j,  4, S.s2, S.s6, S.sa, S.se);
                G(j,  6, S.s3, S.s7, S.sb, S.sf);
                G(j,  8, S.s0, S.s5, S.sa, S.sf);
                G(j, 10, S.s1, S.s6, S.sb, S.sc);
                G(j, 12, S.s2, S.s7, S.s8, S.sd);
                G(j, 14, S.s3, S.s4, S.s9, S.se);
#else
                G1(j, S.s0123, S.s4567, S.s89ab, S.scdef);
                G2(j, S.s0123, S.s5674, S.sab89, S.sfcde);
#endif
            }

            if(z) break;

            S.lo ^= S.hi ^ T[0];
            S.s0 ^= 0x01012020U;
            S.hi = T[0];
            T[0] = S.lo;
            S.sc ^= 128U;
            S.se ^= 0xFFFFFFFFU;

            neoscrypt_copy64(&m[0], &Ai[bufptr >> 2], offset);

        }

#else

#pragma unroll
        for(uint j = 0; j < 10; j++) {
#if (BLAKE2S_SCALAR)
            G(j,  0, S.s0, S.s4, S.s8, S.sc);
            G(j,  2, S.s1, S.s5, S.s9, S.sd);
            G(j,  4, S.s2, S.s6, S.sa, S.se);
            G(j,  6, S.s3, S.s7, S.sb, S.sf);
            G(j,  8, S.s0, S.s5, S.sa, S.sf);
            G(j, 10, S.s1, S.s6, S.sb, S.sc);
            G(j, 12, S.s2, S.s7, S.s8, S.sd);
            G(j, 14, S.s3, S.s4, S.s9, S.se);
#else
            G1(j, S.s0123, S.s4567, S.s89ab, S.scdef);
            G2(j, S.s0123, S.s5674, S.sab89, S.sfcde);
#endif
        }

        S.lo ^= S.hi ^ T[0];
        S.s0 ^= 0x01012020U;
        S.hi = T[0];
        T[0] = S.lo;
        S.sc ^= 128U;
        S.se ^= 0xFFFFFFFFU;

        neoscrypt_copy64(&m[0], &Ai[bufptr >> 2], offset);

#pragma unroll
        for(uint j = 0; j < 10; j++) {
#if (BLAKE2S_SCALAR)
            G(j,  0, S.s0, S.s4, S.s8, S.sc);
            G(j,  2, S.s1, S.s5, S.s9, S.sd);
            G(j,  4, S.s2, S.s6, S.sa, S.se);
            G(j,  6, S.s3, S.s7, S.sb, S.sf);
            G(j,  8, S.s0, S.s5, S.sa, S.sf);
            G(j, 10, S.s1, S.s6, S.sb, S.sc);
            G(j, 12, S.s2, S.s7, S.s8, S.sd);
            G(j, 14, S.s3, S.s4, S.s9, S.se);
#else
            G1(j, S.s0123, S.s4567, S.s89ab, S.scdef);
            G2(j, S.s0123, S.s5674, S.sab89, S.sfcde);
#endif
        }

#endif /* BLAKE2S_COMPACT */

        T[0] ^= S.lo ^ S.hi;

#if (FASTKDF_SCALAR)
        uint8 temp;

        temp.lo = t[0];
        temp.hi = t[1];

        bufptr  = temp.s0;
        bufptr += rotate(temp.s0, 24U);
        bufptr += rotate(temp.s0, 16U);
        bufptr += rotate(temp.s0, 8U);
        bufptr += temp.s1;
        bufptr += rotate(temp.s1, 24U);
        bufptr += rotate(temp.s1, 16U);
        bufptr += rotate(temp.s1, 8U);
        bufptr += temp.s2;
        bufptr += rotate(temp.s2, 24U);
        bufptr += rotate(temp.s2, 16U);
        bufptr += rotate(temp.s2, 8U);
        bufptr += temp.s3;
        bufptr += rotate(temp.s3, 24U);
        bufptr += rotate(temp.s3, 16U);
        bufptr += rotate(temp.s3, 8U);
        bufptr += temp.s4;
        bufptr += rotate(temp.s4, 24U);
        bufptr += rotate(temp.s4, 16U);
        bufptr += rotate(temp.s4, 8U);
        bufptr += temp.s5;
        bufptr += rotate(temp.s5, 24U);
        bufptr += rotate(temp.s5, 16U);
        bufptr += rotate(temp.s5, 8U);
        bufptr += temp.s6;
        bufptr += rotate(temp.s6, 24U);
        bufptr += rotate(temp.s6, 16U);
        bufptr += rotate(temp.s6, 8U);
        bufptr += temp.s7;
        bufptr += rotate(temp.s7, 24U);
        bufptr += rotate(temp.s7, 16U);
        bufptr += rotate(temp.s7, 8U);

        bufptr = convert_uchar(bufptr);
#else
        uint4 temp;
        temp  = t[0];
        temp += rotate(t[0], (uint4)(24, 24, 24, 24));
        temp += rotate(t[0], (uint4)(16, 16, 16, 16));
        temp += rotate(t[0], (uint4)( 8,  8,  8,  8));
        temp += t[1];
        temp += rotate(t[1], (uint4)(24, 24, 24, 24));
        temp += rotate(t[1], (uint4)(16, 16, 16, 16));
        temp += rotate(t[1], (uint4)( 8,  8,  8,  8));

        bufptr = convert_uchar(temp.x + temp.y + temp.z + temp.w);
#endif

        offset = bufptr & 0x03;
        neoscrypt_xor32_au(&Bi[bufptr >> 2], &T[0], offset);

        if(bufptr < 32U) {
            XZq[36] = XZq[20];
            XZq[37] = XZq[21];
            continue;
        }

        if(bufptr > 224U) {
            XZq[20] = XZq[36];
            XZq[21] = XZq[37];
        }

    }

    i = (256 - bufptr + 31) >> 5;
    neoscrypt_xor32_ua_it(&Ai[0], &Bi[bufptr >> 2], offset, i);
    neoscrypt_xor32_ua_it(&Ai[i << 3], &Bi[(bufptr & 0x1FU) >> 2], offset, 8U - i);
}

/* FastKDF (compressing) */
void neoscrypt_fastkdf_comp(ulong16 *XZ) {

    uint i, bufptr, offset;

    uint4 *XZq = (uint4 *) &XZ[0];

    uint *Ai = (uint *)   &XZq[20];
    uint *Bi = (uint *)   &XZq[0];
    uint8 *T = (uint8 *)  &XZq[18];
    uint4 *t = (uint4 *)  &XZq[18];

    for(i = 0, bufptr = 0; i < 32; i++) {

        uint16 S;
        uint m[16];

        offset = bufptr & 0x03;
        neoscrypt_copy32(&m[0], &Bi[bufptr >> 2], offset);

        m[8]  = 0;
        m[9]  = 0;
        m[10] = 0;
        m[11] = 0;
        m[12] = 0;
        m[13] = 0;
        m[14] = 0;
        m[15] = 0;

        T[0] = blake2s_IV4[0];
        S.lo = S.hi = T[0];

        S.s0 ^= 0x01012020U;
        S.sc ^= 64U;

#if (BLAKE2S_COMPACT)

        for(uint z = 0; z < 2; z++) {

#pragma unroll
            for(uint j = 0; j < 10; j++) {
#if (BLAKE2S_SCALAR)
                G(j,  0, S.s0, S.s4, S.s8, S.sc);
                G(j,  2, S.s1, S.s5, S.s9, S.sd);
                G(j,  4, S.s2, S.s6, S.sa, S.se);
                G(j,  6, S.s3, S.s7, S.sb, S.sf);
                G(j,  8, S.s0, S.s5, S.sa, S.sf);
                G(j, 10, S.s1, S.s6, S.sb, S.sc);
                G(j, 12, S.s2, S.s7, S.s8, S.sd);
                G(j, 14, S.s3, S.s4, S.s9, S.se);
#else
                G1(j, S.s0123, S.s4567, S.s89ab, S.scdef);
                G2(j, S.s0123, S.s5674, S.sab89, S.sfcde);
#endif
            }

            if(z) break;

            S.lo ^= S.hi ^ T[0];
            S.s0 ^= 0x01012020U;
            S.hi = T[0];
            T[0] = S.lo;
            S.sc ^= 128U;
            S.se ^= 0xFFFFFFFFU;

            neoscrypt_copy64(&m[0], &Ai[bufptr >> 2], offset);

        }

#else

#pragma unroll
        for(uint j = 0; j < 10; j++) {
#if (BLAKE2S_SCALAR)
            G(j,  0, S.s0, S.s4, S.s8, S.sc);
            G(j,  2, S.s1, S.s5, S.s9, S.sd);
            G(j,  4, S.s2, S.s6, S.sa, S.se);
            G(j,  6, S.s3, S.s7, S.sb, S.sf);
            G(j,  8, S.s0, S.s5, S.sa, S.sf);
            G(j, 10, S.s1, S.s6, S.sb, S.sc);
            G(j, 12, S.s2, S.s7, S.s8, S.sd);
            G(j, 14, S.s3, S.s4, S.s9, S.se);
#else
            G1(j, S.s0123, S.s4567, S.s89ab, S.scdef);
            G2(j, S.s0123, S.s5674, S.sab89, S.sfcde);
#endif
        }

        S.lo ^= S.hi ^ T[0];
        S.s0 ^= 0x01012020U;
        S.hi = T[0];
        T[0] = S.lo;
        S.sc ^= 128U;
        S.se ^= 0xFFFFFFFFU;

        neoscrypt_copy64(&m[0], &Ai[bufptr >> 2], offset);

#pragma unroll
        for(uint j = 0; j < 10; j++) {
#if (BLAKE2S_SCALAR)
            G(j,  0, S.s0, S.s4, S.s8, S.sc);
            G(j,  2, S.s1, S.s5, S.s9, S.sd);
            G(j,  4, S.s2, S.s6, S.sa, S.se);
            G(j,  6, S.s3, S.s7, S.sb, S.sf);
            G(j,  8, S.s0, S.s5, S.sa, S.sf);
            G(j, 10, S.s1, S.s6, S.sb, S.sc);
            G(j, 12, S.s2, S.s7, S.s8, S.sd);
            G(j, 14, S.s3, S.s4, S.s9, S.se);
#else
            G1(j, S.s0123, S.s4567, S.s89ab, S.scdef);
            G2(j, S.s0123, S.s5674, S.sab89, S.sfcde);
#endif
        }

#endif /* BLAKE2S_COMPACT */

        T[0] ^= S.lo ^ S.hi;

#if (FASTKDF_SCALAR)
        uint8 temp;

        temp.lo = t[0];
        temp.hi = t[1];

        bufptr  = temp.s0;
        bufptr += rotate(temp.s0, 24U);
        bufptr += rotate(temp.s0, 16U);
        bufptr += rotate(temp.s0, 8U);
        bufptr += temp.s1;
        bufptr += rotate(temp.s1, 24U);
        bufptr += rotate(temp.s1, 16U);
        bufptr += rotate(temp.s1, 8U);
        bufptr += temp.s2;
        bufptr += rotate(temp.s2, 24U);
        bufptr += rotate(temp.s2, 16U);
        bufptr += rotate(temp.s2, 8U);
        bufptr += temp.s3;
        bufptr += rotate(temp.s3, 24U);
        bufptr += rotate(temp.s3, 16U);
        bufptr += rotate(temp.s3, 8U);
        bufptr += temp.s4;
        bufptr += rotate(temp.s4, 24U);
        bufptr += rotate(temp.s4, 16U);
        bufptr += rotate(temp.s4, 8U);
        bufptr += temp.s5;
        bufptr += rotate(temp.s5, 24U);
        bufptr += rotate(temp.s5, 16U);
        bufptr += rotate(temp.s5, 8U);
        bufptr += temp.s6;
        bufptr += rotate(temp.s6, 24U);
        bufptr += rotate(temp.s6, 16U);
        bufptr += rotate(temp.s6, 8U);
        bufptr += temp.s7;
        bufptr += rotate(temp.s7, 24U);
        bufptr += rotate(temp.s7, 16U);
        bufptr += rotate(temp.s7, 8U);

        bufptr = convert_uchar(bufptr);
#else
        uint4 temp;
        temp  = t[0];
        temp += rotate(t[0], (uint4)(24, 24, 24, 24));
        temp += rotate(t[0], (uint4)(16, 16, 16, 16));
        temp += rotate(t[0], (uint4)( 8,  8,  8,  8));
        temp += t[1];
        temp += rotate(t[1], (uint4)(24, 24, 24, 24));
        temp += rotate(t[1], (uint4)(16, 16, 16, 16));
        temp += rotate(t[1], (uint4)( 8,  8,  8,  8));

        bufptr = convert_uchar(temp.x + temp.y + temp.z + temp.w);
#endif

        /* Modify the salt buffer */
        offset = bufptr & 0x03;
        neoscrypt_xor32_au(&Bi[bufptr >> 2], &T[0], offset);

        if(bufptr < 32U) {
            XZq[16] = XZq[0];
            XZq[17] = XZq[1];
            continue;
        }

        if(bufptr > 224U) {
            XZq[0] = XZq[16];
            XZq[1] = XZq[17];
        }

    }

    /* Most significant uint only */
    neoscrypt_xor4_ua(&Ai[7], &Bi[(bufptr >> 2) + 7], offset);
}


__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global const uint4 *restrict input, __global uint *restrict output,
  __global ulong16 *restrict globalcache, const uint target) {

    uint i, j, k;

    uint glbid = get_global_id(0);
    uint grpid = get_group_id(0);
    __global ulong16 *G = (__global ulong16 *) &globalcache[mul24(grpid, (uint)(WORKSIZE << 8))];

    uint lclid = glbid & (WORKSIZE - 1);

    ulong16 XZ[5];
    uint16 *XZh = (uint16 *) &XZ[0];
    uint4  *XZq = (uint4 *)  &XZ[0];
    uint   *XZi = (uint *)   &XZ[0];

    /* 1st FastKDF buffer initialisation */
    const uint4 mod = (uint4)(input[4].x, input[4].y, input[4].z, glbid);

    XZh[0] = XZh[5] = (uint16)(input[0], input[1], input[2], input[3]);
    XZh[1] = XZh[6] = (uint16)(mod, input[0], input[1], input[2]);
    XZh[2] = XZh[7] = (uint16)(input[3], mod, input[0], input[1]);
    XZh[3] = XZh[8] = (uint16)(input[2], input[3], mod, input[0]);
    XZq[16] = XZq[36] = input[0];
    XZq[17] = XZq[37] = input[1];
    XZq[18] = input[2];
    XZq[19] = input[3];

    /* FastKDF (stretching) */
    neoscrypt_fastkdf_str(XZ);

    /* blkcpy(Z, X) */
    neoscrypt_copy256(&XZ[2], &XZ[0]);

#if 1
    /* X = SMix(X) and Z = SMix(Z) */
    for(i = 0; i < 2; i++) {

        for(j = 0; j < 128; j++) {
            /* blkcpy(G, X) */
            k = rotate(mad24(j, (uint)WORKSIZE, lclid), 1U);
            G[k]     = XZ[0];
            G[k + 1] = XZ[1];

            /* blkmix(X) */
            XZh[0] ^= XZh[3];
            if(i) {
                neoscrypt_salsa(&XZh[0]);
                XZh[1] ^= XZh[0];
                neoscrypt_salsa(&XZh[1]);
                XZh[2] ^= XZh[1];
                neoscrypt_salsa(&XZh[2]);
                XZh[3] ^= XZh[2];
                neoscrypt_salsa(&XZh[3]);
            } else {
                neoscrypt_chacha(&XZh[0]);
                XZh[1] ^= XZh[0];
                neoscrypt_chacha(&XZh[1]);
                XZh[2] ^= XZh[1];
                neoscrypt_chacha(&XZh[2]);
                XZh[3] ^= XZh[2];
                neoscrypt_chacha(&XZh[3]);
            }
            neoscrypt_swap64(&XZh[2], &XZh[1]);

        }

        for(j = 0; j < 128; j++) {

            /* integerify(X) mod N */
            k = rotate(mad24((((uint *) XZ)[48] & 0x7F), (uint)WORKSIZE, lclid), 1U);

            /* blkxor(X, G) */
            XZ[0] ^= G[k];
            XZ[1] ^= G[k + 1];

            /* blkmix(X) */
            XZh[0] ^= XZh[3];
            if(i) {
                neoscrypt_salsa(&XZh[0]);
                XZh[1] ^= XZh[0];
                neoscrypt_salsa(&XZh[1]);
                XZh[2] ^= XZh[1];
                neoscrypt_salsa(&XZh[2]);
                XZh[3] ^= XZh[2];
                neoscrypt_salsa(&XZh[3]);
            } else {
                neoscrypt_chacha(&XZh[0]);
                XZh[1] ^= XZh[0];
                neoscrypt_chacha(&XZh[1]);
                XZh[2] ^= XZh[1];
                neoscrypt_chacha(&XZh[2]);
                XZh[3] ^= XZh[2];
                neoscrypt_chacha(&XZh[3]);
            }
            neoscrypt_swap64(&XZh[2], &XZh[1]);
        }

        if(i) break;

        /* Swap the buffers and repeat */
        neoscrypt_swap256(&XZ[2], &XZ[0]);

    }
#endif
    /* blkxor(X, Z) */
    neoscrypt_xor256(&XZ[0], &XZ[2]);

    /* 2nd FastKDF buffer initialisation */
    XZq[16] = XZq[0];
    XZq[17] = XZq[1];

    XZh[5] = (uint16)(input[0], input[1], input[2], input[3]);
    XZh[6] = (uint16)(mod, input[0], input[1], input[2]);
    XZh[7] = (uint16)(input[3], mod, input[0], input[1]);
    XZh[8] = (uint16)(input[2], input[3], mod, input[0]);
    XZh[9] = XZh[5];

    /* FastKDF (compressing) */
    neoscrypt_fastkdf_comp(XZ);

#define NEOSCRYPT_FOUND (0xFF)
#ifdef cl_khr_global_int32_base_atomics
    #define SETFOUND(nonce) output[atomic_add(&output[NEOSCRYPT_FOUND], 1)] = nonce
#else
    #define SETFOUND(nonce) output[output[NEOSCRYPT_FOUND]++] = nonce
#endif

    if(XZi[87] <= target) SETFOUND(glbid);

    return;
}
