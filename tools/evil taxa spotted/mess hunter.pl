#!/usr/bin/perl
print "Program starting...\n";
print "I need to remove the esses on the names of the file handles and switch back wordyy to wordy";

$file='names.txt'; open(NAMES,$file) or die "Can't open file ($file): $!";
$file='nodes.txt'; open(NODES,$file) or die "Can't open file ($file): $!";
@temp=();
@temp=<NAME>;
chomp(@temp);
foreach (@temp) {	push(@name,[split(/\t/)]);	}
close NAME;
print "\rnomeclature loaded....\n";
@temp=();
@temp=<NODE>;
chomp(@temp);
foreach (@temp) {	push(@node,[split(/\t/)]);	}
close NODE;
print "\rtaxonomy nodes loaded....\n";
for $n (0..$#name) {
	if (($name[$n][0]!=$name[$n-1][0])||($name[$n][3] =~ /scientific name/)) {$name[$n][1]=~s/^(\w)\w+ (\w+).*/$1\_$2/; $id[abs($name[$n][0])]=$name[$n][1]; }
}
	undef @name;

for $n (0..$#node) {
	$papa[abs($node[$n][0])]=abs($node[$n][1]);
}
undef @node;
#$treeone="((((224324,608538)436114),(((438753,176299)272947),(407148,387092),(290398(511145,99287),(58051,357804),(208964,259536)272843)267608),(525909((290399(196627(561304,757418))266940)206672)521003(469383,266117)),(441768(272635,565575)),((224326,243276)355276),((((224308,420246,221109)158879),(321967,299768)),(272562((246194,580331)309798))),((226186,518766)517418),(324602,243164),((497964,481448),(115713,765952)313628),(469381,525903),((243230,649638),((504728,526227),(498848,300852)))309799,445932(381764,521045,403833,484019(243274,390874)),(190304,523794,519441,526218)379066(330214,289376),(103690,1148),(521674,243090),(653733,447454,525904)),((439481,224325(64091,362976,348780),((((188937,192952)259564,547558)349307)456442),(419665,243232)190192(420247,187420),((272844,186497,70601)593117),(273075,273116)),(((272557,453591,399550)415426)666510(399549,273057),(178306,368408)),(414004,436308)374847,228908),(9606,559292))";
$treeone="(((272557,453591,399550)415426)666510(399549,273057),(178306,368408))";
(@array)=gardener($treeone);
@eutag=@{$array[0]};
@eudistance=@{$array[1]};
#@con=@{$array[2]};
@nodetier=@{$array[3]};
@fulltier=@{$array[4]};
@con=@{$array[5]};
@csnode=@{$array[6]};
@array=();

for $t (0..$#fulltier) {
	for $s (0..$#{$fulltier[$t]}) {
		$eunode[$t][$s]{full}=$fulltier[$t][$s];
		$eunode[$t][$s]{abb}=$nodetier[$t][$s];
		$eunode[$t][$s]{abb}=~ s/N/T/g;
		$eunode[$t][$s]{text}=join("\:",destring($eunode[$t][$s]{full}));
		$eunode[$t][$s]{csnode}=$csnode[$t][$s];
		$eunode[$t][$s]{con}=$con[$t][$s];
		$tp=$eunode[$t][$s]{abb};
		@temp=($tp=~ m/(N\d+\_\d*)/g);
		for $n (@temp) {$n=~ m/N(\d*)\_(\d*)/g; $a=$1; $b=$2; $node[$a][$b]{intnode}="N$t\_$s";}
	}
}

for $n (0..$#eutag) {
	$eunode[0][$n]{full}=$tag[$n];
	$eunode[0][$n]{abb}=$tag[$n];
	$eunode[0][$n]{text}=$tag[$n];
}

