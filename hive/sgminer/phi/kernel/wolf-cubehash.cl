#ifndef WOLF_CUBEHASH_CL
#define WOLF_CUBEHASH_CL

// CubeHash implementation helper functions by Wolf

#define CUBEHASH_FORCED_UNROLL
#define CUBEHASH_UNROLL_VALUE 

void CubeHashEvenRound(uint *x)
{
	((uint16 *)x)[1] += ((uint16 *)x)[0];
	((uint16 *)x)[0] = rotate(((uint16 *)x)[0], 7U);
	
	/*#pragma unroll
	for(int i = 0; i < 16; ++i)
	{
		x[i + 16] += x[i];
		x[i] = rotate(x[i], 7U);
	}*/
	
	/*#pragma unroll
	for(int i = 0; i < 16; ++i)
	{
		const uchar y = (i < 8) ? 24 : 8;
		x[i] ^= x[i + y];
	}*/
	
	//#pragma unroll
	//for(int i = 0; i < 8; ++i) x[i] ^= x[i + 24];
	
	((uint8 *)x)[0] ^= ((uint8 *)x)[3];
	((uint8 *)x)[1] ^= ((uint8 *)x)[2];
	
	//#pragma unroll
	//for(int i = 8; i < 16; ++i) x[i] ^= x[i + 8];
	
	/*//#pragma unroll
	for(int i = 0; i < 8; ++i)
	{
		x[i + 26] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 26] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 22] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 22] += x[i];
		x[i] = rotate(x[i], 11U);
	}
		
	//#pragma unroll
	for(int i = 8; i < 15; ++i)
	{
		x[i + 10] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 10] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 6] += x[i];
		x[i] = rotate(x[i], 11U);
		++i;
		x[i + 6] += x[i];
		x[i] = rotate(x[i], 11U);
	}*/
	
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
	//#pragma unroll
	/*for(int i = 0; i < 16; ++i)
	{
		x[i] ^= x[30 - i];
		++i;
		x[i] ^= x[32 - i];
	}*/
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i) x[i] ^= (i & 1) ? x[32 - i] : x[30 - i];
}

void CubeHashOddRound(uint *x)
{
	//#pragma unroll
	//for(int i = 0; i < 16; ++i)
	//{
	//	x[31 - i] += x[i];
	//	x[i] = rotate(x[i], 7U);
	//}
	
	((uint16 *)x)[1].sfedcba9876543210 += ((uint16 *)x)[0];
	((uint16 *)x)[0] = rotate(((uint16 *)x)[0], 7U);
	
	/*#pragma unroll
	for(int i = 0; i < 8; ++i) x[i] ^= x[23 - i];
	
	//#pragma unroll
	for(int i = 8; i < 16; ++i) x[i] ^= x[39 - i];*/
	
	#ifdef CUBEHASH_FORCED_UNROLL
	#pragma unroll CUBEHASH_UNROLL_VALUE
	#endif
	for(int i = 0; i < 16; ++i) x[i] ^= (i < 8) ? x[23 - i] : x[39 - i];
	
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
	
	//#pragma unroll
	/*for(int i = 16; i < 32; ++i)
	{
		x[i - 15] ^= x[i];
		++i;
		x[i - 17] ^= x[i];
	}*/
	
	// i = 16 - 1, i = 17 - 0, i = 18 - 3, i = 19 - 2
	// i = 0  - 1, i = 1  - 0, i = 2  - 3, i = 3  - 3
	/*for(int i = 0; i < 16; ++i)
	{
		x[i + 1] ^= x[i + 16];
		++i;
		x[i - 1] ^= x[i + 16];
	}*/
	
	//for(int i = 0; i < 16; i += 2) x[i + 1] ^= x[i + 16];
	//for(int i = 1; i < 16; i += 2) x[i - 1] ^= x[i + 16];
	
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
