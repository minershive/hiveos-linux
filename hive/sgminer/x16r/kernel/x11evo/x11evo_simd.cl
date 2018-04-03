
// simd
	{
		s32 q[256];
		unsigned char x[128];
		for (unsigned int i = 0; i < 64; i++)
			x[i] = hash.h1[i];
		for (unsigned int i = 64; i < 128; i++)
			x[i] = 0;

		u32 A0 = C32(0x0BA16B95), A1 = C32(0x72F999AD), A2 = C32(0x9FECC2AE), A3 = C32(0xBA3264FC), A4 = C32(0x5E894929), A5 = C32(0x8E9F30E5), A6 = C32(0x2F1DAA37), A7 = C32(0xF0F2C558);
		u32 B0 = C32(0xAC506643), B1 = C32(0xA90635A5), B2 = C32(0xE25B878B), B3 = C32(0xAAB7878F), B4 = C32(0x88817F7A), B5 = C32(0x0A02892B), B6 = C32(0x559A7550), B7 = C32(0x598F657E);
		u32 C0 = C32(0x7EEF60A1), C1 = C32(0x6B70E3E8), C2 = C32(0x9C1714D1), C3 = C32(0xB958E2A8), C4 = C32(0xAB02675E), C5 = C32(0xED1C014F), C6 = C32(0xCD8D65BB), C7 = C32(0xFDB7A257);
		u32 D0 = C32(0x09254899), D1 = C32(0xD699C7BC), D2 = C32(0x9019B6DC), D3 = C32(0x2B9022E4), D4 = C32(0x8FA14956), D5 = C32(0x21BF9BD3), D6 = C32(0xB94D0943), D7 = C32(0x6FFDDC22);

		FFT256(0, 1, 0, ll1);
		for (int i = 0; i < 256; i++) {
			s32 tq;

			tq = q[i] + yoff_b_n[i];
			tq = REDS2(tq);
			tq = REDS1(tq);
			tq = REDS1(tq);
			q[i] = (tq <= 128 ? tq : tq - 257);
		}

		A0 ^= hash.h4[0];
		A1 ^= hash.h4[1];
		A2 ^= hash.h4[2];
		A3 ^= hash.h4[3];
		A4 ^= hash.h4[4];
		A5 ^= hash.h4[5];
		A6 ^= hash.h4[6];
		A7 ^= hash.h4[7];
		B0 ^= hash.h4[8];
		B1 ^= hash.h4[9];
		B2 ^= hash.h4[10];
		B3 ^= hash.h4[11];
		B4 ^= hash.h4[12];
		B5 ^= hash.h4[13];
		B6 ^= hash.h4[14];
		B7 ^= hash.h4[15];

		ONE_ROUND_BIG(0_, 0, 3, 23, 17, 27);
		ONE_ROUND_BIG(1_, 1, 28, 19, 22, 7);
		ONE_ROUND_BIG(2_, 2, 29, 9, 15, 5);
		ONE_ROUND_BIG(3_, 3, 4, 13, 10, 25);

		STEP_BIG(
			C32(0x0BA16B95), C32(0x72F999AD), C32(0x9FECC2AE), C32(0xBA3264FC),
			C32(0x5E894929), C32(0x8E9F30E5), C32(0x2F1DAA37), C32(0xF0F2C558),
			IF, 4, 13, PP8_4_);
		STEP_BIG(
			C32(0xAC506643), C32(0xA90635A5), C32(0xE25B878B), C32(0xAAB7878F),
			C32(0x88817F7A), C32(0x0A02892B), C32(0x559A7550), C32(0x598F657E),
			IF, 13, 10, PP8_5_);
		STEP_BIG(
			C32(0x7EEF60A1), C32(0x6B70E3E8), C32(0x9C1714D1), C32(0xB958E2A8),
			C32(0xAB02675E), C32(0xED1C014F), C32(0xCD8D65BB), C32(0xFDB7A257),
			IF, 10, 25, PP8_6_);
		STEP_BIG(
			C32(0x09254899), C32(0xD699C7BC), C32(0x9019B6DC), C32(0x2B9022E4),
			C32(0x8FA14956), C32(0x21BF9BD3), C32(0xB94D0943), C32(0x6FFDDC22),
			IF, 25, 4, PP8_0_);

		u32 COPY_A0 = A0, COPY_A1 = A1, COPY_A2 = A2, COPY_A3 = A3, COPY_A4 = A4, COPY_A5 = A5, COPY_A6 = A6, COPY_A7 = A7;
		u32 COPY_B0 = B0, COPY_B1 = B1, COPY_B2 = B2, COPY_B3 = B3, COPY_B4 = B4, COPY_B5 = B5, COPY_B6 = B6, COPY_B7 = B7;
		u32 COPY_C0 = C0, COPY_C1 = C1, COPY_C2 = C2, COPY_C3 = C3, COPY_C4 = C4, COPY_C5 = C5, COPY_C6 = C6, COPY_C7 = C7;
		u32 COPY_D0 = D0, COPY_D1 = D1, COPY_D2 = D2, COPY_D3 = D3, COPY_D4 = D4, COPY_D5 = D5, COPY_D6 = D6, COPY_D7 = D7;

#define q SIMD_Q

		A0 ^= 0x200;

		ONE_ROUND_BIG(0_, 0, 3, 23, 17, 27);
		ONE_ROUND_BIG(1_, 1, 28, 19, 22, 7);
		ONE_ROUND_BIG(2_, 2, 29, 9, 15, 5);
		ONE_ROUND_BIG(3_, 3, 4, 13, 10, 25);
		STEP_BIG(
			COPY_A0, COPY_A1, COPY_A2, COPY_A3,
			COPY_A4, COPY_A5, COPY_A6, COPY_A7,
			IF, 4, 13, PP8_4_);
		STEP_BIG(
			COPY_B0, COPY_B1, COPY_B2, COPY_B3,
			COPY_B4, COPY_B5, COPY_B6, COPY_B7,
			IF, 13, 10, PP8_5_);
		STEP_BIG(
			COPY_C0, COPY_C1, COPY_C2, COPY_C3,
			COPY_C4, COPY_C5, COPY_C6, COPY_C7,
			IF, 10, 25, PP8_6_);
		STEP_BIG(
			COPY_D0, COPY_D1, COPY_D2, COPY_D3,
			COPY_D4, COPY_D5, COPY_D6, COPY_D7,
			IF, 25, 4, PP8_0_);
#undef q

		hash.h4[0] = A0;
		hash.h4[1] = A1;
		hash.h4[2] = A2;
		hash.h4[3] = A3;
		hash.h4[4] = A4;
		hash.h4[5] = A5;
		hash.h4[6] = A6;
		hash.h4[7] = A7;
		hash.h4[8] = B0;
		hash.h4[9] = B1;
		hash.h4[10] = B2;
		hash.h4[11] = B3;
		hash.h4[12] = B4;
		hash.h4[13] = B5;
		hash.h4[14] = B6;
		hash.h4[15] = B7;

	}
