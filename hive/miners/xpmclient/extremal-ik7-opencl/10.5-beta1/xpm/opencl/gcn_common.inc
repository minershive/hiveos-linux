PointerSize = 8

SetupBufferPtr = %s[4:5]
XYLocalSizeOffset = 1

ArgumentsPtr = %s[6:7]
XGlobalOffset = 0
YGlobalOffset = 1
ZGlobalOffset = 2
XGlobalSize = 3
YGlobalSize = 4
ZGlobalSize = 5
FirstArgumentOffset = 6
FirstArgumentByteOffset = (6*PointerSize)

.ifarch GCN1.4
GroupId = %s10
.else
GroupId = %s8
.endif

LocalId = %v0

# Benchmarks parameters
MulOpsNum = 512

# Fermat test parameters
WindowSize = 7


.ifarch GCN1.4
.macro vadd32u, result, carryout, op1, op2
  v_add_co_u32          \result, \carryout, \op1, \op2
.endm
.macro vaddc32u, result, carryout, op1, op2, carryin
  v_addc_co_u32         \result, \carryout, \op1, \op2, \carryin
.endm
.macro vsub32u, result, borrowout, op1, op2
  v_sub_co_u32          \result, \borrowout, \op1, \op2
.endm
.macro vsubb32u, result, borrowout, op1, op2, borrowin
  v_sub_co_u32          \result, \borrowout, \op1, \op2, \borrowin
.endm
.else
.macro vadd32u, result, carryout, op1, op2
  v_add_u32          \result, \carryout, \op1, \op2
.endm
.macro vaddc32u, result, carryout, op1, op2, carryin
  v_addc_u32         \result, \carryout, \op1, \op2, \carryin
.endm
.macro vsub32u, result, borrowout, op1, op2
  v_sub_u32          \result, \borrowout, \op1, \op2
.endm
.macro vsubb32u, result, borrowout, op1, op2
  v_sub_u32          \result, \borrowout, \op1, \op2, \borrowin
.endm
.endif

.macro invert_limb limb, addr, tmp, invm
    v_mov_b32           \addr[0], binvert_limb_table & 0xffffffff
    v_mov_b32           \addr[1], binvert_limb_table >> 32
    v_lshlrev_b32       \tmp[0], 1, \limb
    v_and_b32           \tmp[0], (0x7F * 4), \tmp[0]
    vadd32u             \addr[0], vcc, \tmp[0], \addr[0]
    vaddc32u            \addr[1], vcc, 0, \addr[1], vcc
    flat_load_dword     \tmp[0], \addr[0:1]
    s_waitcnt           vmcnt(0)

    v_mad_u32_u24       \tmp[1], \tmp[0], \tmp[0], 0
    v_mul_lo_u32        \tmp[1], \tmp[1], \limb
    v_lshlrev_b32       \tmp[0], 1, \tmp[0]
    vsub32u             \tmp[0], vcc, \tmp[0], \tmp[1]

    v_mul_lo_u32        \tmp[1], \tmp[0], \tmp[0]
    v_mul_lo_u32        \tmp[1], \tmp[1], \limb
    v_lshlrev_b32       \tmp[0], 1, \tmp[0]
    vsub32u             \tmp[0], vcc, \tmp[0], \tmp[1]

    v_not_b32           \tmp[0], \tmp[0]
    vadd32u             \invm, vcc, \tmp[0], 1
.endm

