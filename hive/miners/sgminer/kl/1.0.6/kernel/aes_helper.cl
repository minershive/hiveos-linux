#ifndef AES_HELPER_H
#define AES_HELPER_H

/* $Id: aes_helper.c 220 2010-06-09 09:21:50Z tp $ */
/*
 * AES tables. This file is not meant to be compiled by itself; it
 * is included by some hash function implementations. It contains
 * the precomputed tables and helper macros for evaluating an AES
 * round, optionally with a final XOR with a subkey.
 *
 * By default, this file defines the tables and macros for little-endian
 * processing (i.e. it is assumed that the input bytes have been read
 * from memory and assembled with the little-endian convention). If
 * the 'AES_BIG_ENDIAN' macro is defined (to a non-zero integer value)
 * when this file is included, then the tables and macros for big-endian
 * processing are defined instead. The big-endian tables and macros have
 * names distinct from the little-endian tables and macros, hence it is
 * possible to have both simultaneously, by including this file twice
 * (with and without the AES_BIG_ENDIAN macro).
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

#if AES_BIG_ENDIAN

#define AESx(x)   ( ((SPH_C32(x) >> 24) & SPH_C32(0x000000FF)) \
                  | ((SPH_C32(x) >>  8) & SPH_C32(0x0000FF00)) \
                  | ((SPH_C32(x) <<  8) & SPH_C32(0x00FF0000)) \
                  | ((SPH_C32(x) << 24) & SPH_C32(0xFF000000)))

#define AES0      AES0_BE
#define AES1      AES1_BE
#define AES2      AES2_BE
#define AES3      AES3_BE

#define AES_ROUND_BE(X0, X1, X2, X3, K0, K1, K2, K3, Y0, Y1, Y2, Y3)   do { \
    (Y0) = AES0[((X0) >> 24) & 0xFF] \
      ^ AES1[((X1) >> 16) & 0xFF] \
      ^ AES2[((X2) >> 8) & 0xFF] \
      ^ AES3[(X3) & 0xFF] ^ (K0); \
    (Y1) = AES0[((X1) >> 24) & 0xFF] \
      ^ AES1[((X2) >> 16) & 0xFF] \
      ^ AES2[((X3) >> 8) & 0xFF] \
      ^ AES3[(X0) & 0xFF] ^ (K1); \
    (Y2) = AES0[((X2) >> 24) & 0xFF] \
      ^ AES1[((X3) >> 16) & 0xFF] \
      ^ AES2[((X0) >> 8) & 0xFF] \
      ^ AES3[(X1) & 0xFF] ^ (K2); \
    (Y3) = AES0[((X3) >> 24) & 0xFF] \
      ^ AES1[((X0) >> 16) & 0xFF] \
      ^ AES2[((X1) >> 8) & 0xFF] \
      ^ AES3[(X2) & 0xFF] ^ (K3); \
  } while (0)

#define AES_ROUND_NOKEY_BE(X0, X1, X2, X3, Y0, Y1, Y2, Y3) \
  AES_ROUND_BE(X0, X1, X2, X3, 0, 0, 0, 0, Y0, Y1, Y2, Y3)

#else

#define AESx(x)   SPH_C32(x)
#define AES0      AES0_LE
#define AES1      AES1_LE
#define AES2      AES2_LE
#define AES3      AES3_LE

#define AES_ROUND_LE(X0, X1, X2, X3, K0, K1, K2, K3, Y0, Y1, Y2, Y3)   do { \
    (Y0) = AES0[(X0) & 0xFF] \
      ^ AES1[((X1) >> 8) & 0xFF] \
      ^ AES2[((X2) >> 16) & 0xFF] \
      ^ AES3[((X3) >> 24) & 0xFF] ^ (K0); \
    (Y1) = AES0[(X1) & 0xFF] \
      ^ AES1[((X2) >> 8) & 0xFF] \
      ^ AES2[((X3) >> 16) & 0xFF] \
      ^ AES3[((X0) >> 24) & 0xFF] ^ (K1); \
    (Y2) = AES0[(X2) & 0xFF] \
      ^ AES1[((X3) >> 8) & 0xFF] \
      ^ AES2[((X0) >> 16) & 0xFF] \
      ^ AES3[((X1) >> 24) & 0xFF] ^ (K2); \
    (Y3) = AES0[(X3) & 0xFF] \
      ^ AES1[((X0) >> 8) & 0xFF] \
      ^ AES2[((X1) >> 16) & 0xFF] \
      ^ AES3[((X2) >> 24) & 0xFF] ^ (K3); \
  } while (0)

#define AES_ROUND_NOKEY_LE(X0, X1, X2, X3, Y0, Y1, Y2, Y3) \
  AES_ROUND_LE(X0, X1, X2, X3, 0, 0, 0, 0, Y0, Y1, Y2, Y3)

#endif

#endif
