#!/usr/bin/perl


print "hello World\n";
open(IN,'IN.fasta') or die "Can't open file: $!";
open(OUT,'>out_trimmed.fa') 	or die "Can't open file: $!";
@lines=<IN>;

foreach $item (@lines)
{

	#>silva|AF545473|1|562| Euphausia brevis
	if ($item =~ m/\>/) {
	$item =~ m/\>silva.*\| (\w*) (\w*)/;
	$item ="\>$1\_$2";
		$item =~ s/ //g;
		chomp($item);
		print OUT "\n$item\n";
	} else {chomp($item);	print OUT "$item";}

	
}	
end;
