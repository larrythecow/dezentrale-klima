#!/bin/bash

PWD=`pwd`
CACHE_PWD=$PWD/../var/cache

echo -e "pwd: $PWD"

# 1. do we need this script or just a simple documentation?
# should have options like
# --board panda --kernel stable --get/build/all

function panda-get(){
        echo -e "get pandaboard 3.2.xxx.xxx kernel with sample config\n"
	wget -c 'https://launchpad.net/ubuntu/+archive/primary/+files/linux-ti-omap4_3.2.0-1412.16.tar.gz' -P $CACHE_PWD
	wget -c http://dev.gentoo.org/~armin76/arm/pandaboard/kconfig -O $CACHE_PWD/panda-config

        echo -e "decompressing kernel"
        tar xfz $CACHE_PWD/linux-ti-omap4_3.2.0-1412.16.tar.gz -C $PWD/panda
        echo -e "copy config from var"
        cp $CACHE_PWD/panda-config $PWD/panda/ubuntu-precise/.config	
}

function panda-make(){
	cd $PWD/panda/ubuntu-precise/
	make ARCH=arm CROSS_COMPILE=arm-none-eabi- uImage	
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
"panda-get")
	panda-get
	exit 0
	;;
"panda-make")
        panda-make
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
