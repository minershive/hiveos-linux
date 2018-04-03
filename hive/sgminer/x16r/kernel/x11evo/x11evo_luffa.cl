
// luffa
	{
		sph_u32 V00 = SPH_C32(0x6d251e69), V01 = SPH_C32(0x44b051e0), V02 = SPH_C32(0x4eaa6fb4), V03 = SPH_C32(0xdbf78465), V04 = SPH_C32(0x6e292011), V05 = SPH_C32(0x90152df4), V06 = SPH_C32(0xee058139), V07 = SPH_C32(0xdef610bb);
		sph_u32 V10 = SPH_C32(0xc3b44b95), V11 = SPH_C32(0xd9d2f256), V12 = SPH_C32(0x70eee9a0), V13 = SPH_C32(0xde099fa3), V14 = SPH_C32(0x5d9b0557), V15 = SPH_C32(0x8fc944b3), V16 = SPH_C32(0xcf1ccf0e), V17 = SPH_C32(0x746cd581);
		sph_u32 V20 = SPH_C32(0xf7efc89d), V21 = SPH_C32(0x5dba5781), V22 = SPH_C32(0x04016ce5), V23 = SPH_C32(0xad659c05), V24 = SPH_C32(0x0306194f), V25 = SPH_C32(0x666d1836), V26 = SPH_C32(0x24aa230a), V27 = SPH_C32(0x8b264ae7);
		sph_u32 V30 = SPH_C32(0x858075d5), V31 = SPH_C32(0x36d79cce), V32 = SPH_C32(0xe571f7d7), V33 = SPH_C32(0x204b1f67), V34 = SPH_C32(0x35870c6a), V35 = SPH_C32(0x57e9e923), V36 = SPH_C32(0x14bcb808), V37 = SPH_C32(0x7cde72ce);
		sph_u32 V40 = SPH_C32(0x6c68e9be), V41 = SPH_C32(0x5ec41e22), V42 = SPH_C32(0xc825b7c7), V43 = SPH_C32(0xaffb4363), V44 = SPH_C32(0xf5df3999), V45 = SPH_C32(0x0fc688f1), V46 = SPH_C32(0xb07224cc), V47 = SPH_C32(0x03e86cea);

		DECL_TMP8(M);

		M0 = hash.h4[1];
		M1 = hash.h4[0];
		M2 = hash.h4[3];
		M3 = hash.h4[2];
		M4 = hash.h4[5];
		M5 = hash.h4[4];
		M6 = hash.h4[7];
		M7 = hash.h4[6];

		for (uint i = 0; i < 5; i++)
		{
			MI5;
			LUFFA_P5;

			if (i == 0) {
				M0 = hash.h4[9];
				M1 = hash.h4[8];
				M2 = hash.h4[11];
				M3 = hash.h4[10];
				M4 = hash.h4[13];
				M5 = hash.h4[12];
				M6 = hash.h4[15];
				M7 = hash.h4[14];
			}
			else if (i == 1) {
				M0 = 0x80000000;
				M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
			}
			else if (i == 2) {
				M0 = M1 = M2 = M3 = M4 = M5 = M6 = M7 = 0;
			}
			else if (i == 3) {
				hash.h4[1] = V00 ^ V10 ^ V20 ^ V30 ^ V40;
				hash.h4[0] = V01 ^ V11 ^ V21 ^ V31 ^ V41;
				hash.h4[3] = V02 ^ V12 ^ V22 ^ V32 ^ V42;
				hash.h4[2] = V03 ^ V13 ^ V23 ^ V33 ^ V43;
				hash.h4[5] = V04 ^ V14 ^ V24 ^ V34 ^ V44;
				hash.h4[4] = V05 ^ V15 ^ V25 ^ V35 ^ V45;
				hash.h4[7] = V06 ^ V16 ^ V26 ^ V36 ^ V46;
				hash.h4[6] = V07 ^ V17 ^ V27 ^ V37 ^ V47;
			}
		}
		hash.h4[9] = V00 ^ V10 ^ V20 ^ V30 ^ V40;
		hash.h4[8] = V01 ^ V11 ^ V21 ^ V31 ^ V41;
		hash.h4[11] = V02 ^ V12 ^ V22 ^ V32 ^ V42;
		hash.h4[10] = V03 ^ V13 ^ V23 ^ V33 ^ V43;
		hash.h4[13] = V04 ^ V14 ^ V24 ^ V34 ^ V44;
		hash.h4[12] = V05 ^ V15 ^ V25 ^ V35 ^ V45;
		hash.h4[15] = V06 ^ V16 ^ V26 ^ V36 ^ V46;
		hash.h4[14] = V07 ^ V17 ^ V27 ^ V37 ^ V47;

	}
