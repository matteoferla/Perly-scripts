	#! /usr/bin/perl
	print "Hello World\n";
	use constant PI => 3.1415926536;
	use constant SIGNIFICANT => 5;
	#use warnings;
	use strict;


	###################################
	#	parameters:
	my @fullabc=("A".."Z");
	#@fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
	#@fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
	my @Hydroref=(1.8, 0, 2.5, -3.5, -3.5, 2.8, -0.4, -3.2, 4.5, 0, -3.9, 3.8, 1.9, -3.5, 0, -1.6, -3.5, -4.5, -0.8, -0.7, 0, 4.2, -0.9, 0, -1.3);
	my $Hstep=2; # number of steps per hydropathy score unit, so it increases in 1/step increments.
	my $Sstep=100; #idem but for size...
	#@Cats=("A ( RNA processing and modification)","B ( Chromatin structure and dynamics)","C ( Energy production and conversion)","D ( Cell cycle control, cell division, chromosome partitioning)","E ( Amino acid transport and metabolism)","F ( Nucleotide transport and metabolism)","G ( Carbohydrate transport and metabolism)","H ( Coenzyme transport and metabolism)","I ( Lipid transport and metabolism)","J ( Translation, ribosomal structure and biogenesis)","K ( Transcription)","L ( Replication, recombination and repair)","M ( Cell wall/membrane/envelope biogenesis)","N ( Cell motility)","O ( Posttranslational modification, protein turnover, chaperones)","P ( Inorganic ion transport and metabolism)","Q ( Secondary metabolites biosynthesis, transport and catabolism)","R ( General function prediction only)","S ( Function unknown)","T ( Signal transduction mechanisms)","U ( Intracellular trafficking, secretion, and vesicular transport)","V ( Defense mechanisms)","W ( Extracellular structures)","X (Blank)","Y ( Nuclear structure)","Z ( Cytoskeleton)");
	my @statlabels=qw(avg stdev skew kurt cv min max);
	##################################

	
	my @abc=zeroed(\@fullabc);



	#$scope="omni";
	my $scope="premium";





	my $file=">$scope/tandem.txt"; open(TANDEM,$file) 	or die "Can't create file $file: $!";
	for my $y (0..$#abc) {
		for my $x (2..10)	{
			print TANDEM "\t$x x $abc[$y]";
		}
	}
	$file=">$scope/special_TR.txt"; open(SNARE,$file) 	or die "Can't create file: $!";
	

