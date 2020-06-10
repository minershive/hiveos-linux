.include "gcn_common.inc"
.ifarch GCN1.4
.include "gcn14_procs.inc"
.else
.include "gcn11_procs.inc"
.endif

.include "gcn_config.inc"

.globaldata     # const data

binvert_limb_table:
    .int 0x01, 0xAB, 0xCD, 0xB7, 0x39, 0xA3, 0xC5, 0xEF
    .int 0xF1, 0x1B, 0x3D, 0xA7, 0x29, 0x13, 0x35, 0xDF
    .int 0xE1, 0x8B, 0xAD, 0x97, 0x19, 0x83, 0xA5, 0xCF
    .int 0xD1, 0xFB, 0x1D, 0x87, 0x09, 0xF3, 0x15, 0xBF
    .int 0xC1, 0x6B, 0x8D, 0x77, 0xF9, 0x63, 0x85, 0xAF
    .int 0xB1, 0xDB, 0xFD, 0x67, 0xE9, 0xD3, 0xF5, 0x9F
    .int 0xA1, 0x4B, 0x6D, 0x57, 0xD9, 0x43, 0x65, 0x8F
    .int 0x91, 0xBB, 0xDD, 0x47, 0xC9, 0xB3, 0xD5, 0x7F
    .int 0x81, 0x2B, 0x4D, 0x37, 0xB9, 0x23, 0x45, 0x6F
    .int 0x71, 0x9B, 0xBD, 0x27, 0xA9, 0x93, 0xB5, 0x5F
    .int 0x61, 0x0B, 0x2D, 0x17, 0x99, 0x03, 0x25, 0x4F
    .int 0x51, 0x7B, 0x9D, 0x07, 0x89, 0x73, 0x95, 0x3F
    .int 0x41, 0xEB, 0x0D, 0xF7, 0x79, 0xE3, 0x05, 0x2F
    .int 0x31, 0x5B, 0x7D, 0xE7, 0x69, 0x53, 0x75, 0x1F
    .int 0x21, 0xCB, 0xED, 0xD7, 0x59, 0xC3, 0xE5, 0x0F
    .int 0x11, 0x3B, 0x5D, 0xC7, 0x49, 0x33, 0x55, 0xFF
    
# config
.include "gcn_config_kernel.inc"

.scope multiplyBenchmark320to96u
.kernel multiplyBenchmark320to96u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 10
    Op1MemSize = 10
    Op2Size = 3
    Op2MemSize = 4
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:21]
    op2 = %v[22:24]
    result = %v[25:37]
    zero = %v[38:39]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load10dw            op1, m1, vtmp[0], vaddr
    load3dw             op2, m2, vtmp[1], vaddr

    # Multiplication
    mul320to96          op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store13dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope multiplyBenchmark320to128u
.kernel multiplyBenchmark320to128u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 10
    Op1MemSize = 10
    Op2Size = 4
    Op2MemSize = 4
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:21]
    op2 = %v[22:25]
    result = %v[26:39]
    zero = %v[40:41]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_lt_u32        vcc, i, elementsNum
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load10dw            op1, m1, vtmp[0], vaddr
    load4dw             op2, m2, vtmp[1], vaddr

    # Multiplication
    mul320to128         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store14dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope multiplyBenchmark320to192u
.kernel multiplyBenchmark320to192u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 10
    Op1MemSize = 10
    Op2Size = 6
    Op2MemSize = 6
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp = %v[10:11]

    op1 = %v[12:21]
    op2 = %v[22:27]
    result = %v[28:43]
    zero = %v[44:45]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load10dw            op1, m1, vtmp[0], vaddr
    load6dw             op2, m2, vtmp[1], vaddr

    # Multiplication
    mul320to192         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store16dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope multiplyBenchmark352to96u
.kernel multiplyBenchmark352to96u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 11
    Op1MemSize = 12
    Op2Size = 3
    Op2MemSize = 4
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp = %v[10:11]

    op1 = %v[12:22]
    op2 = %v[23:25]
    result = %v[26:39]
    zero = %v[40:41]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load11dw            op1, m1, vtmp[0], vaddr
    load3dw             op2, m2, vtmp[1], vaddr

    # Multiplication
    mul352to96          op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store14dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope multiplyBenchmark352to128u
.kernel multiplyBenchmark352to128u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 11
    Op1MemSize = 12
    Op2Size = 4
    Op2MemSize = 4
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp = %v[10:11]

    op1 = %v[12:22]
    op2 = %v[23:26]
    result = %v[27:41]
    zero = %v[42:43]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load11dw            op1, m1, vtmp[0], vaddr
    load4dw             op2, m2, vtmp[1], vaddr

    # Multiplication
    mul352to128         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store15dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope multiplyBenchmark352to192u
.kernel multiplyBenchmark352to192u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 11
    Op1MemSize = 12
    Op2Size = 6
    Op2MemSize = 6
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp = %v[10:11]

    op1 = %v[12:22]
    op2 = %v[23:28]
    result = %v[29:45]
    zero = %v[46:47]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load11dw            op1, m1, vtmp[0], vaddr
    load6dw             op2, m2, vtmp[1], vaddr

    # Multiplication
    mul352to192         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store17dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends


