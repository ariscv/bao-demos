# Toradex Verdin-IMX8MP Torizon OS Deployment

<!--- instruction#1 -->
## 1) Setup Torizon OS Yocto Project

For instruction on how to setup Torizon OS build follow:

```shell
sensible-browser https://developer.toradex.cn/torizon/in-depth/build-torizoncore-from-source-with-yocto-projectopenembedded/#build-process
```

Stop at the "Setup Environment" stage and execute the following steps.


<!--- instruction#2 -->
## 2) Add meta-bao layer

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


<!--- instruction#3 -->
## 3) Build torizon OS

Build torizon OS:

``` shell
bitbake torizon-docker
```


<!--- instruction#4 -->
## 4) Copy Torizon OS Image to sdcard

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

Also copy bao's final image to the sdcard:

```
cp $BAO_DEMOS_WRKDIR_IMGS/bao.bin $BAO_DEMOS_SDCARD
umount $BAO_DEMOS_SDCARD
```

Then insert the sdcard on the board.


<!--- instruction#5 -->
## 5) Run TorizonOS Easy Installer

``` sh
cd $BAO_DEMOS_TORADEX_EASY_INSTALLER
./recovery-linux.sh
```

The script will wait for board to enter serial download mode.
Connect to USB-C DRP, and press the Recovery Button, then press and
release the Reset Button, and then, after 1 second, release the DRP button.


<!--- instruction#6 -->
## 6) Install Torizon OS

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


<!--- instruction#7 -->
## 7) Test boot baremetal Torizon OS

Connect via SSH, on this demo we don't have the UART available for Torizon OS.

``` shell
ssh torizon@<Board IP Address>
```

Use `torizon` as password.
Setup a new password (e.g., root)


<!--- instruction#8 -->
## 8) Reset and run u-boot commands

After validating Torizon OS boots, reboot the board and quickly press any key
to skip autoboot.

```
fatload mmc 1 0x80200000 bao.bin && go 0x80200000
```

You should see a message from Bao followed by the FreeRTOS output on the UART
console.

At this point, connect to TorizonOS via ssh by connecting to the board's
ethernet RJ45 socket.
Update access permissions to the bao driver:

``` shell
sudo chmod 666 /dev/bao@ipc0
```

You can communicate with freeRTOS through /dev/bao@ipc0. For example:

``` shell
echo "Hello from TorizonOS" > /dev/bao@ipc0
cat /dev/bao@ipc0
```

<!--- instruction#end -->

