# "package" is the namespace where the module's functionality/data resides. 
# It dictates the name of the file if you want it to be "use"d.
# If more than one word, it constrains the location of the module.

package sensors;
use strict;
use warnings;
use Device::USB::PCSensor::HidTEMPer;

our $VERSION = '0.0.1';

# Inherit from the "Exporter" module which handles exporting functions.
# Most procedural modules make use of this.

use base 'Exporter';

# When the module is invoked, export, by default, the function "hello" into 
# the namespace of the using code.

our @EXPORT = qw(checkTemp bcm2708Temp);

# Lines starting with an equal sign indicate embedded POD 
# documentation.  POD sections end with an =cut directive, and can 
# be intermixed almost freely with normal code.

=head1 NAME

sensors - An encapsulation for several sensors

=head1 AUTHOR

Imran Shamshad <sid@projekt-turm.de>

=head1 SYNOPSIS

use sensors;
print hello();
print hello("Milky Way");

=head1 DESCRIPTION

This is a procedural module which gives you the famous "Hello, world!"
message, and it’s even customizable!

=head2 Functions

The following functions are exported by default

=head3 hello

 print hello();
 print hello($target);

Returns the famous greeting.  If a C<$target> is given it will be used,
otherwise "world" is the target of your greeting.

=cut

#** @var $tolerance stores tolarance between two measures 
my $tolerance = 3;

#** @var $temp1 first temperature which will be compared
my $temp1;

#** @var $temp2 second temperature which will be compared
my $temp2;

#** @function public checkTemp $_[0] $_[1] $_[2]
# @brief compares tow temperature value and return U if they are to different
# @params required $_[0] temperature1
# @params required $_[1] temperature2
# @params optional $_[2] tolerance, default=3
#* 
sub checkTemp{
	if( (defined $_[2]) ){
		$tolerance = $_[2];
	}

	if( (!defined $_[0]) or (!defined $_[1]) ){
		die '$_[0]', " or ", '$_[1]', " not commited";
	}

	if( (($_[0]-$_[1]) > $tolerance) or (($_[0]-$_[1]) < -$tolerance) ){
		return "U";
	}

	else{
		return ($_[0]+$_[1])/2;
	}
}

#** @function public HidTEMPer_temp
# @brief get HidTEMPer temperature 
# @params optional $_[0] tolerance
# @todo add uniqID of sensor to params, print warnings and check if they are in logs, add optional sleep
# if todo is not displayed check this comment
#* 
sub HidTEMPer_temp{
	if( (defined $_[2]) ){
		$tolerance = $_[2];
	}	

	#** @var $temper stores HidTEMPer Object
	my $temper = Device::USB::PCSensor::HidTEMPer->new();
	if(!defined $temper){
		return "U";
	}

	#** @var $sensor stores HidTEMPer Sensor
	my $sensor = $temper->device();
	if(!defined $sensor){
		return "U";
	}
	
	$temp1 = $sensor->internal()->celsius();
	sleep(1);
	$temp2 = $sensor->internal()->celsius();

	if( (!defined $temp1) or (!defined $temp2) ){
		return "U";
	}
	
	return (checkTemp($temp1, $temp2, $tolerance));
}

#** @function public bcm2708Temp
# @brief get bcm2708 temperature 
# @params optional $_[0] tolerance
#* 
sub bcm2708Temp{
        if( !(-r '/opt/vc/bin/vcgencmd') ){
		return "U";
        }
	
	$temp1 = `/opt/vc/bin/vcgencmd measure_temp`;
	sleep(1);
	$temp2 = `/opt/vc/bin/vcgencmd measure_temp`;

        if( !($temp1 =~ m/^temp=(.*)'C$/) ){
		return "U";
        }
        else{
		$temp1 = $1;
        }

        if( !($temp2 =~ m/^temp=(.*)'C$/) ){
		return "U";
        }
        else{
		$temp2 = $1;
        }


        return (checkTemp($temp1, $temp2, $tolerance));
}


# A Perl module must end with a true value or else it is considered not to
# have loaded.  By convention this value is usually 1 though it can be
# any true value.  A module can end with false to indicate failure but
# this is rarely used and it would instead die() (exit with an error).
1;

