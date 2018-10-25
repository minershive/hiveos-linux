/* $Id: blake.c 252 2011-06-07 17:55:14Z tp $ */
/*
 * BLAKE implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2007-2010  Projet RNRT SAPHIR
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
 * @author   Thomas Pornin <thomas.pornin@cryptolog.com>
 */

#ifndef WOLF_BLAKE_CL
#define WOLF_BLAKE_CL

// Modified version of SPH Blake implementation by Wolf

#define Z00   0
#define Z01   1
#define Z02   2
#define Z03   3
#define Z04   4
#define Z05   5
#define Z06   6
#define Z07   7
#define Z08   8
#define Z09   9
#define Z0A   A
#define Z0B   B
#define Z0C   C
#define Z0D   D
#define Z0E   E
#define Z0F   F

#define Z10   E
#define Z11   A
#define Z12   4
#define Z13   8
#define Z14   9
#define Z15   F
#define Z16   D
#define Z17   6
#define Z18   1
#define Z19   C
#define Z1A   0
#define Z1B   2
#define Z1C   B
#define Z1D   7
#define Z1E   5
#define Z1F   3

#define Z20   B
#define Z21   8
#define Z22   C
#define Z23   0
#define Z24   5
#define Z25   2
#define Z26   F
#define Z27   D
#define Z28   A
#define Z29   E
#define Z2A   3
#define Z2B   6
#define Z2C   7
#define Z2D   1
#define Z2E   9
#define Z2F   4

#define Z30   7
#define Z31   9
#define Z32   3
#define Z33   1
#define Z34   D
#define Z35   C
#define Z36   B
#define Z37   E
#define Z38   2
#define Z39   6
#define Z3A   5
#define Z3B   A
#define Z3C   4
#define Z3D   0
#define Z3E   F
#define Z3F   8

#define Z40   9
#define Z41   0
#define Z42   5
#define Z43   7
#define Z44   2
#define Z45   4
#define Z46   A
#define Z47   F
#define Z48   E
#define Z49   1
#define Z4A   B
#define Z4B   C
#define Z4C   6
#define Z4D   8
#define Z4E   3
#define Z4F   D

#define Z50   2
#define Z51   C
#define Z52   6
#define Z53   A
#define Z54   0
#define Z55   B
#define Z56   8
#define Z57   3
#define Z58   4
#define Z59   D
#define Z5A   7
#define Z5B   5
#define Z5C   F
#define Z5D   E
#define Z5E   1
#define Z5F   9

#define Z60   C
#define Z61   5
#define Z62   1
#define Z63   F
#define Z64   E
#define Z65   D
#define Z66   4
#define Z67   A
#define Z68   0
#define Z69   7
#define Z6A   6
#define Z6B   3
#define Z6C   9
#define Z6D   2
#define Z6E   8
#define Z6F   B

#define Z70   D
#define Z71   B
#define Z72   7
#define Z73   E
#define Z74   C
#define Z75   1
#define Z76   3
#define Z77   9
#define Z78   5
#define Z79   0
#define Z7A   F
#define Z7B   4
#define Z7C   8
#define Z7D   6
#define Z7E   2
#define Z7F   A

#define Z80   6
#define Z81   F
#define Z82   E
#define Z83   9
#define Z84   B
#define Z85   3
#define Z86   0
#define Z87   8
#define Z88   C
#define Z89   2
#define Z8A   D
#define Z8B   7
#define Z8C   1
#define Z8D   4
#define Z8E   A
#define Z8F   5

#define Z90   A
#define Z91   2
#define Z92   8
#define Z93   4
#define Z94   7
#define Z95   6
#define Z96   1
#define Z97   5
#define Z98   F
#define Z99   B
#define Z9A   9
#define Z9B   E
#define Z9C   3
#define Z9D   C
#define Z9E   D
#define Z9F   0

#define Mx(r, i)    Mx_(Z ## r ## i)
#define Mx_(n)      Mx__(n)
#define Mx__(n)		M[0x ## n]

#define CBx(r, i)   CBx_(Z ## r ## i)
#define CBx_(n)     CBx__(n)
#define CBx__(n)    CB ## n

#define CB0   0x243F6A8885A308D3UL
#define CB1   0x13198A2E03707344UL
#define CB2   0xA4093822299F31D0UL
#define CB3   0x082EFA98EC4E6C89UL
#define CB4   0x452821E638D01377UL
#define CB5   0xBE5466CF34E90C6CUL
#define CB6   0xC0AC29B7C97C50DDUL
#define CB7   0x3F84D5B5B5470917UL
#define CB8   0x9216D5D98979FB1BUL
#define CB9   0xD1310BA698DFB5ACUL
#define CBA   0x2FFD72DBD01ADFB7UL
#define CBB   0xB8E1AFED6A267E96UL
#define CBC   0xBA7C9045F12C7F99UL
#define CBD   0x24A19947B3916CF7UL
#define CBE   0x0801F2E2858EFC16UL
#define CBF   0x636920D871574E69UL

