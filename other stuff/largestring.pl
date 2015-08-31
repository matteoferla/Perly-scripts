#! /usr/bin/perl
print "Hello World\n";
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5;
use strict;
use warnings;

###################################
#	parameters:
my @Fullabc=("A".."Z");
#my @Fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
#my @Fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
my @Statlabels=qw(avg stdev skew kurt cv min max);
my $Kmax=4;
##################################
if ($ARGV[0]) {$Kmax=abs(int($ARGV[0]));}


my @Abc=zeroed(\@Fullabc);


#$Scope="omni";
my $Scope="premium";

###bound variables...
my $k;		#k string length
my $letter;	#loops of all letter combos
my $key;	#loops of present letter  combos
my $mill;		#mill the gene list
my $stat;		#stat labels
my $m;		#other
my $n;		#other







my @Oligologo=();
my @names=();

$Oligologo[0]=[qw(test testing tested)];
$Oligologo[1]=[@Abc];
for $k (2..$Kmax) {
	my @logo=();
	foreach $letter (@{$Oligologo[$k-1]}) {
		push(@logo,map($_.$letter,@Abc));
	}
	$Oligologo[$k]=[@logo];
}

@names=map("$Scope/alt k$_.txt",0..$Kmax);
my @Altfiles=filegroup([@names],[@Oligologo]);

@names=map("$Scope/count k$_.txt",0..$Kmax);
my @Countfiles=filegroup([@names],[@Oligologo]);


@names=map("$Scope/simple k$_.txt",0..$Kmax);
my @Simfiles=filegroup([@names],[@Oligologo]);





my @Org=(); # list of organisms to do.
my $file="inventory_".$Scope.".txt";
my @micro=readfile($file);
shift(@micro);
for $n (0..$#micro) {
	$Org[$n]=[split(/\t/,$micro[$n])];
}