.scope squareBenchmark320u
.kernel squareBenchmark320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,        uint*, global, const    # __global uint32_t *m1
    .arg out,        uint*, global           # __global uint32_t *out
    .arg elementsNum,    uint            # unsigned elementsNum
    
.text
    # Constants
    OpSize = 10
    OpMemSize = 10
    ResultMemSize = 20

    # Global scope binding
    m1 = %s[0:1]
    out = %s[2:3]
    m1_and_out = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    
    localSize = %s12
    execStore = %s[14:15]
    
    i = %v2
    stmp0 = %s16
    addr0 = %v[3:4]
    addr1 = %v[5:6]
    addr2 = %v[7:8]
    vaddr = %v[3:8]
    vtmp  = %v[10:11]
    j = %v9

    op = %v[12:21]
    result = %v[22:41]
    zero = %v[42:43]
    cache = %v[44:64]

    s_load_dwordx4      m1_and_out, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize    
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load10dw            op, m1, vtmp[0], vaddr

    # Squaring
    sqr320              op, result, cache, zero, vtmp

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store20dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends
   
   
.scope squareBenchmark352u
.kernel squareBenchmark352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    OpSize = 11 
    OpMemSize = 12
    ResultMemSize = (2*OpMemSize)

    # Global scope binding
    m1 = %s[0:1]
    out = %s[2:3]
    m1_and_out = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    
    localSize = %s12
    execStore = %s[14:15]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp = %v[10:11]

    op = %v[12:22]
    result = %v[23:44]
    zero = %v[45:46]
    cache = %v[47:68]

    s_load_dwordx4      m1_and_out, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize    
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load11dw            op, m1, vtmp[0], vaddr

    # Squaring
    sqr352              op, result, cache, zero, vtmp

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store22dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends
   
   
.scope squareBenchmark640u
.kernel squareBenchmark640u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    OpSize = 20
    OpMemSize = 20
    ResultMemSize = (2*OpMemSize)

    # Global scope binding
    m1 = %s[0:1]
    out = %s[2:3]
    m1_and_out = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    
    localSize = %s12
    execStore = %s[14:15]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp = %v[10:11]

    op = %v[12:31]
    result = %v[32:71]
    zero = %v[72:73]
    cache = %v[74:113]

    s_load_dwordx4      m1_and_out, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize    
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mov_b32           vtmp[0], 4*OpMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    load20dw            op, m1, vtmp[0], vaddr

    # Squaring
    sqr640              op, result, cache, zero, vtmp

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store40dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends   

.scope multiplyBenchmark320to320u
.kernel multiplyBenchmark320to320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 10
    Op1MemSize = 10
    Op2Size = 10
    Op2MemSize = 10
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:21]
    op2 = %v[22:31]
    result = %v[32:51]
    zero = %v[52:53]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load10dw            op1, m1, vtmp[0], vaddr
    load10dw            op2, m2, vtmp[1], vaddr

    # Multiplication
    mul320to320         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store20dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends
   
   
.scope multiplyBenchmark352to352u
.kernel multiplyBenchmark352to352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,    uint            # unsigned elementsNum
.text
    # Constants
    Op1Size = 11
    Op1MemSize = 12
    Op2Size = 11
    Op2MemSize = 12
    ResultMemSize = (Op1MemSize + Op2MemSize)
    
    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8] 
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:22]
    op2 = %v[23:33]
    result = %v[34:55]
    zero = %v[56:57]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load11dw            op1, m1, vtmp[0], vaddr
    load11dw            op2, m2, vtmp[1], vaddr

    # Multiplication
    mul352to352         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store22dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends   
   
   
.scope multiplyBenchmark640to640u
.kernel multiplyBenchmark640to640u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,    uint            # unsigned elementsNum
.text
    # Constants
    Op1Size = 20
    Op1MemSize = 20
    Op2Size = 20
    Op2MemSize = 20
    ResultMemSize = (Op1MemSize + Op2MemSize)
    
    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8] 
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:31]
    op2 = %v[32:51]
    result = %v[52:91]
    zero = %v[92:93]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mov_b32           vtmp[0], 4*Op1MemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    v_mov_b32           vtmp[1], 4*Op2MemSize    
    v_mul_lo_u32        vtmp[1], i, vtmp[1]
    load20dw            op1, m1, vtmp[0], vaddr
    load20dw            op2, m2, vtmp[1], vaddr

    # Multiplication
    mul640to640         op1, op2, result, zero 

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store40dw           result, out, vtmp[0], vaddr

    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends      
   
.scope squareBenchmark320p
.kernel squareBenchmark320p
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,        uint*, global, const    # __global uint32_t *m1
    .arg out,        uint*, global           # __global uint32_t *out
    .arg elementsNum,    uint            # unsigned elementsNum
    
.text
    # Constants
    OpSize = 10
    OpMemSize = 10
    ResultMemSize = (2*OpMemSize)

    # Global scope binding
    m1 = %s[0:1]
    out = %s[2:3]
    m1_and_out = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    
    localSize = %s12
    execStore = %s[14:15]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp  = %v[10:11]
    j = %v9

    op = %v[12:21]
    result = %v[22:41]
    zero = %v[42:43]
    cache = %v[44:63]


    s_load_dwordx4      m1_and_out, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize    
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0  
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end

    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load10dw            op, m1, vtmp[0], vaddr  

    # Init counter
    v_mov_b32           j, 0
    
