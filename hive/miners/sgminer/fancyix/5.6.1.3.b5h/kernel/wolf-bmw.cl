#ifndef WOLF_BMW_CL
#define WOLF_BMW_CL

// Wolf's BMW512, loosely based on SPH's implementation

#define CONST_EXP2  q[i+0] + FAST_ROTL64_LO(as_uint2(q[i+1]), 5)  + q[i+2] + FAST_ROTL64_LO(as_uint2(q[i+3]), 11) + \
                    q[i+4] + FAST_ROTL64_LO(as_uint2(q[i+5]), 27) + q[i+6] + as_ulong(as_uint2(q[i+7]).s10) + \
                    q[i+8] + FAST_ROTL64_HI(as_uint2(q[i+9]), 37) + q[i+10] + FAST_ROTL64_HI(as_uint2(q[i+11]), 43) + \
                    q[i+12] + FAST_ROTL64_HI(as_uint2(q[i+13]), 53) + (SHR(q[i+14],1) ^ q[i+14]) + (SHR(q[i+15],2) ^ q[i+15])

#define SHL(x, n) ((x) << (n))
#define SHR(x, n) ((x) >> (n))

#define s64_0(x)  (SHR((x), 1) ^ SHL((x), 3) ^ FAST_ROTL64_LO(as_uint2((x)),  4) ^ FAST_ROTL64_HI(as_uint2((x)), 37))
#define s64_1(x)  (SHR((x), 1) ^ SHL((x), 2) ^ FAST_ROTL64_LO(as_uint2((x)), 13) ^ FAST_ROTL64_HI(as_uint2((x)), 43))
#define s64_2(x)  (SHR((x), 2) ^ SHL((x), 1) ^ FAST_ROTL64_LO(as_uint2((x)), 19) ^ FAST_ROTL64_HI(as_uint2((x)), 53))
#define s64_3(x)  (SHR((x), 2) ^ SHL((x), 2) ^ FAST_ROTL64_LO(as_uint2((x)), 28) ^ FAST_ROTL64_HI(as_uint2((x)), 59))
#define s64_4(x)  (SHR((x), 1) ^ (x))
#define s64_5(x)  (SHR((x), 2) ^ (x))

#define r64_01(x) FAST_ROTL64_LO(as_uint2((x)),  5)
#define r64_02(x) FAST_ROTL64_LO(as_uint2((x)), 11)
#define r64_03(x) FAST_ROTL64_LO(as_uint2((x)), 27)
#define r64_04(x) (as_ulong(as_uint2((x)).s10))
#define r64_05(x) FAST_ROTL64_HI(as_uint2((x)), 37)
#define r64_06(x) FAST_ROTL64_HI(as_uint2((x)), 43)
#define r64_07(x) FAST_ROTL64_HI(as_uint2((x)), 53)

