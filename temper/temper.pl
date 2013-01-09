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

use strict;
use warnings;

use Fcntl;
use FileHandle();
#use Carp;
#use Device::USB;
use Device::USB::PCSensor::HidTEMPer;
#use Device::USB::PCSensor::HidTEMPer::Device;
#use Device::USB::PCSensor::HidTEMPer::NTC;
#use Device::USB::PCSensor::HidTEMPer::TEMPer; 
#use lib;

my $temper = Device::USB::PCSensor::HidTEMPer->new();
my $sensor = $temper->device();
my $err;
my $filename ="office";
my $curTemp;
my $createDB=0;
my $graphWith=500;
my $graphHeight=200;
my $graphStart=1353594690;
my $graphFGColor="#ffffff";
my $graphBGColor="#000000";

if( defined $sensor->internal() ) {
    print "Temperature: ",
    $sensor->internal()->celsius(),
    "\n";
    }

if ($createDB==1){
    $err = system(
        "rrdtool", "create", 
        join(".", $filename, "rrd"), 
        "--step", "30",
        "DS:sensor1:GAUGE:60:-273:5000",
        "RRA:MIN:0:360:576", 
        "RRA:MIN:0:30:576", 
        "RRA:MIN:0:7:576",
        "RRA:AVERAGE:0:360:576", 
        "RRA:AVERAGE:0:30:576",
        "RRA:AVERAGE:0:7:576",
        "RRA:AVERAGE:0:1:576",
        "RRA:MAX:0:360:576", 
        "RRA:MAX:0:30:576",
        "RRA:MAX:0:7:576"
    );
    print "DB Created\n";
}

while(1)
{
    $curTemp = $sensor->internal()->celsius();

    system(
        "rrdtool", "update", 
        join(".", $filename, "rrd"),
        join(":" , time, $curTemp )
        );

    system(
        "rrdtool", "graph", 
        join(".", $filename, "svg"),
        join("=", "--imgformat", "SVG"), 
        "--title", join(" ", "Temperatur",$filename),
        "--vertical-label", "Celsius",
        join("=", "--start", $graphStart),
        join("=", "--height", $graphHeight),
        join("=", "--width", $graphWith),
        join("=", "--color", join("", "CANVAS", $graphBGColor) ),
        join("=", "--color", join("", "BACK", $graphBGColor) ),
        join("=", "--color", join("", "FONT", $graphFGColor) ),
        
        join("=", "--color", join("", "MGRID", "#0000ff") ),

        "DEF:sensor1_AVG=office.rrd:sensor1:AVERAGE",
        "DEF:sensor1_MIN=office.rrd:sensor1:MIN",
        "DEF:sensor1_MAX=office.rrd:sensor1:MAX",
    
        "CDEF:temp1_AVG=sensor1_AVG",
        "CDEF:temp1_MIN=sensor1_MIN",
        "CDEF:temp1_MAX=sensor1_MAX",
    
        "AREA:temp1_MAX#00ff00:MIN/MAX",
        "AREA:temp1_MIN#000000",
        "LINE1:temp1_AVG#ff0000:AVG",

#        join(":", "HRULE", "30#000000", "Max Limit"),
#        join(":", "HRULE", "22#000000", "Min Limit")
        );

    print "curTemp: ", join(":" , time, $curTemp ) , "\n";
    sleep 15;
}
