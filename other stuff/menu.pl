#!/usr/bin/perl
=Pod
 Authors: MP Ferla and W Patrick, Massey University, NZ
 This is the menu file, which accesses the file aacomp.pm which is the actual working element (the core), in essence this is a test script for the aacomp module.
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

use aacomp;   # call the core
use strict;
use warnings;
use constant T=>"\t"; # Author's personal ideosyncrasy to speed-up typing and settings change (exp. for alarm).
use constant N=>"\n";
use constant A=>"\a"; 
sub::clear(); # the custom package lib/sub.pm contains many general functions, such as this which clears the screen in Mac or Win
if ($ARGV[0]) {print 'Run-time settings change disabled according to commandilne arguments'.N; settings->get('ask',0);}
############## splash screen #######################################
open(FILE,'aacomp/welcome.txt') or print 'Welcome page not found.'.N;
print sub::header('Amino acid Composition Analyser');
print <FILE>;
close FILE;
print sub::header('Menu:');

##############main#######################################

my @options=('Analyse one genome','Analyse many genomes','Analyse/load one genome and generate biased-random sequences','View currently defined settings','Generate names (Practical example of randomly generated strings by Markov chain)');
my @reply=(\&one_genome,\&many_genome,\&random,\&settings::view,\&names);
settings->get('first_question',sub::question('Main menu',\@options,chr(65+settings->get('first_question'))))  if settings->get('ask');
$reply[settings->get('first_question')]->();

settings->save();
print sub::header('All Done').A;
exit;

############ subs ####################################

sub one_genome {
	my $file;
	settings->set('one');
	sub::clear;
	
	my $genome=genome->get();  #genome->get(method,name); if the parameters are omitted settings will be used. method is a number 0=ncbi,1=fasta,2=genbank,3=biocyc,4=file 
	#$genome->cog_filter() if defined settings->get('prot_filter'); 
	
	my $who=$genome->species();
	print 'Genome retrieved '.$who.N;
	$file=settings::get('format_dir')."/$who.txt";
	$genome->savetable() if settings->get('store_table');
	
	my ($stats,$freq)=$genome->stats();
	print sub::header('$genome->stats() returned first a '.$stats->dimensionality.' and a '.$freq->dimensionality);
	undef $genome; # save memory, not overly neccessary
	
	$file=settings::get('write_dir')."/freq $who.txt";
	print 'Frequencies in each gene: '.$file.N;
	$freq->out($file); 
	$file=settings::get('write_dir')."/stats $who.txt";
	$stats->out($file);
	$stats=$stats->transpose();
	$stats=$stats->rank(settings->get('sort_col'));
	$file=settings::get('write_dir')."/sorted stats $who.txt";
	$stats->out($file);
	print 'Above sorted by frequency in file:'.$file.N;
	print 'The following appear most frequently:'.N;
	for (0..9) {print $stats->row_el($_).': '.T.$stats->element($_,0).N;}
	undef $stats;

	$file=settings::get('write_dir').'/probability '.$who.'.txt';
	my $scores=$freq->probability(); #accepts another value which is the threshold for the switch to appromated multivariate
	$scores=$scores->rank(0);
	$scores->out($file);
	print 'Each gene with an assigned probability: '.$file.N;
	
	$file=settings::get('write_dir').'/normal '.$who.'.txt';
	$scores=$freq->normalise(settings->get('maha_threshold')); #accepts another value which is the threshold for the switch to appromated multivariate
	$scores=$scores->rank(0);
	$scores->out($file);
	
	print 'Normalised composition: '.$file.N;
	
	$file=settings::get('write_dir').'/percentile '.$who.'.txt';
	$scores=$scores->percentile();
	$scores->out($file);
	print 'Each gene given percentile: '.$file.N;
}
	
sub many_genome {
	my $file;
	settings->set('many');
	sub::clear;
	
	my @list=genome->org_list();
	my @set;
	foreach my $name (@list) {
		my $genome=genome->get(settings->get('many_get'),$name);
		my $who=$genome->species();
		print 'Genome retrieved '.$who.N;
		$file=settings::get('format_dir')."/$who.txt";
		$genome->savetable() if settings->get('store_table');
		
		my ($stats,$freq)=$genome->stats();
		$file=settings::get('write_dir')."/freq $who.txt";
		print 'Frequencies in each gene: '.$file.N;
		$freq->out($file);
		$file=settings::get('write_dir')."/stats $who.txt";
		$stats->out($file);
		$stats->name($genome->species());
		push(@set,$stats);
	}
	my $regrouped=matrix->regroup(\@set);
	foreach my $matrix (@$regrouped) {
		$file=settings::get('write_dir').'/'.$matrix->name().'txt';
		$matrix->out($file);
	}
	$file=settings::get('write_dir').'/trees.txt';
	my $tree=sub::handle($file);
	print 'Matrices have been rearranged. Proceding to distance matrices'.N;
	foreach my $matrix (@$regrouped) {
		$matrix=$matrix->zscore() if settings->get('normalise');
		my $dist=$matrix->pdist(settings->get('distance'));
		$file=settings::get('write_dir').'/distance matrix from '.$matrix->name().'txt';
		$dist->out($file);
		print $tree $matrix->name().T.$dist->neighbour_join.N if settings->get('make_tree');
	}
}	
	


sub names {
	sub::clear;
	print 'Generate Species? If not will generate protein.'.N;
	my $way='protein';
	if (sub::ask(1)) {$way='species';}
	settings->load_press();
	for (0..99) {print matrix::markov_name_gen($way).N;}
	#alternatively to change some settings by ingnoring the settings file:
	#my $data=matrix::markov_name_train('aacomp/protein list.txt',2); for (0..99) {print matrix::markov_name_gen('custom',$data,6,40,3).N;}
	#the first value in markov_name_train is the file with a first column that it uses to garble. the 0..99 is how many to make, eg. 100. 'custom' overrides default settings and uses $data as the freq list, 6 letters minimum, 15 max, 2 words 
	#protein can have silly long names, 40. and 3 words. when the generator gets stuck it disobeys these rules: 'of' may often appear!
}

sub random {
	sub::clear;
	my $model;
	settings->set('random');
	if (! settings->get('load_file')) {
		my $genome=genome->get();
		my $file=settings::get('format_dir').'/'.$genome->species().'.txt';
		$genome->savetable() if settings->get('store_table');
		my ($stats,$freq)=$genome->stats();
		$model=$stats; #$freq could be used if needed thanks to the row option.
		print 'Data made'.N;
		#Try:
		#my $backwards=genome->flip();
		#my $scrambled=genome->scrambled();
	} else {$model=matrix->read(settings->get('stats_file')); print 'Data loaded'.N;}
	my $genome=$model->random(); #if parameters are ommitted will use rand_method, max_prot and len_prot from settings. 
	$genome->savetable() if settings->get('store_table');
	$genome->savefasta() if settings->get('store_fasta');
}

	


__END__

=head1 NAME

menu

=head1 DESCRIPTION

The menu script provised the user with an easy to use interface to access some of the functionality of the modules presented therefore empowering the user to change the settings without having to read through code.
The user can change several parameters, namely those present in the settings module, which contains three hashes, one containing the values, one the string description and a third subroutine references to change the value in the command line.
The ability to change the settings is settings->set()
which depending on the sub who called it allows to change the keys stored in the opt_random opt_one opt_many