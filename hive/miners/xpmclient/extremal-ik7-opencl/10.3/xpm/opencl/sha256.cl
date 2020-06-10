/*
 * sha256.cl
 *
 *  Created on: 07.01.2014
 *      Author: mad
 */

#ifndef __NVIDIA
#define BITALIGN
#endif

__constant uint k[] = {
   0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
   0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
   0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
   0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
   0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
   0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
   0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
   0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2 };

__constant uint h_init[] = { 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19 };

#define HashPrimorial 16

#ifdef BITALIGN
  #pragma OPENCL EXTENSION cl_amd_media_ops : enable
  #define Zrotr(a, b) amd_bitalign((uint)a, (uint)a, (uint)(32 - b))
    #ifdef BFI_INT
    #define Ch(x, y, z) amd_bytealign(x, y, z)
    #define Ma(x, y, z) amd_bytealign(z ^ x, y, x)
  #else
    #define Ch(x, y, z) bitselect(z, y, x)
    #define Ma(z, x, y) bitselect(z, y, z ^ x)
  #endif
#else
  #define Zrotr(a, b) rotate((uint)a, (uint)b)
  #define Ch(x, y, z) (z ^ (x & (y ^ z)))
  #define Ma(x, y, z) ((x & z) | (y & (x | z)))
#endif

#define ZR25(n) ((Zrotr((n), 25) ^ Zrotr((n), 14) ^ ((n) >> 3U)))
#define ZR15(n) ((Zrotr((n), 15) ^ Zrotr((n), 13) ^ ((n) >> 10U)))
#define ZR26(n) ((Zrotr((n), 26) ^ Zrotr((n), 21) ^ Zrotr((n), 7)))
#define ZR30(n) ((Zrotr((n), 30) ^ Zrotr((n), 19) ^ Zrotr((n), 10)))


void sha256(const uint *restrict msg, uint *restrict s)
{
#define ROUND(num) {\
  const uint temp1 = h + ZR26(e) + Ch(e, f, g) + k[num] + w[num];\
  const uint temp2 = ZR30(a) + Ma(a, b, c);\
  h = g;\
  g = f;\
  f = e;\
  e = d + temp1;\
  d = c;\
  c = b;\
  b = a;\
  a = temp1 + temp2;\
}  
  
  uint w[64];
  
#pragma unroll  
  for(int i = 0; i < 16; ++i)
    w[i] = msg[i];
  
#pragma unroll  
  for(int i = 16; i < 64; ++i){
    
    const uint s0 = ZR25(w[i-15]);
    const uint s1 = ZR15(w[i-2]);
    w[i] = w[i-16] + s0 + w[i-7] + s1;
    
  }
  
  uint a = s[0];
  uint b = s[1];
  uint c = s[2];
  uint d = s[3];
  uint e = s[4];
  uint f = s[5];
  uint g = s[6];
  uint h = s[7];
  


  ROUND(0)
  ROUND(1) 
  ROUND(2)
  ROUND(3)
  ROUND(4)
  ROUND(5)
  ROUND(6)
  ROUND(7)  
  ROUND(8)  
  ROUND(9)  
  ROUND(10)  
  ROUND(11)  
  ROUND(12)  
  ROUND(13)  
  ROUND(14)  
  ROUND(15)    
  
  ROUND(16)
  ROUND(17)
  ROUND(18)
  ROUND(19)
  ROUND(20)
  ROUND(21)
  ROUND(22)
  ROUND(23)  
  ROUND(24)  
  ROUND(25)  
  ROUND(26)  
  ROUND(27)  
  ROUND(28)  
  ROUND(29)  
  ROUND(30)  
  ROUND(31)    

  ROUND(32)
  ROUND(33)
  ROUND(34)
  ROUND(35)
  ROUND(36)
  ROUND(37)
  ROUND(38)
  ROUND(39)  
  ROUND(40)  
  ROUND(41)  
  ROUND(42)  
  ROUND(43)  
  ROUND(44)  
  ROUND(45)  
  ROUND(46)  
  ROUND(47)    

  ROUND(48)
  ROUND(49)
  ROUND(50)
  ROUND(51)
  ROUND(52)
  ROUND(53)
  ROUND(54)
  ROUND(55)  
  ROUND(56)  
  ROUND(57)  
  ROUND(58)  
  ROUND(59)  
  ROUND(60)  
  ROUND(61)  
  ROUND(62)  
  ROUND(63)      
  
  s[0] += a;
  s[1] += b;
  s[2] += c;
  s[3] += d;
  s[4] += e;
  s[5] += f;
  s[6] += g;
  s[7] += h;
  
