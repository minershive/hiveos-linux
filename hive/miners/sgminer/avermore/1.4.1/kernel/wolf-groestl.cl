#ifndef WOLF_GROESTL_CL
#define WOLF_GROESTL_CL

// Macros and table for Wolf's OpenCL Groestl implementation

#pragma OPENCL EXTENSION cl_amd_media_ops2 : enable

#define BYTE(x, y)	(amd_bfe((uint)((x) >> ((y >= 32U) ? 32U : 0U)), (y) - (((y) >= 32) ? 32U : 0), 8U))

#define B64_0(x)	((uchar)(x))
#define B64_1(x)    BYTE((x), 8U)
#define B64_2(x)    BYTE((x), 16U)
#define B64_3(x)    BYTE((x), 24U)
#define B64_4(x)    BYTE((x), 32U)
#define B64_5(x)    BYTE((x), 40U)
#define B64_6(x)    BYTE((x), 48U)
#define B64_7(x)    BYTE((x), 56U)

#define GROESTL_RBTT(d, Hval, b0, b1, b2, b3, b4, b5, b6, b7)   do { \
	d = (T0[B64_0(Hval[b0])] ^ T1[B64_1(Hval[b1])] ^ T2[B64_2(Hval[b2])] ^ T3[B64_3(Hval[b3])] \
	^ as_ulong(as_uint2(T0[B64_4(Hval[b4])]).s10) ^ as_ulong(as_uint2(T1[B64_5(Hval[b5])]).s10) ^ as_ulong(as_uint2(T2[B64_6(Hval[b6])]).s10) ^ as_ulong(as_uint2(T3[B64_7(Hval[b7])]).s10)); \
	} while(0)

/*
//#define BYTE(x, y)	(amd_bfe((x), (y), 8U))
#define BYTE(x, y)	(amd_bfe((uint)((x) >> ((y >= 32U) ? 32U : 0U)), (y) - (((y) >= 32) ? 32U : 0), 8U))

#define B64_0(x)	((uchar)(x))
#define B64_1(x)    BYTE((x), 8U)
#define B64_2(x)    BYTE((x), 16U)
#define B64_3(x)    BYTE((x), 24U)
#define B64_4(x)    as_ulong(as_uint2((x)).s10)
#define B64_5(x)    BYTE((x), 40U)
#define B64_6(x)    BYTE((x), 48U)
#define B64_7(x)    BYTE((x), 56U)

#define GROESTL_RBTT(d, Hval, b0, b1, b2, b3, b4, b5, b6, b7)   do { \
	d = (T0[B64_0(Hval[b0])] ^ T1[B64_1(Hval[b1])] ^ T2[B64_2(Hval[b2])] ^ T3[B64_3(Hval[b3])] \
	^ as_ulong(as_uint2(T0[B64_4(Hval[b4])]).s10) ^ as_ulong(as_uint2(T1[B64_5(Hval[b5])]).s10) ^ as_ulong(as_uint2(T2[B64_6(Hval[b6])]).s10) ^ as_ulong(as_uint2(T3[B64_7(Hval[b7])]).s10)); \
	} while(0)
*/

#define PC64(j, r)  (ulong)((j) | (r))
#define QC64(j, r)	rotate(((ulong)(r)) ^ (~((ulong)(j))), 56UL)

//#define PC64(j, r)  ((sph_u64)((j) + (r)))
//#define PC64(j, r)	((ulong)(((uchar)(j)) + (uchar)(r)))
//#define PC64(j, r)	((((uchar)(j)) + (uchar)(r)))

//#define QC64(j, r)	(((ulong)(r) << 56) ^ ~((ulong)(j) << 56))

//#define QC64(j, r)	(((ulong)(r) << 56) ^ (j))

//#define QC64(j, r)	as_uint2((r) ^ (j))

