/*
 * Myriadcoin Groestl kernel implementation (Groestl-512 + SHA-256)
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2007-2010 Thomas Pornin <thomas.pornin@cryptolog.com>
 * Copyright (c) 2014  phm <phm@inbox.com>
 * Copyright (c) 2014-2015 John Doering <ghostlander@phoenixcoin.org>
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
 */

#ifndef MYRIADCOIN_GROESTL_CL
#define MYRIADCOIN_GROESTL_CL

#if __ENDIAN_LITTLE__
#define SPH_LITTLE_ENDIAN 1
#else
#define SPH_BIG_ENDIAN 1
#endif

#define C32(a)         ((uint)(a ## U))
#define T32(a)         (as_uint(a))
#define ROTL32(a, b)   rotate(as_uint(a), as_uint(b))
#define ROTR32(a, b)   ROTL32(a, (32 - (b)))

#define C64(a)         ((ulong)(a ## UL))
#define T64(a)         (as_ulong(a))

#undef USE_LE
#if SPH_GROESTL_LITTLE_ENDIAN
#define USE_LE   1
#elif SPH_GROESTL_BIG_ENDIAN
#define USE_LE   0
#elif SPH_LITTLE_ENDIAN
#define USE_LE   1
#endif

#if USE_LE

#define C64e(x)     ((C64(x) >> 56) \
                    | ((C64(x) >> 40) & C64(0x000000000000FF00)) \
                    | ((C64(x) >> 24) & C64(0x0000000000FF0000)) \
                    | ((C64(x) >>  8) & C64(0x00000000FF000000)) \
                    | ((C64(x) <<  8) & C64(0x000000FF00000000)) \
                    | ((C64(x) << 24) & C64(0x0000FF0000000000)) \
                    | ((C64(x) << 40) & C64(0x00FF000000000000)) \
                    | ((C64(x) << 56) & C64(0xFF00000000000000)))
#define B64_0(x)    ((x) & 0xFF)
#define B64_1(x)    (((x) >> 8) & 0xFF)
#define B64_2(x)    (((x) >> 16) & 0xFF)
#define B64_3(x)    (((x) >> 24) & 0xFF)
#define B64_4(x)    (((x) >> 32) & 0xFF)
#define B64_5(x)    (((x) >> 40) & 0xFF)
#define B64_6(x)    (((x) >> 48) & 0xFF)
#define B64_7(x)    ((x) >> 56)
#define PC64(j, r)  ((ulong)((j) + (r)))
#define QC64(j, r)  (((ulong)(r) << 56) ^ T64(~((ulong)(j) << 56)))
#define H15         (((ulong)(512 & 0xFF) << 56) | ((ulong)(512 & 0xFF00) << 40))

#else

#define C64e(x)     C64(x)
#define B64_0(x)    ((x) >> 56)
#define B64_1(x)    (((x) >> 48) & 0xFF)
#define B64_2(x)    (((x) >> 40) & 0xFF)
#define B64_3(x)    (((x) >> 32) & 0xFF)
#define B64_4(x)    (((x) >> 24) & 0xFF)
#define B64_5(x)    (((x) >> 16) & 0xFF)
#define B64_6(x)    (((x) >> 8) & 0xFF)
#define B64_7(x)    ((x) & 0xFF)
#define PC64(j, r)  ((ulong)((j) + (r)) << 56)
#define QC64(j, r)  ((ulong)(r) ^ T64(~(ulong)(j)))
#define H15         (ulong)512

#endif

#define M15         0x100000000000000

