#! /usr/bin/perl
print "Hello World\n";
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5;



###################################
#	parameters:
@fullabc=("A".."Z");
#@Fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
#@Fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
@abc=zeroed(\@fullabc);
my @Hydroref=(1.8, 0, 2.5, -3.5, -3.5, 2.8, -0.4, -3.2, 4.5, 0, -3.9, 3.8, 1.9, -3.5, 0, -1.6, -3.5, -4.5, -0.8, -0.7, 0, 4.2, -0.9, 0, -1.3);
my $Hstep=2; # number of steps per hydropathy score unit, so it increases in 1/step increments.
my $Sstep=100; #idem but for size...
@Cats=("A ( RNA processing and modification)","B ( Chromatin structure and dynamics)","C ( Energy production and conversion)","D ( Cell cycle control, cell division, chromosome partitioning)","E ( Amino acid transport and metabolism)","F ( Nucleotide transport and metabolism)","G ( Carbohydrate transport and metabolism)","H ( Coenzyme transport and metabolism)","I ( Lipid transport and metabolism)","J ( Translation, ribosomal structure and biogenesis)","K ( Transcription)","L ( Replication, recombination and repair)","M ( Cell wall/membrane/envelope biogenesis)","N ( Cell motility)","O ( Posttranslational modification, protein turnover, chaperones)","P ( Inorganic ion transport and metabolism)","Q ( Secondary metabolites biosynthesis, transport and catabolism)","R ( General function prediction only)","S ( Function unknown)","T ( Signal transduction mechanisms)","U ( Intracellular trafficking, secretion, and vesicular transport)","V ( Defense mechanisms)","W ( Extracellular structures)","X (Blank)","Y ( Nuclear structure)","Z ( Cytoskeleton)");
##################################

my $Hmin=int($Hstep*0.5);
my $Hmax=int($Hstep*9.5);

open(ORG,'prok_out.txt') or die "Can't find microbes: $!";
@micro=<ORG>;
chomp(@micro);
for $x (0..$#micro) {
	@{$org[$x]}=split(/\t/,$micro[$x]);
	shift(@{$org[$x]});
}

$file=">omni/special_TR.txt"; open(SNARE,$file) 	or die "Can't create file: $!";


$file=">omni/single.txt"; open(SINGLE,$file) 	or die "Can't create file: $!";
print SINGLE "org\t".join("\t",@abc)."\tStop";

$file=">omni/pair.txt"; open(PAIR,$file) 	or die "Can't create file: $!";
$file=">omni/cov.txt"; open(COV,$file) 	or die "Can't create file: $!";
$file=">omni/asymmetry.txt"; open(COV,$file) 	or die "Can't create file: $!";
$file=">omni/k2_simple.txt"; open(DISIMPLE,$file) 	or die "Can't create file: $!";
$file=">omni/k2_adv.txt"; open(DIADV,$file) 	or die "Can't create file: $!";
$file=">omni/k3_simple.txt"; open(TRISIMPLE,$file) 	or die "Can't create file: $!";
$file=">omni/k3_adv.txt"; open(TRIADV,$file) 	or die "Can't create file: $!";

$file=">omni/description.txt"; open(INFO,$file) 	or die "Can't create file: $!";
print INFO "name\tuid\tN genes";

$file=">omni/error_report.txt"; open(ERRATUM,$file) 	or die "Can't create file: $!";
print ERRATUM "name\tuid\tissue";





