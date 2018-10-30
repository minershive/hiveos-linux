#ifndef WOLF_SHABAL_CL
#define WOLF_SHABAL_CL

#define PERM_ELT(xa0, xa1, xb0, xb1, xb2, xb3, xc, xm)   do { \
		xa0 = (xa0 ^ (((xa1 << 15) | (xa1 >> 17)) * 5U) ^ xc) * 3U ^ xb1 ^ (xb2 & ~xb3) ^ xm; \
		xb0 = ~((rotate(xb0, 1U)) ^ xa0); \
	} while(0)

#define SHABAL_PERM_V	do { \
	PERM_ELT(A.s0, A.sb, B.s0, B.sd, B.s9, B.s6, C.s8, M.s0); \
	PERM_ELT(A.s1, A.s0, B.s1, B.se, B.sa, B.s7, C.s7, M.s1); \
	PERM_ELT(A.s2, A.s1, B.s2, B.sf, B.sb, B.s8, C.s6, M.s2); \
	PERM_ELT(A.s3, A.s2, B.s3, B.s0, B.sc, B.s9, C.s5, M.s3); \
	PERM_ELT(A.s4, A.s3, B.s4, B.s1, B.sd, B.sa, C.s4, M.s4); \
	PERM_ELT(A.s5, A.s4, B.s5, B.s2, B.se, B.sb, C.s3, M.s5); \
	PERM_ELT(A.s6, A.s5, B.s6, B.s3, B.sf, B.sc, C.s2, M.s6); \
	PERM_ELT(A.s7, A.s6, B.s7, B.s4, B.s0, B.sd, C.s1, M.s7); \
	PERM_ELT(A.s8, A.s7, B.s8, B.s5, B.s1, B.se, C.s0, M.s8); \
	PERM_ELT(A.s9, A.s8, B.s9, B.s6, B.s2, B.sf, C.sf, M.s9); \
	PERM_ELT(A.sa, A.s9, B.sa, B.s7, B.s3, B.s0, C.se, M.sa); \
	PERM_ELT(A.sb, A.sa, B.sb, B.s8, B.s4, B.s1, C.sd, M.sb); \
	PERM_ELT(A.s0, A.sb, B.sc, B.s9, B.s5, B.s2, C.sc, M.sc); \
	PERM_ELT(A.s1, A.s0, B.sd, B.sa, B.s6, B.s3, C.sb, M.sd); \
	PERM_ELT(A.s2, A.s1, B.se, B.sb, B.s7, B.s4, C.sa, M.se); \
	PERM_ELT(A.s3, A.s2, B.sf, B.sc, B.s8, B.s5, C.s9, M.sf); \
	\
	PERM_ELT(A.s4, A.s3, B.s0, B.sd, B.s9, B.s6, C.s8, M.s0); \
	PERM_ELT(A.s5, A.s4, B.s1, B.se, B.sa, B.s7, C.s7, M.s1); \
	PERM_ELT(A.s6, A.s5, B.s2, B.sf, B.sb, B.s8, C.s6, M.s2); \
	PERM_ELT(A.s7, A.s6, B.s3, B.s0, B.sc, B.s9, C.s5, M.s3); \
	PERM_ELT(A.s8, A.s7, B.s4, B.s1, B.sd, B.sa, C.s4, M.s4); \
	PERM_ELT(A.s9, A.s8, B.s5, B.s2, B.se, B.sb, C.s3, M.s5); \
	PERM_ELT(A.sa, A.s9, B.s6, B.s3, B.sf, B.sc, C.s2, M.s6); \
	PERM_ELT(A.sb, A.sa, B.s7, B.s4, B.s0, B.sd, C.s1, M.s7); \
	PERM_ELT(A.s0, A.sb, B.s8, B.s5, B.s1, B.se, C.s0, M.s8); \
	PERM_ELT(A.s1, A.s0, B.s9, B.s6, B.s2, B.sf, C.sF, M.s9); \
	PERM_ELT(A.s2, A.s1, B.sa, B.s7, B.s3, B.s0, C.sE, M.sa); \
	PERM_ELT(A.s3, A.s2, B.sb, B.s8, B.s4, B.s1, C.sD, M.sb); \
	PERM_ELT(A.s4, A.s3, B.sc, B.s9, B.s5, B.s2, C.sC, M.sc); \
	PERM_ELT(A.s5, A.s4, B.sd, B.sa, B.s6, B.s3, C.sB, M.sd); \
	PERM_ELT(A.s6, A.s5, B.se, B.sb, B.s7, B.s4, C.sA, M.se); \
	PERM_ELT(A.s7, A.s6, B.sf, B.sc, B.s8, B.s5, C.s9, M.sf); \
	\
	PERM_ELT(A.s8, A.s7, B.s0, B.sd, B.s9, B.s6, C.s8, M.s0); \
	PERM_ELT(A.s9, A.s8, B.s1, B.se, B.sa, B.s7, C.s7, M.s1); \
	PERM_ELT(A.sa, A.s9, B.s2, B.sf, B.sb, B.s8, C.s6, M.s2); \
	PERM_ELT(A.sb, A.sa, B.s3, B.s0, B.sc, B.s9, C.s5, M.s3); \
	PERM_ELT(A.s0, A.sb, B.s4, B.s1, B.sd, B.sa, C.s4, M.s4); \
	PERM_ELT(A.s1, A.s0, B.s5, B.s2, B.se, B.sb, C.s3, M.s5); \
	PERM_ELT(A.s2, A.s1, B.s6, B.s3, B.sf, B.sc, C.s2, M.s6); \
	PERM_ELT(A.s3, A.s2, B.s7, B.s4, B.s0, B.sd, C.s1, M.s7); \
	PERM_ELT(A.s4, A.s3, B.s8, B.s5, B.s1, B.se, C.s0, M.s8); \
	PERM_ELT(A.s5, A.s4, B.s9, B.s6, B.s2, B.sf, C.sF, M.s9); \
	PERM_ELT(A.s6, A.s5, B.sa, B.s7, B.s3, B.s0, C.sE, M.sa); \
	PERM_ELT(A.s7, A.s6, B.sb, B.s8, B.s4, B.s1, C.sD, M.sb); \
	PERM_ELT(A.s8, A.s7, B.sc, B.s9, B.s5, B.s2, C.sC, M.sc); \
	PERM_ELT(A.s9, A.s8, B.sd, B.sa, B.s6, B.s3, C.sB, M.sd); \
	PERM_ELT(A.sa, A.s9, B.se, B.sb, B.s7, B.s4, C.sA, M.se); \
	PERM_ELT(A.sb, A.sa, B.sf, B.sc, B.s8, B.s5, C.s9, M.sf); \
} while(0)
	
	
#define SWAP_BC_V	do { \
	uint16 tmp = B; \
	B = C; \
	C = tmp; \
} while(0)

