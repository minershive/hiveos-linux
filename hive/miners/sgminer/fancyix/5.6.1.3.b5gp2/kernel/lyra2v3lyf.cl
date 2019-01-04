// lyra441p2 kernel.
// Author: CryptoGraphics ( CrGraphics@protonmail.com )
// Author: fancyIX 2019

#if defined(__GCNMINC__)
uint __attribute__((overloadable)) amd_bitalign(uint src0, uint src1, uint src2)
{
	uint dstx = 0;
	uint dsty = 0;
    __asm ("v_alignbit_b32 %[dstx], %[src0x], %[src1x], %[src2x]\n"
          : [dstx] "=&v" (dstx)
          : [src0x] "v" (src0), [src1x] "v" (src1), [src2x] "v" (src2));
	return (uint) (dstx);
}
uint __attribute__((overloadable)) amd_bytealign(uint src0, uint src1, uint src2)
{
	uint dstx = 0;
	uint dsty = 0;
    __asm ("v_alignbyte_b32 %[dstx], %[src0x], %[src1x], %[src2x]\n"
          : [dstx] "=&v" (dstx)
          : [src0x] "v" (src0), [src1x] "v" (src1), [src2x] "v" (src2));
	return (uint) (dstx);
}
#else
#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable
#endif

#define rotr64(x, n) ((n) < 32 ? (amd_bitalign((uint)((x) >> 32), (uint)(x), (uint)(n)) | ((ulong)amd_bitalign((uint)(x), (uint)((x) >> 32), (uint)(n)) << 32)) : (amd_bitalign((uint)(x), (uint)((x) >> 32), (uint)(n) - 32) | ((ulong)amd_bitalign((uint)((x) >> 32), (uint)(x), (uint)(n) - 32) << 32)))

#define Gfunc(a,b,c,d) \
{ \
    a += b;  \
    d ^= a; \
    d = rotr64(d, 32); \
 \
    c += d;  \
    b ^= c; \
    b = rotr64(b, 24); \
 \
    a += b;  \
    d ^= a; \
    d = rotr64(d, 16); \
 \
    c += d; \
    b ^= c; \
    b = rotr64(b, 63); \
}

#define roundLyra(state) \
{ \
     Gfunc(state[0].x, state[2].x, state[4].x, state[6].x); \
     Gfunc(state[0].y, state[2].y, state[4].y, state[6].y); \
     Gfunc(state[1].x, state[3].x, state[5].x, state[7].x); \
     Gfunc(state[1].y, state[3].y, state[5].y, state[7].y); \
 \
     Gfunc(state[0].x, state[2].y, state[5].x, state[7].y); \
     Gfunc(state[0].y, state[3].x, state[5].y, state[6].x); \
     Gfunc(state[1].x, state[3].y, state[4].x, state[6].y); \
     Gfunc(state[1].y, state[2].x, state[4].y, state[7].x); \
}

#define SHUFFLE_0(s) \
    { \
      uint2 s1, s2, s3; \
      s1 = as_uint2(s[1]); \
      s2 = as_uint2(s[2]); \
      s3 = as_uint2(s[3]); \
		__asm ( \
	     "s_nop 1\n" \
		  "v_mov_b32_dpp  %[s1x], %[s1x] quad_perm:[1,2,3,0]\n" \
        "v_mov_b32_dpp  %[s1y], %[s1y] quad_perm:[1,2,3,0]\n" \
        "v_mov_b32_dpp  %[s2x], %[s2x] quad_perm:[2,3,0,1]\n" \
        "v_mov_b32_dpp  %[s2y], %[s2y] quad_perm:[2,3,0,1]\n" \
        "v_mov_b32_dpp  %[s3x], %[s3x] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s3y], %[s3y] quad_perm:[3,0,1,2]\n" \
		  "s_nop 1\n" \
		  : [s1x] "=&v" (s1.x), \
          [s1y] "=&v" (s1.y), \
		    [s2x] "=&v" (s2.x), \
          [s2y] "=&v" (s2.y), \
          [s3x] "=&v" (s3.x), \
          [s3y] "=&v" (s3.y) \
		  : [s1x] "0" (s1.x), \
          [s1y] "1" (s1.y), \
		    [s2x] "2" (s2.x), \
          [s2y] "3" (s2.y), \
          [s3x] "4" (s3.x), \
          [s3y] "5" (s3.y)); \
        s[1] = as_ulong(s1); \
        s[2] = as_ulong(s2); \
        s[3] = as_ulong(s3); \
	}

