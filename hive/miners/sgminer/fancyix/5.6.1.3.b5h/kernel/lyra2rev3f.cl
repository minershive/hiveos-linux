/*
 * Lyra2RE kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 * Copyright (c) CryptoGraphics ( CrGraphics@protonmail.com )
 * Copyright (c) 2019 fancyIX
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
 * @author   CryptoGraphics ( CrGraphics@protonmail.com )
 * @author   fancyIX 2019
 */

#include "lyra2v3lyf.cl"

#define MAX_GLOBAL_THREADS 16777216

typedef union
{
    uint h[32];
    ulong h2[16];
    uint4 h4[8];
    ulong4 h8[4];
} LyraState;

// lyra2v3 p2
__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void search2(__global uint* lyraStates)
{
    int gid = ((get_global_id(0) >> 2) % MAX_GLOBAL_THREADS);
    __global LyraState *lyraState = (__global LyraState *)(lyraStates + (32* (gid)));

    ulong state[4];
    ulong ttr;
    
    uint lIdx = (uint)get_local_id(0);
    uint gr4 = ((lIdx >> 2) << 2);
    
    //-------------------------------------
    // Load Lyra state
    state[0] = (ulong)(lyraState->h2[(lIdx & 3)]);
    state[1] = (ulong)(lyraState->h2[(lIdx & 3)+4]);
    state[2] = (ulong)(lyraState->h2[(lIdx & 3)+8]);
    state[3] = (ulong)(lyraState->h2[(lIdx & 3)+12]);

    //-------------------------------------
    ulong lMatrix[48];
    ulong state0[12];
    ulong state1[12];
    
    //------------------------------------
    // loop 1
    {
        state0[ 9] = state[0];
        state0[10] = state[1];
        state0[11] = state[2];
        
        roundLyra_sm(state);

        state0[6] = state[0];
        state0[7] = state[1];
        state0[8] = state[2];
        
        roundLyra_sm(state);
        
        state0[3] = state[0];
        state0[4] = state[1];
        state0[5] = state[2];
        
        roundLyra_sm(state);
        
        state0[0] = state[0];
        state0[1] = state[1];
        state0[2] = state[2];
        
        roundLyra_sm(state);
    }
    
    //------------------------------------
    // loop 2
    {
        state[0] ^= state0[0];
        state[1] ^= state0[1];
        state[2] ^= state0[2];
        roundLyra_sm(state);
        state1[ 9] = state0[0] ^ state[0];
        state1[10] = state0[1] ^ state[1];
        state1[11] = state0[2] ^ state[2];
        
        state[0] ^= state0[3];
        state[1] ^= state0[4];
        state[2] ^= state0[5];
        roundLyra_sm(state);
        state1[6] = state0[3] ^ state[0];
        state1[7] = state0[4] ^ state[1];
        state1[8] = state0[5] ^ state[2];
        
        state[0] ^= state0[6];
        state[1] ^= state0[7];
        state[2] ^= state0[8];
        roundLyra_sm(state);
        state1[3] = state0[6] ^ state[0];
        state1[4] = state0[7] ^ state[1];
        state1[5] = state0[8] ^ state[2];
        
        state[0] ^= state0[ 9];
        state[1] ^= state0[10];
        state[2] ^= state0[11];
        roundLyra_sm(state);
        state1[0] = state0[ 9] ^ state[0];
        state1[1] = state0[10] ^ state[1];
        state1[2] = state0[11] ^ state[2];
    }

    ulong state2[3];
    ulong t0,c0;
    loop3p1_iteration(0, 1, 2, 33,34,35);
    loop3p1_iteration(3, 4, 5, 30,31,32);
    loop3p1_iteration(6, 7, 8, 27,28,29);
    loop3p1_iteration(9,10,11, 24,25,26);

    loop3p2_iteration(0, 1, 2, 9,10,11, 45,46,47, 12,13,14);
    loop3p2_iteration(3, 4, 5, 6, 7, 8, 42,43,44, 15,16,17);
    loop3p2_iteration(6, 7, 8, 3, 4, 5, 39,40,41, 18,19,20);
    loop3p2_iteration(9,10,11, 0, 1, 2, 36,37,38, 21,22,23);
 
    ulong a_state1_0, a_state1_1, a_state1_2;
    ulong a_state2_0, a_state2_1, a_state2_2;
    ulong b0,b1;

    //------------------------------------
    // Wandering phase part 1
    uint rowa, index, sid, lid;
    BROADCAST_0(index, ((uint) state[0]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;

    wanderIteration(36,37,38, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 0, 1, 2);
    wanderIteration(39,40,41, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 3, 4, 5);
    wanderIteration(42,43,44, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 6, 7, 8);
    wanderIteration(45,46,47, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 9,10,11);

    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(index, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(index, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(index, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(index, lid, ((uint) state[3]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;
    
    wanderIteration(0, 1, 2, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 12,13,14);
    wanderIteration(3, 4, 5, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 15,16,17);
    wanderIteration(6, 7, 8, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 18,19,20);
    wanderIteration(9,10,11, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 21,22,23);

    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(index, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(index, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(index, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(index, lid, ((uint) state[3]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;
    
    wanderIteration(12,13,14, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 24,25,26);
    wanderIteration(15,16,17, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 27,28,29);
    wanderIteration(18,19,20, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 30,31,32);
    wanderIteration(21,22,23, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 33,34,35);

    //------------------------------------
    // Wandering phase part 2 (last iteration)
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(index, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(index, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(index, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(index, lid, ((uint) state[3]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;

    ulong last[3];

    b0 = (rowa < 2)? lMatrix[0]: lMatrix[24];
    b1 = (rowa < 2)? lMatrix[12]: lMatrix[36];
    last[0] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[1]: lMatrix[25];
    b1 = (rowa < 2)? lMatrix[13]: lMatrix[37];
    last[1] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[2]: lMatrix[26];
    b1 = (rowa < 2)? lMatrix[14]: lMatrix[38];
    last[2] = ((rowa & 0x1U) < 1)? b0: b1;


    t0 = lMatrix[24];
    c0 = last[0] + t0;
    state[0] ^= c0;
    
    t0 = lMatrix[25];
    c0 = last[1] + t0;
    state[1] ^= c0;
    
    t0 = lMatrix[26];
    c0 = last[2] + t0;
    state[2] ^= c0;

    roundLyra_sm_ext(state);
   
    ulong Data0, Data1, Data2;
    SHUFFLE_D_0(Data, state);
    if((lIdx&3) == 0)
    {
        last[1] ^= Data0;
        last[2] ^= Data1;
        last[0] ^= Data2;
    }
    else
    {
        last[0] ^= Data0;
        last[1] ^= Data1;
        last[2] ^= Data2;
    }

    if(rowa == 3)
    {
        last[0] ^= state[0];
        last[1] ^= state[1];
        last[2] ^= state[2];
    }

    wanderIterationP2(27,28,29, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41);
    wanderIterationP2(30,31,32, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44);
    wanderIterationP2(33,34,35, 9,10,11, 21,22,23, 33,34,35, 45,46,47);

    state[0] ^= last[0];
    state[1] ^= last[1];
    state[2] ^= last[2];

    //-------------------------------------
    // save lyra state    
    lyraState->h2[(lIdx & 3)] = state[0];
    lyraState->h2[(lIdx & 3)+4] = state[1];
    lyraState->h2[(lIdx & 3)+8] = state[2];
    lyraState->h2[(lIdx & 3)+12] = state[3];
    
    barrier(CLK_GLOBAL_MEM_FENCE);
}

// lyra2v3 p2
__attribute__((reqd_work_group_size(64, 1, 1)))
__kernel void search6(__global uint* lyraStates)
{
    int gid = ((get_global_id(0) >> 2) % MAX_GLOBAL_THREADS);
    __global LyraState *lyraState = (__global LyraState *)(lyraStates + (32* (gid)));

    ulong state[4];
    ulong ttr;
    
    uint lIdx = (uint)get_local_id(0);
    uint gr4 = ((lIdx >> 2) << 2);
    
    //-------------------------------------
    // Load Lyra state
    state[0] = (ulong)(lyraState->h2[(lIdx & 3)]);
    state[1] = (ulong)(lyraState->h2[(lIdx & 3)+4]);
    state[2] = (ulong)(lyraState->h2[(lIdx & 3)+8]);
    state[3] = (ulong)(lyraState->h2[(lIdx & 3)+12]);

    //-------------------------------------
    ulong lMatrix[48];
    ulong state0[12];
    ulong state1[12];
    
    //------------------------------------
    // loop 1
    {
        state0[ 9] = state[0];
        state0[10] = state[1];
        state0[11] = state[2];
        
        roundLyra_sm(state);

        state0[6] = state[0];
        state0[7] = state[1];
        state0[8] = state[2];
        
        roundLyra_sm(state);
        
        state0[3] = state[0];
        state0[4] = state[1];
        state0[5] = state[2];
        
        roundLyra_sm(state);
        
        state0[0] = state[0];
        state0[1] = state[1];
        state0[2] = state[2];
        
        roundLyra_sm(state);
    }
    
    //------------------------------------
    // loop 2
    {
        state[0] ^= state0[0];
        state[1] ^= state0[1];
        state[2] ^= state0[2];
        roundLyra_sm(state);
        state1[ 9] = state0[0] ^ state[0];
        state1[10] = state0[1] ^ state[1];
        state1[11] = state0[2] ^ state[2];
        
        state[0] ^= state0[3];
        state[1] ^= state0[4];
        state[2] ^= state0[5];
        roundLyra_sm(state);
        state1[6] = state0[3] ^ state[0];
        state1[7] = state0[4] ^ state[1];
        state1[8] = state0[5] ^ state[2];
        
        state[0] ^= state0[6];
        state[1] ^= state0[7];
        state[2] ^= state0[8];
        roundLyra_sm(state);
        state1[3] = state0[6] ^ state[0];
        state1[4] = state0[7] ^ state[1];
        state1[5] = state0[8] ^ state[2];
        
        state[0] ^= state0[ 9];
        state[1] ^= state0[10];
        state[2] ^= state0[11];
        roundLyra_sm(state);
        state1[0] = state0[ 9] ^ state[0];
        state1[1] = state0[10] ^ state[1];
        state1[2] = state0[11] ^ state[2];
    }

    ulong state2[3];
    ulong t0,c0;
    loop3p1_iteration(0, 1, 2, 33,34,35);
    loop3p1_iteration(3, 4, 5, 30,31,32);
    loop3p1_iteration(6, 7, 8, 27,28,29);
    loop3p1_iteration(9,10,11, 24,25,26);

    loop3p2_iteration(0, 1, 2, 9,10,11, 45,46,47, 12,13,14);
    loop3p2_iteration(3, 4, 5, 6, 7, 8, 42,43,44, 15,16,17);
    loop3p2_iteration(6, 7, 8, 3, 4, 5, 39,40,41, 18,19,20);
    loop3p2_iteration(9,10,11, 0, 1, 2, 36,37,38, 21,22,23);
 
    ulong a_state1_0, a_state1_1, a_state1_2;
    ulong a_state2_0, a_state2_1, a_state2_2;
    ulong b0,b1;

    //------------------------------------
    // Wandering phase part 1
    uint rowa, index, sid, lid;
    BROADCAST_0(index, ((uint) state[0]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;

    wanderIteration(36,37,38, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 0, 1, 2);
    wanderIteration(39,40,41, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 3, 4, 5);
    wanderIteration(42,43,44, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 6, 7, 8);
    wanderIteration(45,46,47, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 9,10,11);

    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(index, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(index, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(index, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(index, lid, ((uint) state[3]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;
    
    wanderIteration(0, 1, 2, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 12,13,14);
    wanderIteration(3, 4, 5, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 15,16,17);
    wanderIteration(6, 7, 8, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 18,19,20);
    wanderIteration(9,10,11, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 21,22,23);

    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(index, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(index, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(index, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(index, lid, ((uint) state[3]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;
    
    wanderIteration(12,13,14, 0, 1, 2, 12,13,14, 24,25,26, 36,37,38, 24,25,26);
    wanderIteration(15,16,17, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41, 27,28,29);
    wanderIteration(18,19,20, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44, 30,31,32);
    wanderIteration(21,22,23, 9,10,11, 21,22,23, 33,34,35, 45,46,47, 33,34,35);

    //------------------------------------
    // Wandering phase part 2 (last iteration)
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(index, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(index, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(index, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(index, lid, ((uint) state[3]));
    sid = ((index >> 2) & 0x3);
    lid = ((gr4 + (index & 3)) << 2);
    if (sid == 0) BROADCAST_L_0(rowa, lid, ((uint) state[0]));
    if (sid == 1) BROADCAST_L_0(rowa, lid, ((uint) state[1]));
    if (sid == 2) BROADCAST_L_0(rowa, lid, ((uint) state[2]));
    if (sid == 3) BROADCAST_L_0(rowa, lid, ((uint) state[3]));
    rowa &= 0x3;

    ulong last[3];

    b0 = (rowa < 2)? lMatrix[0]: lMatrix[24];
    b1 = (rowa < 2)? lMatrix[12]: lMatrix[36];
    last[0] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[1]: lMatrix[25];
    b1 = (rowa < 2)? lMatrix[13]: lMatrix[37];
    last[1] = ((rowa & 0x1U) < 1)? b0: b1;

    b0 = (rowa < 2)? lMatrix[2]: lMatrix[26];
    b1 = (rowa < 2)? lMatrix[14]: lMatrix[38];
    last[2] = ((rowa & 0x1U) < 1)? b0: b1;


    t0 = lMatrix[24];
    c0 = last[0] + t0;
    state[0] ^= c0;
    
    t0 = lMatrix[25];
    c0 = last[1] + t0;
    state[1] ^= c0;
    
    t0 = lMatrix[26];
    c0 = last[2] + t0;
    state[2] ^= c0;

    roundLyra_sm_ext(state);
   
    ulong Data0, Data1, Data2;
    SHUFFLE_D_0(Data, state);
    if((lIdx&3) == 0)
    {
        last[1] ^= Data0;
        last[2] ^= Data1;
        last[0] ^= Data2;
    }
    else
    {
        last[0] ^= Data0;
        last[1] ^= Data1;
        last[2] ^= Data2;
    }

    if(rowa == 3)
    {
        last[0] ^= state[0];
        last[1] ^= state[1];
        last[2] ^= state[2];
    }

    wanderIterationP2(27,28,29, 3, 4, 5, 15,16,17, 27,28,29, 39,40,41);
    wanderIterationP2(30,31,32, 6, 7, 8, 18,19,20, 30,31,32, 42,43,44);
    wanderIterationP2(33,34,35, 9,10,11, 21,22,23, 33,34,35, 45,46,47);

    state[0] ^= last[0];
    state[1] ^= last[1];
    state[2] ^= last[2];

    //-------------------------------------
    // save lyra state    
    lyraState->h2[(lIdx & 3)] = state[0];
    lyraState->h2[(lIdx & 3)+4] = state[1];
    lyraState->h2[(lIdx & 3)+8] = state[2];
    lyraState->h2[(lIdx & 3)+12] = state[3];
    
    barrier(CLK_GLOBAL_MEM_FENCE);
}