#define Q0	s64_0( (BMW_H[ 5] ^ msg[ 5])-(BMW_H[ 7] ^ msg[ 7])+(BMW_H[10] ^ msg[10])+(BMW_H[13] ^ msg[13])+(BMW_H[14] ^ msg[14])) + BMW_H[1]
#define Q1	s64_1( (BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 8] ^ msg[ 8])+(BMW_H[11] ^ msg[11])+(BMW_H[14] ^ msg[14])-(BMW_H[15] ^ msg[15])) + BMW_H[2]
#define Q2 	s64_2( (BMW_H[ 0] ^ msg[ 0])+(BMW_H[ 7] ^ msg[ 7])+(BMW_H[ 9] ^ msg[ 9])-(BMW_H[12] ^ msg[12])+(BMW_H[15] ^ msg[15])) + BMW_H[3]
#define Q3	s64_3( (BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 1] ^ msg[ 1])+(BMW_H[ 8] ^ msg[ 8])-(BMW_H[10] ^ msg[10])+(BMW_H[13] ^ msg[13])) + BMW_H[4]
#define Q4	s64_4( (BMW_H[ 1] ^ msg[ 1])+(BMW_H[ 2] ^ msg[ 2])+(BMW_H[ 9] ^ msg[ 9])-(BMW_H[11] ^ msg[11])-(BMW_H[14] ^ msg[14])) + BMW_H[5]
#define Q5	s64_0( (BMW_H[ 3] ^ msg[ 3])-(BMW_H[ 2] ^ msg[ 2])+(BMW_H[10] ^ msg[10])-(BMW_H[12] ^ msg[12])+(BMW_H[15] ^ msg[15])) + BMW_H[6]
#define Q6	s64_1( (BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 3] ^ msg[ 3])-(BMW_H[11] ^ msg[11])+(BMW_H[13] ^ msg[13])) + BMW_H[7]
#define Q7	s64_2( (BMW_H[ 1] ^ msg[ 1])-(BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 5] ^ msg[ 5])-(BMW_H[12] ^ msg[12])-(BMW_H[14] ^ msg[14])) + BMW_H[8]
#define Q8	s64_3( (BMW_H[ 2] ^ msg[ 2])-(BMW_H[ 5] ^ msg[ 5])-(BMW_H[ 6] ^ msg[ 6])+(BMW_H[13] ^ msg[13])-(BMW_H[15] ^ msg[15])) + BMW_H[9]
#define Q9	s64_4( (BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 3] ^ msg[ 3])+(BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 7] ^ msg[ 7])+(BMW_H[14] ^ msg[14])) + BMW_H[10]
#define Q10	s64_0( (BMW_H[ 8] ^ msg[ 8])-(BMW_H[ 1] ^ msg[ 1])-(BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 7] ^ msg[ 7])+(BMW_H[15] ^ msg[15])) + BMW_H[11]
#define Q11	s64_1( (BMW_H[ 8] ^ msg[ 8])-(BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 2] ^ msg[ 2])-(BMW_H[ 5] ^ msg[ 5])+(BMW_H[ 9] ^ msg[ 9])) + BMW_H[12]
#define Q12	s64_2( (BMW_H[ 1] ^ msg[ 1])+(BMW_H[ 3] ^ msg[ 3])-(BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 9] ^ msg[ 9])+(BMW_H[10] ^ msg[10])) + BMW_H[13]
#define Q13	s64_3( (BMW_H[ 2] ^ msg[ 2])+(BMW_H[ 4] ^ msg[ 4])+(BMW_H[ 7] ^ msg[ 7])+(BMW_H[10] ^ msg[10])+(BMW_H[11] ^ msg[11])) + BMW_H[14]
#define Q14	s64_4( (BMW_H[ 3] ^ msg[ 3])-(BMW_H[ 5] ^ msg[ 5])+(BMW_H[ 8] ^ msg[ 8])-(BMW_H[11] ^ msg[11])-(BMW_H[12] ^ msg[12])) + BMW_H[15]
#define Q15	s64_0( (BMW_H[12] ^ msg[12])-(BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 9] ^ msg[ 9])+(BMW_H[13] ^ msg[13])) + BMW_H[0]

