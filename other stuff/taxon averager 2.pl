#!/usr/bin/perl
use sub;
sub::clear;
print "Program starting...\n";
my $timer=time();

#######################
$file='>average.txt'; open(DONE,$file) or die "Can't make file ($file): $!";
#######################


foreach (sub::readfile('nodes.txt')) {	push(@node,[split(/\t/)]);	}
foreach (sub::readfile('names.txt')) {	push(@name,[split(/\t/)]);	}

for $n (0..$#name) {
	if (($name[$n][0]!=$name[$n-1][0])||($name[$n][3] =~ /scientific name/)) {$name[$n][1]=~s/^(\w)\w+ (\w+).*/$1\_$2/; $id[abs($name[$n][0])]=$name[$n][1]; }
}
undef @name;

for $n (0..$#node) {
	$papa[abs($node[$n][0])]=abs($node[$n][1]);
}

@temp=sub::readfile('test.txt');
$taa=shift(@temp);
@aa=split(/\t/,$taa);
shift(@aa);
foreach (@temp) {@tempi=split(/\t/); $name=shift(@tempi); $comp{$name}=[@tempi];}

print "\rfile loaded loaded....\n";



#$tree="((((A.aeolicus,H.thermophilus)S.sp),(((A.caulinodans,A.tumefaciens)R.prowazekii),(C.jejuni,N.sp),(C.salexigens(E.coli,S.enterica),(M.sp,P.ingrahamii),(P.aeruginosa,P.arcticus)P.multocida)R.solanacearum)Actinobacteria (class),(A.laidlawii(M.pulmonis,U.urealyticum)),((B.burgdorferi,T.pallidum)L.borgpetersenii),((((B.subtilis,G.thermodenitrificans,O.iheyensis)S.aureus),(L.casei,S.thermophilus)),(C.acetobutylicum((C.hydrogenoformans,T.italicus)C.proteolyticus))),((B.thetaiotaomicron,R.marinus)C.thalassium),(C.aurantiacus,D.ethenogenes),((C.flavus,M.infernorum),(C.pneumoniae,P.acanthamoebae)L.araneosa),(D.peptidovorans,T.acidaminovorans),((D.radiodurans,T.radiovictrix),((M.ruber,M.silvanus),(T.aquaticus,T.thermophilus)))D.thermophilum,E.minutum(F.nodosum,K.olearia,P.mobilis,T.africanus(T.maritima,T.petrophila)),(F.nucleatum,L.buccalis,S.moniliformis,S.termitidis)G.aurantiaca(C.Nitrospira,T.yellowstonii),(N.sp,S.sp),(P.limnophilus,R.baltica),(b.S5,c.division,T.terrenum)),((A.boonei,A.fulgidus(H.sp,H.walsbyi,N.pharaonis),((((M.acetivorans,M.mazei)M.burtonii,M.mahii)M.thermophila)C.Methanoregula),(M.aeolicus,M.jannaschii)M.kandleri(M.smithii,M.thermautotrophicus),((P.abyssi,P.furiosus,P.horikoshii)T.gammatolerans),(T.acidophilum,T.volcanium)),(((A.pernix,I.hospitalis/I,S.marinus)H.butylicus)A.saccharovorans(M.sedula,S.solfataricus),(P.aerophilum,T.pendens)),(C.symbiosum,N.maritimus)C.Korarchaeum,N.equitans));";
$tree="(((272557,453591,399550)415426)666510(399549,273057)";
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
for $t (0..$#tier) {
	for $s (0..$#{$tier[$t]}) {
		$node[$t][$s]{abb}=$tier[$t][$s];
		print "\$node[$t][$s]{abb} =".$node[$t][$s]{abb}."\n";
	}
}





################average
$p=1;

for $s (0..$#tag) {$node[0][$s]{average}=$comp{$tag[$s]}; $node[0][$s]{name}=$id[$tag[$s]]; print "Vector of N0\_$s ($node[0][$s]{name}): ".join("\t",@{$node[0][$s]{average}})."\n";}  # adding a reference? lol

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
			$node[$tm][$sm]{name}=nodenamer($node[$tm][$sm]{abb});
			print "Vector of N$tm\_$sm ($node[$tm][$sm]{name}): ".join("\t",@{$node[$tm][$sm]{average}})."\n";
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
	my %counter=();
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
	
	
	for $xii (0..$#aim) {
		$xi=$aim[$xii];
		$x=$tag[st($xi)];
		for $yii (0..($xii-1)) {
			$yi=$aim[$yii];
			$y=$tag[st($yi)];
			for $u (0..$#{$lin[$x]}) {
				for $v (0..$#{$lin[$y]}) {
					if (($lin[$x][$u]==$lin[$y][$v])&&(length($lin[$x][$u])>0)) {$counter{$lin[$x][$u]}++; goto HERE;}
				}
			}
			print "crap! $x (aka ".$id[$x].") is unrecognised!\n";
		HERE:
		}
	}
	$max=0;
	$mwho=0;
	for $n (keys %counter) {
		if ($counter{$n}>$max) {$max=$count{$n}; $mwho=$n;}
	}
	return $id[$mwho];
}