@nodetier=();
@fulltier=();
@con=();
@csnode=();
print "\r";
print "reference made\ttree one: \n".wordy($treeone)."\n\n";
###############TREE 2#############################################
$treetwo="(((272557,453591,399550)415426)399549(666510,273057),(178306,368408))";
#$treetwo="((((224324,608538)436114)((((438753,176299)272947),(407148,387092))(290398(511145,99287),(58051,357804),(208964,259536)272843)267608),(525909((290399(196627(561304,757418))266940)206672)521003(469383,266117)),(441768(272635,565575)),((224326,243276)355276),((((224308,420246,221109)158879),(321967,299768)),(272562((246194,580331)309798))),((226186,518766)517418),(324602,243164),((497964,481448),(115713,765952)313628),(469381,525903),((243230,649638),((504728,526227),(498848,300852)))309799,445932(381764,521045,403833,484019(243274,390874)),(190304,523794,519441,526218)379066(330214,289376),(103690,1148),(521674,243090),(653733,447454,525904)),((439481,224325(64091,362976,348780),((((188937,192952)259564,547558)349307)456442),(419665,243232)190192(420247,187420),(((272844,186497)70601)593117),(273075,273116)),(((272557,453591,399550)415426)666510(399549,273057),(178306,368408)),(414004,436308)374847,228908),(9606,559292))";
(@array)=gardener($treetwo);
@tag=@{$array[0]};
@distance=@{$array[1]};
#@con=@{$array[2]};
@nodetier=@{$array[3]};
@fulltier=@{$array[4]};
@con=@{$array[5]};
@csnode=@{$array[6]};
@array=();
for $t (0..$#fulltier) {
	for $s (0..$#{$fulltier[$t]}) {
		$node[$t][$s]{full}=$fulltier[$t][$s];
		$node[$t][$s]{abb}=$nodetier[$t][$s];
		$node[$t][$s]{text}=join("\:",destring($node[$t][$s]{full}));
		$node[$t][$s]{csnode}=$csnode[$t][$s];
		$node[$t][$s]{con}=$con[$t][$s];
		$tp=$node[$t][$s]{abb};
		@temp=($tp=~ m/(N\d+\_\d*)/g);
		for $n (@temp) {$n=~ m/N(\d*)\_(\d*)/g; $a=$1; $b=$2; $node[$a][$b]{intnode}="N$t\_$s";}
		#$nodename[$t][$s]=
	}
}
for $n (0..$#tag) {
	$node[0][$n]{full}=$tag[$n];
	$node[0][$n]{abb}=$tag[$n];
	$node[0][$n]{text}=$tag[$n];
}

@nodetier=();
@fulltier=();
@con=();
@csnode=();
print "sample made\ttree two: \n".wordy($treetwo)."\n\n";
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


for $ta (1..$#eunode) {
	for $sa (0..$#{$eunode[$ta]}) {
		for $tb (0..$#node) {
			for $sb (0..$#{$node[$tb]}) {
				if ($eunode[$ta][$sa]{text} eq $node[$tb][$sb]{text}) {
					$eunode[$ta][$sa]{correspondance}="N$tb\_$sb";
					$node[$tb][$sb]{correspondance}="T$ta\_$sa";
					#print "T$ta\_$sa ($eunode[$ta][$sa]{text}) contains the same elements as N$tb\_$sb ($node[$tb][$sb]{text})\n";
					$tp=$eunode[$ta][$sa]{abb}; @temp=($tp=~ m/(T\d+\_\d*)/g);
					for $n (@temp) {$n=~ m/T(\d*)\_(\d*)/g; $a=$1; $b=$2;
						if ($eunode[$a][$b]{issue}>0) {
							$eunode[$a][$b]{fix}="T$ta\_$sa";$eunode[$a][$b]{fixcorr}="T$tb\_$sb"; $eunode[$ta][$sa]{fixed}="T$a\_$b"; 
							$eunode[$a][$b]{diff}=$node[$tb][$sb]{abb};
							$tp=$eunode[$a][$b]{diff}; @tempii=($tp=~ m/(N\d+\_\d+)/g);
							for $m (@tempii) {$m=~ m/N(\d+)\_(\d+)/g; $c=$1; $d=$2;  if (length($node[$c][$d]{correspondance})>0) {$eunode[$a][$b]{diff}=~ s/N$c\_$d/$node[$c][$d]{correspondance}/;}}
							
						}
					}
					goto BUNGEE;}
				
			}
		}
		

		$tp=$eunode[$ta][$sa]{abb}; @temp=($tp=~ m/(T\d+\_\d*)/g); for $n (@temp) {$n=~ m/T(\d+)\_(\d+)/g; if ($eunode[$1][$2]{issue}>0) {goto BUNGEE;}}
		$eunode[$ta][$sa]{issue}=1;
	BUNGEE:
	}
}

