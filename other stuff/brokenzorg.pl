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
##################################

my $Hmin=int($Hstep*0.5);
my $Hmax=int($Hstep*9.5);

$file=">omni/special_TR.txt"; open(SNARE,$file) 	or die "Can't create file: $!";


$file=">omni/single.txt"; open(SINGLE,$file) 	or die "Can't create file: $!";
@abc=zeroed(\@fullabc);
print SINGLE "org\t".join("\t",@abc)."\tStop";

$file=">omni/alt_single.txt"; open(ALTSINGLE,$file) 	or die "Can't create file: $!";
print ALTSINGLE "org\t".join("\t",@abc)."\tStop";

$file=">omni/pair.txt"; open(PAIR,$file) 	or die "Can't create file: $!";
foreach $ante (@abc) {
	foreach $post (@abc) {
		push(@diabc,"$ante$post")
	}
}
print PAIR "org\t".join("\t",@diabc);

$file=">omni/trip.txt"; open(TRIP,$file) 	or die "Can't create file: $!";
foreach $ante (@abc) {
	foreach $mid (@abc) {
		foreach $post (@abc) {
			push(@triabc,"$ante$mid$post")
		}
	}
}
print TRIP "org\t".join("\t",@triabc);


$file=">omni/cov.txt"; open(COV,$file) 	or die "Can't create file: $!";
$file=">omni/asymmetry.txt"; open(ASY,$file) 	or die "Can't create file: $!";

$file=">omni/k2_simple.txt"; open(DISIMPLE,$file) 	or die "Can't create file: $!";
print DISIMPLE "org\t".join("\t",@diabc);

$file=">omni/k2_adv.txt"; open(DIADV,$file) 	or die "Can't create file: $!";
print DIADV "org\t".join("\t",@diabc);

$file=">omni/k3_simple.txt"; open(TRISIMPLE,$file) 	or die "Can't create file: $!";
print TRISIMPLE "org\t".join("\t",@triabc);

$file=">omni/k3_adv.txt"; open(TRIADV,$file) 	or die "Can't create file: $!";
print TRIADV "org\t".join("\t",@triabc);

$file=">omni/description.txt"; open(INFO,$file) 	or die "Can't create file: $!";
print INFO "name\tuid\tN genes";

$file=">omni/error_report.txt"; open(ERRATUM,$file) 	or die "Can't create file: $!";
print ERRATUM "name\tuid\tissue";



open(ORG,'prok_out.txt') or die "Can't find microbes: $!";
@micro=<ORG>;
chomp(@micro);
for $x (0..$#micro) {
	@{$org[$x]}=split(/\t/,$micro[$x]);
	shift(@{$org[$x]});
}




######################################LOOP START##################################################################################################################
for $whom (0..0) {
	
	#sleep 60;
	my $error=0;
	
	
	
	if ($org[$whom][0] eq "nothing") {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\tnothingness"); goto JUMP;}
	if ($org[$whom][0] eq "") {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\tblankness"); goto JUMP;}
	
	$file="genomes/fasta/".$org[$whom][0].".txt"; open(FASTA,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\tfastalss"); goto JUMP;}
	my @fastalist=<FASTA>; chomp(@fastalist);
	close FASTA;
	
	$file="genomes/table/".$org[$whom][0].".txt"; open(TABLE,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\ttableless"); goto JUMP;}
	my @tablelist=<TABLE>; chomp(@tablelist);
	close TABLE;
	
	$file="genomes/overview/".$org[$whom][0].".txt"; open(OVER,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\toverviewless"); goto JUMP;}
	my @overlist=<OVER>; chomp(@overlist);
	close OVER;
	
	
	
	
	
	for ($n=0;$n<=$#fastalist;$n++)
	{
		
		#>gi|51594360|ref|YP_068551.1| flavodoxin [Yersinia pseudotuberculosis IP 32953]
		if ($fastalist[$n]=~ m/\>/msg) {
			
			@temp=split(/\|/,$fastalist[$n]);
			$genenumber++;
			shift(@temp);
			$gene[$genenumber][0]=shift(@temp);
			shift(@temp);
			$gene[$genenumber][1]=shift(@temp);
			$gene[$genenumber][2]=shift(@temp);
			
		} else
		{$fastalist[$n]=~s/\W//msg;$fastalist[$n]=~s/\r//msg;$fastalist[$n]=~s/\n//msg;$fastalist[$n]=~s/\d//msg;$fastalist[$n]=~s/X//msgi;$fastalist[$n]=~s/\_//msg;$gene[$genenumber][3].=uc($fastalist[$n]);}
	}
	
	@fastalist=();
	@temp=();
	shift(@gene);
	shift(@tablelist);
	shift(@tablelist);
	for ($n=0;$n<=$#gene;$n++)
	{
		
		#Acaryochloris marina MBIC11017, complete genome
		#Product Name	Start	End	Strand	Length	Gi	GeneID	Locus	Locus_tag	COG(s)
		push(@{$gene[$n]},split(/\t/,$tablelist[$n]));
	
	}
	@tablelist=();
	my @temp=();
	my @single=();
	my @momsingle=();
	my @pair=();
	my @mompair=();
	my @trip=();
	my @momtrip=();
	my %lbag=();
	my %moml=();
	my %lstring=();
	my %score=();
	my %diff=();
	my %sstring=();
	my %pstring=();
	
	
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
	
	
	
	
	#######kstring############################################################################################################################
	
	$kmax=3;
	for $k (1..$kmax) {
		for ($n=0;$n<=$#gene;$n++)	{
			for $m (0..(length($gene[$n][3])-$k+1)) {$kbag{substr($gene[$n][3],$m,$k)}[$n]=+1/(length($gene[$n][3])-$k+1);}
		}
		@keychain=(keys %kbag);
		for $m (@keychain) {
			$momk{$m}=[moments($kbag{$m},$m)];
			$kstring{$m}=$momk{$m}[0];
		}
	}
	undef %kbag;
	
	my @monoks=();
	my @diks=();
	my @triks=();
	foreach (keys %kstring) {
		if (length == 1) {push(@monoks,$_);}
		if (length == 2) {push(@diks,$_);}
		if (length == 3) {push(@triks,$_);}
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
	%pstring=map{$_ => $kstring{substr($_,0,$k-1)}*$kstring{substr($_,1,$k)}/$kstring{substr($_,1,$k-1)}} (@triks);
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
	
	
	
		
	###############SAVE THE GENES! (& the whales)########################################################################################################################################################################################################################
	$file=">genomes/analysis/".$org[$whom][0].".txt";	
	open(AAOUT,$file) 	or die "Can't open file: $!";
	print AAOUT ("internal\tkey\tref key\tdescr\tsequence\tProduct Name\tStart\tEnd\tStrand\tLength\tGi\tGeneID\tLocus\tLocus_tag\tCOG(s)\n");
	for $i ( 0 .. $#gene ) {
		print AAOUT (($i+1)."\t".join("\t",@{$gene[$i]})."\n");
	}
	close AAOUT;
	
	
	print INFO "\n".("\n".join("\t",@{$org[$whom]})."\t$genenumber");
	
	@gene=();
	$genenumber=0;
	#############
	
JUMP:
######################################LOOP START##################################################################################################################
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
	if ($#raw<1) {print "Empty value for $current\n";}  else {
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