__constant ulong T0[] = {
    C64e(0xc632f4a5f497a5c6), C64e(0xf86f978497eb84f8),
    C64e(0xee5eb099b0c799ee), C64e(0xf67a8c8d8cf78df6),
    C64e(0xffe8170d17e50dff), C64e(0xd60adcbddcb7bdd6),
    C64e(0xde16c8b1c8a7b1de), C64e(0x916dfc54fc395491),
    C64e(0x6090f050f0c05060), C64e(0x0207050305040302),
    C64e(0xce2ee0a9e087a9ce), C64e(0x56d1877d87ac7d56),
    C64e(0xe7cc2b192bd519e7), C64e(0xb513a662a67162b5),
    C64e(0x4d7c31e6319ae64d), C64e(0xec59b59ab5c39aec),
    C64e(0x8f40cf45cf05458f), C64e(0x1fa3bc9dbc3e9d1f),
    C64e(0x8949c040c0094089), C64e(0xfa68928792ef87fa),
    C64e(0xefd03f153fc515ef), C64e(0xb29426eb267febb2),
    C64e(0x8ece40c94007c98e), C64e(0xfbe61d0b1ded0bfb),
    C64e(0x416e2fec2f82ec41), C64e(0xb31aa967a97d67b3),
    C64e(0x5f431cfd1cbefd5f), C64e(0x456025ea258aea45),
    C64e(0x23f9dabfda46bf23), C64e(0x535102f702a6f753),
    C64e(0xe445a196a1d396e4), C64e(0x9b76ed5bed2d5b9b),
    C64e(0x75285dc25deac275), C64e(0xe1c5241c24d91ce1),
    C64e(0x3dd4e9aee97aae3d), C64e(0x4cf2be6abe986a4c),
    C64e(0x6c82ee5aeed85a6c), C64e(0x7ebdc341c3fc417e),
    C64e(0xf5f3060206f102f5), C64e(0x8352d14fd11d4f83),
    C64e(0x688ce45ce4d05c68), C64e(0x515607f407a2f451),
    C64e(0xd18d5c345cb934d1), C64e(0xf9e1180818e908f9),
    C64e(0xe24cae93aedf93e2), C64e(0xab3e9573954d73ab),
    C64e(0x6297f553f5c45362), C64e(0x2a6b413f41543f2a),
    C64e(0x081c140c14100c08), C64e(0x9563f652f6315295),
    C64e(0x46e9af65af8c6546), C64e(0x9d7fe25ee2215e9d),
    C64e(0x3048782878602830), C64e(0x37cff8a1f86ea137),
    C64e(0x0a1b110f11140f0a), C64e(0x2febc4b5c45eb52f),
    C64e(0x0e151b091b1c090e), C64e(0x247e5a365a483624),
    C64e(0x1badb69bb6369b1b), C64e(0xdf98473d47a53ddf),
    C64e(0xcda76a266a8126cd), C64e(0x4ef5bb69bb9c694e),
    C64e(0x7f334ccd4cfecd7f), C64e(0xea50ba9fbacf9fea),
    C64e(0x123f2d1b2d241b12), C64e(0x1da4b99eb93a9e1d),
    C64e(0x58c49c749cb07458), C64e(0x3446722e72682e34),
    C64e(0x3641772d776c2d36), C64e(0xdc11cdb2cda3b2dc),
    C64e(0xb49d29ee2973eeb4), C64e(0x5b4d16fb16b6fb5b),
    C64e(0xa4a501f60153f6a4), C64e(0x76a1d74dd7ec4d76),
    C64e(0xb714a361a37561b7), C64e(0x7d3449ce49face7d),
    C64e(0x52df8d7b8da47b52), C64e(0xdd9f423e42a13edd),
    C64e(0x5ecd937193bc715e), C64e(0x13b1a297a2269713),
    C64e(0xa6a204f50457f5a6), C64e(0xb901b868b86968b9),
    C64e(0x0000000000000000), C64e(0xc1b5742c74992cc1),
    C64e(0x40e0a060a0806040), C64e(0xe3c2211f21dd1fe3),
    C64e(0x793a43c843f2c879), C64e(0xb69a2ced2c77edb6),
    C64e(0xd40dd9bed9b3bed4), C64e(0x8d47ca46ca01468d),
    C64e(0x671770d970ced967), C64e(0x72afdd4bdde44b72),
    C64e(0x94ed79de7933de94), C64e(0x98ff67d4672bd498),
    C64e(0xb09323e8237be8b0), C64e(0x855bde4ade114a85),
    C64e(0xbb06bd6bbd6d6bbb), C64e(0xc5bb7e2a7e912ac5),
    C64e(0x4f7b34e5349ee54f), C64e(0xedd73a163ac116ed),
    C64e(0x86d254c55417c586), C64e(0x9af862d7622fd79a),
    C64e(0x6699ff55ffcc5566), C64e(0x11b6a794a7229411),
    C64e(0x8ac04acf4a0fcf8a), C64e(0xe9d9301030c910e9),
    C64e(0x040e0a060a080604), C64e(0xfe66988198e781fe),
    C64e(0xa0ab0bf00b5bf0a0), C64e(0x78b4cc44ccf04478),
    C64e(0x25f0d5bad54aba25), C64e(0x4b753ee33e96e34b),
    C64e(0xa2ac0ef30e5ff3a2), C64e(0x5d4419fe19bafe5d),
    C64e(0x80db5bc05b1bc080), C64e(0x0580858a850a8a05),
    C64e(0x3fd3ecadec7ead3f), C64e(0x21fedfbcdf42bc21),
    C64e(0x70a8d848d8e04870), C64e(0xf1fd0c040cf904f1),
    C64e(0x63197adf7ac6df63), C64e(0x772f58c158eec177),
    C64e(0xaf309f759f4575af), C64e(0x42e7a563a5846342),
    C64e(0x2070503050403020), C64e(0xe5cb2e1a2ed11ae5),
    C64e(0xfdef120e12e10efd), C64e(0xbf08b76db7656dbf),
    C64e(0x8155d44cd4194c81), C64e(0x18243c143c301418),
    C64e(0x26795f355f4c3526), C64e(0xc3b2712f719d2fc3),
    C64e(0xbe8638e13867e1be), C64e(0x35c8fda2fd6aa235),
    C64e(0x88c74fcc4f0bcc88), C64e(0x2e654b394b5c392e),
    C64e(0x936af957f93d5793), C64e(0x55580df20daaf255),
    C64e(0xfc619d829de382fc), C64e(0x7ab3c947c9f4477a),
    C64e(0xc827efacef8bacc8), C64e(0xba8832e7326fe7ba),
    C64e(0x324f7d2b7d642b32), C64e(0xe642a495a4d795e6),
    C64e(0xc03bfba0fb9ba0c0), C64e(0x19aab398b3329819),
    C64e(0x9ef668d16827d19e), C64e(0xa322817f815d7fa3),
    C64e(0x44eeaa66aa886644), C64e(0x54d6827e82a87e54),
    C64e(0x3bdde6abe676ab3b), C64e(0x0b959e839e16830b),
    C64e(0x8cc945ca4503ca8c), C64e(0xc7bc7b297b9529c7),
    C64e(0x6b056ed36ed6d36b), C64e(0x286c443c44503c28),
    C64e(0xa72c8b798b5579a7), C64e(0xbc813de23d63e2bc),
    C64e(0x1631271d272c1d16), C64e(0xad379a769a4176ad),
    C64e(0xdb964d3b4dad3bdb), C64e(0x649efa56fac85664),
    C64e(0x74a6d24ed2e84e74), C64e(0x1436221e22281e14),
    C64e(0x92e476db763fdb92), C64e(0x0c121e0a1e180a0c),
    C64e(0x48fcb46cb4906c48), C64e(0xb88f37e4376be4b8),
    C64e(0x9f78e75de7255d9f), C64e(0xbd0fb26eb2616ebd),
    C64e(0x43692aef2a86ef43), C64e(0xc435f1a6f193a6c4),
    C64e(0x39dae3a8e372a839), C64e(0x31c6f7a4f762a431),
    C64e(0xd38a593759bd37d3), C64e(0xf274868b86ff8bf2),
    C64e(0xd583563256b132d5), C64e(0x8b4ec543c50d438b),
    C64e(0x6e85eb59ebdc596e), C64e(0xda18c2b7c2afb7da),
    C64e(0x018e8f8c8f028c01), C64e(0xb11dac64ac7964b1),
    C64e(0x9cf16dd26d23d29c), C64e(0x49723be03b92e049),
    C64e(0xd81fc7b4c7abb4d8), C64e(0xacb915fa1543faac),
    C64e(0xf3fa090709fd07f3), C64e(0xcfa06f256f8525cf),
    C64e(0xca20eaafea8fafca), C64e(0xf47d898e89f38ef4),
    C64e(0x476720e9208ee947), C64e(0x1038281828201810),
    C64e(0x6f0b64d564ded56f), C64e(0xf073838883fb88f0),
    C64e(0x4afbb16fb1946f4a), C64e(0x5cca967296b8725c),
    C64e(0x38546c246c702438), C64e(0x575f08f108aef157),
    C64e(0x732152c752e6c773), C64e(0x9764f351f3355197),
    C64e(0xcbae6523658d23cb), C64e(0xa125847c84597ca1),
    C64e(0xe857bf9cbfcb9ce8), C64e(0x3e5d6321637c213e),
    C64e(0x96ea7cdd7c37dd96), C64e(0x611e7fdc7fc2dc61),
    C64e(0x0d9c9186911a860d), C64e(0x0f9b9485941e850f),
    C64e(0xe04bab90abdb90e0), C64e(0x7cbac642c6f8427c),
    C64e(0x712657c457e2c471), C64e(0xcc29e5aae583aacc),
    C64e(0x90e373d8733bd890), C64e(0x06090f050f0c0506),
    C64e(0xf7f4030103f501f7), C64e(0x1c2a36123638121c),
    C64e(0xc23cfea3fe9fa3c2), C64e(0x6a8be15fe1d45f6a),
    C64e(0xaebe10f91047f9ae), C64e(0x69026bd06bd2d069),
    C64e(0x17bfa891a82e9117), C64e(0x9971e858e8295899),
    C64e(0x3a5369276974273a), C64e(0x27f7d0b9d04eb927),
    C64e(0xd991483848a938d9), C64e(0xebde351335cd13eb),
    C64e(0x2be5ceb3ce56b32b), C64e(0x2277553355443322),
    C64e(0xd204d6bbd6bfbbd2), C64e(0xa9399070904970a9),
    C64e(0x07878089800e8907), C64e(0x33c1f2a7f266a733),
    C64e(0x2decc1b6c15ab62d), C64e(0x3c5a66226678223c),
    C64e(0x15b8ad92ad2a9215), C64e(0xc9a96020608920c9),
    C64e(0x875cdb49db154987), C64e(0xaab01aff1a4fffaa),
    C64e(0x50d8887888a07850), C64e(0xa52b8e7a8e517aa5),
    C64e(0x03898a8f8a068f03), C64e(0x594a13f813b2f859),
    C64e(0x09929b809b128009), C64e(0x1a2339173934171a),
    C64e(0x651075da75cada65), C64e(0xd784533153b531d7),
    C64e(0x84d551c65113c684), C64e(0xd003d3b8d3bbb8d0),
    C64e(0x82dc5ec35e1fc382), C64e(0x29e2cbb0cb52b029),
    C64e(0x5ac3997799b4775a), C64e(0x1e2d3311333c111e),
    C64e(0x7b3d46cb46f6cb7b), C64e(0xa8b71ffc1f4bfca8),
    C64e(0x6d0c61d661dad66d), C64e(0x2c624e3a4e583a2c)
};

