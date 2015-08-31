#!/usr/bin/perl


print OUT "hello World\n\a";
open(SESAME,'fastaaa.txt') or die "Can't open file: $!";
open(FILE,'>freqphobe2.txt') 	or die "Can't open file: $!";
@fastalist=<SESAME>;

foreach $item (@fastalist)
{

@fastaline = split(/\t/, $item);
$seq=$fastaline[3]; chomp($seq);
$seq=~ s/\W//g;
@aa = split(//, $seq);
$size=@aa;
@hp=();
@xp=();



for ($mill = 0; $mill <= $size-1; $mill++)
{

 if (ord($aa[$mill]) ==65) {$hp[$mill]=1.8;}
 if (ord($aa[$mill]) ==82) {$hp[$mill]=-4.5;}
 if (ord($aa[$mill]) ==78) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==68) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==67) {$hp[$mill]=2.5;}
 if (ord($aa[$mill]) ==81) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==69) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==71) {$hp[$mill]=-0.4;}
 if (ord($aa[$mill]) ==72) {$hp[$mill]=-3.2;}
 if (ord($aa[$mill]) ==73) {$hp[$mill]=4.5;}
 if (ord($aa[$mill]) ==76) {$hp[$mill]=3.8;}
 if (ord($aa[$mill]) ==75) {$hp[$mill]=-3.9;}
 if (ord($aa[$mill]) ==77) {$hp[$mill]=1.9;}
 if (ord($aa[$mill]) ==70) {$hp[$mill]=2.8;}
 if (ord($aa[$mill]) ==80) {$hp[$mill]=-1.6;}
 if (ord($aa[$mill]) ==83) {$hp[$mill]=-0.8;}
 if (ord($aa[$mill]) ==84) {$hp[$mill]=-0.7;}
 if (ord($aa[$mill]) ==87) {$hp[$mill]=-0.9;}
 if (ord($aa[$mill]) ==89) {$hp[$mill]=-1.3;}
 if (ord($aa[$mill]) ==86) {$hp[$mill]=4.2;}
}


if ($size<13) {
	$xpt=0;
	for ($mill = 0; $mill <= $size; $mill++) { $xpt +=$hp[$mill];}
	$xpt = int(10*($xpt/$size))+50;
	@xp=map {$xpt} ( 0 .. $size );
} else {
$xpt=0;
for ($mill = 0; $mill <= 5; $mill++) { $xpt +=$hp[$mill];}
$xpt = int(10*($xpt/6))+50;
for ($mill = 0; $mill <= 5; $mill++) { $xp[$mill]=$xpt;}
for ($mill = 6; $mill <= ($size-6); $mill++)
	{
	$xp[$mill]=0;
	for ($deca = ($mill-5); $deca <= ($mill+4); $deca++) { $xp[$mill] +=$hp[$deca];}
	$xp[$mill] = int($xp[$mill])+50;
	}

$xpt=0;
for ($mill = ($size-5); $mill <= $size; $mill++) { $xpt +=$hp[$mill];}
$xpt = int(10*($xpt/5))+50;
for ($mill = ($size-5); $mill <= $size; $mill++) { $xp[$mill]=$xpt;}


}


for ($mill = 0; $mill <= $size-1; $mill++)
{

for ($abc=65;$abc<=90;$abc++) { 
		if (ord($aa[$mill]) == $abc) {$x=$abc-65;$y=$xp[$mill]; $counts[$x][$y]++;}}

}

}
#each protein







for ($col=0;$col<=25;$col++) {print FILE (chr($col+65) . "\t");}
for ($row=0;$row<=100;$row++) {$calc=($row-50)/10;
	print FILE "\n$row\t";
	for ($col=0;$col<=25;$col++) {print FILE"$counts[$col][$row]\t";}}







close FILE;
close SESAME;
print "all done\n\a";
end;