#if 0
ulong BMW_Expand1(uint i, const ulong *restrict msg, const ulong *restrict q, __constant const ulong *restrict h)
#else
ulong BMW_Expand1(uint i, const ulong *restrict msg, const ulong *restrict q, const ulong *restrict h)
#endif
{
	return ( s64_1(q[i - 16])          + s64_2(q[i - 15])   + s64_3(q[i - 14]  ) + s64_0(q[i - 13] ) \
           + s64_1(q[i - 12])          + s64_2(q[i - 11])   + s64_3(q[i - 10]  ) + s64_0(q[i -  9] ) \
		   + s64_1(q[i -  8])          + s64_2(q[i -  7])   + s64_3(q[i -  6]  ) + s64_0(q[i -  5] ) \
		   + s64_1(q[i -  4])          + s64_2(q[i -  3])   + s64_3(q[i -  2]  ) + s64_0(q[i -  1] ) \
		   + ((i*(0x0555555555555555ull) + FAST_ROTL64_LO(as_uint2(msg[i - 16]), ((i - 16) + 1)) + FAST_ROTL64_LO(as_uint2(msg[(i-13)]), ((i - 13) + 1)) - FAST_ROTL64_LO(as_uint2(msg[i - 6]), ((i - 6) + 1))) ^ h[((i - 16) + 7)]));
}
#if 0
ulong BMW_Expand2(uint i, const ulong *restrict msg, const ulong *restrict q, __constant const ulong *restrict h)
#else
ulong BMW_Expand2(uint i, const ulong *restrict msg, const ulong *restrict q, const ulong *restrict h)
#endif
{
	return ( q[i - 16] + r64_01(q[i - 15])  + q[i - 14] + r64_02(q[i - 13]) + \
                    q[i - 12] + r64_03(q[i - 11]) + q[i - 10] + r64_04(q[i - 9]) + \
                    q[i - 8] + r64_05(q[i - 7]) + q[i - 6] + r64_06(q[i - 5]) + \
                    q[i - 4] + r64_07(q[i - 3]) + s64_4(q[i - 2]) + s64_5(q[i - 1]) + \
		   ((i*(0x0555555555555555ull) + FAST_ROTL64_LO(as_uint2(msg[i - 16]), (i - 16) + 1) + FAST_ROTL64_LO(as_uint2(msg[(i - 13) & 15]), ((i - 13) & 15) + 1) - FAST_ROTL64_LO(as_uint2(msg[(i - 6) & 15]), ((i - 6) & 15) + 1)) ^ h[((i - 16) + 7) & 15]));
}

