#ifndef WOLF_SHAVITE_CL
#define WOLF_SHAVITE_CL

uint4 Shavite_AES_4Round(const __local uint *AES0, const __local uint *AES1, const __local uint *AES2, const __local uint *AES3, uint4 X, const uint4 *keys, const uint4 keylast)
{
	uint4 Y;
	
	#pragma unroll
	for(int i = 0; i < 4; ++i)
	{
		Y.s0 = AES0[((uchar)(X.s0))] ^ AES1[as_uchar4(X.s1).s1] ^ AES2[as_uchar4(X.s2).s2] ^ AES3[as_uchar4(X.s3).s3];
		Y.s1 = AES0[((uchar)(X.s1))] ^ AES1[as_uchar4(X.s2).s1] ^ AES2[as_uchar4(X.s3).s2] ^ AES3[as_uchar4(X.s0).s3];
		Y.s2 = AES0[((uchar)(X.s2))] ^ AES1[as_uchar4(X.s3).s1] ^ AES2[as_uchar4(X.s0).s2] ^ AES3[as_uchar4(X.s1).s3];
		Y.s3 = AES0[((uchar)(X.s3))] ^ AES1[as_uchar4(X.s0).s1] ^ AES2[as_uchar4(X.s1).s2] ^ AES3[as_uchar4(X.s2).s3];
		X = Y ^ ((i != 3) ? keys[i] : keylast);
	}
    return(X);
}

uint4 Shavite_Key_Expand(const __local uint *AES0, const __local uint *AES1, const __local uint *AES2, const __local uint *AES3, const uint4 X, const uint4 key)
{
	uint4 Y;
	Y.s0 = AES0[((uchar)(X.s0))] ^ AES1[as_uchar4(X.s1).s1] ^ AES2[as_uchar4(X.s2).s2] ^ AES3[as_uchar4(X.s3).s3];
    Y.s1 = AES0[((uchar)(X.s1))] ^ AES1[as_uchar4(X.s2).s1] ^ AES2[as_uchar4(X.s3).s2] ^ AES3[as_uchar4(X.s0).s3];
    Y.s2 = AES0[((uchar)(X.s2))] ^ AES1[as_uchar4(X.s3).s1] ^ AES2[as_uchar4(X.s0).s2] ^ AES3[as_uchar4(X.s1).s3];
    Y.s3 = AES0[((uchar)(X.s3))] ^ AES1[as_uchar4(X.s0).s1] ^ AES2[as_uchar4(X.s1).s2] ^ AES3[as_uchar4(X.s2).s3];
    Y = shuffle(Y, (uint4)(1, 2, 3, 0)) ^ key;
    return(Y);
}

#endif
