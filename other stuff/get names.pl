
use strict;
use warnings;
use sub;
sub::clear;
use constant T => "\t";
use constant N => "\n";

my @indices=('A'..'Z');
push(@indices,'0-9');
my %journal;


foreach my $letter (@indices) {
	my $file='http://images.isiknowledge.com/WOK46/help/WOS/'.$letter.'_abrvjt.html';
	my $html=sub::got($file);
	$html=~ s/.*<PRE>//smg;
	$html=~ s/<\/PRE>.*//smg;
	$html=~ s/[\t\n\r]//smg;
	$html=~ s/<\/?B>//smg;
	my @lines=split(/<DT>/,$html);
	foreach my $line (@lines) {
		my @pair=split(/<DD>/,$line);
		if ($pair[1]) {$journal{$pair[1]}=$pair[0];}
	}

}

my $issue=0;
open(FILE,'>full names.txt');
print 'there are '.(scalar(keys %journal)+1).' keys'.N;
foreach (keys %journal) {
	if ($journal{$_}) {print FILE $_.T.$journal{$_}.N;} else {$issue++;}
}
print "problems with $issue journals".N;
close FILE;