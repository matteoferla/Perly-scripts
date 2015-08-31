my @hydro=qw(1.8 2.5 -3.5 -3.5 2.8 -0.4 -3.2 4.5 -3.9 3.8 1.9 -3.5 -1.6 -3.5 -4.5 -0.8 -0.7 4.2 -0.9 -1.3);
my @abc=qw(A C D E F G H I K L M N P Q R S T V W Y);
print @abc."\n";
foreach my $m (0..$#abc) {
	foreach my $n (0..$#abc) {
		print $abc[$m].$abc[$n]."\t".abs($hydro[$m]-$hydro[$n])."\n";
	}
}