#define GB(m0, m1, c0, c1, a, b, c, d)   do { \
    a += b + (m0 ^ c1); \
    d = as_ulong(as_uint2(d ^ a).s10); \
    c += d; \
    b = FAST_ROTL64_HI(as_uint2(b ^ c), 39U); \
    a += b + (m1 ^ c0); \
    d = as_ulong(as_ushort4(d ^ a).s1230); \
    c += d; \
    b = FAST_ROTL64_HI(as_uint2(b ^ c), 53U); \
  } while (0)

#define ROUND_B(r)   do { \
    GB(Mx(r, 0), Mx(r, 1), CBx(r, 0), CBx(r, 1), V[0], V[4], V[8], V[12]); \
    GB(Mx(r, 2), Mx(r, 3), CBx(r, 2), CBx(r, 3), V[1], V[5], V[9], V[13]); \
    GB(Mx(r, 4), Mx(r, 5), CBx(r, 4), CBx(r, 5), V[2], V[6], V[10], V[14]); \
    GB(Mx(r, 6), Mx(r, 7), CBx(r, 6), CBx(r, 7), V[3], V[7], V[11], V[15]); \
    GB(Mx(r, 8), Mx(r, 9), CBx(r, 8), CBx(r, 9), V[0], V[5], V[10], V[15]); \
    GB(Mx(r, A), Mx(r, B), CBx(r, A), CBx(r, B), V[1], V[6], V[11], V[12]); \
    GB(Mx(r, C), Mx(r, D), CBx(r, C), CBx(r, D), V[2], V[7], V[8], V[13]); \
    GB(Mx(r, E), Mx(r, F), CBx(r, E), CBx(r, F), V[3], V[4], V[9], V[14]); \
  } while (0)

static const __constant ulong BLAKE512_IV[8] =
{
	0x6A09E667F3BCC908UL, 0xBB67AE8584CAA73BUL, 0x3C6EF372FE94F82BUL, 0xA54FF53A5F1D36F1UL,
	0x510E527FADE682D1UL, 0x9B05688C2B3E6C1FUL, 0x1F83D9ABFB41BD6BUL, 0x5BE0CD19137E2179UL
};

#define SIGMA_00	0x0
#define SIGMA_01	0x1
#define SIGMA_02	0x2
#define SIGMA_03	0x3
#define SIGMA_04	0x4
#define SIGMA_05	0x5
#define SIGMA_06	0x6
#define SIGMA_07	0x7
#define SIGMA_08	0x8
#define SIGMA_09	0x9
#define SIGMA_0A	0xA
#define SIGMA_0B	0xB
#define SIGMA_0C	0xC
#define SIGMA_0D	0xD
#define SIGMA_0E	0xE
#define SIGMA_0F	0xF

#define SIGMA_10	0xE
#define SIGMA_11	0xA
#define SIGMA_12	0x4
#define SIGMA_13	0x8
#define SIGMA_14	0x9
#define SIGMA_15	0xF
#define SIGMA_16	0xD
#define SIGMA_17	0x6
#define SIGMA_18	0x1
#define SIGMA_19	0xC
#define SIGMA_1A	0x0
#define SIGMA_1B	0x2
#define SIGMA_1C	0xB
#define SIGMA_1D	0x7
#define SIGMA_1E	0x5
#define SIGMA_1F	0x3

#define SIGMA_20	0xB
#define SIGMA_21	0x8
#define SIGMA_22	0xC
#define SIGMA_23	0x0
#define SIGMA_24	0x5
#define SIGMA_25	0x2
#define SIGMA_26	0xF
#define SIGMA_27	0xD
#define SIGMA_28	0xA
#define SIGMA_29	0xE
#define SIGMA_2A	0x3
#define SIGMA_2B	0x6
#define SIGMA_2C	0x7
#define SIGMA_2D	0x1
#define SIGMA_2E	0x9
#define SIGMA_2F	0x4

#define SIGMA_30	0x7
#define SIGMA_31	0x9
#define SIGMA_32	0x3
#define SIGMA_33	0x1
#define SIGMA_34	0xD
#define SIGMA_35	0xC
#define SIGMA_36	0xB
#define SIGMA_37	0xE
#define SIGMA_38	0x2
#define SIGMA_39	0x6
#define SIGMA_3A	0x5
#define SIGMA_3B	0xA
#define SIGMA_3C	0x4
#define SIGMA_3D	0x0
#define SIGMA_3E	0xF
#define SIGMA_3F	0x8

