
# How to generate Python readable ATOM C structures from Linux kernel code

## Reguirements

    sudo apt install clang-6.0
    pip3 install --user ctypeslib2 clang

## Get latest Linux kernel

    git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git


## atom.py

    clang2py -k 'm' \
      --clang-args="--include stdint.h" \
      linux/drivers/gpu/drm/amd/amdgpu/atom.h > atom.py


## atombios.py

    clang2py -k 's' \
      --clang-args="--include stdint.h \
                    --include linux/drivers/gpu/drm/amd/include/atom-types.h \
                   " \
      linux/drivers/gpu/drm/amd/include/atombios.h > atombios.py


## pptable_v1_0.py (Polaris/Tonga)

    clang2py -k 'mst' \
      --clang-args="--include stdint.h \
                    --include linux/drivers/gpu/drm/amd/include/atom-types.h \
                    --include linux/drivers/gpu/drm/amd/include/atombios.h" \
       linux/drivers/gpu/drm/amd/powerplay/hwmgr/pptable_v1_0.h > pptable_v1_0.py


## vega10_pptable.py (Vega10 aka Vega 56/64)

    clang2py -k 'mst' \
      --clang-args="--include stdint.h \
                    --include linux/drivers/gpu/drm/amd/include/atom-types.h \
                    --include linux/drivers/gpu/drm/amd/include/atomfirmware.h \
                    --include linux/drivers/gpu/drm/amd/include/atombios.h" \
       linux/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_pptable.h > vega10_pptable.py


## vega20_pptable.py (Vega20 aka Radeon7)

    clang2py -k 'mst' \
      --clang-args="--include stdint.h \
                    --include linux/drivers/gpu/drm/amd/include/atom-types.h \
                    --include linux/drivers/gpu/drm/amd/include/atomfirmware.h \
                    --include linux/drivers/gpu/drm/amd/powerplay/inc/smu11_driver_if.h " \
       linux/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_pptable.h > vega20_pptable.py


##  smu_v11_0_navi10.py (Navi10/14)

    clang2py -k 'mst' \
      --clang-args="--include stdint.h \
                    --include linux/drivers/gpu/drm/amd/include/atom-types.h \
                    --include linux/drivers/gpu/drm/amd/include/atomfirmware.h \
                    --include linux/drivers/gpu/drm/amd/powerplay/inc/smu11_driver_if_navi10.h " \
       linux/drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_pptable.h > smu_v11_0_navi10.py

