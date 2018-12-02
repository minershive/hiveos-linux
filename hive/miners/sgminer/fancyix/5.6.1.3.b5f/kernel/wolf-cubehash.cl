#ifndef WOLF_CUBEHASH_CL
#define WOLF_CUBEHASH_CL

// CubeHash implementation helper functions by Wolf

#define CUBEHASH_FORCED_UNROLL
#define CUBEHASH_UNROLL_VALUE 

#if defined(__GCNMINC__)
uint amd_bitalign(uint src0, uint src1, uint src2)
{
    uint dest;
    __asm("shf.r.wrap.b32 %0, %2, %1, %3"
        : "=r"(dest)
        : "r"(src0), "r"(src1), "r"(src2));
    return dest;
}
#endif

#define ROTL32_x2(r,v,bits) \
{ \
    r.x = amd_bitalign(v.x, v.x, (uint)(32 - bits)); \
    r.y = amd_bitalign(v.y, v.y, (uint)(32 - bits)); \
}

void CubeHashEvenRound(uint *x)
{
	((uint16 *)x)[1] += ((uint16 *)x)[0];
	
	ROTL32_x2(((uint2 *)x)[0],((uint2 *)x)[0],7);
	ROTL32_x2(((uint2 *)x)[1],((uint2 *)x)[1],7);
	ROTL32_x2(((uint2 *)x)[2],((uint2 *)x)[2],7);
	ROTL32_x2(((uint2 *)x)[3],((uint2 *)x)[3],7);
	ROTL32_x2(((uint2 *)x)[4],((uint2 *)x)[4],7);
	ROTL32_x2(((uint2 *)x)[5],((uint2 *)x)[5],7);
	ROTL32_x2(((uint2 *)x)[6],((uint2 *)x)[6],7);
	ROTL32_x2(((uint2 *)x)[7],((uint2 *)x)[7],7);
	
	((uint8 *)x)[0] ^= ((uint8 *)x)[3];
	((uint8 *)x)[1] ^= ((uint8 *)x)[2];
	
	/*((uint2 *)x)[13] += ((uint2 *)x)[0];
	ROTL32_x2(((uint2 *)x)[0],((uint2 *)x)[0], 11);
	((uint2 *)x)[12] += ((uint2 *)x)[1];
	ROTL32_x2(((uint2 *)x)[1],((uint2 *)x)[1], 11);
	
	((uint2 *)x)[15] += ((uint2 *)x)[2];
	ROTL32_x2(((uint2 *)x)[2],((uint2 *)x)[2], 11);
	((uint2 *)x)[14] += ((uint2 *)x)[3];
	ROTL32_x2(((uint2 *)x)[3],((uint2 *)x)[3], 11);
	
	((uint2 *)x)[9] += ((uint2 *)x)[4];
	ROTL32_x2(((uint2 *)x)[4],((uint2 *)x)[4], 11);
	((uint2 *)x)[8] += ((uint2 *)x)[5];
	ROTL32_x2(((uint2 *)x)[5],((uint2 *)x)[5], 11);
	
	((uint2 *)x)[11] += ((uint2 *)x)[6];
	ROTL32_x2(((uint2 *)x)[6],((uint2 *)x)[6], 11);
	((uint2 *)x)[10] += ((uint2 *)x)[7];
	ROTL32_x2(((uint2 *)x)[7],((uint2 *)x)[7], 11);*/
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i)
	{
		const uchar y = (i < 8) ? 0 : 16;
		x[i + 26 - y] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 26 - y] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 22 - y] += x[i];
		x[i] = rotate(x[i], 11U);;
		++i;
		x[i + 22 - y] += x[i];
		x[i] = rotate(x[i], 11U);
	}
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i) x[i] ^= (i & 1) ? x[32 - i] : x[30 - i];
}

void CubeHashOddRound(uint *x)
{	
	((uint16 *)x)[1].sfedcba9876543210 += ((uint16 *)x)[0];
	
	ROTL32_x2(((uint2 *)x)[0],((uint2 *)x)[0],7);
	ROTL32_x2(((uint2 *)x)[1],((uint2 *)x)[1],7);
	ROTL32_x2(((uint2 *)x)[2],((uint2 *)x)[2],7);
	ROTL32_x2(((uint2 *)x)[3],((uint2 *)x)[3],7);
	ROTL32_x2(((uint2 *)x)[4],((uint2 *)x)[4],7);
	ROTL32_x2(((uint2 *)x)[5],((uint2 *)x)[5],7);
	ROTL32_x2(((uint2 *)x)[6],((uint2 *)x)[6],7);
	ROTL32_x2(((uint2 *)x)[7],((uint2 *)x)[7],7);
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i) x[i] ^= (i < 8) ? x[23 - i] : x[39 - i];
	
	/*((uint2 *)x)[10] += ((uint2 *)x)[0].yx;
	ROTL32_x2(((uint2 *)x)[0],((uint2 *)x)[0], 11);
	((uint2 *)x)[11] += ((uint2 *)x)[1].yx;
	ROTL32_x2(((uint2 *)x)[1],((uint2 *)x)[1], 11);
	
	((uint2 *)x)[8] += ((uint2 *)x)[2].yx;
	ROTL32_x2(((uint2 *)x)[2],((uint2 *)x)[2], 11);
	((uint2 *)x)[9] += ((uint2 *)x)[3].yx;
	ROTL32_x2(((uint2 *)x)[3],((uint2 *)x)[3], 11);
	
	((uint2 *)x)[14] += ((uint2 *)x)[4].yx;
	ROTL32_x2(((uint2 *)x)[4],((uint2 *)x)[4], 11);
	((uint2 *)x)[15] += ((uint2 *)x)[5].yx;
	ROTL32_x2(((uint2 *)x)[5],((uint2 *)x)[5], 11);
	
	((uint2 *)x)[12] += ((uint2 *)x)[6].yx;
	ROTL32_x2(((uint2 *)x)[6],((uint2 *)x)[6], 11);
	((uint2 *)x)[13] += ((uint2 *)x)[7].yx;
	ROTL32_x2(((uint2 *)x)[7],((uint2 *)x)[7], 11);*/
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i)
	{
		const uchar y = (i < 8) ? 0 : 16;
		x[21 - i + y] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[21 - i + y] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[25 - i + y] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[25 - i + y] += x[i];
		x[i] = rotate(x[i], 11U);
	}
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i)
	{
		const char y = (i & 1) ? -1 : 1;
		x[i + y] ^= x[i + 16];
	}
}

#endif
