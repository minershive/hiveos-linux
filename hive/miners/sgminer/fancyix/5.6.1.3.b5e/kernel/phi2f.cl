/* Phi2 kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2016 tpruvot
 * Copyright (c) 2018 fancyIX
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
 * @author tpruvot 2016
 * @author fancyIX 2018
 */

#if __ENDIAN_LITTLE__
  #define SPH_LITTLE_ENDIAN 1
#else
  #define SPH_BIG_ENDIAN 1
#endif

#define SPH_UPTR sph_u64
typedef unsigned int sph_u32;
typedef int sph_s32;

#ifndef __OPENCL_VERSION__
  typedef unsigned long long sph_u64;
#else
  typedef unsigned long sph_u64;
#endif

#define SPH_64 1
#define SPH_64_TRUE 1

#define SPH_C32(x) ((sph_u32)(x ## U))
#define SPH_T32(x) (as_uint(x))
#define SPH_ROTL32(x, n) rotate(as_uint(x), as_uint(n))
#define SPH_ROTR32(x, n) SPH_ROTL32(x, (32 - (n)))

#define SPH_C64(x) ((sph_u64)(x ## UL))
#define SPH_T64(x) (as_ulong(x))
#define SPH_ROTL64(x, n) rotate(as_ulong(x), (n) & 0xFFFFFFFFFFFFFFFFUL)
#define SPH_ROTR64(x, n) SPH_ROTL64(x, (64 - (n)))

#define SPH_ECHO_64 1
#define SPH_JH_64 1
#define SPH_CUBEHASH_UNROLL 0

#include "skein.cl"
#include "jh.cl"
#include "cubehash.cl"
#include "fugue.cl"
#include "gost-mod.cl"
#include "echo.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
#define SWAP32(x) as_ulong(as_uint2(x).s10)

#if SPH_BIG_ENDIAN
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC64LE(x) SWAP8(*(const __global sph_u64 *) (x));
#else
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC64LE(x) (*(const __global sph_u64 *) (x));
#endif

#define SHL(x, n) ((x) << (n))
#define SHR(x, n) ((x) >> (n))

typedef union {
  unsigned char h1[64];
  unsigned short h2[32];
  uint h4[16];
  ulong h8[8];
} hash_t;

typedef union {
    uint h4[8];
    ulong h8[4];
    uint4 h16[2];
    ulong2 hl16[2];
    ulong4 h32;
} hash2_t;

typedef union {
    uint h4[32];
    ulong h8[16];
    uint4 h16[8];
    ulong2 hl16[8];
    ulong4 h32[4];
} lyraState_t;

#define SWAP8_INPUT(x)   x
#define SWAP8_USELESS(x) x


#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC32LE(x) SWAP4(*(const __global sph_u32 *) (x));
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC32LE(x) (*(const __global sph_u32 *) (x));
#endif

#define WOLF_JH_64BIT 1

#include "lyra2mdzf2.cl"


/// lyra2 algo p2 

