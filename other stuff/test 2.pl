use this;
use that;
use strict;
use warnings;
use constant N=>"\n";
our $greeting;


this::foo();

#print $this::reply.N;

#my @farm=qw(cow sheep);

#foreach (@farm) {my $temp=\&{"noise_$_"}; &$temp($_);}
my $hero='superman';
this->change($hero)='batman';
#print 'I love '.$hero.N;

sub noise_cow {
	my $x=shift;
	print $x.' Mooo'.N;
}

sub noise_sheep {
	my $x=shift;
	print $x.' Baa'.N;
}





