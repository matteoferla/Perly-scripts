use strict;
use warnings;
use constant N=>"\n";
use constant T=>"\t";

####################################################################
###### Subs ########################################################
####################################################################

sub in {
	open FILE,$_[0] or die 'could not open '.$_[0].N;
	my @array=<FILE>;
	@array=split(/\r/,$array[0]) if ! $#array;
	close FILE;
	chomp(@array);
	return \@array;
}

####################################################################
###### Main ########################################################
####################################################################

system("clear");
print "Running!\n";

my $g=0;
my @gene;
my $ticker=0;

#open(FILE,'ref_human.gpff');
#print "here\n";
#open(FILE,'test.gpff');

system('cat '.$ARGV[0].' > cated_'.$ARGV[0]);  # The whole newline/return carrige issue.
open(FILE,'cated_'.$ARGV[0]);
foreach my $line (<FILE>) {
	$ticker++; print '.' if ($ticker/10 == int($ticker/10)); print "\n" if ($ticker/500 == int($ticker/500));
	if ($line=~ m/LOCUS\s+(\w+)/) {$gene[$g]->[0]=$1}
	if ($line=~ m/\/gene=\"(.*?)\"/) {$gene[$g]->[1]=$1; print "\n$gene[$g][0] is $gene[$g][1]\n";}
	$g++ if ($line =~ /\/\//);
}

print $ticker.' lines read'.N;

#/gene="LOC650293"

open(OUT,'>'.$ARGV[0].'_genes.txt');
print OUT join("\t",@$_).N foreach (@gene);

print "\nAll Done\n\a";
exit;