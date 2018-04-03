
// skein
	{
		sph_u64 h0 = SPH_C64(0x4903ADFF749C51CE), h1 = SPH_C64(0x0D95DE399746DF03), h2 = SPH_C64(0x8FD1934127C79BCE), h3 = SPH_C64(0x9A255629FF352CB1), h4 = SPH_C64(0x5DB62599DF6CA7B0), h5 = SPH_C64(0xEABE394CA9D5C3F4), h6 = SPH_C64(0x991112C71A75B523), h7 = SPH_C64(0xAE18A40B660FCC33);
		sph_u64 m0, m1, m2, m3, m4, m5, m6, m7;
		sph_u64 bcount = 0;

		m0 = SWAP8(hash.h8[0]);
		m1 = SWAP8(hash.h8[1]);
		m2 = SWAP8(hash.h8[2]);
		m3 = SWAP8(hash.h8[3]);
		m4 = SWAP8(hash.h8[4]);
		m5 = SWAP8(hash.h8[5]);
		m6 = SWAP8(hash.h8[6]);
		m7 = SWAP8(hash.h8[7]);
		UBI_BIG(480, 64);
		bcount = 0;
		m0 = m1 = m2 = m3 = m4 = m5 = m6 = m7 = 0;
		UBI_BIG(510, 8);


		hash.h8[0] = SWAP8(h0);
		hash.h8[1] = SWAP8(h1);
		hash.h8[2] = SWAP8(h2);
		hash.h8[3] = SWAP8(h3);
		hash.h8[4] = SWAP8(h4);
		hash.h8[5] = SWAP8(h5);
		hash.h8[6] = SWAP8(h6);
		hash.h8[7] = SWAP8(h7);

	}
