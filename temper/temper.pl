#!/usr/bin/perl

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

#** @file temper2.pl read temperature from HidTemper and save them 
# @brief saves data to RRD and generates SVG
#* 

use strict;
use warnings;

use RRDs;
use Fcntl;
use FileHandle();
use Device::USB::PCSensor::HidTEMPer;
use Data::Dumper;

#** @var $temper stores sensor object
my $temper = Device::USB::PCSensor::HidTEMPer->new();

#** @var $sensor stores the connected sensor
my $sensor = $temper->device();

#** @var $err saves error
my $err;

#** @var $curTemp stores temperature
my $curTemp;
our $DEBUG = 1;

$sensor->internal(); 

$curTemp = $sensor->internal()->celsius();
print "curTemp: ", join(":", time, $curTemp ), "\n";
print Dumper "sensor: $sensor\n";
print Dumper "temper: $temper\n";

my @test=$temper->list_devices();
print Dumper @test;



