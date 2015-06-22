install-tetra-codec (c) 2015 Jacek Lipkowski <sq5bpf@lipkowski.org>


This is a simple script to download the TETRA ACELP codec from ETSI and 
patch/compile/install it. It should work under most linux distributions
(and probably many other POSIX-compatible systems).

Installation steps:

* Install the prerequisites: bash, git, unzip, wget, make, gcc, patch, sudo.


* Check if you can sudo to root (and fix it if not), for example like this:

$ sudo id
[sudo] password for sq5bpf: 
uid=0(root) gid=0(root) groups=0(root)

* Download the script and run it:

$ git clone https://github.com/sq5bpf/install-tetra-codec
$ cd install-tetra-codec
$ chmod 755 install.sh
$ ./install.sh

This should download and compile the codec. 
It will be installed to /tetra/bin (sudo privileges are needed if /tetra 
is not writeable by the user).

View the install.sh script to see how it works, change presets etc.

In case of errors email me with the errors, and with complete info about 
the distribution (version, if it is 32 or 64-bit etc).

Changelog: 
20150622: initial version --sq5bpf

