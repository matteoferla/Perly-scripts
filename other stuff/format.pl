
print OUT "hello World\n";
open(SESAME,'seq_in.txt')
	or die "Can't open file: $!";
open(FILE,'>seq_out.txt')
	or die "Can't open file: $!";

my $i=0;
my $j=0;
print FILE "00\t";

my @seq=<SESAME>;

foreach (@seq) {



my @aa = split(//, $_);

print "size of array: " . @aa . ".\n";

 foreach my $val (@aa)
{
   	print FILE "$val";
	$i++;
	if ($i == 5) {	print FILE "\t"; $i=0}
	$j++;
	if (($j % 20) == 0) {	print FILE "\n $j\t"; }


}

} 



close FILE;
print "Done";
<>;
end;