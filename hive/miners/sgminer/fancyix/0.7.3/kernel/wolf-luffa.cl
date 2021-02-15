#ifndef WOLF_LUFFA_CL
#define WOLF_LUFFA_CL

// Macros and helper functions for Luffa by Wolf

#define RC_0_0		(uint2)(0x303994A6U, 0xE0337818U)
#define RC_0_1		(uint2)(0xC0E65299U, 0x441BA90DU)
#define RC_0_2		(uint2)(0x6CC33A12U, 0x7F34D442U)
#define RC_0_3		(uint2)(0xDC56983EU, 0x9389217FU)
#define RC_0_4		(uint2)(0x1E00108FU, 0xE5A8BCE6U)
#define RC_0_5		(uint2)(0x7800423DU, 0x5274BAF4U)
#define RC_0_6		(uint2)(0x8F5B7882U, 0x26889BA7U)
#define RC_0_7		(uint2)(0x96E1DB12U, 0x9A226E9DU)

#define RC_1_0		(uint2)(0xB6DE10EDU, 0x01685F3DU)
#define RC_1_1		(uint2)(0x70F47AAEU, 0x05A17CF4U)
#define RC_1_2		(uint2)(0x0707A3D4U, 0xBD09CACAU)
#define RC_1_3		(uint2)(0x1C1E8F51U, 0xF4272B28U)
#define RC_1_4		(uint2)(0x707A3D45U, 0x144AE5CCU)
#define RC_1_5		(uint2)(0xAEB28562U, 0xFAA7AE2BU)
#define RC_1_6		(uint2)(0xBACA1589U, 0x2E48F1C1U)
#define RC_1_7		(uint2)(0x40A46F3EU, 0xB923C704U)

#define RC_2_0		(uint2)(0xFC20D9D2U, 0xE25E72C1U)
#define RC_2_1		(uint2)(0x34552E25U, 0xE623BB72U)
#define RC_2_2		(uint2)(0x7AD8818FU, 0x5C58A4A4U)
#define RC_2_3		(uint2)(0x8438764AU, 0x1E38E2E7U)
#define RC_2_4		(uint2)(0xBB6DE032U, 0x78E38B9DU)
#define RC_2_5		(uint2)(0xEDB780C8U, 0x27586719U)
#define RC_2_6		(uint2)(0xD9847356U, 0x36EDA57FU)
#define RC_2_7		(uint2)(0xA2C78434U, 0x703AACE7U)

#define RC_3_0		(uint2)(0xB213AFA5U, 0xE028C9BFU)
#define RC_3_1		(uint2)(0xC84EBE95U, 0x44756F91U)
#define RC_3_2		(uint2)(0x4E608A22U, 0x7E8FCE32U)
#define RC_3_3		(uint2)(0x56D858FEU, 0x956548BEU)
#define RC_3_4		(uint2)(0x343B138FU, 0xFE191BE2U)
#define RC_3_5		(uint2)(0xD0EC4E3DU, 0x3CB226E5U)
#define RC_3_6		(uint2)(0x2CEB4882U, 0x5944A28EU)
#define RC_3_7		(uint2)(0xB3AD2208U, 0xA1C4C355U)

#define RC_4_0		(uint2)(0xF0D2E9E3U, 0x5090D577U)
#define RC_4_1		(uint2)(0xAC11D7FAU, 0x2D1925ABU)
#define RC_4_2		(uint2)(0x1BCB66F2U, 0xB46496ACU)
#define RC_4_3		(uint2)(0x6F2D9BC9U, 0xD1925AB0U)
#define RC_4_4		(uint2)(0x78602649U, 0x29131AB6U)
#define RC_4_5		(uint2)(0x8EDAE952U, 0x0FC053C3U)
#define RC_4_6		(uint2)(0x3B6BA548U, 0x3F014F0CU)
#define RC_4_7		(uint2)(0xEDAE9520U, 0xFC053C31U)

