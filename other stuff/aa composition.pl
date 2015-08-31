#!/usr/bin/perl
use lib::sub;
use lib::step_one;
use lib::composition;
use lib::genome;
use lib::settings;
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";

##############sub#######################################
sub dir_inventory {
	my $name=shift;
	my @files=<*>;
	my @okay=();
	foreach (@files) {
		if (-d $_) {if (-e "$_/$name") {push(@okay,$_);}}
	}
	return @okay;
}
##############main#######################################

#if ($ARGV[0]) {setting->load($ARGV[0]);}
my @dir_inv=dir_inventory("inventory.txt");
my @dir_info=dir_inventory("info.txt");
my $working;
my $def='B';
my $string;
sub::clear;
print '==='x20 .N;
print 'This script, aa composition, performs several analyses based on amino acid composition.
The script accepts different sources, such as NCBI database, BioCyc database, a FASTA file or randomly generated sequences, but must prepare them for analysis (to speed up future analyses and allow merging of multiple sources, which can be done by modifing the inventory.txt file and delete/add a name to the list (all after the tab is ignored) corresponding to the files in the folder without the extension)
Type the letter for the required operation out of the following:'.N;

while (1==1) {
	
	if (@dir_inv) {
		$string="\n>\t".join("\n>\t",map(((1+$_)."\)\t  $dir_inv[$_]"),0..$#dir_inv));
		if (! $working) {$working=$dir_inv[0];}
		$def='E';
	} else {$string="\nN\\A"}
	
	print '==='x20 .N;
	print 'Put together a dataset to analyse'.N;
	print '==='x20 .N;
	print 'A)'.T.'use pre-existing species dataset: '.$string.N;
	print 'B)'.T.'Download all complete sequenced genomes'.N;
	print 'C)'.T.'Create a dataset from Biocyc files'.N;
	print 'D)'.T.'Generate randomly a dataset'.N;
	print '==='x20 .N;
	if ($working) {
		print 'Analyse the dataset "'.$working.'" (option A to D to change)'.N;
		print '==='x20 .N;
		print 'E)'.T.'kstring'.N;
		print 'F)'.T.'largek'.N;
		print 'G)'.T.'tandem'.N;
	}
	print 'Q)'.T.'Exit script'.N;
	
	
	
	my $input=sub::ask($def);
	if ($input=~/(\d+)/) {my $n=abs($1)-1; if ($n<=$#dir_inv) {$working=$dir_inv[$n]; print 'Changed to '.$dir_inv[$n].N;} else {print 'Number too high';}}
	elsif ($input=~/B/i) {step_one::get_all_genomes;}
	elsif ($input=~/C/i) {step_one::biocyc();}
	elsif ($input=~/D/i) {step_one::random();}
	elsif ($input=~/E/i) {composition::kstring($working);}
	elsif ($input=~/F/i) {composition::largek($working);}
	elsif ($input=~/G/i) {composition::tandem($working);}
	else {print 'Unrecognised input'.N;}
	sub::clear;
	print 'DONE.... another operation?'.N
	sub::clear;
}


__END__





print '==='x20 .N;
print 'Part 1... This script will use or create a dataset to be analysed'.N;
print 'Part 2... Will analyse it '.N;
print 'Part 3... Additional analysis, if required'.N;
print 'This is the todo list...
check for the presence of various files. 
Outlying protien.
add a probability section.
Incorporate tree.
PCA and pivot
Add code to skip questions...
'.N;
print '==='x20 .N;
print "\n Press enter to continue\n"; <STDIN>;


##############part 1#######################################

sub::clear;
print '==='x20 .N;
print 'Step one: Creation of list of species to be used in the dataset:'.N;
print 'A)'.T.'use pre-existing species dataset: '.$string.N;
print 'B)'.T.'Download all complete sequenced genomes'.N;
print 'C)'.T.'Create a dataset from Biocyc files'.N;
print 'D)'.T.'Generate randomly a dataset'.N;
print 'NB: To modify a dataset open the inventory.txt file and delete/add a name to the list (all after the tab is ignored) corresponding to the files in the folder without the txt extension)'.N;
print 'Q)'.T.'Exit script'.N;
print '==='x20 .N;
ASKME:
print 'choice: ';
my $input=uc(sub::ask('A1'));
my $max=1+$#dir_opt;
if ($input=~m/[eq]/i) {exit;}
if ((not @dir_opt)&&(($input=~m/A/)||($input=~m/\d/))) {print "invalid choice\n"; goto ASKME;}
if (($input=~m/A/)||($input=~m/\d/)) {
	if ($max==1) {$input='1';}
	while ($input !~ m/[1-$max]/) {print "Number between 1 and $max inclusive:\t"; $input=sub::ask('1');}
	$input=~ m/(\d+)/;
	$Working=$dir_opt[$1-1];
}
if ($input=~m/B/) {$Working=step_one::get_all_genomes();}

if ($input=~m/C/) {$Working=step_one::biocyc();}
if ($input=~m/D/) {$Working=step_one::random();}
##############part 1.5#######################################
TIMEWARP:
reset 'a-z'; #save some memory...

##############part 2#######################################

sub::clear;
print '==='x20 .N;
print "Step two: Analyse the dataset $Working:".N;
print 'A)'.T.'kstring'.N;
print 'B)'.T.'largek'.N;
print 'C)'.T.'tandem'.N;
print 'Q)'.T.'Exit script'.N;
print '==='x20 .N;
$input=sub::ask('A');


   if ($input=~/A/i) {composition::kstring($Working);}
elsif ($input=~/B/i) {composition::largek($Working);}
elsif ($input=~/C/i) {composition::tandem($Working);}
elsif ($input=~/Q/i) {exit;}
else {goto TIMEWARP;}
sub::clear;
print '==='x20 .N;
print 'All done'.N;
print 'Do you require another operation before proceeding?'.N;
my $input=sub::ask_yn(0);
if ($input) {goto TIMEWARP;}

##############part 3#######################################

sub::clear;
print '==='x20 .N;
print "Step three: Analyse further some files".N;
print 'A)'.T.'N\A: Pivot table: Distribution of values'.N;
print 'B)'.T.'N\A: Principal Component Analysis'.N;
print 'C'.T.'Ranking of protein according to distance from mean'.N;
print 'D'.T.'N\A: Generate a tree based on taxonomy with polytomies'.N;
print 'Q)'.T.'Exit script'.N;
print '==='x20 .N;
$input=sub::ask('A');

#elsif ($input=~/C/i) {step_three::mahalobis($Working);}





