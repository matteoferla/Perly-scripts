#### Objective parameters
print "Hello World\n";
use constant PI => 3.1415926535;
use strict;
my @who=qw(Ala Cys Asp Glu Phe Gly His Ile Lys Leu Met Asn Pro Gln Arg Ser Thr Val Trp Tyr stop);
#ecoli
my @aim=qw(0.094979205 0.011528026 0.051377411 0.057407375 0.038805723 0.073685219 0.022536085 0.059915446 0.043765169 0.106453518 0.028084876 0.039295849 0.044209042 0.044228439 0.054762039 0.057755759 0.053796707 0.070635547 0.015220008 0.028365374 0.003193184);
my $data=0;
my @weight=map{1} (0..20);
#$weight[20]=5;

#### Hill climbing parameters

my @climber=map{0.25} (0..11);
my @step=map{0.5} (0..11);

my $acc=1.2;
my $try=10000;
my $boot=1000;
my @way=();

$way[0]=0;
$way[1]=$acc;
$way[2]=-$acc;
$way[3]=1/$acc;
$way[4]=-1/$acc;

my $threshold=0.0001;
my @trail=();
my $basecamp= optima(\@climber);
$trail[0][0]=$basecamp;

#bound variables
##loop!
my $a=0;
my $b=0;
my $c=0;
my $d=0;
###subs
my $n=0;
my $x=0;
my $p=0;
my $u=0;
my $v=0;
my $w=0;
###Free variables
my $euway = 0;
my $eudir=0;
my $eudist=$basecamp;
my @scout=@climber;
my $dist=0;
my $stuck=0;
my @flag=@climber;
my $wanderer=0;
my $trapped=0;
my @preset=("E.coli composition", "all equal");
###user input
SPHINX:
print "Do you want to change any of the following settings?\n";
print "0\:\tRun Defaults\n";
print "1\:\tTarget amino acid composition (currently $preset[0])\n";
print "2\:\tAmino acid weights (currently $preset[1])\n";
print "3\:\tNumber of bootstraps (currently $boot)\n";
print "4\:\tNumber of iterations each (currently $try)\n";
print "5\:\tCutoff (currently $threshold)\n";
print "6\:\tPath taken is not recorded\n";
my $choice=<>;
if ($choice =~ m/1/msgi) {
	print "a\:\tE.coli composition\n";
	print "b\:\tthermophile composition\n";
	print "c\:\tEqual\n";
	print "d\:\tchange one\n";
	print "e\:\tUser input of each amino acid frequency\n";
	my $subchoice =<>;
	if ($subchoice=~ m/a/msgi) {$preset[0]="E.coli composition"; @aim=qw(0.094979205 0.054762039 0.039295849 0.051377411 0.011528026 0.044228438 0.057407375 0.073685219 0.022536085 0.059915446 0.106453518 0.043765169 0.028084876 0.038805723 0.044209042 0.057755759 0.053796707 0.015220008 0.028365374 0.070635547 0.003193184); goto SPHINX;}
	elsif ($subchoice=~ m/b/msgi) {$preset[0]="P.furiosus composition"; @aim=qw(0.039955972 0.065803849 0.017525154 0.080874447 0.071433977 0.078773498 0.043783562 0.034810545 0.042931453 0.012390077 0.044244115 0.018946486 0.015106821 0.087161768 0.100921429 0.053332701 0.049227399 0.04423549 0.005938888 0.089043652 0.003558719); goto SPHINX;}
	elsif ($subchoice=~ m/c/msgi) {$preset[0]="Equal"; @aim=map{0.0476190476190476} (0..20); goto SPHINX;}
	elsif ($subchoice=~ m/d/msgi) {
		print "Lettercode of amino acid...(anything else for stop codons) "; my $ssc=<>; chomp $ssc; $ssc=~ s/\W//msgi; $ssc=ord(uc($ssc))-65;
		if ($ssc==0) {print "freq of $who[0]...";$aim[0]=<>;chomp($aim[0]);abs($aim[0]);}
		elsif (($ssc>0) && ($ssc<9)) {print "freq of $who[$ssc-1]...";$aim[$ssc-1]=<>;chomp($aim[$ssc-1]);abs($aim[$ssc-1]);$ssc=$ssc-1;}
		elsif (($ssc>0) && ($ssc<14)) {print "freq  of $who[$ssc-2]...";$aim[$ssc-2]=<>;chomp($aim[$ssc-2]);abs($aim[$ssc-2]);$ssc=$ssc-2;}
		elsif (($ssc>0) && ($ssc<20)) {print "freq of $who[$ssc-3]...";$aim[$ssc-3]=<>;chomp($aim[$ssc-3]);abs($aim[$ssc-3]);$ssc=$ssc-3;}
		elsif (($ssc>0) && ($ssc<23)) {print "freq of $who[$ssc-4]...";$aim[$ssc-4]=<>;chomp($aim[$ssc-4]);abs($aim[$ssc-4]);$ssc=$ssc-4;}
		elsif (($ssc>0) && ($ssc==24)) {print "freq of $who[19]...";$aim[19]=<>;chomp($aim[19]);abs($aim[19]);$ssc=19;}
		else {print "freq of $who[20]...";$aim[20]=<>;chomp($aim[20]);abs($aim[20]);$ssc=20;}
		my $tally=0; for $n (0..20) {$tally+=$aim[$n]} @aim=map{$aim[$_]/$tally}(0..21);
		$preset[1]=$preset[1]." with $who[$ssc]\: $aim[$ssc]";
		goto SPHINX;}
	elsif ($subchoice=~ m/e/msgi) {$preset[0]="Custom"; my $tally=0; for $n (0..20) {print "$who[$n]..."; $aim[$n]=<>;chomp($aim[$n]);$aim[$n]=~ s/\s//mgsi; $tally+=$aim[$n]} @aim=map{$aim[$_]/$tally}(0..21); goto SPHINX;}
	else {print "invalid.\n"; goto SPHINX;}
}
elsif ($choice =~ m/2/msgi) {
	print "a\:\tEqual weights\n";
	print "b\:\tChange one weight\n";
	print "c\:\tUser input of each amino acid weight\n";
	my $subchoice =<>;
	if ($subchoice=~ m/a/msgi) {$preset[1]="all equal"; @aim=qw(0.094979205 0.054762039 0.039295849 0.051377411 0.011528026 0.044228438 0.057407375 0.073685219 0.022536085 0.059915446 0.106453518 0.043765169 0.028084876 0.038805723 0.044209042 0.057755759 0.053796707 0.015220008 0.028365374 0.070635547 0.003193184); goto SPHINX;}
	elsif ($subchoice=~ m/b/msgi) {
		print "Lettercode of amino acid...(anything else for stop codons) "; my $ssc=<>; chomp $ssc; $ssc=~ s/\W//msgi; $ssc=ord(uc($ssc))-65;
		if ($ssc==0) {print "Weight of $who[0]...";$weight[0]=<>;chomp($weight[0]);abs($weight[0]);}
		elsif (($ssc>0) && ($ssc<9)) {print "Weight of $who[$ssc-1]...";$weight[$ssc-1]=<>;chomp($weight[$ssc-1]);abs($weight[$ssc-1]);$ssc=$ssc-1;}
		elsif (($ssc>0) && ($ssc<14)) {print "Weight of $who[$ssc-2]...";$weight[$ssc-2]=<>;chomp($weight[$ssc-2]);abs($weight[$ssc-2]);$ssc=$ssc-2;}
		elsif (($ssc>0) && ($ssc<20)) {print "Weight of $who[$ssc-3]...";$weight[$ssc-3]=<>;chomp($weight[$ssc-3]);abs($weight[$ssc-3]);$ssc=$ssc-3;}
		elsif (($ssc>0) && ($ssc<23)) {print "Weight of $who[$ssc-4]...";$weight[$ssc-4]=<>;chomp($weight[$ssc-4]);abs($weight[$ssc-4]);$ssc=$ssc-4;}
		elsif (($ssc>0) && ($ssc==24)) {print "Weight of $who[19]...";$weight[19]=<>;chomp($weight[19]);abs($weight[19]);$ssc=19;}
		else {print "Weight of $who[20]...";$weight[20]=<>;chomp($weight[20]);abs($weight[20]);$ssc=20;}
		$preset[1]=$preset[1]." with $who[$ssc]\: $weight[$ssc]";
		goto SPHINX;}
	elsif ($subchoice=~ m/c/msgi) {$preset[1]="Custom"; my $tally=0; for $n (0..20) {print "$who[$n]..."; $weight[$n]=<>;chomp($weight[$n]);$weight[$n]=~ s/\s//mgsi; $tally+=$weight[$n]} @weight=map{$weight[$_]/$tally}(0..21); goto SPHINX;}
	else {print "invalid.\n"; goto SPHINX;}
}
elsif ($choice =~ m/3/msgi) {print "bootstraps..."; $boot=<>;chomp($boot);$boot=~ s/\s//mgsi; goto SPHINX;}
elsif ($choice =~ m/4/msgi) {print "iterations..."; $try=<>;chomp($try);$try=~ s/\s//mgsi; goto SPHINX;}
elsif ($choice =~ m/5/msgi) {print "threshold..."; $threshold=<>;chomp($threshold);$threshold=~ s/\s//mgsi; goto SPHINX;}
elsif ($choice =~ m/6/msgi) {print "path taken is recorded"; goto SPHINX;}
print "Running..\n";
my $now = time;
my $was =$now;




for $d (0..$boot) {
	for $a (0..$try) {
		$euway = 0;
		for $b (0..11) {
			for $c (0..4) {
				@scout=@climber;
				$scout[$b]=$climber[$b] + $step[$b]*$way[$c];
				$dist=optima(\@scout);
				if ($dist<$eudist) {
					$eudist=$dist;
					$euway=$c;
					$eudir=$b;
				}
			}

		}
		if ($euway != 0) {
			$step[$eudir]=$step[$eudir]*$way[$euway];
			$climber[$eudir]= $climber[$eudir]+ $step[$eudir];
			@climber=propo(\@climber);
			if (abs($step[$eudir])<$threshold) {$wanderer++; goto SUMMIT;}
		} else {$trapped++; goto SUMMIT;}
		
		if ((int(time-$was)>(10))) {print "bootstrap $d: $a iterations done\n"; $was=time;}

		
		$trail[$a+1][$d]=$eudist;
	}
SUMMIT:
	if (optima(\@flag)>optima(\@climber)) {@flag=@climber;}
	####Drop!
	@climber=map{rand()}(0..11);
	@step=map{rand()} (0..11);
	@climber=propo(\@climber);
	$eudist=optima(\@climber);
	$trail[0][$d+1]=$eudist;
}

@climber=@flag;
print "$boot bootstraps were performed with a maximum of $try iterations each, in ".(int($wanderer*100/$boot))."% of cases the hill-climbing algorimth reached a plateau and in in ".(int($trapped*100/$boot))."% of cases the algorimth could not go further.\n";

print ("\tA\tT\tC\tG\n");
print ("1st\t".(int(100*$climber[0])/100)."\t".(int(100*$climber[1])/100)."\t".(int(100*$climber[2])/100)."\t".(int(100*$climber[3])/100)."\n");
print ("2nd\t".(int(100*$climber[4])/100)."\t".(int(100*$climber[5])/100)."\t".(int(100*$climber[6])/100)."\t".(int(100*$climber[7])/100)."\n");
print ("3rd\t".(int(100*$climber[8])/100)."\t".(int(100*$climber[9])/100)."\t".(int(100*$climber[10])/100)."\t".(int(100*$climber[11])/100)."\n");




my $file=(">hillfit.txt");
open(OUT,$file) 	or die "Can't open file: $!";
print OUT ("least squares\titerations:$try\nmin=".optima(\@climber)."\n");
print OUT ("\tA\tT\tC\tG\n");
print OUT ("1st\t$climber[0]\t$climber[1]\t$climber[2]\t$climber[3]\n");
print OUT ("2nd\t$climber[4]\t$climber[5]\t$climber[6]\t$climber[7]\n");
print OUT ("3rd\t$climber[8]\t$climber[9]\t$climber[10]\t$climber[11]\n");
print OUT "\n";
my @prot=trans(\@climber);
for $n (0..20) {print OUT "$who[$n]\t$aim[$n]\t$prot[$n]\n";}


if ($data==1) {
print OUT ("trail\n");
for $a (0..$#trail) {print OUT ($a."\t".join("\t",@{$trail[$a]})."\n");}
}



$now = time - $now;
printf("\nTotal running time: %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));


######sub

sub optima {
	my @nt=@{ $_[0] };
	my @corrected=propo(\@nt);
	my @aa=trans(\@corrected);
	
	#least squares
	my $metric=0;
	for $p (0..20) {
		$metric+= ($weight[$p] * ($aim[$p] - $aa[$p])**2);
	}
	return ($metric);
}

sub trans {
	my @base=@{ $_[0] };
	my @cc=();
	my @prot=();
	my $checksum=0;
	for $u (0..3) {
		for $v (0..3) {
			for $w (0..3) {
				$cc[$u][$v][$w]=$base[$u]*$base[4+$v]*$base[8+$w];
				$checksum+=$cc[$u][$v][$w];
			}
		}
	}
	if (($checksum>1.05) || ($checksum<0.95)) {print "WARNING... checksum: $checksum\n";}
	$prot[0]=$cc[3][2][1]+$cc[3][2][2]+$cc[3][2][0]+$cc[3][2][3];
	$prot[1]=$cc[1][3][1]+$cc[1][3][2];
	$prot[2]=$cc[3][0][1]+$cc[3][0][2];
	$prot[3]=$cc[3][0][0]+$cc[3][0][3];
	$prot[4]=$cc[1][1][1]+$cc[1][1][2];
	$prot[5]=$cc[3][3][1]+$cc[3][3][2]+$cc[3][3][0]+$cc[3][3][3];
	$prot[6]=$cc[2][0][1]+$cc[2][0][2];
	$prot[7]=$cc[0][1][1]+$cc[0][1][2]+$cc[0][1][0];
	$prot[8]=$cc[0][0][0]+$cc[0][0][3];
	$prot[9]=$cc[1][1][0]+$cc[1][1][3]+$cc[2][1][1]+$cc[2][1][2]+$cc[2][1][0]+$cc[2][1][3];
	$prot[10]=$cc[0][1][3];
	$prot[11]=$cc[0][0][1]+$cc[0][0][2];
	$prot[12]=$cc[2][2][1]+$cc[2][2][2]+$cc[2][2][0]+$cc[2][2][3];
	$prot[13]=$cc[2][0][0]+$cc[2][0][3];
	$prot[14]=$cc[2][3][1]+$cc[2][3][2]+$cc[2][3][0]+$cc[2][3][3]+$cc[0][3][0]+$cc[0][3][3];
	$prot[15]=$cc[1][2][1]+$cc[1][2][2]+$cc[1][2][0]+$cc[1][2][3]+$cc[0][3][1]+$cc[0][3][2];
	$prot[16]=$cc[0][2][1]+$cc[0][2][2]+$cc[0][2][0]+$cc[0][2][3];
	$prot[17]=$cc[3][1][1]+$cc[3][1][2]+$cc[3][1][0]+$cc[3][1][3];
	$prot[18]=$cc[1][3][3];
	$prot[19]=$cc[1][0][1]+$cc[1][0][2];
	$prot[20]=$cc[1][0][0]+$cc[1][3][0]+$cc[1][0][3];
	
	return (@prot);
}


sub propo {
	my @wonky=@{ $_[0] };
	my $primus =0;
	my $secundus =0;
	my $tertius =0;
	my @monkey=();
	my $luhn=0;
	
	for $n (0..11) { $wonky[$n]=abs($wonky[$n]);}
	
	for $n (0..3) {
		$primus+=$wonky[$n];
		$secundus+=$wonky[$n+4];
		$tertius+=$wonky[$n+8];
	}
	
	for $n (0..3) {
		$monkey[$n]=$wonky[$n]/$primus;
		$monkey[$n+4]=$wonky[$n+4]/$secundus;
		$monkey[$n+8]=$wonky[$n+8]/$tertius;
	}
	return (@monkey);
}