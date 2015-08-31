#!/usr/bin/perl
use sub;
sub::clear;
print "Program starting...\n";

foreach (sub::readfile('nodes.txt')) {	push(@node,[split(/\t/)]);	}
foreach (sub::readfile('names.txt')) {	push(@name,[split(/\t/)]);	}

#######################
#$file='>done.txt'; open(DONE,$file) or die "Can't make file ($file): $!";
#######################


my @aim=(224324,439481,438753,525909,224325,441768,272557,666510,290399);


@temp=();
@temp=<NODE>;
chomp(@temp);
foreach (@temp) {	push(@node,[split(/\t/)]);	}
close NODE;

@temp=();
@temp=<NAME>;
chomp(@temp);
foreach (@temp) {	push(@name,[split(/\t/)]);	}
close NAME;



print "Data loaded in".sub::taken."\n";
#######################

for $n (0..$#node) {
	$papa[abs($node[$n][0])]=abs($node[$n][1]);
}
undef @node;

for $n (0..$#name) {
	if (($name[$n][0]!=$name[$n-1][0])||($name[$n][3] =~ /scientific name/)) {$id[abs($name[$n][0])]=$name[$n][1];}
}
undef @name;

$was=$now;
$now=time()-$was-$timer;
printf("Data prepared in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));

###############FIND LCD###########################
foreach $x (@aim) {
	$x=abs($x);
	$printer[$x]=$id[$x];
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
	print DONE join("\:",map($id[$_],@{$lin[$x]}))."\n";
}

print DONE "\n"x3;
print DONE ("\t".join("\t",map($id[$_],@aim)));
for $xi (1..$#aim) {
	$x=$aim[$xi];
	print DONE ("\n".$id[$x]);
	for $yi (0..($xi-1)) {
		$y=$aim[$yi];
		for $u (0..$#{$lin[$x]}) {
			for $v (0..$#{$lin[$y]}) {
				if (($lin[$x][$u]==$lin[$y][$v])&&(length($lin[$x][$u])>0)) {$ur[$x][$y]=$lin[$x][$u]; for $j (@intnode) {if ($j==$lin[$x][$u]) {goto HERE;}} push(@intnode,$lin[$x][$u]); goto HERE;}
			}
		}
		$ur[$x][$y]=1;
		print "issue with $id[$x] and $id[$y]\n";
	HERE:
	print DONE ("\t$id[$ur[$x][$y]]($ur[$x][$y])");
	}
}

$was=$now+$was;
$now=time()-$was-$timer;
printf("LCD found in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));

##############################################Father and Son####################################################

print "\n\n";
###Hedgertimmer##
for $m (@aim) {
	@temp=();
	for $l (0..$#{$lin[$m]}) {
		for $n (@intnode) {
			if ($lin[$m][$l]==$n) {push(@temp,$n); goto LINEUS;}
		}
	LINEUS:
	}
	$heritage[$m]=[@temp];
	print DONE $id[$m]."\:".join("\>",map($id[$_],@temp))."\n";
}




@son=();
for $m (@aim) {
	$subnode=$m;
	for $currentnode (@{$heritage[$m]}) {
		for $o (@{$son[$currentnode]}) {if ($o==$subnode) {goto HAPPYPLACE;}}
		push(@{$son[$currentnode]}, $subnode);
		HAPPYPLACE:
		$subnode=$currentnode;
	}
}


###NEWICK TREE##############

$tree="\:131567\:";
$stree="\:$id[131567]\:";
$next[0]=131567;
$done=$#aim;
while ($done>0) {
	$father=$next[$fatherindex];
	#delete $next[$fatherindex];
	if ($father<1) {goto LEAF;}
	for $n (@aim) {if ($n==$father) {$done--; goto LEAF;}}
	if ($#{$son[$father]}<0) {$done--; print "Empty values for $id[$father]!\n"; goto LEAF;}
	$temp="\:(\:".join("\:",@{$son[$father]})."\:)\:";
	$stemp="\:(\:".join("\:",map($id[$_],@{$son[$father]}))."\:)\:";
	$tree=~ s/\:$father\:/$temp/;
	$stree=~ s/\:$id[$father]\:/$stemp/;
	push(@next,@{$son[$father]});
LEAF:
	$fatherindex++;
	if ($fatherindex>$#next) {print "Finished Array\n"; $done=0;}
}
$t=$tree;

$t=~ s/\d+/A/g;
$n=($t=~ tr/A//);
print $n." leaves in tree out of ".($#aim+1)."\n";
print $tree."\n\n";
$tree=~ s/\:\(/\(/g;
$tree=~ s/\(\:/\(/g;
$tree=~ s/\:\)/\)/g;
$tree=~ s/\)\:/\)/g;
$tree=~ s/\:/\,/g;
$tree=~ s/\)\(/\)\,\(/g;

$stree=~ s/\:\(/\(/g;
$stree=~ s/\(:/\(/g;
$stree=~ s/\:\)/\)/g;
$stree=~ s/\)\:/\)/g;
$stree=~ s/\:/\,/g;
$stree=~ s/\)\(/\)\,\(/g;

print $tree."\n\n";
#print $stree."\n";
print DONE $tree."\n\n";
print DONE $stree."\n";








$was=$now+$was;
$now=time()-$was-$timer;
printf("LCD found in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));


####################################################################################################################################
#####################################################################################################################################################################################################################

