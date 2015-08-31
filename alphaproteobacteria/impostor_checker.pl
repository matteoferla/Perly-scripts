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

sub fasta_read {
	my @fasta;
	my $key;
	foreach (in($_[0])) {
		if (/>/) {$key++; s/>//; $fasta[$key][0]=$_; $fasta[$key][1]="";}
		else {$fasta[$key][1].=$_}
	}
	shift(@fasta);
	#print "VERBOSE: (Error above is good) ",@{[shift(@fasta)]},N;
	return \@fasta; #ref w/ two indices: the first marks the sequences, the second as 0 has the name, as 1 has the sequence.  
}

sub fasta_write {
	my $fasta=shift;
	my $file=shift;
	open(OUT,'>',$file) or die 'I died making the output file '.$file.N;
	print OUT '>'.$fasta->[$_][0].N.$fasta->[$_][1].N for (0..$#{$fasta});
	close OUT;
}

sub taxonbuster {
	#>640702077 AMr3 247468..248989(+)(NC_004842) [Anaplasma marginale St. Maries]
	($_[0]=~/\[(.*)\]/) ? (return ($1)) : (die "No taxon found in $_[0]\n");
}


####################################################################
###### Main ########################################################
####################################################################

print "Kia ora\n";
system("clear; clear");
my $fasta=fasta_read($ARGV[0]);
foreach (@$fasta) {$_->[0]=taxonbuster($_->[0])} 
my $past=[$fasta->[0][0],$fasta->[0][1]];
my $i=0;
my $j=0;
my $tick=0;
foreach my $pair (@$fasta) {
	if ($past->[0] eq $pair->[0]) {
		if (! $tick) {
			$j++;
			my ($a,$b)=($past->[1],$pair->[1]);
			($b,$a)=($a,$b) if (length($a) < length($b));
			$b=substr($b,0,250);
			if ($a!~/$b/) {
				print $pair->[0].' issue!'.N.'v1 ('.length($past->[1]).'):'.T.substr($past->[1],0,250).N.'v2 ('.length($pair->[1]).'):'.T.substr($pair->[1],0,250).N.N; $i++;
				#print N.N.$past->[1].N.N; <STDIN>; system("clear");
			}
			$tick=1;
		}
		#else {print $pair->[0].' passes!'.N.N}
	} else {$tick=0} #reset
	$past=[$pair->[0],$pair->[1]]; #update
}


print "There were $i issues out of $j\n";
print "\nHaere mai\n";
exit;