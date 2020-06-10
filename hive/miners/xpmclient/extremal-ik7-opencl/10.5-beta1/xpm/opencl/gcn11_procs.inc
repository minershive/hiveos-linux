# Generated for CLRadeonExtender, do not edit!
#  Date: 2020-06-09 18:52:25

.macro load3dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*2
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx2 \op[0:1], \addrv[0:1]
  flat_load_dword   \op[2], \addrv[2:3]
  s_waitcnt           vmcnt(0)
.endm

.macro load4dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[0:3], \addrv[0:1]
  s_waitcnt           vmcnt(0)
.endm

.macro load6dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[0:3], \addrv[0:1]
  flat_load_dwordx2 \op[4:5], \addrv[2:3]
  s_waitcnt           vmcnt(0)
.endm

.macro load8dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[0:3], \addrv[0:1]
  flat_load_dwordx4 \op[4:7], \addrv[2:3]
  s_waitcnt           vmcnt(0)
.endm

.macro load10dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[0:3], \addrv[0:1]
  flat_load_dwordx4 \op[4:7], \addrv[2:3]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx2 \op[8:9], \addrv[2:3]
  s_waitcnt           vmcnt(0)
.endm

.macro load11dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[0:3], \addrv[0:1]
  flat_load_dwordx4 \op[4:7], \addrv[2:3]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*10
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_load_dwordx2 \op[8:9], \addrv[2:3]
  flat_load_dword   \op[10], \addrv[4:5]
  s_waitcnt           vmcnt(0)
.endm

.macro load20dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[0:3], \addrv[0:1]
  flat_load_dwordx4 \op[4:7], \addrv[2:3]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[8:11], \addrv[2:3]
  flat_load_dwordx4 \op[12:15], \addrv[4:5]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*16
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_load_dwordx4 \op[16:19], \addrv[2:3]
  s_waitcnt           vmcnt(0)
.endm

.macro store1dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  flat_store_dword   \addrv[0:1], \op[0]
  s_waitcnt           vmcnt(0)
.endm

.macro store8dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  s_waitcnt           vmcnt(0)
.endm

.macro store10dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx2 \addrv[2:3], \op[8:9]
  s_waitcnt           vmcnt(0)
.endm

.macro store11dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*10
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx2 \addrv[2:3], \op[8:9]
  flat_store_dword   \addrv[4:5], \op[10]
  s_waitcnt           vmcnt(0)
.endm

.macro store13dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dword   \addrv[4:5], \op[12]
  s_waitcnt           vmcnt(0)
.endm

.macro store14dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dwordx2 \addrv[4:5], \op[12:13]
  s_waitcnt           vmcnt(0)
.endm

.macro store16dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dwordx4 \addrv[4:5], \op[12:15]
  s_waitcnt           vmcnt(0)
.endm

.macro store15dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*14
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx2 \addrv[2:3], \op[12:13]
  flat_store_dword   \addrv[4:5], \op[14]
  s_waitcnt           vmcnt(0)
.endm

.macro store17dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dwordx4 \addrv[4:5], \op[12:15]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*16
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dword   \addrv[2:3], \op[16]
  s_waitcnt           vmcnt(0)
.endm

.macro store20dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dwordx4 \addrv[4:5], \op[12:15]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*16
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[16:19]
  s_waitcnt           vmcnt(0)
.endm

.macro store22dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dwordx4 \addrv[4:5], \op[12:15]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*16
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_mov_b32           \offset, 4*20
  v_add_u32        \addrv[4], vcc, \addrv[0], \offset
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[16:19]
  flat_store_dwordx2 \addrv[4:5], \op[20:21]
  s_waitcnt           vmcnt(0)
.endm

.macro store40dw, op, addr, offset, addrv
  v_add_u32        \addrv[0], vcc, \addr[0], \offset
  v_mov_b32           \addrv[1], \addr[1]
  v_addc_u32       \addrv[1], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*4
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[0:1], \op[0:3]
  flat_store_dwordx4 \addrv[2:3], \op[4:7]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*8
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_add_u32        \addrv[4], vcc, \addrv[0], 4*12
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[8:11]
  flat_store_dwordx4 \addrv[4:5], \op[12:15]
  v_add_u32        \addrv[2], vcc, \addrv[0], 4*16
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_mov_b32           \offset, 4*20
  v_add_u32        \addrv[4], vcc, \addrv[0], \offset
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[16:19]
  flat_store_dwordx4 \addrv[4:5], \op[20:23]
  v_mov_b32           \offset, 4*24
  v_add_u32        \addrv[2], vcc, \addrv[0], \offset
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_mov_b32           \offset, 4*28
  v_add_u32        \addrv[4], vcc, \addrv[0], \offset
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[24:27]
  flat_store_dwordx4 \addrv[4:5], \op[28:31]
  v_mov_b32           \offset, 4*32
  v_add_u32        \addrv[2], vcc, \addrv[0], \offset
  v_addc_u32       \addrv[3], vcc, \addrv[1], 0, vcc
  v_mov_b32           \offset, 4*36
  v_add_u32        \addrv[4], vcc, \addrv[0], \offset
  v_addc_u32       \addrv[5], vcc, \addrv[1], 0, vcc
  flat_store_dwordx4 \addrv[2:3], \op[32:35]
  flat_store_dwordx4 \addrv[4:5], \op[36:39]
  s_waitcnt           vmcnt(0)
.endm

.macro limbshl8, reg
  v_mov_b32        \reg[7], \reg[6]
  v_mov_b32        \reg[6], \reg[5]
  v_mov_b32        \reg[5], \reg[4]
  v_mov_b32        \reg[4], \reg[3]
  v_mov_b32        \reg[3], \reg[2]
  v_mov_b32        \reg[2], \reg[1]
  v_mov_b32        \reg[1], \reg[0]
  v_mov_b32        \reg[0], 0
.endm

.macro limbshl10, reg
  v_mov_b32        \reg[9], \reg[8]
  v_mov_b32        \reg[8], \reg[7]
  v_mov_b32        \reg[7], \reg[6]
  v_mov_b32        \reg[6], \reg[5]
  v_mov_b32        \reg[5], \reg[4]
  v_mov_b32        \reg[4], \reg[3]
  v_mov_b32        \reg[3], \reg[2]
  v_mov_b32        \reg[2], \reg[1]
  v_mov_b32        \reg[1], \reg[0]
  v_mov_b32        \reg[0], 0
.endm

.macro limbshl11, reg
  v_mov_b32        \reg[10], \reg[9]
  v_mov_b32        \reg[9], \reg[8]
  v_mov_b32        \reg[8], \reg[7]
  v_mov_b32        \reg[7], \reg[6]
  v_mov_b32        \reg[6], \reg[5]
  v_mov_b32        \reg[5], \reg[4]
  v_mov_b32        \reg[4], \reg[3]
  v_mov_b32        \reg[3], \reg[2]
  v_mov_b32        \reg[2], \reg[1]
  v_mov_b32        \reg[1], \reg[0]
  v_mov_b32        \reg[0], 0
.endm

.macro limbshl15, reg
  v_mov_b32        \reg[14], \reg[13]
  v_mov_b32        \reg[13], \reg[12]
  v_mov_b32        \reg[12], \reg[11]
  v_mov_b32        \reg[11], \reg[10]
  v_mov_b32        \reg[10], \reg[9]
  v_mov_b32        \reg[9], \reg[8]
  v_mov_b32        \reg[8], \reg[7]
  v_mov_b32        \reg[7], \reg[6]
  v_mov_b32        \reg[6], \reg[5]
  v_mov_b32        \reg[5], \reg[4]
  v_mov_b32        \reg[4], \reg[3]
  v_mov_b32        \reg[3], \reg[2]
  v_mov_b32        \reg[2], \reg[1]
  v_mov_b32        \reg[1], \reg[0]
  v_mov_b32        \reg[0], 0
.endm

.macro limbshl16, reg
  v_mov_b32        \reg[15], \reg[14]
  v_mov_b32        \reg[14], \reg[13]
  v_mov_b32        \reg[13], \reg[12]
  v_mov_b32        \reg[12], \reg[11]
  v_mov_b32        \reg[11], \reg[10]
  v_mov_b32        \reg[10], \reg[9]
  v_mov_b32        \reg[9], \reg[8]
  v_mov_b32        \reg[8], \reg[7]
  v_mov_b32        \reg[7], \reg[6]
  v_mov_b32        \reg[6], \reg[5]
  v_mov_b32        \reg[5], \reg[4]
  v_mov_b32        \reg[4], \reg[3]
  v_mov_b32        \reg[3], \reg[2]
  v_mov_b32        \reg[2], \reg[1]
  v_mov_b32        \reg[1], \reg[0]
  v_mov_b32        \reg[0], 0
.endm

.macro shl10, op, count, reg
  v_mov_b32           \reg[0], 0xFFFFFFFF
  v_cmp_eq_u32        vcc, \count, 0
  v_cndmask_b32       \reg[1], \reg[0], 0, vcc
  v_sub_u32        \reg[0], vcc, 32, \count
  v_lshlrev_b32        \op[9], \count, \op[9]
  v_lshrrev_b32        \reg[2], \reg[0], \op[8]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[9], \reg[2], \op[9]
  v_lshlrev_b32        \op[8], \count, \op[8]
  v_lshrrev_b32        \reg[2], \reg[0], \op[7]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[8], \reg[2], \op[8]
  v_lshlrev_b32        \op[7], \count, \op[7]
  v_lshrrev_b32        \reg[2], \reg[0], \op[6]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[7], \reg[2], \op[7]
  v_lshlrev_b32        \op[6], \count, \op[6]
  v_lshrrev_b32        \reg[2], \reg[0], \op[5]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[6], \reg[2], \op[6]
  v_lshlrev_b32        \op[5], \count, \op[5]
  v_lshrrev_b32        \reg[2], \reg[0], \op[4]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[5], \reg[2], \op[5]
  v_lshlrev_b32        \op[4], \count, \op[4]
  v_lshrrev_b32        \reg[2], \reg[0], \op[3]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[4], \reg[2], \op[4]
  v_lshlrev_b32        \op[3], \count, \op[3]
  v_lshrrev_b32        \reg[2], \reg[0], \op[2]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[3], \reg[2], \op[3]
  v_lshlrev_b32        \op[2], \count, \op[2]
  v_lshrrev_b32        \reg[2], \reg[0], \op[1]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[2], \reg[2], \op[2]
  v_lshlrev_b32        \op[1], \count, \op[1]
  v_lshrrev_b32        \reg[2], \reg[0], \op[0]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[1], \reg[2], \op[1]
  v_lshlrev_b32        \op[0], \count, \op[0]
.endm

.macro shl11, op, count, reg
  v_mov_b32           \reg[0], 0xFFFFFFFF
  v_cmp_eq_u32        vcc, \count, 0
  v_cndmask_b32       \reg[1], \reg[0], 0, vcc
  v_sub_u32        \reg[0], vcc, 32, \count
  v_lshlrev_b32        \op[10], \count, \op[10]
  v_lshrrev_b32        \reg[2], \reg[0], \op[9]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[10], \reg[2], \op[10]
  v_lshlrev_b32        \op[9], \count, \op[9]
  v_lshrrev_b32        \reg[2], \reg[0], \op[8]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[9], \reg[2], \op[9]
  v_lshlrev_b32        \op[8], \count, \op[8]
  v_lshrrev_b32        \reg[2], \reg[0], \op[7]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[8], \reg[2], \op[8]
  v_lshlrev_b32        \op[7], \count, \op[7]
  v_lshrrev_b32        \reg[2], \reg[0], \op[6]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[7], \reg[2], \op[7]
  v_lshlrev_b32        \op[6], \count, \op[6]
  v_lshrrev_b32        \reg[2], \reg[0], \op[5]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[6], \reg[2], \op[6]
  v_lshlrev_b32        \op[5], \count, \op[5]
  v_lshrrev_b32        \reg[2], \reg[0], \op[4]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[5], \reg[2], \op[5]
  v_lshlrev_b32        \op[4], \count, \op[4]
  v_lshrrev_b32        \reg[2], \reg[0], \op[3]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[4], \reg[2], \op[4]
  v_lshlrev_b32        \op[3], \count, \op[3]
  v_lshrrev_b32        \reg[2], \reg[0], \op[2]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[3], \reg[2], \op[3]
  v_lshlrev_b32        \op[2], \count, \op[2]
  v_lshrrev_b32        \reg[2], \reg[0], \op[1]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[2], \reg[2], \op[2]
  v_lshlrev_b32        \op[1], \count, \op[1]
  v_lshrrev_b32        \reg[2], \reg[0], \op[0]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[1], \reg[2], \op[1]
  v_lshlrev_b32        \op[0], \count, \op[0]
.endm

.macro shl15, op, count, reg
  v_mov_b32           \reg[0], 0xFFFFFFFF
  v_cmp_eq_u32        vcc, \count, 0
  v_cndmask_b32       \reg[1], \reg[0], 0, vcc
  v_sub_u32        \reg[0], vcc, 32, \count
  v_lshlrev_b32        \op[14], \count, \op[14]
  v_lshrrev_b32        \reg[2], \reg[0], \op[13]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[14], \reg[2], \op[14]
  v_lshlrev_b32        \op[13], \count, \op[13]
  v_lshrrev_b32        \reg[2], \reg[0], \op[12]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[13], \reg[2], \op[13]
  v_lshlrev_b32        \op[12], \count, \op[12]
  v_lshrrev_b32        \reg[2], \reg[0], \op[11]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[12], \reg[2], \op[12]
  v_lshlrev_b32        \op[11], \count, \op[11]
  v_lshrrev_b32        \reg[2], \reg[0], \op[10]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[11], \reg[2], \op[11]
  v_lshlrev_b32        \op[10], \count, \op[10]
  v_lshrrev_b32        \reg[2], \reg[0], \op[9]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[10], \reg[2], \op[10]
  v_lshlrev_b32        \op[9], \count, \op[9]
  v_lshrrev_b32        \reg[2], \reg[0], \op[8]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[9], \reg[2], \op[9]
  v_lshlrev_b32        \op[8], \count, \op[8]
  v_lshrrev_b32        \reg[2], \reg[0], \op[7]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[8], \reg[2], \op[8]
  v_lshlrev_b32        \op[7], \count, \op[7]
  v_lshrrev_b32        \reg[2], \reg[0], \op[6]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[7], \reg[2], \op[7]
  v_lshlrev_b32        \op[6], \count, \op[6]
  v_lshrrev_b32        \reg[2], \reg[0], \op[5]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[6], \reg[2], \op[6]
  v_lshlrev_b32        \op[5], \count, \op[5]
  v_lshrrev_b32        \reg[2], \reg[0], \op[4]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[5], \reg[2], \op[5]
  v_lshlrev_b32        \op[4], \count, \op[4]
  v_lshrrev_b32        \reg[2], \reg[0], \op[3]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[4], \reg[2], \op[4]
  v_lshlrev_b32        \op[3], \count, \op[3]
  v_lshrrev_b32        \reg[2], \reg[0], \op[2]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[3], \reg[2], \op[3]
  v_lshlrev_b32        \op[2], \count, \op[2]
  v_lshrrev_b32        \reg[2], \reg[0], \op[1]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[2], \reg[2], \op[2]
  v_lshlrev_b32        \op[1], \count, \op[1]
  v_lshrrev_b32        \reg[2], \reg[0], \op[0]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[1], \reg[2], \op[1]
  v_lshlrev_b32        \op[0], \count, \op[0]
.endm

.macro shl16, op, count, reg
  v_mov_b32           \reg[0], 0xFFFFFFFF
  v_cmp_eq_u32        vcc, \count, 0
  v_cndmask_b32       \reg[1], \reg[0], 0, vcc
  v_sub_u32        \reg[0], vcc, 32, \count
  v_lshlrev_b32        \op[15], \count, \op[15]
  v_lshrrev_b32        \reg[2], \reg[0], \op[14]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[15], \reg[2], \op[15]
  v_lshlrev_b32        \op[14], \count, \op[14]
  v_lshrrev_b32        \reg[2], \reg[0], \op[13]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[14], \reg[2], \op[14]
  v_lshlrev_b32        \op[13], \count, \op[13]
  v_lshrrev_b32        \reg[2], \reg[0], \op[12]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[13], \reg[2], \op[13]
  v_lshlrev_b32        \op[12], \count, \op[12]
  v_lshrrev_b32        \reg[2], \reg[0], \op[11]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[12], \reg[2], \op[12]
  v_lshlrev_b32        \op[11], \count, \op[11]
  v_lshrrev_b32        \reg[2], \reg[0], \op[10]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[11], \reg[2], \op[11]
  v_lshlrev_b32        \op[10], \count, \op[10]
  v_lshrrev_b32        \reg[2], \reg[0], \op[9]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[10], \reg[2], \op[10]
  v_lshlrev_b32        \op[9], \count, \op[9]
  v_lshrrev_b32        \reg[2], \reg[0], \op[8]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[9], \reg[2], \op[9]
  v_lshlrev_b32        \op[8], \count, \op[8]
  v_lshrrev_b32        \reg[2], \reg[0], \op[7]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[8], \reg[2], \op[8]
  v_lshlrev_b32        \op[7], \count, \op[7]
  v_lshrrev_b32        \reg[2], \reg[0], \op[6]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[7], \reg[2], \op[7]
  v_lshlrev_b32        \op[6], \count, \op[6]
  v_lshrrev_b32        \reg[2], \reg[0], \op[5]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[6], \reg[2], \op[6]
  v_lshlrev_b32        \op[5], \count, \op[5]
  v_lshrrev_b32        \reg[2], \reg[0], \op[4]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[5], \reg[2], \op[5]
  v_lshlrev_b32        \op[4], \count, \op[4]
  v_lshrrev_b32        \reg[2], \reg[0], \op[3]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[4], \reg[2], \op[4]
  v_lshlrev_b32        \op[3], \count, \op[3]
  v_lshrrev_b32        \reg[2], \reg[0], \op[2]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[3], \reg[2], \op[3]
  v_lshlrev_b32        \op[2], \count, \op[2]
  v_lshrrev_b32        \reg[2], \reg[0], \op[1]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[2], \reg[2], \op[2]
  v_lshlrev_b32        \op[1], \count, \op[1]
  v_lshrrev_b32        \reg[2], \reg[0], \op[0]
  v_and_b32            \reg[2], \reg[1], \reg[2]
  v_or_b32             \op[1], \reg[2], \op[1]
  v_lshlrev_b32        \op[0], \count, \op[0]
.endm