#undef ROUND
}


uint sha2_pack(uint val) {
  
  return ((val & 0xFF) << 24) | ((val & 0xFF00) << 8) | ((val & 0xFF0000) >> 8) | ((val & 0xFF000000) >> 24);
  
}

__constant uint32_t indexesOne[] = { 1, 2, 3, 5, 6 };
__constant uint32_t divisors24one[] = { 3, 5, 7, 13, 17 };


__constant uint32_t indexes[] = { 4, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 };
__constant uint32_t divisors24[] = { 11, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71 };

__constant uint32_t modulos24one[] = {
  0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1
};

__constant uint32_t modulos24[] = {
  0x5, 0x3, 0x4, 0x9, 0x1, 0x5, 0x3, 0x4, 0x9, 0x1, 0x5,            // 11
  0x7, 0xb, 0x1, 0x7, 0xb, 0x1, 0x7, 0xb, 0x1, 0x7, 0xb,            // 19
  0x4, 0x10, 0x12, 0x3, 0xc, 0x2, 0x8, 0x9, 0xd, 0x6, 0x1,          // 23
  0x14, 0x17, 0x19, 0x7, 0x18, 0x10, 0x1, 0x14, 0x17, 0x19, 0x7,    // 29
  0x10, 0x8, 0x4, 0x2, 0x1, 0x10, 0x8, 0x4, 0x2, 0x1, 0x10,         // 31
  0xa, 0x1a, 0x1, 0xa, 0x1a, 0x1, 0xa, 0x1a, 0x1, 0xa, 0x1a,        // 37
  0x10, 0xa, 0x25, 0x12, 0x1, 0x10, 0xa, 0x25, 0x12, 0x1, 0x10,     // 41
  0x23, 0x15, 0x4, 0xb, 0x29, 0x10, 0x1, 0x23, 0x15, 0x4, 0xb,      // 43
  0x2, 0x4, 0x8, 0x10, 0x20, 0x11, 0x22, 0x15, 0x2a, 0x25, 0x1b,    // 47
  0xd, 0xa, 0x18, 0x2f, 0x1c, 0x2e, 0xf, 0x24, 0x2c, 0x2a, 0x10,    // 53 *
  0x23, 0x2d, 0x29, 0x13, 0x10, 0x1d, 0xc, 0x7, 0x9, 0x14, 0x33,    // 59
  0x14, 0x22, 0x9, 0x3a, 0x1, 0x14, 0x22, 0x9, 0x3a, 0x1, 0x14,     // 61
  0xe, 0x3e, 0x40, 0x19, 0xf, 0x9, 0x3b, 0x16, 0x28, 0x18, 0x1,     // 67 *
  0x3a, 0x1b, 0x4, 0x13, 0x25, 0x10, 0x5, 0x6, 0x40, 0x14, 0x18,    // 71
};

__constant uint32_t multipliers32one[] = {
   0xaaaaaaab,     // 3
   0x66666667,     // 5
   0x92492493,     // 7
   0x4ec4ec4f,     // 13
   0x78787879,     // 17
};

__constant uint32_t multipliers32[] = {
  0x2e8ba2e9,      // 11
  0x6bca1af3,      // 19
  0xb21642c9,      // 23
  0x8d3dcb09,      // 29
  0x84210843,      // 31
  0xdd67c8a7,      // 37
  0x63e7063f,      // 41
  0x2fa0be83,      // 43
  0xae4c415d,      // 47
  0x4d4873ed,      // 53 *
  0x22b63cbf,      // 59
  0x4325c53f,      // 61
  0x7a44c6b,       // 67 *
  0xe6c2b449       // 71
};