static const __constant uint2 LUFFA_RC[5][8] = 
{
	{
		(uint2)(0x303994A6U, 0xE0337818U), (uint2)(0xC0E65299U, 0x441BA90DU), (uint2)(0x6CC33A12U, 0x7F34D442U), (uint2)(0xDC56983EU, 0x9389217FU),
		(uint2)(0x1E00108FU, 0xE5A8BCE6U), (uint2)(0x7800423DU, 0x5274BAF4U), (uint2)(0x8F5B7882U, 0x26889BA7U), (uint2)(0x96E1DB12U, 0x9A226E9DU)
	},
	{
		(uint2)(0xB6DE10EDU, 0x01685F3DU), (uint2)(0x70F47AAEU, 0x05A17CF4U), (uint2)(0x0707A3D4U, 0xBD09CACAU), (uint2)(0x1C1E8F51U, 0xF4272B28U),
		(uint2)(0x707A3D45U, 0x144AE5CCU), (uint2)(0xAEB28562U, 0xFAA7AE2BU), (uint2)(0xBACA1589U, 0x2E48F1C1U), (uint2)(0x40A46F3EU, 0xB923C704U)
	},
	{
		(uint2)(0xFC20D9D2U, 0xE25E72C1U), (uint2)(0x34552E25U, 0xE623BB72U), (uint2)(0x7AD8818FU, 0x5C58A4A4U), (uint2)(0x8438764AU, 0x1E38E2E7U),
		(uint2)(0xBB6DE032U, 0x78E38B9DU), (uint2)(0xEDB780C8U, 0x27586719U), (uint2)(0xD9847356U, 0x36EDA57FU), (uint2)(0xA2C78434U, 0x703AACE7U)
	},
	{
		(uint2)(0xB213AFA5U, 0xE028C9BFU), (uint2)(0xC84EBE95U, 0x44756F91U), (uint2)(0x4E608A22U, 0x7E8FCE32U), (uint2)(0x56D858FEU, 0x956548BEU),
		(uint2)(0x343B138FU, 0xFE191BE2U), (uint2)(0xD0EC4E3DU, 0x3CB226E5U), (uint2)(0x2CEB4882U, 0x5944A28EU), (uint2)(0xB3AD2208U, 0xA1C4C355U)
	},
	{
		(uint2)(0xF0D2E9E3U, 0x5090D577U), (uint2)(0xAC11D7FAU, 0x2D1925ABU), (uint2)(0x1BCB66F2U, 0xB46496ACU), (uint2)(0x6F2D9BC9U, 0xD1925AB0U),
		(uint2)(0x78602649U, 0x29131AB6U), (uint2)(0x8EDAE952U, 0x0FC053C3U), (uint2)(0x3B6BA548U, 0x3F014F0CU), (uint2)(0xEDAE9520U, 0xFC053C31U)
	}
};

//uint8 MulTwo(const uint8 a) { return((uint8)(a.s7, a.s0 ^ a.s7, a.s1, a.s2 ^ a.s7, a.s3 ^ a.s7, a.s4, a.s5, a.s6)); }
uint8 MulTwo(uint8 a)
{
	const uint4 tmp = (uint4)(a.s7, 0, a.s7, a.s7);
	a.s0123 ^= tmp;
	//a.s0 ^= a.s7;
	//a.s2 ^= a.s7;
	//a.s3 ^= a.s7;
	return(shuffle(a, (uint8)(7, 0, 1, 2, 3, 4, 5, 6)));
}

//void Tweak(uint8 *V, const uint i) { V[i].hi = rotate(V[i].hi, i); }

uint4 SubCrumb(uint4 v)
{
	uint temp = v.s0;
	v.s0 |= v.s1;
	v.s2 ^= v.s3;
	v.s1 = as_uint(~v.s1);
	v.s0 ^= v.s3;
	v.s3 &= temp;
	v.s1 ^= v.s3;
	v.s3 ^= v.s2;
	v.s2 &= v.s0;
	v.s0 = as_uint(~v.s0);
	v.s2 ^= v.s1;
	v.s1 |= v.s3;
	temp ^= v.s1;
	v.s3 ^= v.s2;
	v.s2 &= v.s1;
	v.s1 ^= v.s0;
	v.s0 = temp;
	return(v);
}

uint2 MixWord(uint2 v)
{
	v.y ^= v.x;
	v.x = rotate(v.x, 2U) ^ v.y;
	v.y = rotate(v.y, 14U) ^ v.x;
	v.x = rotate(v.x, 10U) ^ v.y;
	v.y = rotate(v.y, 1U);
	return(v);
}

// 4 = 5, 5 = 6, 6 = 7, 7 = 4

uint8 SubCrumbW(uint8 v)
{
	uint2 temp = v.s05;
	v.s05 |= v.s16;
	v.s27 ^= v.s34;
	v.s16 = as_uint2(~v.s16);
	v.s05 ^= v.s34;
	v.s34 &= temp;
	v.s16 ^= v.s34;
	v.s34 ^= v.s27;
	v.s27 &= v.s05;
	v.s05 = as_uint2(~v.s05);
	v.s27 ^= v.s16;
	v.s16 |= v.s34;
	temp ^= v.s16;
	v.s34 ^= v.s27;
	v.s27 &= v.s16;
	v.s16 ^= v.s05;
	v.s05 = temp;
	return(v);
}

