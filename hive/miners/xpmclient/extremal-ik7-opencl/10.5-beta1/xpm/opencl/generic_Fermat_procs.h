#include "generic_procs.h"

__constant uint pow2[9] = {1, 2, 4, 8, 16, 32, 64, 128, 256};

__constant uint32_t binvert_limb_table[128] = {
  0x01, 0xAB, 0xCD, 0xB7, 0x39, 0xA3, 0xC5, 0xEF,
  0xF1, 0x1B, 0x3D, 0xA7, 0x29, 0x13, 0x35, 0xDF,
  0xE1, 0x8B, 0xAD, 0x97, 0x19, 0x83, 0xA5, 0xCF,
  0xD1, 0xFB, 0x1D, 0x87, 0x09, 0xF3, 0x15, 0xBF,
  0xC1, 0x6B, 0x8D, 0x77, 0xF9, 0x63, 0x85, 0xAF,
  0xB1, 0xDB, 0xFD, 0x67, 0xE9, 0xD3, 0xF5, 0x9F,
  0xA1, 0x4B, 0x6D, 0x57, 0xD9, 0x43, 0x65, 0x8F,
  0x91, 0xBB, 0xDD, 0x47, 0xC9, 0xB3, 0xD5, 0x7F,
  0x81, 0x2B, 0x4D, 0x37, 0xB9, 0x23, 0x45, 0x6F,
  0x71, 0x9B, 0xBD, 0x27, 0xA9, 0x93, 0xB5, 0x5F,
  0x61, 0x0B, 0x2D, 0x17, 0x99, 0x03, 0x25, 0x4F,
  0x51, 0x7B, 0x9D, 0x07, 0x89, 0x73, 0x95, 0x3F,
  0x41, 0xEB, 0x0D, 0xF7, 0x79, 0xE3, 0x05, 0x2F,
  0x31, 0x5B, 0x7D, 0xE7, 0x69, 0x53, 0x75, 0x1F,
  0x21, 0xCB, 0xED, 0xD7, 0x59, 0xC3, 0xE5, 0x0F,
  0x11, 0x3B, 0x5D, 0xC7, 0x49, 0x33, 0x55, 0xFF
};

void shr32(uint32_t *data, unsigned size)
{
#pragma unroll
  for (int j = 1; j < size; j++)
    data[j-1] = data[j];
  data[size-1] = 0;
}

void shl(uint32_t *data, unsigned size, unsigned bits)
{
  #pragma unroll
  for(int i = size-1; i > 0; i--)
    data[i] = (data[i] << bits) | (data[i-1] >> (32-bits));

  data[0] = data[0] << bits;
}

void shr(uint32_t *data, unsigned size, unsigned bits)
{
  #pragma unroll
  for(uint i = 0; i < size-1; i++)
    data[i] = (data[i] >> bits) | (data[i+1] << (32-bits));
  data[size-1] = data[size-1] >> bits;
}

uint32_t invert_limb(uint32_t limb)
{
  uint32_t inv = binvert_limb_table[(limb/2) & 0x7F];
  inv = 2*inv - inv*inv*limb;
  inv = 2*inv - inv*inv*limb;
  return -inv;
}

uint32_t getFromBitfield(const uint32_t *ptr, unsigned bitOffset, unsigned bitSize)
{
  union {
    uint2 v32;
    ulong v64;
  } data;

  unsigned lbitOffset = bitOffset & 0x1F;
  unsigned lLoLimb = bitOffset >> 5;
  unsigned lHiLimb = (bitOffset+bitSize) >> 5;
  data.v32.x = ptr[lLoLimb];
  data.v32.y = (lLoLimb == lHiLimb) ? 0 : ptr[lHiLimb];
  data.v32.x = lLoLimb == 0 ? data.v32.x - 1 : data.v32.x;
  return (data.v64 >> lbitOffset) & ((1 << bitSize) - 1);
}

