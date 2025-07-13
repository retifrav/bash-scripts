## Controlling Raspberry Pi desktop with TV remote via CEC

It is possible to emulate user input (*mouse and keyboard*) on a Raspberry Pi desktop (*such as [Raspbian](https://raspberrypi.com/software/)*) using TV remote via [CEC](https://en.wikipedia.org/wiki/Consumer_Electronics_Control), when Raspberry Pi is connected to a TV via HDMI.

<!-- MarkdownTOC -->

- [Installation](#installation)
- [Customization](#customization)

<!-- /MarkdownTOC -->

### Installation

``` sh
$ sudo apt install cec-utils xdotool
```

Try to move the mouse (*not via SSH, need to use the actual Xorg session on the device*):

``` sh
$ xdotool mousemove_relative -- 100 100
```

Check that you do in fact have CEC supported, press some buttons on your TV remote while this is running:

``` sh
$ cec-client
```

Switch to Xorg from Wayland:

``` sh
$ sudo raspi-config
```
```
6 Advanced Options
A6 Wayland
W1 X11
```

![](./img/raspi-config-x11.png)

and reboot.

Place the [script](https://github.com/retifrav/bash-scripts/blob/master/control-raspberry-pi-desktop-with-tv-remote-via-cec/cec.sh) to `/home/pi/programs/cec.sh` (*or wherever*). Run it and see if you can move the mouse with its directional pad:

``` sh
$ cec-client | /home/pi/programs/cec.sh -d
```

Create a launcher script:

``` sh
$ nano ~/programs/pipe-cec.sh
```
``` sh
#!/bin/bash

/usr/bin/cec-client | /home/pi/programs/cec.sh
```

Finally, create a user systemd service:

``` sh
$ nano /home/pi/.config/systemd/user/cec.service
```
``` ini
[Unit]
Description=cec

[Service]
Environment=DISPLAY=:0
ExecStart=/home/pi/programs/pipe-cec.sh
#Restart=always
#RestartSec=10
SyslogIdentifier=cec
#User=pi

[Install]
WantedBy=default.target
```

Without `DISPLAY=:0` it will be failing

Enable and start the service:

``` sh
$ systemctl --user enable cec.service
$ systemctl start cec.service
```

Watch the log and try to press some buttons on the TV remote:

``` sh
$ journalctl --user -u cec.service -f
```

### Customization

Every remote has different buttons, and the only way to know which ones you have is to click through all of them and watch the `cec-client` output:

``` sh
$ cec-client | /home/pi/programs/cec.sh -d
```

In my case of an LG Magic Remote none of the numerical buttons are supported - I simply get no events for pressing them, which is why they are commented out in the script.
