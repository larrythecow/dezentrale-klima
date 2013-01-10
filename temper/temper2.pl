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

<<<<<<< HEAD
#** @file temper2.pl 
# ........
=======
#** @file temper2.pl read temperature from HidTemper and save them 
# @brief saves data to RRD and generates SVG
>>>>>>> c1eae4a8ecbd8cf028f8709fc731fd732c0118dc
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

#** @var $DEBUG flag
our $DEBUG=1;

#** @var rrd configuration
our %config =( 
    (filename       => "office"),
    (createDB       => 0),
    (graphWith      => 500),
    (graphHeight    => 200),
    (graphStart     => "-1d"),
    (graphEnd       => "+1d"),
    (graphCANVAS    => "#000000"),  # BG color graph
    (graphBACK      => "#222222"),  # BG color border
    (graphFONT      => "#ffffff"),  
    (graphMGRID     => "#0000ff"),  # main grid color
    (graphFormat    => "svg")
    );

#** @function public param @ARGV
# ....
#*    
sub param(){
    foreach(@ARGV){
        my @tmp= split("=", "$_");
        if(defined $config{$tmp[0]}){
            $config{$tmp[0]} = $tmp[1];
            }
        else{
            die print "$tmp[0] undefined\n";
            }
        }

    if($DEBUG){
        print "#### config ####\n";
        foreach my $name(sort keys %config){
            print "$name <=> $config{$name}\n";
        }
        print "################\n\n";
    }
}

sub createDB(){
    if ($config{createDB}==1){
        RRDs::create(
        join(".", $config{filename}, "rrd"),
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
        $err=RRDs::error;
        die "ERROR while creating DB: $err\n" if $err;
        print join(" ", "DB", join(".", $config{filename}, "rrd"), "created");
        }
    }

sub drawGraph(){
    RRDs::graph(
        join(".", $config{filename}, lc($config{graphFormat}) ),
        join("=", "--imgformat", uc($config{graphFormat}) ),  
        "--title", join(" ", "Temperatur",$config{filename}),
        "--vertical-label", "Celsius",
        join("=", "--start", $config{graphStart}),
        join("=", "--end", $config{graphEnd}),
        join("=", "--height", $config{graphHeight}),
        join("=", "--width", $config{graphWith}),
     
        join("=", "--color", join("", "CANVAS", $config{graphCANVAS}) ),
        join("=", "--color", join("", "BACK", $config{graphBACK}) ),
        join("=", "--color", join("", "FONT", $config{graphFONT}) ),
        join("=", "--color", join("", "MGRID", $config{graphMGRID}) ),

        "DEF:sensor1_AVG=office.rrd:sensor1:AVERAGE",
        "DEF:sensor1_MIN=office.rrd:sensor1:MIN",
        "DEF:sensor1_MAX=office.rrd:sensor1:MAX",

        "CDEF:temp1_AVG=sensor1_AVG",
        "CDEF:temp1_MIN=sensor1_MIN",
        "CDEF:temp1_MAX=sensor1_MAX",

        "AREA:temp1_MAX#00ff00:MIN/MAX",
        "AREA:temp1_MIN#000000",
        "LINE1:temp1_AVG#ff0000:AVG",
        );
    die "ERROR while graph $err\n" if $err; 
    }

sub checkSensor(){
    if( defined $sensor->internal() ) {
        }
}

sub updateDB(){
    RRDs::update(
        join(".", $config{filename}, "rrd"),
        join(":" , time, $curTemp )
        );
    die "ERROR while updating: $err\n" if $err;
}

param();
checkSensor();
createDB();

while (1) {
    $curTemp = $sensor->internal()->celsius();

    updateDB();
    drawGraph();
    print "curTemp: ", join(":", time, $curTemp ), "\n";
    sleep 15;
}
