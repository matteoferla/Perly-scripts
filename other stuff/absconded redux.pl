#!/usr/bin/perl


my $timer=time();
$file='>redux_list.txt';
open(OUT,$file) or die "Can't make file: $!";
$file='>redux_cog.txt';
open(COG,$file) or die "Can't make file: $!";
$file='>redux_gi.txt';
open(GI,$file) or die "Can't make file: $!";
$file='prok_out.txt';
open(OLD,$file) or die "Can't make file: $!";
@org=<OLD>;
close(OLD);
chomp(@org);
@alr=map(0,(0..$#org));
@met=map(0,(0..$#org));
for $x (0..$#org) {
	$what="";
	$issue=0;
	$orgtab[$x]=[split(/\t/,$org[$x])];
	$who=$orgtab[$x][1];
	$file='genomes/'.$who.'.txt';
	open(READ,$file) or print "ATTENTION: Can't read file of $who: $!\n";
	@seq=<READ>;
	chomp(@seq);
	close READ;
	foreach (@seq) {
		if (/COG0787/) {$alr[$x]++;} else {if (/alanine racemase/i) {
			#print "ATTENTION: An annotated non-homologous alanine racemase spotted in $who\n $_\n".(10x"\-");
			$issue++; $what.="$_\t";
			@temp=split(/\t/); push(@gi,$temp[5]); print GI $temp[5]."\n";
			if (/(COG\d+\w+)/) {$cog{$1}++;}
		}}
		if (/COG0626/) {$met[$x]++;}
	}
	if ($issue>0) {print OUT "$who\t$alr[$x]\t$met[$x]\t$issue\t$org[$x]\t$what\n";}
}

foreach (sort(keys %cog)) {
	print COG "$_\t$cog{$_}\n";
}
