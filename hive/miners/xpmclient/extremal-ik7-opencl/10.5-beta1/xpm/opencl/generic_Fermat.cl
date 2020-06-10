/*
 * fermat.cl
 *
 *  Created on: 26.12.2013
 *      Author: mad
 */

#include "generic_config_kernel.h"
#include "generic_Fermat_procs.h"

bool fermat352(const uint32_t *restrict p)
{
  uint32_t modpowl[11];
  FermatTest352(p, modpowl);
  
  uint32_t result = modpowl[0] - 1;
  result |= modpowl[1];
  result |= modpowl[2];
  result |= modpowl[3];
  result |= modpowl[4];
  result |= modpowl[5];
  result |= modpowl[6];
  result |= modpowl[7];
  result |= modpowl[8];
  result |= modpowl[9];
  result |= modpowl[10];  
  return result == 0;
}

bool fermat320(const uint32_t *restrict p)
{
  uint32_t modpowl[10];  
  FermatTest320(p, modpowl);
  
  uint32_t result = modpowl[0] - 1;
  result |= modpowl[1];
  result |= modpowl[2];
  result |= modpowl[3];
  result |= modpowl[4];
  result |= modpowl[5];
  result |= modpowl[6];
  result |= modpowl[7];
  result |= modpowl[8];
  result |= modpowl[9];
  return result == 0;  
}

__kernel void fermat_kernel(__global uchar *result,
                            __global const uint32_t *fprimes)
{
  const uint id = get_global_id(0);
  const uint gsize = get_global_size(0);  
  uint32_t e[11];
  
#pragma unroll
  for (unsigned i = 0; i < 11; i++)
    e[i] = fprimes[gsize*i + id];
  
  result[id] = fermat352(e);
}

__kernel void fermat_kernel320(__global uchar *result,
                               __global const uint32_t *fprimes)
{
  const uint id = get_global_id(0);
  const uint gsize = get_global_size(0);  
  uint32_t e[10];
  
#pragma unroll
  for (unsigned i = 0; i < 10; i++)
    e[i] = fprimes[gsize*i + id];  
  
  result[id] = fermat320(e);
}
