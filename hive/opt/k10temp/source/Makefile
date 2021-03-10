# For building for the current running version of Linux
DRV_VER         := 0.3.0
DRIVER          := k10temp
TARGET          := $(shell uname -r)
DKMS_ROOT_PATH  := /usr/src/$(DRIVER)-$(DRV_VER)
KERNEL_MODULES  := /lib/modules/$(TARGET)

ccflags-y       := -DVERSION=$(DRV_VER) $(call cc-disable-warning, missing-attributes)

ifneq ("","$(wildcard /usr/src/linux-headers-$(TARGET)/*)")
# Ubuntu
KERNEL_BUILD    := /usr/src/linux-headers-$(TARGET)
else
ifneq ("","$(wildcard /usr/src/kernels/$(TARGET)/*)")
# Fedora
KERNEL_BUILD    := /usr/src/kernels/$(TARGET)
else
KERNEL_BUILD    := $(KERNEL_MODULES)/build
endif
endif

ifneq ("","$(wildcard /boot/System.map-$(TARGET))")
SYSTEM_MAP      := /boot/System.map-$(TARGET)
else
# Arch
SYSTEM_MAP      := /proc/kallsyms
endif

# Directory below /lib/modules/$(TARGET)/kernel into which to install
# the module:
MOD_SUBDIR := drivers/hwmon
MODDESTDIR := $(KERNEL_MODULES)/kernel/$(MOD_SUBDIR)

obj-m  := $(patsubst %,%.o,$(DRIVER))
obj-ko := $(patsubst %,%.ko,$(DRIVER))

MAKEFLAGS += --no-print-directory

ifneq ("","$(wildcard $(MODDESTDIR)/*.ko.gz)")
COMPRESS_GZIP := y
endif
ifneq ("","$(wildcard $(MODDESTDIR)/*.ko.xz)")
COMPRESS_XZ := y
endif

.PHONY: all install modules modules_install uninstall clean dkms-install dkms-uninstall

all: modules

# Targets for running make directly in the external module directory:

install: modules_install

modules clean:
	@$(MAKE) -C $(KERNEL_BUILD) M=$(CURDIR) $@

modules_install:
	mkdir -p $(MODDESTDIR)
	cp $(DRIVER).ko $(MODDESTDIR)/
ifeq ($(COMPRESS_GZIP), y)
	@gzip -f $(MODDESTDIR)/$(DRIVER).ko
endif
ifeq ($(COMPRESS_XZ), y)
	@xz -f $(MODDESTDIR)/$(DRIVER).ko
endif
	depmod -a -F $(SYSTEM_MAP) $(TARGET)

uninstall:
	rm -f $(MODDESTDIR)/$(DRIVER).*
	depmod -a

dkms-install:
	mkdir $(DKMS_ROOT_PATH)
	cp $(CURDIR)/dkms.conf $(DKMS_ROOT_PATH)
	cp $(CURDIR)/Makefile $(DKMS_ROOT_PATH)
	cp $(CURDIR)/k10temp.c $(DKMS_ROOT_PATH)
	cp $(CURDIR)/compat.h $(DKMS_ROOT_PATH)

	sed -e "s/@CFLGS@/$(ccflags-y)/" \
	    -e "s/@DRIVER@/$(DRIVER)/" \
	    -e "s/@VERSION@/$(DRV_VER)/" \
	    -i $(DKMS_ROOT_PATH)/dkms.conf

	dkms add k10temp/$(DRV_VER)
	dkms build k10temp/$(DRV_VER)
	dkms install k10temp/$(DRV_VER)

dkms-uninstall:
	dkms remove k10temp/$(DRV_VER) --all
	rm -rf $(DKMS_ROOT_PATH)

