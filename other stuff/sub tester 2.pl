#!/usr/bin/perl

use lib::sub;
use lib::genome;

sub::clear;
#http://www.ncbi.nlm.nih.gov/nuccore/256383638
my $mmycoides=genome->genbank('sequence.txt');
print $mmycoides->size;




__END__
use lib::sub;
use lib::step_one;
use lib::step_two;
use lib::step_three;
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';
use matrix;
sub::clear;
sub::clear;
print N;



sub {
	my ($kstring,$dstring,$letter)=@_;
	my $k=length($letter);
	my $x=substr($letter,0,$k-1); if ($kstring->{$x}==0) {die "Error x: $letter: $kstring->{$letter}, but $x\: $kstring->{$x}\n";}
	my $y=substr($letter,1,$k-1); if ($kstring->{$y}==0) {die "Error y: $letter: $kstring->{$letter}, but $y\: $kstring->{$y}\n";}
	if ($k==2) {
		$pstring{$letter}=$kstring{$x}*$kstring{$y};
		$sstring{$letter}=($dstring{$x}*$dstring{$y})**2+($dstring{$x}*$kstring{$y})**2+($kstring{$x}*$dstring{$y})**2;
	}	
	else {
		my $z=substr($letter,1,$k-2); if ($kstring{$z}==0) {die "Division by zero forecast: $letter: $kstring{$letter}, but $z: $kstring{$z}\n";}
		
		$pstring{$letter}=$kstring{$x}*$kstring{$y}/$kstring{$z};
		$sstring{$letter}=((
		$kstring{$x}+$kstring{$y}
		)/$kstring{$z}
		)**2
		*(($dstring{$x}*$dstring{$y})**2
		+($dstring{$x}*$kstring{$y})**2
		+($kstring{$x}*$dstring{$y})**2
		/($kstring{$x}+$kstring{$y})**2
		+($dstring{$z}/$kstring{$z})**2);
		
	}
	return ($pstring,$sstring);
}