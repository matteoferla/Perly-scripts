#! /usr/bin/perl
print "Hello World\n";
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5;



###################################
#	parameters:
@fullabc=("A".."Z");
#@fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
#@fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
my @Hydroref=(1.8, 0, 2.5, -3.5, -3.5, 2.8, -0.4, -3.2, 4.5, 0, -3.9, 3.8, 1.9, -3.5, 0, -1.6, -3.5, -4.5, -0.8, -0.7, 0, 4.2, -0.9, 0, -1.3);
my $Hstep=2; # number of steps per hydropathy score unit, so it increases in 1/step increments.
my $Sstep=100; #idem but for size...
@Cats=("A ( RNA processing and modification)","B ( Chromatin structure and dynamics)","C ( Energy production and conversion)","D ( Cell cycle control, cell division, chromosome partitioning)","E ( Amino acid transport and metabolism)","F ( Nucleotide transport and metabolism)","G ( Carbohydrate transport and metabolism)","H ( Coenzyme transport and metabolism)","I ( Lipid transport and metabolism)","J ( Translation, ribosomal structure and biogenesis)","K ( Transcription)","L ( Replication, recombination and repair)","M ( Cell wall/membrane/envelope biogenesis)","N ( Cell motility)","O ( Posttranslational modification, protein turnover, chaperones)","P ( Inorganic ion transport and metabolism)","Q ( Secondary metabolites biosynthesis, transport and catabolism)","R ( General function prediction only)","S ( Function unknown)","T ( Signal transduction mechanisms)","U ( Intracellular trafficking, secretion, and vesicular transport)","V ( Defense mechanisms)","W ( Extracellular structures)","X (Blank)","Y ( Nuclear structure)","Z ( Cytoskeleton)");
my @statlabels=qw(avg stdev skew kurt cv min max);
##################################

my $Hmin=int($Hstep*0.5);
my $Hmax=int($Hstep*9.5);


@abc=zeroed(\@fullabc);

foreach $ante (@abc) {
	foreach $post (@abc) {
		push(@diabc,"$ante$post")
	}
}

foreach $ante (@abc) {
	foreach $mid (@abc) {
		foreach $post (@abc) {
			push(@triabc,"$ante$mid$post")
		}
	}
}

foreach $ante (@abc) {
	foreach $midfore (@abc) {
		foreach $midback (@abc) {
			foreach $post (@abc) {
				push(@tetraabc,"$ante$midfore$midback$post")
			}
		}
	}
}













#$scope="omni";
$scope="premium";

$file=">$scope/special_TR.txt"; open(SNARE,$file) 	or die "Can't create file: $!";
$file=">$scope/description.txt"; open(INFO,$file) 	or die "Can't create file: $!";
print INFO "name\tuid\tN genes";

$file=">$scope/error_report.txt"; open(ERRATUM,$file) 	or die "Can't create file: $!";
print ERRATUM "name\tuid\tissue";

$file=">$scope/single.txt"; open(SINGLE,$file) 	or die "Can't create file: $!";
print SINGLE "org\t".join("\t",@abc)."\tStop";