.mulloop:
.align 16
    v_cmp_gt_u32        vcc, MulOpsNum, j
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .mulend    
    
    # Multiplication 320x320
    sqr320              op, result, cache, zero, vtmp
    v_mov_b32           op[0], result[OpSize+0]
    v_mov_b32           op[1], result[OpSize+1]
    v_mov_b32           op[2], result[OpSize+2]
    v_mov_b32           op[3], result[OpSize+3]
    v_mov_b32           op[4], result[OpSize+4]
    v_mov_b32           op[5], result[OpSize+5]
    v_mov_b32           op[6], result[OpSize+6]
    v_mov_b32           op[7], result[OpSize+7]
    v_mov_b32           op[8], result[OpSize+8]
    v_mov_b32           op[9], result[OpSize+9]    

    vadd32u             j, vcc, j, 1
    s_branch            .mulloop
    
.mulend:    
    s_mov_b64           exec, execStore

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store20dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends
   
   
.scope squareBenchmark640p
.kernel squareBenchmark640p
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,        uint*, global, const    # __global uint32_t *m1
    .arg out,        uint*, global           # __global uint32_t *out
    .arg elementsNum,    uint            # unsigned elementsNum
    
.text
    # Constants
    OpSize = 20
    OpMemSize = 20
    ResultMemSize = (2*OpMemSize)

    # Global scope binding
    m1 = %s[0:1]
    out = %s[2:3]
    m1_and_out = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    
    localSize = %s12
    execStore = %s[14:15]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp  = %v[10:11]
    j = %v9

    op = %v[12:31]
    result = %v[32:71]
    zero = %v[72:73]
    cache = %v[74:113]


    s_load_dwordx4      m1_and_out, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize    
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0  
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end

    v_mov_b32           vtmp[0], 4*OpMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    load20dw            op, m1, vtmp[0], vaddr  

    # Init counter
    v_mov_b32           j, 0
    
.mulloop:
.align 16
    v_cmp_gt_u32        vcc, MulOpsNum, j
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .mulend    
    
    # Multiplication 320x320
    sqr640              op, result, cache, zero, vtmp
    v_mov_b32           op[0], result[OpSize+0]
    v_mov_b32           op[1], result[OpSize+1]
    v_mov_b32           op[2], result[OpSize+2]
    v_mov_b32           op[3], result[OpSize+3]
    v_mov_b32           op[4], result[OpSize+4]
    v_mov_b32           op[5], result[OpSize+5]
    v_mov_b32           op[6], result[OpSize+6]
    v_mov_b32           op[7], result[OpSize+7]
    v_mov_b32           op[8], result[OpSize+8]
    v_mov_b32           op[9], result[OpSize+9]
    v_mov_b32           op[10], result[OpSize+10]
    v_mov_b32           op[11], result[OpSize+11]
    v_mov_b32           op[12], result[OpSize+12]
    v_mov_b32           op[13], result[OpSize+13]
    v_mov_b32           op[14], result[OpSize+14]
    v_mov_b32           op[15], result[OpSize+15]
    v_mov_b32           op[16], result[OpSize+16]
    v_mov_b32           op[17], result[OpSize+17]
    v_mov_b32           op[18], result[OpSize+18]
    v_mov_b32           op[19], result[OpSize+19]     

    vadd32u             j, vcc, j, 1
    s_branch            .mulloop
    
.mulend:    
    s_mov_b64           exec, execStore

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store40dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends
   
   
.scope squareBenchmark352p
.kernel squareBenchmark352p
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,        uint*, global, const    # __global uint32_t *m1
    .arg out,        uint*, global           # __global uint32_t *out
    .arg elementsNum,    uint            # unsigned elementsNum
    
.text
    # Constants
    OpSize = 11
    OpMemSize = 12
    ResultMemSize = (2*OpMemSize)

    # Global scope binding
    m1 = %s[0:1]
    out = %s[2:3]
    m1_and_out = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    
    localSize = %s12
    execStore = %s[14:15]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    vtmp  = %v[10:11]
    j = %v9

    op = %v[12:22]
    result = %v[23:44]
    zero = %v[45:46]
    cache = %v[47:68]


    s_load_dwordx4      m1_and_out, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize    
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0  
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end

    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load11dw            op, m1, vtmp[0], vaddr  

    # Init counter
    v_mov_b32           j, 0
    
.mulloop:
.align 16
    v_cmp_gt_u32        vcc, MulOpsNum, j
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .mulend    
    
    # Multiplication 320x320
    sqr352              op, result, cache, zero, vtmp
    v_mov_b32           op[0], result[OpSize+0]
    v_mov_b32           op[1], result[OpSize+1]
    v_mov_b32           op[2], result[OpSize+2]
    v_mov_b32           op[3], result[OpSize+3]
    v_mov_b32           op[4], result[OpSize+4]
    v_mov_b32           op[5], result[OpSize+5]
    v_mov_b32           op[6], result[OpSize+6]
    v_mov_b32           op[7], result[OpSize+7]
    v_mov_b32           op[8], result[OpSize+8]
    v_mov_b32           op[9], result[OpSize+9]    
    v_mov_b32           op[10], result[OpSize+10]       

    vadd32u             j, vcc, j, 1
    s_branch            .mulloop
    