my @org=();
	$file="inventory_".$scope.".txt"; open(ORG,$file) 	or die "Can't find microbes file: $!";
	my @micro=<ORG>;
	chomp(@micro);
	shift(@micro);
	for my $x (0..$#micro) {
		@{$org[$x]}=split(/\t/,$micro[$x]);
	}

	$file=">$scope/tandem log slope.txt"; open(LOGM,$file) 	or die "Can't create file $file: $!";
	print LOGM "\t".join("\t",@abc);
	
	$file=">$scope/tandem log start.txt"; open(LOGQ,$file) 	or die "Can't create file $file: $!";
	print LOGQ "\t".join("\t",@abc);
	
	
	
	######################################LOOP START##################################################################################################################
	for my $whom (0..$#org) {
		
		#sleep 60;
		my $error=0;
		my @gene=();
		
		
		if ($org[$whom][0] eq "nothing") {print ERRATUM ("\n$org[$whom][0]\tnothingness"); print ("$org[$whom][0] is not a valid name!\n"); goto JUMP;}
		if ($org[$whom][0] eq "") {print ERRATUM ("\n$org[$whom][0]\tblankness"); print ("$org[$whom][0] is not a valid name!\n"); goto JUMP;}
		
		$file="$scope data/".$org[$whom][0].".txt"; open(FASTA,$file) 	or $error=1;
		if ($error==1) {print ERRATUM ("\n$org[$whom][0]\tno files"); print ("$org[$whom][0] has no files!\n"); goto JUMP;}
		my @fastalist=<FASTA>; chomp(@fastalist); close FASTA;
		shift(@fastalist);
		print "Analysis $org[$whom][0]...\n";
		

		for my $n (0..$#fastalist)
		{
			my @temp=split(/\t/,$fastalist[$n]);
			shift(@temp);
			for my $m (0..4) {$gene[$n][$m]=$temp[$m];}
			#internal	key	ref key	descr	sequence	COG(s) ignore rest
		}
		
		@fastalist=();
		
		##########ARRAY... FASTER############################################################
		my @aa=(); my @len=(); my @char=();
		for (my $n=0;$n<=$#gene;$n++)	{
			if (length($gene[$n][3]) <3) {
				print "Gene ($n of $#gene): @{$gene[$n]} is empty\n";
				$gene[$n][3]=qw(X Z X Z X Z X Z);
			}
			$aa[$n]=[split(//, $gene[$n][3])];
			$len[$n]=$#{$aa[$n]}+2; #start from 1 and count stop...good as a number, minus 2 as an index
			$char[$n]=[map {ord($aa[$n][$_])-65} (0..$#{$aa[$n]})];
			
		}
		
		##################TANDEM######################################################################################################################################################################################################################
		
my @tandem=();

		for (my $n=0;$n<=$#gene;$n++)	{
		my $mill = 0;
			while ( $mill <= $#{$aa[$n]})
			{
				if ($aa[$n][$mill] !~ "X") {
					my $multiloop=0;
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
			$mill++;
			} 
			
		}
		my @momtandem=();
		my @m=(); $#m=8;
		my @q=(); $#q=8;
		for my $y (0,2..8,10..13,15..19,21,22,24) {
			for my $x (0..8) {
				if (ref($tandem[$x][$y]) eq 'ARRAY') {$momtandem[$x][$y]=[moments(\@{$tandem[$x][$y]},"$x x $fullabc[$y]")];}
			}
		if 	((ref($momtandem[1][$y]) eq 'ARRAY')&&(ref($momtandem[1][$y]) eq 'ARRAY')) {
			$m[$y]=(log($momtandem[0][$y][0])-log($momtandem[1][$y][0]))/(2-3);
			$q[$y]=$m[$y]*2-log($momtandem[0][$y][0]);
		}
		}
		
		print LOGM "\n$org[$whom][0]\t".join("\t",@m);
		print LOGQ "\n$org[$whom][0]\t".join("\t",@q);
		
		print TANDEM "\n$org[$whom][0]\t";
		for my $y (0,2..8,10..13,15..19,21,22,24) {
			for my $x (0..8)	{
				if (ref($momtandem[$x][$y]) eq 'ARRAY') {print TANDEM "$momtandem[$x][$y][0]\t";} else {print TANDEM "\t";}
			}
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

sub estdev {
	my ($string,$momkref)=@_;
	my %mom=%$momkref;
	if (ref($mom{$string}) ne 'ARRAY') {print "Impossible error Line 553: $string, $momkref,$mom{$string}[0],.".ref($mom{$string})."\n"; <>;}
	my $kay=length($string);
	if ($kay==0) {die "zero length ($kay) string $string sent to estdev sub, which is impossible"; return;}
	elsif ($kay==1) {die "one length string sent to estdev sub, which is impossible... will add something here though in future";return;}
	elsif ($kay==2) {my $x=substr($string,0,$kay-1);my $y=substr($string,1,$kay-1);
		my $var=($mom{$x}[1]*$mom{$y}[1])**2+($mom{$x}[1]*$mom{$y}[0])**2+($mom{$x}[0]*$mom{$y}[1])**2;
		return sqrt($var);
	}
	elsif ($kay>2) {
		my $x=substr($string,0,$kay-1); if ($mom{$x}[0]==0) {print "Error prevented: $string: $mom{$string}[0], but $x: $mom{$x}[0]\n"; return 0;}
		my $y=substr($string,1,$kay-1); if ($mom{$y}[0]==0) {print "Error prevented: $string: $mom{$string}[0], but $y: $mom{$y}[0]\n"; return 0;}
		my $z=substr($string,1,$kay-2); if ($mom{$z}[0]==0) {print "Division by zero prevented: $string: $mom{$string}[0], but $z: $mom{$z}[0]\n"; return 0;}
		my $var=((
		$mom{$x}[0]+$mom{$y}[0]
		)/$mom{$z}[0]
		)**2
		*(($mom{$x}[1]*$mom{$y}[1])**2
		+($mom{$x}[1]*$mom{$y}[0])**2
		+($mom{$x}[0]*$mom{$y}[1])**2
		/($mom{$x}[0]+$mom{$y}[0])**2
		+($mom{$z}[1]/$mom{$z}[0])**2);
		return sqrt($var);
	}
}


sub filegroup {
	my ($ref_name,$ref_header) = @_;
	my @name=@$ref_name;
	my @header=@$ref_header;
	my $looper="off";
	if (ref($header[0]) eq "ARRAY") {$looper=0;}
	my @handle;
	foreach $file (@name) {
		open my $file, '>', $file or die "Error $file $!";
		if ($looper eq "off") {	print $file ("org\t".join("\t",@header)); }
		else {print $file ("org\t".join("\t",@{$header[$looper]})); $looper++;} 
		push (@handle, $file);
	}
	return @handle;
}