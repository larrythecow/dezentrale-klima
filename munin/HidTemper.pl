#!/usr/bin/perl -w

# -*- cperl -*-

=head1 NAME

bcm2708_temp - Munin plugin to monitor BCM2708 CPU Temperature on a Raspberri Pi with a propertary sensor tool

=head1 APPLICABLE SYSTEMS

Any Raspberry Pi

=head1 CONFIGURATION

None needed

=head1 USAGE

Link this plugin to /etc/munin/plugins/ and restart the munin-node.

=head1 INTERPRETATION

The plugin simply shows the PU Temperature on a Raspberri Pi.

=head1 MAGIC MARKERS

  #%# family=auto
  #%# capabilities=autoconf

=head1 VERSION

  $Id$

=head1 BUGS

None known

=head1 AUTHOR

Imran Shamshad <sid@projekt-turm.de>

=head1 LICENSE

# Copyright (C) 2012/2013  Imran Shamshad <sid@projekt-turm.de>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

=cut

#** @file HidTemper.pl 
# @brief Munin plugin for HidTemper temperature.
#* 

#** @class bcm2708_temp
# @brief munin plugin for CPU temperature for Raspberry
#* 


use strict;
use warnings;
use Munin::Plugin;
use Device::USB::PCSensor::HidTEMPer;


#** @var $temp stores HidTemper Object
my $temper = Device::USB::PCSensor::HidTEMPer->new();

#** @var $temp stores stores HidTemper sensor
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