.mulend:    
    s_mov_b64           exec, execStore

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store22dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends



.scope multiplyBenchmark320to320p
.kernel multiplyBenchmark320to320p
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 10
    Op1MemSize = 10
    Op2Size = 10
    Op2MemSize = 10
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:21]
    op2 = %v[22:31]
    result = %v[32:51]
    zero = %v[52:53]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load10dw            op1, m1, vtmp[0], vaddr
    load10dw            op2, m2, vtmp[1], vaddr
    
    # Init counter
    v_mov_b32           j, 0
    
.mulloop:
.align 16
    v_cmp_gt_u32        vcc, MulOpsNum, j
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .mulend    
    
    # Multiplication 320x320
    mul320to320         op1, op2, result, zero
    v_mov_b32           op1[0], result[Op2Size+0]
    v_mov_b32           op1[1], result[Op2Size+1]
    v_mov_b32           op1[2], result[Op2Size+2]
    v_mov_b32           op1[3], result[Op2Size+3]
    v_mov_b32           op1[4], result[Op2Size+4]
    v_mov_b32           op1[5], result[Op2Size+5]
    v_mov_b32           op1[6], result[Op2Size+6]
    v_mov_b32           op1[7], result[Op2Size+7]
    v_mov_b32           op1[8], result[Op2Size+8]
    v_mov_b32           op1[9], result[Op2Size+9]

    vadd32u             j, vcc, j, 1
    s_branch            .mulloop
    
.mulend:    
    s_mov_b64           exec, execStore

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]    
    store20dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends


.scope multiplyBenchmark352to352p
.kernel multiplyBenchmark352to352p
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 11
    Op1MemSize = 12
    Op2Size = 11
    Op2MemSize = 12
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:22]
    op2 = %v[23:34]
    result = %v[35:56]
    zero = %v[57:58]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*Op1MemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op2MemSize
    load11dw            op1, m1, vtmp[0], vaddr
    load11dw            op2, m2, vtmp[1], vaddr
    
    # Init counter
    v_mov_b32           j, 0
    
.mulloop:
.align 16
    v_cmp_gt_u32        vcc, MulOpsNum, j
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .mulend    
    
    # Multiplication
    mul352to352         op1, op2, result, zero
    v_mov_b32           op1[0], result[Op2Size+0]
    v_mov_b32           op1[1], result[Op2Size+1]
    v_mov_b32           op1[2], result[Op2Size+2]
    v_mov_b32           op1[3], result[Op2Size+3]
    v_mov_b32           op1[4], result[Op2Size+4]
    v_mov_b32           op1[5], result[Op2Size+5]
    v_mov_b32           op1[6], result[Op2Size+6]
    v_mov_b32           op1[7], result[Op2Size+7]
    v_mov_b32           op1[8], result[Op2Size+8]
    v_mov_b32           op1[9], result[Op2Size+9]
    v_mov_b32           op1[10], result[Op2Size+10]

    vadd32u             j, vcc, j, 1
    s_branch            .mulloop
    
.mulend:    
    s_mov_b64           exec, execStore

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]    
    store22dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope multiplyBenchmark640to640p
.kernel multiplyBenchmark640to640p
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const    # __global uint32_t *m1
    .arg m2,            uint*, global, const    # __global uint32_t *m2
    .arg out,           uint*, global           # __global uint32_t *out
    .arg elementsNum,   uint                # unsigned elementsNum
.text
    # Constants
    Op1Size = 20
    Op1MemSize = 20
    Op2Size = 20
    Op2MemSize = 20
    ResultMemSize = (Op1MemSize + Op2MemSize)

    # Global scope binding
    m1 = %s[0:1]
    m2 = %s[2:3]
    m1_and_m2 = %s[0:3]
    elementsNum = %s9
    globalSize = %s11
    out = %s[12:13]
    localSize = %s14
    execStore = %s[16:17]
    
    i = %v2
    stmp0 = %s16
    vaddr = %v[3:8]
    j = %v9
    vtmp = %v[10:11]

    op1 = %v[12:31]
    op2 = %v[32:51]
    result = %v[52:91]
    zero = %v[92:93]

    s_load_dwordx4      m1_and_m2, ArgumentsPtr, (FirstArgumentOffset + 0)*PointerSize  
    s_load_dwordx2      out, ArgumentsPtr, (FirstArgumentOffset + 2)*PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, (FirstArgumentOffset + 3)*PointerSize
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mov_b32           vtmp[0], 4*Op1MemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    v_mov_b32           vtmp[1], 4*Op2MemSize
    v_mul_lo_u32        vtmp[1], i, vtmp[1]
    load20dw            op1, m1, vtmp[0], vaddr
    load20dw            op2, m2, vtmp[1], vaddr
    
    # Init counter
    v_mov_b32           j, 0
    
