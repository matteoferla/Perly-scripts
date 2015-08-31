#!/usr/bin/perl
print "Howdy Worrld\n";
$file='>done.txt'; open(DONE,$file) or die "Can't make file ($file): $!";
$file='>out.txt'; open(OUT,$file) or die "Can't make file ($file): $!";

$tree="((((224324,608538)436114),(((438753,176299)272947),(407148,387092),(290398(511145,99287),(58051,357804),(208964,259536)272843)267608),(525909((290399(196627(561304,757418))266940)206672)521003(469383,266117)),(441768(272635,565575)),((224326,243276)355276),((((224308,420246,221109)158879),(321967,299768)),(272562((246194,580331)309798))),((226186,518766)517418),(324602,243164),((497964,481448),(115713,765952)313628),(469381,525903),((243230,649638),((504728,526227),(498848,300852)))309799,445932(381764,521045,403833,484019(243274,390874)),(190304,523794,519441,526218)379066(330214,289376),(103690,1148),(521674,243090),(653733,447454,525904)),((439481,224325(64091,362976,348780),((((188937,192952)259564,547558)349307)456442),(419665,243232)190192(420247,187420),((272844,186497,70601)593117),(273075,273116)),(((272557,453591,399550)415426)666510(399549,273057),(178306,368408)),(414004,436308)374847,228908),(9606,559292))";
$backup=$tree;
$tree=~ s/\(/</msgi;
$tree=~ s/\)/>/msgi;
@temp=($tree=~ m/(\d+)/g);
for $n (@temp) {if ($n>0){push(@tag,$n);}}
while (($tree=~ /[<>]/)&&($t<10)) {
	$t++;
	$qwerty=$tree;
	$tier[$t]= [($qwerty=~ m/<([N\_\d\,]*)>/g)];
	for $n (0..$#{$tier[$t]}) {
		$tree=~ s/<$tier[$t][$n]>/,N$t\_$n,/g;
	}
	$tree=~ s/,,/,/g;
	$tree=~ s/<,/</g;
	$tree=~ s/,>/>/g;
}



print OUT "$backup\n";
print OUT "$tree\n";
for $t (1..$#tier) {
	for $s (0..$#{$tier[$t]}) {
		$extier[$t][$s]=$tier[$t][$s];
		$extier[$t][$s]=~ s/N(\d)\_(\d+)/<$extier[$1][$2]>/g;
		print OUT "tier $t subtree $s\t$extier[$t][$s]\t$tier[$t][$s]\n";
	}
	
}




@consentience=();
for ($t=$#extier;$t>=1;$t--) {
	for $s (0..$#{$extier[$t]}) {
		if ($tier[$t][$s]=~ m/\,(N\d\_\d+)?\d*\,/) {
			$consentience[$t][$s]++; $stackedconsentience[$t][$s]++;
			if ($tier[$t][$s]=~ m/N(\d)\_(\d+)/) {$stackedconsentience[$1][$2]+=$stackedconsentience[$t][$s];}
		}
	}
	
}

#print "TEST...... ".$extier[$#$extier][$#{$extier[$#$extier]}]."\n";

#given $n and $m what is thier LCD?
@distance=();
for $n (@tag) {$distance[$n][$n]=0;}
$err=0;
print DONE "\t".join("\t",@tag);
for $ni (0..$#tag) {	print DONE "\n$n\t";
	$n=$tag[$ni];
	for $mi (0..$#tag) {
		if ($mi < $ni) {
			$m=$tag[$mi];
			for $t (0..$#extier) {
				for $s (0..$#{$extier[$t]}) {
					pos($extier[$t][$s])=0;
					if (($extier[$t][$s]=~ /\D$n\D/)&&($extier[$t][$s]=~ /\D$m\D/)) {$distance[$n][$m]=$t; $distance[$m][$n]=$t; $con[$m][$n]=$stackedconsentience[$t][$s]; $match++; goto HELL; }
				}
			}
			$err++;
		HELL:
			print DONE "$distance[$n][$m]($con[$m][$n])\t"
		}
		
	}
}
print DONE "\n";
close DONE;
print "$err errors and $match matches in Total ($#tag)\n";
################overlay

#ABOVE FOR SECOND TREE.

#if (($empdistance[$n][$m]>$con[$m][$n]+$distance[$n][$m])&&($empdistance[$n][$m]>$con[$m][$n]+$distance[$n][$m])) {}









