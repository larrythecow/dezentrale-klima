#!/bin/bash

PWD=`pwd`

# 1. do we need this script or just a simple documentation?
# should have options like
# --board panda --kernel stable --get/build/all

function panda(){
        echo -e "get pandaboard 3.2.xxx.xxx kernel with sample config\n"
	wget -c 'https://launchpad.net/ubuntu/+archive/primary/+files/linux-ti-omap4_3.2.0-1412.16.tar.gz'
	tar xfz linux-ti-omap4_3.2.0-1412.16.tar.gz
	wget -c http://dev.gentoo.org/~armin76/arm/pandaboard/kconfig -O ubuntu-precise/.config
	echo -e "you can build with e.g. whith\n"
	echo -e "make ARCH=arm CROSS_COMPILE=armv7a-hardfloat-linux-gnueabi- uImage"
	echo -e "make ARCH=arm CROSS_COMPILE=arm-none-eabi- uImage"
}

function toradex(){
        echo -e "should build toradex kernel"
}

function usage(){
        echo -e "usage:\n\tpanda\n\ttoradex"
}


case "$1" in
"multistrap")
	multistrap
	exit 0 
	;;
"panda")
	panda
	exit 0
	;;
"toradex")
	toradex
	exit 0
	;;
*)
	usage
	exit -1
	;;
esac
