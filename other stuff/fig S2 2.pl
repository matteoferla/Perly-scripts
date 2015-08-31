use aacomp;   # call the core
use strict;
use warnings;

settings->get('ask',0); #no questions asked. Redundant as unless parameters are omitted settings file is actually not used.
my $genome=genome->fasta('demo/E.coli.fasta'); #read fasta
my $freq=$genome->freq(max=>1,gene_tag=>'name',freq=>1); #k=1, label by names, local frequencies 20aa Alphabet is taken from settings.
my $dist=$freq->distributions(1000); # calculates the distributions (a form of crosstabulation) in 500 intevals
$dist->out('figure S2 table.txt');
print "All done\n\a";
exit;