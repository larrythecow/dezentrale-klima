package sensors;
use strict;
use warnings;
use Device::USB::PCSensor::HidTEMPer;
use base 'Exporter';

#** @var @EXPORT DESCTIPTION!!!!!!!!!!!!!!!!!N!!!!!!!!!!!!!!!!!
our @EXPORT = qw(checkTemp bcm2708Temp HidTEMPerTemp);

#** @var $tolerance tolarance between $temp1 and $temp2 
my $tolerance = 3;
#** @var $temp1 temperature which will be compared
my $temp1;
#** @var $temp2 temperature which will be compared
my $temp2;

#** @method public checkTemp ($_[0] $_[1] $_[2])
# @brief compares tow temperature value and return U if they are to different
# @param required $_[0] temperature1
# @param required $_[1] temperature2
# @param optional $_[2] tolerance, default=3
# @retval 'float NUM' if no error
# @retval 'char U' if error
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

#** @function public HidTEMPer_temp ($_[0])
# @brief HidTEMPer temperature 
# @param optional $_[0] tolerance
# @todo add uniqID of sensor to params, print warnings and check if they are in logs, add optional sleep
# @retval 'float NUM' if no error
# @retval 'char U' if error
#* 
sub HidTEMPerTemp{
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

#** @function public bcm2708Tempi ($_[0])
# @brief get bcm2708 temperature 
# @param optional $_[0] tolerance
# @retval 'float NUM' if no error
# @retval 'char U' if error
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