.macro div64to32, dividend, divisor, result, reg, sreg
.ifarch GCN1.4
    v_mov_b32       \reg[1], 0x4f800000
    v_mov_b32       \reg[13], 0xcf800000
    v_cvt_f32_u32   \reg[0], \divisor
    v_sub_co_u32    \reg[15], vcc, 0, \divisor
    v_subb_co_u32   \reg[14], vcc, 0, 0, vcc
    v_mad_f32       \reg[0], 0, \reg[1], \reg[0]
    v_rcp_f32       \reg[0], \reg[0]
    v_mov_b32       \reg[1], 0
    v_mul_f32       \reg[0], 0x5f7ffffc, \reg[0]
    v_mul_f32       \reg[2], 0x2f800000, \reg[0]
    v_trunc_f32     \reg[2], \reg[2]
    v_mad_f32       \reg[0], \reg[2], \reg[13], \reg[0]
    v_cvt_u32_f32   \reg[0], \reg[0]
    v_cvt_u32_f32   \reg[3], \reg[2]
    v_mov_b32       \reg[2], 0
    v_mul_hi_u32    \reg[5], \reg[15], \reg[0]
    v_mul_lo_u32    \reg[4], \reg[15], \reg[3]
    v_mul_lo_u32    \reg[7], \reg[14], \reg[0]
    v_mul_lo_u32    \reg[6], \reg[15], \reg[0]
    v_add_u32       \reg[4], \reg[5], \reg[4]
    v_add_u32       \reg[4], \reg[4], \reg[7]
    v_mul_hi_u32    \reg[5], \reg[0], \reg[6]
    v_mul_lo_u32    \reg[9], \reg[0], \reg[4]
    v_mul_hi_u32    \reg[7], \reg[0], \reg[4]
    v_mul_hi_u32    \reg[8], \reg[3], \reg[6]
    v_mul_lo_u32    \reg[6], \reg[3], \reg[6]
    v_add_co_u32    \reg[5], vcc, \reg[5], \reg[9]
    v_mul_hi_u32    \reg[10], \reg[3], \reg[4]
    v_addc_co_u32   \reg[7], vcc, \reg[2], \reg[7], vcc
    v_mul_lo_u32    \reg[4], \reg[3], \reg[4]
    v_add_co_u32    \reg[5], vcc, \reg[6], \reg[5]
    v_addc_co_u32   \reg[5], vcc, \reg[7], \reg[8], vcc
    v_addc_co_u32   \reg[6], vcc, \reg[10], \reg[1], vcc
    v_add_co_u32    \reg[4], vcc, \reg[5], \reg[4]
    v_add_co_u32    \reg[0], s[0:1], \reg[0], \reg[4]
    v_addc_co_u32   \reg[5], vcc, \reg[2], \reg[6], vcc
    v_addc_co_u32   \reg[4], vcc, \reg[3], \reg[5], s[0:1]
    v_mul_lo_u32    \reg[6], \reg[15], \reg[4]
    v_mul_hi_u32    \reg[7], \reg[15], \reg[0]
    v_mul_lo_u32    \reg[8], \reg[14], \reg[0]
    v_mul_lo_u32    \reg[9], \reg[15], \reg[0]
    v_add_u32       \reg[6], \reg[7], \reg[6]
    v_add_u32       \reg[6], \reg[6], \reg[8]
    v_mul_lo_u32    \reg[10], \reg[0], \reg[6]
    v_mul_hi_u32    \reg[11], \reg[0], \reg[9]
    v_mul_hi_u32    \reg[12], \reg[0], \reg[6]
    v_mul_hi_u32    \reg[8], \reg[4], \reg[9]
    v_mul_lo_u32    \reg[9], \reg[4], \reg[9]
    v_add_co_u32    \reg[10], vcc, \reg[11], \reg[10]
    v_mul_hi_u32    \reg[7], \reg[4], \reg[6]
    v_addc_co_u32   \reg[11], vcc, \reg[2], \reg[12], vcc
    v_mul_lo_u32    \reg[4], \reg[4], \reg[6]
    v_add_co_u32    \reg[9], vcc, \reg[9], \reg[10]
    v_addc_co_u32   \reg[8], vcc, \reg[11], \reg[8], vcc
    v_addc_co_u32   \reg[6], vcc, \reg[7], \reg[1], vcc
    v_add_co_u32    \reg[4], vcc, \reg[8], \reg[4]
    v_addc_co_u32   \reg[6], vcc, \reg[2], \reg[6], vcc
    v_add_u32       \reg[3], \reg[3], \reg[5]
    v_addc_co_u32   \reg[3], vcc, \reg[3], \reg[6], s[0:1]
    v_add_co_u32    \reg[0], vcc, \reg[0], \reg[4]
    v_addc_co_u32   \reg[3], vcc, 0, \reg[3], vcc
    v_mul_lo_u32    \reg[4], \dividend[0], \reg[3]
    v_mul_hi_u32    \reg[5], \dividend[0], \reg[0]
    v_mul_hi_u32    \reg[6], \dividend[0], \reg[3]
    v_mul_hi_u32    \reg[7], \dividend[1], \reg[3]
    v_mul_lo_u32    \reg[3], \dividend[1], \reg[3]
    v_add_co_u32    \reg[4], vcc, \reg[5], \reg[4]
    v_addc_co_u32   \reg[5], vcc, \reg[2], \reg[6], vcc
    v_mul_lo_u32    \reg[6], \dividend[1], \reg[0]
    v_mul_hi_u32    \reg[0], \dividend[1], \reg[0]
    v_add_co_u32    \reg[4], vcc, \reg[6], \reg[4]
    v_addc_co_u32   \reg[0], vcc, \reg[5], \reg[0], vcc
    v_addc_co_u32   \reg[1], vcc, \reg[7], \reg[1], vcc
    v_add_co_u32    \reg[3], vcc, \reg[0], \reg[3]
    v_addc_co_u32   \reg[0], vcc, \reg[2], \reg[1], vcc
    v_mul_lo_u32    \reg[5], \divisor, \reg[3]
    v_mul_lo_u32    \reg[2], \divisor, \reg[0]
    v_mul_hi_u32    \reg[4], \divisor, \reg[3]
    v_sub_co_u32    \reg[5], vcc, \dividend[0], \reg[5]
    v_add_u32       \reg[2], \reg[4], \reg[2]
    v_mov_b32       \reg[4], \dividend[1]
    v_subb_co_u32   \reg[2], vcc, \reg[4], \reg[2], vcc
    v_subrev_co_u32 \reg[4], vcc, \divisor, \reg[5]
    v_subbrev_co_u32 \reg[6], vcc, 0, \reg[2], vcc
    v_cmp_le_u32    vcc, \divisor, \reg[4]
    v_cndmask_b32   \reg[4], 0, -1, vcc
    v_cmp_eq_u32    vcc, 0, \reg[6]
    v_cndmask_b32   \reg[4], -1, \reg[4], vcc
    v_add_co_u32    \reg[6], vcc, 2, \reg[3]
    v_add_co_u32    \reg[7], vcc, 1, \reg[3]
    v_cmp_lg_u32    vcc, 0, \reg[4]
    v_cndmask_b32   \reg[4], \reg[7], \reg[6], vcc
    v_cmp_le_u32    vcc, \divisor, \reg[5]
    v_cndmask_b32   \reg[5], 0, -1, vcc
    v_cmp_eq_u32    vcc, 0, \reg[2]
    v_cndmask_b32   \reg[2], -1, \reg[5], vcc
    v_cmp_lg_u32    vcc, 0, \reg[2]
    v_cndmask_b32   \result, \reg[3], \reg[4], vcc
