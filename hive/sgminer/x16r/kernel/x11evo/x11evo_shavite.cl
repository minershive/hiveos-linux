

// shavite
	{
		// IV
		sph_u32 h0 = SPH_C32(0x72FCCDD8), h1 = SPH_C32(0x79CA4727), h2 = SPH_C32(0x128A077B), h3 = SPH_C32(0x40D55AEC);
		sph_u32 h4 = SPH_C32(0xD1901A06), h5 = SPH_C32(0x430AE307), h6 = SPH_C32(0xB29F5CD1), h7 = SPH_C32(0xDF07FBFC);
		sph_u32 h8 = SPH_C32(0x8E45D73D), h9 = SPH_C32(0x681AB538), hA = SPH_C32(0xBDE86578), hB = SPH_C32(0xDD577E47);
		sph_u32 hC = SPH_C32(0xE275EADE), hD = SPH_C32(0x502D9FCD), hE = SPH_C32(0xB9357178), hF = SPH_C32(0x022A4B9A);

		// state
		sph_u32 rk00, rk01, rk02, rk03, rk04, rk05, rk06, rk07;
		sph_u32 rk08, rk09, rk0A, rk0B, rk0C, rk0D, rk0E, rk0F;
		sph_u32 rk10, rk11, rk12, rk13, rk14, rk15, rk16, rk17;
		sph_u32 rk18, rk19, rk1A, rk1B, rk1C, rk1D, rk1E, rk1F;

		sph_u32 sc_count0 = (64 << 3), sc_count1 = 0, sc_count2 = 0, sc_count3 = 0;

		rk00 = hash.h4[0];
		rk01 = hash.h4[1];
		rk02 = hash.h4[2];
		rk03 = hash.h4[3];
		rk04 = hash.h4[4];
		rk05 = hash.h4[5];
		rk06 = hash.h4[6];
		rk07 = hash.h4[7];
		rk08 = hash.h4[8];
		rk09 = hash.h4[9];
		rk0A = hash.h4[10];
		rk0B = hash.h4[11];
		rk0C = hash.h4[12];
		rk0D = hash.h4[13];
		rk0E = hash.h4[14];
		rk0F = hash.h4[15];
		rk10 = 0x80;
		rk11 = rk12 = rk13 = rk14 = rk15 = rk16 = rk17 = rk18 = rk19 = rk1A = 0;
		rk1B = 0x2000000;
		rk1C = rk1D = rk1E = 0;
		rk1F = 0x2000000;

		c512(buf);

		hash.h4[0] = h0;
		hash.h4[1] = h1;
		hash.h4[2] = h2;
		hash.h4[3] = h3;
		hash.h4[4] = h4;
		hash.h4[5] = h5;
		hash.h4[6] = h6;
		hash.h4[7] = h7;
		hash.h4[8] = h8;
		hash.h4[9] = h9;
		hash.h4[10] = hA;
		hash.h4[11] = hB;
		hash.h4[12] = hC;
		hash.h4[13] = hD;
		hash.h4[14] = hE;
		hash.h4[15] = hF;

	}
