#!/usr/bin/perl


print "this code is to tweak the results from pubmed.pl\n";
open(FOLKS,'authors.txt') or die "Can't open file: $!";
open(CHUMS,'authors_details.txt') or die "Can't make file: $!";
@line=<FOLKS>;
close FOLKS;
chomp(@line);
@temp=split (/\t/,$line[0]);
@header=@temp[1..$#temp]; #push x 1...change if added more.
foreach (@line) {
	@score=split /\t/;
	chomp(@score);
	$man=shift(@score);
	for $x (0..$#header) {
		if(abs($score[$x])>0) {$friend{$header[$x]}{$man}=$score[$x];}
	}
}

@line=<CHUMS>;
close CHUMS;
chomp(@line);
@temp=split (/\t/,$line[0]);
#name	# papers	start date	end date	# first authored papers	first start	first end	# last authored papers	last start	last end
#$x\t$egocentre{$x}\t$start{$x}\t$end{$x}\t$aleph{$x}\t$alephstart{$x}\t$alephend{$x}\t$omega{$x}\t$omegastart{$x}\t$omegaend{$x}\n
foreach (@line) {
	@score=split /\t/;
	chomp(@score);
	$man=shift(@score);
	$egocentre{$man}=shift(@score);
	$start{$man}=shift(@score);
	$end{$man}=shift(@score);
	$aleph{$man}=shift(@score);
	$alephstart{$man}=shift(@score);
	$alephend{$man}=shift(@score);
	$omega{$man}=shift(@score);
	$omegastart{$man}=shift(@score);
	$omegaend{$man}=shift(@score);
}


for $x (keys(%egocentre)) {
	$egodist[$egocentre{$x}]++;
}

for $z (1..20) {
	for $x (keys(%egocentre)) {
		if ($egocentre{$x}>$z) {
			push(@cleanlist, $x);
		}
	}
	$file=('>authors_fix'.$z.'.txt');
	open(CHAPS,$file) or die "Can't make file: $!";
	
	print CHAPS "\t\# Papers";
	foreach $y (@cleanlist) {
		print CHAPS "\t\t$y";
	}
	
	foreach $x (@cleanlist) {
		print CHAPS "\n$x\t".$egocentre{$x};
		foreach $y (@cleanlist) {
			print CHAPS "\t".$friend{$x}{$y};
		}
	}
	close CHAPS;
	@cleanlist=();
}

open(INFO,'>authors_info.txt') or die "Can't make file: $!";
print INFO ("number of authors before:\t".$#line."\nnumber of authors after:\t".$#cleanlist);
print INFO ("\nDISTRIBUTION\n");
for $x (0..$#egodist) {
	print INFO ("$x\t$egodist[$x]\n");
}

%shrink=%friend;
$x=0;
foreach $man (keys %shrink) {
	$tempcount=1;
	@todo=keys %{$shrink{$man}};
	delete $shrink{$man};
	$link=$man;
	@gone=();
	$gone[0]=$man;
	foreach $hombre (@todo) {
		for $desaparesido (@gone) {
			delete $shrink{$desaparesido}{$hombre};
		}
		@temp=keys %{$shrink{$hombre}};
		delete $shrink{$hombre};
		push(@todo,@temp);
		$link=$hombre;
		push(@gone,$hombre); #Desaparesido!
		$tempcount++;
	}
	print "this group is $tempcount people big\n";
	$group[$x]=join("\:",@gone);
	$gsize[$x]=$tempcount;
	$x++;
}

print "There are $#gsize groups\!\n";
open (GROUPS,'>groups.txt') or die "Can't make file: $!";
for $x (0..$#group) {
print GROUPS "$x\t$gsize[$x]\t$group[$x]\n";
}





