#!/bin/bash

PATH=`pwd`
MULTISTRAP_DIR=armhf-debian
MULTISTRAP_CONF=multi.conf

echo $PATH $MULTISTRAP_DIR $MULTISTRAP_CONF

function multistrap(){
        echo "multistrapping system";
	/usr/sbin/multistrap -f $MULTISTRAP_CONF;
}

function panda(){
        echo "configuring pandaboard"
	rsync -a generic/ debian/
	rsync -a panda/ debian/
}

function toradex(){
        echo "configuring pandaboard"
        rsync -a generic/ debian/
        rsync -a toradex/ debian/
}

function usage(){
        echo -e "usage:\n\tmultistrap\n\tpanda\n\ttoradex"
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
