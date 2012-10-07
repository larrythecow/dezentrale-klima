ifneq (${KERNELRELEASE},)
	obj-m += gpio-io.o

else
	ARCH ?=
	CROSS_COMPILE ?=
	KERNEL_DIR ?= /lib/modules/$(shell uname -r)/build

	MODULE_DIR := $(shell pwd)
	CFLAGS := -Wall -g 

.PHONY: all
all:: modules

.PHONY: modules
modules:
	${MAKE} -C ${KERNEL_DIR} SUBDIRS=${MODULE_DIR}  modules

.PHONY: clean
clean::
	rm -f  *.o  .*.o  .*.o.* *.ko  .*.ko  *.mod.* .*.mod.* .*.cmd *~
	rm -f Module.symvers Module.markers modules.order 
	rm -rf .tmp_versions
endif
