#!/usr/bin/perl
use sub;
sub::clear;
print "Program starting...\n";
my $timer=time();

#######################
$file='>average_err.txt'; open(DONE,$file) or die "Can't make file ($file): $!";
#######################


foreach (sub::readfile('nodes.txt')) {	push(@node,[split(/\t/)]);	}
foreach (sub::readfile('names.txt')) {	push(@name,[split(/\t/)]);	}

for $n (0..$#name) {
	if (($name[$n][0]!=$name[$n-1][0])||($name[$n][3] =~ /scientific name/)) {$off='$name[$n][1]=~s/^(\w)\w+ (\w+).*/$1\_$2/'; $id[abs($name[$n][0])]=$name[$n][1]; }
}
undef @name;

for $n (0..$#node) {
	$papa[abs($node[$n][0])]=abs($node[$n][1]);
}

@temp=sub::readfile('premium 10-9/single.txt');
$taa=shift(@temp);
print DONE $taa."\n";
@aa=split(/\t/,$taa);
shift(@aa);
foreach (@temp) {
	@tempi=split(/\t/);
	$name=shift(@tempi);
	$comp{$name}=[@tempi];
}

print "\rfile loaded loaded....\n";



$tree="((((224324,608538)436114),(((438753,176299)272947),(407148,387092),(290398(511145,99287),(58051,357804),(208964,259536)272843)267608),(525909((290399(196627(561304,757418))266940)206672)521003(469383,266117)),(441768(272635,565575)),((224326,243276)355276),((((224308,420246,221109)158879),(321967,299768)),(272562((246194,580331)309798))),((226186,518766)517418),(324602,243164),((497964,481448),(115713,765952)313628),(469381,525903),((243230,649638),((504728,526227),(498848,300852)))309799,445932(381764,521045,403833,484019(243274,390874)),(190304,523794,519441,526218)379066(330214,289376),(103690,1148),(521674,243090),(653733,447454,525904)),((439481,224325(64091,362976,348780),((((188937,192952)259564,547558)349307)456442),(419665,243232)190192(420247,187420),((272844,186497,70601)593117),(273075,273116)),(((272557,453591,399550)415426)666510(399549,273057),(178306,368408)),(414004,436308)374847,228908))";
$timber=$tree;
$timber=~ s/\(/</msgi;
$timber=~ s/\)/>/msgi;
@tag=dewstring($timber);
for $n (0..$#tag) {
	$timber=~ s/(\W)$tag[$n](\W)/$1N0\_$n$2/g;
}
$t=0;
while (($timber=~ /[<>]/)&&($t<10)) {
	$t++;
	$qwerty=$timber;  #most bizzare error otherwise to do with pos($tree)!
	@temp=($qwerty=~ m/<([N\_\d\,]*)>/g);
	$tier[$t]= [@temp];
	
	for $n (0..$#{$tier[$t]}) {
		$timber=~ s/<$tier[$t][$n]>/,N$t\_$n,/g;
		$tier[$t][$n]=~ s/,,/,/g;
		$tier[$t][$n]=~ s/<,/</g;
		$tier[$t][$n]=~ s/,>/>/g;
	}
	$timber=~ s/,,/,/g;
	$timber=~ s/<,/</g;
	$timber=~ s/,>/>/g;
}

@node=();
for $tm (1..$#tier) {
	for $sm (0..$#{$tier[$tm]}) {
		$node[$tm][$sm]{abb}=$tier[$tm][$sm];
		#print "N$tm\_$sm (".nodenamer("N$tm\_$sm").")=".join(", ",map(("$_ (".nodenamer($node[tier($_)][st($_)]{abb}).")"),denodestring($node[$tm][$sm]{abb})))."\n";
		print "N$tm\_$sm = $node[$tm][$sm]{abb}\n";
	}
}





################average
$p=1;

for $s (0..$#tag) {
	$node[0][$s]{average}=$comp{$tag[$s]};
	$node[0][$s]{name}=$id[$tag[$s]];
	print DONE "$tag[$s]\t$node[0][$s]{name}\t".join("\t",@{$node[0][$s]{average}})."\n";
}

for $tm (1..$#node) {
	for $sm (0..$#{$node[$tm]}) {
		@temp=denodestring($node[$tm][$sm]{abb});
		if ($#temp>=0) {
			for $x (0..$#aa) {
				if ($p==0) {
					for $n (@temp) {$node[$tm][$sm]{average}[$x]*=($node[tier($n)][st($n)]{average}[$x]);}
					$node[$tm][$sm]{average}[$x]=($node[$tm][$sm]{average}[$x]/($#temp+1))**($#temp+1);
				} else {
					for $n (@temp) {$node[$tm][$sm]{average}[$x]+=($node[tier($n)][st($n)]{average}[$x])**$p;}
					$node[$tm][$sm]{average}[$x]=($node[$tm][$sm]{average}[$x]/($#temp+1))**(1/$p);
				}
			}
			$node[$tm][$sm]{id}=nodenamer($node[$tm][$sm]{abb});
			$node[$tm][$sm]{name}=$id[$node[$tm][$sm]{id}];
			print DONE "$node[$tm][$sm]{id}\t$node[$tm][$sm]{name}\t".join("\t",@{$node[$tm][$sm]{average}})."\n";
		} else {print "nothing in \$node[$tm][$sm]{abb}=$node[$tm][$sm]{abb}\n";}
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

sub destring {
	my $a=$_[0];
	$a=~ s/[NT]\d+_\d+//g;
	my @temp=($a=~ m/(\d+)/g);
	my @tempus=();
	for $n (@temp) {if ($n>0) {push(@tempus,$n);}}
	return (sort(@tempus));
}

sub dewstring {
	my $a=$_[0];
	$a=~ s/[NT]\d+_\d+//g;
	my @temp=($a=~ m/(\w+)/g);
	my @tempus=();
	for $n (@temp) {if (length($n)>0) {push(@tempus,$n);}}
	return (sort(@tempus));
}


sub denodestring {
	#changed!
	my $a=$_[0];
	my @temp=($a=~ m/([NT]\d+\_\d+)/g);
	$a=~ s/([NT]\d+\_\d+)//g;
	my @tempus=();
	for $n (@temp) {if (length($n)>0) {push(@tempus,$n);}}
	return (sort(@tempus));
}

sub n_index {

}

sub nodenamer {
	my $string=$_[0];
	my @aim=denodestring($string);
	foreach (@aim) {if (tier($_)>0) {push(@aim,denodestring($node[tier($_)][st($_)]{abb}));}}
	@aim=grep(/N0\_\d+/,@aim);
	my @count=();
	foreach $xi (@aim) {
		$x=abs($tag[st($xi)]);
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
	
	@temp=map($tag[st($aim[$_])],0..$#aim);
	while ($#temp>0) {
		@temp=squared(@temp);
	}

	return $temp[0];
}

sub squared {
	@contestant=@_;
	my %counter=();
	for $xi (0..$#contestant) {
		$x=$contestant[$xi];
		for $yi (0..($xi-1)) {
			$y=$contestant[$yi];
			for $u (0..$#{$lin[$x]}) {
				for $v (0..$#{$lin[$y]}) {
					if (($lin[$x][$u]==$lin[$y][$v])&&(length($lin[$x][$u])>0)) {$counter{$lin[$x][$u]}++; goto HERE;}
				}
			}
			print "crap! $x (aka ".$id[$x].") is unrecognised!\n";
		HERE:
		}
	}
	return (keys %counter);
}