__constant uint32_t offsets32one[] = {
  1,               // 3
  1,               // 5
  2,               // 7
  2,               // 13
  3                // 17
};

__constant uint32_t offsets32[] = {
  1,               // 11
  3,               // 19
  4,               // 23
  4,               // 29
  4,               // 31
  5,               // 37
  4,               // 41
  3,               // 43
  5,               // 47
  4,               // 53 *
  3,               // 59
  4,               // 61
  1,               // 67 *
  6                // 71
};

// * using 24-bit arithmetic with primes 53,67 can produce wrong results!

__constant unsigned gPrimes[] = {
  2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73
};

uint32_t sum24(const uint32_t *data, unsigned size, __constant uint32_t *moddata)
{
  unsigned size24 = size*32; size24 += size24 % 24 ? 24 - size24%24 : 0;
  
  uint32_t acc = data[0] & 0x00FFFFFF;
#pragma unroll
  for (unsigned i = 0, bitPos = 24; bitPos < size24; bitPos += 24, i++) {
    uint64_t v64 = *(uint64_t*)(data+bitPos/32) >> (bitPos%32);
#ifdef __NVIDIA
    acc = mad24(v64 & 0xFFFFFF, moddata[i], acc);    
#else
    acc = mad24((uint32_t)v64, moddata[i], acc);    
#endif
  }
  
  return acc;
}

unsigned check24(uint32_t X, uint32_t divisor, uint32_t inversedMultiplier, unsigned offset)
{
  return X == divisor*(mul_hi(X, inversedMultiplier) >> offset);
}

unsigned divisionCheck24(const uint32_t *data,
                       unsigned size,
                       uint32_t divisor,
                       __constant uint32_t *moddata,
                       uint32_t inversedMultiplier,
                       unsigned offset)
{
  return check24(sum24(data, size, moddata), divisor, inversedMultiplier, offset);
}


__kernel void bhashmod(__global uint* found,
            __global uint* fcount,
            __global uint* resultPrimorial,
            __constant uint* midstate,
            uint merkle, uint time, uint nbits )
{
  const uint id = get_global_id(0);

  uint msg[16];
  msg[0] = merkle;
  msg[1] = time;
  msg[2] = nbits;
  msg[3] = sha2_pack(id);
  msg[4] = sha2_pack(0x80);
#pragma unroll  
  for(int i = 5; i < 15; ++i)
    msg[i] = 0;
  msg[15] = 640;
  
  uint state[9];
#pragma unroll  
  for(int i = 0; i < 8; ++i)
    state[i] = midstate[i];
  
  sha256(msg, state);
  
#pragma unroll  
  for(int i = 0; i < 8; ++i)
    msg[i] = state[i];
  msg[8] = sha2_pack(0x80);
  msg[15] = 256;
  
#pragma unroll  
  for(int i = 0; i < 8; ++i)
    state[i] = h_init[i];
  
  sha256(msg, state);
  
#pragma unroll  
  for(int i = 0; i < 8; ++i)
    state[i] = sha2_pack(state[i]);
  
  if (state[7] & (1u << 31)) {
    uint32_t count = !(state[0] & 0x1);
    uint32_t primorialBitField = count;
    state[8] = 0;
    
    {
      uint32_t acc = sum24(state, 8, modulos24one);
#pragma unroll
      for (unsigned i = 0; i < 5; i++) {
        unsigned isDivisor = check24(acc, divisors24one[i], multipliers32one[i], offsets32one[i]);
        primorialBitField |= (isDivisor << indexesOne[i]);
        count += isDivisor;
      }
    }
    
#pragma unroll
    for (unsigned i = 0; i < HashPrimorial-5; i++) {
      unsigned isDivisor =
        divisionCheck24(state, 8, divisors24[i], &modulos24[i*11], multipliers32[i], offsets32[i]);
        primorialBitField |= (isDivisor << indexes[i]);
      count += isDivisor;
    }

    if (count >= 8) {
      const uint index = atomic_inc(fcount);
      resultPrimorial[index] = primorialBitField;
      found[index] = id;
    }
  }
}