for $t (0..$#eunode) {
	for $s (0..$#{$eunode[$t]}) {
		if ($eunode[$t][$s]{issue}>0) {
			$temp="not inhereted from subnodes"; $tempi="no degerate branches";
			if ($eucon[$t][$s]>0) {$tempi="$eunode[$t][$s]{con} upstream degenerate nodes namely ".wordy($eunode[$t][$s]{csnode});}
			#if (length($eunode[$t][$s]{subclash})>1) {$temp="issue with ".wordy($eunode[$t][$s]{subclash})." inherited from subnodes"; }
			
			$query=$eunode[$t][$s]{fix};
			$query=$eunode[tier($query)][st($query)]{full};
			$queryalt=$eunode[$t][$s]{fixcorr};
			$queryalt=$node[tier($queryalt)][st($queryalt)]{full};
			print "The subtree of ".wordy("T$t\_$s")." (".wordy($eunode[$t][$s]{full}).") has not been matched ($tempi), \nreference:".wordy($eunode[$t][$s]{fix})."(";
			print wordy($query).") \nempirical: (".wordy($queryalt).")\ndifference: $eunode[$t][$s]{diff}\n";
			if (length($eunode[$ta][$sa]{subclash})>1) {$eunode[$ta][$sa]{subclash}.=":";}
			$eunode[$ta][$sa]{subclash}.=join(":",@oddoneout);
		}
	}
}



###################Subs################################################################################################################################################################
###################################################################################################################################################################################
######################################################################################################################################################################################
sub tier{
	my $nd=$_[0];
	$nd=~ m/[NT](\d*)\_(\d*)/;
	$a=$1;
	return ($a);
}
sub st{
	my $nd=$_[0];
	$nd=~ m/[NT](\d*)\_(\d*)/;
	$a=$2;
	return ($a);
	
}
sub wordy { return $_[0];}
sub wordyy {
	my $tree=$_[0];
	$bk=$tree;
	$tree=~s/</\(/g;
	$tree=~s/>/\)/g;
	$tree=~s/\:/ \& /g;
	$t=$tree;
	my @temp=($t=~ m/(T\d+\_\d+)/g);
	for $n (@temp) {if (length($n)>0) {$m=$id[nodenamer($eunode[tier($n)][st($n)]{full})]; $tree=~ s/$n/$m/g;}}
	my @temp=($t=~ m/(N\d+\_\d+)/g);
	for $n (@temp) {if (length($n)>0) {$m=$id[nodenamer($node[tier($n)][st($n)]{full})]; $tree=~ s/$n/$m/g;}}
	$tree=~s/(\d+)/$id[$1]/g;
	return $tree;
}

sub destring {
	my $a=$_[0];
	$a=~ s/[NT]\d+_\d+//g;
	my @temp=($a=~ m/(\d+)/g);
	my @tempus=();
	for $n (@temp) {if ($n>0) {push(@tempus,$n);}}
	return (sort(@tempus));
}

sub denodestring {
	my $a=$_[0];
	my @temp=($a=~ m/([NT]\d+\_\d+)/g);
	$a=~ s/([NT]\d+\_\d+)//g;
	my @tempus=();
	for $n (@temp) {if (length($n)>0) {push(@tempus,$n);}}
	push(@tempus,destring($a));
	return (sort(@tempus));
}


sub gardener {
	my $tree=$_[0];
	my @node=();
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

sub nodenamer {
	my $string=$_[0];
	my @aim=destring($string);
	my %counter=();
	foreach $x (@aim) {
		$x=abs($x);
		$count[$x]=2;
		$t=$papa[$x];
		@temp=();
		while ($t>1) {
			push(@temp,$t);
			$t=$papa[$t];
		}
		$lin[$x]=[@temp];
		for $n (0..$#temp) {
			$lin[$temp[$n]]=[@temp[$n..$#temp]];
			$count[$temp[$n]]++;
		}
	}
	

	for $xi (0..$#aim) {
		$x=$aim[$xi];
		for $yi (0..($xi-1)) {
			$y=$aim[$yi];
			for $u (0..$#{$lin[$x]}) {
				for $v (0..$#{$lin[$y]}) {
					if (($lin[$x][$u]==$lin[$y][$v])&&(length($lin[$x][$u])>0)) {$counter{$lin[$x][$u]}++; goto HERE;}
				}
			}
			print "crap!\n";
		HERE:
		}
	}
	$max=0;
	$mwho=1;
	for $n (keys %counter) {
		if ($counter{$n}>$max) {$max=$count{$n}; $mwho=$n;}
	}
	return $mwho;
}
__DATA__
