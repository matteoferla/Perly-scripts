#!/usr/bin/perl
use utf8;
use sub;
use strict;
use warnings;
sub::clear;

use constant T => "\t";
use constant N => "\n";

my @header=('Abbreviated Journal Title','ISSN','{2009} Total Cites','Impact Factor','5-Year Impact Factor','Immediacy Index','{2009} Articles','Cited Half-Life','Eigenfactor Score','Article Influence Score');

my $refj=get_impact();
my %paper=%$refj;
my ($reff,$refa)=read_abbrev();
my %abb=%$refa;
my %full=%$reff;
open(FILE,'>impact.txt');
foreach (sort keys %paper) {
	print FILE $_.T.$full{$_};
	foreach my $n (1..$#header) {print FILE T.$paper{$_}{$header[$n]};}
	print FILE N;
}
close FILE;
print "This is the Impact factor for plant biotechnology journal ".$paper{'PLANT BIOTECHNOL J'}{'Impact Factor'}."\n";

sub get_impact {
	my %journal;
	my @header=('Abbreviated Journal Title','ISSN','{2009} Total Cites','Impact Factor','5-Year Impact Factor','Immediacy Index','{2009} Articles','Cited Half-Life','Eigenfactor Score','Article Influence Score');
	my @files=<JCR/*>;
	
	foreach my $file (@files) {
		my @list=sub::readfile($file);
		foreach (@list) {
			my @tab=split(/;/);
			if (@tab) {
				foreach my $n (1..$#header) {$journal{$tab[0]}{$header[$n]}=$tab[$n];}
			}
		}
	}
	return \%journal;
}

sub get_oldname {
my %changer;
my @namechange=sub::readfile('name change.txt');

foreach (@namechange) {
	my @tab=split(/\t/);
	if ($tab[1]=~ /changed to/) {$changer{$tab[0]}=$tab[2];}
	if ($tab[1]=~ /changed from/) {$changer{$tab[2]}=$tab[0];}
	if ($tab[1]=~ /merged into/) {$changer{$tab[2]}=$tab[0];}
}
	return \%changer;
}

sub read_abbrev {
	my %full;
	my %abb;
	my @list=sub::readfile('full names.txt');
	foreach my $n (@list) {my @pair=split(/\t/,$n); $abb{$pair[1]}=$pair[0]; $full{$pair[0]}=$pair[1];}
	return (\%full,\%abb);
}


sub get_abbrev {
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
	
	return \%journal;	
}