#!/usr/bin/perl
print "Howdy Worrld\n";
#$treeone="((((224324,608538)436114),(((438753,176299)272947),(407148,387092),(290398(511145,99287),(58051,357804),(208964,259536)272843)267608),(525909((290399(196627(561304,757418))266940)206672)521003(469383,266117)),(441768(272635,565575)),((224326,243276)355276),((((224308,420246,221109)158879),(321967,299768)),(272562((246194,580331)309798))),((226186,518766)517418),(324602,243164),((497964,481448),(115713,765952)313628),(469381,525903),((243230,649638),((504728,526227),(498848,300852)))309799,445932(381764,521045,403833,484019(243274,390874)),(190304,523794,519441,526218)379066(330214,289376),(103690,1148),(521674,243090),(653733,447454,525904)),((439481,224325(64091,362976,348780),((((188937,192952)259564,547558)349307)456442),(419665,243232)190192(420247,187420),((272844,186497,70601)593117),(273075,273116)),(((272557,453591,399550)415426)666510(399549,273057),(178306,368408)),(414004,436308)374847,228908),(9606,559292))";
$treeone="((1,2)(3,(4,5))6)";
(@array)=gardener($treeone);
@tag=@{$array[0]};
@distance=@{$array[1]};
#@con=@{$array[2]};
@nodetier=@{$array[3]};
@fulltier=@{$array[4]};
@con=@{$array[5]};
@csnode=@{$array[6]};
@array=();
print "reference made\ttree one: $treeone\n";
###############TREE 2#############################################
$treetwo="((1,2)(4,(3,5))6)";
#$treetwo="((((224324,608538)436114),(((438753,176299)272947),(407148,387092),(290398(511145,99287),(58051,357804),(208964,259536)272843)267608),(525909((290399(196627(561304,757418))266940)206672)521003(469383,266117)),(441768(272635,565575)),((224326,243276)355276),((((224308,420246,221109)158879),(321967,299768)),(272562((246194,580331)309798))),((226186,518766)517418),(324602,243164),((497964,481448),(115713,765952)313628),(469381,525903),((243230,649638),((504728,526227),(498848,300852)))309799,445932(381764,521045,403833,484019(243274,390874)),(190304,523794,519441,526218)379066(330214,289376),(103690,1148),(521674,243090),(653733,447454,525904)),((439481,224325(64091,362976,348780),((((188937,192952)259564,547558)349307)456442),(419665,243232)190192(420247,187420),(((272844,186497)70601)593117),(273075,273116)),(((272557,453591,399550)415426)666510(399549,273057),(178306,368408)),(414004,436308)374847,228908),(9606,559292))";
(@array)=gardener($treetwo);
@eutag=@{$array[0]};
@eudistance=@{$array[1]};
#@eucon=@{$array[2]};
@eunodetier=@{$array[3]};
@eufulltier=@{$array[4]};
@eucon=@{$array[5]};
@eucsnode=@{$array[6]};
@array=();
print "sample made\ttree two: $treetwo\n";
################overlay

if ($deadcode==1) {
	print "The pairwise differences are\:\n";
	$issue=0;
	for $ni (0..$#tag) {
		$n=$tag[$ni];
		for $mi (0..$#tag) {
			if ($mi < $ni) {
				$m=$tag[$mi];
				if (($distance[$n][$m]>$eudistance[$n][$m]+$eucon[$n][$m])||($distance[$n][$m]<$eudistance[$n][$m])) {$issue++; $report[$n]++;$report[$m]++; print "Difference with $n and $m ($distance[$n][$m]\^ and $eudistance[$n][$m]\^ tier nodes)\n";}
				$count++;
			}
		}
	}
	print "$issue issues out of $count.\n";
}


for $ta (0..$#fulltier) {
	for $sa (0..$#{$fulltier[$ta]}) {
		$texttier[$ta][$sa]=join("\:",destring($fulltier[$ta][$sa]));
	}
}

for $ta (0..$#eufulltier) {
	for $sa (0..$#{$eufulltier[$ta]}) {
		$eutexttier[$ta][$sa]=join("\:",destring($eufulltier[$ta][$sa]));
	}
}