#define SIGMA_40	0x9
#define SIGMA_41	0x0
#define SIGMA_42	0x5
#define SIGMA_43	0x7
#define SIGMA_44	0x2
#define SIGMA_45	0x4
#define SIGMA_46	0xA
#define SIGMA_47	0xF
#define SIGMA_48	0xE
#define SIGMA_49	0x1
#define SIGMA_4A	0xB
#define SIGMA_4B	0xC
#define SIGMA_4C	0x6
#define SIGMA_4D	0x8
#define SIGMA_4E	0x3
#define SIGMA_4F	0xD

#define SIGMA_50	0x2
#define SIGMA_51	0xC
#define SIGMA_52	0x6
#define SIGMA_53	0xA
#define SIGMA_54	0x0
#define SIGMA_55	0xB
#define SIGMA_56	0x8
#define SIGMA_57	0x3
#define SIGMA_58	0x4
#define SIGMA_59	0xD
#define SIGMA_5A	0x7
#define SIGMA_5B	0x5
#define SIGMA_5C	0xF
#define SIGMA_5D	0xE
#define SIGMA_5E	0x1
#define SIGMA_5F	0x9

#define SIGMA_60	0xC
#define SIGMA_61	0x5
#define SIGMA_62	0x1
#define SIGMA_63	0xF
#define SIGMA_64	0xE
#define SIGMA_65	0xD
#define SIGMA_66	0x4
#define SIGMA_67	0xA
#define SIGMA_68	0x0
#define SIGMA_69	0x7
#define SIGMA_6A	0x6
#define SIGMA_6B	0x3
#define SIGMA_6C	0x9
#define SIGMA_6D	0x2
#define SIGMA_6E	0x8
#define SIGMA_6F	0xB

#define SIGMA_70	0xD
#define SIGMA_71	0xB
#define SIGMA_72	0x7
#define SIGMA_73	0xE
#define SIGMA_74	0xC
#define SIGMA_75	0x1
#define SIGMA_76	0x3
#define SIGMA_77	0x9
#define SIGMA_78	0x5
#define SIGMA_79	0x0
#define SIGMA_7A	0xF
#define SIGMA_7B	0x4
#define SIGMA_7C	0x8
#define SIGMA_7D	0x6
#define SIGMA_7E	0x2
#define SIGMA_7F	0xA

#define SIGMA_80	0x6
#define SIGMA_81	0xF
#define SIGMA_82	0xE
#define SIGMA_83	0x9
#define SIGMA_84	0xB
#define SIGMA_85	0x3
#define SIGMA_86	0x0
#define SIGMA_87	0x8
#define SIGMA_88	0xC
#define SIGMA_89	0x2
#define SIGMA_8A	0xD
#define SIGMA_8B	0x7
#define SIGMA_8C	0x1
#define SIGMA_8D	0x4
#define SIGMA_8E	0xA
#define SIGMA_8F	0x5

#define SIGMA_90	0xA
#define SIGMA_91	0x2
#define SIGMA_92	0x8
#define SIGMA_93	0x4
#define SIGMA_94	0x7
#define SIGMA_95	0x6
#define SIGMA_96	0x1
#define SIGMA_97	0x5
#define SIGMA_98	0xF
#define SIGMA_99	0xB
#define SIGMA_9A	0x9
#define SIGMA_9B	0xE
#define SIGMA_9C	0x3
#define SIGMA_9D	0xC
#define SIGMA_9E	0xD
#define SIGMA_9F	0x0

#define SIGMA_A0	0x0
#define SIGMA_A1	0x1
#define SIGMA_A2	0x2
#define SIGMA_A3	0x3
#define SIGMA_A4	0x4
#define SIGMA_A5	0x5
#define SIGMA_A6	0x6
#define SIGMA_A7	0x7
#define SIGMA_A8	0x8
#define SIGMA_A9	0x9
#define SIGMA_AA	0xA
#define SIGMA_AB	0xB
#define SIGMA_AC	0xC
#define SIGMA_AD	0xD
#define SIGMA_AE	0xE
#define SIGMA_AF	0xF