#if 0
void BMW_Compression(ulong *restrict msg, __constant const ulong *restrict BMW_H)
#else
void BMW_Compression(ulong *restrict msg, const ulong *restrict BMW_H)
#endif
{
	ulong q[32];
	
	q[ 0] = s64_0( (BMW_H[ 5] ^ msg[ 5])-(BMW_H[ 7] ^ msg[ 7])+(BMW_H[10] ^ msg[10])+(BMW_H[13] ^ msg[13])+(BMW_H[14] ^ msg[14])) + BMW_H[1];
	q[ 1] = s64_1( (BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 8] ^ msg[ 8])+(BMW_H[11] ^ msg[11])+(BMW_H[14] ^ msg[14])-(BMW_H[15] ^ msg[15])) + BMW_H[2];
	q[ 2] = s64_2( (BMW_H[ 0] ^ msg[ 0])+(BMW_H[ 7] ^ msg[ 7])+(BMW_H[ 9] ^ msg[ 9])-(BMW_H[12] ^ msg[12])+(BMW_H[15] ^ msg[15])) + BMW_H[3];
	q[ 3] = s64_3( (BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 1] ^ msg[ 1])+(BMW_H[ 8] ^ msg[ 8])-(BMW_H[10] ^ msg[10])+(BMW_H[13] ^ msg[13])) + BMW_H[4];
	q[ 4] = s64_4( (BMW_H[ 1] ^ msg[ 1])+(BMW_H[ 2] ^ msg[ 2])+(BMW_H[ 9] ^ msg[ 9])-(BMW_H[11] ^ msg[11])-(BMW_H[14] ^ msg[14])) + BMW_H[5];
	q[ 5] = s64_0( (BMW_H[ 3] ^ msg[ 3])-(BMW_H[ 2] ^ msg[ 2])+(BMW_H[10] ^ msg[10])-(BMW_H[12] ^ msg[12])+(BMW_H[15] ^ msg[15])) + BMW_H[6];
	q[ 6] = s64_1( (BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 3] ^ msg[ 3])-(BMW_H[11] ^ msg[11])+(BMW_H[13] ^ msg[13])) + BMW_H[7];
	q[ 7] = s64_2( (BMW_H[ 1] ^ msg[ 1])-(BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 5] ^ msg[ 5])-(BMW_H[12] ^ msg[12])-(BMW_H[14] ^ msg[14])) + BMW_H[8];
	q[ 8] = s64_3( (BMW_H[ 2] ^ msg[ 2])-(BMW_H[ 5] ^ msg[ 5])-(BMW_H[ 6] ^ msg[ 6])+(BMW_H[13] ^ msg[13])-(BMW_H[15] ^ msg[15])) + BMW_H[9];
	q[ 9] = s64_4( (BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 3] ^ msg[ 3])+(BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 7] ^ msg[ 7])+(BMW_H[14] ^ msg[14])) + BMW_H[10];
	q[10] = s64_0( (BMW_H[ 8] ^ msg[ 8])-(BMW_H[ 1] ^ msg[ 1])-(BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 7] ^ msg[ 7])+(BMW_H[15] ^ msg[15])) + BMW_H[11];
	q[11] = s64_1( (BMW_H[ 8] ^ msg[ 8])-(BMW_H[ 0] ^ msg[ 0])-(BMW_H[ 2] ^ msg[ 2])-(BMW_H[ 5] ^ msg[ 5])+(BMW_H[ 9] ^ msg[ 9])) + BMW_H[12];
	q[12] = s64_2( (BMW_H[ 1] ^ msg[ 1])+(BMW_H[ 3] ^ msg[ 3])-(BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 9] ^ msg[ 9])+(BMW_H[10] ^ msg[10])) + BMW_H[13];
	q[13] = s64_3( (BMW_H[ 2] ^ msg[ 2])+(BMW_H[ 4] ^ msg[ 4])+(BMW_H[ 7] ^ msg[ 7])+(BMW_H[10] ^ msg[10])+(BMW_H[11] ^ msg[11])) + BMW_H[14];
	q[14] = s64_4( (BMW_H[ 3] ^ msg[ 3])-(BMW_H[ 5] ^ msg[ 5])+(BMW_H[ 8] ^ msg[ 8])-(BMW_H[11] ^ msg[11])-(BMW_H[12] ^ msg[12])) + BMW_H[15];
	q[15] = s64_0( (BMW_H[12] ^ msg[12])-(BMW_H[ 4] ^ msg[ 4])-(BMW_H[ 6] ^ msg[ 6])-(BMW_H[ 9] ^ msg[ 9])+(BMW_H[13] ^ msg[13])) + BMW_H[0];
	
	#if defined(QUARKCOIN_CL) && defined(__Tahiti__)
	#pragma unroll
	#else
	#pragma unroll
	#endif
	for(int i = 0; i < 16; ++i) q[i + 16] = (i < 2) ? BMW_Expand1(i + 16, msg, q, BMW_H) : BMW_Expand2(i + 16, msg, q, BMW_H);
			
	const ulong XL64 = q[16]^q[17]^q[18]^q[19]^q[20]^q[21]^q[22]^q[23];
	const ulong XH64 = XL64^q[24]^q[25]^q[26]^q[27]^q[28]^q[29]^q[30]^q[31];
		
	msg[0] = (SHL(XH64, 5) ^ SHR(q[16],5) ^ msg[0]) + ( XL64 ^ q[24] ^ q[0]);
	msg[1] = (SHR(XH64, 7) ^ SHL(q[17],8) ^ msg[1]) + ( XL64 ^ q[25] ^ q[1]);
	msg[2] = (SHR(XH64, 5) ^ SHL(q[18],5) ^ msg[2]) + ( XL64 ^ q[26] ^ q[2]);
	msg[3] = (SHR(XH64, 1) ^ SHL(q[19],5) ^ msg[3]) + ( XL64 ^ q[27] ^ q[3]);
	msg[4] = (SHR(XH64, 3) ^ q[20] ^ msg[4]) + ( XL64 ^ q[28] ^ q[4]);
	msg[5] = (SHL(XH64, 6) ^ SHR(q[21],6) ^ msg[5]) + ( XL64 ^ q[29] ^ q[5]);
	msg[6] = (SHR(XH64, 4) ^ SHL(q[22],6) ^ msg[6]) + ( XL64 ^ q[30] ^ q[6]);
	msg[7] = (SHR(XH64,11) ^ SHL(q[23],2) ^ msg[7]) + ( XL64 ^ q[31] ^ q[7]);

	msg[8] = FAST_ROTL64_LO(as_uint2(msg[4]), 9) + ( XH64 ^ q[24] ^ msg[8]) + (SHL(XL64,8) ^ q[23] ^ q[8]);
	msg[9] = FAST_ROTL64_LO(as_uint2(msg[5]),10) + ( XH64 ^ q[25] ^ msg[9]) + (SHR(XL64,6) ^ q[16] ^ q[9]);
	msg[10] = FAST_ROTL64_LO(as_uint2(msg[6]),11) + ( XH64 ^ q[26] ^ msg[10]) + (SHL(XL64,6) ^ q[17] ^ q[10]);
	msg[11] = FAST_ROTL64_LO(as_uint2(msg[7]),12) + ( XH64 ^ q[27] ^ msg[11]) + (SHL(XL64,4) ^ q[18] ^ q[11]);
	msg[12] = FAST_ROTL64_LO(as_uint2(msg[0]),13) + ( XH64 ^ q[28] ^ msg[12]) + (SHR(XL64,3) ^ q[19] ^ q[12]);
	msg[13] = FAST_ROTL64_LO(as_uint2(msg[1]),14) + ( XH64 ^ q[29] ^ msg[13]) + (SHR(XL64,4) ^ q[20] ^ q[13]);
	msg[14] = FAST_ROTL64_LO(as_uint2(msg[2]),15) + ( XH64 ^ q[30] ^ msg[14]) + (SHR(XL64,7) ^ q[21] ^ q[14]);
	msg[15] = FAST_ROTL64_LO(as_uint2(msg[3]),16) + ( XH64 ^ q[31] ^ msg[15]) + (SHR(XL64,2) ^ q[22] ^ q[15]);
}