for $ta (0..$#eutexttier) {
	for $sa (0..$#{$eutexttier[$ta]}) {
		for $tb (0..$#texttier) {
			for $sb (0..$#{$texttier[$tb]}) {
				if ($eutexttier[$ta][$sa] eq $texttier[$tb][$sb]) {
					$node[$ta][$sa]{correspondance}="$tb\:$sb";
					$tp=$eunodetier[$ta][$sa]; @temp=($tp=~ m/(N\d+\_\d*)/g); for $n (@temp) {$n=~ m/N(\d*)\_(\d*)/g; $a=$1; $b=$2; if (length($node[$a][$b]{issue})>0) {print "Missalignment from node N$a\_$b solved in node N$ta\_$tb\n";}}
					goto BUNGEE;}
				
			}
		}
		$temp=$eunodetier[$ta][$sa];
		$temp=~ s/N\d+_\d+//g;
		@oddoneout=destring($temp);
		$tp=$eunodetier[$ta][$sa]; @temp=($tp=~ m/(N\d+\_\d*)/g); for $n (@temp) {$n=~ m/N(\d*)\_(\d*)/g; $subclash[$ta][$sa].=$subclash[$1][$2];}
		$temp="not inhereted from subnodes"; $tempi="no degerate branches";
		if (length($subclash[$ta][$sa])>1) {$temp="$subclash[$ta][$sa] inherited from subnodes"; $subclash[$ta][$sa].=":";}
		if ($eucon[$ta][$sa]>0) {$tempi="$eucon[$ta][$sa] upstream degenerate nodes namely $eucsnode[$ta][$sa]";}
		$subclash[$ta][$sa].=join(":",@oddoneout);
		print "$eunodetier[$ta][$sa] ($eufulltier[$ta][$sa]) subtree is unmatched due to @oddoneout ($temp, $tempi).\n";
		$node[$ta][$sa]{issue}=join(":",@oddoneout);
	BUNGEE:
	}
}
###################Subs################################################################################################################################################################
###################################################################################################################################################################################
######################################################################################################################################################################################
sub destring {
	my $a=$_[0];
	my @temp=($a=~ m/(\d+)/g);
	my @tempus=();
	for $n (@temp) {if ($n>0) {push(@tempus,$n);}}
	return (sort(@tempus));
}

sub denodestring {
	my $a=$_[0];
	my @temp=($a=~ m/(N\d+\_\d+)/g);
	$a=~ s/(N\d+\_\d+)//g;
	my @tempus=();
	for $n (@temp) {if (length($n)>0) {push(@tempus,$n);}}
	push(@tempus,destring($a));
	return (sort(@tempus));
}


sub gardener {
	my $tree=$_[0];
	
	my @temp=();
	my @consentience=();
	my @stackedconsentience=();
	my @tag=();
	my @distance=();
	my @con=();
	my @tier=();
	my @extier=();
	my @connode=();
	my $backup=$tree;
	$tree=~ s/\(/</msgi;
	$tree=~ s/\)/>/msgi;
	@tag=destring($tree);
	$t=0;
	while (($tree=~ /[<>]/)&&($t<10)) {
		$t++;
		$qwerty=$tree;  #most bizzare error otherwise to do with pos($tree)!
		$tier[$t]= [($qwerty=~ m/<([N\_\d\,]*)>/g)];
		for $n (0..$#{$tier[$t]}) {
			$tree=~ s/<$tier[$t][$n]>/,N$t\_$n,/g;
			$tier[$t][$n]=~ s/,,/,/g;
			$tier[$t][$n]=~ s/<,/</g;
			$tier[$t][$n]=~ s/,>/>/g;
		}
		$tree=~ s/,,/,/g;
		$tree=~ s/<,/</g;
		$tree=~ s/,>/>/g;
	}
	
	
	for $t (1..$#tier) {
		for $s (0..$#{$tier[$t]}) {
			$extier[$t][$s]=$tier[$t][$s];
			$extier[$t][$s]=~ s/N(\d)\_(\d+)/<$extier[$1][$2]>/g;
		}
		
	}
	
	
	
	
	@consentience=();
	@stackedconsentience=();
	@distance=0;
	for ($t=$#extier;$t>=1;$t--) {
		for $s (0..$#{$extier[$t]}) {
			if ($tier[$t][$s]=~ m/\,(N\d\_\d+)?\d*\,/) {
				$n=($tier[$t][$s]=~ s/\,/\./g);$tier[$t][$s]=~ s/\./\,/g;
				$consentience[$t][$s]+=$n-1; $stackedconsentience[$t][$s]+=$n-1; @tempus=denodestring($tier[$t][$s]); push(@tempus,$connode[$t][$s]); $connode[$t][$s]=join(":",@tempus); $connode[$t][$s]=~s/:://g; $connode[$t][$s]=~s/^://g; $connode[$t][$s]=~s/:$//g;
				if ($tier[$t][$s]=~ m/N(\d)\_(\d+)/) {$a=$1; $b=$2; $stackedconsentience[$a][$b]+=$stackedconsentience[$t][$s]; @tempus=(); push(@tempus,$connode[$a][$b]); push(@tempus,$connode[$t][$s]); $connode[$a][$b]=join("\:",@tempus); $connode[$a][$b]=~s/:://g; $connode[$a][$b]=~s/^://g; $connode[$a][$b]=~s/:$//g;}
			}
		}
		
	}
	if ($deadcode==1) {
		for $n (@tag) {$distance[$n][$n]=0;}
		$err=0;
		for $ni (0..$#tag) {	
			$n=$tag[$ni];
			for $mi (0..$#tag) {
				if ($mi < $ni) {
					$m=$tag[$mi];
					for $t (0..$#extier) {
						for $s (0..$#{$extier[$t]}) {
							pos($extier[$t][$s])=0;
							$search="\_$extier[$t][$s]\_";
							if (($search=~ /\D$n\D/)&&($search=~ /\D$m\D/)) {$distance[$n][$m]=$t; $distance[$m][$n]=$t; $con[$m][$n]=$stackedconsentience[$t][$s]; goto WELL; }
						}
					}
					$err++;
					print "Error with $n and $m not found in $backup aka @{$extier[$#extier]}\n";
				WELL:
				}
			}
		}
		
	}
		return (\@tag,\@distance,\@con,\@tier,\@extier,\@stackedconsentience,\@connode);
}
__DATA__