#define SIGMA_B0	0xE
#define SIGMA_B1	0xA
#define SIGMA_B2	0x4
#define SIGMA_B3	0x8
#define SIGMA_B4	0x9
#define SIGMA_B5	0xF
#define SIGMA_B6	0xD
#define SIGMA_B7	0x6
#define SIGMA_B8	0x1
#define SIGMA_B9	0xC
#define SIGMA_BA	0x0
#define SIGMA_BB	0x2
#define SIGMA_BC	0xB
#define SIGMA_BD	0x7
#define SIGMA_BE	0x5
#define SIGMA_BF	0x3

#define SIGMA_C0	0xB
#define SIGMA_C1	0x8
#define SIGMA_C2	0xC
#define SIGMA_C3	0x0
#define SIGMA_C4	0x5
#define SIGMA_C5	0x2
#define SIGMA_C6	0xF
#define SIGMA_C7	0xD
#define SIGMA_C8	0xA
#define SIGMA_C9	0xE
#define SIGMA_CA	0x3
#define SIGMA_CB	0x6
#define SIGMA_CC	0x7
#define SIGMA_CD	0x1
#define SIGMA_CE	0x9
#define SIGMA_CF	0x4

#define SIGMA_D0	0x7
#define SIGMA_D1	0x9
#define SIGMA_D2	0x3
#define SIGMA_D3	0x1
#define SIGMA_D4	0xD
#define SIGMA_D5	0xC
#define SIGMA_D6	0xB
#define SIGMA_D7	0xE
#define SIGMA_D8	0x2
#define SIGMA_D9	0x6
#define SIGMA_DA	0x5
#define SIGMA_DB	0xA
#define SIGMA_DC	0x4
#define SIGMA_DD	0x0
#define SIGMA_DE	0xF
#define SIGMA_DF	0x8

#define SIGMA_E0	0x9
#define SIGMA_E1	0x0
#define SIGMA_E2	0x5
#define SIGMA_E3	0x7
#define SIGMA_E4	0x2
#define SIGMA_E5	0x4
#define SIGMA_E6	0xA
#define SIGMA_E7	0xF
#define SIGMA_E8	0xE
#define SIGMA_E9	0x1
#define SIGMA_EA	0xB
#define SIGMA_EB	0xC
#define SIGMA_EC	0x6
#define SIGMA_ED	0x8
#define SIGMA_EE	0x3
#define SIGMA_EF	0xD

#define SIGMA_F0	0x2
#define SIGMA_F1	0xC
#define SIGMA_F2	0x6
#define SIGMA_F3	0xA
#define SIGMA_F4	0x0
#define SIGMA_F5	0xB
#define SIGMA_F6	0x8
#define SIGMA_F7	0x3
#define SIGMA_F8	0x4
#define SIGMA_F9	0xD
#define SIGMA_FA	0x7
#define SIGMA_FB	0x5
#define SIGMA_FC	0xF
#define SIGMA_FD	0xE
#define SIGMA_FE	0x1
#define SIGMA_FF	0x9

#define CB0		0x243F6A8885A308D3UL
#define CB1		0x13198A2E03707344UL
#define CB2		0xA4093822299F31D0UL
#define CB3		0x082EFA98EC4E6C89UL
#define CB4		0x452821E638D01377UL
#define CB5		0xBE5466CF34E90C6CUL
#define CB6		0xC0AC29B7C97C50DDUL
#define CB7		0x3F84D5B5B5470917UL
#define CB8		0x9216D5D98979FB1BUL
#define CB9		0xD1310BA698DFB5ACUL
#define CBA		0x2FFD72DBD01ADFB7UL
#define CBB		0xB8E1AFED6A267E96UL
#define CBC		0xBA7C9045F12C7F99UL
#define CBD		0x24A19947B3916CF7UL
#define CBE		0x0801F2E2858EFC16UL
#define CBF		0x636920D871574E69UL

#define GET_SIGMA(x, n)		SIGMA_ ## x ## n
#define GET_CB(x)			CB ## x

static const __constant uchar blake_sigma[160] = 
{
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 ,
	 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 ,
	 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 ,
	  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 ,
	  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 ,
	  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 ,
	 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 ,
	 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 ,
	  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 ,
	 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13,  0
};

