/*
 * Lyra2RE kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 * Copyright (c) 2014 djm34
 * Copyright (c) 2014 James Lovejoy
 * Copyright (c) 2017 MaxDZ8
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
 * @author   djm34
 */
/*
 * This file is mostly the same as lyra2rev2.cl: differences:
 * - Cubehash implementation is now shared across search2 and search5
 * - Cubehash is reformulated, this reduces ISA size to almost 1/3
 *   leaving rooms for other algorithms.
 * - Lyra is reformulated in 4 stages: arithmetically intensive
 *   head and tail, one coherent matrix expansion, one incoherent mess.
*/
#ifndef LYRA2REV2_CL
#define LYRA2REV2_CL

#if __ENDIAN_LITTLE__
#define SPH_LITTLE_ENDIAN 1
#else
#define SPH_BIG_ENDIAN 1
#endif

#define SPH_UPTR sph_u64

typedef unsigned int sph_u32;
typedef int sph_s32;
#ifndef __OPENCL_VERSION__
typedef unsigned long sph_u64;
typedef long  sph_s64;
#else
typedef unsigned long sph_u64;
typedef long sph_s64;
#endif


#define SPH_64 1
#define SPH_64_TRUE 1

#define SPH_C32(x)    ((sph_u32)(x ## U))
#define SPH_T32(x)    ((x) & SPH_C32(0xFFFFFFFF))

#define SPH_C64(x)    ((sph_u64)(x ## UL))
#define SPH_T64(x)    ((x) & SPH_C64(0xFFFFFFFFFFFFFFFF))


#define SPH_ROTL32(x,n) rotate(x,(uint)n)     //faster with driver 14.6
#define SPH_ROTR32(x,n) rotate(x,(uint)(32-n))
#define SPH_ROTL64(x,n) rotate(x,(ulong)n)
#define SPH_ROTR64(x,n) rotate(x,(ulong)(64-n))


#pragma OPENCL EXTENSION cl_amd_media_ops : enable
#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

ulong ROTR64(const ulong x2, const uint y)
{
	uint2 x = as_uint2(x2);
	if(y < 32) return(as_ulong(amd_bitalign(x.s10, x, y)));
	else return(as_ulong(amd_bitalign(x, x.s10, (y - 32))));
}

#include "blake256.cl"
#include "keccak1600.cl"
#include "skein256.cl"
#include "cubehash.cl"
#include "bmw256.cl"

#define SWAP4(x) as_uint(as_uchar4(x).wzyx)
#define SWAP8(x) as_ulong(as_uchar8(x).s76543210)
#define SWAP32(x) as_ulong(as_uint2(x).s10)
//#define SWAP8(x) as_ulong(as_uchar8(x).s32107654)
#if SPH_BIG_ENDIAN
  #define DEC64E(x) (x)
  #define DEC64BE(x) (*(const __global sph_u64 *) (x));
  #define DEC64LE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC32LE(x) (*(const __global sph_u32 *) (x));
#else
  #define DEC64E(x) SWAP8(x)
  #define DEC64BE(x) SWAP8(*(const __global sph_u64 *) (x));
  #define DEC64LE(x) (*(const __global sph_u64 *) (x));
#define DEC32LE(x) SWAP4(*(const __global sph_u32 *) (x));
#endif

typedef union {
  unsigned char h1[32];
  uint h4[8];
  ulong h8[4];
} hash_t;

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(
	 __global uchar* hashes,
	// precalc hash from fisrt part of message
	const uint h0,
	const uint h1,
	const uint h2,
	const uint h3,
	const uint h4,
	const uint h5,
	const uint h6,
	const uint h7,
	// last 12 bytes of original message
	const uint in16,
	const uint in17,
	const uint in18
)
{
 uint gid = get_global_id(0);
 __global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));


//  __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

    unsigned int h[8];
	unsigned int m[16];
	unsigned int v[16];