#define RBTT(d, a, b0, b1, b2, b3, b4, b5, b6, b7) do { \
    t[d] = T0[B64_0(a[b0])]  \
         ^ T1[B64_1(a[b1])]  \
         ^ T2[B64_2(a[b2])]  \
         ^ T3[B64_3(a[b3])]  \
         ^ T4[B64_4(a[b4])]  \
         ^ T5[B64_5(a[b5])]  \
         ^ T6[B64_6(a[b6])]  \
         ^ T7[B64_7(a[b7])]; \
} while (0)

#define ROUND_BIG_P(a, r) do { \
	a[0] ^= PC64(0x00, r); \
	a[1] ^= PC64(0x10, r); \
	a[2] ^= PC64(0x20, r); \
	a[3] ^= PC64(0x30, r); \
	a[4] ^= PC64(0x40, r); \
	a[5] ^= PC64(0x50, r); \
	a[6] ^= PC64(0x60, r); \
	a[7] ^= PC64(0x70, r); \
	a[8] ^= PC64(0x80, r); \
	a[9] ^= PC64(0x90, r); \
	a[10] ^= PC64(0xA0, r); \
	a[11] ^= PC64(0xB0, r); \
	a[12] ^= PC64(0xC0, r); \
	a[13] ^= PC64(0xD0, r); \
	a[14] ^= PC64(0xE0, r); \
	a[15] ^= PC64(0xF0, r); \
	RBTT( 0, a, 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0xB); \
	RBTT( 1, a, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0xC); \
	RBTT( 2, a, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0xD); \
	RBTT( 3, a, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xE); \
	RBTT( 4, a, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xF); \
	RBTT( 5, a, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0x0); \
	RBTT( 6, a, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0x1); \
	RBTT( 7, a, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0x2); \
	RBTT( 8, a, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0x3); \
	RBTT( 9, a, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x4); \
	RBTT(10, a, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x0, 0x5); \
	RBTT(11, a, 0xB, 0xC, 0xD, 0xE, 0xF, 0x0, 0x1, 0x6); \
	RBTT(12, a, 0xC, 0xD, 0xE, 0xF, 0x0, 0x1, 0x2, 0x7); \
	RBTT(13, a, 0xD, 0xE, 0xF, 0x0, 0x1, 0x2, 0x3, 0x8); \
	RBTT(14, a, 0xE, 0xF, 0x0, 0x1, 0x2, 0x3, 0x4, 0x9); \
	RBTT(15, a, 0xF, 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0xA); \
	a[0] = t[0]; \
	a[1] = t[1]; \
	a[2] = t[2]; \
	a[3] = t[3]; \
	a[4] = t[4]; \
	a[5] = t[5]; \
	a[6] = t[6]; \
	a[7] = t[7]; \
	a[8] = t[8]; \
	a[9] = t[9]; \
	a[10] = t[10]; \
	a[11] = t[11]; \
	a[12] = t[12]; \
	a[13] = t[13]; \
	a[14] = t[14]; \
	a[15] = t[15]; \
    } while (0)