.macro submul320, op1, op2, m, reg, sreg, zero
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[0], \zero[0:1]
  v_sub_u32        \op1[0], vcc, \op1[0], \reg[0]
  v_subb_u32       \op1[1], vcc, \op1[1], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[2], \zero[0:1]
  v_subb_u32       \op1[2], vcc, \op1[2], \reg[0], vcc
  v_subb_u32       \op1[3], vcc, \op1[3], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[4], \zero[0:1]
  v_subb_u32       \op1[4], vcc, \op1[4], \reg[0], vcc
  v_subb_u32       \op1[5], vcc, \op1[5], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[6], \zero[0:1]
  v_subb_u32       \op1[6], vcc, \op1[6], \reg[0], vcc
  v_subb_u32       \op1[7], vcc, \op1[7], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[8], \zero[0:1]
  v_subb_u32       \op1[8], vcc, \op1[8], \reg[0], vcc
  v_subb_u32       \op1[9], vcc, \op1[9], \reg[1], vcc
  v_subb_u32       \op1[10], vcc, \op1[10], 0, vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[1], \zero[0:1]
  v_sub_u32        \op1[1], vcc, \op1[1], \reg[0]
  v_subb_u32       \op1[2], vcc, \op1[2], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[3], \zero[0:1]
  v_subb_u32       \op1[3], vcc, \op1[3], \reg[0], vcc
  v_subb_u32       \op1[4], vcc, \op1[4], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[5], \zero[0:1]
  v_subb_u32       \op1[5], vcc, \op1[5], \reg[0], vcc
  v_subb_u32       \op1[6], vcc, \op1[6], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[7], \zero[0:1]
  v_subb_u32       \op1[7], vcc, \op1[7], \reg[0], vcc
  v_subb_u32       \op1[8], vcc, \op1[8], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[9], \zero[0:1]
  v_subb_u32       \op1[9], vcc, \op1[9], \reg[0], vcc
  v_subb_u32       \op1[10], vcc, \op1[10], \reg[1], vcc
.endm

.macro submul352, op1, op2, m, reg, sreg, zero
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[0], \zero[0:1]
  v_sub_u32        \op1[0], vcc, \op1[0], \reg[0]
  v_subb_u32       \op1[1], vcc, \op1[1], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[2], \zero[0:1]
  v_subb_u32       \op1[2], vcc, \op1[2], \reg[0], vcc
  v_subb_u32       \op1[3], vcc, \op1[3], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[4], \zero[0:1]
  v_subb_u32       \op1[4], vcc, \op1[4], \reg[0], vcc
  v_subb_u32       \op1[5], vcc, \op1[5], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[6], \zero[0:1]
  v_subb_u32       \op1[6], vcc, \op1[6], \reg[0], vcc
  v_subb_u32       \op1[7], vcc, \op1[7], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[8], \zero[0:1]
  v_subb_u32       \op1[8], vcc, \op1[8], \reg[0], vcc
  v_subb_u32       \op1[9], vcc, \op1[9], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[10], \zero[0:1]
  v_subb_u32       \op1[10], vcc, \op1[10], \reg[0], vcc
  v_subb_u32       \op1[11], vcc, \op1[11], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[1], \zero[0:1]
  v_sub_u32        \op1[1], vcc, \op1[1], \reg[0]
  v_subb_u32       \op1[2], vcc, \op1[2], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[3], \zero[0:1]
  v_subb_u32       \op1[3], vcc, \op1[3], \reg[0], vcc
  v_subb_u32       \op1[4], vcc, \op1[4], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[5], \zero[0:1]
  v_subb_u32       \op1[5], vcc, \op1[5], \reg[0], vcc
  v_subb_u32       \op1[6], vcc, \op1[6], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[7], \zero[0:1]
  v_subb_u32       \op1[7], vcc, \op1[7], \reg[0], vcc
  v_subb_u32       \op1[8], vcc, \op1[8], \reg[1], vcc
  v_mad_u64_u32       \reg[0:1], \sreg[0:1], \m, \op2[9], \zero[0:1]
  v_subb_u32       \op1[9], vcc, \op1[9], \reg[0], vcc
  v_subb_u32       \op1[10], vcc, \op1[10], \reg[1], vcc
  v_subb_u32       \op1[11], vcc, \op1[11], 0, vcc
.endm

.macro mul320to96, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
.endm

.macro mul320to128, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
.endm

