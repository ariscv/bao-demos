
freertos_image:=$(wrkdir_demo_imgs)/freertos.bin
make_args:=STD_ADDR_SPACE=y
include $(bao_demos)/guests/freertos/make.mk
$(eval $(call build-freertos, $(freertos_image), $(make_args)))

include $(bao_demos)/guests/torizonos/make.mk

guest_images:=torizonos_image $(freertos_image)
