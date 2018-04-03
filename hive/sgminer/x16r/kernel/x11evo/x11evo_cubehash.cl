
// cubehash.h1
	{
		sph_u32 x0 = SPH_C32(0x2AEA2A61), x1 = SPH_C32(0x50F494D4), x2 = SPH_C32(0x2D538B8B), x3 = SPH_C32(0x4167D83E);
		sph_u32 x4 = SPH_C32(0x3FEE2313), x5 = SPH_C32(0xC701CF8C), x6 = SPH_C32(0xCC39968E), x7 = SPH_C32(0x50AC5695);
		sph_u32 x8 = SPH_C32(0x4D42C787), x9 = SPH_C32(0xA647A8B3), xa = SPH_C32(0x97CF0BEF), xb = SPH_C32(0x825B4537);
		sph_u32 xc = SPH_C32(0xEEF864D2), xd = SPH_C32(0xF22090C4), xe = SPH_C32(0xD0E5CD33), xf = SPH_C32(0xA23911AE);
		sph_u32 xg = SPH_C32(0xFCD398D9), xh = SPH_C32(0x148FE485), xi = SPH_C32(0x1B017BEF), xj = SPH_C32(0xB6444532);
		sph_u32 xk = SPH_C32(0x6A536159), xl = SPH_C32(0x2FF5781C), xm = SPH_C32(0x91FA7934), xn = SPH_C32(0x0DBADEA9);
		sph_u32 xo = SPH_C32(0xD65C8A2B), xp = SPH_C32(0xA5A70E75), xq = SPH_C32(0xB1C62456), xr = SPH_C32(0xBC796576);
		sph_u32 xs = SPH_C32(0x1921C8F7), xt = SPH_C32(0xE7989AF1), xu = SPH_C32(0x7795D246), xv = SPH_C32(0xD43E3B44);

		x0 ^= SWAP4(hash.h4[1]);
		x1 ^= SWAP4(hash.h4[0]);
		x2 ^= SWAP4(hash.h4[3]);
		x3 ^= SWAP4(hash.h4[2]);
		x4 ^= SWAP4(hash.h4[5]);
		x5 ^= SWAP4(hash.h4[4]);
		x6 ^= SWAP4(hash.h4[7]);
		x7 ^= SWAP4(hash.h4[6]);

		for (int i = 0; i < 13; i++) {
			SIXTEEN_ROUNDS;

			if (i == 0) {
				x0 ^= SWAP4(hash.h4[9]);
				x1 ^= SWAP4(hash.h4[8]);
				x2 ^= SWAP4(hash.h4[11]);
				x3 ^= SWAP4(hash.h4[10]);
				x4 ^= SWAP4(hash.h4[13]);
				x5 ^= SWAP4(hash.h4[12]);
				x6 ^= SWAP4(hash.h4[15]);
				x7 ^= SWAP4(hash.h4[14]);
			}
			else if (i == 1) {
				x0 ^= 0x80;
			}
			else if (i == 2) {
				xv ^= SPH_C32(1);
			}
		}

		hash.h4[0] = x0;
		hash.h4[1] = x1;
		hash.h4[2] = x2;
		hash.h4[3] = x3;
		hash.h4[4] = x4;
		hash.h4[5] = x5;
		hash.h4[6] = x6;
		hash.h4[7] = x7;
		hash.h4[8] = x8;
		hash.h4[9] = x9;
		hash.h4[10] = xa;
		hash.h4[11] = xb;
		hash.h4[12] = xc;
		hash.h4[13] = xd;
		hash.h4[14] = xe;
		hash.h4[15] = xf;

	}
