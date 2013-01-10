#!/usr/bin/perl -w

#** @file HidTEMPer.pl
# @verbatim
#####################################################################
# This program is not guaranteed to work at all, and by using this  #
# program you release the author of any and all liability.          #
#                                                                   #
# You may use this code as long as you are in compliance with the   #
# license (see the LICENSE file) and this notice, disclaimer and    #
# comment box remain intact and unchanged.                          #
#                                                                   #
# Class:       bcmHidTEMPer                                         #
# Description: munin plugin for HidTEMPer sensor                    #
#                                                                   #
# Written by:  Imran Shamshad (sid@projekt-turm.de)                 #
##################################################################### 
# @endverbatim
#
# @copy 2011, Imran Shamhad (sid@projekt-turm.de)
# $Id: $HidTEMPer.pl
#*

use strict;
use warnings;
use Munin::Plugin;
use Device::USB::PCSensor::HidTEMPer;


#** @var $temper stores HidTemper Object
my $temper = Device::USB::PCSensor::HidTEMPer->new();

#** @var $sensor stores stores HidTemper sensor
my $sensor = $temper->device();

if (defined $ARGV[0] && $ARGV[0] eq 'autoconf') {
    if(defined $sensor->internal()){
	print "yes\n";
	exit(0);
    } else {
	print "no\n";
	exit(1);
    }
}

if (defined $ARGV[0] && $ARGV[0] eq 'config') {
print <<EOM;
graph_title Raspberry Pi CPU temperature
graph_args --base 1000 -l 0
graph_vlabel temp in °C 
graph_category sensors
cpu.label CPU Temperature
graph_info This graph shows the CPU temperature in degrees Celsius of a Raspberry Pi. 
EOM
} 
else {
	print "HidTEMPer.value ", $sensor->internal()->celsius();
}


#**}
