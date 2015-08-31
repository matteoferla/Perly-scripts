use strict;
use constant T=>"\t";
use constant N=>"\n";
use sub;
use strict;
use warnings;


my %master=();


for my $n (0..20) {
	sub::clear;
	print N.N.$n.N.N;
	
	my @edit=sub::table(sub::readfile("out_$n.txt"));
	my $pref=sub::pivot(\@edit,1);
	my %pivot=%$pref;
	my @ik=sub::inkeys(\%pivot);
	foreach my $k (keys %pivot) {
		if ($master{$k}) {$master{$k}+=$pivot{$k}} else {$master{$k}=$pivot{$k};}
	}

}
open(FILE,'>pivoted.txt');
foreach my $k (sort { $master{$b} <=> $master{$a}} keys %master) {
 print FILE "$k\t$master{$k}\n";
}
close FILE;

my @list=map(int(log($master{$_})),keys %master);
my $ref=sub::pivot(\@list);
my %hash=%$ref;
open(FILE,'>distribution.txt');
foreach my $k (sort keys %hash) {
	print FILE "$k\t$hash{$k}\n";
}
close FILE;

print 'done'.N;
exit;