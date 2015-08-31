#!/usr/bin/perl
# Email from Minh on Sat 6/12/14



use strict;
#use warnings;
use constant T=>"\t";
use constant N=>"\n";



sub in {
	open FILE,$_[0] or die 'could not open '.$_[0].N;
	my @array=<FILE>;
	@array=split(/\r/,$array[0]) if ! $#array;
	close FILE;
	chomp(@array);
	return @array;
}

sub cow_wash {
	open(OUT,'>',shift(@_));
	my $a=shift @_;
	$a=~ s/\"\s*+//smg;
	my @b=split(/\, /,$a);
	print OUT $_.N foreach @b;
	close OUT;
	return @b;
}

sub tablein {
	my $matrix=[];
	my @lines=in(shift);
	foreach my $l (0..$#lines) {
		$matrix->[$l]=[split(/\t/,$lines[$l])];
	}
	return $matrix;
}

####################################################################
###### Main ########################################################
####################################################################
system("clear");
print "Program has started running.\n";

#read…
my @go=in('table.txt');
shift @go;
open (OP,'>out.txt');
my @genecube=();
my $toggle=0;

#process this…
#Acute inflammatory response (GO:0002526)	"TF, C7, A2M, YWHAZ, C9, MASP1, C3, MASP2, C6, CLU, CRP, C5, TLR4, C1R, C1S, C1QC, AHSG, SAA1, KLKB1, CFH, KRT1, ITIH4, SERPINA1, C2, LBP, CFD, FN1, B4GALT1, C4A, C4B, CFB, SERPING1, C4BPA, C8A, C1QA, C1QB, C8B, SERPINF2, F2"	"TF, C7, MBL2, A2M, C9, MASP1, C3, C6, CLU, C5, C1R, C1S, AHSG, INS, SAA1, CFH, ITIH4, IL1B, SERPINA1, LBP, C2, CFI, CFD, FN1, B4GALT1, IL6, APCS, C4A, CFB, IGF2, SERPING1, C4BPA, ORM1, C8B, SERPINF2, F2"


foreach my $line (@go) {
	my ($head,$sheep,$cow)=split(/\t/,$line);
	#out($_.'.txt',cow_wash($$_)) foreach ('cow', 'sheep'); #damn strict!
	if ($head eq 'MF') {$toggle++; next;}

	cow_wash('cow.txt',$cow);
	cow_wash('sheep.txt',$sheep);
	#system("comm  <(sort cow.txt | uniq) <(sort sheep.txt | uniq) > temp.txt;");
	system("sort cow.txt | uniq > scow.txt; sort sheep.txt | uniq > ssheep.txt;  comm scow.txt ssheep.txt > temp.txt;");
	my @geneball=();
	foreach my $gene (in('temp.txt')) {
		my @uniq=split(/\t/,$gene);
		for my $n (0..2) {push(@{$geneball[$n]},$uniq[$n]) if $uniq[$n]}
	}
	for my $n (0..2) {
		$geneball[$n]=['NO_UNIQUE'] if(!$geneball[$n]);
		($genecube[$n]{$_}[$toggle])?($genecube[$n]{$_}[$toggle].='; '.$head):($genecube[$n]{$_}[$toggle]=$head) foreach (@{$geneball[$n]});
	}
	
	
	print OP $head;
	print OP T.'"'.join(', ',@{$geneball[$_]}).'"' for (0..2);
	print OP N;
}

my $ref=tablein('cow_ref.txt');
#NP_001096576	WRNIP1	ATPase WRNIP1 [Bos taurus].

open (DUE,'>out_partB.txt');
for my $n (0..2) {
	my @tmp=('cow','sheep', 'common');
	print DUE N.$tmp[$n].N;
	foreach my $gene (sort keys(%{$genecube[$n]})) {
		my ($name)=grep($_->[1]=~/$gene/,@$ref);
		print DUE $gene.T.$name->[2].T.$name->[0].T.$genecube[$n]{$gene}[0].T.$genecube[$n]{$gene}[1].N;
	}
}


#Bye!
print "\nProgram has finished running.\n\a";
exit;

####################################################################
###### DUMP ########################################################
####################################################################

__END__