

SHELL := /bin/bash

torizonos_tools=$(wrkdir_src)/torizonos

# Extract the directory of the current Makefile
MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_DIR)/$(PLATFORM)/make.mk

$(toradex-easy-installer):
	wget -P $(torizonos_tools) $(toradex-easy-installer-link)
	cd $(torizonos_tools) && unzip $(toradex-easy-installer).zip
	

# configure the torizonos image

.PHONY: torizonos_image
torizonos_image: $(wrkdir_demo_imgs)/u-boot.bin $(toradex-easy-installer)

