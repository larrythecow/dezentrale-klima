package sensors;

use strict;
use warnings;

use Device::USB::PCSensor::HidTEMPer;
use base 'Exporter';
use Data::Dumper;

#** @var @EXPORT functions which will be exported 
our @EXPORT = qw(checkTemp bcm2708Temp HidTEMPerTemp ds1920Temp);

#** @var $tolerance tolarance between $temp1 and $temp2 
my $tolerance = 3;
#** @var $temp1 temperature which will be compared
my $temp1;
#** @var $temp2 temperature which will be compared
my $temp2;

#** @function public checkTemp ($temp1, $temp2, $tolerance)
# @brief compares two temperature value and return U if they are to different
# @param required $temp1 temperature1
# @param required $temp2 temperature2
# @param optional $tolerance default=3
# @retval "scalar temperature" if no error
# @retval "scalar 'U'" if error
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

#** @function public HidTEMPerTemp ($tolerance)
# @brief HidTEMPer temperature 
# @param optional $tolerance
# @todo add uniqID of sensor to params
# @retval "scalar temperature" if no error
# @retval "scalar 'U'" if error
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

#** @function public bcm2708Temp ($tolerance)
# @brief get bcm2708 temperature 
# @param optional $tolerance default=3
# @retval "scalar temperature" if no error
# @retval "scalar 'U'" if error
#* 
sub bcm2708Temp{
        if( !(-r '/opt/vc/bin/vcgencmd') ){
		return "U";
        }

        if( (defined $_[0]) ){
                $tolerance = $_[0];
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

#** @function public ds1820Temp ($ID, $tolerance)
# @brief DS1820 temperature 
# @param required $ID ID of DS1820
# @param optional $tolerance default=3
# @retval "scalar temperature" if no error
# @retval "scalar 'U'" if error
#* 
sub ds1820Temp{
	open(my $fh, "<", "/sys/bus/w1/devices/$_[0]/w1_slave") or return "U";
	#** @var @temp stores recived string
	my @temp = <$fh>;
	close($fh);

	if( !($temp[1]=~ m\t=(.*)\) ){
		return "U";
	}
	if($1 < -55000 || $1 > 125000){
		return "U";
	}
	else{
		return $1/1000;
	}
}

# A Perl module must end with a true value or else it is considered not to
# have loaded.  By convention this value is usually 1 though it can be
# any true value.  A module can end with false to indicate failure but
# this is rarely used and it would instead die() (exit with an error).
1;