void sha256UsePrecalc(const uint *restrict msg,
                      uint *restrict s,
                      const uint32_t *WData, int WSize,
                      const uint32_t *new1Data, int new1Size,
                      const uint32_t *new2Data, int new2Size,
                      const uint32_t *temp2Data, int tmp2Size)
{
#define ROUND(num) {\
  const uint temp1 = h + ZR26(e) + Ch(e, f, g) + k[num] + w[num];\
  const uint temp2 = ZR30(a) + Ma(a, b, c);\
  h = g;\
  g = f;\
  f = e;\
  if (num < new2Size)\
    e = new2Data[num];\
  else\
    e = d + temp1;\
  d = c;\
  c = b;\
  b = a;\
  if (num < new1Size)\
    a = new1Data[num];\
  else if (num < tmp2Size)\
    a = temp1 + temp2Data[num];\
  else\
    a = temp1 + temp2;\
  }
  
  uint w[64];
  
#pragma unroll  
  for(int i = 0; i < 16; ++i)
    w[i] = msg[i];
  
#pragma unroll  
  for(int i = 16; i < 64; ++i){
    
    const uint s0 = ZR25(w[i-15]);
    const uint s1 = ZR15(w[i-2]);
    w[i] = w[i-16] + s0 + w[i-7] + s1;
    
  }
  
  uint a = s[0];
  uint b = s[1];
  uint c = s[2];
  uint d = s[3];
  uint e = s[4];
  uint f = s[5];
  uint g = s[6];
  uint h = s[7];
  


  ROUND(0)
  ROUND(1)
  ROUND(2)
  ROUND(3)
  ROUND(4)
  ROUND(5)
  ROUND(6)
  ROUND(7)  
  ROUND(8)  
  ROUND(9)  
  ROUND(10)  
  ROUND(11)  
  ROUND(12)  
  ROUND(13)  
  ROUND(14)  
  ROUND(15)    
  
  ROUND(16)
  ROUND(17)
  ROUND(18)
  ROUND(19)
  ROUND(20)
  ROUND(21)
  ROUND(22)
  ROUND(23)  
  ROUND(24)  
  ROUND(25)  
  ROUND(26)  
  ROUND(27)  
  ROUND(28)  
  ROUND(29)  
  ROUND(30)  
  ROUND(31)    

  ROUND(32)
  ROUND(33)
  ROUND(34)
  ROUND(35)
  ROUND(36)
  ROUND(37)
  ROUND(38)
  ROUND(39)  
  ROUND(40)  
  ROUND(41)  
  ROUND(42)  
  ROUND(43)  
  ROUND(44)  
  ROUND(45)  
  ROUND(46)  
  ROUND(47)    

  ROUND(48)
  ROUND(49)
  ROUND(50)
  ROUND(51)
  ROUND(52)
  ROUND(53)
  ROUND(54)
  ROUND(55)  
  ROUND(56)  
  ROUND(57)  
  ROUND(58)  
  ROUND(59)  
  ROUND(60)  
  ROUND(61)  
  ROUND(62)  
  ROUND(63)      
  
  s[0] += a;
  s[1] += b;
  s[2] += c;
  s[3] += d;
  s[4] += e;
  s[5] += f;
  s[6] += g;
  s[7] += h;
  
#undef ROUND  
}


