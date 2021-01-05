/*
 * MyriadCoin Groestl kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2014  phm
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
 * @author   phm <phm@inbox.com>
 */
 #ifndef SHA256F_CL
 #define SHA256F_CL

#define SHA256_S0(x) (ROL32(x, 25) ^ ROL32(x, 14) ^  SHR(x, 3))
#define SHA256_S1(x) (ROL32(x, 15) ^ ROL32(x, 13) ^  SHR(x, 10))

#define SHA256_S2(x) (ROL32(x, 30) ^ ROL32(x, 19) ^ ROL32(x, 10))
#define SHA256_S3(x) (ROL32(x, 26) ^ ROL32(x, 21) ^ ROL32(x, 7))

#define SHA256_P(a,b,c,d,e,f,g,h,x,K)                  \
{                                               \
  temp1 = h + SHA256_S3(e) + SHA256_F1(e,f,g) + (K + x);      \
  d += temp1; h = temp1 + SHA256_S2(a) + SHA256_F0(a,b,c);  \
}

#define SHA256_PLAST(a,b,c,d,e,f,g,h,x,K)                  \
{                                               \
  d += h + SHA256_S3(e) + SHA256_F1(e,f,g) + (x + K);              \
}

#define SHA256_F0(y, x, z) bitselect(z, y, z ^ x)
#define SHA256_F1(x, y, z) bitselect(z, y, x)

#define SHA256_R0 (W0 = SHA256_S1(W14) + W9 + SHA256_S0(W1) + W0)
#define SHA256_R1 (W1 = SHA256_S1(W15) + W10 + SHA256_S0(W2) + W1)
#define SHA256_R2 (W2 = SHA256_S1(W0) + W11 + SHA256_S0(W3) + W2)
#define SHA256_R3 (W3 = SHA256_S1(W1) + W12 + SHA256_S0(W4) + W3)
#define SHA256_R4 (W4 = SHA256_S1(W2) + W13 + SHA256_S0(W5) + W4)
#define SHA256_R5 (W5 = SHA256_S1(W3) + W14 + SHA256_S0(W6) + W5)
#define SHA256_R6 (W6 = SHA256_S1(W4) + W15 + SHA256_S0(W7) + W6)
#define SHA256_R7 (W7 = SHA256_S1(W5) + W0 + SHA256_S0(W8) + W7)
#define SHA256_R8 (W8 = SHA256_S1(W6) + W1 + SHA256_S0(W9) + W8)
#define SHA256_R9 (W9 = SHA256_S1(W7) + W2 + SHA256_S0(W10) + W9)
#define SHA256_R10 (W10 = SHA256_S1(W8) + W3 + SHA256_S0(W11) + W10)
#define SHA256_R11 (W11 = SHA256_S1(W9) + W4 + SHA256_S0(W12) + W11)
#define SHA256_R12 (W12 = SHA256_S1(W10) + W5 + SHA256_S0(W13) + W12)
#define SHA256_R13 (W13 = SHA256_S1(W11) + W6 + SHA256_S0(W14) + W13)
#define SHA256_R14 (W14 = SHA256_S1(W12) + W7 + SHA256_S0(W15) + W14)
#define SHA256_R15 (W15 = SHA256_S1(W13) + W8 + SHA256_S0(W0) + W15)

#define SHA256_RD14 (SHA256_S1(W12) + W7 + SHA256_S0(W15) + W14)
#define SHA256_RD15 (SHA256_S1(W13) + W8 + SHA256_S0(W0) + W15)

#endif // SHA256F_CL