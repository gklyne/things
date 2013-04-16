These are my sketchy notes for installing the PrintRun RepRap host control software on a Raspberry Pi.

Credit is due to others in the RepRap community for some of the details, 
but I've lost the various references I used to create these notes.
I'll add links here if and when I find them.

1. Raspberry Pi won't boot without SD card and system image.
   To load an sd card image from an mage file on Linux:

        dd if=<image-file> of=/dev/sdf

   The device name shown here is that for my Dell SD card reader - it may well vary.
   To find device names, try any of the following:

        fdisk -l
        cat /proc/partitions

2. Setting up default Debian-based system

   Initial boot provides configuration options: 
   select option to expand root partition to entire SD card.
   Other options may also be selected at this time.

   Reboot the Raspberry Pi - on restarting, it takes a while to resize partition.  
   With a network cable, the system pretty much sorts itself out using DHCP, 
   including setting the system time via NTP.

   A second reboot may be needed to get everything setttled.

   Login (username `pi`, password `raspberry`)

3. Update software package index, and set up for SSH access.

        sudo apt-get update
        sudo dpkg-reconfigure openssh-server # to generate host keys

   From here on, should be able to use network ssh login to run commands.
   This makes it easier to ciut and paste details from browser windows, etc.

4. Get system ready to install printrun host software:

        sudo apt-get install git
        sudo apt-get install mercurial
        sudo apt-get install python-distribute
        sudo easy_install pip
        sudo pip install pyserial
        sudo apt-get install wx-common
        sudo apt-get install python-pmw python-imaging
        sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n libwxgtk2.8-dev

   The python imaging libraries are installed per `tkinter` install instructions 
   (cf. http://tkinter.unpythonic.net/wiki/How_to_install_Tkinter)

   The wxPython installation is per http://www.raspberrypi.org/phpBB3/viewtopic.php?f=32&t=12185

5. Create working directory/ies for reprap software; e.g.

        mkdir -p ~/github/kliment

6. Get copy of printrun 

        cd ~/github/kliment
        git clone https://github.com/kliment/Printrun.git

   See also: http://reprap.org/wiki/Printrun

   It should not be possible to run `pronterface` in the windowing system,
   or `pronsole` from any terminal session (including ssh) to control a connected RepRap.

7. Download and unpack latest copy of Skeinforge from  http://fabmetheus.crsndoo.com/

   I have found Skeinforge to be rather slow on the Raspberry Pi.  
   Up to now, I have tended to run Skeinforge on other computers and import the resulting GCode files,
   e.g. via GitHub.  It may be that performanmce is better on 512Mb variants of the Raspberry Pi.

8. Check out serial ports:

   Use this command to list detected USB devices:

        lsusb

   The RepRap port should be /dev/ttyUSB0 (or similar)