#define ROUND_BIG_Q(a, r) do { \
	a[0] ^= QC64(0x00, r); \
	a[1] ^= QC64(0x10, r); \
	a[2] ^= QC64(0x20, r); \
	a[3] ^= QC64(0x30, r); \
	a[4] ^= QC64(0x40, r); \
	a[5] ^= QC64(0x50, r); \
	a[6] ^= QC64(0x60, r); \
	a[7] ^= QC64(0x70, r); \
	a[8] ^= QC64(0x80, r); \
	a[9] ^= QC64(0x90, r); \
	a[10] ^= QC64(0xA0, r); \
	a[11] ^= QC64(0xB0, r); \
	a[12] ^= QC64(0xC0, r); \
	a[13] ^= QC64(0xD0, r); \
	a[14] ^= QC64(0xE0, r); \
	a[15] ^= QC64(0xF0, r); \
	RBTT(0x0, a, 0x1, 0x3, 0x5, 0xB, 0x0, 0x2, 0x4, 0x6); \
	RBTT(0x1, a, 0x2, 0x4, 0x6, 0xC, 0x1, 0x3, 0x5, 0x7); \
	RBTT(0x2, a, 0x3, 0x5, 0x7, 0xD, 0x2, 0x4, 0x6, 0x8); \
	RBTT(0x3, a, 0x4, 0x6, 0x8, 0xE, 0x3, 0x5, 0x7, 0x9); \
	RBTT(0x4, a, 0x5, 0x7, 0x9, 0xF, 0x4, 0x6, 0x8, 0xA); \
	RBTT(0x5, a, 0x6, 0x8, 0xA, 0x0, 0x5, 0x7, 0x9, 0xB); \
	RBTT(0x6, a, 0x7, 0x9, 0xB, 0x1, 0x6, 0x8, 0xA, 0xC); \
	RBTT(0x7, a, 0x8, 0xA, 0xC, 0x2, 0x7, 0x9, 0xB, 0xD); \
	RBTT(0x8, a, 0x9, 0xB, 0xD, 0x3, 0x8, 0xA, 0xC, 0xE); \
	RBTT(0x9, a, 0xA, 0xC, 0xE, 0x4, 0x9, 0xB, 0xD, 0xF); \
	RBTT(0xA, a, 0xB, 0xD, 0xF, 0x5, 0xA, 0xC, 0xE, 0x0); \
	RBTT(0xB, a, 0xC, 0xE, 0x0, 0x6, 0xB, 0xD, 0xF, 0x1); \
	RBTT(0xC, a, 0xD, 0xF, 0x1, 0x7, 0xC, 0xE, 0x0, 0x2); \
	RBTT(0xD, a, 0xE, 0x0, 0x2, 0x8, 0xD, 0xF, 0x1, 0x3); \
	RBTT(0xE, a, 0xF, 0x1, 0x3, 0x9, 0xE, 0x0, 0x2, 0x4); \
	RBTT(0xF, a, 0x0, 0x2, 0x4, 0xA, 0xF, 0x1, 0x3, 0x5); \
	a[0] = t[0]; \
	a[1] = t[1]; \
	a[2] = t[2]; \
	a[3] = t[3]; \
	a[4] = t[4]; \
	a[5] = t[5]; \
	a[6] = t[6]; \
	a[7] = t[7]; \
	a[8] = t[8]; \
	a[9] = t[9]; \
	a[10] = t[10]; \
	a[11] = t[11]; \
	a[12] = t[12]; \
	a[13] = t[13]; \
	a[14] = t[14]; \
	a[15] = t[15]; \
} while (0)

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)

#if SPH_BIG_ENDIAN
  #define ENC64E(x) SWAP8(x)
  #define DEC64E(x) SWAP8(*(const __global ulong *) (x));
#else
  #define ENC64E(x) (x)
  #define DEC64E(x) (*(const __global ulong *) (x));
#endif

#define SHR(x, n)    ((x) >> n)
#define SWAP32(a)    (as_uint(as_uchar4(a).wzyx))

#define S0(x) (ROTL32(x, 25) ^ ROTL32(x, 14) ^  SHR(x, 3))
#define S1(x) (ROTL32(x, 15) ^ ROTL32(x, 13) ^  SHR(x, 10))

#define S2(x) (ROTL32(x, 30) ^ ROTL32(x, 19) ^ ROTL32(x, 10))
#define S3(x) (ROTL32(x, 26) ^ ROTL32(x, 21) ^ ROTL32(x, 7))

