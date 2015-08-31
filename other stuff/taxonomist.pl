#!/usr/bin/perl
$here=0; #change to 3 if zorg output
print "the full organism name in target.txt is in field number... $here\n";
my $file="";
#bound variables
my $x=0;
my $timer=time();

#######################
$file='target.txt'; open(AIM,$file) or die "Can't open file ($file): $!";
$file='nodes.txt'; open(NODE,$file) or die "Can't open file ($file): $!";
$file='names.txt'; open(NAME,$file) or die "Can't open file ($file): $!";
$file='info.txt'; open(INFO,$file) or die "Can't open file ($file): $!";
$file='tobe.txt'; open(TOBE,$file) or die "Can't open file ($file): $!";
$file='now.txt'; open(NOW,$file) or die "Can't open file ($file): $!";
$file='>done.txt'; open(DONE,$file) or die "Can't make file ($file): $!";
#######################


my @temp=();
@temp=<AIM>;
chomp(@temp);
shift(@temp);
foreach (@temp) {	push(@aim,[split(/\t/)]);	}
close AIM;


@temp=();
@temp=<INFO>;
chomp(@temp);
shift(@temp);
shift(@temp);
foreach (@temp) {	push(@info,[split(/\t/)]);	}
close INFO;

@temp=();
@temp=<TOBE>;
chomp(@temp);
shift(@temp);
shift(@temp);
foreach (@temp) {	push(@tobe,[split(/\t/)]);	}
close TOBE;

@temp=();
@temp=<NOW>;
chomp(@temp);
shift(@temp);
shift(@temp);
foreach (@temp) {	push(@fini,[split(/\t/)]);	}
close NOW;

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



$now=time()-$timer;
printf("Data loaded in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
#######################

$mi=0;


for $x (0..$#info) {
	$lite[$x]=$info[$x][3];
	$lite[$x]=~ s/ strain//msi;
	$lite[$x]=~ s/ str.//msi;
	$lite[$x]=~ s/ subspecies//msi;
	$lite[$x]=~ s/ subsp.//msi;
	#$lite[$x] =~ s/[^A-Z 0-9]+//g;
}


for $x (0..$#aim) {
	$aim[$x][10]="---";
	$clean=$aim[$x][$here];
	$clean=~ s/ chromosome.*$//msi;
	$clean=~ s/ strain//msi;
	$clean=~ s/ str.//msi;
	$clean=~ s/ subspecies//msi;
	$clean=~ s/ subsp.//msi;
	#$clean =~ s/[^A-Z 0-9]+//g;
	
	for $y (0..$#info) {
		if ($lite[$y]=~ m/$clean/) {$mi++; push(@{$aim[$x]},@{$info[$y]});goto SKIPPER;}
	}
	for $y (0..$#info) {
		if ($clean=~ m/$lite[$y]/) {$mi++; push(@{$aim[$x]},@{$info[$y]});goto SKIPPER;}   ###just in case I have crap written in my name
	}
	
	
	if ($clean=~ m/(\w* \w*) .*/i) {
		$tempus=$1;
		for $y (0..$#lite) {
			if ($lite[$y]=~ m/$tempus/) {
				#print "$aim[$x][$here] was not entirely matched with information data, but was partially matched $info[$y][3]\n";
				$mi++; push(@{$aim[$x]},@{$info[$y]});goto SKIPPER;}
		}
	}
	
	
	print "$aim[$x][$here] was not matched with information data, what is it's taxon id? (0 to ignore blank)\n";
	$aim[$x][13]=<>;
	chomp($aim[$x][13]);
	$aim[$x][13]=~ s/\D//;
	$aim[$x][13]=abs($aim[$x][13]);
	
	
SKIPPER:
}

$was=$now+$timer;
$now=time()-$was;
printf("Done information data\: $mi matched out of $#aim in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));

#######################
$mf=0; $mt=0;

for $y (0..$#fini) {
	$fini[$y][2]=~ s/\D//;
	$fini[$y][2]=abs($fini[$y][2]);
}
for $y (0..$#tobe) {
	$tobe[$y][2]=~ s/\D//;
	$tobe[$y][2]=abs($tobe[$y][2]);
}

for $x (0..$#aim) {
	$aim[$x][34]="---";
	$aim[$x][13]=~ s/\D//;
	$aim[$x][13]=abs($aim[$x][13]);
	if ($aim[$x][13]<2) {goto JUMPER;}
	for $y (0..$#fini) {
			if ($aim[$x][13]==$fini[$y][2]) {$mf++; push(@{$aim[$x]},@{$fini[$y]});goto JUMPER;}
	}
	for $y (0..$#tobe) {
		if ($aim[$x][13]==$tobe[$y][2]) {$mt++; push(@{$aim[$x]},@{$tobe[$y]});goto JUMPER;}
	}
	
JUMPER:
}

$was=$now+$was;
$now=time()-$was; $mft=$mf+$mt;
printf("Done genome data\: $mft (complete\: $mf assemply\: $mt) matched out of $mi in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));

#######################
$mu=0; $mv=0;

for $y (0..$#name) {
	$name[$y][0]=~ s/\D//;
	$name[$y][0]=abs($name[$y][0]);
}


for $y (0..$#node) {
	$node[$y][0]=~ s/\D//;
	$node[$y][0]=abs($node[$y][0]);
}

for $x (0..$#aim) {
	$aim[$x][51]="---";
	if ($aim[$x][13]<2) {goto LEAPER;}
	for $y (0..$#name) {
		if ($aim[$x][13]==$name[$y][0]) {$mu++; push(@{$aim[$x]},@{$name[$y]});goto HOPPER;}
	}
HOPPER:
	$aim[$x][56]="---";
	for $y (0..$#node) {
		if ($aim[$x][13]==$node[$y][0]) {$mv++; push(@{$aim[$x]},@{$node[$y]});goto LEAPER;}
	}
LEAPER:
}

$was=$now+$was;
$now=time()-$was;
printf("Done taxon data\: $mu and $mv matched out of $mi in %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));

#######################


for $x (0..$#aim) {
	print DONE join("\t",@{$aim[$x]})."\n";
}
close DONE;