my @singlefiles;
foreach $stat (0..$#statlabels)
{
	$file="$scope/extra/single_$statlabels[$stat].txt";
	open my $fh, '>', $file or die "Cannot open $file: $!";
	push(@singlefiles,$fh);
	$temp=$singlefiles[$stat];
	print $temp ("org\t".join("\t",@abc)."\tStop");
}







$file=">$scope/alt_single.txt"; open(ALTSINGLE,$file) 	or die "Can't create file: $!";
print ALTSINGLE "org\t".join("\t",@abc)."\tStop";

$file=">$scope/pair.txt"; open(PAIR,$file) 	or die "Can't create file: $!";

print PAIR "org\t".join("\t",@diabc);

my @pairfiles;
foreach $stat (0..$#statlabels)
{
	$file="$scope/extra/pair_$statlabels[$stat].txt";
	open my $fh, '>', $file or die "Cannot open $file: $!";
	push(@pairfiles,$fh);
	$temp=$pairfiles[$stat];
	print $temp ("org\t".join("\t",@diabc)."\tStop");
}


$file=">$scope/triplet.txt"; open(TRIP,$file) 	or die "Can't create file: $!";

print TRIP "org\t".join("\t",@triabc);

my @tripfiles;
foreach $stat (0..$#statlabels)
{
	$file="$scope/extra/triplet_$statlabels[$stat].txt";
	open my $fh, '>', $file or die "Cannot open $file: $!";
	push(@tripfiles,$fh);
	$temp=$tripfiles[$stat];
	print $temp ("org\t".join("\t",@triabc)."\tStop");
}


$file=">$scope/covariance.txt"; open(COV,$file) 	or die "Can't create file: $!";
$file=">$scope/pearson.txt"; open(PEAR,$file) 	or die "Can't create file: $!";
print COV "org\t";
print PEAR "org\t";
for $ante (0,2..8,10..13,15..19,21,22,24) {
	for $post (0,2..8,10..13,15..19,21,22,24) {
		if ($ante<$post) {
			print PEAR "$fullabc[$ante]$fullabc[$post]\t";
			print COV "$fullabc[$ante]$fullabc[$post]\t";
		}
	}
}

$file=">$scope/tandem.txt"; open(TANDEM,$file) 	or die "Can't create file: $!";
	for $y (0..$#abc) {
		for $x (0..8)	{
			print TANDEM "\t$x x $abc[$y]";
		}
	}

###asymmetry
foreach $k (2..4)
{
	$file="$scope/extra/asymmetry_$k.txt";
	open my $fh, '>', $file or die "Cannot open $file: $!";
	push(@asyfiles,$fh);
}




$file=">$scope/k2_simple.txt"; open(DISIMPLE,$file) 	or die "Can't create file: $!";
print DISIMPLE "org\t".join("\t",@diabc);

$file=">$scope/k2_adv.txt"; open(DIADV,$file) 	or die "Can't create file: $!";
print DIADV "org\t".join("\t",@diabc);

$file=">$scope/k3_simple.txt"; open(TRISIMPLE,$file) 	or die "Can't create file: $!";
print TRISIMPLE "org\t".join("\t",@triabc);

$file=">$scope/k3_adv.txt"; open(TRIADV,$file) 	or die "Can't create file: $!";
print TRIADV "org\t".join("\t",@triabc);

$file=">$scope/k3_simple.txt"; open(TRISIMPLE,$file) 	or die "Can't create file: $!";
print TETRASIMPLE "org\t".join("\t",@triabc);

$file=">$scope/k3_adv.txt"; open(TRIADV,$file) 	or die "Can't create file: $!";
print TETRAADV "org\t".join("\t",@triabc);




$file="inventory_".$scope.".txt"; open(ORG,$file) 	or die "Can't find microbes file: $!";
@micro=<ORG>;
chomp(@micro);
shift(@micro);
for $x (0..$#micro) {
	@{$org[$x]}=split(/\t/,$micro[$x]);
}


######################################LOOP START##################################################################################################################
for $whom (0..$#org) {
	
	#sleep 60;
	my $error=0;
	my @gene=();
	
	
	if ($org[$whom][0] eq "nothing") {print ERRATUM ("\n$org[$whom][0]\tnothingness"); print ("$org[$whom][0] is not a valid name!\n"); goto JUMP;}
	if ($org[$whom][0] eq "") {print ERRATUM ("\n$org[$whom][0]\tblankness"); print ("$org[$whom][0] is not a valid name!\n"); goto JUMP;}
	
	$file="$scope data/".$org[$whom][0].".txt"; open(FASTA,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n$org[$whom][0]\tno files"); print ("$org[$whom][0] has no files!\n"); goto JUMP;}
	my @fastalist=<FASTA>; chomp(@fastalist);
	shift(@fastalist);
	print "Analysis $org[$whom][0]...\n";
	

	for $n (0..$#fastalist)
	{
		@temp=split(/\t/,$fastalist[$n]);
		shift(@temp);
		for $m (0..4) {$gene[$n][$m]=$temp[$m];}
		#internal	key	ref key	descr	sequence	COG(s) ignore rest
	}
	
	@fastalist=();
	@temp=();
	my @single=();
	my @momsingle=();
	my @cov=();
	my @pear=();
	my @pair=();
	my @mompair=();
	my @tandem=();
	my @trip=();
	my @momtrip=();
	my %lbag=();
	my %moml=();
	my %lstring=();
	my %kbag=();
	my %momk=();
	my %kstring=();
	my %score=();
	my %diff=();
	my %sstring=();
	my %pstring=();
	my %revdiff=();
	my %revscore=();
	
	##########ARRAY... FASTER############################################################
	###########SINGLE####################
	my @aa=(); my @len=(); my $char=(); 
	for ($n=0;$n<=$#gene;$n++)	{
		if (length($gene[$n][3]) <3) {
			print "Gene ($n of $#gene): @{$gene[$n]} is empty\n";
			$gene[$n][3]=qw(X Z X Z X Z X Z);
		}
		$aa[$n]=[split(//, $gene[$n][3])];
		$len[$n]=$#{$aa[$n]}+2; #start from 1 and count stop...good as a number, minus 2 as an index
		$char[$n]=[map {ord($aa[$n][$_])-65} (0..$#{$aa[$n]})];
		
		for $i (0..$#{$aa[$n]}) {$single[$char[$n][$i]][$n]+=(1/($len[$n]));}
		$single[25][$n]+=(1/($len[$n]));
	}
	
	
	for $n (0,2..8,10..13,15..19,21,22,24,25) {
		$momsingle[$n]=[moments(\@{$single[$n]},$fullabc[$n])];
	}
	
	print SINGLE ("\n$org[$whom][0]\t");
	for $letter (0,2..8,10..13,15..19,21,22,24) {
		print SINGLE ($momsingle[$letter][0]."\t");
	}
	
	for $stat (0..$#statlabels) {
		$temp=$singlefiles[$stat];
		print $temp ("\n$org[$whom][0]\t");
		for $letter (0,2..8,10..13,15..19,21,22,24) {
			print $temp ($momsingle[$letter][$stat]."\t");
		}
	}
	#########GENOME##############################################
	$file=">$scope/extra/$org[$whom][0].txt"; open(ALLSINGLE,$file) 	or die "Can't create file: $!";
	print ALLSINGLE "gene\t".join("\t",@abc)."\tStop\n";
	for ($n=0;$n<=$#gene;$n++)	{
		print ALLSINGLE "$gene[$n][1]\t".join("\t",map($single[$_][$n],(0,2..8,10..13,15..19,21,22,24)))."\n";
	}
	close ALLSINGLE;
	
	#########COV##############################################
	
	
	for ($n=0;$n<=$#gene;$n++)	{
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				$cov[$ante][$post]+=($single[$ante][$n]-$momsingle[$ante][0])*($single[$post][$n]-$momsingle[$post][0])/($#gene+1);
			}
		}
	}
	
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			$pear[$ante][$post]=$cov[$ante][$post]/($momsingle[$ante][1]*$momsingle[$post][1]);
		}
	}
	
	print COV "\n$org[$whom][0]\t";
	print PEAR "\n$org[$whom][0]\t";
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			if ($ante<$post) {
				print PEAR "$pear[$ante][$post]\t";
				print COV "$pear[$ante][$post]\t";
			}
		}
	}
	
	
	
	
	
	#########PAIR#############################################

	for ($n=0;$n<=$#gene;$n++)	{
		for $i (0..$#{$aa[$n]}) {$pair[$char[$n][$i]][$char[$n][$i+1]][$n]+=(1/($len[$n]));}
	}
	
	
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			$mompair[$ante][$post]=[moments(\@{$pair[$ante][$post]},"$fullabc[$ante]$fullabc[$post]")];
		}
	}
	
	print PAIR "\n$org[$whom][0]\t";
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			print PAIR ($mompair[$ante][$post][0]."\t");
		}
	}
	
	for $stat (0..$#statlabels) {
		$temp=$pairfiles[$stat];
		print $temp ("\n$org[$whom][0]\t");
			for $ante (0,2..8,10..13,15..19,21,22,24) {
				for $post (0,2..8,10..13,15..19,21,22,24) {
					print $temp ($mompair[$ante][$post][$stat]."\t");
			}
		}
	}
	
	
	
	
	
	#########TRIP#############################################

	for ($n=0;$n<=$#gene;$n++)	{
		for $i (0..$#{$aa[$n]}) {$trip[$char[$n][$i]][$char[$n][$i+1]][$char[$n][$i+2]][$n]+=(1/($len[$n]));}
	}
	
	
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $mid (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				$momtrip[$ante][$mid][$post]=[moments(\@{$trip[$ante][$mid][$post]},"$fullabc[$ante]$fullabc[$mid]$fullabc[$post]")];
			}
		}
	}
	
	print TRIP "\n$org[$whom][0]\t";
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $mid (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				print TRIP ($momtrip[$ante][$mid][$post][0]."\t");
			}
		}
	}
	
	for $n (0..$#statlabels) {
		$temp=$tripfiles[$stat];
		print $temp ("\n$org[$whom][0]\t");
			for $ante (0,2..8,10..13,15..19,21,22,24) {
				for $mid (0,2..8,10..13,15..19,21,22,24) {
					for $post (0,2..8,10..13,15..19,21,22,24) {
						print $temp ($momtrip[$ante][$mid][$post][$n]."\t");
				}
			}
		}
	}

	
	
	##################TANDEM######################################################################################################################################################################################################################
	


	for ($n=0;$n<=$#gene;$n++)	{
		for ($mill = 0; $mill <= $#{$aa[$n]}; $mill++)
		{
			if ($aa[$n][$mill] !~ "X") {
				$multiloop=0;
				until ($aa[$n][$multiloop+$mill] ne "$aa[$n][$mill]")
				{
					$multiloop++;
				}
				$multiloop--;$multiloop--;
				if ($multiloop > 9) {
					print "WARNING: A homopolymeric track of ".($multiloop+2)." tandem repeats was encountered! This is very Unusual for Prokaryotes!!\n";
					print SNARE "\n$org[$whom][0]\t$gene[$n][0]\t$gene[$n][2]\t$gene[$n][3]\t".($multiloop+2).$aa[$n][$mill];
					$tandem[$multiloop][$char[$n][$mill]][$n]+=(1/$len[$n]);
					$mill+=$multiloop+2;
				}
				
		
			elsif ($multiloop > -1) {
				$tandem[$multiloop][$char[$n][$mill]][$n]+=(1/$len[$n]);
				$mill+=$multiloop+2;
			}
			
		}
		}
		
	}
	
	for $y (0,2..8,10..13,15..19,21,22,24) {
		for $x (0..8) {
			$momtandem[$x][$y]=[moments(\@{$tandem[$x][$y]},"$x x $fullabc[$y]")];
		}
	}
	
	print TANDEM "\n$org[$whom][0]\t";
	for $y (0..$#abc) {
		for $x (0..8)	{
			print TANDEM "$momtandem[$x][$y][0]\t";
		}
	}
	
	
	#######kstring############################################################################################################################
	
	$kmax=4;
	for $k (1..$kmax) {
		for $n (0..$#gene)	{
			$totlen=length($gene[$n][3])-$k+1;
			for $m (0..$totlen) {$kbag{substr($gene[$n][3],$m,$k)}[$n]+=1/$totlen;}
		}
		@keychain=(keys %kbag);
		for $m (@keychain) {
			$momk{$m}=[moments($kbag{$m},$m)];
			$kstring{$m}=$momk{$m}[0];
		}
	}

	
	my @monoks=();
	my @diks=();
	my @triks=();
	my @tetraks=();
	foreach (keys %kstring) {
		if (length == 1) {push(@monoks,$_);}
		if (length == 2) {push(@diks,$_);}
		if (length == 3) {push(@triks,$_);}
		if (length == 4) {push(@tetraks,$_);}
	}
	
	
	$k=1;
	print ALTSINGLE "\n$org[$whom][0]\t";
	foreach $letter (@abc) {
		print ALTSINGLE ($kstring{$letter}."\t");
	}
	
	$k=2;
	%pstring=map{$_ => $kstring{substr($_,0,1)}*$kstring{substr($_,1,1)}} (@diks);
	%sstring=map{$_ => $momk{substr($_,0,1)}[1]*$momk{substr($_,1,2)}[1]+$momk{substr($_,0,1)}[1]*($momk{substr($_,1,2)}[0]**2)+($momk{substr($_,0,1)}[0]**2)*$momk{substr($_,1,2)}[1]} (@diks);
	%diff=map{$_ => ($kstring{$_}-$pstring{$_})/$pstring{$_}} (@diks);
	%score=map{$_ => ($kstring{$_}-$pstring{$_})/$sstring{$_}} (@diks);
	
	print DISIMPLE "\n$org[$whom][0]\t";
	foreach $letter (@diabc) {
		print DISIMPLE ($diff{$letter}."\t");
	}
	
	print DIADV "\n$org[$whom][0]\t";
	foreach $letter (@diabc) {
		print DIADV ($score{$letter}."\t");
	}
	
	$k=3; #or loop to Kmax
	%pstring=map{$_ => ($kstring{substr($_,0,$k-1)}*$kstring{substr($_,1,$k)}/$kstring{substr($_,1,$k-1)})} (@triks);
	%sstring=map{$_ => sqrt(((($momk{substr($_,0,$k-1)}[0]+$momk{substr($_,1,$k)}[0])/$momk{substr($_,1,$k-1)}[0])**2)*(($momk{substr($_,0,$k-1)}[1]*$momk{substr($_,1,$k)}[1]+$momk{substr($_,0,$k-1)}[1]*($momk{substr($_,1,$k)}[0]**2)+($momk{substr($_,0,$k-1)}[0]**2)*$momk{substr($_,1,$k)}[1])/(($momk{substr($_,0,$k-1)}[0]+$momk{substr($_,1,$k)}[0]))**2+$momk{substr($_,1,$k-1)}[1]/($momk{substr($_,1,$k-1)}[0]**2)))} (@triks);
	%diff=map{$_ => ($kstring{$_}-$pstring{$_})/$pstring{$_}} (@triks);
	%score=map{$_ => ($kstring{$_}-$pstring{$_})/$sstring{$_}} (@triks);
	
	print TRISIMPLE "\n$org[$whom][0]\t";
	foreach $letter (@triabc) {
		print TRISIMPLE ($diff{$letter}."\t");
	}
	
	print TRIADV "\n$org[$whom][0]\t";
	foreach $letter (@triabc) {
		print TRIADV ($score{$letter}."\t");
	}
	
	$k=4;
	%pstring=map{$_ => ($kstring{substr($_,0,$k-1)}*$kstring{substr($_,1,$k)}/$kstring{substr($_,1,$k-1)})} (@tetraks);
	%sstring=map{$_ => sqrt(((($momk{substr($_,0,$k-1)}[0]+$momk{substr($_,1,$k)}[0])/$momk{substr($_,1,$k-1)}[0])**2)*(($momk{substr($_,0,$k-1)}[1]*$momk{substr($_,1,$k)}[1]+$momk{substr($_,0,$k-1)}[1]*($momk{substr($_,1,$k)}[0]**2)+($momk{substr($_,0,$k-1)}[0]**2)*$momk{substr($_,1,$k)}[1])/(($momk{substr($_,0,$k-1)}[0]+$momk{substr($_,1,$k)}[0]))**2+$momk{substr($_,1,$k-1)}[1]/($momk{substr($_,1,$k-1)}[0]**2)))} (@tetraks);
	%diff=map{$_ => ($kstring{$_}-$pstring{$_})/$pstring{$_}} (@tetraks);
	%score=map{$_ => ($kstring{$_}-$pstring{$_})/$sstring{$_}} (@tetraks);
	
	print TETRASIMPLE "\n$org[$whom][0]\t";
	foreach $letter (@tetraabc) {
		print TETRASIMPLE ($diff{$letter}."\t");
	}
	
	print TETRAADV "\n$org[$whom][0]\t";
	foreach $letter (@tetraabc) {
		print TETRAADV ($score{$letter}."\t");
	}
	
	#@asyfile;
	#reverse $_ %revdiff %revscore
		

	$genenumber=0;
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
	if ($#raw>0) {
		my @moment=();
		for $n (0..$#raw)	{ $moment[0]+=$raw[$n]/($#raw+1);}
		for $n (0..$#raw)	{ $moment[1]+=($raw[$n]-$moment[0])**2;} $moment[1]=sqrt($moment[1]/($#raw+1));
		if ($moment[1] >0) {
			for $n (0..$#raw)	{ $moment[2]+=($raw[$n]-$moment[0])**3;} $moment[2]=($moment[2]/(($#raw+1)*($moment[1]**3)));
			for $n (0..$#raw)	{ $moment[3]+=($raw[$n]-$moment[0])**4;} $moment[3]=($moment[3]/(($#raw+1)*($moment[1]**4)))-3;
		}
		$moment[4]=$moment[1]/$moment[0];
		$moment[5]=$moment[0]; $moment[6]=$moment[0];
		for $n (0..$#raw)	{ if ($moment[5]>$raw[$n]) {$moment[5]=$raw[$n];}}
		for $n (0..$#raw)	{ if ($moment[6]<$raw[$n]) {$moment[6]=$raw[$n];}}
		return (@moment);
	}
}

sub tprob { # Upper probability   t(x,n)
	my ($n, $x) = @_;
	if (($n <= 0) || ((abs($n) - abs(int($n))) !=0)) {
		die "Invalid n: $n\n"; # degree of freedom
	}
	return precision_string(_subtprob($n, $x));
}

sub _subtprob {
	my ($n, $x) = @_;
	
	my ($a,$b);
	my $w = atan2($x / sqrt($n), 1);
	my $z = cos($w) ** 2;
	my $y = 1;
	
	for (my $i = $n-2; $i >= 2; $i -= 2) {
		$y = 1 + ($i-1) / $i * $z * $y;
	} 
	
	if ($n % 2 == 0) {
		$a = sin($w)/2;
		$b = .5;
	} else {
		$a = ($n == 1) ? 0 : sin($w)*cos($w)/PI;
		$b= .5 + $w/PI;
	}
	return max(0, 1 - $b - $a * $y);
}

sub max {
	my $max = shift;
	my $next;
	while (@_) {
		$next = shift;
		$max = $next if ($next > $max);
	}	
	return $max;
}

sub min {
	my $min = shift;
	my $next;
	while (@_) {
		$next = shift;
		$min = $next if ($next < $min);
	}	
	return $min;
}

sub precision {
	my ($x) = @_;
	return abs int(log10(abs $x) - SIGNIFICANT);
}

sub precision_string {
	my ($x) = @_;
	if ($x) {
		return sprintf "%." . precision($x) . "f", $x;
	} else {
		return "0";
	}
}

sub log10 {
	my $n = shift;
	return log($n) / log(10);
}