#define P(a, b, c, d, e, f, g, h, x, K) {     \
  temp = h + S3(e) + F1(e, f, g) + (K + x);   \
  d += temp; h = temp + S2(a) + F0(a, b, c);  \
}

#define PLAST(a, b, c, d, e, f, g, h, x, K) { \
  d += h + S3(e) + F1(e, f, g) + (x + K);     \
}

#define F0(y, x, z) bitselect(z, y, z ^ x)
#define F1(x, y, z) bitselect(z, y, x)

#define R0 (W0 = S1(W14) + W9 + S0(W1) + W0)
#define R1 (W1 = S1(W15) + W10 + S0(W2) + W1)
#define R2 (W2 = S1(W0) + W11 + S0(W3) + W2)
#define R3 (W3 = S1(W1) + W12 + S0(W4) + W3)
#define R4 (W4 = S1(W2) + W13 + S0(W5) + W4)
#define R5 (W5 = S1(W3) + W14 + S0(W6) + W5)
#define R6 (W6 = S1(W4) + W15 + S0(W7) + W6)
#define R7 (W7 = S1(W5) + W0 + S0(W8) + W7)
#define R8 (W8 = S1(W6) + W1 + S0(W9) + W8)
#define R9 (W9 = S1(W7) + W2 + S0(W10) + W9)
#define R10 (W10 = S1(W8) + W3 + S0(W11) + W10)
#define R11 (W11 = S1(W9) + W4 + S0(W12) + W11)
#define R12 (W12 = S1(W10) + W5 + S0(W13) + W12)
#define R13 (W13 = S1(W11) + W6 + S0(W14) + W13)
#define R14 (W14 = S1(W12) + W7 + S0(W15) + W14)
#define R15 (W15 = S1(W13) + W8 + S0(W0) + W15)

#define RD14 (S1(W12) + W7 + S0(W15) + W14)
#define RD15 (S1(W13) + W8 + S0(W0) + W15)