h[0]=h0;
h[1]=h1;
h[2]=h2;
h[3]=h3;
h[4]=h4;
h[5]=h5;
h[6]=h6;
h[7]=h7;
// compress 2nd round
 m[0] = in16;
 m[1] = in17;
 m[2] = in18;
 m[3] = SWAP4(gid);

	for (int i = 4; i < 16; i++) {m[i] = c_Padding[i];}

	for (int i = 0; i < 8; i++) {v[i] = h[i];}

	v[8] =  c_u256[0];
	v[9] =  c_u256[1];
	v[10] = c_u256[2];
	v[11] = c_u256[3];
	v[12] = c_u256[4] ^ 640;
	v[13] = c_u256[5] ^ 640;
	v[14] = c_u256[6];
	v[15] = c_u256[7];

	for (int r = 0; r < 14; r++) {	
		GS(0, 4, 0x8, 0xC, 0x0);
		GS(1, 5, 0x9, 0xD, 0x2);
		GS(2, 6, 0xA, 0xE, 0x4);
		GS(3, 7, 0xB, 0xF, 0x6);
		GS(0, 5, 0xA, 0xF, 0x8);
		GS(1, 6, 0xB, 0xC, 0xA);
		GS(2, 7, 0x8, 0xD, 0xC);
		GS(3, 4, 0x9, 0xE, 0xE);
	}

	for (int i = 0; i < 16; i++) {
		 int j = i & 7;
		h[j] ^= v[i];}

for (int i=0;i<8;i++) {hash->h4[i]=SWAP4(h[i]);}

barrier(CLK_LOCAL_MEM_FENCE);

}

// keccak256


__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search1(__global uchar* hashes)
{
  uint gid = get_global_id(0);
 // __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);

  __global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));

 		sph_u64 keccak_gpu_state[25];

		for (int i = 0; i<25; i++) {
			if (i<4) { keccak_gpu_state[i] = hash->h8[i]; }
			else    { keccak_gpu_state[i] = 0; }
		}
		keccak_gpu_state[4] = 0x0000000000000001;
		keccak_gpu_state[16] = 0x8000000000000000;

		keccak_block(keccak_gpu_state);
		for (int i = 0; i<4; i++) { hash->h8[i] = keccak_gpu_state[i]; }
barrier(CLK_LOCAL_MEM_FENCE);



}

void cubehash_256(global uint *msg) {
    uint x0 = 0xEA2BD4B4, x1 = 0xCCD6F29F, x2 = 0x63117E71, x3 = 0x35481EAE;
    uint x4 = 0x22512D5B, x5 = 0xE5D94E63, x6 = 0x7E624131, x7 = 0xF4CC12BE;
    uint x8 = 0xC2D0B696, x9 = 0x42AF2070, xa = 0xD0720C35, xb = 0x3361DA8C;
    uint xc = 0x28CCECA4, xd = 0x8EF8AD83, xe = 0x4680AC00, xf = 0x40E5FBAB;
	
    uint xg = 0xD89041C3, xh = 0x6107FBD5, xi = 0x6C859D41, xj = 0xF0B26679;
    uint xk = 0x09392549, xl = 0x5FA25603, xm = 0x65C892FD, xn = 0x93CB6285;
    uint xo = 0x2AF2B5AE, xp = 0x9E4B4E60, xq = 0x774ABFDD, xr = 0x85254725;
    uint xs = 0x15815AEB, xt = 0x4AB6AAD6, xu = 0x9CDAF8AF, xv = 0xD6032C0A;
	
    x0 ^= msg[0];
    x1 ^= msg[1];
    x2 ^= msg[2];
    x3 ^= msg[3];
    x4 ^= msg[4];
    x5 ^= msg[5];
    x6 ^= msg[6];
    x7 ^= msg[7];

    for (int i = 0; i < 12; i ++) {
		for (int j = 0; j < 8; j++) {
			ROUND_EVEN;
			ROUND_ODD;
		}

        if (i == 0) { // ugly. But don't ask me why, doing this on my system makes things faster!
            x0 ^= 0x80; // most importantly, ISA down to less than half due to rounds not unrolled (?)
        } else if (i == 1) {
            xv ^= 0x01;
        }
    }

    msg[ 0] = x0;
    msg[ 1] = x1;
    msg[ 2] = x2;
    msg[ 3] = x3;
    msg[ 4] = x4;
    msg[ 5] = x5;
    msg[ 6] = x6;
    msg[ 7] = x7;
}

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search2(__global uchar* hashes)
{
	uint gid = get_global_id(0);
	__global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));
	cubehash_256(hash->h4);
}


