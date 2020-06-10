.kernel getconfig
.config
    .dims x
    .useargs
    .usesetup
    .setupargs
    .arg conf,            uint*, global        # __global config_t* conf
.text
    configptr   = %s[12:13]
    configdata  = %v[1:10]
    vaddr       = %v[11:16]

    s_load_dwordx2      configptr, ArgumentsPtr, FirstArgumentByteOffset
    s_waitcnt           lgkmcnt(0)
    v_mov_b32           configdata[0], 12
    v_mov_b32           configdata[1], SIZE
    v_mov_b32           configdata[2], STRIPES
    v_mov_b32           configdata[3], WIDTH
    v_mov_b32           configdata[4], PCOUNT
    v_mov_b32           configdata[5], TARGET
    v_mov_b32           configdata[6], LIMIT13
    v_mov_b32           configdata[7], LIMIT14
    v_mov_b32           configdata[8], LIMIT15
    v_mov_b32           configdata[9], 1
    store10dw            configdata, configptr, 0, vaddr

    s_endpgm