#define SHUFFLE_1(s) \
    { \
      uint2 s1, s2, s3; \
      s1 = as_uint2(s[1]); \
      s2 = as_uint2(s[2]); \
      s3 = as_uint2(s[3]); \
		__asm ( \
	     "s_nop 1\n" \
		  "v_mov_b32_dpp  %[s1x], %[s1x] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s1y], %[s1y] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s2x], %[s2x] quad_perm:[2,3,0,1]\n" \
        "v_mov_b32_dpp  %[s2y], %[s2y] quad_perm:[2,3,0,1]\n" \
        "v_mov_b32_dpp  %[s3x], %[s3x] quad_perm:[1,2,3,0]\n" \
        "v_mov_b32_dpp  %[s3y], %[s3y] quad_perm:[1,2,3,0]\n" \
		  "s_nop 1\n" \
		  : [s1x] "=&v" (s1.x), \
          [s1y] "=&v" (s1.y), \
		    [s2x] "=&v" (s2.x), \
          [s2y] "=&v" (s2.y), \
          [s3x] "=&v" (s3.x), \
          [s3y] "=&v" (s3.y) \
		  : [s1x] "0" (s1.x), \
          [s1y] "1" (s1.y), \
		    [s2x] "2" (s2.x), \
          [s2y] "3" (s2.y), \
          [s3x] "4" (s3.x), \
          [s3y] "5" (s3.y)); \
        s[1] = as_ulong(s1); \
        s[2] = as_ulong(s2); \
        s[3] = as_ulong(s3); \
	}

#define SHUFFLE_D_0(Data, s) \
    { \
      uint2 s0, s1, s2; \
      s0 = as_uint2(s[0]); \
      s1 = as_uint2(s[1]); \
      s2 = as_uint2(s[2]); \
		__asm ( \
	     "s_nop 1\n" \
		  "v_mov_b32_dpp  %[s0x], %[s0x] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s0y], %[s0y] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s1x], %[s1x] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s1y], %[s1y] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s2x], %[s2x] quad_perm:[3,0,1,2]\n" \
        "v_mov_b32_dpp  %[s2y], %[s2y] quad_perm:[3,0,1,2]\n" \
		  "s_nop 1\n" \
		  : [s0x] "=&v" (s0.x), \
          [s0y] "=&v" (s0.y), \
		    [s1x] "=&v" (s1.x), \
          [s1y] "=&v" (s1.y), \
          [s2x] "=&v" (s2.x), \
          [s2y] "=&v" (s2.y) \
		  : [s0x] "0" (s0.x), \
          [s0y] "1" (s0.y), \
		    [s1x] "2" (s1.x), \
          [s1y] "3" (s1.y), \
          [s2x] "4" (s2.x), \
          [s2y] "5" (s2.y)); \
      Data ## 0 = as_ulong(s0); \
      Data ## 1 = as_ulong(s1); \
      Data ## 2 = as_ulong(s2); \
	}

#define BROADCAST_0(d, s)  \
    { \
		__asm ( \
	     "s_nop 1\n" \
		  "v_mov_b32_dpp  %[d0], %[s0] quad_perm:[0,0,0,0]\n" \
		  "s_nop 1\n" \
		  : [d0] "=&v" (d) \
		  : [s0] "0" (s)); \
	}

#define BROADCAST_L_0(d, l, s)  \
    { \
		__asm ( \
		  "ds_bpermute_b32  %[d0], %[l0], %[s0]\n" \
		  "s_waitcnt lgkmcnt(0)\n" \
		  : [d0] "=&v" (d) \
		  : [l0] "v" (l), \
          [s0] "v" (s)); \
	}

#define roundLyra_sm(state) \
{ \
    Gfunc(state[0], state[1], state[2], state[3]); \
    SHUFFLE_0(state); \
 \
    Gfunc(state[0], state[1], state[2], state[3]); \
 \
    SHUFFLE_1(state); \
}

#define roundLyra_sm_ext(state) \
{ \
    Gfunc(state[0], state[1], state[2], state[3]); \
    SHUFFLE_0(state); \
 \
    Gfunc(state[0], state[1], state[2], state[3]); \
 \
    SHUFFLE_1(state); \
}