__attribute__((reqd_work_group_size(LSIZE, 1, 1)))
__kernel void bhashmodUsePrecalc(__global uint *found,
                                 __global uint *fcount,
                                 __global uint *resultPrimorial,
                                 __constant* midstate,
                                 uint merkle,
                                 uint time,
                                 uint nbits,
                                 uint W0,
                                 uint W1,
                                 uint new1_0,
                                 uint new1_1,
                                 uint new1_2,
                                 uint new2_0,
                                 uint new2_1,
                                 uint new2_2,
                                 uint temp2_3)
{
  const uint id = get_global_id(0);
  
  uint msg[16];
  msg[0] = merkle;
  msg[1] = time;
  msg[2] = nbits;
  msg[3] = sha2_pack(id);
  msg[4] = sha2_pack(0x80);
  
  #pragma unroll  
  for(int i = 5; i < 15; ++i)
    msg[i] = 0;
  msg[15] = 640;
  
  uint state[9];
  #pragma unroll  
  for(int i = 0; i < 8; ++i)
    state[i] = midstate[i];
  
  uint32_t W[2] = {W0, W1};
  uint32_t new1[3] = {new1_0, new1_1, new1_2};
  uint32_t new2[3] = {new2_0, new2_1, new2_2};
  uint32_t temp2[4] = {0, 0, 0, temp2_3};  
  
  sha256UsePrecalc(msg, state, W, 2, new1, 3, new2, 3, temp2, 4);
  
  #pragma unroll  
  for(int i = 0; i < 8; ++i)
    msg[i] = state[i];
  msg[8] = sha2_pack(0x80);
  msg[15] = 256;
  
  #pragma unroll  
  for(int i = 0; i < 8; ++i)
    state[i] = h_init[i];
  
  sha256(msg, state);
  for(int i = 0; i < 8; ++i)
    state[i] = sha2_pack(state[i]);
  
  if (state[7] & (1u << 31)) {
    uint32_t count = !(state[0] & 0x1);
    uint32_t primorialBitField = count;
    state[8] = 0;
    
    {
      uint32_t acc = sum24(state, 8, modulos24one);
      #pragma unroll
      for (unsigned i = 0; i < 5; i++) {
        unsigned isDivisor = check24(acc, divisors24one[i], multipliers32one[i], offsets32one[i]);
        primorialBitField |= (isDivisor << indexesOne[i]);
        count += isDivisor;
      }
    }
    
    unsigned lastBit = 0;
    #pragma unroll    
    for (unsigned i = 0; i < HashPrimorial-5; i++) {
      unsigned isDivisor =
      divisionCheck24(state, 8, divisors24[i], &modulos24[i*11], multipliers32[i], offsets32[i]);
      primorialBitField |= (isDivisor << indexes[i]);
      lastBit = isDivisor ? i+5 : lastBit;
    }
    
    uint32_t prod13l = 1;
    for (unsigned i = 0; i < 8; i++)
      prod13l = mul24(prod13l, select(gPrimes[i], 1u, primorialBitField & (1u << i)));
    prod13l *= select(gPrimes[8], 1u, primorialBitField & (1u << 8));
    
    uint64_t prod13 = prod13l;
    for (unsigned i = 9; i < 14; i++)
      prod13 *= select(gPrimes[i], 1u, primorialBitField & (1u << i));
    
    uint64_t prod14 = prod13 * select(gPrimes[14], 1u, primorialBitField & (1u << 14));
    uint64_t prod15 = prod14 * select(gPrimes[15], 1u, primorialBitField & (1u << 15));
    
    int p13isValid = ((64-clz(prod13)) < LIMIT13);
    
    int p14Unique = !(p13isValid & (prod14 == prod13));
    int p14isValid = ((64-clz(prod14)) < LIMIT14) & p14Unique;
    
    int p15Unique = !(p13isValid & (prod15 == prod13)) & !(p14isValid & (prod15 == prod14));
    int p15isValid = ((64-clz(prod15)) < LIMIT15) & p15Unique;
    
    if (p13isValid) {
      const uint index = atomic_inc(fcount);
      resultPrimorial[index] = (primorialBitField & 0xFFFF) | (13u << 16);
      found[index] = id;
    }
    
    if (p14isValid) {
      const uint index = atomic_inc(fcount);
      resultPrimorial[index] = (primorialBitField & 0xFFFF) | (14u << 16);
      found[index] = id;
    }
    
    if (p15isValid) {
      const uint index = atomic_inc(fcount);
      resultPrimorial[index] = (primorialBitField & 0xFFFF) | (15u << 16);
      found[index] = id;
    }    
  }
}