__attribute__((amdgpu_waves_per_eu(1,1)))
__attribute__((amdgpu_num_vgpr(256)))
__attribute__((amdgpu_num_sgpr(200)))
__attribute__((reqd_work_group_size(4, 4, 16)))
__kernel void search2(__global uchar* sharedDataBuf)
{
  uint gid = get_global_id(2);
  __global lyraState_t *lyraState = (__global lyraState_t *)(sharedDataBuf + ((8 * 4 * 4 * 2) * (gid-get_global_offset(2))));
  __global lyraState_t *lyraState2 = (__global lyraState_t *)(sharedDataBuf + ((8 * 4 * 4) + (8 * 4 * 4 * 2) * (gid-get_global_offset(2))));

  uint notepad[192];

  const int player = get_local_id(1) % 4;

  uint state[4];
  uint si[3];
  uint sII[3];
  uint s0;
	uint s1;
	uint s2;
	uint s3;
  int ss0;
  uint ss1;
	uint ss3;
  uint ss;
  uint carry;
  const uint mindex = (LOCAL_LINEAR & 1) == 0 ? 0 : 1;

  //-------------------------------------
  // Load Lyra state
  if (LOCAL_LINEAR == 0) state[0] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 0]));
  if (LOCAL_LINEAR == 0) state[1] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 1]));
  if (LOCAL_LINEAR == 0) state[2] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 2]));
  if (LOCAL_LINEAR == 0) state[3] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 3]));
  if (LOCAL_LINEAR == 1) state[0] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 0 + 1]));
  if (LOCAL_LINEAR == 1) state[1] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 1 + 1]));
  if (LOCAL_LINEAR == 1) state[2] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 2 + 1]));
  if (LOCAL_LINEAR == 1) state[3] = ((uint)(lyraState->h4[2 * player + 2 * 4 * 3 + 1]));
  if (LOCAL_LINEAR == 2) state[0] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 0]));
  if (LOCAL_LINEAR == 2) state[1] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 1]));
  if (LOCAL_LINEAR == 2) state[2] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 2]));
  if (LOCAL_LINEAR == 2) state[3] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 3]));
  if (LOCAL_LINEAR == 3) state[0] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 0 + 1]));
  if (LOCAL_LINEAR == 3) state[1] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 1 + 1]));
  if (LOCAL_LINEAR == 3) state[2] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 2 + 1]));
  if (LOCAL_LINEAR == 3) state[3] = ((uint)(lyraState2->h4[2 * player + 2 * 4 * 3 + 1]));

  SETSGPR100101;

  write_state(notepad, state, 0, 7);
  round_lyra_4way_sw(state);
  
  write_state(notepad, state, 0, 6);
  round_lyra_4way_sw(state);
  write_state(notepad, state, 0, 5);
  round_lyra_4way_sw(state);
  write_state(notepad, state, 0, 4);
  round_lyra_4way_sw(state);
  write_state(notepad, state, 0, 3);
  round_lyra_4way_sw(state);
  write_state(notepad, state, 0, 2);
  round_lyra_4way_sw(state);
  write_state(notepad, state, 0, 1);
  round_lyra_4way_sw(state);
  write_state(notepad, state, 0, 0);
  round_lyra_4way_sw(state);
  
  make_hyper_one_macro(state, notepad);
  
  make_next_hyper_macro(1, 0, 2, state, notepad);
  
  make_next_hyper_macro(2, 1, 3, state, notepad);
  make_next_hyper_macro(3, 0, 4, state, notepad);
  make_next_hyper_macro(4, 3, 5, state, notepad);
  make_next_hyper_macro(5, 2, 6, state, notepad);
  make_next_hyper_macro(6, 1, 7, state, notepad);

  uint modify = 0;
  uint p0;
  uint p1;
  uint p2;
  uint p3;

  broadcast_zero(state);
  hyper_xor_dpp_macro(7, modify, 0, state, notepad);
  
  broadcast_zero(state);
  hyper_xor_dpp_macro(0, modify, 3, state, notepad);
  
  broadcast_zero(state);
  hyper_xor_dpp_macro(3, modify, 6, state, notepad);
  
  broadcast_zero(state);
  hyper_xor_dpp_macro(6, modify, 1, state, notepad);
  broadcast_zero(state);
  hyper_xor_dpp_macro(1, modify, 4, state, notepad);
  broadcast_zero(state);
  hyper_xor_dpp_macro(4, modify, 7, state, notepad);
  broadcast_zero(state);
  hyper_xor_dpp_macro(7, modify, 2, state, notepad);
  broadcast_zero(state);
  hyper_xor_dpp_macro(2, modify, 5, state, notepad);

  state_xor_modify(modify, 0, 0, mindex, state, notepad);
  state_xor_modify(modify, 1, 0, mindex, state, notepad);
  state_xor_modify(modify, 2, 0, mindex, state, notepad);
  state_xor_modify(modify, 3, 0, mindex, state, notepad);
  state_xor_modify(modify, 4, 0, mindex, state, notepad);
  state_xor_modify(modify, 5, 0, mindex, state, notepad);
  state_xor_modify(modify, 6, 0, mindex, state, notepad);
  state_xor_modify(modify, 7, 0, mindex, state, notepad);
/**/

  //-------------------------------------
  // save lyra state
  if (LOCAL_LINEAR == 0) lyraState->h4[2 * player + 2 * 4 * 0] = state[0];
  if (LOCAL_LINEAR == 0) lyraState->h4[2 * player + 2 * 4 * 1] = state[1];
  if (LOCAL_LINEAR == 0) lyraState->h4[2 * player + 2 * 4 * 2] = state[2];
  if (LOCAL_LINEAR == 0) lyraState->h4[2 * player + 2 * 4 * 3] = state[3];
  if (LOCAL_LINEAR == 1) lyraState->h4[2 * player + 2 * 4 * 0 + 1] = state[0];
  if (LOCAL_LINEAR == 1) lyraState->h4[2 * player + 2 * 4 * 1 + 1] = state[1];
  if (LOCAL_LINEAR == 1) lyraState->h4[2 * player + 2 * 4 * 2 + 1] = state[2];
  if (LOCAL_LINEAR == 1) lyraState->h4[2 * player + 2 * 4 * 3 + 1] = state[3];
  if (LOCAL_LINEAR == 2) lyraState2->h4[2 * player + 2 * 4 * 0] = state[0];
  if (LOCAL_LINEAR == 2) lyraState2->h4[2 * player + 2 * 4 * 1] = state[1];
  if (LOCAL_LINEAR == 2) lyraState2->h4[2 * player + 2 * 4 * 2] = state[2];
  if (LOCAL_LINEAR == 2) lyraState2->h4[2 * player + 2 * 4 * 3] = state[3];
  if (LOCAL_LINEAR == 3) lyraState2->h4[2 * player + 2 * 4 * 0 + 1] = state[0];
  if (LOCAL_LINEAR == 3) lyraState2->h4[2 * player + 2 * 4 * 1 + 1] = state[1];
  if (LOCAL_LINEAR == 3) lyraState2->h4[2 * player + 2 * 4 * 2 + 1] = state[2];
  if (LOCAL_LINEAR == 3) lyraState2->h4[2 * player + 2 * 4 * 3 + 1] = state[3];

  barrier(CLK_GLOBAL_MEM_FENCE);
}
