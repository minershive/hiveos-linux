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

.scope fermat_kernel
.kernel fermat_kernel
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg result,           uchar*, global           # __global uchar *result
    .arg primes,           uint*,  global, const    # __global uint *fprimes
.text
    localSize = %s2    
    globalSize = %s11  
    result = %s[12:13]
    fprimes = %s[14:15]
    sreg = %s[16:23]    
    
    globalId   = %v1
    mod        = %v[2:12]
    modpowregs = %v[13:87]
    vaddr      = %v[82:87]    
    zero       = %v[88:89]
    
    s_load_dwordx2      result, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      fprimes, ArgumentsPtr, FirstArgumentByteOffset + PointerSize 
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)    
    s_and_b32           localSize, localSize, 0xFFFF    

    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           sreg[0], localSize, GroupId
    vadd32u             globalId, vcc, sreg[0], LocalId
    
    # fill zero
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    
    
    # load modulo
    v_lshlrev_b32       modpowregs[0], 2+1, globalSize
    v_lshlrev_b32       modpowregs[1], 2, globalId
    v_lshlrev_b32       modpowregs[2], 2, globalSize    
    vadd32u             vaddr[0], vcc, fprimes[0], modpowregs[1]
    v_mov_b32           vaddr[1], fprimes[1]
    vaddc32u            vaddr[1], vcc, 0, vaddr[1], vcc
    v_mov_b32           vaddr[2], vaddr[0]
    v_mov_b32           vaddr[3], vaddr[1]
    vadd32u             vaddr[4], vcc, vaddr[0], modpowregs[2]
    vaddc32u            vaddr[5], vcc, vaddr[1], 0, vcc
    flat_load_dword     mod[0], vaddr[2:3]
    flat_load_dword     mod[1], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[2], vaddr[2:3]
    flat_load_dword     mod[3], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[4], vaddr[2:3]
    flat_load_dword     mod[5], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[6], vaddr[2:3]
    flat_load_dword     mod[7], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[8], vaddr[2:3]
    flat_load_dword     mod[9], vaddr[4:5]    
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc  
    flat_load_dword     mod[10], vaddr[2:3]
    s_waitcnt           vmcnt(0)    
    
    modpow352of2        mod, modpowregs, zero, sreg
    vsub32u             mod[0], vcc, mod[0], 1
    v_or_b32            mod[0], mod[0], mod[1]
    v_or_b32            mod[0], mod[0], mod[2]
    v_or_b32            mod[0], mod[0], mod[3]
    v_or_b32            mod[0], mod[0], mod[4]
    v_or_b32            mod[0], mod[0], mod[5]
    v_or_b32            mod[0], mod[0], mod[6]
    v_or_b32            mod[0], mod[0], mod[7]
    v_or_b32            mod[0], mod[0], mod[8]
    v_or_b32            mod[0], mod[0], mod[9]  
    v_or_b32            mod[0], mod[0], mod[10]    
    v_cmp_eq_u32        vcc, mod[0], 0
    v_cndmask_b32       mod[0], 0, 1, vcc
    
    # store result & exit
    vadd32u             vaddr[0], vcc, result[0], globalId
    v_mov_b32           vaddr[1], result[1]
    vaddc32u            vaddr[1], vcc, vaddr[1], 0, vcc
    flat_store_byte     vaddr[0:1], mod[0]
    s_endpgm
.ends


.scope fermat_kernel320
.kernel fermat_kernel320
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg result,           uchar*, global           # __global uchar *result
    .arg primes,           uint*,  global, const    # __global uint *fprimes
.text
    localSize = %s2    
    globalSize = %s11        
    result = %s[12:13]
    fprimes = %s[14:15]
    sreg = %s[16:23]        
    
    globalId   = %v1
    mod        = %v[2:11]
    modpowregs = %v[12:81]
    vaddr      = %v[76:81]    
    zero       = %v[82:83]
    
    s_load_dwordx2      result, ArgumentsPtr, FirstArgumentByteOffset
    s_load_dwordx2      fprimes, ArgumentsPtr, FirstArgumentByteOffset + PointerSize 
    s_load_dword        globalSize, SetupBufferPtr, 4*XGlobalSize
    s_load_dword        localSize, SetupBufferPtr, 4*XYLocalSizeOffset
    s_waitcnt           lgkmcnt(0)    
    s_and_b32           localSize, localSize, 0xFFFF    

    # i = get_global_offset(0) = get_local_size(0)*GroupId + LocalId
    s_mul_i32           sreg[0], localSize, GroupId
    vadd32u             globalId, vcc, sreg[0], LocalId
    
    # fill zero
    v_mov_b32           zero[0], 0
    v_mov_b32           zero[1], 0    

    # load modulo
    v_lshlrev_b32       modpowregs[0], 2+1, globalSize
    v_lshlrev_b32       modpowregs[1], 2, globalId
    v_lshlrev_b32       modpowregs[2], 2, globalSize
    vadd32u             vaddr[0], vcc, fprimes[0], modpowregs[1]
    v_mov_b32           vaddr[1], fprimes[1]
    vaddc32u            vaddr[1], vcc, 0, vaddr[1], vcc
    v_mov_b32           vaddr[2], vaddr[0]
    v_mov_b32           vaddr[3], vaddr[1]
    vadd32u             vaddr[4], vcc, vaddr[0], modpowregs[2]
    vaddc32u            vaddr[5], vcc, vaddr[1], 0, vcc
    flat_load_dword     mod[0], vaddr[2:3]
    flat_load_dword     mod[1], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[2], vaddr[2:3]
    flat_load_dword     mod[3], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[4], vaddr[2:3]
    flat_load_dword     mod[5], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[6], vaddr[2:3]
    flat_load_dword     mod[7], vaddr[4:5]
    vadd32u             vaddr[2], vcc, modpowregs[0], vaddr[2]
    vaddc32u            vaddr[3], vcc, 0, vaddr[3], vcc
    vadd32u             vaddr[4], vcc, modpowregs[0], vaddr[4]
    vaddc32u            vaddr[5], vcc, 0, vaddr[5], vcc    
    flat_load_dword     mod[8], vaddr[2:3]
    flat_load_dword     mod[9], vaddr[4:5]
    s_waitcnt           vmcnt(0)   
    
    modpow320of2        mod, modpowregs, zero, sreg
    vsub32u             mod[0], vcc, mod[0], 1
    v_or_b32            mod[0], mod[0], mod[1]
    v_or_b32            mod[0], mod[0], mod[2]
    v_or_b32            mod[0], mod[0], mod[3]
    v_or_b32            mod[0], mod[0], mod[4]
    v_or_b32            mod[0], mod[0], mod[5]
    v_or_b32            mod[0], mod[0], mod[6]
    v_or_b32            mod[0], mod[0], mod[7]
    v_or_b32            mod[0], mod[0], mod[8]
    v_or_b32            mod[0], mod[0], mod[9]
    v_cmp_eq_u32        vcc, mod[0], 0
    v_cndmask_b32       mod[0], 0, 1, vcc
    
    # store result & exit
    vadd32u             vaddr[0], vcc, result[0], globalId
    v_mov_b32           vaddr[1], result[1]
    vaddc32u            vaddr[1], vcc, vaddr[1], 0, vcc
    flat_store_byte     vaddr[0:1], mod[0]
    s_endpgm
.ends
