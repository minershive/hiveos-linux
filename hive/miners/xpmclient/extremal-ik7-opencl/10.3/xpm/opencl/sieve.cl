/*
 * sieve.cl
 *
 *  Created on: 18.12.2013
 *      Author: mad
 */

#define S1RUNS (sizeof(nps_all)/sizeof(uint))
#define NLIFO 6

__constant uint nps_all[] = { 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6 };

#if defined(__AMDVEGA)
__attribute__((reqd_work_group_size(LSIZE, 1, 1)))
__kernel void sieve(  __global uint* gsieve_all,
                      __global const uint* offset_all,
                      __global const uint2* primes)
{
  __local uint sieve[SIZE];

  const uint id = get_local_id(0);
  const uint stripe = get_group_id(0);
  const uint line = get_group_id(1);

  const uint entry = SIZE*32*(stripe+STRIPES/2);
  const float fentry = entry;

  __global const uint* offset = &offset_all[PCOUNT*line];

  for (uint i = id; i < SIZE; i += LSIZE)
    sieve[i] = 0;
  barrier(CLK_LOCAL_MEM_FENCE);

  uint poff = 0;

#pragma unroll
  for(int b = 0; b < S1RUNS; b++) {
    uint nps = nps_all[b];
    const uint var = LSIZE >> nps;
    const uint lpoff = id & (var-1);
    uint ip = id >> (LSIZELOG2-nps);

    const uint2 tmp1 = primes[poff+ip];
    const uint prime = tmp1.x;
    const float fiprime = as_float(tmp1.y);

    const uint loffset = offset[poff+ip];
    const uint orb = (loffset >> 31) ^ 0x1;
    uint pos = loffset & 0x7FFFFFFF;

    poff += 1u << nps;
    pos = mad24((uint)(fentry * fiprime), prime, pos) - entry;
    pos += ((int)pos < 0 ? prime : 0);
    pos = mad24(lpoff, prime, pos);

    uint4 vpos = {pos,
                  mad24(var, prime, pos),
                  mad24(var*2, prime, pos),
                  mad24(var*3, prime, pos)};

    if (var*4 >= 32) {
      __local uint32_t *s1 = &sieve[vpos.x >> 5];
      __local uint32_t *s2 = &sieve[vpos.y >> 5];
      __local uint32_t *s3 = &sieve[vpos.z >> 5];
      __local uint32_t *s4 = &sieve[vpos.w >> 5];
      __local uint32_t *se = &sieve[SIZE];
      uint32_t bit1 = orb << (vpos.x % 32);
      uint32_t bit2 = orb << (vpos.y % 32);
      uint32_t bit3 = orb << (vpos.z % 32);
      uint32_t bit4 = orb << (vpos.w % 32);
      const uint32_t add = var*4*prime >> 5;
      while (s4 < se) {
        atomic_or(s1, bit1);
        atomic_or(s2, bit2);
        atomic_or(s3, bit3);
        atomic_or(s4, bit4);
        s1 += add;
        s2 += add;
        s3 += add;
        s4 += add;
      }

      if (s1 < se)
        atomic_or(s1, bit1);
      if (s2 < se)
        atomic_or(s2, bit2);
      if (s3 < se)
        atomic_or(s3, bit3);
    } else {
      const uint add = var*4*prime;
      while (vpos.w < SIZE*32) {
        uint4 bit = (uint4){orb, orb, orb, orb} << vpos;
        uint4 offset = vpos >> 5;
        atomic_or(&sieve[offset.x], bit.x);
        atomic_or(&sieve[offset.y], bit.y);
        atomic_or(&sieve[offset.z], bit.z);
        atomic_or(&sieve[offset.w], bit.w);
        vpos += add;
      }

      if (vpos.x < SIZE*32)
        atomic_or(&sieve[vpos.x >> 5], orb << vpos.x);
      if (vpos.y < SIZE*32)
        atomic_or(&sieve[vpos.y >> 5], orb << vpos.y);
      if (vpos.z < SIZE*32)
        atomic_or(&sieve[vpos.z >> 5], orb << vpos.z);
    }
  }

  __global const uint2* pprimes = &primes[id];
  __global const uint* poffset = &offset[id];
  __local uint8_t *sieve8 = (__local uint8_t*)sieve;

  uint plifo[NLIFO];
  uint fiplifo[NLIFO];
  uint olifo[NLIFO];

  for(int i = 0; i < NLIFO; ++i){
    pprimes += LSIZE;
    poffset += LSIZE;

    const uint2 tmp = *pprimes;
    plifo[i] = tmp.x;
    fiplifo[i] = tmp.y;
    olifo[i] = *poffset;
  }

  uint lpos = 0;

#pragma unroll
  for(uint ip = 1; ip < SIEVERANGE3; ++ip) {
    const uint prime = plifo[lpos];
    const float fiprime = as_float(fiplifo[lpos]);
    uint pos = olifo[lpos];

    pos = mad24((uint)(fentry * fiprime), prime, pos) - entry;
    pos += ((int)pos < 0 ? prime : 0);

    uint index = pos >> 5;

    if(ip < SIEVERANGE1){
      uint2 vpos = {pos,
                    mad24(1u, prime, pos)};

      const uint add = 2*prime;
      while (vpos.y < SIZE*32) {
        uint2 bit = (uint2){1u, 1u} << vpos;
        uint2 offset = vpos >> 5;
        atomic_or(&sieve[offset.x], bit.x);
        atomic_or(&sieve[offset.y], bit.y);
        vpos += add;
      }

      if (vpos.x < SIZE*32)
        atomic_or(&sieve[vpos.x >> 5], 1u << vpos.x);
    } else if (ip < SIEVERANGE2) {
      if(index < SIZE){
        atomic_or(&sieve[index], 1u << pos);
        pos += prime;
        index = pos >> 5;
        if(index < SIZE){
          atomic_or(&sieve[index], 1u << pos);
          pos += prime;
          index = pos >> 5;
          if(index < SIZE){
            atomic_or(&sieve[index], 1u << pos);
          }
        }
      }
    } else if(ip < SIEVERANGE3) {
      if(index < SIZE){
        atomic_or(&sieve[index], 1u << pos);
        pos += prime;
        index = pos >> 5;
        if(index < SIZE){
          atomic_or(&sieve[index], 1u << pos);
        }
      }
    } else {
      if(index < SIZE){
        atomic_or(&sieve[index], 1u << pos);
      }
    }

    if(ip+NLIFO < SCOUNT/LSIZE){
      pprimes += LSIZE;
      poffset += LSIZE;

      const uint2 tmp = *pprimes;
      plifo[lpos] = tmp.x;
      fiplifo[lpos] = tmp.y;
      olifo[lpos] = *poffset;
    }

    lpos++;
    lpos = lpos % NLIFO;
  }

#pragma unroll
  for(uint32_t ip = SIEVERANGE3; ip < SCOUNT/LSIZE; ++ip) {
    const uint32_t prime = plifo[lpos];
    const float fiprime = as_float(fiplifo[lpos]);
    uint32_t pos = olifo[lpos];

    pos = mad24((uint)(fentry * fiprime), prime, pos) - entry;
    pos += ((int)pos < 0 ? prime : 0);

    uint32_t index = pos >> 5;
    if(index < SIZE){
      atomic_or(&sieve[index], 1u << pos);
    }


    if(ip+NLIFO < SCOUNT/LSIZE){
      pprimes += LSIZE;
      poffset += LSIZE;

      const uint2 tmp = *pprimes;
      plifo[lpos] = tmp.x;
      fiplifo[lpos] = tmp.y;
      olifo[lpos] = *poffset;
    }

    lpos++;
    lpos = lpos % NLIFO;
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  __global uint *gsieve = &gsieve_all[SIZE*(STRIPES/2*line + stripe)];
  for (uint i = id; i < SIZE; i += LSIZE)
    gsieve[i] = sieve[i];
}

#else

__attribute__((reqd_work_group_size(LSIZE, 1, 1)))
__kernel void sieve(  __global uint* gsieve_all,
            __global const uint* offset_all,
            __global const uint2* primes)
{

  __local uint sieve[SIZE];

  const uint id = get_local_id(0);
  const uint stripe = get_group_id(0);
  const uint line = get_group_id(1);

  const uint entry = SIZE*32*(stripe+STRIPES/2);
  const float fentry = entry;

  __global const uint* offset = &offset_all[PCOUNT*line];

  for(uint i = 0; i < SIZE/LSIZE; ++i)
    sieve[i*LSIZE+id] = 0;
  barrier(CLK_LOCAL_MEM_FENCE);

  {
    uint lprime[2];
    float lfiprime[2];
    uint lpos[2];

    uint poff = 0;
    uint nps = nps_all[0];
    uint ip = id >> (LSIZELOG2-nps);

    const uint2 tmp1 = primes[poff+ip];
    lprime[0] = tmp1.x;
    lfiprime[0] = as_float(tmp1.y);
    lpos[0] = offset[poff+ip];

#pragma unroll
    for(int b = 0; b < S1RUNS; b++) {
      const uint var = LSIZE >> nps;
      const uint lpoff = id & (var-1);

      if (b < S1RUNS-1) {
        poff += 1u << nps;
        nps = nps_all[b+1];
        ip = id >> (LSIZELOG2-nps);

        const uint2 tmp2 = primes[poff+ip];
        lprime[(b+1)%2] = tmp2.x;
        lfiprime[(b+1)%2] = as_float(tmp2.y);
        lpos[(b+1)%2] = offset[poff+ip];
      }

      const uint prime = lprime[b%2];
      const float fiprime = lfiprime[b%2];
      uint pos = lpos[b%2];

      pos = mad24((uint)(fentry * fiprime), prime, pos) - entry;
      pos += ((int)pos < 0 ? prime : 0);
      pos = mad24(lpoff, prime, pos);

      uint32_t sieve32 = (uint32_t)sieve + pos;
      uint4 vpos = {sieve32,
                    mad24(var, prime, sieve32),
                    mad24(var*2, prime, sieve32),
                    mad24(var*3, prime, sieve32)};

      if (var*4 >= 32) {
        __local uint32_t *s1 = &sieve[vpos.x >> 5];
        __local uint32_t *s2 = &sieve[vpos.y >> 5];
        __local uint32_t *s3 = &sieve[vpos.z >> 5];
        __local uint32_t *s4 = &sieve[vpos.w >> 5];
        __local uint32_t *se = &sieve[SIZE];
        uint32_t bit1 = 1u << (vpos.x % 32);
        uint32_t bit2 = 1u << (vpos.y % 32);
        uint32_t bit3 = 1u << (vpos.z % 32);
        uint32_t bit4 = 1u << (vpos.w % 32);
        const uint32_t add = var*4*prime >> 5;
        while (s1 < se) {
          atomic_or(s1, bit1);
          atomic_or(s2, bit2);
          atomic_or(s3, bit3);
          atomic_or(s4, bit4);
          s1 += add;
          s2 += add;
          s3 += add;
          s4 += add;
        }
      } else {
        while (vpos.x < SIZE*32) {
          uint4 ptr = vpos >> 3;
          uint4 bit = (uint4){1u, 1u, 1u, 1u} << vpos;

          atomic_or((__local uint32_t*)ptr.x, bit.x);
          atomic_or((__local uint32_t*)ptr.y, bit.y);
          atomic_or((__local uint32_t*)ptr.z, bit.z);
          atomic_or((__local uint32_t*)ptr.w, bit.w);

          vpos = mad24(var*4, prime, vpos);
        }
      }
    }
  }

  __global const uint2* pprimes = &primes[id];
  __global const uint* poffset = &offset[id];
  __local uint8_t *sieve8 = (__local uint8_t*)sieve;

  uint plifo[NLIFO];
  uint fiplifo[NLIFO];
  uint olifo[NLIFO];

  for(int i = 0; i < NLIFO; ++i){
    pprimes += LSIZE;
    poffset += LSIZE;

    const uint2 tmp = *pprimes;
    plifo[i] = tmp.x;
    fiplifo[i] = tmp.y;
    olifo[i] = *poffset;
  }

  uint lpos = 0;

#pragma unroll
  for(uint ip = 1; ip < SIEVERANGE3; ++ip){
    const uint prime = plifo[lpos];
    const float fiprime = as_float(fiplifo[lpos]);
    uint pos = olifo[lpos];

    pos = mad24((uint)(fentry * fiprime), prime, pos) - entry;
    pos += ((int)pos < 0 ? prime : 0);

    if (ip < SIEVERANGE1) {
      while (pos < SIZE*32) {
        atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos); pos = mad24(1u, prime, pos);
        atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos); pos = mad24(1u, prime, pos);
        atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos); pos = mad24(1u, prime, pos);
        atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos); pos = mad24(1u, prime, pos);
      }
    } else if(ip < SIEVERANGE2) {
      atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos);
      pos += prime;
      atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos);
      pos += prime;
      atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos);
    } else if(ip < SIEVERANGE3) {
      atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos);
      pos += prime;
      atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos);
    }

    if(ip+NLIFO < SCOUNT/LSIZE){

      pprimes += LSIZE;
      poffset += LSIZE;

      const uint2 tmp = *pprimes;
      plifo[lpos] = tmp.x;
      fiplifo[lpos] = tmp.y;
      olifo[lpos] = *poffset;

    }

    lpos++;
    lpos = lpos % NLIFO;
  }

#pragma unroll
  for(uint ip = SIEVERANGE3; ip < SCOUNT/LSIZE; ++ip){

    const uint prime = plifo[lpos];
    const float fiprime = as_float(fiplifo[lpos]);
    uint pos = olifo[lpos];

    pos = mad24((uint)(fentry * fiprime), prime, pos) - entry;
    pos += ((int)pos < 0 ? prime : 0);

    atomic_or((__local uint32_t*)&sieve8[pos >> 3], 1u << pos);

    if(ip+NLIFO < SCOUNT/LSIZE){

      pprimes += LSIZE;
      poffset += LSIZE;

      const uint2 tmp = *pprimes;
      plifo[lpos] = tmp.x;
      fiplifo[lpos] = tmp.y;
      olifo[lpos] = *poffset;
    }

    lpos++;
    lpos = lpos % NLIFO;
  }

  barrier(CLK_LOCAL_MEM_FENCE);

  __global uint *gsieve = &gsieve_all[SIZE*(STRIPES/2*line + stripe)];
  for (uint i = id; i < SIZE; i += LSIZE)
    gsieve[i] = sieve[i];
}

#endif

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
