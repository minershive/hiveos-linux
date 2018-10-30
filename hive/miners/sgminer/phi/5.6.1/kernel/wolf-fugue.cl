/* $Id: fugue.c 216 2010-06-08 09:46:57Z tp $ */
/*
 * Fugue implementation.
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

__constant const uint IV224[] = {
  0xf4c9120dU, 0x6286f757U, 0xee39e01cU,
  0xe074e3cbU, 0xa1127c62U, 0x9a43d215U,
  0xbd8d679aU
};

__constant const uint IV256[] = {
  0xe952bddeU, 0x6671135fU, 0xe0d4f668U,
  0xd2b0b594U, 0xf96c621dU, 0xfbf929deU,
  0x9149e899U, 0x34f8c248U
};

__constant const uint IV384[] = {
  0xaa61ec0dU, 0x31252e1fU, 0xa01db4c7U,
  0x00600985U, 0x215ef44aU, 0x741b5e9cU,
  0xfa693e9aU, 0x473eb040U, 0xe502ae8aU,
  0xa99c25e0U, 0xbc95517cU, 0x5c1095a1U
};

__constant const uint IV512[] = {
  0x8807a57eU, 0xe616af75U, 0xc5d3e4dbU,
  0xac9ab027U, 0xd915f117U, 0xb6eecc54U,
  0x06e8020bU, 0x4a92efd1U, 0xaac6e2c9U,
  0xddb21398U, 0xcae65838U, 0x437f203fU,
  0x25ea78e7U, 0x951fddd6U, 0xda6ed11dU,
  0xe13e3567U
};

__constant const uint mixtab0_c[] = {
  0x63633297U, 0x7c7c6febU, 0x77775ec7U,
  0x7b7b7af7U, 0xf2f2e8e5U, 0x6b6b0ab7U,
  0x6f6f16a7U, 0xc5c56d39U, 0x303090c0U,
  0x01010704U, 0x67672e87U, 0x2b2bd1acU,
  0xfefeccd5U, 0xd7d71371U, 0xabab7c9aU,
  0x767659c3U, 0xcaca4005U, 0x8282a33eU,
  0xc9c94909U, 0x7d7d68efU, 0xfafad0c5U,
  0x5959947fU, 0x4747ce07U, 0xf0f0e6edU,
  0xadad6e82U, 0xd4d41a7dU, 0xa2a243beU,
  0xafaf608aU, 0x9c9cf946U, 0xa4a451a6U,
  0x727245d3U, 0xc0c0762dU, 0xb7b728eaU,
  0xfdfdc5d9U, 0x9393d47aU, 0x2626f298U,
  0x363682d8U, 0x3f3fbdfcU, 0xf7f7f3f1U,
  0xcccc521dU, 0x34348cd0U, 0xa5a556a2U,
  0xe5e58db9U, 0xf1f1e1e9U, 0x71714cdfU,
  0xd8d83e4dU, 0x313197c4U, 0x15156b54U,
  0x04041c10U, 0xc7c76331U, 0x2323e98cU,
  0xc3c37f21U, 0x18184860U, 0x9696cf6eU,
  0x05051b14U, 0x9a9aeb5eU, 0x0707151cU,
  0x12127e48U, 0x8080ad36U, 0xe2e298a5U,
  0xebeba781U, 0x2727f59cU, 0xb2b233feU,
  0x757550cfU, 0x09093f24U, 0x8383a43aU,
  0x2c2cc4b0U, 0x1a1a4668U, 0x1b1b416cU,
  0x6e6e11a3U, 0x5a5a9d73U, 0xa0a04db6U,
  0x5252a553U, 0x3b3ba1ecU, 0xd6d61475U,
  0xb3b334faU, 0x2929dfa4U, 0xe3e39fa1U,
  0x2f2fcdbcU, 0x8484b126U, 0x5353a257U,
  0xd1d10169U, 0x00000000U, 0xededb599U,
  0x2020e080U, 0xfcfcc2ddU, 0xb1b13af2U,
  0x5b5b9a77U, 0x6a6a0db3U, 0xcbcb4701U,
  0xbebe17ceU, 0x3939afe4U, 0x4a4aed33U,
  0x4c4cff2bU, 0x5858937bU, 0xcfcf5b11U,
  0xd0d0066dU, 0xefefbb91U, 0xaaaa7b9eU,
  0xfbfbd7c1U, 0x4343d217U, 0x4d4df82fU,
  0x333399ccU, 0x8585b622U, 0x4545c00fU,
  0xf9f9d9c9U, 0x02020e08U, 0x7f7f66e7U,
  0x5050ab5bU, 0x3c3cb4f0U, 0x9f9ff04aU,
  0xa8a87596U, 0x5151ac5fU, 0xa3a344baU,
  0x4040db1bU, 0x8f8f800aU, 0x9292d37eU,
  0x9d9dfe42U, 0x3838a8e0U, 0xf5f5fdf9U,
  0xbcbc19c6U, 0xb6b62feeU, 0xdada3045U,
  0x2121e784U, 0x10107040U, 0xffffcbd1U,
  0xf3f3efe1U, 0xd2d20865U, 0xcdcd5519U,
  0x0c0c2430U, 0x1313794cU, 0xececb29dU,
  0x5f5f8667U, 0x9797c86aU, 0x4444c70bU,
  0x1717655cU, 0xc4c46a3dU, 0xa7a758aaU,
  0x7e7e61e3U, 0x3d3db3f4U, 0x6464278bU,
  0x5d5d886fU, 0x19194f64U, 0x737342d7U,
  0x60603b9bU, 0x8181aa32U, 0x4f4ff627U,
  0xdcdc225dU, 0x2222ee88U, 0x2a2ad6a8U,
  0x9090dd76U, 0x88889516U, 0x4646c903U,
  0xeeeebc95U, 0xb8b805d6U, 0x14146c50U,
  0xdede2c55U, 0x5e5e8163U, 0x0b0b312cU,
  0xdbdb3741U, 0xe0e096adU, 0x32329ec8U,
  0x3a3aa6e8U, 0x0a0a3628U, 0x4949e43fU,
  0x06061218U, 0x2424fc90U, 0x5c5c8f6bU,
  0xc2c27825U, 0xd3d30f61U, 0xacac6986U,
  0x62623593U, 0x9191da72U, 0x9595c662U,
  0xe4e48abdU, 0x797974ffU, 0xe7e783b1U,
  0xc8c84e0dU, 0x373785dcU, 0x6d6d18afU,
  0x8d8d8e02U, 0xd5d51d79U, 0x4e4ef123U,
  0xa9a97292U, 0x6c6c1fabU, 0x5656b943U,
  0xf4f4fafdU, 0xeaeaa085U, 0x6565208fU,
  0x7a7a7df3U, 0xaeae678eU, 0x08083820U,
  0xbaba0bdeU, 0x787873fbU, 0x2525fb94U,
  0x2e2ecab8U, 0x1c1c5470U, 0xa6a65faeU,
  0xb4b421e6U, 0xc6c66435U, 0xe8e8ae8dU,
  0xdddd2559U, 0x747457cbU, 0x1f1f5d7cU,
  0x4b4bea37U, 0xbdbd1ec2U, 0x8b8b9c1aU,
  0x8a8a9b1eU, 0x70704bdbU, 0x3e3ebaf8U,
  0xb5b526e2U, 0x66662983U, 0x4848e33bU,
  0x0303090cU, 0xf6f6f4f5U, 0x0e0e2a38U,
  0x61613c9fU, 0x35358bd4U, 0x5757be47U,
  0xb9b902d2U, 0x8686bf2eU, 0xc1c17129U,
  0x1d1d5374U, 0x9e9ef74eU, 0xe1e191a9U,
  0xf8f8decdU, 0x9898e556U, 0x11117744U,
  0x696904bfU, 0xd9d93949U, 0x8e8e870eU,
  0x9494c166U, 0x9b9bec5aU, 0x1e1e5a78U,
  0x8787b82aU, 0xe9e9a989U, 0xcece5c15U,
  0x5555b04fU, 0x2828d8a0U, 0xdfdf2b51U,
  0x8c8c8906U, 0xa1a14ab2U, 0x89899212U,
  0x0d0d2334U, 0xbfbf10caU, 0xe6e684b5U,
  0x4242d513U, 0x686803bbU, 0x4141dc1fU,
  0x9999e252U, 0x2d2dc3b4U, 0x0f0f2d3cU,
  0xb0b03df6U, 0x5454b74bU, 0xbbbb0cdaU,
  0x16166258U
};

#define TIX2(q, x00, x01, x08, x10, x24)   do { \
    x10 ^= x00; \
    x00 = (q); \
    x08 ^= x00; \
    x01 ^= x24; \
  } while (0)

#define TIX3(q, x00, x01, x04, x08, x16, x27, x30)   do { \
    x16 ^= x00; \
    x00 = (q); \
    x08 ^= x00; \
    x01 ^= x27; \
    x04 ^= x30; \
  } while (0)

#define TIX4(q, x00, x01, x04, x07, x08, x22, x24, x27, x30)   do { \
    x22 ^= x00; \
    x00 = (q); \
    x08 ^= x00; \
    x01 ^= x24; \
    x04 ^= x27; \
    x07 ^= x30; \
  } while (0)

#define CMIX30(x00, x01, x02, x04, x05, x06, x15, x16, x17)   do { \
    x00 ^= x04; \
    x01 ^= x05; \
    x02 ^= x06; \
    x15 ^= x04; \
    x16 ^= x05; \
    x17 ^= x06; \
  } while (0)

#define CMIX36(x00, x01, x02, x04, x05, x06, x18, x19, x20)   do { \
    x00 ^= x04; \
    x01 ^= x05; \
    x02 ^= x06; \
    x18 ^= x04; \
    x19 ^= x05; \
    x20 ^= x06; \
  } while (0)

//#define SMIX(x0, x1, x2, x3)   do { \
    uint c0 = 0; \
    uint c1 = 0; \
    uint c2 = 0; \
    uint c3 = 0; \
    uint r0 = 0; \
    uint r1 = 0; \
    uint r2 = 0; \
    uint r3 = 0; \
    uint tmp; \
    tmp = mixtab0[x0 >> 24]; \
    c0 ^= tmp; \
    tmp = mixtab1[(x0 >> 16) & 0xFF]; \
    c0 ^= tmp; \
    r1 ^= tmp; \
    tmp = mixtab2[(x0 >>  8) & 0xFF]; \
    c0 ^= tmp; \
    r2 ^= tmp; \
    tmp = mixtab3[x0 & 0xFF]; \
    c0 ^= tmp; \
    r3 ^= tmp; \
    tmp = mixtab0[x1 >> 24]; \
    c1 ^= tmp; \
    r0 ^= tmp; \
    tmp = mixtab1[(x1 >> 16) & 0xFF]; \
    c1 ^= tmp; \
    tmp = mixtab2[(x1 >>  8) & 0xFF]; \
    c1 ^= tmp; \
    r2 ^= tmp; \
    tmp = mixtab3[x1 & 0xFF]; \
    c1 ^= tmp; \
    r3 ^= tmp; \
    tmp = mixtab0[x2 >> 24]; \
    c2 ^= tmp; \
    r0 ^= tmp; \
    tmp = mixtab1[(x2 >> 16) & 0xFF]; \
    c2 ^= tmp; \
    r1 ^= tmp; \
    tmp = mixtab2[(x2 >>  8) & 0xFF]; \
    c2 ^= tmp; \
    tmp = mixtab3[x2 & 0xFF]; \
    c2 ^= tmp; \
    r3 ^= tmp; \
    tmp = mixtab0[x3 >> 24]; \
    c3 ^= tmp; \
    r0 ^= tmp; \
    tmp = mixtab1[(x3 >> 16) & 0xFF]; \
    c3 ^= tmp; \
    r1 ^= tmp; \
    tmp = mixtab2[(x3 >>  8) & 0xFF]; \
    c3 ^= tmp; \
    r2 ^= tmp; \
    tmp = mixtab3[x3 & 0xFF]; \
    c3 ^= tmp; \
    x0 = ((c0 ^ r0) & 0xFF000000U) \
      | ((c1 ^ r1) & 0x00FF0000U) \
      | ((c2 ^ r2) & 0x0000FF00U) \
      | ((c3 ^ r3) & 0x000000FFU); \
    x1 = ((c1 ^ (r0 << 8)) & 0xFF000000U) \
      | ((c2 ^ (r1 << 8)) & 0x00FF0000U) \
      | ((c3 ^ (r2 << 8)) & 0x0000FF00U) \
      | ((c0 ^ (r3 >> 24)) & 0x000000FFU); \
    x2 = ((c2 ^ (r0 << 16)) & 0xFF000000U) \
      | ((c3 ^ (r1 << 16)) & 0x00FF0000U) \
      | ((c0 ^ (r2 >> 16)) & 0x0000FF00U) \
      | ((c1 ^ (r3 >> 16)) & 0x000000FFU); \
    x3 = ((c3 ^ (r0 << 24)) & 0xFF000000U) \
      | ((c0 ^ (r1 >> 8)) & 0x00FF0000U) \
      | ((c1 ^ (r2 >> 8)) & 0x0000FF00U) \
      | ((c2 ^ (r3 >> 8)) & 0x000000FFU); \
  } while (0)

#define FUGUE512_3(x, y, z)    do {  \
    TIX4(x, S[0][0], S[0][1], S[0][4], S[0][7], S[0][8], S[2][2], S[2][4], S[2][7], S[3][0]); \
    CMIX36(S[3][3], S[3][4], S[3][5], S[0][1], S[0][2], S[0][3], S[1][5], S[1][6], S[1][7]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[3][3], &S[3][4], &S[3][5], &S[0][0]); \
    CMIX36(S[3][0], S[3][1], S[3][2], S[3][4], S[3][5], S[0][0], S[1][2], S[1][3], S[1][4]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[3][0], &S[3][1], &S[3][2], &S[3][3]); \
    CMIX36(S[2][7], S[2][8], S[2][9], S[3][1], S[3][2], S[3][3], S[0][9], S[1][0], S[1][1]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[2][7], &S[2][8], &S[2][9], &S[3][0]); \
    CMIX36(S[2][4], S[2][5], S[2][6], S[2][8], S[2][9], S[3][0], S[0][6], S[0][7], S[0][8]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[2][4], &S[2][5], &S[2][6], &S[2][7]); \
    \
    TIX4(y, S[2][4], S[2][5], S[2][8], S[3][1], S[3][2], S[1][0], S[1][2], S[1][5], S[1][8]); \
    CMIX36(S[2][1], S[2][2], S[2][3], S[2][5], S[2][6], S[2][7], S[0][3], S[0][4], S[0][5]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[2][1], &S[2][2], &S[2][3], &S[2][4]); \
    CMIX36(S[1][8], S[1][9], S[2][0], S[2][2], S[2][3], S[2][4], S[0][0], S[0][1], S[0][2]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[1][8], &S[1][9], &S[2][0], &S[2][1]); \
    CMIX36(S[1][5], S[1][6], S[1][7], S[1][9], S[2][0], S[2][1], S[3][3], S[3][4], S[3][5]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[1][5], &S[1][6], &S[1][7], &S[1][8]); \
    CMIX36(S[1][2], S[1][3], S[1][4], S[1][6], S[1][7], S[1][8], S[3][0], S[3][1], S[3][2]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[1][2], &S[1][3], &S[1][4], &S[1][5]); \
    \
    TIX4(z, S[1][2], S[1][3], S[1][6], S[1][9], S[2][0], S[3][4], S[0][0], S[0][3], S[0][6]); \
    CMIX36(S[0][9], S[1][0], S[1][1], S[1][3], S[1][4], S[1][5], S[2][7], S[2][8], S[2][9]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0][9], &S[1][0], &S[1][1], &S[1][2]); \
    CMIX36(S[0][6], S[0][7], S[0][8], S[1][0], S[1][1], S[1][2], S[2][4], S[2][5], S[2][6]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0][6], &S[0][7], &S[0][8], &S[0][9]); \
    CMIX36(S[0][3], S[0][4], S[0][5], S[0][7], S[0][8], S[0][9], S[2][1], S[2][2], S[2][3]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0][3], &S[0][4], &S[0][5], &S[0][6]); \
    CMIX36(S[0][0], S[0][1], S[0][2], S[0][4], S[0][5], S[0][6], S[1][8], S[1][9], S[2][0]); \
    SMIX(mixtab0, mixtab1, mixtab2, mixtab3, &S[0][0], &S[0][1], &S[0][2], &S[0][3]); \
  } while (0)

#define ROR3   do { \
	const uint tmp81 = S[8].s1, tmp82 = S[8].s2, tmp83 = S[8].s3; \
	S[8].s3 = S[8].s0; S[8].s2 = S[7].s3; S[8].s1 = S[7].s2; S[8].s0 = S[7].s1; S[7].s3 = S[7].s0; S[7].s2 = S[6].s3; S[7].s1 = S[6].s2; S[7].s0 = S[6].s1; S[6].s3 = S[6].s0; \
	S[6].s2 = S[5].s3; S[6].s1 = S[5].s2; S[6].s0 = S[5].s1; S[5].s3 = S[5].s0; S[5].s2 = S[4].s3; S[5].s1 = S[4].s2; S[5].s0 = S[4].s1; S[4].s3 = S[4].s0; S[4].s2 = S[3].s3; \
	S[4].s1 = S[3].s2; S[4].s0 = S[3].s1; S[3].s3 = S[3].s0; S[3].s2 = S[2].s3; S[3].s1 = S[2].s2; S[3].s0 = S[2].s1; S[2].s3 = S[2].s0; S[2].s2 = S[1].s3; S[2].s1 = S[1].s2; \
	S[2].s0 = S[1].s1; S[1].s3 = S[1].s0; S[1].s2 = S[0].s3; S[1].s1 = S[0].s2; S[1].s0 = S[0].s1; S[0].s3 = S[0].s0; S[0].s2 = tmp83; S[0].s1 = tmp82; S[0].s0 = tmp81; \
} while (0)

#define ROR8	do { \
	const uint4 B7 = S[7], B8 = S[8]; \
	S[8] = S[6]; S[7] = S[5]; S[6] = S[4]; S[5] = S[3]; S[4] = S[2]; S[3] = S[1]; S[2] = S[0]; S[1] = B8; S[0] = B7; \
} while(0)

#define ROR9	do { \
	const uint tmp63 = S[6].s3, tmp70 = S[7].s0, tmp71 = S[7].s1, tmp72 = S[7].s2, tmp73 = S[7].s3, tmp80 = S[8].s0, tmp81 = S[8].s1, tmp82 = S[8].s2, tmp83 = S[8].s3; \
	S[8].s3 = S[6].s2; S[8].s2 = S[6].s1; S[8].s1 = S[6].s0; S[8].s0 = S[5].s3; S[7].s3 = S[5].s2; S[7].s2 = S[5].s1; S[7].s1 = S[5].s0; S[7].s0 = S[4].s3; S[6].s3 = S[4].s2; \
	S[6].s2 = S[4].s1; S[6].s1 = S[4].s0; S[6].s0 = S[3].s3; S[5].s3 = S[3].s2; S[5].s2 = S[3].s1; S[5].s1 = S[3].s0; S[5].s0 = S[2].s3; S[4].s3 = S[2].s2; S[4].s2 = S[2].s1; \
	S[4].s1 = S[2].s0; S[4].s0 = S[1].s3; S[3].s3 = S[1].s2; S[3].s2 = S[1].s1; S[3].s1 = S[1].s0; S[3].s0 = S[0].s3; S[2].s3 = S[0].s2; S[2].s2 = S[0].s1; S[2].s1 = S[0].s0; \
	S[2].s0 = tmp83; S[1].s3 = tmp82; S[1].s2 = tmp81; S[1].s1 = tmp80; S[1].s0 = tmp73; S[0].s3 = tmp72; S[0].s2 = tmp71; S[0].s1 = tmp70; S[0].s0 = tmp63; \
} while(0)

#undef BYTE0
#undef BYTE1
#undef BYTE2
#undef BYTE3

#define BYTE0(x)	((x) & 0xFF)
#define BYTE1(x)	(((x) >> 8) & 0xFF)
#define BYTE2(x)	(((x) >> 16) & 0xFF)
#define BYTE3(x)	((x) >> 24)

//#define BYTE0(x)	as_uchar4(x).s0
//#define BYTE1(x)	as_uchar4(x).s1
//#define BYTE2(x)	as_uchar4(x).s2
//#define BYTE3(x)	as_uchar4(x).s3

void SMIX(__local const uint *restrict mixtab0, __local const uint *restrict mixtab1, __local const uint *restrict mixtab2, __local const uint *restrict mixtab3, uint4 *restrict inout)
{
	uint c[4], r[4], x[4];
	
	((uint4 *)x)[0] = *inout;
	
	c[0] = mixtab0[BYTE3(x[0])] ^ mixtab1[BYTE2(x[0])] ^ mixtab2[BYTE1(x[0])] ^ mixtab3[BYTE0(x[0])];
	c[1] = mixtab0[BYTE3(x[1])] ^ mixtab1[BYTE2(x[1])] ^ mixtab2[BYTE1(x[1])] ^ mixtab3[BYTE0(x[1])];
	c[2] = mixtab0[BYTE3(x[2])] ^ mixtab1[BYTE2(x[2])] ^ mixtab2[BYTE1(x[2])] ^ mixtab3[BYTE0(x[2])];
	c[3] = mixtab0[BYTE3(x[3])] ^ mixtab1[BYTE2(x[3])] ^ mixtab2[BYTE1(x[3])] ^ mixtab3[BYTE0(x[3])];
	
	r[0] = mixtab0[BYTE3(x[1])] ^ mixtab0[BYTE3(x[2])] ^ mixtab0[BYTE3(x[3])];
	r[1] = mixtab1[BYTE2(x[0])] ^ mixtab1[BYTE2(x[2])] ^ mixtab1[BYTE2(x[3])];
	r[2] = mixtab2[BYTE1(x[0])] ^ mixtab2[BYTE1(x[1])] ^ mixtab2[BYTE1(x[3])];
	r[3] = mixtab3[BYTE0(x[0])] ^ mixtab3[BYTE0(x[1])] ^ mixtab3[BYTE0(x[2])];
	
	x[0] = ((c[0] ^ r[0]) & 0xFF000000U)
	| ((c[1] ^ r[1]) & 0x00FF0000U)
	| ((c[2] ^ r[2]) & 0x0000FF00U)
	| ((c[3] ^ r[3]) & 0x000000FFU);
	
	//x[0] = as_uint((uchar4)(convert_uchar(c[3] ^ r[3]), convert_uchar((c[2] ^ r[2]) >> 8), convert_uchar((c[1] ^ r[1]) >> 16), convert_uchar((c[0] ^ r[0]) >> 24)));
	
	//x[0] = as_uint((((uchar16 *)c)[0] ^ ((uchar16 *)r)[0]).sc963);
		
	// c.s7 ^ r.s2, c.sa ^ r.s5, c.sd ^ r.s8, c.s0 ^ r.sf
	x[1] = ((c[1] ^ (r[0] << 8)) & 0xFF000000U)
	| ((c[2] ^ (r[1] << 8)) & 0x00FF0000U)
	| ((c[3] ^ (r[2] << 8)) & 0x0000FF00U)
	| ((c[0] ^ (r[3] >> 24)) & 0x000000FFU);
	
	//x[1] = as_uint(((uchar4)(((uchar16 *)c)[0].s7 ^ ((uchar16 *)r)[0].s2, ((uchar16 *)c)[0].sa ^ ((uchar16 *)r)[0].s5, ((uchar16 *)c)[0].sd ^ ((uchar16 *)r)[0].s8, ((uchar16 *)c)[0].s0 ^ ((uchar16 *)r)[0].sf)).s3210);
	//x[1] = as_uint(((uchar16 *)c)[0].s0da7 ^ ((uchar16 *)r)[0].sf852);
	
	x[2] = ((c[2] ^ (r[0] << 16)) & 0xFF000000U)
	| ((c[3] ^ (r[1] << 16)) & 0x00FF0000U)
	| ((c[0] ^ (r[2] >> 16)) & 0x0000FF00U)
	| ((c[1] ^ (r[3] >> 16)) & 0x000000FFU);
	x[3] = ((c[3] ^ (r[0] << 24)) & 0xFF000000U)
	| ((c[0] ^ (r[1] >> 8)) & 0x00FF0000U)
	| ((c[1] ^ (r[2] >> 8)) & 0x0000FF00U)
	| ((c[2] ^ (r[3] >> 8)) & 0x000000FFU);
	
	/*((uint4 *)x)[0] = 0;
	((uint4 *)x)[0] |= (((uint4 *)c)[0] ^ rotate((uint4)(r[0]), (uint4)(0, 8, 16, 24))) & 0xFF000000;
	((uint4 *)x)[0] |= (((uint4 *)c)[0].s1230 ^ rotate((uint4)(r[1]), (uint4)(0, 8, 16, 24))) & 0x00FF0000;
	((uint4 *)x)[0] |= (((uint4 *)c)[0].s2301 ^ rotate((uint4)(r[2]), (uint4)(0, 8, 16, 24))) & 0x0000FF00;
	((uint4 *)x)[0] |= (((uint4 *)c)[0].s3012 ^ rotate((uint4)(r[3]), (uint4)(0, 8, 16, 24))) & 0x000000FF;*/
	
	*inout = ((uint4 *)x)[0];
}
