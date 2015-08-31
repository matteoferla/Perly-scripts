open(IN,'table.txt') 	or die "Bummer, can't open file: $!";
open(OUT,'>table_out.txt') 	or die "Can't open file: $!";
print "Hello World\n";

@line=<IN>;
chomp(@line);
if ($#line<2) {
	@temp=split(/\r/,$line[0]);
	@tempo=split(/\r/,$line[1]); #pretty sure cannot be.
	@line=@temp;
	push(@line,@tempo);
}

@header=split(/\t/,$line[0]);
print join("...",@header)." times ".$#line."\n";
for $n (1..$#line) {
	@tab=split(/\t/,$line[$n]);
	for $m (1..$#tab) {
				print OUT "$tab[0]$header[$m]\t$tab[$m]\n";
	}}