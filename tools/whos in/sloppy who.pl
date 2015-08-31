open(PROBE,'table_probe.txt') 	or die "Bummer, can't open file: $!";
open(TARGET,'table_target.txt') 	or die "Bummer, can't open file: $!";
open(OUT,'>table_out.txt') 	or die "Can't open file: $!";
print "Hello World\n";
$matchee=0;
$matcher=0;

@comparer=<PROBE>;
chomp(@comparer);
if ($#comparer<2) {
	@temp=split(/\r/,$comparer[0]);
	@tempo=split(/\r/,$comparer[1]); #pretty sure cannot be.
	@comparer=@temp;
	push(@comparer,@tempo);
}

@comparee=<TARGET>;
chomp(@comparee);
if ($#comparee<2) {
	@temp=split(/\r/,$comparee[0]);
	@tempo=split(/\r/,$comparee[1]); #pretty sure cannot be.
	@comparee=@temp;
	push(@comparee,@tempo);
}
foreach (@comparer) {
	m/^(\w* \w*)/;
	$_=uc($1);
}
foreach (@comparee) {
	m/^(\w* \w*)/;
	$_=uc($1);
}




print OUT "unmatched probes\n";
for $n (0..$#comparer) {
	for $m (0..$#comparee) {
		if ($comparer[$n] eq $comparee[$m]) {$matcher++; goto WELL;}
	}
	print OUT $comparer[$n]."\n";
WELL:
}

print "probes matched $matcher\n";

print OUT "unmatched targets\n";
for $m (0..$#comparee) {
	for $n (0..$#comparer) {
		if ($comparer[$n] eq $comparee[$m]) {$matchee++; goto DITCH;}
	}
	print OUT $comparee[$m]."\n";
DITCH:
}

print "probes matched $matchee\n";

print OUT "matched probes\n";
for $m (0..$#comparee) {
	for $n (0..$#comparer) {
		if ($comparer[$n] eq $comparee[$m]) {$matchee++; print OUT $comparee[$m]."\n"; goto TRENCH;}
	}
TRENCH:
}