static const __constant ulong T0_G[] =
{
	0xc6a597f4a5f432c6UL, 0xf884eb9784976ff8UL, 0xee99c7b099b05eeeUL, 0xf68df78c8d8c7af6UL, 
	0xff0de5170d17e8ffUL, 0xd6bdb7dcbddc0ad6UL, 0xdeb1a7c8b1c816deUL, 0x915439fc54fc6d91UL, 
	0x6050c0f050f09060UL, 0x0203040503050702UL, 0xcea987e0a9e02eceUL, 0x567dac877d87d156UL, 
	0xe719d52b192bcce7UL, 0xb56271a662a613b5UL, 0x4de69a31e6317c4dUL, 0xec9ac3b59ab559ecUL, 
	0x8f4505cf45cf408fUL, 0x1f9d3ebc9dbca31fUL, 0x894009c040c04989UL, 0xfa87ef92879268faUL, 
	0xef15c53f153fd0efUL, 0xb2eb7f26eb2694b2UL, 0x8ec90740c940ce8eUL, 0xfb0bed1d0b1de6fbUL, 
	0x41ec822fec2f6e41UL, 0xb3677da967a91ab3UL, 0x5ffdbe1cfd1c435fUL, 0x45ea8a25ea256045UL, 
	0x23bf46dabfdaf923UL, 0x53f7a602f7025153UL, 0xe496d3a196a145e4UL, 0x9b5b2ded5bed769bUL, 
	0x75c2ea5dc25d2875UL, 0xe11cd9241c24c5e1UL, 0x3dae7ae9aee9d43dUL, 0x4c6a98be6abef24cUL, 
	0x6c5ad8ee5aee826cUL, 0x7e41fcc341c3bd7eUL, 0xf502f1060206f3f5UL, 0x834f1dd14fd15283UL, 
	0x685cd0e45ce48c68UL, 0x51f4a207f4075651UL, 0xd134b95c345c8dd1UL, 0xf908e9180818e1f9UL, 
	0xe293dfae93ae4ce2UL, 0xab734d9573953eabUL, 0x6253c4f553f59762UL, 0x2a3f54413f416b2aUL, 
	0x080c10140c141c08UL, 0x955231f652f66395UL, 0x46658caf65afe946UL, 0x9d5e21e25ee27f9dUL, 
	0x3028607828784830UL, 0x37a16ef8a1f8cf37UL, 0x0a0f14110f111b0aUL, 0x2fb55ec4b5c4eb2fUL, 
	0x0e091c1b091b150eUL, 0x2436485a365a7e24UL, 0x1b9b36b69bb6ad1bUL, 0xdf3da5473d4798dfUL, 
	0xcd26816a266aa7cdUL, 0x4e699cbb69bbf54eUL, 0x7fcdfe4ccd4c337fUL, 0xea9fcfba9fba50eaUL, 
	0x121b242d1b2d3f12UL, 0x1d9e3ab99eb9a41dUL, 0x5874b09c749cc458UL, 0x342e68722e724634UL, 
	0x362d6c772d774136UL, 0xdcb2a3cdb2cd11dcUL, 0xb4ee7329ee299db4UL, 0x5bfbb616fb164d5bUL, 
	0xa4f65301f601a5a4UL, 0x764decd74dd7a176UL, 0xb76175a361a314b7UL, 0x7dcefa49ce49347dUL, 
	0x527ba48d7b8ddf52UL, 0xdd3ea1423e429fddUL, 0x5e71bc937193cd5eUL, 0x139726a297a2b113UL, 
	0xa6f55704f504a2a6UL, 0xb96869b868b801b9UL, 0x0000000000000000UL, 0xc12c99742c74b5c1UL, 
	0x406080a060a0e040UL, 0xe31fdd211f21c2e3UL, 0x79c8f243c8433a79UL, 0xb6ed772ced2c9ab6UL, 
	0xd4beb3d9bed90dd4UL, 0x8d4601ca46ca478dUL, 0x67d9ce70d9701767UL, 0x724be4dd4bddaf72UL, 
	0x94de3379de79ed94UL, 0x98d42b67d467ff98UL, 0xb0e87b23e82393b0UL, 0x854a11de4ade5b85UL, 
	0xbb6b6dbd6bbd06bbUL, 0xc52a917e2a7ebbc5UL, 0x4fe59e34e5347b4fUL, 0xed16c13a163ad7edUL, 
	0x86c51754c554d286UL, 0x9ad72f62d762f89aUL, 0x6655ccff55ff9966UL, 0x119422a794a7b611UL, 
	0x8acf0f4acf4ac08aUL, 0xe910c9301030d9e9UL, 0x0406080a060a0e04UL, 0xfe81e798819866feUL, 
	0xa0f05b0bf00baba0UL, 0x7844f0cc44ccb478UL, 0x25ba4ad5bad5f025UL, 0x4be3963ee33e754bUL, 
	0xa2f35f0ef30eaca2UL, 0x5dfeba19fe19445dUL, 0x80c01b5bc05bdb80UL, 0x058a0a858a858005UL, 
	0x3fad7eecadecd33fUL, 0x21bc42dfbcdffe21UL, 0x7048e0d848d8a870UL, 0xf104f90c040cfdf1UL, 
	0x63dfc67adf7a1963UL, 0x77c1ee58c1582f77UL, 0xaf75459f759f30afUL, 0x426384a563a5e742UL, 
	0x2030405030507020UL, 0xe51ad12e1a2ecbe5UL, 0xfd0ee1120e12effdUL, 0xbf6d65b76db708bfUL, 
	0x814c19d44cd45581UL, 0x1814303c143c2418UL, 0x26354c5f355f7926UL, 0xc32f9d712f71b2c3UL, 
	0xbee16738e13886beUL, 0x35a26afda2fdc835UL, 0x88cc0b4fcc4fc788UL, 0x2e395c4b394b652eUL, 
	0x93573df957f96a93UL, 0x55f2aa0df20d5855UL, 0xfc82e39d829d61fcUL, 0x7a47f4c947c9b37aUL, 
	0xc8ac8befacef27c8UL, 0xbae76f32e73288baUL, 0x322b647d2b7d4f32UL, 0xe695d7a495a442e6UL, 
	0xc0a09bfba0fb3bc0UL, 0x199832b398b3aa19UL, 0x9ed12768d168f69eUL, 0xa37f5d817f8122a3UL, 
	0x446688aa66aaee44UL, 0x547ea8827e82d654UL, 0x3bab76e6abe6dd3bUL, 0x0b83169e839e950bUL, 
	0x8cca0345ca45c98cUL, 0xc729957b297bbcc7UL, 0x6bd3d66ed36e056bUL, 0x283c50443c446c28UL, 
	0xa779558b798b2ca7UL, 0xbce2633de23d81bcUL, 0x161d2c271d273116UL, 0xad76419a769a37adUL, 
	0xdb3bad4d3b4d96dbUL, 0x6456c8fa56fa9e64UL, 0x744ee8d24ed2a674UL, 0x141e28221e223614UL, 
	0x92db3f76db76e492UL, 0x0c0a181e0a1e120cUL, 0x486c90b46cb4fc48UL, 0xb8e46b37e4378fb8UL, 
	0x9f5d25e75de7789fUL, 0xbd6e61b26eb20fbdUL, 0x43ef862aef2a6943UL, 0xc4a693f1a6f135c4UL, 
	0x39a872e3a8e3da39UL, 0x31a462f7a4f7c631UL, 0xd337bd5937598ad3UL, 0xf28bff868b8674f2UL, 
	0xd532b156325683d5UL, 0x8b430dc543c54e8bUL, 0x6e59dceb59eb856eUL, 0xdab7afc2b7c218daUL, 
	0x018c028f8c8f8e01UL, 0xb16479ac64ac1db1UL, 0x9cd2236dd26df19cUL, 0x49e0923be03b7249UL, 
	0xd8b4abc7b4c71fd8UL, 0xacfa4315fa15b9acUL, 0xf307fd090709faf3UL, 0xcf25856f256fa0cfUL, 
	0xcaaf8feaafea20caUL, 0xf48ef3898e897df4UL, 0x47e98e20e9206747UL, 0x1018202818283810UL, 
	0x6fd5de64d5640b6fUL, 0xf088fb83888373f0UL, 0x4a6f94b16fb1fb4aUL, 0x5c72b8967296ca5cUL, 
	0x3824706c246c5438UL, 0x57f1ae08f1085f57UL, 0x73c7e652c7522173UL, 0x975135f351f36497UL, 
	0xcb238d652365aecbUL, 0xa17c59847c8425a1UL, 0xe89ccbbf9cbf57e8UL, 0x3e217c6321635d3eUL, 
	0x96dd377cdd7cea96UL, 0x61dcc27fdc7f1e61UL, 0x0d861a9186919c0dUL, 0x0f851e9485949b0fUL, 
	0xe090dbab90ab4be0UL, 0x7c42f8c642c6ba7cUL, 0x71c4e257c4572671UL, 0xccaa83e5aae529ccUL, 
	0x90d83b73d873e390UL, 0x06050c0f050f0906UL, 0xf701f5030103f4f7UL, 0x1c12383612362a1cUL, 
	0xc2a39ffea3fe3cc2UL, 0x6a5fd4e15fe18b6aUL, 0xaef94710f910beaeUL, 0x69d0d26bd06b0269UL, 
	0x17912ea891a8bf17UL, 0x995829e858e87199UL, 0x3a2774692769533aUL, 0x27b94ed0b9d0f727UL, 
	0xd938a948384891d9UL, 0xeb13cd351335deebUL, 0x2bb356ceb3cee52bUL, 0x2233445533557722UL, 
	0xd2bbbfd6bbd604d2UL, 0xa9704990709039a9UL, 0x07890e8089808707UL, 0x33a766f2a7f2c133UL, 
	0x2db65ac1b6c1ec2dUL, 0x3c22786622665a3cUL, 0x15922aad92adb815UL, 0xc92089602060a9c9UL, 
	0x874915db49db5c87UL, 0xaaff4f1aff1ab0aaUL, 0x5078a0887888d850UL, 0xa57a518e7a8e2ba5UL, 
	0x038f068a8f8a8903UL, 0x59f8b213f8134a59UL, 0x0980129b809b9209UL, 0x1a1734391739231aUL, 
	0x65daca75da751065UL, 0xd731b553315384d7UL, 0x84c61351c651d584UL, 0xd0b8bbd3b8d303d0UL, 
	0x82c31f5ec35edc82UL, 0x29b052cbb0cbe229UL, 0x5a77b4997799c35aUL, 0x1e113c3311332d1eUL, 
	0x7bcbf646cb463d7bUL, 0xa8fc4b1ffc1fb7a8UL, 0x6dd6da61d6610c6dUL, 0x2c3a584e3a4e622cUL
};

#endif
