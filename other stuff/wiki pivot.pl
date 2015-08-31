use strict;
use constant T=>"\t";
use constant N=>"\n";
use sub;
use strict;
use warnings;


my %master=();
my $blank='human';

for my $n (0..20) {
	sub::clear;
	print N.N.$n.N.N;
	
	my @edit=sub::table(sub::readfile("out_$n.txt"));
	for my $a (0..$#edit) {if (! $edit[$a][8]) {$edit[$a][8]=$blank;}}
	my ($pref,$rref,$cref,$total)=sub::pivot(\@edit,1,8);
	my %pivot=%$pref;
	my @ik=sub::inkeys(\%pivot);
	foreach my $k (keys %pivot) {
		foreach my $j (@ik) {
			if ($master{$k}{$j}) {$master{$k}{$j}+=$pivot{$k}{$j}} else {$master{$k}{$j}=$pivot{$k}{$j};}
		}
	}

}

my @ik=sub::inkeys(\%master);
open(FILE,'>pivoted.txt');
foreach my $j (@ik) {print FILE $j;} print FILE N;
foreach my $k (sort { $master{$b}{$blank} <=> $master{$a}{$blank}} keys %master) {
	print FILE $k.T;
	foreach my $j (@ik) {if ($master{$k}{$j}) {print FILE $master{$k}{$j}.T;} else {print FILE T;}} print FILE N;
}
close FILE;


my @list=map([(int(log10($master{$_}{'bot'})),int(log10($master{$_}{$blank})))],keys %master);
my $ref=sub::fpivot('distribution.txt',\@list,0,1);
print 'done'.N;
exit;

sub log10 {
	my $n=shift;
	if ($n==0) {return 'NaN';}
	return log($n)/log(10);
}