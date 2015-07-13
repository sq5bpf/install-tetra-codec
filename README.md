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

View the install.sh script to see how it works, change presets etc. Please 
read the script first so that you know what it does, it is unwise to execute
random scripts downloaded from the internet without understanding them first.

In case of errors email me with the errors, and with complete info about 
the distribution (version, if it is 32 or 64-bit etc).



Legal notice: 
I disclaim any liability for things that this software does or doesn't do.
Everything is the responsibility of the user.

Also please note that this script downloads the TETRA codec from the ETSI 
website, and install it for your own use. It is up to you to verify that this
is legally correct in your jurisdiction. Some of the licensing text is 
avaliable on the ETSI website. I am not a lawyer, and don't consider this 
legal advice, but it would be probably inapropriate to include precompiled
binaries or the source from ETSI in any product (or distribute it further in 
any other way).
 

Changelog: 
20150622: initial version --sq5bpf
20150713: minor README changes --sq5bpf
