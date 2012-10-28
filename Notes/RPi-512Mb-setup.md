Getting raspberry pi working with 512M RAM.  2012-10-28

Starting with new installation of September 2012 distribution of Raspbian Linux.

1. Update packages.  (I tried dist-upgrade after this, but there was notining else to update)

        apt-get update
        apt-get install git
        apt-get upgrade


2. Pull copy of latest firmware from GitHub repository.
   (This is probably a slow option, as it pulls a lot of stuff I didn't need.)

        mkdir github
        cd github
        mkdir raspberrypi
        cd raspberrypi
        git clone http://github.com/raspberrypi/firmware

3. Create backup copy of original /boot directory (optional)

        cd /boot
        mkdir /root/rpi
        mkdir /root/rpi/boot
        cp -av * /root/rpi/boot/

4. Replace original content of /boot directory with content pulled from GitHub repository

        cd /boot
        rm *
        cp ~/github/raspberrypi/firmware/boot/* .

Now reboot:  the system should be using the full complement of available memory.
Now, you can think about tweaking /boot/config.txt to set local options.