void redcify352(unsigned shiftCount,
                const uint32_t *restrict quotient,
                const uint32_t *restrict limbs,
                uint32_t *result,
                uint32_t windowSize)
{
  uint32_t q[8];
  q[0] = quotient[0];
  q[1] = quotient[1];
  q[2] = quotient[2];
  q[3] = quotient[3];
  q[4] = quotient[4];
  q[5] = quotient[5];
  q[6] = quotient[6];
  q[7] = quotient[7];

  const unsigned pow2ws = pow2[windowSize];

  for (unsigned  i = 0, ie = (pow2ws-shiftCount)/32; i < ie; i++)
    shr32(q, 8);
  if ((pow2ws-shiftCount) % 32)
    shr(q, 8, (pow2ws-shiftCount) % 32);

  if (windowSize == 5)
    mulProductScan352to96(result, limbs, q);
  else if (windowSize == 6)
    mulProductScan352to128(result, limbs, q);
  else if (windowSize == 7)
    mulProductScan352to192(result, limbs, q);

  // substract 2^(384+shiftCount) - q*R
  for (unsigned i = 0; i < 11; i++)
    result[i] = ~result[i];
  result[0]++;
}

void FermatTest352(const uint32_t *restrict e, uint32_t *restrict redcl)
{
  const int windowSize = 7;
  uint32_t inverted = invert_limb(e[0]);
  uint32_t q[8] = {0, 0, 0, 0, 0, 0, 0, 0};
  int remaining = divide512to352reg(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                    e[0], e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8], e[9], e[10],
                    &q[0], &q[1], &q[2], &q[3], &q[4], &q[5], &q[6], &q[7]);
  remaining--;


  // Retrieve of "2" in Montgomery representation
  redcify352(1, q, e, redcl, windowSize);

  while (remaining > 0) {
    int size = min(remaining, windowSize);
    uint32_t index = getFromBitfield(e, remaining-size, size);

    uint32_t m[12];
    for (unsigned i = 0; i < size; i++)
      monSqr352(redcl, e, inverted);

    redcify352(index, q, e, m, windowSize);
    monMul352(redcl, m, e, inverted);
    remaining -= windowSize;
  }

  redcHalf352(redcl, e, inverted);
}

void redcify320(unsigned shiftCount,
                const uint32_t *restrict quotient,
                const uint32_t *restrict limbs,
                uint32_t *result,
                uint32_t windowSize)
{
  uint32_t q[8];
  q[0] = quotient[0];
  q[1] = quotient[1];
  q[2] = quotient[2];
  q[3] = quotient[3];
  q[4] = quotient[4];
  q[5] = quotient[5];
  q[6] = quotient[6];
  q[7] = quotient[7];

  const unsigned pow2ws = pow2[windowSize];
  for (unsigned  i = 0, ie = (pow2ws-shiftCount)/32; i < ie; i++)
    shr32(q, 8);
  if ((pow2ws-shiftCount) % 32)
    shr(q, 8, (pow2ws-shiftCount) % 32);

  if (windowSize == 5)
    mulProductScan320to96(result, limbs, q);
  else if (windowSize == 6)
    mulProductScan320to128(result, limbs, q);
  else if (windowSize == 7)
    mulProductScan320to192(result, limbs, q);

  // substract 2^(384+shiftCount) - q*R
  for (unsigned i = 0; i < 10; i++)
    result[i] = ~result[i];
  result[0]++;
}

void FermatTest320(const uint32_t *restrict e, uint32_t *restrict redcl)
{
  const int windowSize = 7;
  uint32_t inverted = invert_limb(e[0]);
  uint32_t q[8] = {0, 0, 0, 0, 0, 0, 0, 0};
  int remaining = divide480to320reg(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                    e[0], e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8], e[9],
                    &q[0], &q[1], &q[2], &q[3], &q[4], &q[5], &q[6], &q[7]);
  remaining--;

  // Retrieve of "2" in Montgomery representation
  redcify320(1, q, e, redcl, windowSize);

  while (remaining > 0) {
    int size = min(remaining, windowSize);
    uint32_t index = getFromBitfield(e, remaining-size, size);

    uint32_t m[12];
    for (unsigned i = 0; i < size; i++)
      monSqr320(redcl, e, inverted);
    redcify320(index, q, e, m, windowSize);
    monMul320(redcl, m, e, inverted);
    remaining -= windowSize;
  }

  redcHalf320(redcl, e, inverted);
}
