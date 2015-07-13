#!/bin/bash
# this script downloads the tetra codec from ETSI, and tries to patch it,
# compile it, and install it --sq5bpf
#
# This script is licensed by the GNU General Public License v2. See the file
# LICENSE for the license text, or if unavaliable obtain it via other means.
#
# I disclaim any liability for things that this software does or doesn't do.
# Everything is the responsibility of the user.
#
# Changelog:
# 20150629: manage permissions better, and check installation --sq5bpf
# 20150617: initial version --sq5bpf

# please read this script, it is self-documenting
# you can edit the following variables as you like:

URL="http://www.etsi.org/deliver/etsi_en/300300_300399/30039502/01.03.01_60/en_30039502v010301p0.zip"
CODECFILE=`basename "$URL"`
CODECSUM=a8115fe68ef8f8cc466f4192572a1e3e
WORKDIR=/tmp/codec-$$
BASEDIR=/tetra #change this if you want to install in another directory
INSTALLDIR=$BASEDIR/bin
SCRIPT_VERSION=1.1

check_codec() {
	TMPSUM=`md5sum "$CODECFILE" 2>/dev/null |cut -d ' ' -f 1`
	if [ "$TMPSUM" = "$CODECSUM" ]; then
		echo "Codec checksum ok"
		return 0
	else
		echo "Bad codec checksum. is $TMPSUM , but should be $CODECSUM"
		echo "Deleting the codec file $CODECFILE , please download a correct version"
		rm "$CODECFILE"
		exit 1
	fi
}

get_codec() {
	RET=0
	echo "*****  Getting codec"
	if [ -f "$CODECFILE" ]; then
		echo "We already have the codec sources in $CODECFILE"
	else
		echo "Downloading codec $URL"
		wget -v -O "$CODECFILE" "$URL"; RET=$?
		if [ "$RET" != 0 ]; then
			#should use here-documents, but they don't indent well under vim
			echo "Couldn't get codec from $URL"
			echo
			echo "***  PLEASE MAKE SURE YOU HAVE INTERNET ACCESS  !! ***" #ok, i know capitals are rude, but maybe someone will read it
			echo
			echo "You can also try to download it yourself, put it in $CODECFILE"
			echo "and run this script again."
			exit 1
		fi
	fi

}

check_prerequisites() {
	for i in unzip wget make gcc patch sudo
	do
		A=`which $i`
		if [ -x "$A" ]; then
			:
		else
			echo "You don't seem to have >> $i << installed."
			echo 	"Please install it and try again"
			exit 1
		fi
	done
}

compile_codec() {
	echo "*****  Building in $WORKDIR"
	mkdir -p $WORKDIR 
	TMPPWD=`pwd`
	(
	cd $WORKDIR && unzip -L "$TMPPWD/$CODECFILE" && patch -p1 -N -E < "$TMPPWD/codec.diff" && cd c-code && make
	) ; RET=$?
	if [ "$RET" != 0 ]; then
		echo "Something went wrong during the build. You can o to $WORKDIR/c-code and"
		echo "try to figure out what is the problem."
		echo "Or just remove the $WORKDIR if you don't want to debug the problem yourself"
		exit 1
	fi
}

install_codec() {
	echo "******  Installing codec."
	echo "Will try without sudo first, and then with sudo if that fails"
	MYUSER=`id -nu`
	MYGROUP=`id -ng`
	( cd "$WORKDIR/c-code" || exit $?
	#try without sudo first
	mkdir -p "$INSTALLDIR" || sudo mkdir -p "$INSTALLDIR"
	cp sdecoder scoder cdecoder ccoder "$INSTALLDIR" || \
		sudo cp sdecoder scoder cdecoder ccoder "$INSTALLDIR"
	chown -R ${MYUSER}.${MYGROUP} "$BASEDIR" || sudo chown -R ${MYUSER}.${MYGROUP} "$BASEDIR"
	) ; RET=$?
	if [ "$RET" != 0 ]; then
		echo "There was some problem installing, maybe you don't have sudo privileges?"
		echo "Try to copy sdecoder, scoder, cdecoder, and ccoder from $WORKDIR/c-code to $INSTALLDIR"
		exit 1
	fi
}

cleanup_install() {
	rm -fr "$WORKDIR"
}

check_install() {
	for i in sdecoder scoder cdecoder ccoder
	do
		[ -x "${INSTALLDIR}/$i" ] || return 1
	done
	return 0
}

######### main
echo "******  TETRA Codec installer [$0 v$SCRIPT_VERSION]"
echo "******  (c) 2015 Jacek Lipkowski <sq5bpf@lipkowski.org>"
check_prerequisites
get_codec
check_codec #you can comment out this line if you know what you're doing :)
compile_codec
install_codec && cleanup_install
check_install && echo "******  Codec installed [$0 v$SCRIPT_VERSION]"