/// lyra2 algo  ///////////////////////////////////////////////////////////
#define HASH_SIZE (256 / 8) // size in bytes of an hash in/out
#define SLOT (get_global_id(1) - get_global_offset(1))
#define LOCAL_LINEAR (get_local_id(1) * get_local_size(0) + get_local_id(0))
#define REG_ROW_COUNT (4 * get_global_size(1)) // ideally all happen at the same clock
#define STATE_BLOCK_COUNT (3 * REG_ROW_COUNT)  // very close instructions
#define LYRA_ROUNDS 4
#define HYPERMATRIX_COUNT (LYRA_ROUNDS * STATE_BLOCK_COUNT)

// Usually just #define G(a,b,c,d)...; I have no time to read the Lyra paper
// but that looks like some kind of block cipher I guess.
void cipher_G(ulong s[4]) {
	s[0] += s[1]; s[3] ^= s[0]; s[3] = SWAP32(s[3]);
	s[2] += s[3]; s[1] ^= s[2]; s[1] = ROTR64(s[1], 24);
	s[0] += s[1]; s[3] ^= s[0]; s[3] = ROTR64(s[3], 16);
	s[2] += s[3]; s[1] ^= s[2]; s[1] = ROTR64(s[1], 63);
}

// pad counts 4 entries each hash team of 4
void round_lyra_4way(ulong state[4], local ulong *pad) {
	// The first half of the round is super nice to us 4-way kernels because we mangle
	// our own column so it's just as in the legacy kernel, except we are parallel.
	cipher_G(state);
	// Now we mangle diagonals ~ shift rows
	// That's a problem for us in CL because we don't have SIMD lane shuffle yet (AMD you dumb fuck)
	// Not a problem for private miners: there's an op for that.
	// But maybe only for GCN>3? IDK.
	// Anyway, each element of my state besides 0 should go somewhere!
	for(int shuffle = 1; shuffle < 4; shuffle++) {
		pad[get_local_id(0)] = state[shuffle];
		barrier(CLK_LOCAL_MEM_FENCE); // nop, we're lockstep
		state[shuffle] = pad[(get_local_id(0) + shuffle) % 4]; // maybe also precompute those offsets
	}	
	cipher_G(state);
	// And we also have to put everything back in place :-(
	for(int shuffle = 1; shuffle < 4; shuffle++) {
		pad[get_local_id(0)] = state[shuffle];
		barrier(CLK_LOCAL_MEM_FENCE); // nop, we're lockstep
		int offset = shuffle % 2? 2 : 0;
		offset += shuffle;
		state[shuffle] = pad[(get_local_id(0) + offset) % 4]; // maybe also precompute those offsets
	}
}


/** Legacy kernel: "reduce duplex f". What it really does:
init hypermatrix[1] from [0], starting at bigMat, already offset per hash
inverting cols. We init hyper index 1 and we have only 1 to mangle. */
void make_hyper_one(ulong *state, local ulong *xchange, global ulong *bigMat) {
	ulong si[3];
	uint src = 0;
	uint dst = HYPERMATRIX_COUNT * 2 - STATE_BLOCK_COUNT;
	for (int loop = 0; loop < LYRA_ROUNDS; loop++)
	{
		for (int row = 0; row < 3; row++) {
			si[row] = bigMat[src];
			state[row] ^= si[row];
			src += REG_ROW_COUNT; // read sequentially huge chunks of memory!
		}
		round_lyra_4way(state, xchange);
		for (int row = 0; row < 3; row++) {
			si[row] ^= state[row];
			bigMat[dst + row * REG_ROW_COUNT] = si[row]; // zigzag. Less nice.
		} // legacy kernel interleave xyzw for each row of matrix so
		// going ahead or back is no difference for them but it is for us
		// (me and my chip) because we keep the columns packed.
		dst -= STATE_BLOCK_COUNT;
	}
}