.mulloop:
.align 16
    v_cmp_gt_u32        vcc, MulOpsNum, j
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .mulend    
    
    # Multiplication
    mul640to640         op1, op2, result, zero
    v_mov_b32           op1[0], result[Op2Size+0]
    v_mov_b32           op1[1], result[Op2Size+1]
    v_mov_b32           op1[2], result[Op2Size+2]
    v_mov_b32           op1[3], result[Op2Size+3]
    v_mov_b32           op1[4], result[Op2Size+4]
    v_mov_b32           op1[5], result[Op2Size+5]
    v_mov_b32           op1[6], result[Op2Size+6]
    v_mov_b32           op1[7], result[Op2Size+7]
    v_mov_b32           op1[8], result[Op2Size+8]
    v_mov_b32           op1[9], result[Op2Size+9]
    v_mov_b32           op1[10], result[Op2Size+10]
    v_mov_b32           op1[11], result[Op2Size+11]
    v_mov_b32           op1[12], result[Op2Size+12]
    v_mov_b32           op1[13], result[Op2Size+13]
    v_mov_b32           op1[14], result[Op2Size+14]
    v_mov_b32           op1[15], result[Op2Size+15]
    v_mov_b32           op1[16], result[Op2Size+16]
    v_mov_b32           op1[17], result[Op2Size+17]
    v_mov_b32           op1[18], result[Op2Size+18]
    v_mov_b32           op1[19], result[Op2Size+19]

    vadd32u             j, vcc, j, 1
    s_branch            .mulloop
    
.mulend:    
    s_mov_b64           exec, execStore

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]    
    store40dw           result, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope monsqrBenchmark320u
.kernel monsqrBenchmark320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const        # __global uint32_t *m1
    .arg mod,           uint*, global, const        # __global uint32_t *m2
    .arg out,           uint*, global               # __global uint32_t *out
    .arg elementsNum,   uint                        # unsigned elementsNum
     
.text
    # Constants
    OpSize = 10
    OpMemSize = 10
    ResultMemSize = 10

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    m1 = %s[12:13]
    mod = %s[14:15]    
    out = %s[16:17]    
    stmp = %s[18:19]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9
    vtmp  = %v[10:11]

    vm1ctx = %v[12:24]
    vm1 = %v[15:24]
    vmod = %v[25:34]
    zero = %v[35:36]
    cache = %v[37:56]
    inv = %v[57:66]
    invm = %v67

    s_load_dwordx2      m1, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      out, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    v_mul_lo_u32        vtmp[1], i, 4*OpMemSize
    load10dw            vm1, m1, vtmp[0], vaddr
    load10dw            vmod, mod, vtmp[1], vaddr
    
    # Calculate invm
    invert_limb         vmod[0], vaddr, vtmp, invm
    
    # Montromery squaring
    monsqr320           vm1ctx, vmod, inv, invm, cache, zero, vtmp[0], stmp
    
    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store10dw           vm1, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope monsqrBenchmark352u
.kernel monsqrBenchmark352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const        # __global uint32_t *m1
    .arg mod,           uint*, global, const        # __global uint32_t *m2
    .arg out,           uint*, global               # __global uint32_t *out
    .arg elementsNum,   uint                        # unsigned elementsNum
     
.text
    # Constants
    OpSize = 11
    OpMemSize = 12
    ResultMemSize = 12

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    m1 = %s[12:13]
    mod = %s[14:15]    
    out = %s[16:17]    
    stmp = %s[18:19]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9
    vtmp  = %v[10:11]

    vm1ctx = %v[12:25]
    vm1 = %v[15:25]
    vmod = %v[26:36]
    zero = %v[37:38]
    cache = %v[39:60]
    inv = %v[61:71]
    invm = %v72

    s_load_dwordx2      m1, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      out, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load11dw            vm1, m1, vtmp[0], vaddr
    load11dw            vmod, mod, vtmp[0], vaddr
    
    # Calculate invm
    invert_limb         vmod[0], vaddr, vtmp, invm    
    
    # Montromery squaring
    monsqr352           vm1ctx, vmod, inv, invm, cache, zero, vtmp[0], stmp

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store11dw           vm1, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope monmulBenchmark320u
.kernel monmulBenchmark320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const        # __global uint32_t *m1
    .arg m2,            uint*, global, const        # __global uint32_t *m2
    .arg mod,           uint*, global, const        # __global uint32_t *mod
    .arg out,           uint*, global               # __global uint32_t *out
    .arg elementsNum,   uint                        # unsigned elementsNum
     
.text
    # Constants
    OpSize = 10
    OpMemSize = 10
    ResultMemSize = 10

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    m1 = %s[12:13]
    m2 = %s[14:15]
    mod = %s[16:17]
    out = %s[18:19]    
    stmp = %s[20:21]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9
    vtmp  = %v[10:11]

    vm1ctx = %v[12:24]
    vm1 = %v[15:24]
    vm2 = %v[25:34]
    vmod = %v[35:44]
    zero = %v[45:46]
    cache = %v[47:56]
    inv = %v[57:66]
    invm = %v67

    s_load_dwordx2      m1, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      m2, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      mod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dwordx2      out, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*4
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load10dw            vm1, m1, vtmp[0], vaddr
    load10dw            vm2, m2, vtmp[0], vaddr
    load10dw            vmod, mod, vtmp[0], vaddr
    
    # Calculate invm
    invert_limb         vmod[0], vaddr, vtmp, invm    
    
    # Montromery squaring
    monmul320           vm1, vm2, vmod, inv, invm, cache, zero, vtmp[0], stmp

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store10dw           vm1, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope monmulBenchmark352u
.kernel monmulBenchmark352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const        # __global uint32_t *m1
    .arg m2,            uint*, global, const        # __global uint32_t *m2
    .arg mod,           uint*, global, const        # __global uint32_t *mod
    .arg out,           uint*, global               # __global uint32_t *out
    .arg elementsNum,   uint                        # unsigned elementsNum
     