######################################LOOP START##################################################################################################################
for my $Whom (0..$#Org) {
	reset 'a-z';
	#sleep 60;
	my $error=0;
	my @gene=();
	
	
	if ($Org[$Whom][0] eq "nothing") {print ("\n$Org[$Whom][0]\tnothingness"); print ("$Org[$Whom][0] is not a valid name!\n"); goto JUMP;}
	if ($Org[$Whom][0] eq "") {print ("\n$Org[$Whom][0]\tblankness"); print ("$Org[$Whom][0] is not a valid name!\n"); goto JUMP;}
	
	$file="$Scope data/".$Org[$Whom][0].".txt";
	my @fastalist=readfile($file);
	shift(@fastalist);
	print "Analysis $Org[$Whom][0]...\n";
	
	
	for $mill (0..$#fastalist)
	{
		my @temp=split(/\t/,$fastalist[$mill]);
		shift(@temp);
		for $n (0..4) {$gene[$mill][$n]=$temp[$n];}
		#internal	key	ref key	descr	sequence	COG(s) ignore rest
	}
	
	@fastalist=();
	my @temp=();
	

	#######kstring############################################################################################################################

	my @proteome=map($gene[$_][3],0..$#gene);
	
	for $k (3..$Kmax) {
		my $tot_aa=0;my $tot_de=0;my $tot_dde=0;
		foreach (@proteome)	{
			$tot_aa+=length()-$k+1;
			$tot_de+=length()-$k;
			$tot_dde+=length()-$k-1;
		}
		
		
		my @tempks=();
		print {$Altfiles[$k]} ("$Org[$Whom][0]\t");
		print {$Countfiles[$k]} ("$tot_aa\t");
		foreach $letter (@{$Oligologo[$k]}) {
		my @match=grep(/$letter/,@proteome);
			my $tally=0;
			if ($#match>-1) {
				foreach (@match) {$tally+=(s/$letter/$letter/g);}
				print {$Countfiles[$k]} ("$tally\t"); $tally=$tally/$tot_aa; print {$Altfiles[$k]} ("$tally\t");
				my @subbag=(substr($letter,0,$k-1),substr($letter,1,$k-1),substr($letter,1,$k-2));
				my @subtally=map(0,0..2);
				foreach my $snippet (@subbag) {
					my @match_i=grep(/$snippet/,@proteome); #if ($#match_i==-1) {die "we have an impossible problem $snippet\n";}
					 my $n=0; foreach (@match_i) {$subtally[$n]+=(s/$snippet/$snippet/g);$n++;}
				}
				
				
				my $p=$subtally[0]*$subtally[1]*$tot_dde/($subtally[2]*$tot_de*$tot_dde);
				#if ($p==0) {print "we have an impossible problem for $letter ($tally): p = $p from $subbag[0] = $subtally[0] x $subbag[1] = $subtally[1] div $subbag[2] = $subtally[2]\n"; exit;}
				print {$Simfiles[$k]} ((($tally-$p)/$p)."\t");
			} else {print {$Altfiles[$k]} ("\t");print {$Countfiles[$k]} ("\t");print {$Simfiles[$k]} ("\t");}
		}
		print "$k-string done\n";
	}
	
	

	
JUMP:
	######################################LOOP END##################################################################################################################
}


print "All done!\n\a";

######################################################
####################################################
################################# SUBS... ##########

sub zeroed {
	my @a = @{ $_[0] };
	
	delete $a[25]; #Z
	splice(@a, 25, 1);
	delete $a[23]; #X
	splice(@a, 23, 1);
	delete $a[20]; #U
	splice(@a, 20, 1);
	delete $a[14]; #O
	splice(@a, 14, 1);
	delete $a[9]; #J
	splice(@a, 9, 1);
	delete $a[1]; #B
	splice(@a, 1, 1);
	
	return (@a);
}


sub moments {
	#avg, stdev, skew, kurt, followed by non-moments but useful descriptors... cv, min and max
	#to call use moments([map{$lol[$_][const.]}(0..$#lol)])
	my @raw=@{ $_[0] };
	my $current =$_[1];
	my $n=0;
	my $max=$#raw;
	for $n (0..$max)	{if(!$raw[$n]) {$raw[$n]=0;}}
	if ($max>0) {
		my @moment=map(0,0..3); #preallocation
		for $n (0..$max)	{ $moment[0]+=$raw[$n]/($max+1);}
		for $n (0..$max)	{ $moment[1]+=($raw[$n]-$moment[0])**2;} $moment[1]=sqrt($moment[1]/($max+1));
		if ($moment[1] >0) {
			for $n (0..$max)	{ $moment[2]+=($raw[$n]-$moment[0])**3;} $moment[2]=($moment[2]/(($max+1)*($moment[1]**3)));
			for $n (0..$max)	{ $moment[3]+=($raw[$n]-$moment[0])**4;} $moment[3]=($moment[3]/(($max+1)*($moment[1]**4)))-3;
		}
		$moment[4]=$moment[1]/$moment[0];
		$moment[5]=$moment[0]; $moment[6]=$moment[0];
		for $n (0..$max)	{ if ($moment[5]>$raw[$n]) {$moment[5]=$raw[$n];}}
		for $n (0..$max)	{ if ($moment[6]<$raw[$n]) {$moment[6]=$raw[$n];}}
		return (@moment);
	}
}

sub filegroup {
	my ($ref_name,$ref_header) = @_;
	my @name=@$ref_name;
	my @header=@$ref_header;
	my $looper="off";
	if (ref($header[0]) eq "ARRAY") {$looper=0;}
	my $file;
	my @handle=();
	foreach my $file (@name) {
		open my $hand, '>', $file or die "Error $file $!";
		if ($looper eq "off") {	print $hand ("Org\t".join("\t",@header)); }
		else {print $hand ("Org\t".join("\t",@{$header[$looper]})."\n"); $looper++;} 
		push (@handle, $hand);
	}
	return @handle;
}

sub readfile {
	my ($file)=@_;
BACK:
	open(FILE,$file) or do {print "Cannot find file called $file, what is it's real name?\n"; $file=<>; chomp $file; goto BACK;};	
	my @line=<FILE>;
	close FILE;
	chomp(@line);
	if ($#line<2) {
		my @temp=split(/\r/,$line[0]);
		my @tempo=split(/\r/,$line[1]); #pretty sure cannot be.
		@line=@temp;
		push(@line,@tempo);
	}
	return (@line);
}