######################################LOOP START##################################################################################################################
for $whom (0..2) {
	
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
		{$fastalist[$n]=~s/\W//msg;$fastalist[$n]=~s/\r//msg;$fastalist[$n]=~s/\d//msg;$fastalist[$n]=~s/X//msgi;$fastalist[$n]=~s/\_//msg;$gene[$genenumber][3].=uc($fastalist[$n]);}
	}
	
	@fastalist=();
	@temp=();
	shift(@gene);
	
	for ($n=2;$n<=$#tablelist;$n++)
	{
		
		#Acaryochloris marina MBIC11017, complete genome
		#Product Name	Start	End	Strand	Length	Gi	GeneID	Locus	Locus_tag	COG(s)
		@temp=split($tablelist[$n]);
		for $m (0..$#gene) {
			if($temp[6]==$gene[$m][0]) {
				push(@{$gene[$m]},@temp[1..5,7..9]);
			}
		}
	}
	@tablelist=();
	@temp=();
	
	
	
	###########SINGLE#####################
	my @aa=(); my @len=(); my $char=(); 
	for ($n=0;$n<=$#gene;$n++)	{
		$aa[$n]=[split(//, $gene[$n][2])];
		$len[$n]=$#{$aa[$n]}+2; #start from 1 and count stop...good as a number, minus 2 as an index
		$char[$n]=[map {ord($aa[$n][$_])-65} (0..$#{$aa[$n]})];
		
		for $i (0..$#{$aa[$n]}) {$single[$char[$n][$i]][$n]+=(1/($len[$n]));}
		$single[25][$n]+=(1/($len[$n]));
	}
	
	
	for $n (0..$#single) {
		$momsingle[$n]=[moments(\@{$single[$n]})];
	}
	
	print SINGLE ("\n$org[$whom][0]\t".
	join("\t",zeroed([map{$momsingle[$_][0]}(0..$#momsingle)]))."\t$momsingle[25][0]");
	
	
	#########PAIR#############################################
	
	for ($n=0;$n<=$#gene;$n++)	{
		for $i (0..$#{$aa[$n]}) {$pair[$char[$n][$i]][$char[$n][$i+1]][$n]+=(1/($len[$n]));}
	}
	
	
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			$mompair[$ante][$post]=[moments(\@{$pair[$ante][$post]})];
		}
	}
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		print PAIR ("\n$org[$whom][0]\t".join("\t",zeroed([map{$mompair[$ante][$_][0]}(0..$#mompair)])));
	}
	



	
	
	#######kstring#####	####################
	$kmax=3;
		for $k (($kmax -2)..$kmax) {
			for ($n=0;$n<=$#gene;$n++)	{
				for $m (0..(length($gene[$n][2])-$k+1)) {$kbag[$n]{substr($gene[$n][2],$m,$k)}=+1/(length($gene[$n][2])-$k+1);}
			}
			
			for $m (keys %kbag) {
				$momk{$m}=[moments([map{$kbag[$_]{$m}}(0..$#gene)])];
				$kstring{$m}=$momk{$m}[0];
			}
		}
		undef %kbag;	
		%pstring=map{$kstring{substr($_,0,$k-1)}*$kstring{substr($_,1,$k)}/$kstring{substr($_,1,$k-1)}} (keys %kstring);
		%sstring=map{sqrt((((momk{substr($_,0,$k-1)}[0]+momk{substr($_,1,$k)}[0])/momk{substr($_,1,$k-1)}[0])**2)*((momk{substr($_,0,$k-1)}[1]*momk{substr($_,1,$k)}[1]+momk{substr($_,0,$k-1)}[1]*(momk{substr($_,1,$k)}[0]**2)+(momk{substr($_,0,$k-1)}[0]**2)*momk{substr($_,1,$k)}[1])/((momk{substr($_,0,$k-1)}[0]+momk{substr($_,1,$k)}[0]))**2+momk{substr($_,1,$k-1)}[1]/(momk{substr($_,1,$k-1)}[0]**2)))} (keys %kstring);
		%diff=map{($kstring{$_}-$pstring{$_})/$pstring{$_}} (keys %kstring);
		%score=map{($kstring{$_}-$pstring{$_})/$sstring{$_}} (keys %kstring);
	}
	
	
	###############SAVE THE GENES! (& the whales)########################################################################################################################################################################################################################
	$file=">analysis/genome/".$org[$whom][0].".txt";	
	open(AAOUT,$file) 	or die "Can't open file: $!";
	print AAOUT ("internal\tkey\tref key\tdescr\tsequence\tStart\tEnd\tStrand\tLength\tGivLocus\tLocus_tag\tCOG(s)\n");
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
	my @moment=();
	for ($n=0;$n<=$#raw;$n++)	{ $moment[0]+=$raw[$n]/($#raw+1);}
	for ($n=0;$n<=$#raw;$n++)	{ $moment[1]+=($raw[$n]-$moment[0])**2;} $moment[1]=sqrt($moment[1]/($#raw+1));
	if ($moment[1] >0) {
		for ($n=0;$n<=$#raw;$n++)	{ $moment[2]+=($raw[$n]-$moment[0])**3;} $moment[2]=($moment[2]/(($#raw+1)*($moment[1]**3)));
		for ($n=0;$n<=$#raw;$n++)	{ $moment[3]+=($raw[$n]-$moment[0])**4;} $moment[3]=($moment[3]/(($#raw+1)*($moment[1]**4)))-3;
	}
	$moment[4]=$moment[1]/$moment[0];
	$moment[5]=$moment[0]; $moment[6]=$moment[0];
	for ($n=0;$n<=$#raw;$n++)	{ if ($moment[5]>$raw[$n]) {$moment[5]=$raw[$n];}}
	for ($n=0;$n<=$#raw;$n++)	{ if ($moment[6]<$raw[$n]) {$moment[6]=$raw[$n];}}
	return (@moment);
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
