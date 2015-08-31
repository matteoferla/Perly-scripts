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
	return @array;
}

sub fasta_write {  #formerly OO
	my $fasta=shift;
	my $file=shift;
	open(OUT,'>',$file) or die 'I died making the output file '.$file.N;
	print OUT '>'.$fasta->[$_][0].N.$fasta->[$_][1].N for (0..$#{$fasta});
	close OUT;
}


####################################################################
###### Main ########################################################
####################################################################

system("clear");
print "Kia ora\n";

my $fasta=[];

my @lines=in($ARGV[0]);
foreach my $i (0..$#lines) {
	my @l=split(/\t/,$lines[$i]);
	$fasta->[$i][0]=$l[0];
	$fasta->[$i][1]=$l[4];
}
fasta_write($fasta,$ARGV[1]);

print "\nHaere mai\n\a";
exit;