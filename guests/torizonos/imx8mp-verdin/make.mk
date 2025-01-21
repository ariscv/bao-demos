
uboot_repo:=https://github.com/u-boot/u-boot.git
uboot_version:=v2024.10
uboot_src:=$(wrkdir_src)/u-boot-torizon
$(uboot_src):
	git clone --depth 1 --branch $(uboot_version) $(uboot_repo) $(uboot_src)

IMX8MP_MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
$(wrkdir_demo_imgs)/u-boot.bin: $(uboot_src)
	cp $(IMX8MP_MAKEFILE_DIR)/uboot-patch.diff $(uboot_src)/ && cd $(uboot_src) && git apply uboot-patch.diff
	$(MAKE) -C $(uboot_src) verdin-imx8mp_defconfig
	$(MAKE) -C $(uboot_src) -j$(nproc) u-boot.bin
	@cp $(uboot_src)/u-boot.bin $(wrkdir_demo_imgs)

toradex-easy-installer-version=Verdin-iMX8MP_ToradexEasyInstaller_6.8.1+build.9
toradex-easy-installer-link:=https://tezi.toradex.com/artifactory/tezi-oe-prod-frankfurt/kirkstone-6.x.y/release/9/verdin-imx8mp/tezi/tezi-run/oedeploy/$(toradex-easy-installer-version).zip
toradex-easy-installer:=$(torizonos_tools)/$(toradex-easy-installer-version)

environment+=BAO_DEMOS_TORADEX_EASY_INSTALLER=$(toradex-easy-installer)
environment+=BAO_DEMOS_UBOOT_PATCH=$(IMX8MP_MAKEFILE_DIR)/uboot-patch.diff

$(bao_src):
	git clone --branch $(bao_version) $(bao_repo) $(bao_src)
	cd $(bao_src) && git apply $(bao_demos)/demos/$(DEMO)/$(PLATFORM)/bao-smc-passthrough.patch

BAO_SRC_DEFINED = 1