/** Consider your s'' as a sequence of ulongs instead of a matrix. Rotate it back
and xor with true state. */
void xorrot_one(ulong *modify, local ulong *groupPad, ulong *src) {
	
	ushort dst = LOCAL_LINEAR; // my slot
	short off = get_local_id(0) < 3? 1 : (64 - 3);
	groupPad[dst + off] = src[0];
	dst += 64;
	groupPad[dst + off] = src[1];
	dst += 64;
	off = get_local_id(0) < 3? 1 : (-128 - 3);
	groupPad[dst + off] = src[2];
	for(uint cp = 0; cp < 3; cp++) modify[cp] ^= groupPad[LOCAL_LINEAR + cp * 64];
}


/** Legacy kernel: reduce duplex row (from) setup.
I rather think of their rows as my hyper matrix.
There are two we can use now. The first we read.
The last we modify (and we created it only a few ticks before!
So maybe LDS here as well? To be benchmarked). */
void make_next_hyper(uint matin, uint matrw, uint matout,
                     ulong *state, local ulong *groupPad, global ulong *bigMat) {
	ulong si[3], sII[3];
	uint hyc = HYPERMATRIX_COUNT * matin; // hyper constant
	uint hymod = HYPERMATRIX_COUNT * matrw; // hyper modify
	uint hydst = HYPERMATRIX_COUNT * matout + HYPERMATRIX_COUNT - STATE_BLOCK_COUNT;
	for (int i = 0; i < LYRA_ROUNDS; i++)
	{
		for (int row = 0; row < 3; row++)  {
			si[row] = bigMat[hyc + row * REG_ROW_COUNT];
			sII[row] = bigMat[hymod + row * REG_ROW_COUNT];
			state[row] ^= si[row] + sII[row];
		}
		round_lyra_4way(state, groupPad + get_local_id(1) * 4);
		for (int row = 0; row < 3; row++) {
			si[row] ^= state[row];
			bigMat[hydst + row * REG_ROW_COUNT] = si[row];
		}
		// A nice surprise there! Before continuing, xor your mini-matrix'' by state.
		// But there's a quirk! Your s''[i] is to be xorred with s[i-1].
		// Or with s[i+11] in modulo arithmetic.
		// Private miners again shuffle those with the ISA instruction which provides
		// far more performance (1 op instead of 4, and shuffle masks are constants
		// whereas LDS isn't). So, we send forward 1 our state, rows interleaved.
		xorrot_one(sII, groupPad, state);
		for(uint cp = 0; cp < 3; cp++) bigMat[hymod + cp * REG_ROW_COUNT] = sII[cp];
		hyc += STATE_BLOCK_COUNT;
		hymod += STATE_BLOCK_COUNT;
		hydst -= STATE_BLOCK_COUNT;
	}
}


/** Legacy: reduce duplex row function? IDK.
What it does: XOR huge chunks of memory (now fully parallel and packed)!
The difference wrt building hyper matrices is
- We don't invert rows anymore so we start and walk similarly for all matrix.
- When the two matrices being modified are the same we just assign. */
void hyper_xor(uint matin, uint matrw, uint matout,
               ulong *state, local ulong *groupPad, global ulong *bigMat) {
	ulong si[3], sII[3];
	uint3 hyoff = (uint3)(matin, matrw, matout) * HYPERMATRIX_COUNT;
	uint hyc = HYPERMATRIX_COUNT * matin;
	uint hymod = HYPERMATRIX_COUNT * matrw;
	uint hydst = HYPERMATRIX_COUNT * matout;
	for (int i = 0; i < LYRA_ROUNDS; i++)
	{
		for (int row = 0; row < 3; row++)  {
			si[row] = bigMat[hyc + row * REG_ROW_COUNT];
			sII[row] = bigMat[hymod + row * REG_ROW_COUNT];
		}
		for (int row = 0; row < 3; row++)  {
			si[row] += sII[row];
			state[row] ^= si[row];
		}
		round_lyra_4way(state, groupPad + get_local_id(1) * 4);
		xorrot_one(sII, groupPad, state);
		// Oh noes! An 'if' inside a loop!
		// That's particularly bad: it's a 'dynamic' (or 'varying') branch
		// which means it's potentially divergent and it's basically random.
		// Every hash goes this or that way and if we could have 4-element
		// SIMD lanes we would have little problem but we have this.
		// Don't worry; we're going at memory speed anyway.
		// BTW this has both different sources and different destinations so
		// no other way to do it but just diverge.
		if (matrw != matout) {
			for (int row = 0; row < 3; row++) {
				bigMat[hymod + row * REG_ROW_COUNT] = sII[row];
				bigMat[hydst + row * REG_ROW_COUNT] ^= state[row];
			}
		}
		else {
			for (int row = 0; row < 3; row++) {
				sII[row] ^= state[row];
			    bigMat[hymod + row * REG_ROW_COUNT] = sII[row];
			}
		}
		hyc += STATE_BLOCK_COUNT;
		hymod += STATE_BLOCK_COUNT;
		hydst += STATE_BLOCK_COUNT;
	}
}