.text
    # Constants
    OpSize = 11
    OpMemSize = 12
    ResultMemSize = 12

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    m1 = %s[12:13]
    m2 = %s[14:15]
    mod = %s[16:17]
    out = %s[18:19]    
    stmp = %s[20:21]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9
    vtmp  = %v[10:11]

    vm1ctx = %v[12:25]
    vm1 = %v[15:25]
    vm2 = %v[26:36]
    vmod = %v[37:47]
    zero = %v[48:49]
    cache = %v[50:60]
    inv = %v[61:71]
    invm = %v72

    s_load_dwordx2      m1, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      m2, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      mod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dwordx2      out, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*4
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    load11dw            vm1, m1, vtmp[0], vaddr
    load11dw            vm2, m2, vtmp[0], vaddr
    load11dw            vmod, mod, vtmp[0], vaddr
    
    # Calculate invm
    invert_limb         vmod[0], vaddr, vtmp, invm    
    
    # Montromery squaring
    monmul352           vm1, vm2, vmod, inv, invm, cache, zero, vtmp[0], stmp

    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store11dw           vm1, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends

.scope redchalfBenchmark320u
.kernel redchalfBenchmark320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const        # __global uint32_t *m1
    .arg mod,           uint*, global, const        # __global uint32_t *mod
    .arg out,           uint*, global               # __global uint32_t *out
    .arg elementsNum,   uint                        # unsigned elementsNum
     
.text
    # Constants
    OpSize = 10
    OpMemSize = 10
    ResultMemSize = 10

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    m1 = %s[12:13]
    mod = %s[14:15]    
    out = %s[16:17]    
    stmp0 = %s18
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9
    vtmp  = %v[10:11]

    vm1ctx = %v[12:24]
    vm1 = %v[15:24]
    vmod = %v[25:34]
    zero = %v[35:36]
    cache = %v[37:46]
    inv = %v[47:56]
    invm = %v57

    s_load_dwordx2      m1, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      out, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    v_mul_lo_u32        vtmp[1], i, 4*OpMemSize
    load10dw            vm1, m1, vtmp[0], vaddr
    load10dw            vmod, mod, vtmp[1], vaddr
    
    # Calculate invm
    invert_limb         vmod[0], vaddr, vtmp, invm
    
    # Montromery squaring
    redchalf320         vm1, vmod, inv, invm, cache, zero, vtmp[0]
    
    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store10dw           vm1, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends


.scope redchalfBenchmark352u
.kernel redchalfBenchmark352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg m1,            uint*, global, const        # __global uint32_t *m1
    .arg mod,           uint*, global, const        # __global uint32_t *mod
    .arg out,           uint*, global               # __global uint32_t *out
    .arg elementsNum,   uint                        # unsigned elementsNum
     
.text
    # Constants
    OpSize = 11
    OpMemSize = 12
    ResultMemSize = 12

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    m1 = %s[12:13]
    mod = %s[14:15]    
    out = %s[16:17]    
    stmp0 = %s18
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9
    vtmp  = %v[10:11]

    vm1ctx = %v[12:25]
    vm1 = %v[15:25]
    vmod = %v[26:36]
    zero = %v[37:38]
    cache = %v[39:49]
    inv = %v[50:60]
    invm = %v61

    s_load_dwordx2      m1, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      out, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp0, localSize, GroupId
    vadd32u             i, vcc, stmp0, LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end
    
    v_mul_lo_u32        vtmp[0], i, 4*OpMemSize
    v_mul_lo_u32        vtmp[1], i, 4*OpMemSize
    load11dw            vm1, m1, vtmp[0], vaddr
    load11dw            vmod, mod, vtmp[1], vaddr
    
    # Calculate invm
    invert_limb         vmod[0], vaddr, vtmp, invm
    
    # Montromery squaring
    redchalf352         vm1, vmod, inv, invm, cache, zero, vtmp[0]
    
    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store11dw           vm1, out, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:    
    s_endpgm
.ends


.scope redcifyBenchmark320u
.kernel redcifyBenchmark320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg mquotient,       uint*, global, const      # __global uint32_t *restrict mquotient
    .arg mmod,            uint*, global, const      # __global uint32_t *restrict mmod
    .arg out,             uint*, global             # __global uint32_t *restrict out
    .arg elementsNum,     uint                      # unsigned elementsNum
.text
    # Constants
    Op1Size = 10
    Op1MemSize = 10
    QuotientMemSize = 8
    ResultMemSize = Op1MemSize

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    mquotient = %s[12:13]
    mmod = %s[14:15]    
    mout = %s[16:17]    
    stmp = %s[18:21]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9

    quotient = %v[10:21]
    mod =      %v[22:31]
    cache =    %v[32:41]
    out =      %v[42:52]
    zero =     %v[53:54]
    vtmp = %v[55:58]
    
    s_load_dwordx2      mquotient, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mmod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      mout, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    
    
    v_mov_b32           quotient[8], 0
    v_mov_b32           quotient[9], 0
    v_mov_b32           quotient[10], 0
    v_mov_b32           quotient[11], 0    
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end    
    
    v_mul_lo_u32        vtmp[0], i, 4*QuotientMemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op1MemSize
    load8dw             quotient, mquotient, vtmp[0], vaddr
    load10dw            mod, mmod, vtmp[1], vaddr
    
    v_and_b32           vtmp[0], ((1 << WindowSize)-1), i

    # Calculate redcify    
    redcify320ws7       quotient, mod, vtmp[0], cache, out, vtmp, zero
    
    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store10dw           out, mout, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:        
    s_endpgm
