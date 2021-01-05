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

uint2 __attribute__((overloadable)) amd_bitalign(uint2 src0, uint2 src1, uint src2)
{
	uint dstx = 0;
	uint dsty = 0;
    __asm ("v_alignbit_b32 %[dstx], %[src0x], %[src1x], %[src2x]\n"
          "v_alignbit_b32 %[dsty], %[src0y], %[src1y], %[src2y]"
          : [dstx] "=&v" (dstx), [dsty] "=&v" (dsty)
          : [src0x] "v" (src0.x), [src1x] "v" (src1.x), [src2x] "v" (src2),
		    [src0y] "v" (src0.y), [src1y] "v" (src1.y), [src2y] "v" (src2));
	return (uint2) (dstx, dsty);
}
uint2 __attribute__((overloadable)) amd_bytealign(uint2 src0, uint2 src1, uint src2)
{
	uint dstx = 0;
	uint dsty = 0;
    __asm ("v_alignbyte_b32 %[dstx], %[src0x], %[src1x], %[src2x]\n"
          "v_alignbyte_b32 %[dsty], %[src0y], %[src1y], %[src2y]"
          : [dstx] "=&v" (dstx), [dsty] "=&v" (dsty)
          : [src0x] "v" (src0.x), [src1x] "v" (src1.x), [src2x] "v" (src2),
		    [src0y] "v" (src0.y), [src1y] "v" (src1.y), [src2y] "v" (src2));
	return (uint2) (dstx, dsty);
}

inline ulong ROTR64(const ulong x2, const uint y)
{
	uint2 x = as_uint2(x2);
	if(y < 32) {
		if (y % 8 == 0)
		    return(as_ulong(amd_bytealign(x.s10, x, y / 8)));
		else
		    return(as_ulong(amd_bitalign(x.s10, x, y)));
	}
	else return(as_ulong(amd_bitalign(x, x.s10, (y - 32))));
}

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
    v[d] = ROTR64(v[d] ^ v[a],32); \
    v[c] += v[d]; \
    v[b] = ROTR64(v[b] ^ v[c], 24); \
    v[a] +=v[b]+upsample(m[ref2*2+1], m[ref2*2]); \
    v[d] = ROTR64( v[d] ^ v[a], 16); \
    v[c] += v[d]; \
    v[b] = ROTR64( v[b] ^ v[c], 63); \
}

#define G_loop(a,b,c,d,x,col) { \
    ref1=sigma[r][col]>>16*x; \
    ref2=sigma[r][col]>>(16*x+8); \
    ref1=ref1&7; \
    ref2=ref2&7; \
    v[a] += v[b]+state[ref1]; \
    v[d] = ROTR64(v[d] ^ v[a],32); \
    v[c] += v[d]; \
    v[b] = ROTR64(v[b] ^ v[c], 24); \
    v[a] +=v[b]+state[ref2]; \
    v[d] = ROTR64( v[d] ^ v[a], 16); \
    v[c] += v[d]; \
    v[b] = ROTR64( v[b] ^ v[c], 63); \
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


#define ARGON2D_SHFL(s0, s1, l)  \
    { \
		__asm ( \
		  "ds_bpermute_b32  %[os0], %[ol0], %[os0]\n" \
          "ds_bpermute_b32  %[os1], %[ol0], %[os1]\n" \
          "s_waitcnt lgkmcnt(0)\n" \
		  : [os0] "=&v" (s0), \
            [os1] "=&v" (s1) \
		  : [ol0] "v" (l), \
            [os0] "0" (s0), \
            [os1] "1" (s1)); \
	}

struct u64_shuffle_buf {
    uint lo[THREADS_PER_LANE];
    uint hi[THREADS_PER_LANE];
};
ulong u64_shuffle(ulong v, uint thread_src, uint thread, uint grp,
                  struct u64_shuffle_buf *buf)
{
    uint2 temp = as_uint2(v);
    uint lane_src = (thread_src + grp) << 2;
    ARGON2D_SHFL(temp.x, temp.y, lane_src);