struct SharedState
{
    ulong s[4];
};

#define loop3p1_iteration(st00,st01,st02, lm20,lm21,lm22) \
{ \
    t0 = state0[st00]; \
    c0 = state1[st00] + t0; \
    state[0] ^= c0; \
 \
    t0 = state0[st01]; \
    c0 = state1[st01] + t0; \
    state[1] ^= c0; \
 \
    t0 = state0[st02]; \
    c0 = state1[st02] + t0; \
    state[2] ^= c0; \
 \
    roundLyra_sm_ext(state); \
 \
    state2[0] = state1[st00]; \
    state2[1] = state1[st01]; \
    state2[2] = state1[st02]; \
 \
    state2[0] ^= state[0]; \
    state2[1] ^= state[1]; \
    state2[2] ^= state[2]; \
 \
    lMatrix[lm20] = state2[0]; \
    lMatrix[lm21] = state2[1]; \
    lMatrix[lm22] = state2[2]; \
 \
    ulong Data0, Data1, Data2; \
    SHUFFLE_D_0(Data, state); \
    if((lIdx&3) == 0) \
    { \
        state0[st01] ^= Data0; \
        state0[st02] ^= Data1; \
        state0[st00] ^= Data2; \
    } \
    else \
    { \
        state0[st00] ^= Data0; \
        state0[st01] ^= Data1; \
        state0[st02] ^= Data2; \
    } \
 \
    lMatrix[st00] = state0[st00]; \
    lMatrix[st01] = state0[st01]; \
    lMatrix[st02] = state0[st02]; \
 \
    state0[st00] = state2[0]; \
    state0[st01] = state2[1]; \
    state0[st02] = state2[2]; \
}

#define loop3p2_iteration(st00,st01,st02, st10,st11,st12, lm30,lm31,lm32, lm10,lm11,lm12) \
{ \
    t0 = state1[st00]; \
    c0 = state0[st10] + t0; \
    state[0] ^= c0; \
 \
    t0 = state1[st01]; \
    c0 = state0[st11] + t0; \
    state[1] ^= c0; \
 \
    t0 = state1[st02]; \
    c0 = state0[st12] + t0; \
    state[2] ^= c0; \
 \
    roundLyra_sm_ext(state); \
 \
    state0[st10] ^= state[0]; \
    state0[st11] ^= state[1]; \
    state0[st12] ^= state[2]; \
 \
    lMatrix[lm30] = state0[st10]; \
    lMatrix[lm31] = state0[st11]; \
    lMatrix[lm32] = state0[st12]; \
 \
    ulong Data0, Data1, Data2; \
    SHUFFLE_D_0(Data, state); \
    if((lIdx&3) == 0) \
    { \
        state1[st01] ^= Data0; \
        state1[st02] ^= Data1; \
        state1[st00] ^= Data2; \
    } \
    else \
    { \
        state1[st00] ^= Data0; \
        state1[st01] ^= Data1; \
        state1[st02] ^= Data2; \
    } \
 \
    lMatrix[lm10] = state1[st00]; \
    lMatrix[lm11] = state1[st01]; \
    lMatrix[lm12] = state1[st02]; \
}