uint8 SubCrumbWL(ulong4 v)
{
	ulong temp = v.s0;
	v.s0 |= v.s1;
	v.s2 ^= v.s3;
	v.s1 = as_ulong(~v.s1);
	v.s0 ^= v.s3;
	v.s3 &= temp;
	v.s1 ^= v.s3;
	v.s3 ^= v.s2;
	v.s2 &= v.s0;
	v.s0 = as_ulong(~v.s0);
	v.s2 ^= v.s1;
	v.s1 |= v.s3;
	temp ^= v.s1;
	v.s3 ^= v.s2;
	v.s2 &= v.s1;
	v.s1 ^= v.s0;
	v.s0 = temp;
	return(as_uint8(v));
}

uint4 MixWordW(uint4 in)
{
	uint2 lo = in.s01;
	uint2 hi = in.s23;
	
	hi ^= lo;
	lo = rotate(lo, 2U) ^ hi;
	hi = rotate(hi, 14U) ^ lo;
	lo = rotate(lo, 10U) ^ hi;
	hi = rotate(hi, 1U);
	return(shuffle2(lo, hi, (uint4)(0, 1, 2, 3)));
}

void MixWordWW(uint8 *in)
{	
	(*in).hi ^= (*in).lo;
	(*in).lo = rotate((*in).lo, 2U) ^ (*in).hi;
	(*in).hi = rotate((*in).hi, 14U) ^ (*in).lo;
	(*in).lo = rotate((*in).lo, 10U) ^ (*in).hi;
	(*in).hi = rotate((*in).hi, 1U);
}

// Constants must obviously be used with this
//#define LUFFA_RND(reg, p) \
	V[reg].lo    = SubCrumb(V[reg].lo); \
	V[reg].s5674 = SubCrumb(V[reg].s5674); \
	V[reg].s04 = MixWord(V[reg].s04); \
	V[reg].s15 = MixWord(V[reg].s15); \
	V[reg].s26 = MixWord(V[reg].s26); \
	V[reg].s37 = MixWord(V[reg].s37); \
	V[reg].s04 ^= RC_##reg##_##p

#if 1

#define LUFFA_RND(reg, p) \
	V[reg].lo    = SubCrumb(V[reg].lo); \
	V[reg].s5674 = SubCrumb(V[reg].s5674); \
	V[reg].s04 = MixWord(V[reg].s04); \
	V[reg].s15 = MixWord(V[reg].s15); \
	V[reg].s26 = MixWord(V[reg].s26); \
	V[reg].s37 = MixWord(V[reg].s37); \
	V[reg].s04 ^= LUFFA_RC[reg][p];

#elif 0

#define LUFFA_RND(reg, p) \
	V[reg] = SubCrumbW(V[reg]); \
	V[reg].s04 = MixWord(V[reg].s04) ^ RC_ ## reg ## _ ## p; \
	V[reg].s15 = MixWord(V[reg].s15); \
	V[reg].s2367 = MixWordW(V[reg].s2367);

#else

#define LUFFA_RND(reg, p) \
	V[reg].s05162734    = SubCrumbWL(as_ulong4(V[reg].s05162734)); \
	MixWordWW(&(V[reg])); \
	V[reg].s04 ^= LUFFA_RC[reg][p];

#endif
//#define LUFFA_RND(reg, p) \
	V[reg].s05162734    = SubCrumbWL(as_ulong4(V[reg].s05162734)); \
	V[reg].s04 = MixWord(V[reg].s04) ^ LUFFA_RC[reg][p]; \
	V[reg].s15 = MixWord(V[reg].s15); \
	V[reg].s26 = MixWord(V[reg].s26); \
	V[reg].s37 = MixWord(V[reg].s37);

//

#define LUFFA_RNDS() do { \
	LUFFA_RND(0, 0); \
	LUFFA_RND(0, 1); \
	LUFFA_RND(0, 2); \
	LUFFA_RND(0, 3); \
	LUFFA_RND(0, 4); \
	LUFFA_RND(0, 5); \
	LUFFA_RND(0, 6); \
	LUFFA_RND(0, 7); \
	\
	LUFFA_RND(1, 0); \
	LUFFA_RND(1, 1); \
	LUFFA_RND(1, 2); \
	LUFFA_RND(1, 3); \
	LUFFA_RND(1, 4); \
	LUFFA_RND(1, 5); \
	LUFFA_RND(1, 6); \
	LUFFA_RND(1, 7); \
	\
	LUFFA_RND(2, 0); \
	LUFFA_RND(2, 1); \
	LUFFA_RND(2, 2); \
	LUFFA_RND(2, 3); \
	LUFFA_RND(2, 4); \
	LUFFA_RND(2, 5); \
	LUFFA_RND(2, 6); \
	LUFFA_RND(2, 7); \
	\
	LUFFA_RND(3, 0); \
	LUFFA_RND(3, 1); \
	LUFFA_RND(3, 2); \
	LUFFA_RND(3, 3); \
	LUFFA_RND(3, 4); \
	LUFFA_RND(3, 5); \
	LUFFA_RND(3, 6); \
	LUFFA_RND(3, 7); \
	\
	LUFFA_RND(4, 0); \
	LUFFA_RND(4, 1); \
	LUFFA_RND(4, 2); \
	LUFFA_RND(4, 3); \
	LUFFA_RND(4, 4); \
	LUFFA_RND(4, 5); \
	LUFFA_RND(4, 6); \
	LUFFA_RND(4, 7); \
} while(0)

