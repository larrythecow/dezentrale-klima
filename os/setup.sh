#!/bin/bash

PWD=`pwd`
MULTISTRAP_DIR=armhf-debian
MULTISTRAP_CONF=multi.conf

function multistrap(){
        echo -e "multistrapping system with options\n\t-d $PWD/$MULTISTRAP_DIR -f $MULTISTRAP_CONF\n";
	/usr/sbin/multistrap -d $PWD/$MULTISTRAP_DIR -f $MULTISTRAP_CONF;
}

function panda(){
        echo "configuring pandaboard"
	rsync -a $PWD/generic/  $PWD/$MULTISTRAP_DIR
	rsync -a $PWD/panda/ $PWD/$MULTISTRAP_DIR
}

function toradex(){
        echo "configuring toradex"
        rsync -a $PWD/generic/ $PWD/$MULTISTRAP_DIR
        rsync -a $PWD/toradex/ $PWD/$MULTISTRAP_DIR
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