static const __constant ulong BMW512_IV[16] =
{
	0x8081828384858687UL, 0x88898A8B8C8D8E8FUL, 0x9091929394959697UL, 0x98999A9B9C9D9E9FUL,
	0xA0A1A2A3A4A5A6A7UL, 0xA8A9AAABACADAEAFUL, 0xB0B1B2B3B4B5B6B7UL, 0xB8B9BABBBCBDBEBFUL,
	0xC0C1C2C3C4C5C6C7UL, 0xC8C9CACBCCCDCECFUL, 0xD0D1D2D3D4D5D6D7UL, 0xD8D9DADBDCDDDEDFUL,
	0xE0E1E2E3E4E5E6E7UL, 0xE8E9EAEBECEDEEEFUL, 0xF0F1F2F3F4F5F6F7UL, 0xF8F9FAFBFCFDFEFFUL
};

static const __constant ulong BMW512_FINAL[16] =
{
	0xAAAAAAAAAAAAAAA0UL, 0xAAAAAAAAAAAAAAA1UL, 0xAAAAAAAAAAAAAAA2UL, 0xAAAAAAAAAAAAAAA3UL,
	0xAAAAAAAAAAAAAAA4UL, 0xAAAAAAAAAAAAAAA5UL, 0xAAAAAAAAAAAAAAA6UL, 0xAAAAAAAAAAAAAAA7UL,
	0xAAAAAAAAAAAAAAA8UL, 0xAAAAAAAAAAAAAAA9UL, 0xAAAAAAAAAAAAAAAAUL, 0xAAAAAAAAAAAAAAABUL,
	0xAAAAAAAAAAAAAAACUL, 0xAAAAAAAAAAAAAAADUL, 0xAAAAAAAAAAAAAAAEUL, 0xAAAAAAAAAAAAAAAFUL
};

#endif
