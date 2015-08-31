#!/usr/bin/perl
use lib::sub;
use lib::step_one;
use lib::step_two;
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';

##############part 1#######################################
my @dir_opt=dir_inventory();
my $Working;
my $string;
if (@dir_opt) {$string="\n>\t".join("\n>\t",map((chr(97+$_)."\)\t  $dir_opt[$_]"),0..$#dir_opt));} else {$string="\nN\\A"}
sub::clear;
print '==='x20 .N;
print 'Step one: Creation of list of species to be used in the dataset:'.N;
print '1)'.T.'use pre-existing species dataset: '.$string.N;
print '2)'.T.'Download all complete sequenced genomes'.N;
print '3)'.T.'Create a dataset from Biocyc files (not available ATM)'.N;
print '==='x20 .N;
ASKME:
print 'choice: ';
my $input=sub::ask('1a');
my $max=chr($#dir_opt+97);
if ((not @dir_opt)&&($input=~m/1/)) {print "invalid choice\n"; got ASKME;}
if (($input=~m/1/)||($input=~m/[a-z\D]/)) {
	if ($max eq 'a') {$input='a';}
	while ($input !~ m/[a-$max]/) {print "Letter between a to $max:\t"; $input=sub::ask('a');}
	$input=~ m/([a-$max])/;
	$Working=$dir_opt[ord(lc($1))-97];
}
if ($input=~m/2/) {$Working=step_one::get_all_genomes();}
##############part 1.5#######################################
reset 'a-z'; #save some memory...

##############part 2#######################################
sub::clear;
print '==='x20 .N;
print "Step two: Analyse the dataset $Working:".N;
print 'A)'.T.'Monopeptide composition with statistics (including covariance) - fast'.N;
print 'B)'.T.'Dipeptide composition with statistics - fast'.N;
print 'C)'.T.'Tripeptide composition with statistics - fast'.N;
print 'D)'.T.'Perfect tandem repeats'.N;
print 'E)'.T.'k-string composition with statistics and markov whatever'.N;
print 'F)'.T.'k-string composition without statistics but with markov whatever'.N;
print '==='x20 .N;
$input=sub::ask('A');

if ($input=~/A/i) {step_two::mono($Working);}
elsif ($input=~/B/i) {step_two::di($Working);}
elsif ($input=~/C/i) {step_two::tri($Working);}
elsif ($input=~/D/i) {step_two::tandem($Working);}
elsif ($input=~/E/i) {print "What is the largest k to be analysed?\n"; $input=sub::ask('3'); step_two::kstring($Working,$input);}
elsif ($input=~/F/i) {print "What is the largest k to be analysed?\n"; $input=sub::ask('4'); step_two::largek($Working,$input);}
sub::clear;
print 'All done'.N;



##############sub#######################################
sub dir_inventory {
	my @files=<*>;
	my @okay=();
	foreach (@files) {
		if (-d $_) {if (-e "$_/inventory.txt") {push(@okay,$_);}}
	}
	return @okay;
}