.ends    
    
.scope redcifyBenchmark352u
.kernel redcifyBenchmark352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg mquotient,       uint*, global, const      # __global uint32_t *restrict mquotient
    .arg mmod,            uint*, global, const      # __global uint32_t *restrict mmod
    .arg out,             uint*, global             # __global uint32_t *restrict out
    .arg elementsNum,     uint                      # unsigned elementsNum
.text
    # Constants
    Op1Size = 11
    Op1MemSize = 12
    QuotientMemSize = 8
    ResultMemSize = Op1MemSize

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2    
    elementsNum = %s9
    globalSize = %s11
    mquotient = %s[12:13]
    mmod = %s[14:15]    
    mout = %s[16:17]    
    stmp = %s[18:19]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9

    quotient = %v[10:21]
    mod =      %v[22:32]
    cache =    %v[33:43]
    out =      %v[44:55]
    zero =     %v[56:57]
    vtmp = %v[58:61]
    
    s_load_dwordx2      mquotient, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mmod, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      mout, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    
    
    v_mov_b32           quotient[8], 0
    v_mov_b32           quotient[9], 0
    v_mov_b32           quotient[10], 0
    v_mov_b32           quotient[11], 0    
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end    
    
    v_mul_lo_u32        vtmp[0], i, 4*QuotientMemSize
    v_mul_lo_u32        vtmp[1], i, 4*Op1MemSize
    load8dw             quotient, mquotient, vtmp[0], vaddr
    load11dw            mod, mmod, vtmp[1], vaddr
    
    v_and_b32           vtmp[0], ((1 << WindowSize)-1), i

    # Calculate redcify    
    redcify352ws7       quotient, mod, vtmp[0], cache, out, vtmp,  zero
    
    # Store result
    v_mov_b32           vtmp[0], 4*ResultMemSize
    v_mul_lo_u32        vtmp[0], i, vtmp[0]
    store11dw           out, mout, vtmp[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:        
    s_endpgm
.ends    
    
.scope divideBenchmark480to320u
.kernel divideBenchmark480to320u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg mdivisor,       uint*, global, const    # __global uint32_t *mdivisor
    .arg mquotient,      uint*, global           # __global uint32_t *mquotient    
    .arg msize,          uint*, global           # __global uint32_t *msize     
    .arg elementsNum,    uint                    # unsigned elementsNum
.text
    # Constants
    DivisorSize = 10
    DivisorMemSize = 10
    QuotientMemSize = 8

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2
    elementsNum = %s9
    globalSize = %s11
    mdivisor = %s[12:13]
    mquotient = %s[14:15]
    msize = %s[16:17]    
    stmp = %s[18:21]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9

    divisor =  %v[10:19]
    dividend = %v[20:34]
    quotient = %v[35:42]
    size     = %v43
    
    reg0 =     %v[44:65]
    zero =     %v[66:67]

    s_load_dwordx2      mdivisor, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mquotient, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      msize, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end    
    
    v_mul_lo_u32        reg0[0], i, 4*DivisorMemSize
    load10dw            divisor, mdivisor, reg0[0], vaddr

    # fill dividend
    v_mov_b32           dividend[0], 0
    v_mov_b32           dividend[1], 0
    v_mov_b32           dividend[2], 0
    v_mov_b32           dividend[3], 0
    v_mov_b32           dividend[4], 0
    v_mov_b32           dividend[5], 0
    v_mov_b32           dividend[6], 0
    v_mov_b32           dividend[7], 0
    v_mov_b32           dividend[8], 0
    v_mov_b32           dividend[9], 0
    v_mov_b32           dividend[10], 0
    v_mov_b32           dividend[11], 0
    v_mov_b32           dividend[12], 0
    v_mov_b32           dividend[13], 0
    v_mov_b32           dividend[14], 1    
    
    div480to320         dividend, divisor, quotient, size, reg0, stmp, zero
    
    # Store result
    v_mul_lo_u32        reg0[0], i, 4*QuotientMemSize
    v_mul_lo_u32        reg0[1], i, 4
    store8dw            quotient, mquotient, reg0[0], vaddr
    store1dw            size, msize, reg0[1], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:
    s_endpgm
.ends

.scope divideBenchmark512to352u
.kernel divideBenchmark512to352u
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg mdivisor,       uint*, global, const    # __global uint32_t *mdivisor
    .arg mquotient,      uint*, global           # __global uint32_t *mquotient    
    .arg msize,          uint*, global           # __global uint32_t *msize     
    .arg elementsNum,    uint                    # unsigned elementsNum
.text
    # Constants
    DivisorSize = 11
    DivisorMemSize = 12
    QuotientMemSize = 8

    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2
    elementsNum = %s9
    globalSize = %s11
    mdivisor = %s[12:13]
    mquotient = %s[14:15]
    msize = %s[16:17]    
    stmp = %s[18:21]
    
    vaddr = %v[2:7]
    i = %v8
    j = %v9

    divisor =  %v[10:20]
    dividend = %v[21:36]
    quotient = %v[37:44]
    size     = %v45
    
    reg =      %v[46:67]
    zero =     %v[68:69]

    s_load_dwordx2      mdivisor, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mquotient, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dwordx2      msize, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*3
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           stmp[0], localSize, GroupId
    vadd32u             i, vcc, stmp[0], LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0
    
.loop1:
.align 16
    v_cmp_gt_u32        vcc, elementsNum, i
    s_and_saveexec_b64  execStore, vcc
    s_cbranch_execz     .end    
    
    v_mul_lo_u32        reg[0], i, 4*DivisorMemSize
    load11dw            divisor, mdivisor, reg[0], vaddr

    # fill dividend
    v_mov_b32           dividend[0], 0
    v_mov_b32           dividend[1], 0
    v_mov_b32           dividend[2], 0
    v_mov_b32           dividend[3], 0
    v_mov_b32           dividend[4], 0
    v_mov_b32           dividend[5], 0
    v_mov_b32           dividend[6], 0
    v_mov_b32           dividend[7], 0
    v_mov_b32           dividend[8], 0
    v_mov_b32           dividend[9], 0
    v_mov_b32           dividend[10], 0
    v_mov_b32           dividend[11], 0
    v_mov_b32           dividend[12], 0
    v_mov_b32           dividend[13], 0
    v_mov_b32           dividend[14], 0
    v_mov_b32           dividend[15], 1    
    
    div512to352         dividend, divisor, quotient, size, reg, stmp, zero
    
    # Store result
    v_mul_lo_u32        reg[0], i, 4*QuotientMemSize
    v_mul_lo_u32        reg[1], i, 4
    store8dw            quotient, mquotient, reg[0], vaddr
    store1dw            size, msize, reg[1], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
    
.end:
    s_endpgm
.ends
    
.scope fermatTestBenchmark320
.kernel fermatTestBenchmark320
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg int,           uint*, global, const    # __global uint32_t *restrict numbers
    .arg out,           uint*, global           # __global uint32_t *restrict out
    .arg elementsNum,   uint                    # unsigned elementsNum
.text
    OpSize = 10
    OpMemSize = 10
    ResultMemSize = 10
    
    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2
    elementsNum = %s9
    globalSize = %s11
    
    min = %s[12:13]
    mout = %s[14:15]
    sreg = %s[18:23]
    
    i = %v1
    mod        = %v[2:11]
    modpowregs = %v[12:81]
    vaddr      = %v[76:81]    
    zero       = %v[82:83]
    
    s_load_dwordx2      min, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mout, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           sreg[0], localSize, GroupId
    vadd32u             i, vcc, sreg[0], LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0

.loop1:
.align 16
    v_cmpx_lt_u32       vcc, i, elementsNum
    s_cbranch_execz     .end    
    
    v_mul_lo_u32        modpowregs[0], i, 4*OpMemSize
    load10dw            mod, min, modpowregs[0], vaddr
    
    modpow320of2        mod, modpowregs, zero, sreg
    
    #; store result
    v_mul_lo_u32        modpowregs[0], i, 4*ResultMemSize
    store10dw           mod, mout, modpowregs[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
.end:    
    s_endpgm
.ends    
    
.scope fermatTestBenchmark352
.kernel fermatTestBenchmark352
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg int,           uint*, global, const    # __global uint32_t *restrict numbers
    .arg out,           uint*, global           # __global uint32_t *restrict out
    .arg elementsNum,   uint                    # unsigned elementsNum
.text
    OpSize = 11
    OpMemSize = 12
    ResultMemSize = 12
    
    # Global scope binding
    execStore = %s[0:1]
    localSize = %s2
    elementsNum = %s9
    globalSize = %s11
    
    min = %s[12:13]
    mout = %s[14:15]
    sreg = %s[18:23]
    
    i = %v1
    mod        = %v[2:12]
    modpowregs = %v[13:87]
    vaddr      = %v[82:87]    
    zero       = %v[88:89]
    
    s_load_dwordx2      min, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      mout, ArgumentsPtr, FirstArgumentByteOffset + PointerSize
    s_load_dword        elementsNum, ArgumentsPtr, FirstArgumentByteOffset + PointerSize*2
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)
    s_and_b32           localSize, localSize, 0xFFFF
    
    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           sreg[0], localSize, GroupId
    vadd32u             i, vcc, sreg[0], LocalId
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0

.loop1:
.align 16
    v_cmpx_lt_u32       vcc, i, elementsNum
    s_cbranch_execz     .end    
    
    v_mul_lo_u32        modpowregs[0], i, 4*OpMemSize
    load11dw            mod, min, modpowregs[0], vaddr
    
    modpow352of2        mod, modpowregs, zero, sreg
    
    #; store result
    v_mul_lo_u32        modpowregs[0], i, 4*ResultMemSize
    store11dw           mod, mout, modpowregs[0], vaddr
    
    vadd32u             i, vcc, i, globalSize
    s_branch            .loop1
.end:    
    s_endpgm
.ends    
