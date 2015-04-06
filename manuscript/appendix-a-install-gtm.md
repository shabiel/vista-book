# Installing GT.M for Learning MUMPS
GT.M is a very solid M implementation which has a very small footprint and
integrates really well with UNIX operating systems. It only runs on Linux and
other commercial Unices; not on any BSD derived systems (including Macs). This
means that you have to create a virtual machine if you don't run Linux
natively. You can skip these steps if you already run Linux.

## Vagrant

Vagrant can be download from http://downloads.vagrantup.com/. You need to
download the correct version of vagrant according to your operating system.

The vagrant download site is organized so the latest version is always at the
top. Any version should work.

Vagrant also shows the operating system icons to the left of the links to make
the choice easier.

You can install Vagrant at this point. It is a simple installer that you can
take the defaults through the installation process.

## VirtualBox

VirtualBox is an open source virtual machine provider that works with Vagrant.
VirtualBox can be downloaded from https://www.virtualbox.org/wiki/Downloads.

As with Vagrant above select the correct binary package for your operating
system. You do not need to download the Extension Pack or any other extra
packages from VirtualBox.

You can install VirtualBox at this point. It is a simple installer that you can
take the defaults through the installation process.

## Open the Command Line/Shell

You have to open the command line now. On Windows, press Win-R, and type cmd,
then press enter. On a Mac press Command-Space, type "Terminal" and press enter.

Once you are there, run these commands. Be patient, as these will take a lot
of time the first time you do them as a big download (~700 MB) needs to take
place.
```
 vagrant init ubuntu/trusty64
 vagrant up
 vagrant ssh
```

The last command will drop you into the Linux command line. You will need to
run this next to install GT.M:

```
 wget http://sourceforge.net/projects/fis-gtm/files/GT.M%20Installer/v0.13/gtminstall && chmod +x ./gtminstall && sudo ./gtminstall --verbose
```

To start GT.M, run the following:

```
/usr/lib/fis-gtm/current/gtm
```

You will be dropped into the M shell of GT.M. Get out of there by typing "HALT"
and then set the editor to an editor you are comfortable with. For new users,
I recommend using `nano`, which is installed by default. Type the following:

```
export EDITOR=$(which nano)
```

You can then go into GT.M again:

```
/usr/lib/fis-gtm/current/gtm
```

To create a new routine, type `zedit "routineName"`. You will edit the routine
inside of Nano. Once you save it, you can run it by doing the following:

```
zlink
do/write [$$][label]^routineName[([par1,...])]
```

To edit it again, repeat this cycle:
```
zedit "routineName"
zlink
do/write [$$][label]^routineName[([par1,...])]
```

If GT.M complains to you that it can't link a rouine it's already running,
type `zgoto` before trying `zlink` again.

At this point, you can follow the M tutorial.

Here's an example session:

