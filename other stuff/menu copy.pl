#!/usr/bin/perl
=Pod
 Authors: MP Ferla and W Patrick, Massey University, NZ
 This is the menu file, which accesses the file aa_comp.pm which is the actual working element, in essence a test script for the aa_comp module.
 It functions to give a menu to the user, whereas if a custom script is written to use that module it should use aa_comp which relies on several other packages.
 These are:
 =head1 settings
 Settings is a package which enpowers the user to change the settings without much having to read any code by changing the table in settings.txt.
 =head1 genome
 The genome object contains names and sequences of a genome.
 Note: the method $genome->freq() returns a matrix object (frequencies for each gene) and $genome->stats() returns 2 matrix objects (a table of stats and the frequencies for each gene)
 =head1 matrix
 The matrix object is a matrix and several methods are present to perform mathematical calculations.
=cut

use lib::aa_comp;   # settings file is necessary to call all packages needed
use strict;
use warnings;
use constant T=>"\t"; # Author's personal ideosyncrasy to speed-up typing
use constant N=>"\n";
use constant A=>"\a";

sub::clear(); # the custom package lib/sub.pm contains many general functions, such as this which clears the screen in Mac or Win


open(FILE,'todo.txt') or die;
print <FILE>;
close FILE;


##############main#######################################

my @options=('Analyse one genome','Analyse many genomes','View all settings','Generate names');
my @reply=(\&one_genome,\&many_genome,\&settings::view,\&names);
&{$reply[sub::question('Main menu',\@options,settings->get('first_question'))]}();

exit;



sub one_genome {
	settings->set('one',1);
	settings->get('max',2);
	
	my @get=(\&genome::ncbi,\&genome::fasta,\&genome::genbank,\&genome::biocyc,\&genome::file);
	my $name=settings->get('one_get_name');
	if (settings->get('one_get')==0) {composition->pick_address();} #NCBI requires an internet address
	
	my $genome=&{$get[settings->get('one_get')]}('genome',$name);
	print 'Genome retrieved'.N;
	my ($stats,$freq)=$genome->stats();
	die 'od"ed'.N;
	
	#due to memory issues, the data from composition::analysis is saved to a file and reaccessed.
	my $file=composition::analysis($genome,settings->get('max'));
	my $who=$genome->species();
	undef $genome; # save memory
	
	settings->get('no_scale',1); #on for now!!!
	print 'Forced to deactivate scaling!'.N;
	my $gentable=matrix->read(settings::get('write_dir')."/freq $who.txt",2);
	my $scores=matrix::append(
	$gentable->multivar_gauss(settings->get('no_scale')),
	$gentable->gauss(settings->get('no_scale')));
	$scores->out(settings::get('write_dir').'/probability '.$who.'.txt');
	
	
	my $data=matrix->read($file,2); # two rows of header
	print 'Amino acids counted etc. data in file:'.$file.N;

	$data=$data->rank(settings->get('sort_col')); #sort in descending order
	$file=settings::get('write_dir').'/sorted stats '.$who.'.txt';
	$data->out($file); #the matrix method out uses sub::handle which returns the handle of the string, the handle if a handle is given or STDOUT if nill.
	print 'Above sorted by frequency in file:'.$file.N;
	print 'The following appear most frequently:'.N;
	for (0..9) {print ${$data->rowhead()}[$_].': '.T.$data->element($_,0).N;}
	
	my $pivot=$data->pivot(settings->get('pivot_col')); #pivot based on column 0
	$file=settings::get('write_dir').'/pivot '.$who.'.txt';
	$pivot->out($file);

}

sub many_genome {
	
}

sub names {
	print 'Generate Species? If not will generate protein.'.N;
	if (sub::ask(1)) {my $data=random::markov_name_train('lib/species list.txt',1); for (0..99) {print random::markov_name_gen('custom',$data,6,15,2).N;}} #the first value in markov_name_train is the file with a first column that it uses to garble. the 0..99 is how many to make, eg. 100. 'custom' overrides default settings and uses $data as the freq list, 6 letters minimum, 15 max, 2 words 
	else {my $data=random::markov_name_train('lib/protein list.txt',2);for (0..99) {print random::markov_name_gen('custom',$data,6,40,3).N;}} #protein can have silly long names, 40. and 3 words. when the generator gets stuck it disobeys these rules: 'of' may often appear!
}



__END__




my $string;
print '==='x20 .N;
print 'This script, aa composition, performs several analyses based on amino acid composition.
The script accepts different sources, such as NCBI database, BioCyc database, a FASTA file or randomly generated sequences, '.
'but must prepare them for analysis (to speed up future analyses and allow merging of multiple sources, which can be done by modifing the inventory.txt'.
' file and delete/add a name to the list (all after the tab is ignored) corresponding to the files in the folder without the extension)
Type the letter for the required operation out of the following:'.N;
my $repeat=1;
while ($repeat==1) {
	if (@{settings::get('possible_inv')}) {
		$string="\n>\t".join("\n>\t",map(((1+$_)."\)\t  ${settings::get('possible_inv')}[$_]"),0..$#{settings::get('possible_inv')}));
		if (! settings::get('format_dir')) {settings::get('format_dir',${settings::get('possible_inv')}[0]);}
		settings->get('first_question','E'); # change default to E
	} else {$string="\nN\\A"}
	
	print '==='x20 .N;
	print 'Put together a dataset to analyse'.N;
	print '==='x20 .N;
	print 'A)'.T.'use pre-existing species dataset: '.$string.N;
	print 'B)'.T.'Download all complete sequenced genomes'.N;
	print 'C)'.T.'Download one complete sequenced genomes'.N;
	print 'D)'.T.'Create a dataset from Biocyc files'.N;
	print 'E)'.T.'Generate randomly a dataset'.N;

	if (settings::get('format_dir')) {
		print '==='x20 .N;
		print 'Calculate frequencies etc for the dataset "'.settings::get('format_dir').'" (option A to D to change)'.N;
		print '==='x20 .N;
		print 'F)'.T.'kstring'.N;
		print 'G)'.T.'largek'.N;
		print 'H)'.T.'tandem'.N;
	}
	
	if (settings::get('possible_info')) {
		print '==='x20 .N;
		print 'Analyse further a genome/dataset'.N;
		print '==='x20 .N;
		print 'I)'.T.'Calculate distances and probabilities of a genome'.N;
		print 'J)'.T.'Calculate principal components'.N;
		print 'K)'.T.'Calculate the distribution of values'.N;
		print 'L)'.T.'Calculate distance matrix and NJ tree'.N
	}
	
	print '==='x20 .N;
	print 'Other'.N;
	print '==='x20 .N;
	#print 'X)'.T.'Generate species names by Markov chain'.N;
	#print 'Y)'.T.'Generate protein names by Markov chain'.N;
	print 'Q)'.T.'Exit script'.N;
	
	print '==='x20 .N;
	
############## PROCESS REPLY #######################################
	my $input=sub::ask(settings->get('first_question'));
	if ($input=~/(\d+)/) {my $n=abs($1)-1; if ($n<=$#{settings::get('possible_inv')}) {settings::get('format_dir',${settings::get('possible_inv')}[$n]); print 'Changed to '.${settings::get('possible_inv')}[$n].N;} else {print 'Number too high';}}
	elsif ($input=~/B/i) {settings->set('get_all_genomes',1); composition::get_all_genomes();} # the 1 means it will ask about settings.
	elsif ($input=~/B/i) {settings->set('get_all_genomes',1); composition::get_one_genomes();}
	elsif ($input=~/D/i) {settings->set('get_all_biocyc',1);  composition::get_all_biocyc();}
	elsif ($input=~/E/i) {settings->set('random',1);  random::make();}
	elsif ($input=~/F/i) {settings->set('kstring',1);  composition::kstring();}
	elsif ($input=~/G/i) {settings->set('largek',1);  composition::largek();}
	elsif ($input=~/H/i) {settings->set('tandem',1);  composition::tandem();}
	elsif ($input=~/J/i) {further::pca();}
	elsif ($input=~/J/i) {further::pca();}
	elsif ($input=~/K/i) {further::pivot();}
	elsif ($input=~/L/i) {settings->set('linkage',1); further::linkage();}
		else {print 'Unrecognised input'.N;}
	
	print 'DONE... another operation?'.N.A;
	$repeat=sub::ask_yn(0);
	sub::clear();
}