#define wanderIteration(prv00,prv01,prv02, rng00,rng01,rng02, rng10,rng11,rng12, rng20,rng21,rng22, rng30,rng31,rng32, rou00,rou01,rou02) \
{ \
    a_state1_0 = lMatrix[prv00]; \
    a_state1_1 = lMatrix[prv01]; \
    a_state1_2 = lMatrix[prv02]; \
 \
    b0 = (rowa < 2)? lMatrix[rng00]: lMatrix[rng20]; \
    b1 = (rowa < 2)? lMatrix[rng10]: lMatrix[rng30]; \
    a_state2_0 = ((rowa & 0x1U) < 1)? b0: b1; \
 \
    b0 = (rowa < 2)? lMatrix[rng01]: lMatrix[rng21]; \
    b1 = (rowa < 2)? lMatrix[rng11]: lMatrix[rng31]; \
    a_state2_1 = ((rowa & 0x1U) < 1)? b0: b1; \
 \
    b0 = (rowa < 2)? lMatrix[rng02]: lMatrix[rng22]; \
    b1 = (rowa < 2)? lMatrix[rng12]: lMatrix[rng32]; \
    a_state2_2 = ((rowa & 0x1U) < 1)? b0: b1; \
 \
    t0 = a_state1_0; \
    c0 = a_state2_0 + t0; \
    state[0] ^= c0; \
 \
    t0 = a_state1_1; \
    c0 = a_state2_1 + t0; \
    state[1] ^= c0; \
 \
    t0 = a_state1_2; \
    c0 = a_state2_2 + t0; \
    state[2] ^= c0; \
 \
    roundLyra_sm_ext(state); \
    SHUFFLE_D_0(a_state1_, state); \
 \
    if(rowa == 0) \
    { \
        lMatrix[rng00] = a_state2_0; \
        lMatrix[rng01] = a_state2_1; \
        lMatrix[rng02] = a_state2_2; \
        lMatrix[rng00] ^= ((lIdx&3) == 0)?a_state1_2:a_state1_0; \
        lMatrix[rng01] ^= ((lIdx&3) == 0)?a_state1_0:a_state1_1; \
        lMatrix[rng02] ^= ((lIdx&3) == 0)?a_state1_1:a_state1_2; \
    } \
    if(rowa == 1) \
    { \
        lMatrix[rng10] = a_state2_0; \
        lMatrix[rng11] = a_state2_1; \
        lMatrix[rng12] = a_state2_2; \
        lMatrix[rng10] ^= ((lIdx&3) == 0)?a_state1_2:a_state1_0; \
        lMatrix[rng11] ^= ((lIdx&3) == 0)?a_state1_0:a_state1_1; \
        lMatrix[rng12] ^= ((lIdx&3) == 0)?a_state1_1:a_state1_2; \
    } \
    if(rowa == 2) \
    { \
        lMatrix[rng20] = a_state2_0; \
        lMatrix[rng21] = a_state2_1; \
        lMatrix[rng22] = a_state2_2; \
        lMatrix[rng20] ^= ((lIdx&3) == 0)?a_state1_2:a_state1_0; \
        lMatrix[rng21] ^= ((lIdx&3) == 0)?a_state1_0:a_state1_1; \
        lMatrix[rng22] ^= ((lIdx&3) == 0)?a_state1_1:a_state1_2; \
    } \
    if(rowa == 3) \
    { \
        lMatrix[rng30] = a_state2_0; \
        lMatrix[rng31] = a_state2_1; \
        lMatrix[rng32] = a_state2_2; \
        lMatrix[rng30] ^= ((lIdx&3) == 0)?a_state1_2:a_state1_0; \
        lMatrix[rng31] ^= ((lIdx&3) == 0)?a_state1_0:a_state1_1; \
        lMatrix[rng32] ^= ((lIdx&3) == 0)?a_state1_1:a_state1_2; \
    } \
 \
    lMatrix[rou00] ^= state[0]; \
    lMatrix[rou01] ^= state[1]; \
    lMatrix[rou02] ^= state[2]; \
}


#define wanderIterationP2(rin00,rin01,rin02, rng00,rng01,rng02, rng10,rng11,rng12, rng20,rng21,rng22, rng30,rng31,rng32) \
{ \
    t0 = lMatrix[rin00]; \
    b0 = (rowa < 2)? lMatrix[rng00]: lMatrix[rng20]; \
    b1 = (rowa < 2)? lMatrix[rng10]: lMatrix[rng30]; \
    c0 = ((rowa & 0x1U) < 1)? b0: b1; \
    t0 += c0; \
    state[0] ^= t0; \
 \
    t0 = lMatrix[rin01]; \
    b0 = (rowa < 2)? lMatrix[rng01]: lMatrix[rng21]; \
    b1 = (rowa < 2)? lMatrix[rng11]: lMatrix[rng31]; \
    c0 = ((rowa & 0x1U) < 1)? b0: b1; \
    t0 += c0; \
    state[1] ^= t0; \
 \
    t0 = lMatrix[rin02]; \
    b0 = (rowa < 2)? lMatrix[rng02]: lMatrix[rng22]; \
    b1 = (rowa < 2)? lMatrix[rng12]: lMatrix[rng32]; \
    c0 = ((rowa & 0x1U) < 1)? b0: b1; \
    t0 += c0; \
    state[2] ^= t0; \
 \
    roundLyra_sm(state); \
}