void MessageInj(uint8 *V, uint8 M)
{
	// Message Injection function MI for w=5, luffa specification pag 26.
	// If you take the specification and read the image "by column" you see this
	// can be thought as 4 steps:
	// 1) From input to first parallel XOR
	// 2) First "up" feistel to second parallel XOR
	// 3) Second "down" feistel to third parallel XOR
	// 4) XORring with (multiplied)
	const uint8 initial = MulTwo(V[0] ^ V[1] ^ V[2] ^ V[3] ^ V[4]);
	//uint8 tmp = V[0] ^= initial;
	V[0] ^= initial;
	V[1] ^= initial;
	V[2] ^= initial;
	V[3] ^= initial;
	V[4] ^= initial;
	
	uint8 tmp = V[0];
	
	V[0] = MulTwo(V[0]) ^ V[1];
	V[1] = MulTwo(V[1]) ^ V[2];
	V[2] = MulTwo(V[2]) ^ V[3];
	V[3] = MulTwo(V[3]) ^ V[4];
	V[4] = MulTwo(V[4]) ^ tmp;
	
	tmp = V[4];
	V[4] = MulTwo(tmp) ^ V[3];
	V[3] = MulTwo(V[3]) ^ V[2];
	V[2] = MulTwo(V[2]) ^ V[1];
	V[1] = MulTwo(V[1]) ^ V[0];
	V[0] = MulTwo(V[0]) ^ tmp;
	
	V[0] ^= M;    M = MulTwo(M);
	V[1] ^= M;    M = MulTwo(M);
	V[2] ^= M;    M = MulTwo(M);
	V[3] ^= M;    M = MulTwo(M);
	V[4] ^= M;
}

void LuffaPerm(uint8 *V)
{
	// Now the permutations. Those are 5 functions Qi, see page 13 for pseudocode.
	
	V[1].hi = rotate(V[1].hi, 1U);
	V[2].hi = rotate(V[2].hi, 2U);
	V[3].hi = rotate(V[3].hi, 3U);
	V[4].hi = rotate(V[4].hi, 4U);
	
	/*	
	//#ifdef __Hawaii__
	#if 0
	
	#pragma unroll
	for(int i = 0; i < 5; ++i)
	{
		#pragma unroll
		for(int x = 0; x < 8; ++x)
		{
			LUFFA_RND(i, x);
		}
	}
	
	#else
	
	LUFFA_RNDS();
	
	#endif*/
	
	for(int reg = 0; reg < 5; ++reg)
	{
		for(int p = 0; p < 8; ++p)
		{
			V[reg].lo    = SubCrumb(V[reg].lo);
			V[reg].s5674 = SubCrumb(V[reg].s5674);
			V[reg].s04 = MixWord(V[reg].s04);
			V[reg].s15 = MixWord(V[reg].s15);
			V[reg].s26 = MixWord(V[reg].s26);
			V[reg].s37 = MixWord(V[reg].s37);
			V[reg].s04 ^= LUFFA_RC[reg][p];
		}
	}
}

static const __constant uint8 LUFFA_INIT_CONSTS[5] =
{
	(uint8)(0x6D251E69U, 0x44B051E0U, 0x4EAA6FB4U, 0xDBF78465U, 0x6E292011U, 0x90152DF4U, 0xEE058139U, 0xDEF610BBU),
	(uint8)(0xC3B44B95U, 0xD9D2F256U, 0x70EEE9A0U, 0xDE099FA3U, 0x5D9B0557U, 0x8FC944B3U, 0xCF1CCF0EU, 0x746CD581U),
	(uint8)(0xF7EFC89DU, 0x5DBA5781U, 0x04016CE5U, 0xAD659C05U, 0x0306194FU, 0x666D1836U, 0x24AA230AU, 0x8B264AE7U),
	(uint8)(0x858075D5U, 0x36D79CCEU, 0xE571F7D7U, 0x204B1F67U, 0x35870C6AU, 0x57E9E923U, 0x14BCB808U, 0x7CDE72CEU),
	(uint8)(0x6C68E9BEU, 0x5EC41E22U, 0xC825B7C7U, 0xAFFB4363U, 0xF5DF3999U, 0x0FC688F1U, 0xB07224CCU, 0x03E86CEAU)
};

#endif
