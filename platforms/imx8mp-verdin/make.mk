ARCH:=aarch64

ifneq ($(DEMO), torizonos+freertos)

instructions:=$(bao_demos)/platforms/$(PLATFORM)/README.md
platform: $(bao_image)
	$(call print-instructions, $(instructions), 1, false)
	$(call print-instructions, $(instructions), 2, false)
	$(call print-instructions, $(instructions), 3, true)

else

instructions:=$(bao_demos)/platforms/$(PLATFORM)/TORIZONOS-README.md
platform: $(bao_image)
	$(call print-instructions, $(instructions), 1, false)
	$(call print-instructions, $(instructions), 2, false)
	$(call print-instructions, $(instructions), 3, false)
	$(call print-instructions, $(instructions), 4, false)
	$(call print-instructions, $(instructions), 5, false)
	$(call print-instructions, $(instructions), 6, false)
	$(call print-instructions, $(instructions), 7, false)
	$(call print-instructions, $(instructions), 8, true)
endif