__kernel __attribute__((vec_type_hint(uint4)))
__kernel __attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global unsigned char* block, volatile __global uint* output,
  const ulong target) {
    uint glbid = get_global_id(0);
    uint lclid = get_local_id(0);
    ulong r;
    uint i;

    /* Groestl-512 */

    __private ulong16 GMT[3];
    ulong *g = (ulong *) &GMT[0];
    ulong *m = (ulong *) &GMT[1];
    ulong *t = (ulong *) &GMT[2];

    __local ulong T0_L[256], T1_L[256], T2_L[256], T3_L[256],
      T4_L[256], T5_L[256], T6_L[256], T7_L[256];

    /* Compute the tables */

#if (WORKSIZE == 64)
    T0_L[lclid] = T0[lclid];
    T0_L[lclid + 64] = T0[lclid + 64];
    T0_L[lclid + 128] = T0[lclid + 128];
    T0_L[lclid + 192] = T0[lclid + 192];
    T1_L[lclid] = rotate(T0[lclid], 8UL);
    T1_L[lclid + 64] = rotate(T0[lclid + 64], 8UL);
    T1_L[lclid + 128] = rotate(T0[lclid + 128], 8UL);
    T1_L[lclid + 192] = rotate(T0[lclid + 192], 8UL);
    T2_L[lclid] = rotate(T0[lclid], 16UL);
    T2_L[lclid + 64] = rotate(T0[lclid + 64], 16UL);
    T2_L[lclid + 128] = rotate(T0[lclid + 128], 16UL);
    T2_L[lclid + 192] = rotate(T0[lclid + 192], 16UL);
    T3_L[lclid] = rotate(T0[lclid], 24UL);
    T3_L[lclid + 64] = rotate(T0[lclid + 64], 24UL);
    T3_L[lclid + 128] = rotate(T0[lclid + 128], 24UL);
    T3_L[lclid + 192] = rotate(T0[lclid + 192], 24UL);
    T4_L[lclid] = rotate(T0[lclid], 32UL);
    T4_L[lclid + 64] = rotate(T0[lclid + 64], 32UL);
    T4_L[lclid + 128] = rotate(T0[lclid + 128], 32UL);
    T4_L[lclid + 192] = rotate(T0[lclid + 192], 32UL);
    T5_L[lclid] = rotate(T0[lclid], 40UL);
    T5_L[lclid + 64] = rotate(T0[lclid + 64], 40UL);
    T5_L[lclid + 128] = rotate(T0[lclid + 128], 40UL);
    T5_L[lclid + 192] = rotate(T0[lclid + 192], 40UL);
    T6_L[lclid] = rotate(T0[lclid], 48UL);
    T6_L[lclid + 64] = rotate(T0[lclid + 64], 48UL);
    T6_L[lclid + 128] = rotate(T0[lclid + 128], 48UL);
    T6_L[lclid + 192] = rotate(T0[lclid + 192], 48UL);
    T7_L[lclid] = rotate(T0[lclid], 56UL);
    T7_L[lclid + 64] = rotate(T0[lclid + 64], 56UL);
    T7_L[lclid + 128] = rotate(T0[lclid + 128], 56UL);
    T7_L[lclid + 192] = rotate(T0[lclid + 192], 56UL);
#elif (WORKSIZE == 128)
    T0_L[lclid] = T0[lclid];
    T0_L[lclid + 128] = T0[lclid + 128];
    T1_L[lclid] = rotate(T0[lclid], 8UL);
    T1_L[lclid + 128] = rotate(T0[lclid + 128], 8UL);
    T2_L[lclid] = rotate(T0[lclid], 16UL);
    T2_L[lclid + 128] = rotate(T0[lclid + 128], 16UL);
    T3_L[lclid] = rotate(T0[lclid], 24UL);
    T3_L[lclid + 128] = rotate(T0[lclid + 128], 24UL);
    T4_L[lclid] = rotate(T0[lclid], 32UL);
    T4_L[lclid + 128] = rotate(T0[lclid + 128], 32UL);
    T5_L[lclid] = rotate(T0[lclid], 40UL);
    T5_L[lclid + 128] = rotate(T0[lclid + 128], 40UL);
    T6_L[lclid] = rotate(T0[lclid], 48UL);
    T6_L[lclid + 128] = rotate(T0[lclid + 128], 48UL);
    T7_L[lclid] = rotate(T0[lclid], 56UL);
    T7_L[lclid + 128] = rotate(T0[lclid + 128], 56UL);
#elif (WORKSIZE == 256)
    T0_L[lclid] = T0[lclid];
    T1_L[lclid] = rotate(T0[lclid], 8UL);
    T2_L[lclid] = rotate(T0[lclid], 16UL);
    T3_L[lclid] = rotate(T0[lclid], 24UL);
    T4_L[lclid] = rotate(T0[lclid], 32UL);
    T5_L[lclid] = rotate(T0[lclid], 40UL);
    T6_L[lclid] = rotate(T0[lclid], 48UL);
    T7_L[lclid] = rotate(T0[lclid], 56UL);
#else
    return;
#endif

#define T0 T0_L
#define T1 T1_L
#define T2 T2_L
#define T3 T3_L
#define T4 T4_L
#define T5 T5_L
#define T6 T6_L
#define T7 T7_L

    m[0] = DEC64E(block);
    m[1] = DEC64E(block + 8);
    m[2] = DEC64E(block + 16);
    m[3] = DEC64E(block + 24);
    m[4] = DEC64E(block + 32);
    m[5] = DEC64E(block + 40);
    m[6] = DEC64E(block + 48);
    m[7] = DEC64E(block + 56);
    m[8] = DEC64E(block + 64);
    m[9] = DEC64E(block + 72);
    m[9] &= 0x00000000FFFFFFFF;
    m[9] |= ((ulong) glbid << 32);
    m[10] = 0x80;
    m[11] = 0;
    m[12] = 0;
    m[13] = 0;
    m[14] = 0;
    m[15] = M15;

    g[0] = m[0];
    g[1] = m[1];
    g[2] = m[2];
    g[3] = m[3];
    g[4] = m[4];
    g[5] = m[5];
    g[6] = m[6];
    g[7] = m[7];
    g[8] = m[8];
    g[9] = m[9];
    g[10] = m[10];
    g[11] = m[11];
    g[12] = m[12];
    g[13] = m[13];
    g[14] = m[14];
    g[15] = M15 ^ H15;

    /* PERM_BIG_Q(m); */
    for(r = 0; r < 14; r++)
      ROUND_BIG_Q(m, r);

    /* PERM_BIG_P(g); */
    for(r = 0; r < 14; r++)
      ROUND_BIG_P(g, r);

    g[0] ^= m[0];
    g[1] ^= m[1];
    g[2] ^= m[2];
    g[3] ^= m[3];
    g[4] ^= m[4];
    g[5] ^= m[5];
    g[6] ^= m[6];
    g[7] ^= m[7];
    g[8] ^= m[8];
    g[9] ^= m[9];
    g[10] ^= m[10];
    g[11] ^= m[11];
    g[12] ^= m[12];
    g[13] ^= m[13];
    g[14] ^= m[14];
    g[15] ^= m[15] ^ H15;

    m[0] = g[0];
    m[1] = g[1];
    m[2] = g[2];
    m[3] = g[3];
    m[4] = g[4];
    m[5] = g[5];
    m[6] = g[6];
    m[7] = g[7];
    m[8] = g[8];
    m[9] = g[9];
    m[10] = g[10];
    m[11] = g[11];
    m[12] = g[12];
    m[13] = g[13];
    m[14] = g[14];
    m[15] = g[15];

    /* PERM_BIG_P(g); */
    for(r = 0; r < 14; r++)
      ROUND_BIG_P(g, r);

    m[8] = m[8]   ^ g[8];
    m[9] = m[9]   ^ g[9];
    m[10] = m[10] ^ g[10];
    m[11] = m[11] ^ g[11];
    m[12] = m[12] ^ g[12];
    m[13] = m[13] ^ g[13];
    m[14] = m[14] ^ g[14];
    m[15] = m[15] ^ g[15];

    /* SHA-256 */

    __private uint16 hash[1];
    uint  *hash_uint  = (uint *)  hash;
    ulong *hash_ulong = (ulong *) hash;
    uint temp;

    hash_ulong[0] = ENC64E(m[8]);
    hash_ulong[1] = ENC64E(m[9]);
    hash_ulong[2] = ENC64E(m[10]);
    hash_ulong[3] = ENC64E(m[11]);
    hash_ulong[4] = ENC64E(m[12]);
    hash_ulong[5] = ENC64E(m[13]);
    hash_ulong[6] = ENC64E(m[14]);
    hash_ulong[7] = ENC64E(m[15]);

    uint W0 = SWAP32(hash_uint[0]);
    uint W1 = SWAP32(hash_uint[1]);
    uint W2 = SWAP32(hash_uint[2]);
    uint W3 = SWAP32(hash_uint[3]);
    uint W4 = SWAP32(hash_uint[4]);
    uint W5 = SWAP32(hash_uint[5]);
    uint W6 = SWAP32(hash_uint[6]);
    uint W7 = SWAP32(hash_uint[7]);
    uint W8 = SWAP32(hash_uint[8]);
    uint W9 = SWAP32(hash_uint[9]);
    uint W10 = SWAP32(hash_uint[10]);
    uint W11 = SWAP32(hash_uint[11]);
    uint W12 = SWAP32(hash_uint[12]);
    uint W13 = SWAP32(hash_uint[13]);
    uint W14 = SWAP32(hash_uint[14]);
    uint W15 = SWAP32(hash_uint[15]);

    uint v0 = 0x6A09E667;
    uint v1 = 0xBB67AE85;
    uint v2 = 0x3C6EF372;
    uint v3 = 0xA54FF53A;
    uint v4 = 0x510E527F;
    uint v5 = 0x9B05688C;
    uint v6 = 0x1F83D9AB;
    uint v7 = 0x5BE0CD19;

    P(v0, v1, v2, v3, v4, v5, v6, v7, W0,  0x428A2F98);
    P(v7, v0, v1, v2, v3, v4, v5, v6, W1,  0x71374491);
    P(v6, v7, v0, v1, v2, v3, v4, v5, W2,  0xB5C0FBCF);
    P(v5, v6, v7, v0, v1, v2, v3, v4, W3,  0xE9B5DBA5);
    P(v4, v5, v6, v7, v0, v1, v2, v3, W4,  0x3956C25B);
    P(v3, v4, v5, v6, v7, v0, v1, v2, W5,  0x59F111F1);
    P(v2, v3, v4, v5, v6, v7, v0, v1, W6,  0x923F82A4);
    P(v1, v2, v3, v4, v5, v6, v7, v0, W7,  0xAB1C5ED5);
    P(v0, v1, v2, v3, v4, v5, v6, v7, W8,  0xD807AA98);
    P(v7, v0, v1, v2, v3, v4, v5, v6, W9,  0x12835B01);
    P(v6, v7, v0, v1, v2, v3, v4, v5, W10, 0x243185BE);
    P(v5, v6, v7, v0, v1, v2, v3, v4, W11, 0x550C7DC3);
    P(v4, v5, v6, v7, v0, v1, v2, v3, W12, 0x72BE5D74);
    P(v3, v4, v5, v6, v7, v0, v1, v2, W13, 0x80DEB1FE);
    P(v2, v3, v4, v5, v6, v7, v0, v1, W14, 0x9BDC06A7);
    P(v1, v2, v3, v4, v5, v6, v7, v0, W15, 0xC19BF174);

    P(v0, v1, v2, v3, v4, v5, v6, v7, R0,  0xE49B69C1);
    P(v7, v0, v1, v2, v3, v4, v5, v6, R1,  0xEFBE4786);
    P(v6, v7, v0, v1, v2, v3, v4, v5, R2,  0x0FC19DC6);
    P(v5, v6, v7, v0, v1, v2, v3, v4, R3,  0x240CA1CC);
    P(v4, v5, v6, v7, v0, v1, v2, v3, R4,  0x2DE92C6F);
    P(v3, v4, v5, v6, v7, v0, v1, v2, R5,  0x4A7484AA);
    P(v2, v3, v4, v5, v6, v7, v0, v1, R6,  0x5CB0A9DC);
    P(v1, v2, v3, v4, v5, v6, v7, v0, R7,  0x76F988DA);
    P(v0, v1, v2, v3, v4, v5, v6, v7, R8,  0x983E5152);
    P(v7, v0, v1, v2, v3, v4, v5, v6, R9,  0xA831C66D);
    P(v6, v7, v0, v1, v2, v3, v4, v5, R10, 0xB00327C8);
    P(v5, v6, v7, v0, v1, v2, v3, v4, R11, 0xBF597FC7);
    P(v4, v5, v6, v7, v0, v1, v2, v3, R12, 0xC6E00BF3);
    P(v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xD5A79147);
    P(v2, v3, v4, v5, v6, v7, v0, v1, R14, 0x06CA6351);
    P(v1, v2, v3, v4, v5, v6, v7, v0, R15, 0x14292967);

    P(v0, v1, v2, v3, v4, v5, v6, v7, R0,  0x27B70A85);
    P(v7, v0, v1, v2, v3, v4, v5, v6, R1,  0x2E1B2138);
    P(v6, v7, v0, v1, v2, v3, v4, v5, R2,  0x4D2C6DFC);
    P(v5, v6, v7, v0, v1, v2, v3, v4, R3,  0x53380D13);
    P(v4, v5, v6, v7, v0, v1, v2, v3, R4,  0x650A7354);
    P(v3, v4, v5, v6, v7, v0, v1, v2, R5,  0x766A0ABB);
    P(v2, v3, v4, v5, v6, v7, v0, v1, R6,  0x81C2C92E);
    P(v1, v2, v3, v4, v5, v6, v7, v0, R7,  0x92722C85);
    P(v0, v1, v2, v3, v4, v5, v6, v7, R8,  0xA2BFE8A1);
    P(v7, v0, v1, v2, v3, v4, v5, v6, R9,  0xA81A664B);
    P(v6, v7, v0, v1, v2, v3, v4, v5, R10, 0xC24B8B70);
    P(v5, v6, v7, v0, v1, v2, v3, v4, R11, 0xC76C51A3);
    P(v4, v5, v6, v7, v0, v1, v2, v3, R12, 0xD192E819);
    P(v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xD6990624);
    P(v2, v3, v4, v5, v6, v7, v0, v1, R14, 0xF40E3585);
    P(v1, v2, v3, v4, v5, v6, v7, v0, R15, 0x106AA070);

    P(v0, v1, v2, v3, v4, v5, v6, v7, R0,   0x19A4C116);
    P(v7, v0, v1, v2, v3, v4, v5, v6, R1,   0x1E376C08);
    P(v6, v7, v0, v1, v2, v3, v4, v5, R2,   0x2748774C);
    P(v5, v6, v7, v0, v1, v2, v3, v4, R3,   0x34B0BCB5);
    P(v4, v5, v6, v7, v0, v1, v2, v3, R4,   0x391C0CB3);
    P(v3, v4, v5, v6, v7, v0, v1, v2, R5,   0x4ED8AA4A);
    P(v2, v3, v4, v5, v6, v7, v0, v1, R6,   0x5B9CCA4F);
    P(v1, v2, v3, v4, v5, v6, v7, v0, R7,   0x682E6FF3);
    P(v0, v1, v2, v3, v4, v5, v6, v7, R8,   0x748F82EE);
    P(v7, v0, v1, v2, v3, v4, v5, v6, R9,   0x78A5636F);
    P(v6, v7, v0, v1, v2, v3, v4, v5, R10,  0x84C87814);
    P(v5, v6, v7, v0, v1, v2, v3, v4, R11,  0x8CC70208);
    P(v4, v5, v6, v7, v0, v1, v2, v3, R12,  0x90BEFFFA);
    P(v3, v4, v5, v6, v7, v0, v1, v2, R13,  0xA4506CEB);
    P(v2, v3, v4, v5, v6, v7, v0, v1, RD14, 0xBEF9A3F7);
    P(v1, v2, v3, v4, v5, v6, v7, v0, RD15, 0xC67178F2);

    v0 += 0x6A09E667;
    v1 += 0xBB67AE85;
    v2 += 0x3C6EF372;
    v3 += 0xA54FF53A;
    v4 += 0x510E527F;
    v5 += 0x9B05688C;
    v6 += 0x1F83D9AB;
    uint s6 = v6;
    v7 += 0x5BE0CD19;
    uint s7 = v7;

    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x80000000, 0x428A2F98);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0, 0x71374491);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0, 0xB5C0FBCF);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0, 0xE9B5DBA5);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0, 0x3956C25B);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0, 0x59F111F1);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0, 0x923F82A4);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 0, 0xAB1C5ED5);
    P(v0, v1, v2, v3, v4, v5, v6, v7, 0, 0xD807AA98);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0, 0x12835B01);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0, 0x243185BE);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0, 0x550C7DC3);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0, 0x72BE5D74);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0, 0x80DEB1FE);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0, 0x9BDC06A7);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 512, 0xC19BF174);

    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x80000000U, 0xE49B69C1U);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0x01400000U, 0xEFBE4786U);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0x00205000U, 0x0FC19DC6U);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0x00005088U, 0x240CA1CCU);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0x22000800U, 0x2DE92C6FU);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0x22550014U, 0x4A7484AAU);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0x05089742U, 0x5CB0A9DCU);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 0xa0000020U, 0x76F988DAU);
    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x5a880000U, 0x983E5152U);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0x005c9400U, 0xA831C66DU);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0x0016d49dU, 0xB00327C8U);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0xfa801f00U, 0xBF597FC7U);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0xd33225d0U, 0xC6E00BF3U);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0x11675959U, 0xD5A79147U);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0xf6e6bfdaU, 0x06CA6351U);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 0xb30c1549U, 0x14292967U);
    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x08b2b050U, 0x27B70A85U);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0x9d7c4c27U, 0x2E1B2138U);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0x0ce2a393U, 0x4D2C6DFCU);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0x88e6e1eaU, 0x53380D13U);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0xa52b4335U, 0x650A7354U);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0x67a16f49U, 0x766A0ABBU);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0xd732016fU, 0x81C2C92EU);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 0x4eeb2e91U, 0x92722C85U);
    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x5dbf55e5U, 0xA2BFE8A1U);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0x8eee2335U, 0xA81A664BU);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0xe2bc5ec2U, 0xC24B8B70U);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0xa83f4394U, 0xC76C51A3U);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0x45ad78f7U, 0xD192E819U);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0x36f3d0cdU, 0xD6990624U);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0xd99c05e8U, 0xF40E3585U);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 0xb0511dc7U, 0x106AA070U);
    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x69bc7ac4U, 0x19A4C116U);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0xbd11375bU, 0x1E376C08U);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0xe3ba71e5U, 0x2748774CU);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0x3b209ff2U, 0x34B0BCB5U);
    P(v4, v5, v6, v7, v0, v1, v2, v3, 0x18feee17U, 0x391C0CB3U);
    P(v3, v4, v5, v6, v7, v0, v1, v2, 0xe25ad9e7U, 0x4ED8AA4AU);
    P(v2, v3, v4, v5, v6, v7, v0, v1, 0x13375046U, 0x5B9CCA4FU);
    P(v1, v2, v3, v4, v5, v6, v7, v0, 0x0515089dU, 0x682E6FF3U);
    P(v0, v1, v2, v3, v4, v5, v6, v7, 0x4f0d0f04U, 0x748F82EEU);
    P(v7, v0, v1, v2, v3, v4, v5, v6, 0x2627484eU, 0x78A5636FU);
    P(v6, v7, v0, v1, v2, v3, v4, v5, 0x310128d2U, 0x84C87814U);
    P(v5, v6, v7, v0, v1, v2, v3, v4, 0xc668b434U, 0x8CC70208U);
    PLAST(v4, v5, v6, v7, v0, v1, v2, v3, 0x420841ccU, 0x90BEFFFAU);

    hash_uint[6] = SWAP4(v6 + s6);
    hash_uint[7] = SWAP4(v7 + s7);

    if(hash_ulong[3] <= target)
      output[output[0xFF]++] = SWAP4(glbid);
}

#endif /* MYRIADCOIN_GROESTL_CL */