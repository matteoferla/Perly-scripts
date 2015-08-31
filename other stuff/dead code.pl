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



__END__

#####################################################################DEAD CODE##############################################
##########################################################################################################################################
###legacy... will delete one day
foreach $ante (@Abc) {
	foreach $post (@Abc) {
		push(@diabc,"$ante$post")
	}
}

foreach $ante (@Abc) {
	foreach $mid (@Abc) {
		foreach $post (@Abc) {
			push(@triabc,"$ante$mid$post")
		}
	}
}

foreach $ante (@Abc) {
	foreach $midfore (@Abc) {
		foreach $midback (@Abc) {
			foreach $post (@Abc) {
				push(@tetraabc,"$ante$midfore$midback$post")
			}
		}
	}
}
if (1==0) {
	
	$file=">$Scope/special_TR.txt"; open(SNARE,$file) 	or die "Can't create file: $!";
	$file=">$Scope/description.txt"; open(INFO,$file) 	or die "Can't create file: $!";
	print INFO "name\tuid\tN genes";
	
	$file=">$Scope/error_report.txt"; open(ERRATUM,$file) 	or die "Can't create file: $!";
	print ERRATUM "name\tuid\tissue";
	
	$file=">$Scope/single.txt"; open(SINGLE,$file) 	or die "Can't create file: $!";
	print SINGLE "Org\t".join("\t",@Abc)."\tStop";
	
	my @singlefiles=filegroup("$Scope/extra/single_#.txt",\@Statlabels,\@Abc);
	
	
	
	
	
	
	$file=">$Scope/pair.txt"; open(PAIR,$file) 	or die "Can't create file: $!";
	
	print PAIR "Org\t".join("\t",@diabc);
	
	my @pairfiles=filegroup("$Scope/extra/pair_#.txt",\@Statlabels,\@Abc);
	
	
	$file=">$Scope/triplet.txt"; open(TRIP,$file) 	or die "Can't create file: $!";
	
	print TRIP "Org\t".join("\t",@triabc);
	
	my @tripfiles;
	foreach $stat (0..$#Statlabels)
	{
		$file="$Scope/extra/triplet_$Statlabels[$stat].txt";
		open my $fh, '>', $file or die "Cannot open $file: $!";
		push(@tripfiles,$fh);
		$temp=$tripfiles[$stat];
		print $temp ("Org\t".join("\t",@triabc)."\tStop");
	}
	
	
	$file=">$Scope/covariance.txt"; open(COV,$file) 	or die "Can't create file: $!";
	$file=">$Scope/pearson.txt"; open(PEAR,$file) 	or die "Can't create file: $!";
	print COV "Org\t";
	print PEAR "Org\t";
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			if ($ante<$post) {
				print PEAR "$fullabc[$ante]$fullabc[$post]\t";
				print COV "$fullabc[$ante]$fullabc[$post]\t";
			}
		}
	}
	
	
	$file=">$Scope/tandem.txt"; open(TANDEM,$file) 	or die "Can't create file $file: $!";
	for $y (0..0) {
		for $x (0..8)	{
			print TANDEM "\t$x x $Abc[$y]";
		}
	}
	
	
} ### OFF

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

if(1==0) {##############################DISABLEMENT##############################DISABLEMENT############################
	for $n (0,2..8,10..13,15..19,21,22,24,25) {
		$momsingle[$n]=[moments(\@{$single[$n]},$fullabc[$n])];
	}
	
	print SINGLE ("\n$Org[$Whom][0]\t");
	for $letter (0,2..8,10..13,15..19,21,22,24) {
		print SINGLE ($momsingle[$letter][0]."\t");
	}
	
	for $stat (0..$#Statlabels) {
		$temp=$singlefiles[$stat];
		print $temp ("\n$Org[$Whom][0]\t");
		for $letter (0,2..8,10..13,15..19,21,22,24) {
			print $temp ($momsingle[$letter][$stat]."\t");
		}
	}
	#########GENOME##############################################
	$file=">$Scope/extra/$Org[$Whom][0].txt"; open(ALLSINGLE,$file) 	or die "Can't create file: $!";
	print ALLSINGLE "gene\t".join("\t",@Abc)."\tStop\n";
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
	
	print COV "\n$Org[$Whom][0]\t";
	print PEAR "\n$Org[$Whom][0]\t";
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
	
	print PAIR "\n$Org[$Whom][0]\t";
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $post (0,2..8,10..13,15..19,21,22,24) {
			print PAIR ($mompair[$ante][$post][0]."\t");
		}
	}
	
	for $stat (0..$#Statlabels) {
		$temp=$pairfiles[$stat];
		print $temp ("\n$Org[$Whom][0]\t");
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
	
	print TRIP "\n$Org[$Whom][0]\t";
	for $ante (0,2..8,10..13,15..19,21,22,24) {
		for $mid (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				print TRIP ($momtrip[$ante][$mid][$post][0]."\t");
			}
		}
	}
	
	for $n (0..$#Statlabels) {
		$temp=$tripfiles[$stat];
		print $temp ("\n$Org[$Whom][0]\t");
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
					print SNARE "\n$Org[$Whom][0]\t$gene[$n][0]\t$gene[$n][2]\t$gene[$n][3]\t".($multiloop+2).$aa[$n][$mill];
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
	
	print TANDEM "\n$Org[$Whom][0]\t";
	for $y (0..$#abc) {
		for $x (0..8)	{
			print TANDEM "$momtandem[$x][$y][0]\t";
		}
	}
}	##############################DISABLEMENT##############################DISABLEMENT##############################DISABLEMENT##############################DISABLEMENT##############################DISABLEMENT
