#!/usr/bin/perl


print "Greatings to all Earlings\n";
open(COG,'whog') or die "Can't open file: $!";
@lines=<COG>;
$species="Eco";




$size=@lines+0;

for ($n=1;$n<=$size; $n++)
{
	$item=$lines[$n];
	chomp($item);

	if ($item =~ m/\[/)
	{
		#[H] COG0001 Glutamate-1-semialdehyde aminotransferase
		$maxcog++;
		$item =~ m/\[(\w)*?\] (\w*?) (.*)/;
		$cog[0][$maxcog] =$1;
		$cog[1][$maxcog] =$2;
		$cog[2][$maxcog] =$3;
	}
	
	if ($item =~ m/ $species\:/) { $item =~ m/ $species\: (.*)/; $t =$1; @temp=split(/ /,$t);
		for $z ( 0 .. $#temp ) {
			$cog[3+$z][$maxcog]=$temp[$z];
			$cog[3+$z][$maxcog]=~s/\W//msg; 
			$cog[3+$z][$maxcog]=~s/\s//msg; 
			$cog[3+$z][$maxcog]=~s/_.*//msg;
			if (length($cog[3+$z][$maxcog])==0) {delete $cog[3+$z][$maxcog];}
				}		

	}

}




########

open(TABLE,'table.txt') 	or die "Bummer, can't open file: $!";
open(TABLEOUT,'>table_out.txt') 	or die "Can't open file: $!";
#for ($x=0; $x<=$maxcog; $x++) {for ($y=0; $y<=15; $y++) {print TABLEOUT "$cog[$y][$x]\t";} print TABLEOUT "\n";}



@queries=<TABLE>;
$size=@lines+0;
for ($n=1;$n<=$size; $n++)
{
	chomp($queries[$n]);
	@query=split(/\t/,$queries[$n]);
	$query[0]=~s/\W//msg;	$query[1]=~s/\W//msg;	$query[2]=~s/\W//msg;#	if (length($query[0])==0) {goto TRANSPROBLEM;}
	if (length($query[1])==0) {$query[1]="BLANK";}
	if (length($query[2])==0) {$query[2]="BLANK";}
	
	
		$ok=0; $i=0; $j=0;$k=0; $gotcog[0]="Not Found";$gotcog[1]="Not Found";$gotcog[2]="Not Found";$gotcog[3]="Not Found";
		
				for ($i=0;$i<$maxcog;$i++) {
					for ($q=3;$q<10;$q++) {
					if ($query[0] eq $cog[$q][$i]) {$gotcog[0]=$query[0];$gotcog[1]=$cog[0][$i];$gotcog[2]=$cog[1][$i];$gotcog[3]=$cog[2][$i];$ok=1; goto ESCAPING;} 
					elsif ($query[1] eq $cog[$q][$j]) {$gotcog[0]=$query[1];$gotcog[1]=$cog[0][$j];$gotcog[2]=$cog[1][$j];$gotcog[3]=$cog[2][$j];$ok=2;  goto ESCAPING;}
				elsif ($query[2] eq $cog[$q][$k]) {$gotcog[0]=$query[2];$gotcog[1]=$cog[0][$k];$gotcog[2]=$cog[1][$k];$gotcog[3]=$cog[2][$k];$ok=3;  goto ESCAPING;}
				}  #compare with each of the cogs in the entry
				}  #compare with each cog entry
ESCAPING:	
	print TABLEOUT "$query[0]\t$gotcog[2]\t$gotcog[1]\t$gotcog[3]\t$gotcog[0]\t$ok\n";
	print "$n, ";
TRANSPROBLEM:	
}#each ASKA entry			

close TABLEOUT;

	
end;
