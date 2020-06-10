/*
 * fermat.cl
 *
 *  Created on: 26.12.2013
 *      Author: mad
 */

#include "generic_config_kernel.h"
#include "generic_Fermat_procs.h"

__kernel void setup_fermat(__global uint *fprimes,
                           __global const fermat_t *info_all,
                           __global uint *hash)
{
  const uint id = get_global_id(0);
  const uint gsize = get_global_size(0);
  const fermat_t info = info_all[id];
  
  uint h[11];
  uint m[11];

  __global uint *H = &hash[info.hashid*N]; 
#pragma unroll
  for (unsigned i = 0; i < 11; i++)
    h[i] = H[i];

  uint line = info.origin;
  if(info.type < 2)
    line += info.chainpos;
  else
    line += info.chainpos/2;

  uint modifier = (info.type == 1 || (info.type == 2 && (info.chainpos & 1))) ? 1 : -1;

  mulProductScan352to32(m, h, info.index);
  if (line)
    shl(m, 11, line);
  m[0] += modifier;
  
#pragma unroll
  for (unsigned i = 0; i < 11; i++)
    fprimes[gsize*i + id] = m[i];
}

__kernel void check_fermat(	__global fermat_t* info_out,
							__global uint* count,
							__global fermat_t* info_fin_out,
							__global uint* count_fin,
							__global const uchar* results,
							__global const fermat_t* info_in,
							uint depth )
{
	
	const uint id = get_global_id(0);
	
	if(results[id] == 1){
		
		fermat_t info = info_in[id];
		info.chainpos++;
		
		if(info.chainpos < depth){
			
			const uint i = atomic_inc(count);
			info_out[i] = info;
			
		}else{
			
			const uint i = atomic_inc(count_fin);
			info_fin_out[i] = info;
			
		}
		
	}
	
}

