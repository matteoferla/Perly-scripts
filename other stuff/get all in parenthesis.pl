

$file="PF01168_full_length_sequences.fasta";
open(FILE,$file) or die "Bugger";
$file=">out.txt";
open(OUT,$file) or die "Bugger";

@line=<FILE>;
chomp(@line);
foreach (@line) {
	if (/\((.+)\)/) {print OUT $1."\n";}
}