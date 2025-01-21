# TorizonOS+FreeRTOS Demo

This demo duplicates the behavior of the Linux+FreeRTOS demo, with TorizonOS
taking the place of Linux. It features a dual guest configuration, i.e.,
TorizonOS and FreeRTOS, connected through an inter-VM communication object. This
object is implemented through a shared memory region and a doorbell mechanism
in the form of hardware interrupts.

One of the platform's cores is assigned to FreeRTOS while all remaining cores
are used by Torizon. The platform's first available UART is also assigned to
FreeRTOS. Any additional UART device is assigned to Torizon. The Torizon guest is 
also accessible via ssh at an IP cconfigured through DHCP.

You can send messages to FreeRTOS by writing to `/dev/baoipc0`. For example:

```
echo "Hello, Bao!" > /dev/baoipc0
```

The FreeRTOS guest will also send a message to Torizon each time it receives a 
character in its UART. However, the Torizon inter-VM is not configured for Torizon
to asynchronously react to it and output this message. You can checkout the last
FreeRTOS message by reading `/dev/baoipc0`:

```
cat /dev/baoipc0
```

To build FreeRTOS set:

```
export FREERTOS_PARAMS="STD_ADDR_SPACE=y"
```

And follow the instructions in [FreeRTOS](../../guests/freertos/README.md). To
build linux follow [Torizon](../../guests/torizonos/README.md).
