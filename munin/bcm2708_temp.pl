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

GPLv2

=cut

#** @file bcm2708_temp.pl 
# @brief munin plugin for CPU temperature for Raspberry
#* 
  
#** @class bcm2708_temp
# @brief munin plugin for CPU temperature for Raspberry
#* 

use Munin::Plugin;
use strict;
use warnings;

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
} 
else {
	#** @var $temp stores unformated temperature string
	my $temp = `/opt/vc/bin/vcgencmd measure_temp`;
	#my @a = $temp =~ /^temp=(.*)'C$/;
	# print $a[0];
	$temp =~ m/^temp=(.*)'C$/;
	print "cpu.value ", $1;
}
