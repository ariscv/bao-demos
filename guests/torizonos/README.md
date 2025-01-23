# Torizon Guest


## 1. Setup Torizon OS Yocto Project

For instruction on how to setup Torizon OS build follow:

```shell
sensible-browser https://developer.toradex.cn/torizon/in-depth/build-torizoncore-from-source-with-yocto-projectopenembedded/#build-process
```

Stop at the "Setup Environment" stage and execute the following steps.


## 2. Add meta-bao layer

Although Toradex provides the torizonbuilder tool to modify some aspects of a
TorizonOS Image, Bao requires slight modifications to the kernel on the imx8mp
which is not supported by the tool. We've added this modifications in a Yocto
Project layer. This layer also modifies the dts for this demo, and adds the Bao
driver. Alternatevely this could be done through the torizonbuilder.

You can add the Bao layer by running the following commands.

``` shell
cd <path-to-torizonos>

# be sure to set up environment for imx8mp
. setup-environment

# obtain the meta-bao repository
git clone https://github.com/bao-project/meta-bao ../layers/meta-bao

#add our layer
bitbake-layers add-layer ../layers/meta-bao/
```


## 3. Build torizon OS

Build torizon OS:

``` shell
bitbake torizon-docker
```

## 4. Copy Torizon OS Image to sdcard

[Prepare an SD card](./../../platforms/sdcard.md), extract the image from the
generate .tar, and copy the extracted Torizon OS folder to the sdcard.

``` shell
cd <path-to-yocto-build-dir>/deploy/images/

# extract
tar -xf torizon-docker-verdin-imx8mp-Tezi_7.1.0-devel-<version>+build.0.tar

# copy to sdcard
cp -r torizon-docker-verdin-imx8mp-Tezi_7.1.0-devel-<version>+build.0 /media/$USER/boot
umount /media/$USER/boot
```

Then insert the sdcard on the board.


## 5. Run Toradex Easy Installer

### Setup Toradex Easy Installer Environment Variables

Define the version and download link for the Toradex Easy Installer:

```bash
export BAO_DEMOS_TORADEX_EASY_INSTALLER_VERSION=Verdin-iMX8MP_ToradexEasyInstaller_6.8.1+build.9
export BAO_DEMOS_TORADEX_EASY_INSTALLER_LINK=https://tezi.toradex.com/artifactory/tezi-oe-prod-frankfurt/kirkstone-6.x.y/release/9/verdin-imx8mp/tezi/tezi-run/oedeploy/$BAO_DEMOS_TORADEX_EASY_INSTALLER_VERSION.zip
export BAO_DEMOS_TORADEX_EASY_INSTALLER=$TORIZONOS_TOOLS/$BAO_DEMOS_TORADEX_EASY_INSTALLER_VERSION
```

### Download the Toradex Easy Installer

Use `wget` to download the Toradex Easy Installer zip file:

```bash
wget -P $TORIZONOS_TOOLS $BAO_DEMOS_TORADEX_EASY_INSTALLER_LINK
```

### Extract the Toradex Easy Installer

Unzip the downloaded file into the target tools directory:

```bash
cd $TORIZONOS_TOOLS && unzip $BAO_DEMOS_TORADEX_EASY_INSTALLER.zip
```

### Run TorizonOS Easy Installer

```bash
cd $BAO_DEMOS_TORADEX_EASY_INSTALLER
./recovery-linux.sh
```

The script will wait for board to enter serial download mode. Connect to USB-C DRP, and press the Recovery Button, then press and release the Reset Button, and then, after 1 second, release the DRP button.

## 6. Install Torizon OS

Connect to USB-C debug on the board and connect to the UART.

``` shell
screen /dev/ttyUSB3 115200
```

Connect the board to your local network using the ethernet cable, and check its
IP.

``` shell
ifconfig
``` 

Use you VNC client of choice to interact with TorizonOS easy installer.
``` shell
sudo apt install vncviewer
```
``` shell
vncviewer <Board IP Address>
```

Select the TorizonOS image on the SD Card click install and accept the terms.
After installation click "Reboot".


## 7) Test boot baremetal Torizon OS

Connect via SSH, on this demo we don't have the UART available for Torizon OS.

``` shell
ssh torizon@<Board IP Address>
```

Use `torizon` as password.
Setup a new password (e.g., root)



## 5. U-Boot

The guest image for this demo is U-Boot. U-boot will operate as it does on a
typical platforms looking for the relevant kernel files in the emmc filesystem.
For this demo we update the memory layout of the platform, e.g., for
iMX8MP-verdin we modify `include/configs/verdin-imx8mp.h`.

Additionally we remove the first UART from U-boot, as this UART is given to
FreeRTOS guest. This modifcations are applied through a patch. For example for
iMX8MP-verdin `guests/torizonos/imx8mp-verdin/uboot-patch.diff`.


### Setup U-Boot Environment Variables

Define the U-Boot repository, version, and source directory:

```bash
export BAO_DEMOS_UBOOT_REPO=https://github.com/u-boot/u-boot.git
export BAO_DEMOS_UBOOT_VERSION=v2024.10
export BAO_DEMOS_UBOOT_SRC=$BAO_DEMOS_WRKDIR_SRC/u-boot-$BAO_DEMOS_UBOOT_VERSION
```

Clone the specified version of the U-Boot repository:

```bash
git clone $BAO_DEMOS_UBOOT_REPO $BAO_DEMOS_UBOOT_SRC\
    --depth 1 --branch $BAO_DEMOS_UBOOT_VERSION
```

### Apply Patches to U-Boot Source

If platform-specific patches are required, copy and apply them:

```bash
cp $BAO_DEMOS/guests/torizonos/imx8mp-verdin/uboot-patch.diff $BAO_DEMOS_UBOOT_SRC/
cd $BAO_DEMOS_UBOOT_SRC
git apply uboot-patch.diff
```

### Configure U-Boot for the Target Platform

Select the U-Boot configuration for the target platform. For example, for the Verdin i.MX8MP platform:

```bash
make -C $BAO_DEMOS_UBOOT_SRC verdin-imx8mp_defconfig
```

### Build U-Boot Binary

Compile the U-Boot source code:

```bash
make -C $BAO_DEMOS_UBOOT_SRC -j$(nproc) u-boot.bin
```

### Copy the Built Binary to the Demo Images Directory

Move the resulting U-Boot binary to the target directory for demo images:

```bash
cp $BAO_DEMOS_UBOOT_SRC/u-boot.bin $BAO_DEMOS_WRKDIR_IMGS/
```

## 7. Bao Patch


The linux kernel on this demo interacts with the hardware to manage power
domains related to media related peripherals. We currently do not support a
controlled access to this features. With this patch Bao will passthrough all
firmware calls.

### Build Bao

Clone Bao's repo to the the working directory (Skip the clone step on step B.4)
on the main README):

```shell
export BAO_DEMOS_BAO=$BAO_DEMOS_WRKDIR_SRC/bao
git clone https://github.com/bao-project/bao-hypervisor $BAO_DEMOS_BAO\
    --branch demo
```

Apply the patch:
```bash
cd $BAO_DEMOS_BAO
git apply $BAO_DEMOS/demos/$DEMO/$PLATFORM/bao-smc-passthrough.patch
```

