#!/usr/bin/perl
use lib::sub;
use lib::step_one;
use lib::step_two;
use lib::step_three;
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';
use matrix;
sub::clear;
print N;

#my $matrix=matrix->random(10,5);
my $matrix=matrix->read('lib/E.coli.txt');
$matrix->normalise_rows;
my $gauss=$matrix->multivar_gauss;
$gauss->out;

__END__
my $matrix=matrix->read('all genomes analysis/single.txt');
my $prod=$matrix->distance_matrix;
$prod->display;