
// keccak
	{
		sph_u64 a00 = 0, a01 = 0, a02 = 0, a03 = 0, a04 = 0;
		sph_u64 a10 = 0, a11 = 0, a12 = 0, a13 = 0, a14 = 0;
		sph_u64 a20 = 0, a21 = 0, a22 = 0, a23 = 0, a24 = 0;
		sph_u64 a30 = 0, a31 = 0, a32 = 0, a33 = 0, a34 = 0;
		sph_u64 a40 = 0, a41 = 0, a42 = 0, a43 = 0, a44 = 0;

		a10 = SPH_C64(0xFFFFFFFFFFFFFFFF);
		a20 = SPH_C64(0xFFFFFFFFFFFFFFFF);
		a31 = SPH_C64(0xFFFFFFFFFFFFFFFF);
		a22 = SPH_C64(0xFFFFFFFFFFFFFFFF);
		a23 = SPH_C64(0xFFFFFFFFFFFFFFFF);
		a04 = SPH_C64(0xFFFFFFFFFFFFFFFF);

		a00 ^= SWAP8(hash.h8[0]);
		a10 ^= SWAP8(hash.h8[1]);
		a20 ^= SWAP8(hash.h8[2]);
		a30 ^= SWAP8(hash.h8[3]);
		a40 ^= SWAP8(hash.h8[4]);
		a01 ^= SWAP8(hash.h8[5]);
		a11 ^= SWAP8(hash.h8[6]);
		a21 ^= SWAP8(hash.h8[7]);
		a31 ^= 0x8000000000000001;
		KECCAK_F_1600;
		// Finalize the "lane complement"
		a10 = ~a10;
		a20 = ~a20;

		hash.h8[0] = SWAP8(a00);
		hash.h8[1] = SWAP8(a10);
		hash.h8[2] = SWAP8(a20);
		hash.h8[3] = SWAP8(a30);
		hash.h8[4] = SWAP8(a40);
		hash.h8[5] = SWAP8(a01);
		hash.h8[6] = SWAP8(a11);
		hash.h8[7] = SWAP8(a21);




	}
