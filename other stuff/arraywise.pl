#! /usr/bin/perl
print "Hello World\n";
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5;
use strict;
#use warnings;

###################################
#	parameters:
my @Fullabc=("A".."Z");
#my @Fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
#my @Fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
my @Statlabels=qw(avg stdev skew kurt cv min max);
##################################

my @diabc=0;

my @Abc=zeroed(\@Fullabc);
foreach my $ante (@Abc) {
	foreach my $post (@Abc) {
		push(@diabc,"$ante$post")
	}
}






#$Scope="omni";
my $Scope="redux";

###bound variables...
my $k;		#k string length
my $letter;	#loops of all letter combos
my $key;	#loops of present letter  combos
my $mill;		#mill the gene list
my $stat;		#stat labels
my $m;		#other
my $n;		#other


my $file=">$Scope/single.txt"; open(SINGLE,$file) 	or die "Can't create file: $!";
print SINGLE "Org\t".join("\t",@Abc)."\tStop";
my @names=map("$Scope/extra/single_$_.txt",@Statlabels);
my @Singlefiles=filegroup(\@names,\@Abc);


my @Org=(); # list of organisms to do.
my $file="inventory_".$Scope.".txt";
my @micro=readfile($file);
shift(@micro);
for my $n (0..$#micro) {
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
	
	my $file="$Scope data/".legal($Org[$Whom][0]).".txt";
	my @fastalist=readfile($file);
	shift(@fastalist);
	print "Analysis $Org[$Whom][0]...\n";
	
	
	for my $mill (0..$#fastalist)
	{
		my @temp=split(/\t/,$fastalist[$mill]);
		shift(@temp);
		for my $n (0..4) {$gene[$mill][$n]=$temp[$n];}
		#internal	key	ref key	descr	sequence	COG(s) ignore rest
	}
	
	@fastalist=();
	##########ARRAY... FASTER############################################################
	###########SINGLE####################
	my @aa=(); my @len=(); my @char=(); my @single=(); my @momsingle=();
	for (my $n=0;$n<=$#gene;$n++)	{
		if (length($gene[$n][3]) <3) {
			print "Gene ($n of $#gene): @{$gene[$n]} is empty\n";
			$gene[$n][3]=qw(X Z X Z X Z X Z);
		}
		$aa[$n]=[split(//, $gene[$n][3])];
		$len[$n]=$#{$aa[$n]}+2; #start from 1 and count stop...good as a number, minus 2 as an index
		$char[$n]=[map {ord($aa[$n][$_])-65} (0..$#{$aa[$n]})];
		
		for my $i (0..$#{$aa[$n]}) {$single[$char[$n][$i]][$n]+=(1/($len[$n]));}
		$single[25][$n]+=(1/($len[$n]));
	}
	
		for my $n (0,2..8,10..13,15..19,21,22,24,25) {
			$momsingle[$n]=[moments(\@{$single[$n]},$Fullabc[$n])];
		}
		
		print SINGLE ("\n$Org[$Whom][0]\t");
		for $letter (0,2..8,10..13,15..19,21,22,24) {
			print SINGLE ($momsingle[$letter][0]."\t");
		}
		
		for my $stat (0..$#Statlabels) {
			my $temp=$Singlefiles[$stat];
			print $temp ("\n$Org[$Whom][0]\t");
			for $letter (0,2..8,10..13,15..19,21,22,24) {
				print $temp ($momsingle[$letter][$stat]."\t");
			}
		}
		#########GENOME##############################################
	$file=">$Scope/extra/".legal($Org[$Whom][0]).".txt"; open(ALLSINGLE,$file) 	or die "Can't create file: $!";
		print ALLSINGLE "gene\t".join("\t",@Abc)."\tStop\n";
		for (my $n=0;$n<=$#gene;$n++)	{
			print ALLSINGLE "$gene[$n][1]\t".join("\t",map($single[$_][$n],(0,2..8,10..13,15..19,21,22,24)))."\n";
		}
		close ALLSINGLE;
	
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

sub legal {
	my ($n)=@_;
	chomp($n);
	$n=~s/\///g;
	$n=~s/\$//g;
	$n=~s/\://g;
	return $n;
}
