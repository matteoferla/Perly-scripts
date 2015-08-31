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
my $Kmax=3;
##################################

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

my @Statfiles=();
for $k (0..$Kmax) {
	my @names=map("$Scope/extra/stats k$k $_.txt",@Statlabels);
	$Statfiles[$k]=[filegroup([@names],$Oligologo[$k])];
}

@names=map("$Scope/simple k$_.txt",0..$Kmax);
my @Simfiles=filegroup([@names],[@Oligologo]);

@names=map("$Scope/score k$_.txt",0..$Kmax);
my @Advfiles=filegroup([@names],[@Oligologo]);

@names=map("$Scope/asymetry k$_.txt",0..$Kmax);
my @Asyfiles=filegroup([@names],[@Oligologo]);

@names=map("$Scope/score asy k$_.txt",0..$Kmax);
my @Dasyfiles=filegroup([@names],[@Oligologo]);

@names=map("$Scope/tr rel k$_.txt",0..$Kmax);
my @Relfiles=filegroup([@names],[@Oligologo]);





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
	my @ks=();
	my %kbag=();
	my %momk=();
	my %kstring=();
	my %dstring=();
	my %score=();
	my %diff=();
	my %sstring=();
	my %pstring=();
	my %revdiff=();
	my %revscore=();
	my %rel=();
	

	#######kstring############################################################################################################################

	for $k (1..$Kmax) {
		my @tempks=();
		print {$Altfiles[$k]} ("$Org[$Whom][0]\t");
		foreach $n (0..$#Statlabels) {print {$Statfiles[$k][$n]} ("$Org[$Whom][0]\t");}
		
		for $mill (0..$#gene)	{
			my $current=$gene[$mill][3];
			my $totlen=length($current)-$k+1;
			for $n (0..$totlen) {$kbag{substr($current,$n,$k)}[$mill]+=1/$totlen;}
		}
		@tempks=();
		foreach $letter (@{$Oligologo[$k]}) {
			if ($kbag{$letter}) {
				push(@tempks,$letter);
				$momk{$letter}=[moments($kbag{$letter},$letter)];
				$kstring{$letter}=$momk{$letter}[0];
				$dstring{$letter}=$momk{$letter}[1];
				print {$Altfiles[$k]} ($kstring{$letter}."\t");
				foreach $stat (0..$#Statlabels) {print {$Statfiles[$k][$stat]} ($momk{$letter}[$stat]."\t");}
				delete $momk{$letter};
				delete $kbag{$letter};
			} else {
				print {$Altfiles[$k]} ("\t");
				foreach $stat (0..$#Statlabels) {print {$Statfiles[$k][$stat]} ("\t");}
			}
		}
		
		$ks[$k]=[@tempks];
		%kbag=();
		@tempks=();
		
		if ($k>1) {
			print {$Simfiles[$k]} ("$Org[$Whom][0]\t");
			print {$Advfiles[$k]} ("$Org[$Whom][0]\t");
			print {$Asyfiles[$k]} ("$Org[$Whom][0]\t");
			print {$Dasyfiles[$k]} ("$Org[$Whom][0]\t");
			print {$Relfiles[$k]} ("$Org[$Whom][0]\t");
			
			#preallocation
			#%diff=map{$_ => 0} (@{$Oligologo[$k]});
			#%score=map{$_ => 0} (@{$Oligologo[$k]});
			#%revdiff=map{$_ => 0} (@{$Oligologo[$k]});
			#%revscore=map{$_ => 0} (@{$Oligologo[$k]});
			#%rel=map{$_ => 0} (@{$Oligologo[$k]});
		
			
			foreach $key ((@{$ks[$k]})) {   #FORMER MAP FUNCTION GROUP
				if ($kstring{$key}<=0) {goto KEYDROP;}
				my $x=substr($key,0,$k-1); if ($kstring{$x}==0) {die "Error x: $key: $kstring{$key}, but $x\: $kstring{$x}\n";}
				my $y=substr($key,1,$k-1); if ($kstring{$y}==0) {die "Error y: $key: $kstring{$key}, but $y\: $kstring{$y}\n";}
				
				
				if ($k==2) {
					$pstring{$key}=$kstring{$x}*$kstring{$y};
					$sstring{$key}=($dstring{$x}*$dstring{$y})**2+($dstring{$x}*$kstring{$y})**2+($kstring{$x}*$dstring{$y})**2;
				}	
				else {
					my $z=substr($key,1,$k-2); if ($kstring{$z}==0) {die "Division by zero forecast: $key: $kstring{$key}, but $z: $kstring{$z}\n";}
					
					$pstring{$key}=$kstring{$x}*$kstring{$y}/$kstring{$z};
					$sstring{$key}=((
					$kstring{$x}+$kstring{$y}
					)/$kstring{$z}
					)**2
					*(($dstring{$x}*$dstring{$y})**2
					+($dstring{$x}*$kstring{$y})**2
					+($kstring{$x}*$dstring{$y})**2
					/($kstring{$x}+$kstring{$y})**2
					+($dstring{$z}/$kstring{$z})**2);
					
				}
				if ($pstring{$key}<=0) {print "LINE 480!\n"; goto KEYDROP;}
				$diff{$key}=($kstring{$key}-$pstring{$key})/$pstring{$key};
				if ($kstring{$key}=>$pstring{$key}) { $rel{$key}=($kstring{$key}-$pstring{$key})/$pstring{$key};} else {$rel{$key}=($kstring{$key}-$pstring{$key})/$kstring{$key};}
				
				if ($kstring{reverse($key)}) {
					$revdiff{$key}=($kstring{$key}-$kstring{reverse($key)})/$kstring{reverse($key)};
					if ($dstring{reverse($key)}) {
						$revscore{$key}= ($kstring{$key}-$kstring{reverse($key)})/$dstring{reverse($key)};
					}
				}	
				if ($sstring{$key}>0) {$score{$key}=($kstring{$key}-$pstring{$key})/$sstring{$key};} else {print "Line 468 Division by zero prevented: $key: $kstring{$key}, but prob var: $sstring{$key}\n";}
								
				
			KEYDROP:
			} #key
			foreach $letter (@{$Oligologo[$k]}) {
				print {$Simfiles[$k]} ($diff{$letter}."\t");
				print {$Advfiles[$k]} ($score{$letter}."\t");
				print {$Asyfiles[$k]} ($revdiff{$letter}."\t");
				print {$Dasyfiles[$k]} ($revscore{$letter}."\t");
				print {$Relfiles[$k]} ($rel{$letter}."\t");
			}
			
			print {$Simfiles[$k]} ("\n");
			print {$Advfiles[$k]} ("\n");
			print {$Asyfiles[$k]} ("\n");
			print {$Dasyfiles[$k]} ("\n");
			print {$Relfiles[$k]} ("\n");
			
		}	#ks over 1
		print {$Altfiles[$k]} ("\n");
		foreach $stat (0..$#Statlabels) {print {$Statfiles[$k][$stat]} ("\n");}
	print "$k-string done\n";
	} #ks
	
	#############
	
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
