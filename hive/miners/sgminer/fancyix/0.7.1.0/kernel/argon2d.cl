/*
 * Copyright (C) 2018-2019 Ehsan Dalvand <dalvand.ehsan@gmail.com>, Alireza Jahandideh <ar.jahandideh@gmail.com>
 *
 * This program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation: either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 

#define ARGON2_BLOCK_SIZE 1024
#define ARGON2_QWORDS_IN_BLOCK (ARGON2_BLOCK_SIZE / 8)
#define BLAKE2B_BLOCKBYTES 128
#define BLAKE2B_OUTBYTES 64
#define ARGON2_PREHASH_DIGEST_LENGTH 64
#define ARGON2_SYNC_POINTS 4
#define THREADS_PER_LANE 32
#define QWORDS_PER_THREAD (ARGON2_QWORDS_IN_BLOCK / 32)
#define ALGO_VERSION 0x10
 
enum algo_params {
    ALGO_LANES = 8,
    ALGO_MCOST = 500,
    ALGO_PASSES = 2,
    ALGO_OUTLEN = 32,
    ALGO_TOTAL_BLOCKS = (ALGO_MCOST / (4 * ALGO_LANES)) * 4 * ALGO_LANES,
    ALGO_LANE_LENGHT = ALGO_TOTAL_BLOCKS / ALGO_LANES,
    ALGO_SEGMENT_BLOCKS = ALGO_LANE_LENGHT / 4
};

typedef unsigned int uint32_t;
typedef unsigned long uint64_t;
typedef unsigned char uint8_t;

struct block {
    uint64_t v[ARGON2_QWORDS_IN_BLOCK];
};
struct partialState {
    uint64_t a, b;
};
struct uint64x8{
    uint64_t s0,s1,s2,s3,s4,s5,s6,s7;
};

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)

__constant uint64_t blake2b_Init[8] =
{
    0x6A09E667F2BDC948,0xBB67AE8584CAA73B,
    0x3C6EF372FE94F82B,0xA54FF53A5F1D36F1,
    0x510E527FADE682D1,0x9B05688C2B3E6C1F,
    0x1F83D9ABFB41BD6B,0x5BE0CD19137E2179
};
__constant uint64_t blake2b_IV[8] =
{
    7640891576956012808,13503953896175478587,
    4354685564936845355,11912009170470909681,
    5840696475078001361,11170449401992604703,
    2270897969802886507,6620516959819538809
};
__constant uint64_t sigma[12][2]=
{
    {506097522914230528,1084818905618843912},
    {436021270388410894,217587900856929281},
    {940973067642603531,290764780619369994},
    {1011915791265892615,580682894302053890},
    {1083683067090239497,937601969488068878},
    {218436676723543042,648815278989708548},
    {721716194318550284,794887571959580416},
    {649363922558061325,721145521830297605},
    {576464098234863366,363107122416517644},
    {360576072368521738,3672381957147407},
    {506097522914230528,1084818905618843912},
    {436021270388410894,217587900856929281}, 
};

__constant uint64_t blake2b_Init_928[8] =
{
    0x6A09E667F2BDC928,0xBB67AE8584CAA73B,
    0x3C6EF372FE94F82B,0xA54FF53A5F1D36F1,
    0x510E527FADE682D1,0x9B05688C2B3E6C1F,
    0x1F83D9ABFB41BD6B,0x5BE0CD19137E2179
};
#define initState(a) {\
    a[0]=0x6A09E667F2BDC948;\
    a[1]=0xBB67AE8584CAA73B;\
    a[2]=0x3C6EF372FE94F82B;\
    a[3]=0xA54FF53A5F1D36F1;\
    a[4]=0x510E527FADE682D1;\
    a[5]=0x9B05688C2B3E6C1F;\
    a[6]=0x1F83D9ABFB41BD6B;\
    a[7]=0x5BE0CD19137E2179;\
}

#define G(a,b,c,d,x,col) { \
    ref1=sigma[r][col]>>16*x;\
    ref2=sigma[r][col]>>(16*x+8);\
    v[a] += v[b]+upsample(m[ref1*2+1], m[ref1*2]); \
    v[d] = rotate64(v[d] ^ v[a],32); \
    v[c] += v[d]; \
    v[b] = rotate64(v[b] ^ v[c], 24); \
    v[a] +=v[b]+upsample(m[ref2*2+1], m[ref2*2]); \
    v[d] = rotate64( v[d] ^ v[a], 16); \
    v[c] += v[d]; \
    v[b] = rotate64( v[b] ^ v[c], 63); \
}

#define G_loop(a,b,c,d,x,col) { \
    ref1=sigma[r][col]>>16*x; \
    ref2=sigma[r][col]>>(16*x+8); \
    ref1=ref1&7; \
    ref2=ref2&7; \
    v[a] += v[b]+state[ref1]; \
    v[d] = rotate64(v[d] ^ v[a],32); \
    v[c] += v[d]; \
    v[b] = rotate64(v[b] ^ v[c], 24); \
    v[a] +=v[b]+state[ref2]; \
    v[d] = rotate64( v[d] ^ v[a], 16); \
    v[c] += v[d]; \
    v[b] = rotate64( v[b] ^ v[c], 63); \
}
ulong u64_build(uint hi, uint lo)
{
    return upsample(hi, lo);
}

uint u64_lo(ulong x)
{
    return (uint)x;
}

uint u64_hi(ulong x)
{
    return (uint)(x >> 32);
}
void zero_buffer( __local uint32_t* buffer, const uint32_t idx){
    buffer[idx] =0;
    buffer[idx+4] =0;
    buffer[idx+8] =0;
    buffer[idx+12]=0;
    buffer[idx+16]  =0;
    buffer[idx+20] =0;
    buffer[idx+24] =0;
    buffer[idx+28]=0;
}


void enc32( void *pp, const uint32_t x)
{
    uint8_t *p = ( uint8_t *)pp;
    
    p[3] = x & 0xff;
    p[2] = (x >> 8) & 0xff;
    p[1] = (x >> 16) & 0xff;
    p[0] = (x >> 24) & 0xff;
}

uint64_t rotate64( uint64_t x, const uint32_t n)
{
    return (x >> n) | (x << (64 - n));
}
void blake2b_compress_loop_1w(  uint64_t* restrict state,__global struct block* memCell)
{
    uint64_t v[16];
    uint64_t s[8];
    
    s[0]=state[0];
    s[1]=state[1];
    s[2]=state[2];
    s[3]=state[3];
    s[4]=state[4];
    s[5]=state[5];
    s[6]=state[6];
    s[7]=state[7];
    
    for (int i=1;i<31;i++){
        initState(v);
    
    v[8]  = blake2b_IV[0];
    v[9]  = blake2b_IV[1];
    v[10] = blake2b_IV[2];
    v[11] = blake2b_IV[3];
    v[12] = blake2b_IV[4] ^ 64;
    v[13] = blake2b_IV[5];
    v[14] = blake2b_IV[6] ^(uint64_t) -1;
    v[15] = blake2b_IV[7];
    
    v[0] += v[4]+s[0];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4]+s[1];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[2];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5]+s[3];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6]+s[4];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[5];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7]+s[6];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7]+s[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    
    v[1] += v[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[4];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7]+s[6];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5]+s[1];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6]+s[0];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[2];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4]+s[5];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4]+s[3];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5]+s[0];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6]+s[5];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[2];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6]+s[3];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[6];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    
    v[2] += v[7]+s[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[1];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4]+s[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4]+s[7];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[3];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5]+s[1];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    
    v[0] += v[5]+s[2];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5]+s[6];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    
    v[1] += v[6]+s[5];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    
    v[2] += v[7]+s[4];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[0];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4]+s[0];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[5];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5]+s[7];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6]+s[2];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[4];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5]+s[1];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7]+s[6];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4]+s[3];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4]+s[2];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[6];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6]+s[0];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7]+s[3];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5]+s[4];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    
    v[1] += v[6]+s[7];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[5];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4]+s[1];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4]+s[5];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[1];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7]+s[4];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5]+s[0];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5]+s[7];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6]+s[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[3];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[2];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[7];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[1];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7]+s[3];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5]+s[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5]+s[0];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[4];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[6];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4]+s[2];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4]+s[6];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[3];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7]+s[0];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5]+s[2];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[7];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7]+s[1];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[4];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4]+s[5];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4]+s[2];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5]+s[4];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6]+s[7];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[6];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7]+s[1];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7]+s[5];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7]+s[3];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4]+s[0];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4]+s[0];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4]+s[1];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[2];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5]+s[3];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6]+s[4];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6]+s[5];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7]+s[6];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7]+s[7];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    
    v[0] += v[4];
    v[12] = rotate64(v[12] ^ v[0],32);
    v[8] += v[12];
    v[4] = rotate64(v[4] ^ v[8], 24);
    v[0] +=v[4];
    v[12] = rotate64( v[12] ^ v[0], 16);
    v[8] += v[12];
    v[4] = rotate64( v[4] ^ v[8], 63);
    
    
    v[1] += v[5]+s[4];
    v[13] = rotate64(v[13] ^ v[1],32);
    v[9] += v[13];
    v[5] = rotate64(v[5] ^ v[9], 24);
    v[1] +=v[5];
    v[13] = rotate64( v[13] ^ v[1], 16);
    v[9] += v[13];
    v[5] = rotate64( v[5] ^ v[9], 63);
    
    
    v[2] += v[6];
    v[14] = rotate64(v[14] ^ v[2],32);
    v[10] += v[14];
    v[6] = rotate64(v[6] ^ v[10], 24);
    v[2] +=v[6];
    v[14] = rotate64( v[14] ^ v[2], 16);
    v[10] += v[14];
    v[6] = rotate64( v[6] ^ v[10], 63);
    
            
    v[3] += v[7];
    v[15] = rotate64(v[15] ^ v[3],32);
    v[11] += v[15];
    v[7] = rotate64(v[7] ^ v[11], 24);
    v[3] +=v[7]+s[6];
    v[15] = rotate64( v[15] ^ v[3], 16);
    v[11] += v[15];
    v[7] = rotate64( v[7] ^ v[11], 63);
    
    
    v[0] += v[5]+s[1];
    v[15] = rotate64(v[15] ^ v[0],32);
    v[10] += v[15];
    v[5] = rotate64(v[5] ^ v[10], 24);
    v[0] +=v[5];
    v[15] = rotate64( v[15] ^ v[0], 16);
    v[10] += v[15];
    v[5] = rotate64( v[5] ^ v[10], 63);
    
    
    v[1] += v[6]+s[0];
    v[12] = rotate64(v[12] ^ v[1],32);
    v[11] += v[12];
    v[6] = rotate64(v[6] ^ v[11], 24);
    v[1] +=v[6]+s[2];
    v[12] = rotate64( v[12] ^ v[1], 16);
    v[11] += v[12];
    v[6] = rotate64( v[6] ^ v[11], 63);
    
    
    v[2] += v[7];
    v[13] = rotate64(v[13] ^ v[2],32);
    v[8] += v[13];
    v[7] = rotate64(v[7] ^ v[8], 24);
    v[2] +=v[7]+s[7];
    v[13] = rotate64( v[13] ^ v[2], 16);
    v[8] += v[13];
    v[7] = rotate64( v[7] ^ v[8], 63);
    
    
    v[3] += v[4]+s[5];
    v[14] = rotate64(v[14] ^ v[3],32);
    v[9] += v[14];
    v[4] = rotate64(v[4] ^ v[9], 24);
    v[3] +=v[4]+s[3];
    v[14] = rotate64( v[14] ^ v[3], 16);
    v[9] += v[14];
    v[4] = rotate64( v[4] ^ v[9], 63);
    
    s[0] = blake2b_Init[0] ^ v[0] ^ v[8];
    s[1] = blake2b_Init[1] ^ v[1] ^ v[9];
    s[2] = blake2b_Init[2] ^ v[2] ^ v[10];
    s[3] = blake2b_Init[3] ^ v[3] ^ v[11];
    s[4] = blake2b_Init[4] ^ v[4] ^ v[12];
    s[5] = blake2b_Init[5] ^ v[5] ^ v[13];
    s[6] = blake2b_Init[6] ^ v[6] ^ v[14];
    s[7] = blake2b_Init[7] ^ v[7] ^ v[15];
    
    #pragma unroll
    for (int j=0;j<4;j++)
            memCell->v[j+i*4]=s[j];
    }
    
    for (int i=0;i<4;i++)
        memCell->v[i+124]=s[i+4];   

}

void blake2b_compress_1w(
    uint64_t* state,
    const uint32_t* m,
    const uint32_t step,
    const bool lastChunk,
    const size_t lastChunkSize)
{
    uint64_t v[16];
    
    v[0] = state[0];
    v[1] = state[1];
    v[2] = state[2];
    v[3] = state[3];
    v[4] = state[4];
    v[5] = state[5];
    v[6] = state[6];
    v[7] = state[7];
    v[8] = blake2b_IV[0];
    v[9] = blake2b_IV[1];
    v[10] = blake2b_IV[2];
    v[11] = blake2b_IV[3];
    
    if (lastChunk){
        v[12]= blake2b_IV[4] ^ (step-1)*BLAKE2B_BLOCKBYTES+lastChunkSize;
        v[14]= blake2b_IV[6] ^(uint64_t) -1;
    }else{
        v[12]= blake2b_IV[4] ^ step*BLAKE2B_BLOCKBYTES;
        v[14]= blake2b_IV[6];
    }
    v[13]= blake2b_IV[5];
    v[15]= blake2b_IV[7];
    
    #pragma unroll
    for(int r=0; r < 12; r++)
    {
        uint8_t ref1,ref2;
    
        G( 0, 4,  8, 12, 0, 0 );
        G( 1, 5,  9, 13, 1, 0 );
        G( 2, 6, 10, 14, 2, 0 );
        G( 3, 7, 11, 15, 3, 0 );
        G( 0, 5, 10, 15, 0, 1 );
        G( 1, 6, 11, 12, 1, 1 );
        G( 2, 7,  8, 13, 2, 1 );
        G( 3, 4,  9, 14, 3, 1 );
    }
    state[0] ^= v[0] ^ v[8];
    state[1] ^= v[1] ^ v[9];
    state[2] ^= v[2] ^ v[10];
    state[3] ^= v[3] ^ v[11];
    state[4] ^= v[4] ^ v[12];
    state[5] ^= v[5] ^ v[13];
    state[6] ^= v[6] ^ v[14];
    state[7] ^= v[7] ^ v[15];
}

void computeInitialHash(
    __global const uint32_t* input,
    uint32_t* buffer, const uint32_t nonce)
{
    uint64_t state[8];
    initState(state);
    for (int i=0;i<16;i++)
        buffer[i]=0;

    buffer[0] = ALGO_LANES;
    buffer[1] = ALGO_OUTLEN;
    buffer[2] = ALGO_MCOST;
    buffer[3] = ALGO_PASSES;
    buffer[4] = ALGO_VERSION;
    buffer[6] = 80;
    
    for (int i=0;i<19;i++)
        buffer[7+i]=input[i];
    buffer[26] = nonce;
    buffer[27] = 80;
    for (int i=0;i<4;i++)
        buffer[28+i]=input[i];
    blake2b_compress_1w( state, buffer, 1, false, 72);
    for (int i=0;i<15;i++)
        buffer[i]=input[i+4];
    buffer[15] = nonce;
    for (int i=16;i<32;i++)
        buffer[i]=0;
    blake2b_compress_1w( state, buffer, 2, true, 72);
    for (int i=0;i<16;i++)
        buffer[i+1]=((uint32_t*)state)[i];
}
void fillFirstBlock(
    __global struct block* memory, 
    uint32_t* buffer)
{
    const uint32_t idx      = get_local_id(0);
    const uint32_t jobID    = get_group_id(1)*get_local_size(1)+get_local_id(1);
    uint32_t row            = idx / ALGO_LANES; 
    uint32_t column         = idx % ALGO_LANES; 
    __global struct block* memCell = memory + jobID * ALGO_TOTAL_BLOCKS + row * ALGO_LANES + column;
    uint64_t state[8];
    initState(state);
    buffer[0]=1024;
    buffer[17] = row;
    buffer[18] = column;
    blake2b_compress_1w( state, buffer, 1, true, 76);
    #pragma unroll
    for (int j=0;j<4;j++)
        memCell->v[j]=state[j];
blake2b_compress_loop_1w(state,memCell);
}

__attribute__((reqd_work_group_size(16, 16, 1)))
__kernel void search(
    __global struct block* memory, 
    __global uint32_t* input,
    const uint startNonce)
{
    const uint32_t idx      = get_local_id(0);
    uint32_t jobId          = get_group_id(1)*get_local_size(1)+get_local_id(1);
    const uint32_t nonce = jobId + startNonce;
    uint32_t buffer[32];
    computeInitialHash( input, buffer, nonce);
    fillFirstBlock(memory, buffer);
}

struct u64_shuffle_buf {
    uint lo[THREADS_PER_LANE];
    uint hi[THREADS_PER_LANE];
};
ulong u64_shuffle(ulong v, uint thread_src, uint thread,
                  __local struct u64_shuffle_buf *buf)
{
    uint lo = u64_lo(v);
    uint hi = u64_hi(v);
    buf->lo[thread] = lo;
    buf->hi[thread] = hi;
    barrier(CLK_LOCAL_MEM_FENCE);
    lo = buf->lo[thread_src];
    hi = buf->hi[thread_src];
    return u64_build(hi, lo);
}
struct block_g {
    ulong data[ARGON2_QWORDS_IN_BLOCK];
};
struct block_th {
    ulong a, b, c, d;
};
ulong cmpeq_mask(uint test, uint ref)
{
    uint x = -(uint)(test == ref);
    return u64_build(x, x);
}
ulong block_th_get(const struct block_th *b, uint idx)
{
    ulong res = 0;
    res ^= cmpeq_mask(idx, 0) & b->a;
    res ^= cmpeq_mask(idx, 1) & b->b;
    res ^= cmpeq_mask(idx, 2) & b->c;
    res ^= cmpeq_mask(idx, 3) & b->d;
    return res;
}
void block_th_set(struct block_th *b, uint idx, ulong v)
{
    b->a ^= cmpeq_mask(idx, 0) & (v ^ b->a);
    b->b ^= cmpeq_mask(idx, 1) & (v ^ b->b);
    b->c ^= cmpeq_mask(idx, 2) & (v ^ b->c);
    b->d ^= cmpeq_mask(idx, 3) & (v ^ b->d);
}
void move_block(struct block_th *dst, const struct block_th *src)
{
    *dst = *src;
}
void xor_block(struct block_th *dst, const struct block_th *src)
{
    dst->a ^= src->a;
    dst->b ^= src->b;
    dst->c ^= src->c;
    dst->d ^= src->d;
}
void load_block(struct block_th *dst, __global const struct block_g *src,
                uint thread)
{
    dst->a = src->data[0 * THREADS_PER_LANE + thread];
    dst->b = src->data[1 * THREADS_PER_LANE + thread];
    dst->c = src->data[2 * THREADS_PER_LANE + thread];
    dst->d = src->data[3 * THREADS_PER_LANE + thread];
}
void load_block_xor(struct block_th *dst, __global const struct block_g *src,
                    uint thread)
{
    dst->a ^= src->data[0 * THREADS_PER_LANE + thread];
    dst->b ^= src->data[1 * THREADS_PER_LANE + thread];
    dst->c ^= src->data[2 * THREADS_PER_LANE + thread];
    dst->d ^= src->data[3 * THREADS_PER_LANE + thread];
}
void store_block(__global struct block_g *dst, const struct block_th *src,
                 uint thread)
{
    dst->data[0 * THREADS_PER_LANE + thread] = src->a;
    dst->data[1 * THREADS_PER_LANE + thread] = src->b;
    dst->data[2 * THREADS_PER_LANE + thread] = src->c;
    dst->data[3 * THREADS_PER_LANE + thread] = src->d;
}
#ifdef cl_amd_media_ops
#pragma OPENCL EXTENSION cl_amd_media_ops : enable
ulong rotr64(ulong x, ulong n)
{
    uint lo = u64_lo(x);
    uint hi = u64_hi(x);
    uint r_lo, r_hi;
    if (n < 32) {
        r_lo = amd_bitalign(hi, lo, (uint)n);
        r_hi = amd_bitalign(lo, hi, (uint)n);
    } else {
        r_lo = amd_bitalign(lo, hi, (uint)n - 32);
        r_hi = amd_bitalign(hi, lo, (uint)n - 32);
    }
    return u64_build(r_hi, r_lo);
}
#else
ulong rotr64(ulong x, ulong n)
{
    return rotate(x, 64 - n);
}
#endif
ulong f(ulong x, ulong y)
{
    uint xlo = u64_lo(x);
    uint ylo = u64_lo(y);
    return x + y + 2 * u64_build(mul_hi(xlo, ylo), xlo * ylo);
}
void g(struct block_th *block)
{
    ulong a, b, c, d;
    a = block->a;
    b = block->b;
    c = block->c;
    d = block->d;
    a = f(a, b);
    d = rotr64(d ^ a, 32);
    c = f(c, d);
    b = rotr64(b ^ c, 24);
    a = f(a, b);
    d = rotr64(d ^ a, 16);
    c = f(c, d);
    b = rotr64(b ^ c, 63);
    block->a = a;
    block->b = b;
    block->c = c;
    block->d = d;
}
uint apply_shuffle_shift1(uint thread, uint idx)
{
    return (thread & 0x1c) | ((thread + idx) & 0x3);
}
uint apply_shuffle_unshift1(uint thread, uint idx)
{
    idx = (QWORDS_PER_THREAD - idx) % QWORDS_PER_THREAD;
    return apply_shuffle_shift1(thread, idx);
}
uint apply_shuffle_shift2(uint thread, uint idx)
{
    uint lo = (thread & 0x1) | ((thread & 0x10) >> 3);
    lo = (lo + idx) & 0x3;
    return ((lo & 0x2) << 3) | (thread & 0xe) | (lo & 0x1);
}
uint apply_shuffle_unshift2(uint thread, uint idx)
{
    idx = (QWORDS_PER_THREAD - idx) % QWORDS_PER_THREAD;

    return apply_shuffle_shift2(thread, idx);
}
void shuffle_shift1(struct block_th *block, uint thread,
                    __local struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_shift1(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, buf);
        block_th_set(block, i, v);
    }
}
void shuffle_unshift1(struct block_th *block, uint thread,
                      __local struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_unshift1(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, buf);
        block_th_set(block, i, v);
    }
}
void shuffle_shift2(struct block_th *block, uint thread,
                    __local struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_shift2(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, buf);
        block_th_set(block, i, v);
    }
}
void shuffle_unshift2(struct block_th *block, uint thread,
                      __local struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_unshift2(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, buf);
        block_th_set(block, i, v);
    }
}
void transpose(struct block_th *block, uint thread,
               __local struct u64_shuffle_buf *buf)
{
    uint thread_group = (thread & 0x0C) >> 2;
    for (uint i = 1; i < QWORDS_PER_THREAD; i++) {
        uint thr = (i << 2) ^ thread;
        uint idx = thread_group ^ i;

        ulong v = block_th_get(block, idx);
        v = u64_shuffle(v, thr, thread, buf);
        block_th_set(block, idx, v);
    }
}
void shuffle_block(struct block_th *block, uint thread,
                   __local struct u64_shuffle_buf *buf)
{
    transpose(block, thread, buf);
    g(block);
    shuffle_shift1(block, thread, buf);
    g(block);
    shuffle_unshift1(block, thread, buf);
    transpose(block, thread, buf);
    g(block);
    shuffle_shift2(block, thread, buf);
    g(block);
    shuffle_unshift2(block, thread, buf);
}
void compute_ref_pos(uint lanes, uint segment_blocks,
                     uint pass, uint lane, uint slice, uint offset,
                     uint *ref_lane, uint *ref_index)
{
    uint lane_blocks = ARGON2_SYNC_POINTS * segment_blocks;
    *ref_lane = *ref_lane % lanes;
    uint base;
    if (pass != 0) {
        base = lane_blocks - segment_blocks;
    } else {
        if (slice == 0) {
            *ref_lane = lane;
        }
        base = slice * segment_blocks;
    }
    uint ref_area_size = base + offset - 1;
    if (*ref_lane != lane) {
        ref_area_size = min(ref_area_size, base);
    }
    *ref_index = mul_hi(*ref_index, *ref_index);
    *ref_index = ref_area_size - 1 - mul_hi(ref_area_size, *ref_index);
    if (pass != 0 && slice != ARGON2_SYNC_POINTS - 1) {
        *ref_index += (slice + 1) * segment_blocks;
        if (*ref_index >= lane_blocks) {
            *ref_index -= lane_blocks;
        }
    }
}
void argon2_core(
        __global struct block_g *memory, __global struct block_g *mem_curr,
        struct block_th *prev, struct block_th *tmp,
        __local struct u64_shuffle_buf *shuffle_buf, uint lanes,
        uint thread, uint pass, uint ref_index, uint ref_lane)
{
    __global struct block_g *mem_ref;
    mem_ref = memory + ref_index * lanes + ref_lane;

#if ALGO_VERSION == 0x10
    load_block_xor(prev, mem_ref, thread);
    move_block(tmp, prev);
#else
    if (pass != 0)
    {
        load_block(tmp, mem_curr, thread);
        load_block_xor(prev, mem_ref, thread);
        xor_block(tmp, prev);
    }
    else
    {
        load_block_xor(prev, mem_ref, thread);
        move_block(tmp, prev);
    }
#endif

    shuffle_block(prev, thread, shuffle_buf);
    xor_block(prev, tmp);
    store_block(mem_curr, prev, thread);
}
void argon2_step(
        __global struct block_g *memory, __global struct block_g *mem_curr,
        struct block_th *prev, struct block_th *tmp, struct block_th *addr,
        __local struct u64_shuffle_buf *shuffle_buf,
        uint lanes, uint segment_blocks, uint thread, uint *thread_input,
        uint lane, uint pass, uint slice, uint offset)
{
    uint ref_index, ref_lane;
    ulong v = u64_shuffle(prev->a, 0, thread, shuffle_buf);
    ref_index = u64_lo(v);
    ref_lane  = u64_hi(v);
    compute_ref_pos(lanes, segment_blocks, pass, lane, slice, offset,
                    &ref_lane, &ref_index);
    argon2_core(memory, mem_curr, prev, tmp, shuffle_buf, lanes, thread, pass,
                ref_index, ref_lane);
}

__attribute__((reqd_work_group_size(32 * 8, 1, 1)))
__kernel void search1(
        __global struct block_g *memory, uint passes, uint lanes,
        uint segment_blocks)
{
    __local char shuffle_bufs[32 * 8 * 1 * sizeof(uint32_t) * 2];
    uint job_id = get_global_id(1);
    uint lane   = get_global_id(0) / THREADS_PER_LANE;
    uint warp   = get_local_id(0) / THREADS_PER_LANE;
    uint thread = get_local_id(0) % THREADS_PER_LANE;
    __local struct u64_shuffle_buf *shuffle_buf = (__local struct u64_shuffle_buf *) &shuffle_bufs[warp * sizeof(struct u64_shuffle_buf)];
    uint lane_blocks = ARGON2_SYNC_POINTS * segment_blocks;
    memory += (size_t)job_id * lanes * lane_blocks;
    struct block_th prev, addr, tmp;
    uint thread_input;
    __global struct block_g *mem_lane = memory + lane;
    __global struct block_g *mem_prev = mem_lane + 1 * lanes;
    __global struct block_g *mem_curr = mem_lane + 2 * lanes;
    load_block(&prev, mem_prev, thread);
    uint skip = 2;
    for (uint pass = 0; pass < passes; ++pass) {
        for (uint slice = 0; slice < ARGON2_SYNC_POINTS; ++slice) {
            for (uint offset = 0; offset < segment_blocks; ++offset) {
                if (skip > 0) {
                    --skip;
                    continue;
                }
                argon2_step(memory, mem_curr, &prev, &tmp, &addr, shuffle_buf,
                            lanes, segment_blocks, thread, &thread_input,
                            lane, pass, slice, offset);
                mem_curr += lanes;
            }
            barrier(CLK_LOCAL_MEM_FENCE);
        }
        mem_curr = mem_lane;
    }
    
    __global uint* memLane = (__global uint*) ( memory + lanes * ( lane_blocks - 1 ) ) ; 

    thread = get_local_id(0);
    uint buf = 0;
    for (uint i=0; i<8; i++){
        buf ^= memLane[thread+256*i];
    }
    memLane[thread] = buf;
}
void g_shuffle(
    const uint32_t r, 
    __local uint64_t* a, 
    __local uint64_t* b, 
    __local uint64_t* c,
    __local uint64_t* d, 
    __local uint64_t* m1, 
    __local uint64_t* m2 )
{
    *a = *a + *b + *m1;
    *d = rotate64(*d ^ *a, 32);
    *c = *c + *d;
    *b = rotate64(*b ^ *c, 24);
    *a = *a + *b + *m2;
    *d = rotate64(*d ^ *a, 16);
    *c = *c + *d;
    *b = rotate64(*b ^ *c, 63);

}
void load_block_fin( __global uint32_t* block, __local uint32_t* buffer, uint32_t idx){
    uint32_t i,j;
    for(i=0;i<64;i++){
        j=idx+i*4;
        buffer[j]=block[j];
    }
}
void blake2b_compress_final(
    struct partialState* state, 
    __local uint64_t* m,
    __local uint64_t* buffer,
    uint32_t step,
    uint32_t idx)
{
    uint64_t counter=(idx==0?step:0);
    buffer[idx]     = state->a;
    buffer[idx+4]   = state->b;
    buffer[idx+8]   = blake2b_IV[idx];
    if(idx==0)
        buffer[idx+12] = blake2b_IV[4] ^ (step-1)*BLAKE2B_BLOCKBYTES+4;
    else if(idx==2)
        buffer[idx+12] = blake2b_IV[6] ^ (uint64_t) -1;
    else
        buffer[idx+12] = blake2b_IV[idx+4];
    barrier(CLK_LOCAL_MEM_FENCE);
    for (uint32_t r = 0; r < 12; ++r) {
        uint8_t ref1,ref2;
        ref1 = sigma[r][0]>>16*idx;
        ref2 = sigma[r][0]>>(16*idx+8);
        g_shuffle(r, &buffer[idx], &buffer[idx+4], &buffer[idx+8], &buffer[idx+12], &m[ref1],&m[ref2] );
        ref1=sigma[r][1]>>16*idx;
        ref2=sigma[r][1]>>(16*idx+8);
        g_shuffle(r, &buffer[idx], &buffer[(idx+1)%4 +4], &buffer[(idx+2)%4+8], &buffer[(idx+3)%4+12], &m[ref1],&m[ref2] );
    }
    state->a = state->a ^ buffer[idx] ^ buffer[idx+8];
    state->b = state->b ^ buffer[idx+4] ^ buffer[idx+12];
}
void blake2b_compress(
    struct partialState* state, 
    __local uint64_t* m,
    __local uint64_t* buffer,
    uint32_t step,
    uint32_t idx)
{
    uint64_t counter=(idx==0?step:0);
    buffer[idx]     = state->a;
    buffer[idx+4]   = state->b;
    buffer[idx+8]   = blake2b_IV[idx];
    buffer[idx+12] = blake2b_IV[idx+4]^ counter*BLAKE2B_BLOCKBYTES;
    barrier(CLK_LOCAL_MEM_FENCE);
    for (uint32_t r = 0; r < 12; ++r) {
        uint8_t ref1,ref2;
        ref1 = sigma[r][0]>>16*idx;
        ref2 = sigma[r][0]>>(16*idx+8);
        g_shuffle(r, &buffer[idx], &buffer[idx+4], &buffer[idx+8], &buffer[idx+12], &m[ref1],&m[ref2] );
        ref1=sigma[r][1]>>16*idx;
        ref2=sigma[r][1]>>(16*idx+8);
        g_shuffle(r, &buffer[idx], &buffer[(idx+1)%4 +4], &buffer[(idx+2)%4+8], &buffer[(idx+3)%4+12], &m[ref1],&m[ref2] );
    }
    state->a = state->a ^ buffer[idx] ^ buffer[idx+8];
    state->b = state->b ^ buffer[idx+4] ^ buffer[idx+12];
}

__attribute__((reqd_work_group_size(4, 8, 1)))
__kernel void search2(
    __global struct block* memory,
    __global uint32_t* output,
    const uint32_t startNonce,
    const uint32_t target

    )
{
    __local char smem[129 * sizeof(uint64_t) * 8 + 18 * sizeof(uint64_t) * 8];
    uint32_t idx            = get_local_id(0);
    uint32_t jobId          = get_group_id(1)*get_local_size(1)+get_local_id(1);
    const uint32_t nonce    = startNonce + jobId;

    __global uint32_t* memLane = (__global uint32_t*)((memory+jobId*ALGO_TOTAL_BLOCKS)+ALGO_LANES*(ALGO_LANE_LENGHT-1));
    __local uint64_t* input = (__local uint64_t*) &smem[129*get_local_id(1)*sizeof(uint64_t)];
    __local uint64_t* buffer= (__local uint64_t*) &smem[129*get_local_size(1)*sizeof(uint64_t)+get_local_id(1)*18*sizeof(uint64_t)];
    __local uint32_t* input_32 = (__local uint32_t*)input;
    
    load_block_fin(memLane,&input_32[1],idx);
    
    input_32[0]=32;
    struct partialState state;
    state.a = blake2b_Init_928[idx];
    state.b = blake2b_Init_928[idx+4];

    blake2b_compress(&state,&input[0],buffer,1,idx);
    blake2b_compress(&state,&input[16],buffer,2,idx);
    blake2b_compress(&state,&input[32],buffer,3,idx);
    blake2b_compress(&state,&input[48],buffer,4,idx);
    blake2b_compress(&state,&input[64],buffer,5,idx);
    blake2b_compress(&state,&input[80],buffer,6,idx);
    blake2b_compress(&state,&input[96],buffer,7,idx);
    blake2b_compress(&state,&input[112],buffer,8,idx);
    
    zero_buffer(&input_32[0], idx);
    input_32[0] = input_32[256];

    blake2b_compress_final(&state,&input[0],buffer,9,idx);

    barrier(CLK_LOCAL_MEM_FENCE);

    if ( ((uint*)&state.a)[1] <= target && idx==3) {
        uint32_t ret = SWAP4(nonce);
		 output[output[0xFF]++] = ret;
	}
}