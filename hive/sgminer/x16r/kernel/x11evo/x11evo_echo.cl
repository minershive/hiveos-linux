
// echo
	{
		sph_u64 W00, W01, W10, W11, W20, W21, W30, W31, W40, W41, W50, W51, W60, W61, W70, W71, W80, W81, W90, W91, WA0, WA1, WB0, WB1, WC0, WC1, WD0, WD1, WE0, WE1, WF0, WF1;
		sph_u64 Vb00, Vb01, Vb10, Vb11, Vb20, Vb21, Vb30, Vb31, Vb40, Vb41, Vb50, Vb51, Vb60, Vb61, Vb70, Vb71;
		Vb00 = Vb10 = Vb20 = Vb30 = Vb40 = Vb50 = Vb60 = Vb70 = 512UL;
		Vb01 = Vb11 = Vb21 = Vb31 = Vb41 = Vb51 = Vb61 = Vb71 = 0;

		sph_u32 K0 = 512;
		sph_u32 K1 = 0;
		sph_u32 K2 = 0;
		sph_u32 K3 = 0;

		W00 = Vb00;
		W01 = Vb01;
		W10 = Vb10;
		W11 = Vb11;
		W20 = Vb20;
		W21 = Vb21;
		W30 = Vb30;
		W31 = Vb31;
		W40 = Vb40;
		W41 = Vb41;
		W50 = Vb50;
		W51 = Vb51;
		W60 = Vb60;
		W61 = Vb61;
		W70 = Vb70;
		W71 = Vb71;
		W80 = hash.h8[0];
		W81 = hash.h8[1];
		W90 = hash.h8[2];
		W91 = hash.h8[3];
		WA0 = hash.h8[4];
		WA1 = hash.h8[5];
		WB0 = hash.h8[6];
		WB1 = hash.h8[7];
		WC0 = 0x80;
		WC1 = 0;
		WD0 = 0;
		WD1 = 0;
		WE0 = 0;
		WE1 = 0x200000000000000;
		WF0 = 0x200;
		WF1 = 0;

		for (unsigned u = 0; u < 10; u++) {
			BIG_ROUND;
		}

		Vb00 ^= hash.h8[0] ^ W00 ^ W80;
		Vb01 ^= hash.h8[1] ^ W01 ^ W81;
		Vb10 ^= hash.h8[2] ^ W10 ^ W90;
		Vb11 ^= hash.h8[3] ^ W11 ^ W91;
		Vb20 ^= hash.h8[4] ^ W20 ^ WA0;
		Vb21 ^= hash.h8[5] ^ W21 ^ WA1;
		Vb30 ^= hash.h8[6] ^ W30 ^ WB0;
		Vb31 ^= hash.h8[7] ^ W31 ^ WB1;

		hash.h8[0] = Vb00;
		hash.h8[1] = Vb01;
		hash.h8[2] = Vb10;
		hash.h8[3] = Vb11;
		hash.h8[4] = Vb20;
		hash.h8[5] = Vb21;
		hash.h8[6] = Vb30;
		hash.h8[7] = Vb31;

	}