static constant ulong initial_lyra2[2][4] = {
	{ 0x6a09e667f3bcc908UL, 0xbb67ae8584caa73bUL, 0x3c6ef372fe94f82bUL, 0xa54ff53a5f1d36f1UL },
	{ 0x510e527fade682d1UL, 0x9b05688c2b3e6c1fUL, 0x1f83d9abfb41bd6bUL, 0x5be0cd19137e2179UL }
};

static constant ulong mid_mix[2][4] = {
	{ 0x20,0x20,0x20,0x01 },
	{ 0x04,0x04,0x80,0x0100000000000000 }
};

__attribute__((reqd_work_group_size(4, 16, 1)))
kernel void search3(global ulong *hashio, global ulong *notepad)
{
	// cipher_G only requires to shuffle rows so 4 elements would be sufficient.
	// Unfortunately, reduceDuplexRowSetupf shuffles whole matrices thinking at them
	// as an array of 12 ulongs. That's still just 1.5 KiB of local, very viable!
	local ulong roundPad[12 * 16];
	local ulong *xchange = roundPad + get_local_id(1) * 4;
	hashio += (SLOT * HASH_SIZE / sizeof(ulong));
	notepad += get_local_id(0) + 4 * SLOT; // wait, wut? We pack'em close! Very different from legacy kernel!
	const int player = get_local_id(0);
	
	ulong state[4];
	state[0] = hashio[player];
    state[1] = state[0];
    state[2] = initial_lyra2[0][player];
    state[3] = initial_lyra2[1][player];
	
	for (int loop = 0; loop < 12; loop++) round_lyra_4way(state, xchange);
	state[0] ^= mid_mix[0][get_local_id(0)];
	state[1] ^= mid_mix[1][get_local_id(0)];
	for (int loop = 0; loop < 12; loop++) round_lyra_4way(state, xchange);
  
	global ulong *dst = notepad + HYPERMATRIX_COUNT;
	for (int loop = 0; loop < LYRA_ROUNDS; loop++) { // write columns and rows 'in order'
		dst -= STATE_BLOCK_COUNT; // but blocks backwards
		for(int cp = 0; cp < 3; cp++) dst[cp * REG_ROW_COUNT] = state[cp];
		round_lyra_4way(state, xchange);
	}
	make_hyper_one(state, xchange, notepad);
    make_next_hyper(1, 0, 2, state, roundPad, notepad);
    make_next_hyper(2, 1, 3, state, roundPad, notepad);
	uint prev = 3;
	uint modify;
	for (uint loop = 0; loop < LYRA_ROUNDS; loop++) {
		local uint *shorter = (local uint*)roundPad;
		if(get_local_id(0) == 0) {
			// Ouch! I am the only one who can compute this value.
			// All others in my team need this and with shuffle we can get it FAST.
			// But I have no shuffle so I go LDS. And LDS is either point-to-point
			// or broadcast. Ok, we'll stall a bit.
			shorter[get_local_id(1)] = (uint)(state[0] % 4);
		}
		barrier(CLK_LOCAL_MEM_FENCE); // nop
		modify = shorter[get_local_id(1)];
		hyper_xor(prev, modify, loop, state, roundPad, notepad);
		prev = loop;
	}
	notepad += HYPERMATRIX_COUNT * modify;
	for(int loop = 0; loop < 3; loop++) state[loop] ^= notepad[loop * REG_ROW_COUNT];
	for(int loop = 0; loop < 12; loop++) round_lyra_4way(state, xchange);
	hashio[player] = state[0]; 
}
////////////////////////////////////////////////////////////////////////////