    return as_ulong(temp);
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
    d = ROTR64(d ^ a, 32);
    c = f(c, d);
    b = ROTR64(b ^ c, 24);
    a = f(a, b);
    d = ROTR64(d ^ a, 16);
    c = f(c, d);
    b = ROTR64(b ^ c, 63);
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
void shuffle_shift1(struct block_th *block, uint thread, uint grp,
                    struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_shift1(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, grp, buf);
        block_th_set(block, i, v);
    }
}
void shuffle_unshift1(struct block_th *block, uint thread, uint grp,
                     struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_unshift1(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, grp, buf);
        block_th_set(block, i, v);
    }
}
void shuffle_shift2(struct block_th *block, uint thread, uint grp,
                   struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_shift2(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, grp, buf);
        block_th_set(block, i, v);
    }
}
void shuffle_unshift2(struct block_th *block, uint thread, uint grp,
                     struct u64_shuffle_buf *buf)
{
    for (uint i = 0; i < QWORDS_PER_THREAD; i++) {
        uint src_thr = apply_shuffle_unshift2(thread, i);

        ulong v = block_th_get(block, i);
        v = u64_shuffle(v, src_thr, thread, grp, buf);
        block_th_set(block, i, v);
    }
}
void transpose(struct block_th *block, uint thread, uint grp,
              struct u64_shuffle_buf *buf)
{
    uint thread_group = (thread & 0x0C) >> 2;
    for (uint i = 1; i < QWORDS_PER_THREAD; i++) {
        uint thr = (i << 2) ^ thread;
        uint idx = thread_group ^ i;

        ulong v = block_th_get(block, idx);
        v = u64_shuffle(v, thr, thread, grp, buf);
        block_th_set(block, idx, v);
    }
}
void shuffle_block(struct block_th *block, uint thread, uint grp,
                  struct u64_shuffle_buf *buf)
{
    transpose(block, thread, grp, buf);
    g(block);
    shuffle_shift1(block, thread, grp, buf);
    g(block);
    shuffle_unshift1(block, thread, grp, buf);
    transpose(block, thread, grp, buf);
    g(block);
    shuffle_shift2(block, thread, grp, buf);
    g(block);
    shuffle_unshift2(block, thread, grp, buf);
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
       struct u64_shuffle_buf *shuffle_buf, uint lanes,
        uint thread, uint grp, uint pass, uint ref_index, uint ref_lane)
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

    shuffle_block(prev, thread, grp, shuffle_buf);
    xor_block(prev, tmp);
    store_block(mem_curr, prev, thread);
}
void argon2_step(
        __global struct block_g *memory, __global struct block_g *mem_curr,
        struct block_th *prev, struct block_th *tmp, struct block_th *addr,
       struct u64_shuffle_buf *shuffle_buf,
        uint lanes, uint segment_blocks, uint thread, uint grp, uint *thread_input,
        uint lane, uint pass, uint slice, uint offset)
{
    uint ref_index, ref_lane;
    ulong v = u64_shuffle(prev->a, 0, thread, grp, shuffle_buf);
    ref_index = u64_lo(v);
    ref_lane  = u64_hi(v);
    compute_ref_pos(lanes, segment_blocks, pass, lane, slice, offset,
                    &ref_lane, &ref_index);
    argon2_core(memory, mem_curr, prev, tmp, shuffle_buf, lanes, thread, grp, pass,
                ref_index, ref_lane);
}

__attribute__((reqd_work_group_size(32, 8, 1)))
__kernel void search1(
        __global struct block_g *memory, uint passes, uint lanes,
        uint segment_blocks)
{
    //__local char shuffle_bufs[32 * 8 * 1 * sizeof(uint32_t) * 2];
    uint job_id = get_global_id(2);
    uint lane   = get_global_id(1);
    uint warp   = get_local_id(1);
    uint grp    = (warp % 2) << 5;
    uint thread = get_local_id(0);
    //struct u64_shuffle_buf S_shuffle_buf;
    struct u64_shuffle_buf *shuffle_buf = (struct u64_shuffle_buf *) 0; // = (__local struct u64_shuffle_buf *) &shuffle_bufs[warp * sizeof(struct u64_shuffle_buf)];
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
                            lanes, segment_blocks, thread, grp, &thread_input,
                            lane, pass, slice, offset);
                mem_curr += lanes;
            }
            barrier(CLK_LOCAL_MEM_FENCE);
        }
        mem_curr = mem_lane;
    }
    
    __global uint* memLane = (__global uint*) ( memory + lanes * ( lane_blocks - 1 ) ) ; 

    uint thread2 = get_local_id(0) + (get_local_id(1) << 5);
    uint buf = 0;
    for (uint i=0; i<8; i++){
        buf ^= memLane[thread2+256*i];
    }
    memLane[thread2] = buf;
}