#define BLAKE_PARALLEL_G1(a, b, c, d, rnd) do { \
		a += b + ((ulong4)(M[blake_sigma[(rnd << 4) + 0]], M[blake_sigma[(rnd << 4) + 2]], M[blake_sigma[(rnd << 4) + 4]], M[blake_sigma[(rnd << 4) + 6]]) ^ (ulong4)(blake_cb[blake_sigma[(rnd << 4) + 1]], blake_cb[blake_sigma[(rnd << 4) + 3]], blake_cb[blake_sigma[(rnd << 4) + 5]], blake_cb[blake_sigma[(rnd << 4) + 7]])); \
		d = as_ulong4(as_uint8(d ^ a).s10325476); \
		c += d; \
		b = rotate(b ^ c, 39UL); \
		a += b + ((ulong4)(M[blake_sigma[(rnd << 4) + 1]], M[blake_sigma[(rnd << 4) + 3]], M[blake_sigma[(rnd << 4) + 5]], M[blake_sigma[(rnd << 4) + 7]]) ^ (ulong4)(blake_cb[blake_sigma[(rnd << 4) + 0]], blake_cb[blake_sigma[(rnd << 4) + 2]], blake_cb[blake_sigma[(rnd << 4) + 4]], blake_cb[blake_sigma[(rnd << 4) + 6]])); \
		d = rotate(d ^ a, 48UL); \
		c += d;	\
		b = rotate(b ^ c, 53UL); \
} while(0)

#define BLAKE_PARALLEL_G2(a, b, c, d, rnd) do { \
		a += b + ((ulong4)(M[blake_sigma[(rnd << 4) + 8]], M[blake_sigma[(rnd << 4) + 0x0A]], M[blake_sigma[(rnd << 4) + 0x0C]], M[blake_sigma[(rnd << 4) + 0x0E]]) ^ (ulong4)(blake_cb[blake_sigma[(rnd << 4) + 9]], blake_cb[blake_sigma[(rnd << 4) + 0x0B]], blake_cb[blake_sigma[(rnd << 4) + 0x0D]], blake_cb[blake_sigma[(rnd << 4) + 0x0F]])); \
		d = as_ulong4(as_uint8(d ^ a).s10325476); \
		c += d; \
		b = rotate(b ^ c, 39UL); \
		a += b + ((ulong4)(M[blake_sigma[(rnd << 4) + 9]], M[blake_sigma[(rnd << 4) + 0x0B]], M[blake_sigma[(rnd << 4) + 0x0D]], M[blake_sigma[(rnd << 4) + 0x0F]]) ^ (ulong4)(blake_cb[blake_sigma[(rnd << 4) + 8]], blake_cb[blake_sigma[(rnd << 4) + 0x0A]], blake_cb[blake_sigma[(rnd << 4) + 0x0C]], blake_cb[blake_sigma[(rnd << 4) + 0x0E]])); \
		d = rotate(d ^ a, 48UL); \
		c += d;	\
		b = rotate(b ^ c, 53UL); \
} while(0)

#define BLAKE_RND(rnd) BLAKE_PARALLEL_G1(V.s0123, V.s4567, V.s89ab, V.scdef, rnd); BLAKE_PARALLEL_G2(V.s0123, V.s5674, V.sab89, V.sfcde, rnd);

static const __constant ulong blake_cb[16] =
{
	0x243F6A8885A308D3UL, 0x13198A2E03707344UL,
	0xA4093822299F31D0UL, 0x082EFA98EC4E6C89UL,
	0x452821E638D01377UL, 0xBE5466CF34E90C6CUL,
	0xC0AC29B7C97C50DDUL, 0x3F84D5B5B5470917UL,
	0x9216D5D98979FB1BUL, 0xD1310BA698DFB5ACUL,
	0x2FFD72DBD01ADFB7UL, 0xB8E1AFED6A267E96UL,
	0xBA7C9045F12C7F99UL, 0x24A19947B3916CF7UL,
	0x0801F2E2858EFC16UL, 0x636920D871574E69UL
};

static const __constant ulong blake_cb_init[16] =
{
	0x243F6A8885A308D3UL, 0x13198A2E03707344UL,
	0xA4093822299F31D0UL, 0x082EFA98EC4E6C89UL,
	0x452821E638D01177UL, 0xBE5466CF34E90E6CUL,
	0xC0AC29B7C97C50DDUL, 0x3F84D5B5B5470917UL,
	0x9216D5D98979FB1BUL, 0xD1310BA698DFB5ACUL,
	0x2FFD72DBD01ADFB7UL, 0xB8E1AFED6A267E96UL,
	0xBA7C9045F12C7F99UL, 0x24A19947B3916CF7UL,
	0x0801F2E2858EFC16UL, 0x636920D871574E69UL
};

 

static const __constant ulong BLAKE_IV512[8] =
{
	0x6A09E667F3BCC908UL, 0xBB67AE8584CAA73BUL,
	0x3C6EF372FE94F82BUL, 0xA54FF53A5F1D36F1UL,
	0x510E527FADE682D1UL, 0x9B05688C2B3E6C1FUL,
	0x1F83D9ABFB41BD6BUL, 0x5BE0CD19137E2179UL
};

#endif