//skein256

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search4(__global uchar* hashes)
{
 uint gid = get_global_id(0);
 // __global hash_t *hash = &(hashes[gid-get_global_offset(0)]);
  __global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));


		sph_u64 h[9];
		sph_u64 t[3];
        sph_u64 dt0,dt1,dt2,dt3;
		sph_u64 p0, p1, p2, p3, p4, p5, p6, p7;
        h[8] = skein_ks_parity;

		for (int i = 0; i<8; i++) {
			h[i] = SKEIN_IV512_256[i];
			h[8] ^= h[i];}
		    
			t[0]=t12[0];
			t[1]=t12[1];
			t[2]=t12[2];

        dt0=hash->h8[0];
        dt1=hash->h8[1];
        dt2=hash->h8[2];
        dt3=hash->h8[3];

		p0 = h[0] + dt0;
		p1 = h[1] + dt1;
		p2 = h[2] + dt2;
		p3 = h[3] + dt3;
		p4 = h[4];
		p5 = h[5] + t[0];
		p6 = h[6] + t[1];
		p7 = h[7];

        #pragma unroll 
		for (int i = 1; i<19; i+=2) {Round_8_512(p0,p1,p2,p3,p4,p5,p6,p7,i);}
        p0 ^= dt0;
        p1 ^= dt1;
        p2 ^= dt2;
        p3 ^= dt3;

		h[0] = p0;
		h[1] = p1;
		h[2] = p2;
		h[3] = p3;
		h[4] = p4;
		h[5] = p5;
		h[6] = p6;
		h[7] = p7;
		h[8] = skein_ks_parity;
        
		for (int i = 0; i<8; i++) { h[8] ^= h[i]; }
		
		t[0] = t12[3];
		t[1] = t12[4];
		t[2] = t12[5];
		p5 += t[0];  //p5 already equal h[5] 
		p6 += t[1];
       
        #pragma unroll
		for (int i = 1; i<19; i+=2) { Round_8_512(p0, p1, p2, p3, p4, p5, p6, p7, i); }

		hash->h8[0]      = p0;
		hash->h8[1]      = p1;
		hash->h8[2]      = p2;
		hash->h8[3]      = p3;
	barrier(CLK_LOCAL_MEM_FENCE);

}


__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search5(__global uchar* hashes)
{
	uint gid = get_global_id(0);
	__global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));
	cubehash_256(hash->h4);
}



__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search6(__global uchar* hashes, __global uint* output, const ulong target)
{
	uint gid = get_global_id(0);
	__global hash_t *hash = (__global hash_t *)(hashes + (4 * sizeof(ulong)* (get_global_id(0) % MAX_GLOBAL_THREADS)));

	uint dh[16] = {
		0x40414243, 0x44454647,
		0x48494A4B, 0x4C4D4E4F,
		0x50515253, 0x54555657,
		0x58595A5B, 0x5C5D5E5F,
		0x60616263, 0x64656667,
		0x68696A6B, 0x6C6D6E6F,
		0x70717273, 0x74757677,
		0x78797A7B, 0x7C7D7E7F
	};
	uint final_s[16] = {
		0xaaaaaaa0, 0xaaaaaaa1, 0xaaaaaaa2,
		0xaaaaaaa3, 0xaaaaaaa4, 0xaaaaaaa5,
		0xaaaaaaa6, 0xaaaaaaa7, 0xaaaaaaa8,
		0xaaaaaaa9, 0xaaaaaaaa, 0xaaaaaaab,
		0xaaaaaaac, 0xaaaaaaad, 0xaaaaaaae,
		0xaaaaaaaf
	};

	uint message[16];
	for (int i = 0; i<8; i++) message[i] = hash->h4[i];
	for (int i = 9; i<14; i++) message[i] = 0;
	message[8]= 0x80;
	message[14]=0x100;
	message[15]=0;

	Compression256(message, dh);
	Compression256(dh, final_s);
	barrier(CLK_LOCAL_MEM_FENCE);


	bool result = ( ((ulong*)final_s)[7] <= target);
	if (result) {
		output[atomic_inc(output + 0xFF)] = SWAP4(gid);
	}

}


#endif // LYRA2REV2_CL