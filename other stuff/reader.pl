
open(IN,'test_set.txt')
	or die "Can't open file: $!";
open(OUT,'>test_out.txt')
	or die "Can't open file: $!";


##########################################
#print OUT "$j:\t$pmid[$j]\t$title[$j]\t$journal[$j]\t$abs[$j]\t$date[$j]\t$doi[$j]\n";
	

my @doc=<IN>;
my $size=@doc;

my $index="hello";
my @pmid=();
my @journal=();
my @title=();
my @abs=();
my @date=();
my @doi=();
print "$size sized\n";
for(my $i=0; $i <$size; $i++)
	{
	chomp($doc[$i]);
	$_=$doc[$i];
	s/ /_/g;#s/://g;
($index,$pmid[$i],$title[$i],$journal[$j],$abs[$j],$date[$j],$doi[$j])= /(\d+)\:\t(\d+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)/;
print "$index\t";
	}

#########################################



close IN;
close OUT;
print "\n\x01\a";
<>;
end;