.else
    v_mov_b32       \reg[1], 0x4f800000
    v_mov_b32       \reg[2], 0
    v_cvt_f32_u32   \reg[0], \divisor
    v_sub_u32       \reg[13], vcc, 0, \divisor
    v_subb_u32      \reg[14], vcc, 0, 0, vcc
    v_mac_f32       \reg[0], 0, \reg[1]
    v_rcp_f32       \reg[0], \reg[0]
    v_mov_b32       \reg[1], 0
    v_mul_f32       \reg[0], 0x5f7ffffc, \reg[0]
    v_mul_f32       \reg[3], 0x2f800000, \reg[0]
    v_trunc_f32     \reg[3], \reg[3]
    v_mac_f32       \reg[0], 0xcf800000, \reg[3]
    v_cvt_u32_f32   \reg[0], \reg[0]
    v_cvt_u32_f32   \reg[4], \reg[3]
    v_mul_hi_u32    \reg[5], \reg[13], \reg[0]
    v_mul_lo_u32    \reg[3], \reg[13], \reg[4]
    v_mul_lo_u32    \reg[7], \reg[14], \reg[0]
    v_mul_lo_u32    \reg[6], \reg[13], \reg[0]
    v_add_u32       \reg[3], vcc, \reg[5], \reg[3]
    v_add_u32       \reg[3], vcc, \reg[7], \reg[3]
    v_mul_hi_u32    \reg[5], \reg[0], \reg[6]
    v_mul_lo_u32    \reg[9], \reg[0], \reg[3]
    v_mul_hi_u32    \reg[7], \reg[0], \reg[3]
    v_mul_hi_u32    \reg[8], \reg[4], \reg[6]
    v_mul_lo_u32    \reg[6], \reg[4], \reg[6]
    v_add_u32       \reg[5], vcc, \reg[5], \reg[9]
    v_mul_hi_u32    \reg[10], \reg[4], \reg[3]
    v_addc_u32      \reg[7], vcc, \reg[2], \reg[7], vcc
    v_mul_lo_u32    \reg[3], \reg[4], \reg[3]
    v_add_u32       \reg[5], vcc, \reg[6], \reg[5]
    v_addc_u32      \reg[5], vcc, \reg[7], \reg[8], vcc
    v_addc_u32      \reg[6], vcc, \reg[10], \reg[1], vcc
    v_add_u32       \reg[3], vcc, \reg[5], \reg[3]
    v_add_u32       \reg[0], s[0:1], \reg[0], \reg[3]
    v_addc_u32      \reg[5], vcc, \reg[2], \reg[6], vcc
    v_addc_u32      \reg[3], vcc, \reg[4], \reg[5], s[0:1]
    v_mul_lo_u32    \reg[6], \reg[13], \reg[3]
    v_mul_hi_u32    \reg[7], \reg[13], \reg[0]
    v_mul_lo_u32    \reg[8], \reg[14], \reg[0]
    v_add_u32       \reg[6], vcc, \reg[7], \reg[6]
    v_mul_lo_u32    \reg[7], \reg[13], \reg[0]
    v_add_u32       \reg[6], vcc, \reg[8], \reg[6]
    v_mul_lo_u32    \reg[10], \reg[0], \reg[6]
    v_mul_hi_u32    \reg[12], \reg[0], \reg[6]
    v_mul_hi_u32    \reg[11], \reg[0], \reg[7]
    v_mul_hi_u32    \reg[9], \reg[3], \reg[7]
    v_mul_lo_u32    \reg[7], \reg[3], \reg[7]
    v_mul_hi_u32    \reg[8], \reg[3], \reg[6]
    v_add_u32       \reg[10], vcc, \reg[11], \reg[10]
    v_addc_u32      \reg[11], vcc, \reg[2], \reg[12], vcc
    v_mul_lo_u32    \reg[3], \reg[3], \reg[6]
    v_add_u32       \reg[7], vcc, \reg[7], \reg[10]
    v_addc_u32      \reg[7], vcc, \reg[11], \reg[9], vcc
    v_addc_u32      \reg[6], vcc, \reg[8], \reg[1], vcc
    v_add_u32       \reg[3], vcc, \reg[7], \reg[3]
    v_addc_u32      \reg[6], vcc, \reg[2], \reg[6], vcc
    v_add_u32       \reg[4], vcc, \reg[4], \reg[5]
    v_addc_u32      \reg[4], vcc, \reg[4], \reg[6], s[0:1]
    v_add_u32       \reg[3], vcc, \reg[0], \reg[3]
    v_addc_u32      \reg[4], vcc, 0, \reg[4], vcc
    v_mul_lo_u32    \reg[5], \dividend[0], \reg[4]
    v_mul_hi_u32    \reg[6], \dividend[0], \reg[3]
    v_mul_hi_u32    \reg[7], \dividend[0], \reg[4]
    v_mul_hi_u32    \reg[8], \dividend[1], \reg[4]
    v_mul_lo_u32    \reg[4], \dividend[1], \reg[4]
    v_add_u32       \reg[5], vcc, \reg[6], \reg[5]
    v_addc_u32      \reg[6], vcc, \reg[2], \reg[7], vcc
    v_mul_lo_u32    \reg[7], \dividend[1], \reg[3]
    v_mul_hi_u32    \reg[3], \dividend[1], \reg[3]
    v_add_u32       \reg[5], vcc, \reg[7], \reg[5]
    v_addc_u32      \reg[3], vcc, \reg[6], \reg[3], vcc
    v_addc_u32      \reg[1], vcc, \reg[8], \reg[1], vcc
    v_add_u32       \reg[3], vcc, \reg[3], \reg[4]
    v_addc_u32      \reg[1], vcc, \reg[2], \reg[1], vcc
    v_mul_lo_u32    \reg[2], \divisor, \reg[1]
    v_mul_hi_u32    \reg[4], \divisor, \reg[3]
    v_mul_lo_u32    \reg[5], \divisor, \reg[3]
    v_add_u32       \reg[2], vcc, \reg[4], \reg[2]
    v_mov_b32       \reg[4], \dividend[1]
    v_sub_u32       \reg[5], vcc, \dividend[0], \reg[5]
    v_subb_u32      \reg[2], vcc, \reg[4], \reg[2], vcc
    v_subrev_u32    \reg[4], vcc, \divisor, \reg[5]
    v_subbrev_u32   \reg[6], vcc, 0, \reg[2], vcc
    v_cmp_le_u32    vcc, \divisor, \reg[4]
    v_cndmask_b32   \reg[4], 0, -1, vcc
    v_cmp_eq_u32    vcc, 0, \reg[6]
    v_cndmask_b32   \reg[4], -1, \reg[4], vcc
    v_add_u32       \reg[6], vcc, 2, \reg[3]
    v_add_u32       \reg[7], vcc, 1, \reg[3]
    v_cmp_lg_u32    vcc, 0, \reg[4]
    v_cndmask_b32   \reg[4], \reg[7], \reg[6], vcc
    v_cmp_le_u32    vcc, \divisor, \reg[5]
    v_cndmask_b32   \reg[5], 0, -1, vcc
    v_cmp_eq_u32    vcc, 0, \reg[2]
    v_cndmask_b32   \reg[2], -1, \reg[5], vcc
    v_cmp_lg_u32    vcc, 0, \reg[2]
    v_cndmask_b32   \result, \reg[3], \reg[4], vcc
.endif
.endm