#define SWAP_BC_V	B ^= C; C ^= B; B ^= C;

__constant static const uint A_init_512[] = {
	0x20728DFDU, 0x46C0BD53U, 0xE782B699U, 0x55304632U,
	0x71B4EF90U, 0x0EA9E82CU, 0xDBB930F1U, 0xFAD06B8BU,
	0xBE0CAE40U, 0x8BD14410U, 0x76D2ADACU, 0x28ACAB7FU
};

__constant static const uint B_init_512[] = {
	0xC1099CB7U, 0x07B385F3U, 0xE7442C26U, 0xCC8AD640U,
	0xEB6F56C7U, 0x1EA81AA9U, 0x73B9D314U, 0x1DE85D08U,
	0x48910A5AU, 0x893B22DBU, 0xC5A0DF44U, 0xBBC4324EU,
	0x72D2F240U, 0x75941D99U, 0x6D8BDE82U, 0xA1A7502BU
};

__constant static const uint C_init_512[] = {
	0xD9BF68D1U, 0x58BAD750U, 0x56028CB2U, 0x8134F359U,
	0xB5D469D8U, 0x941A8CC2U, 0x418B2A6EU, 0x04052780U,
	0x7F07D787U, 0x5194358FU, 0x3C60D665U, 0xBE97D79AU,
	0x950C3434U, 0xAED9A06DU, 0x2537DC8DU, 0x7CDB5969U
};

#endif