.macro mul320to192, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[5], \in2[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[6], \in2[4], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[6], \in2[5], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[7], \in2[4], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[7], \in2[5], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[8], \in2[4], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[8], \in2[5], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[9], \in2[4], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[9], \in2[5], \out[14:15]
.endm

.macro mul320to96l320, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
.endm

.macro mul320to128l320, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
.endm

.macro mul320to192l320, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
.endm

.macro mul352to96, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[10], \in2[1], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[10], \in2[2], \out[12:13]
.endm

.macro mul352to128, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[10], \in2[1], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[10], \in2[2], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[10], \in2[3], \out[13:14]
.endm

.macro mul352to192, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[5], \in2[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[6], \in2[4], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[6], \in2[5], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[7], \in2[4], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[10], \in2[1], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[7], \in2[5], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[8], \in2[4], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[10], \in2[2], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[8], \in2[5], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[9], \in2[4], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[10], \in2[3], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[9], \in2[5], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[10], \in2[4], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[10], \in2[5], \out[15:16]
.endm

.macro mul352to96l352, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
.endm

.macro mul352to128l352, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
.endm

.macro mul352to192l352, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_mad_u64_u32      \out[10:11], vcc, \in1[5], \in2[5], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[6], \in2[4], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
.endm

.macro sqr320, in, out, cache, zero, calc
  v_add_u32         \cache[0], vcc, \in[0], \in[0]
  v_subb_u32        \cache[1], vcc, 0, 0, vcc
  v_add_u32         \cache[2], vcc, \in[1], \in[1]
  v_subb_u32        \cache[3], vcc, 0, 0, vcc
  v_add_u32         \cache[4], vcc, \in[2], \in[2]
  v_subb_u32        \cache[5], vcc, 0, 0, vcc
  v_add_u32         \cache[6], vcc, \in[3], \in[3]
  v_subb_u32        \cache[7], vcc, 0, 0, vcc
  v_add_u32         \cache[8], vcc, \in[4], \in[4]
  v_subb_u32        \cache[9], vcc, 0, 0, vcc
  v_add_u32         \cache[10], vcc, \in[5], \in[5]
  v_subb_u32        \cache[11], vcc, 0, 0, vcc
  v_add_u32         \cache[12], vcc, \in[6], \in[6]
  v_subb_u32        \cache[13], vcc, 0, 0, vcc
  v_add_u32         \cache[14], vcc, \in[7], \in[7]
  v_subb_u32        \cache[15], vcc, 0, 0, vcc
  v_add_u32         \cache[16], vcc, \in[8], \in[8]
  v_subb_u32        \cache[17], vcc, 0, 0, vcc
  v_add_u32         \cache[18], vcc, \in[9], \in[9]
  v_subb_u32        \cache[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[0:1], vcc, \in[0], \in[0], \zero[0:1]
  v_and_b32          \out[2], \cache[1], \in[1]
  v_mad_u64_u32      \out[1:2], vcc, \cache[0], \in[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_and_b32          \calc[0], \cache[1], \in[2]
  v_add_u32       \out[3], vcc, \calc[0], \out[3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \cache[0], \in[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in[1], \in[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_and_b32          \calc[0], \cache[1], \in[3]
  v_add_u32       \out[4], vcc, \calc[0], \out[4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \cache[0], \in[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_and_b32          \calc[0], \cache[3], \in[2]
  v_add_u32       \out[4], vcc, \calc[0], \out[4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \cache[2], \in[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_and_b32          \calc[0], \cache[1], \in[4]
  v_add_u32       \out[5], vcc, \calc[0], \out[5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \cache[0], \in[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_and_b32          \calc[0], \cache[3], \in[3]
  v_add_u32       \out[5], vcc, \calc[0], \out[5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \cache[2], \in[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in[2], \in[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_and_b32          \calc[0], \cache[1], \in[5]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[0], \in[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[3], \in[4]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[2], \in[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[5], \in[3]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[4], \in[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[1], \in[6]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[0], \in[6], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[3], \in[5]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[2], \in[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[5], \in[4]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[4], \in[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in[3], \in[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[1], \in[7]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[0], \in[7], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[3], \in[6]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[2], \in[6], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[5], \in[5]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[4], \in[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[7], \in[4]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[6], \in[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[1], \in[8]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[0], \in[8], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[3], \in[7]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[2], \in[7], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[5], \in[6]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[4], \in[6], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[7], \in[5]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[6], \in[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in[4], \in[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[1], \in[9]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[0], \in[9], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[3], \in[8]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[2], \in[8], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[5], \in[7]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[4], \in[7], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[7], \in[6]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[6], \in[6], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[9], \in[5]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[8], \in[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[3], \in[9]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[2], \in[9], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[5], \in[8]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[4], \in[8], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[7], \in[7]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[6], \in[7], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[9], \in[6]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[8], \in[6], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in[5], \in[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[5], \in[9]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[4], \in[9], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[7], \in[8]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[6], \in[8], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[9], \in[7]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[8], \in[7], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[11], \in[6]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[10], \in[6], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[7], \in[9]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[6], \in[9], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[9], \in[8]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[8], \in[8], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[11], \in[7]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[10], \in[7], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in[6], \in[6], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[9], \in[9]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[8], \in[9], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[11], \in[8]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[10], \in[8], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[13], \in[7]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[12], \in[7], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[11], \in[9]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[10], \in[9], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[13], \in[8]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[12], \in[8], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in[7], \in[7], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[13], \in[9]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[12], \in[9], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[15], \in[8]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[14], \in[8], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[15], \in[9]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[14], \in[9], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in[8], \in[8], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[17], \in[9]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[16], \in[9], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in[9], \in[9], \out[18:19]
.endm

.macro sqr352, in, out, cache, zero, calc
  v_add_u32         \cache[0], vcc, \in[0], \in[0]
  v_subb_u32        \cache[1], vcc, 0, 0, vcc
  v_add_u32         \cache[2], vcc, \in[1], \in[1]
  v_subb_u32        \cache[3], vcc, 0, 0, vcc
  v_add_u32         \cache[4], vcc, \in[2], \in[2]
  v_subb_u32        \cache[5], vcc, 0, 0, vcc
  v_add_u32         \cache[6], vcc, \in[3], \in[3]
  v_subb_u32        \cache[7], vcc, 0, 0, vcc
  v_add_u32         \cache[8], vcc, \in[4], \in[4]
  v_subb_u32        \cache[9], vcc, 0, 0, vcc
  v_add_u32         \cache[10], vcc, \in[5], \in[5]
  v_subb_u32        \cache[11], vcc, 0, 0, vcc
  v_add_u32         \cache[12], vcc, \in[6], \in[6]
  v_subb_u32        \cache[13], vcc, 0, 0, vcc
  v_add_u32         \cache[14], vcc, \in[7], \in[7]
  v_subb_u32        \cache[15], vcc, 0, 0, vcc
  v_add_u32         \cache[16], vcc, \in[8], \in[8]
  v_subb_u32        \cache[17], vcc, 0, 0, vcc
  v_add_u32         \cache[18], vcc, \in[9], \in[9]
  v_subb_u32        \cache[19], vcc, 0, 0, vcc
  v_add_u32         \cache[20], vcc, \in[10], \in[10]
  v_subb_u32        \cache[21], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[0:1], vcc, \in[0], \in[0], \zero[0:1]
  v_and_b32          \out[2], \cache[1], \in[1]
  v_mad_u64_u32      \out[1:2], vcc, \cache[0], \in[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_and_b32          \calc[0], \cache[1], \in[2]
  v_add_u32       \out[3], vcc, \calc[0], \out[3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \cache[0], \in[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in[1], \in[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_and_b32          \calc[0], \cache[1], \in[3]
  v_add_u32       \out[4], vcc, \calc[0], \out[4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \cache[0], \in[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_and_b32          \calc[0], \cache[3], \in[2]
  v_add_u32       \out[4], vcc, \calc[0], \out[4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \cache[2], \in[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_and_b32          \calc[0], \cache[1], \in[4]
  v_add_u32       \out[5], vcc, \calc[0], \out[5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \cache[0], \in[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_and_b32          \calc[0], \cache[3], \in[3]
  v_add_u32       \out[5], vcc, \calc[0], \out[5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \cache[2], \in[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in[2], \in[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_and_b32          \calc[0], \cache[1], \in[5]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[0], \in[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[3], \in[4]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[2], \in[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[5], \in[3]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[4], \in[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[1], \in[6]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[0], \in[6], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[3], \in[5]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[2], \in[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[5], \in[4]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[4], \in[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in[3], \in[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[1], \in[7]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[0], \in[7], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[3], \in[6]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[2], \in[6], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[5], \in[5]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[4], \in[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[7], \in[4]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[6], \in[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[1], \in[8]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[0], \in[8], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[3], \in[7]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[2], \in[7], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[5], \in[6]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[4], \in[6], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[7], \in[5]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[6], \in[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in[4], \in[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[1], \in[9]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[0], \in[9], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[3], \in[8]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[2], \in[8], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[5], \in[7]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[4], \in[7], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[7], \in[6]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[6], \in[6], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[9], \in[5]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[8], \in[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[1], \in[10]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[0], \in[10], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[3], \in[9]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[2], \in[9], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[5], \in[8]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[4], \in[8], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[7], \in[7]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[6], \in[7], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[9], \in[6]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[8], \in[6], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in[5], \in[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[3], \in[10]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[2], \in[10], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[5], \in[9]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[4], \in[9], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[7], \in[8]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[6], \in[8], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[9], \in[7]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[8], \in[7], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[11], \in[6]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[10], \in[6], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[5], \in[10]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[4], \in[10], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[7], \in[9]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[6], \in[9], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[9], \in[8]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[8], \in[8], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[11], \in[7]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[10], \in[7], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in[6], \in[6], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[7], \in[10]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[6], \in[10], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[9], \in[9]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[8], \in[9], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[11], \in[8]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[10], \in[8], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[13], \in[7]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[12], \in[7], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[9], \in[10]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[8], \in[10], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[11], \in[9]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[10], \in[9], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[13], \in[8]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[12], \in[8], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in[7], \in[7], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[11], \in[10]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[10], \in[10], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[13], \in[9]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[12], \in[9], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[15], \in[8]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[14], \in[8], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[13], \in[10]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[12], \in[10], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[15], \in[9]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[14], \in[9], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in[8], \in[8], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[15], \in[10]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[14], \in[10], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[17], \in[9]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[16], \in[9], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[17], \in[10]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[16], \in[10], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in[9], \in[9], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[19], \in[10]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[18], \in[10], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in[10], \in[10], \out[20:21]
.endm

.macro sqr640, in, out, cache, zero, calc
  v_add_u32         \cache[0], vcc, \in[0], \in[0]
  v_subb_u32        \cache[1], vcc, 0, 0, vcc
  v_add_u32         \cache[2], vcc, \in[1], \in[1]
  v_subb_u32        \cache[3], vcc, 0, 0, vcc
  v_add_u32         \cache[4], vcc, \in[2], \in[2]
  v_subb_u32        \cache[5], vcc, 0, 0, vcc
  v_add_u32         \cache[6], vcc, \in[3], \in[3]
  v_subb_u32        \cache[7], vcc, 0, 0, vcc
  v_add_u32         \cache[8], vcc, \in[4], \in[4]
  v_subb_u32        \cache[9], vcc, 0, 0, vcc
  v_add_u32         \cache[10], vcc, \in[5], \in[5]
  v_subb_u32        \cache[11], vcc, 0, 0, vcc
  v_add_u32         \cache[12], vcc, \in[6], \in[6]
  v_subb_u32        \cache[13], vcc, 0, 0, vcc
  v_add_u32         \cache[14], vcc, \in[7], \in[7]
  v_subb_u32        \cache[15], vcc, 0, 0, vcc
  v_add_u32         \cache[16], vcc, \in[8], \in[8]
  v_subb_u32        \cache[17], vcc, 0, 0, vcc
  v_add_u32         \cache[18], vcc, \in[9], \in[9]
  v_subb_u32        \cache[19], vcc, 0, 0, vcc
  v_add_u32         \cache[20], vcc, \in[10], \in[10]
  v_subb_u32        \cache[21], vcc, 0, 0, vcc
  v_add_u32         \cache[22], vcc, \in[11], \in[11]
  v_subb_u32        \cache[23], vcc, 0, 0, vcc
  v_add_u32         \cache[24], vcc, \in[12], \in[12]
  v_subb_u32        \cache[25], vcc, 0, 0, vcc
  v_add_u32         \cache[26], vcc, \in[13], \in[13]
  v_subb_u32        \cache[27], vcc, 0, 0, vcc
  v_add_u32         \cache[28], vcc, \in[14], \in[14]
  v_subb_u32        \cache[29], vcc, 0, 0, vcc
  v_add_u32         \cache[30], vcc, \in[15], \in[15]
  v_subb_u32        \cache[31], vcc, 0, 0, vcc
  v_add_u32         \cache[32], vcc, \in[16], \in[16]
  v_subb_u32        \cache[33], vcc, 0, 0, vcc
  v_add_u32         \cache[34], vcc, \in[17], \in[17]
  v_subb_u32        \cache[35], vcc, 0, 0, vcc
  v_add_u32         \cache[36], vcc, \in[18], \in[18]
  v_subb_u32        \cache[37], vcc, 0, 0, vcc
  v_add_u32         \cache[38], vcc, \in[19], \in[19]
  v_subb_u32        \cache[39], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[0:1], vcc, \in[0], \in[0], \zero[0:1]
  v_and_b32          \out[2], \cache[1], \in[1]
  v_mad_u64_u32      \out[1:2], vcc, \cache[0], \in[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_and_b32          \calc[0], \cache[1], \in[2]
  v_add_u32       \out[3], vcc, \calc[0], \out[3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \cache[0], \in[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in[1], \in[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_and_b32          \calc[0], \cache[1], \in[3]
  v_add_u32       \out[4], vcc, \calc[0], \out[4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \cache[0], \in[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_and_b32          \calc[0], \cache[3], \in[2]
  v_add_u32       \out[4], vcc, \calc[0], \out[4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \cache[2], \in[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_and_b32          \calc[0], \cache[1], \in[4]
  v_add_u32       \out[5], vcc, \calc[0], \out[5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \cache[0], \in[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_and_b32          \calc[0], \cache[3], \in[3]
  v_add_u32       \out[5], vcc, \calc[0], \out[5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \cache[2], \in[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in[2], \in[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_and_b32          \calc[0], \cache[1], \in[5]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[0], \in[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[3], \in[4]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[2], \in[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[5], \in[3]
  v_add_u32       \out[6], vcc, \calc[0], \out[6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \cache[4], \in[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_and_b32          \calc[0], \cache[1], \in[6]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[0], \in[6], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[3], \in[5]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[2], \in[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[5], \in[4]
  v_add_u32       \out[7], vcc, \calc[0], \out[7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \cache[4], \in[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in[3], \in[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_and_b32          \calc[0], \cache[1], \in[7]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[0], \in[7], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[3], \in[6]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[2], \in[6], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[5], \in[5]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[4], \in[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[7], \in[4]
  v_add_u32       \out[8], vcc, \calc[0], \out[8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \cache[6], \in[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_and_b32          \calc[0], \cache[1], \in[8]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[0], \in[8], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[3], \in[7]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[2], \in[7], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[5], \in[6]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[4], \in[6], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[7], \in[5]
  v_add_u32       \out[9], vcc, \calc[0], \out[9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \cache[6], \in[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in[4], \in[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_and_b32          \calc[0], \cache[1], \in[9]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[0], \in[9], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[3], \in[8]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[2], \in[8], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[5], \in[7]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[4], \in[7], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[7], \in[6]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[6], \in[6], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[9], \in[5]
  v_add_u32       \out[10], vcc, \calc[0], \out[10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \cache[8], \in[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_and_b32          \calc[0], \cache[1], \in[10]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[0], \in[10], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[3], \in[9]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[2], \in[9], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[5], \in[8]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[4], \in[8], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[7], \in[7]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[6], \in[7], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[9], \in[6]
  v_add_u32       \out[11], vcc, \calc[0], \out[11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \cache[8], \in[6], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in[5], \in[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_and_b32          \calc[0], \cache[1], \in[11]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[0], \in[11], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[3], \in[10]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[2], \in[10], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[5], \in[9]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[4], \in[9], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[7], \in[8]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[6], \in[8], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[9], \in[7]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[8], \in[7], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[11], \in[6]
  v_add_u32       \out[12], vcc, \calc[0], \out[12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \cache[10], \in[6], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_and_b32          \calc[0], \cache[1], \in[12]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[0], \in[12], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[3], \in[11]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[2], \in[11], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[5], \in[10]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[4], \in[10], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[7], \in[9]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[6], \in[9], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[9], \in[8]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[8], \in[8], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[11], \in[7]
  v_add_u32       \out[13], vcc, \calc[0], \out[13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \cache[10], \in[7], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in[6], \in[6], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_and_b32          \calc[0], \cache[1], \in[13]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[0], \in[13], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[3], \in[12]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[2], \in[12], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[5], \in[11]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[4], \in[11], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[7], \in[10]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[6], \in[10], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[9], \in[9]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[8], \in[9], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[11], \in[8]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[10], \in[8], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[13], \in[7]
  v_add_u32       \out[14], vcc, \calc[0], \out[14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \cache[12], \in[7], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_and_b32          \calc[0], \cache[1], \in[14]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[0], \in[14], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[3], \in[13]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[2], \in[13], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[5], \in[12]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[4], \in[12], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[7], \in[11]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[6], \in[11], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[9], \in[10]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[8], \in[10], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[11], \in[9]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[10], \in[9], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[13], \in[8]
  v_add_u32       \out[15], vcc, \calc[0], \out[15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \cache[12], \in[8], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in[7], \in[7], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_and_b32          \calc[0], \cache[1], \in[15]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[0], \in[15], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[3], \in[14]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[2], \in[14], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[5], \in[13]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[4], \in[13], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[7], \in[12]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[6], \in[12], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[9], \in[11]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[8], \in[11], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[11], \in[10]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[10], \in[10], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[13], \in[9]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[12], \in[9], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[15], \in[8]
  v_add_u32       \out[16], vcc, \calc[0], \out[16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \cache[14], \in[8], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_and_b32          \calc[0], \cache[1], \in[16]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[0], \in[16], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[3], \in[15]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[2], \in[15], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[5], \in[14]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[4], \in[14], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[7], \in[13]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[6], \in[13], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[9], \in[12]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[8], \in[12], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[11], \in[11]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[10], \in[11], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[13], \in[10]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[12], \in[10], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[15], \in[9]
  v_add_u32       \out[17], vcc, \calc[0], \out[17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \cache[14], \in[9], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in[8], \in[8], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_and_b32          \calc[0], \cache[1], \in[17]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[0], \in[17], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[3], \in[16]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[2], \in[16], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[5], \in[15]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[4], \in[15], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[7], \in[14]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[6], \in[14], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[9], \in[13]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[8], \in[13], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[11], \in[12]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[10], \in[12], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[13], \in[11]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[12], \in[11], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[15], \in[10]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[14], \in[10], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[17], \in[9]
  v_add_u32       \out[18], vcc, \calc[0], \out[18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \cache[16], \in[9], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_and_b32          \calc[0], \cache[1], \in[18]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[0], \in[18], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[3], \in[17]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[2], \in[17], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[5], \in[16]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[4], \in[16], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[7], \in[15]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[6], \in[15], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[9], \in[14]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[8], \in[14], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[11], \in[13]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[10], \in[13], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[13], \in[12]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[12], \in[12], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[15], \in[11]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[14], \in[11], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[17], \in[10]
  v_add_u32       \out[19], vcc, \calc[0], \out[19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \cache[16], \in[10], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in[9], \in[9], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_and_b32          \calc[0], \cache[1], \in[19]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[0], \in[19], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[3], \in[18]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[2], \in[18], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[5], \in[17]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[4], \in[17], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[7], \in[16]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[6], \in[16], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[9], \in[15]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[8], \in[15], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[11], \in[14]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[10], \in[14], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[13], \in[13]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[12], \in[13], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[15], \in[12]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[14], \in[12], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[17], \in[11]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[16], \in[11], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[19], \in[10]
  v_add_u32       \out[20], vcc, \calc[0], \out[20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \cache[18], \in[10], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_and_b32          \calc[0], \cache[3], \in[19]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[2], \in[19], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[5], \in[18]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[4], \in[18], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[7], \in[17]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[6], \in[17], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[9], \in[16]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[8], \in[16], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[11], \in[15]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[10], \in[15], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[13], \in[14]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[12], \in[14], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[15], \in[13]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[14], \in[13], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[17], \in[12]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[16], \in[12], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[19], \in[11]
  v_add_u32       \out[21], vcc, \calc[0], \out[21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \cache[18], \in[11], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in[10], \in[10], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_and_b32          \calc[0], \cache[5], \in[19]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[4], \in[19], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[7], \in[18]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[6], \in[18], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[9], \in[17]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[8], \in[17], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[11], \in[16]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[10], \in[16], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[13], \in[15]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[12], \in[15], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[15], \in[14]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[14], \in[14], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[17], \in[13]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[16], \in[13], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[19], \in[12]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[18], \in[12], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[21], \in[11]
  v_add_u32       \out[22], vcc, \calc[0], \out[22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \cache[20], \in[11], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_and_b32          \calc[0], \cache[7], \in[19]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[6], \in[19], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[9], \in[18]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[8], \in[18], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[11], \in[17]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[10], \in[17], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[13], \in[16]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[12], \in[16], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[15], \in[15]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[14], \in[15], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[17], \in[14]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[16], \in[14], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[19], \in[13]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[18], \in[13], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[21], \in[12]
  v_add_u32       \out[23], vcc, \calc[0], \out[23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \cache[20], \in[12], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in[11], \in[11], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_and_b32          \calc[0], \cache[9], \in[19]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[8], \in[19], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[11], \in[18]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[10], \in[18], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[13], \in[17]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[12], \in[17], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[15], \in[16]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[14], \in[16], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[17], \in[15]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[16], \in[15], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[19], \in[14]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[18], \in[14], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[21], \in[13]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[20], \in[13], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[23], \in[12]
  v_add_u32       \out[24], vcc, \calc[0], \out[24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \cache[22], \in[12], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_and_b32          \calc[0], \cache[11], \in[19]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[10], \in[19], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[13], \in[18]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[12], \in[18], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[15], \in[17]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[14], \in[17], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[17], \in[16]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[16], \in[16], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[19], \in[15]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[18], \in[15], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[21], \in[14]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[20], \in[14], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[23], \in[13]
  v_add_u32       \out[25], vcc, \calc[0], \out[25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \cache[22], \in[13], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in[12], \in[12], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_and_b32          \calc[0], \cache[13], \in[19]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[12], \in[19], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[15], \in[18]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[14], \in[18], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[17], \in[17]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[16], \in[17], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[19], \in[16]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[18], \in[16], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[21], \in[15]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[20], \in[15], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[23], \in[14]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[22], \in[14], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[25], \in[13]
  v_add_u32       \out[26], vcc, \calc[0], \out[26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \cache[24], \in[13], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_and_b32          \calc[0], \cache[15], \in[19]
  v_add_u32       \out[27], vcc, \calc[0], \out[27]
  v_addc_u32      \out[28], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[26:27], vcc, \cache[14], \in[19], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_and_b32          \calc[0], \cache[17], \in[18]
  v_add_u32       \out[27], vcc, \calc[0], \out[27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \cache[16], \in[18], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_and_b32          \calc[0], \cache[19], \in[17]
  v_add_u32       \out[27], vcc, \calc[0], \out[27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \cache[18], \in[17], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_and_b32          \calc[0], \cache[21], \in[16]
  v_add_u32       \out[27], vcc, \calc[0], \out[27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \cache[20], \in[16], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_and_b32          \calc[0], \cache[23], \in[15]
  v_add_u32       \out[27], vcc, \calc[0], \out[27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \cache[22], \in[15], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_and_b32          \calc[0], \cache[25], \in[14]
  v_add_u32       \out[27], vcc, \calc[0], \out[27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \cache[24], \in[14], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in[13], \in[13], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_and_b32          \calc[0], \cache[17], \in[19]
  v_add_u32       \out[28], vcc, \calc[0], \out[28]
  v_addc_u32      \out[29], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[27:28], vcc, \cache[16], \in[19], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_and_b32          \calc[0], \cache[19], \in[18]
  v_add_u32       \out[28], vcc, \calc[0], \out[28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \cache[18], \in[18], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_and_b32          \calc[0], \cache[21], \in[17]
  v_add_u32       \out[28], vcc, \calc[0], \out[28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \cache[20], \in[17], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_and_b32          \calc[0], \cache[23], \in[16]
  v_add_u32       \out[28], vcc, \calc[0], \out[28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \cache[22], \in[16], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_and_b32          \calc[0], \cache[25], \in[15]
  v_add_u32       \out[28], vcc, \calc[0], \out[28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \cache[24], \in[15], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_and_b32          \calc[0], \cache[27], \in[14]
  v_add_u32       \out[28], vcc, \calc[0], \out[28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \cache[26], \in[14], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_and_b32          \calc[0], \cache[19], \in[19]
  v_add_u32       \out[29], vcc, \calc[0], \out[29]
  v_addc_u32      \out[30], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[28:29], vcc, \cache[18], \in[19], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_and_b32          \calc[0], \cache[21], \in[18]
  v_add_u32       \out[29], vcc, \calc[0], \out[29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \cache[20], \in[18], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_and_b32          \calc[0], \cache[23], \in[17]
  v_add_u32       \out[29], vcc, \calc[0], \out[29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \cache[22], \in[17], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_and_b32          \calc[0], \cache[25], \in[16]
  v_add_u32       \out[29], vcc, \calc[0], \out[29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \cache[24], \in[16], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_and_b32          \calc[0], \cache[27], \in[15]
  v_add_u32       \out[29], vcc, \calc[0], \out[29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \cache[26], \in[15], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in[14], \in[14], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_and_b32          \calc[0], \cache[21], \in[19]
  v_add_u32       \out[30], vcc, \calc[0], \out[30]
  v_addc_u32      \out[31], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[29:30], vcc, \cache[20], \in[19], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_and_b32          \calc[0], \cache[23], \in[18]
  v_add_u32       \out[30], vcc, \calc[0], \out[30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \cache[22], \in[18], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_and_b32          \calc[0], \cache[25], \in[17]
  v_add_u32       \out[30], vcc, \calc[0], \out[30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \cache[24], \in[17], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_and_b32          \calc[0], \cache[27], \in[16]
  v_add_u32       \out[30], vcc, \calc[0], \out[30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \cache[26], \in[16], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_and_b32          \calc[0], \cache[29], \in[15]
  v_add_u32       \out[30], vcc, \calc[0], \out[30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \cache[28], \in[15], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_and_b32          \calc[0], \cache[23], \in[19]
  v_add_u32       \out[31], vcc, \calc[0], \out[31]
  v_addc_u32      \out[32], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[30:31], vcc, \cache[22], \in[19], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_and_b32          \calc[0], \cache[25], \in[18]
  v_add_u32       \out[31], vcc, \calc[0], \out[31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \cache[24], \in[18], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_and_b32          \calc[0], \cache[27], \in[17]
  v_add_u32       \out[31], vcc, \calc[0], \out[31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \cache[26], \in[17], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_and_b32          \calc[0], \cache[29], \in[16]
  v_add_u32       \out[31], vcc, \calc[0], \out[31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \cache[28], \in[16], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in[15], \in[15], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_and_b32          \calc[0], \cache[25], \in[19]
  v_add_u32       \out[32], vcc, \calc[0], \out[32]
  v_addc_u32      \out[33], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[31:32], vcc, \cache[24], \in[19], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_and_b32          \calc[0], \cache[27], \in[18]
  v_add_u32       \out[32], vcc, \calc[0], \out[32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \cache[26], \in[18], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_and_b32          \calc[0], \cache[29], \in[17]
  v_add_u32       \out[32], vcc, \calc[0], \out[32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \cache[28], \in[17], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_and_b32          \calc[0], \cache[31], \in[16]
  v_add_u32       \out[32], vcc, \calc[0], \out[32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \cache[30], \in[16], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_and_b32          \calc[0], \cache[27], \in[19]
  v_add_u32       \out[33], vcc, \calc[0], \out[33]
  v_addc_u32      \out[34], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[32:33], vcc, \cache[26], \in[19], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_and_b32          \calc[0], \cache[29], \in[18]
  v_add_u32       \out[33], vcc, \calc[0], \out[33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \cache[28], \in[18], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_and_b32          \calc[0], \cache[31], \in[17]
  v_add_u32       \out[33], vcc, \calc[0], \out[33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \cache[30], \in[17], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in[16], \in[16], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_and_b32          \calc[0], \cache[29], \in[19]
  v_add_u32       \out[34], vcc, \calc[0], \out[34]
  v_addc_u32      \out[35], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[33:34], vcc, \cache[28], \in[19], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_and_b32          \calc[0], \cache[31], \in[18]
  v_add_u32       \out[34], vcc, \calc[0], \out[34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[33:34], vcc, \cache[30], \in[18], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_and_b32          \calc[0], \cache[33], \in[17]
  v_add_u32       \out[34], vcc, \calc[0], \out[34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[33:34], vcc, \cache[32], \in[17], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_and_b32          \calc[0], \cache[31], \in[19]
  v_add_u32       \out[35], vcc, \calc[0], \out[35]
  v_addc_u32      \out[36], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[34:35], vcc, \cache[30], \in[19], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_and_b32          \calc[0], \cache[33], \in[18]
  v_add_u32       \out[35], vcc, \calc[0], \out[35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_mad_u64_u32      \out[34:35], vcc, \cache[32], \in[18], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_mad_u64_u32      \out[34:35], vcc, \in[17], \in[17], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_and_b32          \calc[0], \cache[33], \in[19]
  v_add_u32       \out[36], vcc, \calc[0], \out[36]
  v_addc_u32      \out[37], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[35:36], vcc, \cache[32], \in[19], \out[35:36]
  v_addc_u32      \out[37], vcc, 0, \out[37], vcc
  v_and_b32          \calc[0], \cache[35], \in[18]
  v_add_u32       \out[36], vcc, \calc[0], \out[36]
  v_addc_u32      \out[37], vcc, 0, \out[37], vcc
  v_mad_u64_u32      \out[35:36], vcc, \cache[34], \in[18], \out[35:36]
  v_addc_u32      \out[37], vcc, 0, \out[37], vcc
  v_and_b32          \calc[0], \cache[35], \in[19]
  v_add_u32       \out[37], vcc, \calc[0], \out[37]
  v_addc_u32      \out[38], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[36:37], vcc, \cache[34], \in[19], \out[36:37]
  v_addc_u32      \out[38], vcc, 0, \out[38], vcc
  v_mad_u64_u32      \out[36:37], vcc, \in[18], \in[18], \out[36:37]
  v_addc_u32      \out[38], vcc, 0, \out[38], vcc
  v_and_b32          \calc[0], \cache[37], \in[19]
  v_add_u32       \out[38], vcc, \calc[0], \out[38]
  v_addc_u32      \out[39], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[37:38], vcc, \cache[36], \in[19], \out[37:38]
  v_addc_u32      \out[39], vcc, 0, \out[39], vcc
  v_mad_u64_u32      \out[38:39], vcc, \in[19], \in[19], \out[38:39]
.endm

.macro mul320to320, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[0], \in2[6], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[0], \in2[7], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[1], \in2[6], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[0], \in2[8], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[1], \in2[7], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[2], \in2[6], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[0], \in2[9], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[1], \in2[8], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[2], \in2[7], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[3], \in2[6], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[1], \in2[9], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[2], \in2[8], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[3], \in2[7], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[4], \in2[6], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[5], \in2[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[6], \in2[4], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[2], \in2[9], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[3], \in2[8], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[4], \in2[7], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[5], \in2[6], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[6], \in2[5], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[7], \in2[4], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[3], \in2[9], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[4], \in2[8], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[5], \in2[7], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[6], \in2[6], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[7], \in2[5], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[8], \in2[4], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[4], \in2[9], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[5], \in2[8], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[6], \in2[7], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[7], \in2[6], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[8], \in2[5], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[9], \in2[4], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[5], \in2[9], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[6], \in2[8], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[7], \in2[7], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[8], \in2[6], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[9], \in2[5], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[6], \in2[9], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[7], \in2[8], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[8], \in2[7], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[9], \in2[6], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[7], \in2[9], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[8], \in2[8], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[9], \in2[7], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[8], \in2[9], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[9], \in2[8], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[9], \in2[9], \out[18:19]
.endm

.macro mul352to352, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[0], \in2[6], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[0], \in2[7], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[1], \in2[6], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[0], \in2[8], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[1], \in2[7], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[2], \in2[6], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[0], \in2[9], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[1], \in2[8], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[2], \in2[7], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[3], \in2[6], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[0], \in2[10], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[1], \in2[9], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[2], \in2[8], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[3], \in2[7], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[4], \in2[6], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[5], \in2[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[6], \in2[4], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[1], \in2[10], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[2], \in2[9], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[3], \in2[8], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[4], \in2[7], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[5], \in2[6], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[6], \in2[5], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[7], \in2[4], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[10], \in2[1], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[2], \in2[10], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[3], \in2[9], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[4], \in2[8], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[5], \in2[7], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[6], \in2[6], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[7], \in2[5], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[8], \in2[4], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[10], \in2[2], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[3], \in2[10], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[4], \in2[9], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[5], \in2[8], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[6], \in2[7], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[7], \in2[6], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[8], \in2[5], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[9], \in2[4], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[10], \in2[3], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[4], \in2[10], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[5], \in2[9], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[6], \in2[8], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[7], \in2[7], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[8], \in2[6], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[9], \in2[5], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[10], \in2[4], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[5], \in2[10], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[6], \in2[9], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[7], \in2[8], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[8], \in2[7], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[9], \in2[6], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[10], \in2[5], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[6], \in2[10], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[7], \in2[9], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[8], \in2[8], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[9], \in2[7], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[10], \in2[6], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[7], \in2[10], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[8], \in2[9], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[9], \in2[8], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[10], \in2[7], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[8], \in2[10], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[9], \in2[9], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[10], \in2[8], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[9], \in2[10], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[10], \in2[9], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[10], \in2[10], \out[20:21]
.endm

.macro mul640to640, in1, in2, out, zero
  v_mov_b32          \out[2], 0
  v_mad_u64_u32      \out[0:1], vcc, \in1[0], \in2[0], \zero[0:1]
  v_mad_u64_u32      \out[1:2], vcc, \in1[0], \in2[1], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[1:2], vcc, \in1[1], \in2[0], \out[1:2]
  v_addc_u32      \out[3], vcc, 0, \out[3], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[0], \in2[2], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[1], \in2[1], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[2:3], vcc, \in1[2], \in2[0], \out[2:3]
  v_addc_u32      \out[4], vcc, 0, \out[4], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[0], \in2[3], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[1], \in2[2], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[2], \in2[1], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[3:4], vcc, \in1[3], \in2[0], \out[3:4]
  v_addc_u32      \out[5], vcc, 0, \out[5], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[0], \in2[4], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[1], \in2[3], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[2], \in2[2], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[3], \in2[1], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[4:5], vcc, \in1[4], \in2[0], \out[4:5]
  v_addc_u32      \out[6], vcc, 0, \out[6], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[0], \in2[5], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[1], \in2[4], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[2], \in2[3], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[3], \in2[2], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[4], \in2[1], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[5:6], vcc, \in1[5], \in2[0], \out[5:6]
  v_addc_u32      \out[7], vcc, 0, \out[7], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[0], \in2[6], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[1], \in2[5], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[2], \in2[4], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[3], \in2[3], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[4], \in2[2], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[5], \in2[1], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[6:7], vcc, \in1[6], \in2[0], \out[6:7]
  v_addc_u32      \out[8], vcc, 0, \out[8], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[0], \in2[7], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[1], \in2[6], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[2], \in2[5], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[3], \in2[4], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[4], \in2[3], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[5], \in2[2], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[6], \in2[1], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[7:8], vcc, \in1[7], \in2[0], \out[7:8]
  v_addc_u32      \out[9], vcc, 0, \out[9], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[0], \in2[8], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[1], \in2[7], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[2], \in2[6], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[3], \in2[5], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[4], \in2[4], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[5], \in2[3], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[6], \in2[2], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[7], \in2[1], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[8:9], vcc, \in1[8], \in2[0], \out[8:9]
  v_addc_u32      \out[10], vcc, 0, \out[10], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[0], \in2[9], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[1], \in2[8], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[2], \in2[7], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[3], \in2[6], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[4], \in2[5], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[5], \in2[4], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[6], \in2[3], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[7], \in2[2], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[8], \in2[1], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[9:10], vcc, \in1[9], \in2[0], \out[9:10]
  v_addc_u32      \out[11], vcc, 0, \out[11], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[0], \in2[10], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[1], \in2[9], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[2], \in2[8], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[3], \in2[7], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[4], \in2[6], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[5], \in2[5], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[6], \in2[4], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[7], \in2[3], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[8], \in2[2], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[9], \in2[1], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[10:11], vcc, \in1[10], \in2[0], \out[10:11]
  v_addc_u32      \out[12], vcc, 0, \out[12], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[0], \in2[11], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[1], \in2[10], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[2], \in2[9], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[3], \in2[8], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[4], \in2[7], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[5], \in2[6], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[6], \in2[5], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[7], \in2[4], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[8], \in2[3], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[9], \in2[2], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[10], \in2[1], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[11:12], vcc, \in1[11], \in2[0], \out[11:12]
  v_addc_u32      \out[13], vcc, 0, \out[13], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[0], \in2[12], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[1], \in2[11], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[2], \in2[10], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[3], \in2[9], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[4], \in2[8], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[5], \in2[7], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[6], \in2[6], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[7], \in2[5], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[8], \in2[4], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[9], \in2[3], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[10], \in2[2], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[11], \in2[1], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[12:13], vcc, \in1[12], \in2[0], \out[12:13]
  v_addc_u32      \out[14], vcc, 0, \out[14], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[0], \in2[13], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[1], \in2[12], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[2], \in2[11], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[3], \in2[10], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[4], \in2[9], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[5], \in2[8], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[6], \in2[7], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[7], \in2[6], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[8], \in2[5], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[9], \in2[4], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[10], \in2[3], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[11], \in2[2], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[12], \in2[1], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[13:14], vcc, \in1[13], \in2[0], \out[13:14]
  v_addc_u32      \out[15], vcc, 0, \out[15], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[0], \in2[14], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[1], \in2[13], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[2], \in2[12], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[3], \in2[11], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[4], \in2[10], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[5], \in2[9], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[6], \in2[8], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[7], \in2[7], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[8], \in2[6], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[9], \in2[5], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[10], \in2[4], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[11], \in2[3], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[12], \in2[2], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[13], \in2[1], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[14:15], vcc, \in1[14], \in2[0], \out[14:15]
  v_addc_u32      \out[16], vcc, 0, \out[16], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[0], \in2[15], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[1], \in2[14], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[2], \in2[13], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[3], \in2[12], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[4], \in2[11], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[5], \in2[10], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[6], \in2[9], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[7], \in2[8], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[8], \in2[7], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[9], \in2[6], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[10], \in2[5], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[11], \in2[4], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[12], \in2[3], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[13], \in2[2], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[14], \in2[1], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[15:16], vcc, \in1[15], \in2[0], \out[15:16]
  v_addc_u32      \out[17], vcc, 0, \out[17], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[0], \in2[16], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[1], \in2[15], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[2], \in2[14], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[3], \in2[13], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[4], \in2[12], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[5], \in2[11], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[6], \in2[10], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[7], \in2[9], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[8], \in2[8], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[9], \in2[7], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[10], \in2[6], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[11], \in2[5], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[12], \in2[4], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[13], \in2[3], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[14], \in2[2], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[15], \in2[1], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[16:17], vcc, \in1[16], \in2[0], \out[16:17]
  v_addc_u32      \out[18], vcc, 0, \out[18], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[0], \in2[17], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[1], \in2[16], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[2], \in2[15], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[3], \in2[14], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[4], \in2[13], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[5], \in2[12], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[6], \in2[11], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[7], \in2[10], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[8], \in2[9], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[9], \in2[8], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[10], \in2[7], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[11], \in2[6], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[12], \in2[5], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[13], \in2[4], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[14], \in2[3], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[15], \in2[2], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[16], \in2[1], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[17:18], vcc, \in1[17], \in2[0], \out[17:18]
  v_addc_u32      \out[19], vcc, 0, \out[19], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[0], \in2[18], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[1], \in2[17], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[2], \in2[16], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[3], \in2[15], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[4], \in2[14], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[5], \in2[13], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[6], \in2[12], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[7], \in2[11], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[8], \in2[10], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[9], \in2[9], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[10], \in2[8], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[11], \in2[7], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[12], \in2[6], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[13], \in2[5], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[14], \in2[4], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[15], \in2[3], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[16], \in2[2], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[17], \in2[1], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[18:19], vcc, \in1[18], \in2[0], \out[18:19]
  v_addc_u32      \out[20], vcc, 0, \out[20], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[0], \in2[19], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[1], \in2[18], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[2], \in2[17], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[3], \in2[16], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[4], \in2[15], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[5], \in2[14], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[6], \in2[13], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[7], \in2[12], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[8], \in2[11], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[9], \in2[10], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[10], \in2[9], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[11], \in2[8], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[12], \in2[7], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[13], \in2[6], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[14], \in2[5], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[15], \in2[4], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[16], \in2[3], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[17], \in2[2], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[18], \in2[1], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[19:20], vcc, \in1[19], \in2[0], \out[19:20]
  v_addc_u32      \out[21], vcc, 0, \out[21], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[1], \in2[19], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[2], \in2[18], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[3], \in2[17], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[4], \in2[16], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[5], \in2[15], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[6], \in2[14], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[7], \in2[13], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[8], \in2[12], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[9], \in2[11], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[10], \in2[10], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[11], \in2[9], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[12], \in2[8], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[13], \in2[7], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[14], \in2[6], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[15], \in2[5], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[16], \in2[4], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[17], \in2[3], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[18], \in2[2], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[20:21], vcc, \in1[19], \in2[1], \out[20:21]
  v_addc_u32      \out[22], vcc, 0, \out[22], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[2], \in2[19], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[3], \in2[18], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[4], \in2[17], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[5], \in2[16], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[6], \in2[15], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[7], \in2[14], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[8], \in2[13], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[9], \in2[12], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[10], \in2[11], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[11], \in2[10], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[12], \in2[9], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[13], \in2[8], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[14], \in2[7], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[15], \in2[6], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[16], \in2[5], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[17], \in2[4], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[18], \in2[3], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[21:22], vcc, \in1[19], \in2[2], \out[21:22]
  v_addc_u32      \out[23], vcc, 0, \out[23], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[3], \in2[19], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[4], \in2[18], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[5], \in2[17], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[6], \in2[16], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[7], \in2[15], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[8], \in2[14], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[9], \in2[13], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[10], \in2[12], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[11], \in2[11], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[12], \in2[10], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[13], \in2[9], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[14], \in2[8], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[15], \in2[7], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[16], \in2[6], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[17], \in2[5], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[18], \in2[4], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[22:23], vcc, \in1[19], \in2[3], \out[22:23]
  v_addc_u32      \out[24], vcc, 0, \out[24], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[4], \in2[19], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[5], \in2[18], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[6], \in2[17], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[7], \in2[16], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[8], \in2[15], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[9], \in2[14], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[10], \in2[13], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[11], \in2[12], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[12], \in2[11], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[13], \in2[10], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[14], \in2[9], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[15], \in2[8], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[16], \in2[7], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[17], \in2[6], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[18], \in2[5], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[23:24], vcc, \in1[19], \in2[4], \out[23:24]
  v_addc_u32      \out[25], vcc, 0, \out[25], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[5], \in2[19], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[6], \in2[18], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[7], \in2[17], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[8], \in2[16], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[9], \in2[15], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[10], \in2[14], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[11], \in2[13], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[12], \in2[12], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[13], \in2[11], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[14], \in2[10], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[15], \in2[9], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[16], \in2[8], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[17], \in2[7], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[18], \in2[6], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[24:25], vcc, \in1[19], \in2[5], \out[24:25]
  v_addc_u32      \out[26], vcc, 0, \out[26], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[6], \in2[19], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[7], \in2[18], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[8], \in2[17], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[9], \in2[16], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[10], \in2[15], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[11], \in2[14], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[12], \in2[13], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[13], \in2[12], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[14], \in2[11], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[15], \in2[10], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[16], \in2[9], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[17], \in2[8], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[18], \in2[7], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[25:26], vcc, \in1[19], \in2[6], \out[25:26]
  v_addc_u32      \out[27], vcc, 0, \out[27], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[7], \in2[19], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[8], \in2[18], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[9], \in2[17], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[10], \in2[16], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[11], \in2[15], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[12], \in2[14], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[13], \in2[13], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[14], \in2[12], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[15], \in2[11], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[16], \in2[10], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[17], \in2[9], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[18], \in2[8], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[26:27], vcc, \in1[19], \in2[7], \out[26:27]
  v_addc_u32      \out[28], vcc, 0, \out[28], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[8], \in2[19], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[9], \in2[18], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[10], \in2[17], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[11], \in2[16], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[12], \in2[15], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[13], \in2[14], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[14], \in2[13], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[15], \in2[12], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[16], \in2[11], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[17], \in2[10], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[18], \in2[9], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[27:28], vcc, \in1[19], \in2[8], \out[27:28]
  v_addc_u32      \out[29], vcc, 0, \out[29], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[9], \in2[19], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[10], \in2[18], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[11], \in2[17], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[12], \in2[16], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[13], \in2[15], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[14], \in2[14], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[15], \in2[13], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[16], \in2[12], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[17], \in2[11], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[18], \in2[10], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[28:29], vcc, \in1[19], \in2[9], \out[28:29]
  v_addc_u32      \out[30], vcc, 0, \out[30], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[10], \in2[19], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[11], \in2[18], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[12], \in2[17], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[13], \in2[16], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[14], \in2[15], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[15], \in2[14], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[16], \in2[13], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[17], \in2[12], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[18], \in2[11], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[29:30], vcc, \in1[19], \in2[10], \out[29:30]
  v_addc_u32      \out[31], vcc, 0, \out[31], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[11], \in2[19], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[12], \in2[18], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[13], \in2[17], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[14], \in2[16], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[15], \in2[15], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[16], \in2[14], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[17], \in2[13], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[18], \in2[12], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[30:31], vcc, \in1[19], \in2[11], \out[30:31]
  v_addc_u32      \out[32], vcc, 0, \out[32], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[12], \in2[19], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[13], \in2[18], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[14], \in2[17], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[15], \in2[16], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[16], \in2[15], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[17], \in2[14], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[18], \in2[13], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[31:32], vcc, \in1[19], \in2[12], \out[31:32]
  v_addc_u32      \out[33], vcc, 0, \out[33], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[13], \in2[19], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[14], \in2[18], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[15], \in2[17], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[16], \in2[16], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[17], \in2[15], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[18], \in2[14], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[32:33], vcc, \in1[19], \in2[13], \out[32:33]
  v_addc_u32      \out[34], vcc, 0, \out[34], vcc
  v_mad_u64_u32      \out[33:34], vcc, \in1[14], \in2[19], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[33:34], vcc, \in1[15], \in2[18], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[33:34], vcc, \in1[16], \in2[17], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[33:34], vcc, \in1[17], \in2[16], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[33:34], vcc, \in1[18], \in2[15], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[33:34], vcc, \in1[19], \in2[14], \out[33:34]
  v_addc_u32      \out[35], vcc, 0, \out[35], vcc
  v_mad_u64_u32      \out[34:35], vcc, \in1[15], \in2[19], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[34:35], vcc, \in1[16], \in2[18], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_mad_u64_u32      \out[34:35], vcc, \in1[17], \in2[17], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_mad_u64_u32      \out[34:35], vcc, \in1[18], \in2[16], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_mad_u64_u32      \out[34:35], vcc, \in1[19], \in2[15], \out[34:35]
  v_addc_u32      \out[36], vcc, 0, \out[36], vcc
  v_mad_u64_u32      \out[35:36], vcc, \in1[16], \in2[19], \out[35:36]
  v_addc_u32      \out[37], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[35:36], vcc, \in1[17], \in2[18], \out[35:36]
  v_addc_u32      \out[37], vcc, 0, \out[37], vcc
  v_mad_u64_u32      \out[35:36], vcc, \in1[18], \in2[17], \out[35:36]
  v_addc_u32      \out[37], vcc, 0, \out[37], vcc
  v_mad_u64_u32      \out[35:36], vcc, \in1[19], \in2[16], \out[35:36]
  v_addc_u32      \out[37], vcc, 0, \out[37], vcc
  v_mad_u64_u32      \out[36:37], vcc, \in1[17], \in2[19], \out[36:37]
  v_addc_u32      \out[38], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[36:37], vcc, \in1[18], \in2[18], \out[36:37]
  v_addc_u32      \out[38], vcc, 0, \out[38], vcc
  v_mad_u64_u32      \out[36:37], vcc, \in1[19], \in2[17], \out[36:37]
  v_addc_u32      \out[38], vcc, 0, \out[38], vcc
  v_mad_u64_u32      \out[37:38], vcc, \in1[18], \in2[19], \out[37:38]
  v_addc_u32      \out[39], vcc, 0, 0, vcc
  v_mad_u64_u32      \out[37:38], vcc, \in1[19], \in2[18], \out[37:38]
  v_addc_u32      \out[39], vcc, 0, \out[39], vcc
  v_mad_u64_u32      \out[38:39], vcc, \in1[19], \in2[19], \out[38:39]
.endm

.macro monsqr320, m1ctx, mod, inv, invm, cache, zero, x, sregs
  v_add_u32         \cache[0], vcc, \m1ctx[3], \m1ctx[3]
  v_subb_u32        \cache[1], vcc, 0, 0, vcc
  v_add_u32         \cache[2], vcc, \m1ctx[4], \m1ctx[4]
  v_subb_u32        \cache[3], vcc, 0, 0, vcc
  v_add_u32         \cache[4], vcc, \m1ctx[5], \m1ctx[5]
  v_subb_u32        \cache[5], vcc, 0, 0, vcc
  v_add_u32         \cache[6], vcc, \m1ctx[6], \m1ctx[6]
  v_subb_u32        \cache[7], vcc, 0, 0, vcc
  v_add_u32         \cache[8], vcc, \m1ctx[7], \m1ctx[7]
  v_subb_u32        \cache[9], vcc, 0, 0, vcc
  v_add_u32         \cache[10], vcc, \m1ctx[8], \m1ctx[8]
  v_subb_u32        \cache[11], vcc, 0, 0, vcc
  v_add_u32         \cache[12], vcc, \m1ctx[9], \m1ctx[9]
  v_subb_u32        \cache[13], vcc, 0, 0, vcc
  v_add_u32         \cache[14], vcc, \m1ctx[10], \m1ctx[10]
  v_subb_u32        \cache[15], vcc, 0, 0, vcc
  v_add_u32         \cache[16], vcc, \m1ctx[11], \m1ctx[11]
  v_subb_u32        \cache[17], vcc, 0, 0, vcc
  v_add_u32         \cache[18], vcc, \m1ctx[12], \m1ctx[12]
  v_subb_u32        \cache[19], vcc, 0, 0, vcc

  #; result limb 0 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[3], \m1ctx[3], \zero[0:1]
  v_mul_lo_u32       \inv[0], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc

  #; result limb 1 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[4], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[4]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[1], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 2 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[5], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[5]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[4], \m1ctx[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[2], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 3 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[6], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[6]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[5]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[3], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 4 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[7], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[6]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[5], \m1ctx[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[4], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 5 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[8], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[6]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[5], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 6 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[9], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[9]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[8], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[6], \m1ctx[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[6], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[6], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 7 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[10], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[10]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[9], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[9]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[8], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[6], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[7], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[6], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[7], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[7], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 8 out index: 1
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[0], \m1ctx[11], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[11]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[2], \m1ctx[10], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[3], \m1ctx[10]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[4], \m1ctx[9], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[5], \m1ctx[9]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[6], \m1ctx[8], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[7], \m1ctx[8]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \m1ctx[7], \m1ctx[7], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[0], \mod[8], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[1], \mod[7], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[2], \mod[6], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[3], \mod[5], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[4], \mod[4], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[5], \mod[3], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[6], \mod[2], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[7], \mod[1], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mul_lo_u32       \inv[8], \m1ctx[1], \invm
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[8], \mod[0], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc

  #; result limb 9 out index: 2
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[0], \m1ctx[12], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[12]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[2], \m1ctx[11], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[3], \m1ctx[11]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[4], \m1ctx[10], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[5], \m1ctx[10]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[6], \m1ctx[9], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[7], \m1ctx[9]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[8], \m1ctx[8], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[9], \m1ctx[8]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[0], \mod[9], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[1], \mod[8], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[2], \mod[7], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[3], \mod[6], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[4], \mod[5], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[5], \mod[4], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[6], \mod[3], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[7], \mod[2], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[8], \mod[1], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mul_lo_u32       \inv[9], \m1ctx[2], \invm
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[9], \mod[0], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc

  #; result limb 10 out index: 3
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[2], \m1ctx[12], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[3], \m1ctx[12]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[4], \m1ctx[11], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[5], \m1ctx[11]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[6], \m1ctx[10], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[7], \m1ctx[10]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[8], \m1ctx[9], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[9], \m1ctx[9]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \m1ctx[8], \m1ctx[8], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[1], \mod[9], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[2], \mod[8], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[3], \mod[7], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[4], \mod[6], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[5], \mod[5], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[6], \mod[4], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[7], \mod[3], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[8], \mod[2], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[9], \mod[1], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc

  #; result limb 11 out index: 4
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[4], \m1ctx[12], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[5], \m1ctx[12]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[6], \m1ctx[11], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_and_b32          \x, \cache[7], \m1ctx[11]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[8], \m1ctx[10], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_and_b32          \x, \cache[9], \m1ctx[10]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[10], \m1ctx[9], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_and_b32          \x, \cache[11], \m1ctx[9]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[2], \mod[9], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[3], \mod[8], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[4], \mod[7], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[5], \mod[6], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[6], \mod[5], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[7], \mod[4], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[8], \mod[3], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[9], \mod[2], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc

  #; result limb 12 out index: 5
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[6], \m1ctx[12], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[7], \m1ctx[12]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[8], \m1ctx[11], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_and_b32          \x, \cache[9], \m1ctx[11]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[10], \m1ctx[10], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_and_b32          \x, \cache[11], \m1ctx[10]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \m1ctx[9], \m1ctx[9], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[3], \mod[9], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[4], \mod[8], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[5], \mod[7], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[6], \mod[6], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[7], \mod[5], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[8], \mod[4], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[9], \mod[3], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc

  #; result limb 13 out index: 6
  v_mad_u64_u32      \m1ctx[6:7], vcc, \cache[8], \m1ctx[12], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[9], \m1ctx[12]
  v_add_u32       \m1ctx[7], vcc, \x, \m1ctx[7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \cache[10], \m1ctx[11], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_and_b32          \x, \cache[11], \m1ctx[11]
  v_add_u32       \m1ctx[7], vcc, \x, \m1ctx[7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \cache[12], \m1ctx[10], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_and_b32          \x, \cache[13], \m1ctx[10]
  v_add_u32       \m1ctx[7], vcc, \x, \m1ctx[7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[4], \mod[9], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[5], \mod[8], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[6], \mod[7], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[7], \mod[6], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[8], \mod[5], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[9], \mod[4], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc

  #; result limb 14 out index: 7
  v_mad_u64_u32      \m1ctx[7:8], vcc, \cache[10], \m1ctx[12], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[11], \m1ctx[12]
  v_add_u32       \m1ctx[8], vcc, \x, \m1ctx[8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \cache[12], \m1ctx[11], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_and_b32          \x, \cache[13], \m1ctx[11]
  v_add_u32       \m1ctx[8], vcc, \x, \m1ctx[8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \m1ctx[10], \m1ctx[10], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[5], \mod[9], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[6], \mod[8], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[7], \mod[7], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[8], \mod[6], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[9], \mod[5], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc

  #; result limb 15 out index: 8
  v_mad_u64_u32      \m1ctx[8:9], vcc, \cache[12], \m1ctx[12], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[13], \m1ctx[12]
  v_add_u32       \m1ctx[9], vcc, \x, \m1ctx[9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \cache[14], \m1ctx[11], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_and_b32          \x, \cache[15], \m1ctx[11]
  v_add_u32       \m1ctx[9], vcc, \x, \m1ctx[9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[6], \mod[9], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[7], \mod[8], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[8], \mod[7], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[9], \mod[6], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc

  #; result limb 16 out index: 9
  #; move 2 last limbs to begin of m1ctx
  v_mov_b32          \m1ctx[0], \m1ctx[11]
  v_mov_b32          \m1ctx[1], \m1ctx[12]
  v_mad_u64_u32      \m1ctx[9:10], vcc, \cache[14], \m1ctx[1], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[15], \m1ctx[1]
  v_add_u32       \m1ctx[10], vcc, \x, \m1ctx[10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \m1ctx[0], \m1ctx[0], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[7], \mod[9], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[8], \mod[8], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[9], \mod[7], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc

  #; result limb 17 out index: 10
  v_mad_u64_u32      \m1ctx[10:11], vcc, \cache[16], \m1ctx[1], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[17], \m1ctx[1]
  v_add_u32       \m1ctx[11], vcc, \x, \m1ctx[11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc
  v_mad_u64_u32      \m1ctx[10:11], vcc, \inv[8], \mod[9], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc
  v_mad_u64_u32      \m1ctx[10:11], vcc, \inv[9], \mod[8], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc

  #; result limb 18 out index: 11
  v_mad_u64_u32      \m1ctx[11:12], vcc, \m1ctx[1], \m1ctx[1], \m1ctx[11:12]
  v_addc_u32      \x, vcc, 0, 0, vcc
  v_mad_u64_u32      \m1ctx[11:12], vcc, \inv[9], \mod[9], \m1ctx[11:12]
  v_addc_u32      \x, vcc, 0, \x, vcc

  #; result limb 19 out index: 12
  s_mov_b64         \sregs, exec
  v_cmpx_gt_u32     vcc, \x, 0
  v_sub_u32      \m1ctx[3], vcc, \m1ctx[3], \mod[0]
  v_subb_u32     \m1ctx[4], vcc, \m1ctx[4], \mod[1], vcc
  v_subb_u32     \m1ctx[5], vcc, \m1ctx[5], \mod[2], vcc
  v_subb_u32     \m1ctx[6], vcc, \m1ctx[6], \mod[3], vcc
  v_subb_u32     \m1ctx[7], vcc, \m1ctx[7], \mod[4], vcc
  v_subb_u32     \m1ctx[8], vcc, \m1ctx[8], \mod[5], vcc
  v_subb_u32     \m1ctx[9], vcc, \m1ctx[9], \mod[6], vcc
  v_subb_u32     \m1ctx[10], vcc, \m1ctx[10], \mod[7], vcc
  v_subb_u32     \m1ctx[11], vcc, \m1ctx[11], \mod[8], vcc
  v_subb_u32     \m1ctx[12], vcc, \m1ctx[12], \mod[9], vcc
  s_mov_b64         exec, \sregs
.endm

.macro monmul320, m1, m2, mod, inv, invm, cache, zero, x, sregs
  v_mov_b32           \cache[0], \m1[0]
  v_mov_b32           \cache[1], \m1[1]
  v_mov_b32           \cache[2], \m1[2]
  v_mov_b32           \cache[3], \m1[3]
  v_mov_b32           \cache[4], \m1[4]
  v_mov_b32           \cache[5], \m1[5]
  v_mov_b32           \cache[6], \m1[6]
  v_mov_b32           \cache[7], \m1[7]
  v_mov_b32           \cache[8], \m1[8]
  v_mov_b32           \cache[9], \m1[9]

  #; result limb 0 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[0], \zero[0:1]
  v_mul_lo_u32       \inv[0], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc

  #; result limb 1 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[1], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[1], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 2 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[2], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[2], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 3 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[3], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[3], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 4 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[4], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[4], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 5 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[5], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[5], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 6 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[6], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[6], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 7 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[7], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[7], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 8 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[8], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[8], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 9 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[9], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[9], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[9], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[9], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 10 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[9], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[9], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[9], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 11 out index: 1
  v_mad_u64_u32      \m1[1:2], vcc, \cache[2], \m2[9], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[3], \m2[8], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[4], \m2[7], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[5], \m2[6], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[6], \m2[5], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[7], \m2[4], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[8], \m2[3], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[9], \m2[2], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[2], \mod[9], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[3], \mod[8], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[4], \mod[7], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[5], \mod[6], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[6], \mod[5], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[7], \mod[4], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[8], \mod[3], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[9], \mod[2], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc

  #; result limb 12 out index: 2
  v_mad_u64_u32      \m1[2:3], vcc, \cache[3], \m2[9], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[4], \m2[8], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[5], \m2[7], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[6], \m2[6], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[7], \m2[5], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[8], \m2[4], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[9], \m2[3], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[3], \mod[9], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[4], \mod[8], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[5], \mod[7], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[6], \mod[6], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[7], \mod[5], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[8], \mod[4], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[9], \mod[3], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc

  #; result limb 13 out index: 3
  v_mad_u64_u32      \m1[3:4], vcc, \cache[4], \m2[9], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[5], \m2[8], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[6], \m2[7], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[7], \m2[6], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[8], \m2[5], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[9], \m2[4], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[4], \mod[9], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[5], \mod[8], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[6], \mod[7], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[7], \mod[6], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[8], \mod[5], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[9], \mod[4], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc

  #; result limb 14 out index: 4
  v_mad_u64_u32      \m1[4:5], vcc, \cache[5], \m2[9], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[6], \m2[8], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[7], \m2[7], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[8], \m2[6], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[9], \m2[5], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[5], \mod[9], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[6], \mod[8], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[7], \mod[7], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[8], \mod[6], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[9], \mod[5], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc

  #; result limb 15 out index: 5
  v_mad_u64_u32      \m1[5:6], vcc, \cache[6], \m2[9], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[7], \m2[8], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[8], \m2[7], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[9], \m2[6], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[6], \mod[9], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[7], \mod[8], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[8], \mod[7], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[9], \mod[6], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc

  #; result limb 16 out index: 6
  v_mad_u64_u32      \m1[6:7], vcc, \cache[7], \m2[9], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[6:7], vcc, \cache[8], \m2[8], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \cache[9], \m2[7], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[7], \mod[9], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[8], \mod[8], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[9], \mod[7], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc

  #; result limb 17 out index: 7
  v_mad_u64_u32      \m1[7:8], vcc, \cache[8], \m2[9], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[7:8], vcc, \cache[9], \m2[8], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[8], \mod[9], \m1[7:8]
  v_addc_u32    \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[9], \mod[8], \m1[7:8]
  v_addc_u32    \m1[9], vcc, 0, \m1[9], vcc

  #; result limb 18 out index: 8
  v_mad_u64_u32      \m1[8:9], vcc, \cache[9], \m2[9], \m1[8:9]
  v_addc_u32      \x, vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[8:9], vcc, \inv[9], \mod[9], \m1[8:9]
  v_addc_u32      \x, vcc, 0, \x, vcc

  #; result limb 19 out index: 9
  s_mov_b64         \sregs, exec
  v_cmpx_gt_u32     vcc, \x, 0
  v_sub_u32      \m1[0], vcc, \m1[0], \mod[0]
  v_subb_u32     \m1[1], vcc, \m1[1], \mod[1], vcc
  v_subb_u32     \m1[2], vcc, \m1[2], \mod[2], vcc
  v_subb_u32     \m1[3], vcc, \m1[3], \mod[3], vcc
  v_subb_u32     \m1[4], vcc, \m1[4], \mod[4], vcc
  v_subb_u32     \m1[5], vcc, \m1[5], \mod[5], vcc
  v_subb_u32     \m1[6], vcc, \m1[6], \mod[6], vcc
  v_subb_u32     \m1[7], vcc, \m1[7], \mod[7], vcc
  v_subb_u32     \m1[8], vcc, \m1[8], \mod[8], vcc
  v_subb_u32     \m1[9], vcc, \m1[9], \mod[9], vcc
  s_mov_b64         exec, \sregs
.endm

.macro redchalf320, m1, mod, inv, invm, cache, zero, x
  v_mov_b32           \cache[0], \m1[0]
  v_mov_b32           \cache[1], \m1[1]
  v_mov_b32           \cache[2], \m1[2]
  v_mov_b32           \cache[3], \m1[3]
  v_mov_b32           \cache[4], \m1[4]
  v_mov_b32           \cache[5], \m1[5]
  v_mov_b32           \cache[6], \m1[6]
  v_mov_b32           \cache[7], \m1[7]
  v_mov_b32           \cache[8], \m1[8]
  v_mov_b32           \cache[9], \m1[9]

  #; result limb 0 out index: 0
  v_mul_lo_u32       \inv[0], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[0], \cache[0:1]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc

  #; result limb 1 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[1], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 1 from m1
  v_add_u32       \m1[1], vcc, \cache[2], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[1], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 2 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[2], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 2 from m1
  v_add_u32       \m1[1], vcc, \cache[3], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[2], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 3 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[3], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 3 from m1
  v_add_u32       \m1[1], vcc, \cache[4], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[3], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 4 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[4], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 4 from m1
  v_add_u32       \m1[1], vcc, \cache[5], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[4], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 5 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[5], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 5 from m1
  v_add_u32       \m1[1], vcc, \cache[6], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[5], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 6 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[6], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 6 from m1
  v_add_u32       \m1[1], vcc, \cache[7], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[6], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 7 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[7], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 7 from m1
  v_add_u32       \m1[1], vcc, \cache[8], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[7], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 8 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[8], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 8 from m1
  v_add_u32       \m1[1], vcc, \cache[9], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[8], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 9 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[9], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[9], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 10 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[9], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 11 out index: 1
  v_mad_u64_u32      \m1[1:2], vcc, \inv[2], \mod[9], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[3], \mod[8], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[4], \mod[7], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[5], \mod[6], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[6], \mod[5], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[7], \mod[4], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[8], \mod[3], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[9], \mod[2], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc

  #; result limb 12 out index: 2
  v_mad_u64_u32      \m1[2:3], vcc, \inv[3], \mod[9], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[4], \mod[8], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[5], \mod[7], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[6], \mod[6], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[7], \mod[5], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[8], \mod[4], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[9], \mod[3], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc

  #; result limb 13 out index: 3
  v_mad_u64_u32      \m1[3:4], vcc, \inv[4], \mod[9], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[5], \mod[8], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[6], \mod[7], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[7], \mod[6], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[8], \mod[5], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[9], \mod[4], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc

  #; result limb 14 out index: 4
  v_mad_u64_u32      \m1[4:5], vcc, \inv[5], \mod[9], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[6], \mod[8], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[7], \mod[7], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[8], \mod[6], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[9], \mod[5], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc

  #; result limb 15 out index: 5
  v_mad_u64_u32      \m1[5:6], vcc, \inv[6], \mod[9], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[7], \mod[8], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[8], \mod[7], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[9], \mod[6], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc

  #; result limb 16 out index: 6
  v_mad_u64_u32      \m1[6:7], vcc, \inv[7], \mod[9], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[8], \mod[8], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[9], \mod[7], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc

  #; result limb 17 out index: 7
  v_mad_u64_u32      \m1[7:8], vcc, \inv[8], \mod[9], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[9], \mod[8], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, \m1[9], vcc

  #; result limb 18 out index: 8
  v_mad_u64_u32      \m1[8:9], vcc, \inv[9], \mod[9], \m1[8:9]

  #; result limb 19 out index: 9
.endm

.macro redcify320ws7, quotient, mod, N, cache, out, reg, zero
  v_sub_u32        \reg[0], vcc, (1 << 7), \N
  v_lshrrev_b32       \reg[1], 5, \reg[0]
  v_cmp_gt_u32        vcc, \reg[1], 0
  v_cndmask_b32       \cache[0], \quotient[0], \quotient[1], vcc
  v_cndmask_b32       \cache[1], \quotient[1], \quotient[2], vcc
  v_cndmask_b32       \cache[2], \quotient[2], \quotient[3], vcc
  v_cndmask_b32       \cache[3], \quotient[3], \quotient[4], vcc
  v_cndmask_b32       \cache[4], \quotient[4], \quotient[5], vcc
  v_cndmask_b32       \cache[5], \quotient[5], \quotient[6], vcc
  v_cndmask_b32       \cache[6], \quotient[6], \quotient[7], vcc
  v_cndmask_b32       \cache[7], \quotient[7], 0, vcc
  v_cmp_gt_u32        vcc, \reg[1], 1
  v_cndmask_b32       \cache[0], \cache[0], \cache[1], vcc
  v_cndmask_b32       \cache[1], \cache[1], \cache[2], vcc
  v_cndmask_b32       \cache[2], \cache[2], \cache[3], vcc
  v_cndmask_b32       \cache[3], \cache[3], \cache[4], vcc
  v_cndmask_b32       \cache[4], \cache[4], \cache[5], vcc
  v_cndmask_b32       \cache[5], \cache[5], \cache[6], vcc
  v_cndmask_b32       \cache[6], \cache[6], 0, vcc
  v_cmp_gt_u32        vcc, \reg[1], 2
  v_cndmask_b32       \cache[0], \cache[0], \cache[1], vcc
  v_cndmask_b32       \cache[1], \cache[1], \cache[2], vcc
  v_cndmask_b32       \cache[2], \cache[2], \cache[3], vcc
  v_cndmask_b32       \cache[3], \cache[3], \cache[4], vcc
  v_cndmask_b32       \cache[4], \cache[4], \cache[5], vcc
  v_cndmask_b32       \cache[5], \cache[5], 0, vcc
  v_cmp_gt_u32        vcc, \reg[1], 3
  v_cndmask_b32       \cache[0], \cache[0], \cache[1], vcc
  v_cndmask_b32       \cache[1], \cache[1], \cache[2], vcc
  v_cndmask_b32       \cache[2], \cache[2], \cache[3], vcc
  v_cndmask_b32       \cache[3], \cache[3], \cache[4], vcc
  v_cndmask_b32       \cache[4], \cache[4], 0, vcc
  v_mov_b32           \reg[1], 0xFFFFFFFF
  v_and_b32           \reg[0], 0x1F, \reg[0]
  v_cmp_eq_u32        vcc, \reg[0], 0
  v_cndmask_b32       \reg[2], \reg[1], 0, vcc
  v_sub_u32        \reg[1], vcc, 32, \reg[0]
  v_lshrrev_b32       \cache[0], \reg[0], \cache[0]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[1]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[0], \reg[3], \cache[0]
  v_lshrrev_b32       \cache[1], \reg[0], \cache[1]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[2]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[1], \reg[3], \cache[1]
  v_lshrrev_b32       \cache[2], \reg[0], \cache[2]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[3]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[2], \reg[3], \cache[2]
  v_lshrrev_b32       \cache[3], \reg[0], \cache[3]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[4]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[3], \reg[3], \cache[3]
  v_lshrrev_b32       \cache[4], \reg[0], \cache[4]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[5]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[4], \reg[3], \cache[4]
  v_lshrrev_b32       \cache[5], \reg[0], \cache[5]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[6]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[5], \reg[3], \cache[5]
  v_lshrrev_b32       \cache[6], \reg[0], \cache[6]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[7]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[6], \reg[3], \cache[6]
  v_lshrrev_b32       \cache[7], \reg[0], \cache[7]
  mul320to192l320     \mod, \cache, \out, \zero
  v_not_b32           \out[0], \out[0]
  v_not_b32           \out[1], \out[1]
  v_not_b32           \out[2], \out[2]
  v_not_b32           \out[3], \out[3]
  v_not_b32           \out[4], \out[4]
  v_not_b32           \out[5], \out[5]
  v_not_b32           \out[6], \out[6]
  v_not_b32           \out[7], \out[7]
  v_not_b32           \out[8], \out[8]
  v_not_b32           \out[9], \out[9]
  v_add_u32        \out[0], vcc, 1, \out[0]
.endm

.macro monsqr352, m1ctx, mod, inv, invm, cache, zero, x, sregs
  v_add_u32         \cache[0], vcc, \m1ctx[3], \m1ctx[3]
  v_subb_u32        \cache[1], vcc, 0, 0, vcc
  v_add_u32         \cache[2], vcc, \m1ctx[4], \m1ctx[4]
  v_subb_u32        \cache[3], vcc, 0, 0, vcc
  v_add_u32         \cache[4], vcc, \m1ctx[5], \m1ctx[5]
  v_subb_u32        \cache[5], vcc, 0, 0, vcc
  v_add_u32         \cache[6], vcc, \m1ctx[6], \m1ctx[6]
  v_subb_u32        \cache[7], vcc, 0, 0, vcc
  v_add_u32         \cache[8], vcc, \m1ctx[7], \m1ctx[7]
  v_subb_u32        \cache[9], vcc, 0, 0, vcc
  v_add_u32         \cache[10], vcc, \m1ctx[8], \m1ctx[8]
  v_subb_u32        \cache[11], vcc, 0, 0, vcc
  v_add_u32         \cache[12], vcc, \m1ctx[9], \m1ctx[9]
  v_subb_u32        \cache[13], vcc, 0, 0, vcc
  v_add_u32         \cache[14], vcc, \m1ctx[10], \m1ctx[10]
  v_subb_u32        \cache[15], vcc, 0, 0, vcc
  v_add_u32         \cache[16], vcc, \m1ctx[11], \m1ctx[11]
  v_subb_u32        \cache[17], vcc, 0, 0, vcc
  v_add_u32         \cache[18], vcc, \m1ctx[12], \m1ctx[12]
  v_subb_u32        \cache[19], vcc, 0, 0, vcc
  v_add_u32         \cache[20], vcc, \m1ctx[13], \m1ctx[13]
  v_subb_u32        \cache[21], vcc, 0, 0, vcc

  #; result limb 0 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[3], \m1ctx[3], \zero[0:1]
  v_mul_lo_u32       \inv[0], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc

  #; result limb 1 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[4], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[4]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[1], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 2 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[5], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[5]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[4], \m1ctx[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[2], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 3 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[6], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[6]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[5]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[3], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 4 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[7], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[6]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[5], \m1ctx[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[4], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 5 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[8], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[6]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[5], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 6 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[9], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[9]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[8], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[6], \m1ctx[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[6], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[6], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 7 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[10], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[10]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[9], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[9]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[8], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[6], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[7], \m1ctx[7]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[6], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[7], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[7], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 8 out index: 0
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[0], \m1ctx[11], \m1ctx[1:2]
  v_addc_u32      \m1ctx[2], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[11]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[2], \m1ctx[10], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[3], \m1ctx[10]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[4], \m1ctx[9], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[5], \m1ctx[9]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \cache[6], \m1ctx[8], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_and_b32          \x, \cache[7], \m1ctx[8]
  v_add_u32       \m1ctx[1], vcc, \x, \m1ctx[1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \m1ctx[7], \m1ctx[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[0], \mod[8], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[1], \mod[7], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[2], \mod[6], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[3], \mod[5], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[4], \mod[4], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[5], \mod[3], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[6], \mod[2], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[7], \mod[1], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc
  v_mul_lo_u32       \inv[8], \m1ctx[0], \invm
  v_mad_u64_u32      \m1ctx[0:1], vcc, \inv[8], \mod[0], \m1ctx[0:1]
  v_addc_u32      \m1ctx[2], vcc, 0, \m1ctx[2], vcc

  #; result limb 9 out index: 1
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[0], \m1ctx[12], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[12]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[2], \m1ctx[11], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[3], \m1ctx[11]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[4], \m1ctx[10], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[5], \m1ctx[10]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[6], \m1ctx[9], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[7], \m1ctx[9]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \cache[8], \m1ctx[8], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_and_b32          \x, \cache[9], \m1ctx[8]
  v_add_u32       \m1ctx[2], vcc, \x, \m1ctx[2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[0], \mod[9], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[1], \mod[8], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[2], \mod[7], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[3], \mod[6], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[4], \mod[5], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[5], \mod[4], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[6], \mod[3], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[7], \mod[2], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[8], \mod[1], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc
  v_mul_lo_u32       \inv[9], \m1ctx[1], \invm
  v_mad_u64_u32      \m1ctx[1:2], vcc, \inv[9], \mod[0], \m1ctx[1:2]
  v_addc_u32      \m1ctx[3], vcc, 0, \m1ctx[3], vcc

  #; result limb 10 out index: 2
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[0], \m1ctx[13], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[1], \m1ctx[13]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[2], \m1ctx[12], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[3], \m1ctx[12]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[4], \m1ctx[11], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[5], \m1ctx[11]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[6], \m1ctx[10], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[7], \m1ctx[10]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \cache[8], \m1ctx[9], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_and_b32          \x, \cache[9], \m1ctx[9]
  v_add_u32       \m1ctx[3], vcc, \x, \m1ctx[3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \m1ctx[8], \m1ctx[8], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[0], \mod[10], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[1], \mod[9], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[2], \mod[8], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[3], \mod[7], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[4], \mod[6], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[5], \mod[5], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[6], \mod[4], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[7], \mod[3], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[8], \mod[2], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[9], \mod[1], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc
  v_mul_lo_u32       \inv[10], \m1ctx[2], \invm
  v_mad_u64_u32      \m1ctx[2:3], vcc, \inv[10], \mod[0], \m1ctx[2:3]
  v_addc_u32      \m1ctx[4], vcc, 0, \m1ctx[4], vcc

  #; result limb 11 out index: 3
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[2], \m1ctx[13], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[3], \m1ctx[13]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[4], \m1ctx[12], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[5], \m1ctx[12]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[6], \m1ctx[11], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[7], \m1ctx[11]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[8], \m1ctx[10], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[9], \m1ctx[10]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \cache[10], \m1ctx[9], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_and_b32          \x, \cache[11], \m1ctx[9]
  v_add_u32       \m1ctx[4], vcc, \x, \m1ctx[4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[1], \mod[10], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[2], \mod[9], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[3], \mod[8], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[4], \mod[7], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[5], \mod[6], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[6], \mod[5], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[7], \mod[4], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[8], \mod[3], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[9], \mod[2], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc
  v_mad_u64_u32      \m1ctx[3:4], vcc, \inv[10], \mod[1], \m1ctx[3:4]
  v_addc_u32      \m1ctx[5], vcc, 0, \m1ctx[5], vcc

  #; result limb 12 out index: 4
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[4], \m1ctx[13], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[5], \m1ctx[13]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[6], \m1ctx[12], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_and_b32          \x, \cache[7], \m1ctx[12]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[8], \m1ctx[11], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_and_b32          \x, \cache[9], \m1ctx[11]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \cache[10], \m1ctx[10], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_and_b32          \x, \cache[11], \m1ctx[10]
  v_add_u32       \m1ctx[5], vcc, \x, \m1ctx[5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \m1ctx[9], \m1ctx[9], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[2], \mod[10], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[3], \mod[9], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[4], \mod[8], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[5], \mod[7], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[6], \mod[6], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[7], \mod[5], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[8], \mod[4], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[9], \mod[3], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc
  v_mad_u64_u32      \m1ctx[4:5], vcc, \inv[10], \mod[2], \m1ctx[4:5]
  v_addc_u32      \m1ctx[6], vcc, 0, \m1ctx[6], vcc

  #; result limb 13 out index: 5
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[6], \m1ctx[13], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[7], \m1ctx[13]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[8], \m1ctx[12], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_and_b32          \x, \cache[9], \m1ctx[12]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[10], \m1ctx[11], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_and_b32          \x, \cache[11], \m1ctx[11]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \cache[12], \m1ctx[10], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_and_b32          \x, \cache[13], \m1ctx[10]
  v_add_u32       \m1ctx[6], vcc, \x, \m1ctx[6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[3], \mod[10], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[4], \mod[9], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[5], \mod[8], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[6], \mod[7], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[7], \mod[6], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[8], \mod[5], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[9], \mod[4], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc
  v_mad_u64_u32      \m1ctx[5:6], vcc, \inv[10], \mod[3], \m1ctx[5:6]
  v_addc_u32      \m1ctx[7], vcc, 0, \m1ctx[7], vcc

  #; result limb 14 out index: 6
  v_mad_u64_u32      \m1ctx[6:7], vcc, \cache[8], \m1ctx[13], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[9], \m1ctx[13]
  v_add_u32       \m1ctx[7], vcc, \x, \m1ctx[7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \cache[10], \m1ctx[12], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_and_b32          \x, \cache[11], \m1ctx[12]
  v_add_u32       \m1ctx[7], vcc, \x, \m1ctx[7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \cache[12], \m1ctx[11], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_and_b32          \x, \cache[13], \m1ctx[11]
  v_add_u32       \m1ctx[7], vcc, \x, \m1ctx[7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \m1ctx[10], \m1ctx[10], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[4], \mod[10], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[5], \mod[9], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[6], \mod[8], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[7], \mod[7], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[8], \mod[6], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[9], \mod[5], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc
  v_mad_u64_u32      \m1ctx[6:7], vcc, \inv[10], \mod[4], \m1ctx[6:7]
  v_addc_u32      \m1ctx[8], vcc, 0, \m1ctx[8], vcc

  #; result limb 15 out index: 7
  v_mad_u64_u32      \m1ctx[7:8], vcc, \cache[10], \m1ctx[13], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[11], \m1ctx[13]
  v_add_u32       \m1ctx[8], vcc, \x, \m1ctx[8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \cache[12], \m1ctx[12], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_and_b32          \x, \cache[13], \m1ctx[12]
  v_add_u32       \m1ctx[8], vcc, \x, \m1ctx[8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \cache[14], \m1ctx[11], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_and_b32          \x, \cache[15], \m1ctx[11]
  v_add_u32       \m1ctx[8], vcc, \x, \m1ctx[8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[5], \mod[10], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[6], \mod[9], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[7], \mod[8], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[8], \mod[7], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[9], \mod[6], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc
  v_mad_u64_u32      \m1ctx[7:8], vcc, \inv[10], \mod[5], \m1ctx[7:8]
  v_addc_u32      \m1ctx[9], vcc, 0, \m1ctx[9], vcc

  #; result limb 16 out index: 8
  v_mad_u64_u32      \m1ctx[8:9], vcc, \cache[12], \m1ctx[13], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[13], \m1ctx[13]
  v_add_u32       \m1ctx[9], vcc, \x, \m1ctx[9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \cache[14], \m1ctx[12], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_and_b32          \x, \cache[15], \m1ctx[12]
  v_add_u32       \m1ctx[9], vcc, \x, \m1ctx[9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \m1ctx[11], \m1ctx[11], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[6], \mod[10], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[7], \mod[9], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[8], \mod[8], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[9], \mod[7], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc
  v_mad_u64_u32      \m1ctx[8:9], vcc, \inv[10], \mod[6], \m1ctx[8:9]
  v_addc_u32      \m1ctx[10], vcc, 0, \m1ctx[10], vcc

  #; result limb 17 out index: 9
  v_mad_u64_u32      \m1ctx[9:10], vcc, \cache[14], \m1ctx[13], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[15], \m1ctx[13]
  v_add_u32       \m1ctx[10], vcc, \x, \m1ctx[10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \cache[16], \m1ctx[12], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_and_b32          \x, \cache[17], \m1ctx[12]
  v_add_u32       \m1ctx[10], vcc, \x, \m1ctx[10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[7], \mod[10], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[8], \mod[9], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[9], \mod[8], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc
  v_mad_u64_u32      \m1ctx[9:10], vcc, \inv[10], \mod[7], \m1ctx[9:10]
  v_addc_u32      \m1ctx[11], vcc, 0, \m1ctx[11], vcc

  #; result limb 18 out index: 10
  #; move 2 last limbs to begin of m1ctx
  v_mov_b32          \m1ctx[0], \m1ctx[12]
  v_mov_b32          \m1ctx[1], \m1ctx[13]
  v_mad_u64_u32      \m1ctx[10:11], vcc, \cache[16], \m1ctx[1], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[17], \m1ctx[1]
  v_add_u32       \m1ctx[11], vcc, \x, \m1ctx[11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc
  v_mad_u64_u32      \m1ctx[10:11], vcc, \m1ctx[0], \m1ctx[0], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc
  v_mad_u64_u32      \m1ctx[10:11], vcc, \inv[8], \mod[10], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc
  v_mad_u64_u32      \m1ctx[10:11], vcc, \inv[9], \mod[9], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc
  v_mad_u64_u32      \m1ctx[10:11], vcc, \inv[10], \mod[8], \m1ctx[10:11]
  v_addc_u32      \m1ctx[12], vcc, 0, \m1ctx[12], vcc

  #; result limb 19 out index: 11
  v_mad_u64_u32      \m1ctx[11:12], vcc, \cache[18], \m1ctx[1], \m1ctx[11:12]
  v_addc_u32      \m1ctx[13], vcc, 0, 0, vcc
  v_and_b32          \x, \cache[19], \m1ctx[1]
  v_add_u32       \m1ctx[12], vcc, \x, \m1ctx[12]
  v_addc_u32      \m1ctx[13], vcc, 0, \m1ctx[13], vcc
  v_mad_u64_u32      \m1ctx[11:12], vcc, \inv[9], \mod[10], \m1ctx[11:12]
  v_addc_u32      \m1ctx[13], vcc, 0, \m1ctx[13], vcc
  v_mad_u64_u32      \m1ctx[11:12], vcc, \inv[10], \mod[9], \m1ctx[11:12]
  v_addc_u32      \m1ctx[13], vcc, 0, \m1ctx[13], vcc

  #; result limb 20 out index: 12
  v_mad_u64_u32      \m1ctx[12:13], vcc, \m1ctx[1], \m1ctx[1], \m1ctx[12:13]
  v_addc_u32      \x, vcc, 0, 0, vcc
  v_mad_u64_u32      \m1ctx[12:13], vcc, \inv[10], \mod[10], \m1ctx[12:13]
  v_addc_u32      \x, vcc, 0, \x, vcc

  #; result limb 21 out index: 13
  s_mov_b64         \sregs, exec
  v_cmpx_gt_u32     vcc, \x, 0
  v_sub_u32      \m1ctx[3], vcc, \m1ctx[3], \mod[0]
  v_subb_u32     \m1ctx[4], vcc, \m1ctx[4], \mod[1], vcc
  v_subb_u32     \m1ctx[5], vcc, \m1ctx[5], \mod[2], vcc
  v_subb_u32     \m1ctx[6], vcc, \m1ctx[6], \mod[3], vcc
  v_subb_u32     \m1ctx[7], vcc, \m1ctx[7], \mod[4], vcc
  v_subb_u32     \m1ctx[8], vcc, \m1ctx[8], \mod[5], vcc
  v_subb_u32     \m1ctx[9], vcc, \m1ctx[9], \mod[6], vcc
  v_subb_u32     \m1ctx[10], vcc, \m1ctx[10], \mod[7], vcc
  v_subb_u32     \m1ctx[11], vcc, \m1ctx[11], \mod[8], vcc
  v_subb_u32     \m1ctx[12], vcc, \m1ctx[12], \mod[9], vcc
  v_subb_u32     \m1ctx[13], vcc, \m1ctx[13], \mod[10], vcc
  s_mov_b64         exec, \sregs
.endm

.macro monmul352, m1, m2, mod, inv, invm, cache, zero, x, sregs
  v_mov_b32           \cache[0], \m1[0]
  v_mov_b32           \cache[1], \m1[1]
  v_mov_b32           \cache[2], \m1[2]
  v_mov_b32           \cache[3], \m1[3]
  v_mov_b32           \cache[4], \m1[4]
  v_mov_b32           \cache[5], \m1[5]
  v_mov_b32           \cache[6], \m1[6]
  v_mov_b32           \cache[7], \m1[7]
  v_mov_b32           \cache[8], \m1[8]
  v_mov_b32           \cache[9], \m1[9]
  v_mov_b32           \cache[10], \m1[10]

  #; result limb 0 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[0], \zero[0:1]
  v_mul_lo_u32       \inv[0], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc

  #; result limb 1 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[1], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[1], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 2 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[2], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[2], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 3 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[3], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[3], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 4 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[4], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[4], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 5 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[5], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[5], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 6 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[6], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[6], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 7 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[7], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[7], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 8 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[8], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[8], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 9 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[9], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[9], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[9], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[9], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 10 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[0], \m2[10], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[9], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[9], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[10], \m2[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[10], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[9], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[10], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[10], \mod[0], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 11 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \cache[1], \m2[10], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[2], \m2[9], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[3], \m2[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[4], \m2[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[5], \m2[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[6], \m2[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[7], \m2[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[8], \m2[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[9], \m2[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \cache[10], \m2[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[10], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[9], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[8], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[7], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[6], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[5], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[4], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[3], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[2], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[10], \mod[1], \m1[0:1]
  v_addc_u32    \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 12 out index: 1
  v_mad_u64_u32      \m1[1:2], vcc, \cache[2], \m2[10], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[3], \m2[9], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[4], \m2[8], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[5], \m2[7], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[6], \m2[6], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[7], \m2[5], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[8], \m2[4], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[9], \m2[3], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \cache[10], \m2[2], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[2], \mod[10], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[3], \mod[9], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[4], \mod[8], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[5], \mod[7], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[6], \mod[6], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[7], \mod[5], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[8], \mod[4], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[9], \mod[3], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[10], \mod[2], \m1[1:2]
  v_addc_u32    \m1[3], vcc, 0, \m1[3], vcc

  #; result limb 13 out index: 2
  v_mad_u64_u32      \m1[2:3], vcc, \cache[3], \m2[10], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[4], \m2[9], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[5], \m2[8], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[6], \m2[7], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[7], \m2[6], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[8], \m2[5], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[9], \m2[4], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \cache[10], \m2[3], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[3], \mod[10], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[4], \mod[9], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[5], \mod[8], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[6], \mod[7], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[7], \mod[6], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[8], \mod[5], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[9], \mod[4], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[10], \mod[3], \m1[2:3]
  v_addc_u32    \m1[4], vcc, 0, \m1[4], vcc

  #; result limb 14 out index: 3
  v_mad_u64_u32      \m1[3:4], vcc, \cache[4], \m2[10], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[5], \m2[9], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[6], \m2[8], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[7], \m2[7], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[8], \m2[6], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[9], \m2[5], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \cache[10], \m2[4], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[4], \mod[10], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[5], \mod[9], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[6], \mod[8], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[7], \mod[7], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[8], \mod[6], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[9], \mod[5], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[10], \mod[4], \m1[3:4]
  v_addc_u32    \m1[5], vcc, 0, \m1[5], vcc

  #; result limb 15 out index: 4
  v_mad_u64_u32      \m1[4:5], vcc, \cache[5], \m2[10], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[6], \m2[9], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[7], \m2[8], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[8], \m2[7], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[9], \m2[6], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \cache[10], \m2[5], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[5], \mod[10], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[6], \mod[9], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[7], \mod[8], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[8], \mod[7], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[9], \mod[6], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[10], \mod[5], \m1[4:5]
  v_addc_u32    \m1[6], vcc, 0, \m1[6], vcc

  #; result limb 16 out index: 5
  v_mad_u64_u32      \m1[5:6], vcc, \cache[6], \m2[10], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[7], \m2[9], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[8], \m2[8], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[9], \m2[7], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \cache[10], \m2[6], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[6], \mod[10], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[7], \mod[9], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[8], \mod[8], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[9], \mod[7], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[10], \mod[6], \m1[5:6]
  v_addc_u32    \m1[7], vcc, 0, \m1[7], vcc

  #; result limb 17 out index: 6
  v_mad_u64_u32      \m1[6:7], vcc, \cache[7], \m2[10], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[6:7], vcc, \cache[8], \m2[9], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \cache[9], \m2[8], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \cache[10], \m2[7], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[7], \mod[10], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[8], \mod[9], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[9], \mod[8], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[10], \mod[7], \m1[6:7]
  v_addc_u32    \m1[8], vcc, 0, \m1[8], vcc

  #; result limb 18 out index: 7
  v_mad_u64_u32      \m1[7:8], vcc, \cache[8], \m2[10], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[7:8], vcc, \cache[9], \m2[9], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \cache[10], \m2[8], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[8], \mod[10], \m1[7:8]
  v_addc_u32    \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[9], \mod[9], \m1[7:8]
  v_addc_u32    \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[10], \mod[8], \m1[7:8]
  v_addc_u32    \m1[9], vcc, 0, \m1[9], vcc

  #; result limb 19 out index: 8
  v_mad_u64_u32      \m1[8:9], vcc, \cache[9], \m2[10], \m1[8:9]
  v_addc_u32      \m1[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[8:9], vcc, \cache[10], \m2[9], \m1[8:9]
  v_addc_u32      \m1[10], vcc, 0, \m1[10], vcc
  v_mad_u64_u32      \m1[8:9], vcc, \inv[9], \mod[10], \m1[8:9]
  v_addc_u32    \m1[10], vcc, 0, \m1[10], vcc
  v_mad_u64_u32      \m1[8:9], vcc, \inv[10], \mod[9], \m1[8:9]
  v_addc_u32    \m1[10], vcc, 0, \m1[10], vcc

  #; result limb 20 out index: 9
  v_mad_u64_u32      \m1[9:10], vcc, \cache[10], \m2[10], \m1[9:10]
  v_addc_u32      \x, vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[9:10], vcc, \inv[10], \mod[10], \m1[9:10]
  v_addc_u32      \x, vcc, 0, \x, vcc

  #; result limb 21 out index: 10
  s_mov_b64         \sregs, exec
  v_cmpx_gt_u32     vcc, \x, 0
  v_sub_u32      \m1[0], vcc, \m1[0], \mod[0]
  v_subb_u32     \m1[1], vcc, \m1[1], \mod[1], vcc
  v_subb_u32     \m1[2], vcc, \m1[2], \mod[2], vcc
  v_subb_u32     \m1[3], vcc, \m1[3], \mod[3], vcc
  v_subb_u32     \m1[4], vcc, \m1[4], \mod[4], vcc
  v_subb_u32     \m1[5], vcc, \m1[5], \mod[5], vcc
  v_subb_u32     \m1[6], vcc, \m1[6], \mod[6], vcc
  v_subb_u32     \m1[7], vcc, \m1[7], \mod[7], vcc
  v_subb_u32     \m1[8], vcc, \m1[8], \mod[8], vcc
  v_subb_u32     \m1[9], vcc, \m1[9], \mod[9], vcc
  v_subb_u32     \m1[10], vcc, \m1[10], \mod[10], vcc
  s_mov_b64         exec, \sregs
.endm

.macro redchalf352, m1, mod, inv, invm, cache, zero, x
  v_mov_b32           \cache[0], \m1[0]
  v_mov_b32           \cache[1], \m1[1]
  v_mov_b32           \cache[2], \m1[2]
  v_mov_b32           \cache[3], \m1[3]
  v_mov_b32           \cache[4], \m1[4]
  v_mov_b32           \cache[5], \m1[5]
  v_mov_b32           \cache[6], \m1[6]
  v_mov_b32           \cache[7], \m1[7]
  v_mov_b32           \cache[8], \m1[8]
  v_mov_b32           \cache[9], \m1[9]
  v_mov_b32           \cache[10], \m1[10]

  #; result limb 0 out index: 0
  v_mul_lo_u32       \inv[0], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[0], \cache[0:1]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc

  #; result limb 1 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[1], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 1 from m1
  v_add_u32       \m1[1], vcc, \cache[2], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[1], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 2 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[2], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 2 from m1
  v_add_u32       \m1[1], vcc, \cache[3], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[2], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 3 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[3], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 3 from m1
  v_add_u32       \m1[1], vcc, \cache[4], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[3], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 4 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[4], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 4 from m1
  v_add_u32       \m1[1], vcc, \cache[5], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[4], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 5 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[5], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 5 from m1
  v_add_u32       \m1[1], vcc, \cache[6], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[5], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 6 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[6], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 6 from m1
  v_add_u32       \m1[1], vcc, \cache[7], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[6], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 7 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[7], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 7 from m1
  v_add_u32       \m1[1], vcc, \cache[8], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[7], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 8 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[8], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 8 from m1
  v_add_u32       \m1[1], vcc, \cache[9], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[8], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 9 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[9], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  #; add limb 9 from m1
  v_add_u32       \m1[1], vcc, \cache[10], \m1[1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[9], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 10 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[0], \mod[10], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[9], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mul_lo_u32       \inv[10], \m1[0], \invm
  v_mad_u64_u32      \m1[0:1], vcc, \inv[10], \mod[0], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 11 out index: 0
  v_mad_u64_u32      \m1[0:1], vcc, \inv[1], \mod[10], \m1[1:2]
  v_addc_u32      \m1[2], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[2], \mod[9], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[3], \mod[8], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[4], \mod[7], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[5], \mod[6], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[6], \mod[5], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[7], \mod[4], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[8], \mod[3], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[9], \mod[2], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc
  v_mad_u64_u32      \m1[0:1], vcc, \inv[10], \mod[1], \m1[0:1]
  v_addc_u32      \m1[2], vcc, 0, \m1[2], vcc

  #; result limb 12 out index: 1
  v_mad_u64_u32      \m1[1:2], vcc, \inv[2], \mod[10], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[3], \mod[9], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[4], \mod[8], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[5], \mod[7], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[6], \mod[6], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[7], \mod[5], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[8], \mod[4], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[9], \mod[3], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc
  v_mad_u64_u32      \m1[1:2], vcc, \inv[10], \mod[2], \m1[1:2]
  v_addc_u32      \m1[3], vcc, 0, \m1[3], vcc

  #; result limb 13 out index: 2
  v_mad_u64_u32      \m1[2:3], vcc, \inv[3], \mod[10], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[4], \mod[9], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[5], \mod[8], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[6], \mod[7], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[7], \mod[6], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[8], \mod[5], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[9], \mod[4], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc
  v_mad_u64_u32      \m1[2:3], vcc, \inv[10], \mod[3], \m1[2:3]
  v_addc_u32      \m1[4], vcc, 0, \m1[4], vcc

  #; result limb 14 out index: 3
  v_mad_u64_u32      \m1[3:4], vcc, \inv[4], \mod[10], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[5], \mod[9], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[6], \mod[8], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[7], \mod[7], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[8], \mod[6], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[9], \mod[5], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc
  v_mad_u64_u32      \m1[3:4], vcc, \inv[10], \mod[4], \m1[3:4]
  v_addc_u32      \m1[5], vcc, 0, \m1[5], vcc

  #; result limb 15 out index: 4
  v_mad_u64_u32      \m1[4:5], vcc, \inv[5], \mod[10], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[6], \mod[9], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[7], \mod[8], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[8], \mod[7], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[9], \mod[6], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc
  v_mad_u64_u32      \m1[4:5], vcc, \inv[10], \mod[5], \m1[4:5]
  v_addc_u32      \m1[6], vcc, 0, \m1[6], vcc

  #; result limb 16 out index: 5
  v_mad_u64_u32      \m1[5:6], vcc, \inv[6], \mod[10], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[7], \mod[9], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[8], \mod[8], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[9], \mod[7], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc
  v_mad_u64_u32      \m1[5:6], vcc, \inv[10], \mod[6], \m1[5:6]
  v_addc_u32      \m1[7], vcc, 0, \m1[7], vcc

  #; result limb 17 out index: 6
  v_mad_u64_u32      \m1[6:7], vcc, \inv[7], \mod[10], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[8], \mod[9], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[9], \mod[8], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc
  v_mad_u64_u32      \m1[6:7], vcc, \inv[10], \mod[7], \m1[6:7]
  v_addc_u32      \m1[8], vcc, 0, \m1[8], vcc

  #; result limb 18 out index: 7
  v_mad_u64_u32      \m1[7:8], vcc, \inv[8], \mod[10], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[9], \mod[9], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, \m1[9], vcc
  v_mad_u64_u32      \m1[7:8], vcc, \inv[10], \mod[8], \m1[7:8]
  v_addc_u32      \m1[9], vcc, 0, \m1[9], vcc

  #; result limb 19 out index: 8
  v_mad_u64_u32      \m1[8:9], vcc, \inv[9], \mod[10], \m1[8:9]
  v_addc_u32      \m1[10], vcc, 0, 0, vcc
  v_mad_u64_u32      \m1[8:9], vcc, \inv[10], \mod[9], \m1[8:9]
  v_addc_u32      \m1[10], vcc, 0, \m1[10], vcc

  #; result limb 20 out index: 9
  v_mad_u64_u32      \m1[9:10], vcc, \inv[10], \mod[10], \m1[9:10]

  #; result limb 21 out index: 10
.endm

.macro redcify352ws7, quotient, mod, N, cache, out, reg, zero
  v_sub_u32        \reg[0], vcc, (1 << 7), \N
  v_lshrrev_b32       \reg[1], 5, \reg[0]
  v_cmp_gt_u32        vcc, \reg[1], 0
  v_cndmask_b32       \cache[0], \quotient[0], \quotient[1], vcc
  v_cndmask_b32       \cache[1], \quotient[1], \quotient[2], vcc
  v_cndmask_b32       \cache[2], \quotient[2], \quotient[3], vcc
  v_cndmask_b32       \cache[3], \quotient[3], \quotient[4], vcc
  v_cndmask_b32       \cache[4], \quotient[4], \quotient[5], vcc
  v_cndmask_b32       \cache[5], \quotient[5], \quotient[6], vcc
  v_cndmask_b32       \cache[6], \quotient[6], \quotient[7], vcc
  v_cndmask_b32       \cache[7], \quotient[7], 0, vcc
  v_cmp_gt_u32        vcc, \reg[1], 1
  v_cndmask_b32       \cache[0], \cache[0], \cache[1], vcc
  v_cndmask_b32       \cache[1], \cache[1], \cache[2], vcc
  v_cndmask_b32       \cache[2], \cache[2], \cache[3], vcc
  v_cndmask_b32       \cache[3], \cache[3], \cache[4], vcc
  v_cndmask_b32       \cache[4], \cache[4], \cache[5], vcc
  v_cndmask_b32       \cache[5], \cache[5], \cache[6], vcc
  v_cndmask_b32       \cache[6], \cache[6], 0, vcc
  v_cmp_gt_u32        vcc, \reg[1], 2
  v_cndmask_b32       \cache[0], \cache[0], \cache[1], vcc
  v_cndmask_b32       \cache[1], \cache[1], \cache[2], vcc
  v_cndmask_b32       \cache[2], \cache[2], \cache[3], vcc
  v_cndmask_b32       \cache[3], \cache[3], \cache[4], vcc
  v_cndmask_b32       \cache[4], \cache[4], \cache[5], vcc
  v_cndmask_b32       \cache[5], \cache[5], 0, vcc
  v_cmp_gt_u32        vcc, \reg[1], 3
  v_cndmask_b32       \cache[0], \cache[0], \cache[1], vcc
  v_cndmask_b32       \cache[1], \cache[1], \cache[2], vcc
  v_cndmask_b32       \cache[2], \cache[2], \cache[3], vcc
  v_cndmask_b32       \cache[3], \cache[3], \cache[4], vcc
  v_cndmask_b32       \cache[4], \cache[4], 0, vcc
  v_mov_b32           \reg[1], 0xFFFFFFFF
  v_and_b32           \reg[0], 0x1F, \reg[0]
  v_cmp_eq_u32        vcc, \reg[0], 0
  v_cndmask_b32       \reg[2], \reg[1], 0, vcc
  v_sub_u32        \reg[1], vcc, 32, \reg[0]
  v_lshrrev_b32       \cache[0], \reg[0], \cache[0]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[1]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[0], \reg[3], \cache[0]
  v_lshrrev_b32       \cache[1], \reg[0], \cache[1]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[2]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[1], \reg[3], \cache[1]
  v_lshrrev_b32       \cache[2], \reg[0], \cache[2]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[3]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[2], \reg[3], \cache[2]
  v_lshrrev_b32       \cache[3], \reg[0], \cache[3]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[4]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[3], \reg[3], \cache[3]
  v_lshrrev_b32       \cache[4], \reg[0], \cache[4]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[5]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[4], \reg[3], \cache[4]
  v_lshrrev_b32       \cache[5], \reg[0], \cache[5]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[6]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[5], \reg[3], \cache[5]
  v_lshrrev_b32       \cache[6], \reg[0], \cache[6]
  v_lshlrev_b32       \reg[3], \reg[1], \cache[7]
  v_and_b32           \reg[3], \reg[2], \reg[3]
  v_or_b32            \cache[6], \reg[3], \cache[6]
  v_lshrrev_b32       \cache[7], \reg[0], \cache[7]
  mul352to192l352     \mod, \cache, \out, \zero
  v_not_b32           \out[0], \out[0]
  v_not_b32           \out[1], \out[1]
  v_not_b32           \out[2], \out[2]
  v_not_b32           \out[3], \out[3]
  v_not_b32           \out[4], \out[4]
  v_not_b32           \out[5], \out[5]
  v_not_b32           \out[6], \out[6]
  v_not_b32           \out[7], \out[7]
  v_not_b32           \out[8], \out[8]
  v_not_b32           \out[9], \out[9]
  v_not_b32           \out[10], \out[10]
  v_add_u32        \out[0], vcc, 1, \out[0]
.endm

.macro div480to320, dividend, divisor, quotient, size, reg, sreg, zero
      dividendSize = %\reg[16]
       divisorSize = %\reg[17]
         cyclesNum = %\reg[18]
        shiftCount = %\reg[19]
                 q = %\reg[20]
            borrow = %\reg[21]
  v_mov_b32           \quotient[0], 0
  v_mov_b32           \quotient[1], 0
  v_mov_b32           \quotient[2], 0
  v_mov_b32           \quotient[3], 0
  v_mov_b32           \quotient[4], 0
  v_mov_b32           \quotient[5], 0
  v_mov_b32           \quotient[6], 0
  v_mov_b32           \quotient[7], 0
  v_mov_b32           dividendSize, (480/32)
  v_mov_b32           divisorSize, (320/32)
  s_mov_b64            \sreg[0:1], exec
.div_divisornormalize_loop:
  v_cmpx_eq_u32       vcc, \divisor[9], 0
  s_cbranch_execz     .div_divisornormalize_loop_end
  limbshl10           \divisor
  v_sub_u32           divisorSize, vcc, divisorSize, 1
  s_branch            .div_divisornormalize_loop
.div_divisornormalize_loop_end:
  s_mov_b64           exec, \sreg[0:1]
  v_ffbh_u32          shiftCount, \divisor[9]
  shl10               \divisor, shiftCount, \reg
  shl15               \dividend, shiftCount, \reg
.div_dividendnormalize_loop:
  v_cmpx_eq_u32       vcc, \dividend[14], 0
  s_cbranch_execz     .div_dividendnormalize_loop_end
  limbshl15           \dividend
  v_sub_u32           dividendSize, vcc, dividendSize, 1
  s_branch            .div_dividendnormalize_loop
.div_dividendnormalize_loop_end:
  s_mov_b64           exec, \sreg[0:1]
  v_sub_u32           \reg[0], vcc, dividendSize, divisorSize
  v_min_u32           cyclesNum, \reg[0], 8
.div_mainloop:
  v_cmpx_gt_u32       vcc, cyclesNum, 0
  s_cbranch_execz     .div_mainloop_end
  #; make division highest 64-bit dividend bits to highest 32-bit divisor bits
      dividendhi = %\dividend[13:14]
  div64to32           dividendhi, \divisor[9], q, \reg, \sreg[2:3]
  v_mov_b32           \reg[0], 0xFFFFFFFF
  v_cmp_eq_u32        vcc, \dividend[14], \divisor[9]
  v_cndmask_b32       q, q, \reg[0], vcc
      dividendhi = %\dividend[4:14]
      carryholder = %\sreg[2:3]
  submul320           dividendhi, \divisor, q, \reg, carryholder, \zero
  v_mov_b32           borrow, \dividend[14]
  limbshl15           \dividend
  s_mov_b64           \sreg[2:3], exec
  v_cmpx_lg_u32       vcc, borrow, 0
  v_add_u32        \dividend[5], vcc, \dividend[5], \divisor[0]
  v_addc_u32       \dividend[6], vcc, \dividend[6], \divisor[1], vcc
  v_addc_u32       \dividend[7], vcc, \dividend[7], \divisor[2], vcc
  v_addc_u32       \dividend[8], vcc, \dividend[8], \divisor[3], vcc
  v_addc_u32       \dividend[9], vcc, \dividend[9], \divisor[4], vcc
  v_addc_u32       \dividend[10], vcc, \dividend[10], \divisor[5], vcc
  v_addc_u32       \dividend[11], vcc, \dividend[11], \divisor[6], vcc
  v_addc_u32       \dividend[12], vcc, \dividend[12], \divisor[7], vcc
  v_addc_u32       \dividend[13], vcc, \dividend[13], \divisor[8], vcc
  v_addc_u32       \dividend[14], vcc, \dividend[14], \divisor[9], vcc
  v_sub_u32           q, vcc, q, 1
  v_cmpx_gt_u32       vcc, \dividend[14], \divisor[9]
  v_add_u32        \dividend[5], vcc, \dividend[5], \divisor[0]
  v_addc_u32       \dividend[6], vcc, \dividend[6], \divisor[1], vcc
  v_addc_u32       \dividend[7], vcc, \dividend[7], \divisor[2], vcc
  v_addc_u32       \dividend[8], vcc, \dividend[8], \divisor[3], vcc
  v_addc_u32       \dividend[9], vcc, \dividend[9], \divisor[4], vcc
  v_addc_u32       \dividend[10], vcc, \dividend[10], \divisor[5], vcc
  v_addc_u32       \dividend[11], vcc, \dividend[11], \divisor[6], vcc
  v_addc_u32       \dividend[12], vcc, \dividend[12], \divisor[7], vcc
  v_addc_u32       \dividend[13], vcc, \dividend[13], \divisor[8], vcc
  v_addc_u32       \dividend[14], vcc, \dividend[14], \divisor[9], vcc
  v_sub_u32           q, vcc, q, 1
  s_mov_b64           exec, \sreg[2:3]
  limbshl8           \quotient
  v_mov_b32           \quotient[0], q
  v_sub_u32           cyclesNum, vcc, cyclesNum, 1
  s_branch            .div_mainloop
.div_mainloop_end:
  s_mov_b64           exec, \sreg[0:1]
  v_sub_u32           \reg[1], vcc, 320, shiftCount
  v_sub_u32           \reg[0], vcc, 10, divisorSize
  v_lshlrev_b32       \reg[0], 5, \reg[0]
  v_sub_u32           \size, vcc, \reg[1], \reg[0]
.endm

.macro div512to352, dividend, divisor, quotient, size, reg, sreg, zero
      dividendSize = %\reg[16]
       divisorSize = %\reg[17]
         cyclesNum = %\reg[18]
        shiftCount = %\reg[19]
                 q = %\reg[20]
            borrow = %\reg[21]
  v_mov_b32           \quotient[0], 0
  v_mov_b32           \quotient[1], 0
  v_mov_b32           \quotient[2], 0
  v_mov_b32           \quotient[3], 0
  v_mov_b32           \quotient[4], 0
  v_mov_b32           \quotient[5], 0
  v_mov_b32           \quotient[6], 0
  v_mov_b32           \quotient[7], 0
  v_mov_b32           dividendSize, (512/32)
  v_mov_b32           divisorSize, (352/32)
  s_mov_b64            \sreg[0:1], exec
.div_divisornormalize_loop:
  v_cmpx_eq_u32       vcc, \divisor[10], 0
  s_cbranch_execz     .div_divisornormalize_loop_end
  limbshl11           \divisor
  v_sub_u32           divisorSize, vcc, divisorSize, 1
  s_branch            .div_divisornormalize_loop
.div_divisornormalize_loop_end:
  s_mov_b64           exec, \sreg[0:1]
  v_ffbh_u32          shiftCount, \divisor[10]
  shl11               \divisor, shiftCount, \reg
  shl16               \dividend, shiftCount, \reg
.div_dividendnormalize_loop:
  v_cmpx_eq_u32       vcc, \dividend[15], 0
  s_cbranch_execz     .div_dividendnormalize_loop_end
  limbshl16           \dividend
  v_sub_u32           dividendSize, vcc, dividendSize, 1
  s_branch            .div_dividendnormalize_loop
.div_dividendnormalize_loop_end:
  s_mov_b64           exec, \sreg[0:1]
  v_sub_u32           \reg[0], vcc, dividendSize, divisorSize
  v_min_u32           cyclesNum, \reg[0], 8
.div_mainloop:
  v_cmpx_gt_u32       vcc, cyclesNum, 0
  s_cbranch_execz     .div_mainloop_end
  #; make division highest 64-bit dividend bits to highest 32-bit divisor bits
      dividendhi = %\dividend[14:15]
  div64to32           dividendhi, \divisor[10], q, \reg, \sreg[2:3]
  v_mov_b32           \reg[0], 0xFFFFFFFF
  v_cmp_eq_u32        vcc, \dividend[15], \divisor[10]
  v_cndmask_b32       q, q, \reg[0], vcc
      dividendhi = %\dividend[4:15]
      carryholder = %\sreg[2:3]
  submul352           dividendhi, \divisor, q, \reg, carryholder, \zero
  v_mov_b32           borrow, \dividend[15]
  limbshl16           \dividend
  s_mov_b64           \sreg[2:3], exec
  v_cmpx_lg_u32       vcc, borrow, 0
  v_add_u32        \dividend[5], vcc, \dividend[5], \divisor[0]
  v_addc_u32       \dividend[6], vcc, \dividend[6], \divisor[1], vcc
  v_addc_u32       \dividend[7], vcc, \dividend[7], \divisor[2], vcc
  v_addc_u32       \dividend[8], vcc, \dividend[8], \divisor[3], vcc
  v_addc_u32       \dividend[9], vcc, \dividend[9], \divisor[4], vcc
  v_addc_u32       \dividend[10], vcc, \dividend[10], \divisor[5], vcc
  v_addc_u32       \dividend[11], vcc, \dividend[11], \divisor[6], vcc
  v_addc_u32       \dividend[12], vcc, \dividend[12], \divisor[7], vcc
  v_addc_u32       \dividend[13], vcc, \dividend[13], \divisor[8], vcc
  v_addc_u32       \dividend[14], vcc, \dividend[14], \divisor[9], vcc
  v_addc_u32       \dividend[15], vcc, \dividend[15], \divisor[10], vcc
  v_sub_u32           q, vcc, q, 1
  v_cmpx_gt_u32       vcc, \dividend[15], \divisor[10]
  v_add_u32        \dividend[5], vcc, \dividend[5], \divisor[0]
  v_addc_u32       \dividend[6], vcc, \dividend[6], \divisor[1], vcc
  v_addc_u32       \dividend[7], vcc, \dividend[7], \divisor[2], vcc
  v_addc_u32       \dividend[8], vcc, \dividend[8], \divisor[3], vcc
  v_addc_u32       \dividend[9], vcc, \dividend[9], \divisor[4], vcc
  v_addc_u32       \dividend[10], vcc, \dividend[10], \divisor[5], vcc
  v_addc_u32       \dividend[11], vcc, \dividend[11], \divisor[6], vcc
  v_addc_u32       \dividend[12], vcc, \dividend[12], \divisor[7], vcc
  v_addc_u32       \dividend[13], vcc, \dividend[13], \divisor[8], vcc
  v_addc_u32       \dividend[14], vcc, \dividend[14], \divisor[9], vcc
  v_addc_u32       \dividend[15], vcc, \dividend[15], \divisor[10], vcc
  v_sub_u32           q, vcc, q, 1
  s_mov_b64           exec, \sreg[2:3]
  limbshl8           \quotient
  v_mov_b32           \quotient[0], q
  v_sub_u32           cyclesNum, vcc, cyclesNum, 1
  s_branch            .div_mainloop
.div_mainloop_end:
  s_mov_b64           exec, \sreg[0:1]
  v_sub_u32           \reg[1], vcc, 320, shiftCount
  v_sub_u32           \reg[0], vcc, 10, divisorSize
  v_lshlrev_b32       \reg[0], 5, \reg[0]
  v_sub_u32           \size, vcc, \reg[1], \reg[0]
.endm

.macro modpow320of2, mod, regs, zero, sregs
     # common
         modpowof2_coeff    = %\regs[0:7]
         modpowof2_bitsize  = %\regs[8]
     # divide time
         modpowof2_dividend = %\regs[9:23]
         modpowof2_divisor  = %\regs[24:33]
         modpowof2_dreg     = %\regs[34:56]
    # modpow time
        modpowof2_e         = %\regs[9:18]
        modpowof2_resultacc = %\regs[19:32]
        modpowof2_result    = %\regs[22:32]
        modpowof2_inv       = %\regs[33:42]
        modpowof2_cache     = %\regs[43:62]
          modpowof2_redcifyout   = %\regs[43:53]
          modpowof2_redcifycache = %\regs[55:62]
          modpowof2_mulcache     = %\regs[53:62]
        modpowof2_invm      = %\regs[63]
        modpowof2_count     = %\regs[64]
        modpowof2_wsReg     = %\regs[65]
        modpowof2_mreg      = %\regs[66:69]
    # scalars
        modpow_exec0        = %\sregs[0:1]
        modpow_exec1        = %\sregs[2:3]
        modpow_exec2        = %\sregs[4:5]

  #; fill dividend & divisor; calculate modpowof2_coeff
  v_mov_b32           modpowof2_dividend[0], 0
  v_mov_b32           modpowof2_dividend[1], 0
  v_mov_b32           modpowof2_dividend[2], 0
  v_mov_b32           modpowof2_dividend[3], 0
  v_mov_b32           modpowof2_dividend[4], 0
  v_mov_b32           modpowof2_dividend[5], 0
  v_mov_b32           modpowof2_dividend[6], 0
  v_mov_b32           modpowof2_dividend[7], 0
  v_mov_b32           modpowof2_dividend[8], 0
  v_mov_b32           modpowof2_dividend[9], 0
  v_mov_b32           modpowof2_dividend[10], 0
  v_mov_b32           modpowof2_dividend[11], 0
  v_mov_b32           modpowof2_dividend[12], 0
  v_mov_b32           modpowof2_dividend[13], 0
  v_mov_b32           modpowof2_dividend[14], 1
  v_mov_b32           modpowof2_divisor[0], \mod[0]
  v_mov_b32           modpowof2_divisor[1], \mod[1]
  v_mov_b32           modpowof2_divisor[2], \mod[2]
  v_mov_b32           modpowof2_divisor[3], \mod[3]
  v_mov_b32           modpowof2_divisor[4], \mod[4]
  v_mov_b32           modpowof2_divisor[5], \mod[5]
  v_mov_b32           modpowof2_divisor[6], \mod[6]
  v_mov_b32           modpowof2_divisor[7], \mod[7]
  v_mov_b32           modpowof2_divisor[8], \mod[8]
  v_mov_b32           modpowof2_divisor[9], \mod[9]
  div480to320         modpowof2_dividend, modpowof2_divisor, modpowof2_coeff, modpowof2_bitsize, modpowof2_dreg, \sregs, \zero

  #; copy normalized mod to e
  v_mov_b32           modpowof2_e[0], modpowof2_divisor[0]
  v_mov_b32           modpowof2_e[1], modpowof2_divisor[1]
  v_mov_b32           modpowof2_e[2], modpowof2_divisor[2]
  v_mov_b32           modpowof2_e[3], modpowof2_divisor[3]
  v_mov_b32           modpowof2_e[4], modpowof2_divisor[4]
  v_mov_b32           modpowof2_e[5], modpowof2_divisor[5]
  v_mov_b32           modpowof2_e[6], modpowof2_divisor[6]
  v_mov_b32           modpowof2_e[7], modpowof2_divisor[7]
  v_mov_b32           modpowof2_e[8], modpowof2_divisor[8]
  v_mov_b32           modpowof2_e[9], modpowof2_divisor[9]

  #; calculate 2 in Montgomery representation
  v_mov_b32           modpowof2_mreg[0], 1
  redcify320ws7       modpowof2_coeff, \mod, modpowof2_mreg[0], modpowof2_redcifycache, modpowof2_result, modpowof2_mreg, \zero

  #; invert first limb
  invert_limb         \mod[0], modpowof2_cache, modpowof2_mreg, modpowof2_invm

  #; prepare main loop
  v_sub_u32           modpowof2_bitsize, vcc, modpowof2_bitsize, 1
  v_mov_b32           modpowof2_wsReg, WindowSize
  shl10               modpowof2_e, 1, modpowof2_mreg
  s_mov_b64           modpow_exec0, exec

.modpowof2.mainloop:
  v_min_u32           modpowof2_count, modpowof2_wsReg, modpowof2_bitsize
  v_cmpx_lg_u32       vcc, modpowof2_count, 0
  s_cbranch_execz     .modpowof2.mainloop.end
  v_sub_u32           modpowof2_bitsize, vcc, modpowof2_bitsize, modpowof2_count
  v_sub_u32           modpowof2_mreg[1], vcc, 32, modpowof2_count
  v_cmp_eq_u32        vcc, modpowof2_bitsize, 0
  v_addc_u32       modpowof2_mreg[2], vcc, 0, 0, vcc
  v_lshrrev_b32       modpowof2_mreg[3], modpowof2_mreg[1], modpowof2_e[9]
  v_sub_u32           modpowof2_mreg[3], vcc, modpowof2_mreg[3], modpowof2_mreg[2]

  #; Montgomery square
  s_mov_b64           modpow_exec1, exec

.modpowof2.squareloop:
  v_cmpx_lg_u32       vcc, modpowof2_count, 0
  s_cbranch_execz     .modpowof2.squareloop_end
  v_sub_u32           modpowof2_count, vcc, modpowof2_count, 1
  monsqr320           modpowof2_resultacc, \mod, modpowof2_inv, modpowof2_invm, modpowof2_cache, \zero, modpowof2_mreg[0], modpow_exec2
  s_branch            .modpowof2.squareloop

.modpowof2.squareloop_end:
  s_mov_b64           exec, modpow_exec1
  redcify320ws7       modpowof2_coeff, \mod, modpowof2_mreg[3], modpowof2_redcifycache, modpowof2_redcifyout, modpowof2_mreg, \zero
  monmul320           modpowof2_result, modpowof2_redcifyout, \mod, modpowof2_inv, modpowof2_invm, modpowof2_mulcache, \zero, modpowof2_mreg[0], modpow_exec1
  shl10               modpowof2_e, WindowSize, modpowof2_mreg
  s_branch            .modpowof2.mainloop
.modpowof2.mainloop.end:
  s_mov_b64           exec, modpow_exec0
  redchalf320         modpowof2_result, \mod, modpowof2_inv, modpowof2_invm, modpowof2_cache, \zero, modpowof2_mreg[0]
  v_mov_b32           \mod[0], modpowof2_result[0]
  v_mov_b32           \mod[1], modpowof2_result[1]
  v_mov_b32           \mod[2], modpowof2_result[2]
  v_mov_b32           \mod[3], modpowof2_result[3]
  v_mov_b32           \mod[4], modpowof2_result[4]
  v_mov_b32           \mod[5], modpowof2_result[5]
  v_mov_b32           \mod[6], modpowof2_result[6]
  v_mov_b32           \mod[7], modpowof2_result[7]
  v_mov_b32           \mod[8], modpowof2_result[8]
  v_mov_b32           \mod[9], modpowof2_result[9]
.endm

.macro modpow352of2, mod, regs, zero, sregs
     # common
         modpowof2_coeff    = %\regs[0:7]
         modpowof2_bitsize  = %\regs[8]
     # divide time
         modpowof2_dividend = %\regs[9:24]
         modpowof2_divisor  = %\regs[25:35]
         modpowof2_dreg     = %\regs[36:58]
    # modpow time
        modpowof2_e         = %\regs[9:19]
        modpowof2_resultacc = %\regs[20:34]
        modpowof2_result    = %\regs[23:34]
        modpowof2_inv       = %\regs[35:45]
        modpowof2_cache     = %\regs[46:67]
          modpowof2_redcifyout   = %\regs[46:57]
          modpowof2_redcifycache = %\regs[60:67]
          modpowof2_mulcache     = %\regs[57:67]
        modpowof2_invm      = %\regs[68]
        modpowof2_count     = %\regs[69]
        modpowof2_wsReg     = %\regs[70]
        modpowof2_mreg      = %\regs[71:74]
    # scalars
        modpow_exec0        = %\sregs[0:1]
        modpow_exec1        = %\sregs[2:3]
        modpow_exec2        = %\sregs[4:5]

  #; fill dividend & divisor; calculate modpowof2_coeff
  v_mov_b32           modpowof2_dividend[0], 0
  v_mov_b32           modpowof2_dividend[1], 0
  v_mov_b32           modpowof2_dividend[2], 0
  v_mov_b32           modpowof2_dividend[3], 0
  v_mov_b32           modpowof2_dividend[4], 0
  v_mov_b32           modpowof2_dividend[5], 0
  v_mov_b32           modpowof2_dividend[6], 0
  v_mov_b32           modpowof2_dividend[7], 0
  v_mov_b32           modpowof2_dividend[8], 0
  v_mov_b32           modpowof2_dividend[9], 0
  v_mov_b32           modpowof2_dividend[10], 0
  v_mov_b32           modpowof2_dividend[11], 0
  v_mov_b32           modpowof2_dividend[12], 0
  v_mov_b32           modpowof2_dividend[13], 0
  v_mov_b32           modpowof2_dividend[14], 0
  v_mov_b32           modpowof2_dividend[15], 1
  v_mov_b32           modpowof2_divisor[0], \mod[0]
  v_mov_b32           modpowof2_divisor[1], \mod[1]
  v_mov_b32           modpowof2_divisor[2], \mod[2]
  v_mov_b32           modpowof2_divisor[3], \mod[3]
  v_mov_b32           modpowof2_divisor[4], \mod[4]
  v_mov_b32           modpowof2_divisor[5], \mod[5]
  v_mov_b32           modpowof2_divisor[6], \mod[6]
  v_mov_b32           modpowof2_divisor[7], \mod[7]
  v_mov_b32           modpowof2_divisor[8], \mod[8]
  v_mov_b32           modpowof2_divisor[9], \mod[9]
  v_mov_b32           modpowof2_divisor[10], \mod[10]
  div512to352         modpowof2_dividend, modpowof2_divisor, modpowof2_coeff, modpowof2_bitsize, modpowof2_dreg, \sregs, \zero

  #; copy normalized mod to e
  v_mov_b32           modpowof2_e[0], modpowof2_divisor[0]
  v_mov_b32           modpowof2_e[1], modpowof2_divisor[1]
  v_mov_b32           modpowof2_e[2], modpowof2_divisor[2]
  v_mov_b32           modpowof2_e[3], modpowof2_divisor[3]
  v_mov_b32           modpowof2_e[4], modpowof2_divisor[4]
  v_mov_b32           modpowof2_e[5], modpowof2_divisor[5]
  v_mov_b32           modpowof2_e[6], modpowof2_divisor[6]
  v_mov_b32           modpowof2_e[7], modpowof2_divisor[7]
  v_mov_b32           modpowof2_e[8], modpowof2_divisor[8]
  v_mov_b32           modpowof2_e[9], modpowof2_divisor[9]
  v_mov_b32           modpowof2_e[10], modpowof2_divisor[10]

  #; calculate 2 in Montgomery representation
  v_mov_b32           modpowof2_mreg[0], 1
  redcify352ws7       modpowof2_coeff, \mod, modpowof2_mreg[0], modpowof2_redcifycache, modpowof2_result, modpowof2_mreg, \zero

  #; invert first limb
  invert_limb         \mod[0], modpowof2_cache, modpowof2_mreg, modpowof2_invm

  #; prepare main loop
  v_sub_u32           modpowof2_bitsize, vcc, modpowof2_bitsize, 1
  v_mov_b32           modpowof2_wsReg, WindowSize
  shl11               modpowof2_e, 1, modpowof2_mreg
  s_mov_b64           modpow_exec0, exec

.modpowof2.mainloop:
  v_min_u32           modpowof2_count, modpowof2_wsReg, modpowof2_bitsize
  v_cmpx_lg_u32       vcc, modpowof2_count, 0
  s_cbranch_execz     .modpowof2.mainloop.end
  v_sub_u32           modpowof2_bitsize, vcc, modpowof2_bitsize, modpowof2_count
  v_sub_u32           modpowof2_mreg[1], vcc, 32, modpowof2_count
  v_cmp_eq_u32        vcc, modpowof2_bitsize, 0
  v_addc_u32       modpowof2_mreg[2], vcc, 0, 0, vcc
  v_lshrrev_b32       modpowof2_mreg[3], modpowof2_mreg[1], modpowof2_e[10]
  v_sub_u32           modpowof2_mreg[3], vcc, modpowof2_mreg[3], modpowof2_mreg[2]

  #; Montgomery square
  s_mov_b64           modpow_exec1, exec

.modpowof2.squareloop:
  v_cmpx_lg_u32       vcc, modpowof2_count, 0
  s_cbranch_execz     .modpowof2.squareloop_end
  v_sub_u32           modpowof2_count, vcc, modpowof2_count, 1
  monsqr352           modpowof2_resultacc, \mod, modpowof2_inv, modpowof2_invm, modpowof2_cache, \zero, modpowof2_mreg[0], modpow_exec2
  s_branch            .modpowof2.squareloop

.modpowof2.squareloop_end:
  s_mov_b64           exec, modpow_exec1
  redcify352ws7       modpowof2_coeff, \mod, modpowof2_mreg[3], modpowof2_redcifycache, modpowof2_redcifyout, modpowof2_mreg, \zero
  monmul352           modpowof2_result, modpowof2_redcifyout, \mod, modpowof2_inv, modpowof2_invm, modpowof2_mulcache, \zero, modpowof2_mreg[0], modpow_exec1
  shl11               modpowof2_e, WindowSize, modpowof2_mreg
  s_branch            .modpowof2.mainloop
.modpowof2.mainloop.end:
  s_mov_b64           exec, modpow_exec0
  redchalf352         modpowof2_result, \mod, modpowof2_inv, modpowof2_invm, modpowof2_cache, \zero, modpowof2_mreg[0]
  v_mov_b32           \mod[0], modpowof2_result[0]
  v_mov_b32           \mod[1], modpowof2_result[1]
  v_mov_b32           \mod[2], modpowof2_result[2]
  v_mov_b32           \mod[3], modpowof2_result[3]
  v_mov_b32           \mod[4], modpowof2_result[4]
  v_mov_b32           \mod[5], modpowof2_result[5]
  v_mov_b32           \mod[6], modpowof2_result[6]
  v_mov_b32           \mod[7], modpowof2_result[7]
  v_mov_b32           \mod[8], modpowof2_result[8]
  v_mov_b32           \mod[9], modpowof2_result[9]
  v_mov_b32           \mod[10], modpowof2_result[10]
.endm

