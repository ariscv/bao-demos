opensbi_repo:=git@github.com:ariscv/opensbi.git
# opensbi_repo:=git@github.com:ariscv/bao-opensbi.git
opensbi_version:=bao/demo
opensbi_src:=$(wrkdir_src)/opensbi

# opensbi_PLATFORM:=generic
opensbi_PLATFORM:=myspike

$(opensbi_src):
	-git clone --branch $(opensbi_version) $(opensbi_repo) $(opensbi_src)

define build-opensbi-payload
$(strip $1): $(strip $2) $(opensbi_src) 
	+$(MAKE) -C $(opensbi_src) PLATFORM=$(opensbi_PLATFORM) \
		FW_PAYLOAD=y \
		FW_PAYLOAD_FDT_ADDR=0x80100000\
		FW_PAYLOAD_PATH=$(strip $2)
	cp $(opensbi_src)/build/platform/$(opensbi_PLATFORM)/firmware/fw_payload.elf $$@
endef
