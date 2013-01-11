#!/usr/bin/perl -w

#** @file bcm2708_temp.pl
# @verbatim
#####################################################################
# This program is not guaranteed to work at all, and by using this  #
# program you release the author of any and all liability.          #
#                                                                   #
# You may use this code as long as you are in compliance with the   #
# license (see the LICENSE file) and this notice, disclaimer and    #
# comment box remain intact and unchanged.                          #
#                                                                   #
# Class:       bcm2708                                              #
# Description: munin plugin for Raspberry Pi CPU sensor             #
#                                                                   #
# Written by:  Imran Shamshad (sid@projekt-turm.de)                 #
##################################################################### 
# @endverbatim
#
# @copy 2011, Imran Shamhad (sid@projekt-turm.de)
# $Id: bcm2708_temp.pl
#*

use strict;
use warnings;

use sensors;
use Munin::Plugin;

if (defined $ARGV[0] && $ARGV[0] eq 'autoconf') {
	if(-r '/opt/vc/bin/vcgencmd') {
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
graph_info This graph shows the CPU temperature in degrees Celsius of a Raspberry Pi.
graph_category sensors
graph_args --base 1000 -l 0
graph_vlabel temp in °C 
cpu.label CPU Temperature
cpu.warning 50.0
cpu.critical 60.0
EOM
exit(0);
}
else{  
        print "cpu.value ", bcm2708Temp(2);
        exit(1);
}
