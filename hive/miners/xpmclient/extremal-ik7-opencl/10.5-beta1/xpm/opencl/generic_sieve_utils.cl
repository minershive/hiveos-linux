/*
 * sieve.cl
 *
 *  Created on: 18.12.2013
 *      Author: mad
 */

#include "generic_config_kernel.h"

uint32_t mod32(uint32_t *data, unsigned size, uint32_t *modulos, uint32_t divisor)
{
  uint64_t acc = data[0];
  for (unsigned i = 1; i < size; i++)
    acc += (uint64_t)modulos[i-1] * (uint64_t)data[i];
  return acc % divisor;
}

uint int_invert(uint a, uint nPrime)
{
    // Extended Euclidean algorithm to calculate the inverse of a in finite field defined by nPrime
    int rem0 = nPrime, rem1 = a % nPrime, rem2;
    int aux0 = 0, aux1 = 1, aux2;
    int quotient, inverse;

    while (1)
    {
        if (rem1 <= 1)
        {
            inverse = aux1;
            break;
        }

        rem2 = rem0 % rem1;
        quotient = rem0 / rem1;
        aux2 = -quotient * aux1 + aux0;

        if (rem2 <= 1)
        {
            inverse = aux2;
            break;
        }

        rem0 = rem1 % rem2;
        quotient = rem1 / rem2;
        aux0 = -quotient * aux2 + aux1;

        if (rem0 <= 1)
        {
            inverse = aux0;
            break;
        }

        rem1 = rem2 % rem0;
        quotient = rem2 / rem0;
        aux1 = -quotient * aux0 + aux2;
    }

    return (inverse + nPrime) % nPrime;
}

__kernel void setup_sieve(  __global uint* offset1,
                            __global uint* offset2,
                            __global const uint* vPrimes,
                            __global uint* hash,
                            uint hashid,
                            __global uint *modulos)
{

  const uint id = get_global_id(0);
  const uint nPrime = vPrimes[id];

  uint tmp[N];
#pragma unroll
  for(int i = 0; i < N; ++i)
    tmp[i] = hash[hashid*N + i];

  uint localModulos[N-2];
#pragma unroll
  for (unsigned i = 0; i < N-2; i++)
    localModulos[i] = modulos[PCOUNT*i + id];
  const uint nFixedFactorMod = mod32(tmp, N-1, localModulos, nPrime);

  if(nFixedFactorMod == 0){
    for(uint line = 0; line < WIDTH; ++line){
      offset1[PCOUNT*line + id] = 0; //1u << 31;
      offset2[PCOUNT*line + id] = 0; //1u << 31;
    }
    return;

  }

  uint nFixedInverse = int_invert(nFixedFactorMod, nPrime);
  for(uint layer = 0; layer < WIDTH; ++layer) {
    offset1[PCOUNT*layer + id] = nFixedInverse;
    offset2[PCOUNT*layer + id] = nPrime - nFixedInverse;
    nFixedInverse = (nFixedInverse & 0x1) ?
    (nFixedInverse + nPrime) / 2 : nFixedInverse / 2;
  }
}

__kernel void s_sieve(	__global const uint* gsieve1,
            __global const uint* gsieve2,
            __global fermat_t* found320,
            __global fermat_t* found352,
            __global uint* fcount,
            uint hashid,
            uint hashSize,
            uint depth)
{
  const uint id = get_global_id(0);

  uint tmp1[WIDTH];
#pragma unroll
  for(int i = 0; i < WIDTH; ++i)
    tmp1[i] = gsieve1[SIZE*STRIPES/2*i + id];

#pragma unroll
  for(int start = 0; start <= WIDTH-TARGET; ++start){

    uint mask = 0;
#pragma unroll
    for(int line = 0; line < TARGET; ++line)
      mask |= tmp1[start+line];

    if(mask != 0xFFFFFFFF) {
      unsigned bit = 31-clz(~mask);
      unsigned multiplier = mad24(id, 32u, (unsigned)bit) + SIZE*32*STRIPES/2;
      unsigned maxSize = hashSize + (32-clz(multiplier)) + start + depth;
      const uint addr = atomic_inc(&fcount[(maxSize <= 320) ? 0 : 1]);
      __global fermat_t *found = (maxSize <= 320) ? found320 : found352;

      fermat_t info;
      info.index = multiplier;
      info.origin = start;
      info.chainpos = 0;
      info.type = 0;
      info.hashid = hashid;
      found[addr] = info;
    }
  }

  uint tmp2[WIDTH];
#pragma unroll
  for(int i = 0; i < WIDTH; ++i)
    tmp2[i] = gsieve2[SIZE*STRIPES/2*i + id];

#pragma unroll
  for(int start = 0; start <= WIDTH-TARGET; ++start){

    uint mask = 0;
#pragma unroll
    for(int line = 0; line < TARGET; ++line)
      mask |= tmp2[start+line];

    if(mask != 0xFFFFFFFF) {
      unsigned bit = 31-clz(~mask);
      unsigned multiplier = mad24(id, 32u, (unsigned)bit) + SIZE*32*STRIPES/2;
      unsigned maxSize = hashSize + (32-clz(multiplier)) + start + depth;
      const uint addr = atomic_inc(&fcount[(maxSize <= 320) ? 0 : 1]);
      __global fermat_t *found = (maxSize <= 320) ? found320 : found352;

      fermat_t info;
      info.index = multiplier;
      info.origin = start;
      info.chainpos = 0;
      info.type = 1;
      info.hashid = hashid;
      found[addr] = info;
    }
  }

  const unsigned bitwinLayers = (TARGET / 2) + (TARGET % 2);
#pragma unroll
  for(int i = 0; i < WIDTH; ++i)
    tmp2[i] |= tmp1[i];
#pragma unroll
  for(int start = 0; start <= WIDTH-bitwinLayers; ++start){

    uint mask = 0;
#pragma unroll
    for(int line = 0; line < TARGET/2; ++line)
      mask |= tmp2[start+line];

    if(TARGET & 1u)
      mask |= tmp1[start+TARGET/2];

    if(mask != 0xFFFFFFFF) {
      unsigned bit = 31-clz(~mask);
      unsigned multiplier = mad24(id, 32u, (unsigned)bit) + SIZE*32*STRIPES/2;
      unsigned maxSize = hashSize + (32-clz(multiplier)) + start + (depth/2) + (depth&1);
      const uint addr = atomic_inc(&fcount[(maxSize <= 320) ? 0 : 1]);
      __global fermat_t *found = (maxSize <= 320) ? found320 : found352;

      fermat_t info;
      info.index = multiplier;
      info.origin = start;
      info.chainpos = 0;
      info.type = 2;
      info.hashid = hashid;
      found[addr] = info;
    }
  }
}
