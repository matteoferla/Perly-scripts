
open(IN,'test_set.txt')
	or die "Can't open file: $!";
open(OUT,'>out.txt')
	or die "Can't open file: $!";


##########################################
print "formating as... newline author tab title tab journal tab PMID\n";


my @doc=<IN>;
my $size=@doc;
for(my $i=0; $i <$size; $i++)
	{
	chomp($doc[$i]);
  	if ($doc[$i] =~ m/PMID/)
		{
		$doc[$i]="\t$doc[$i]";
		$doc[$i-1]="\t$doc[$i-1]";
		}
	if ($doc[$i] =~ m/^\d+\:/)
		{
		$doc[$i]="\n$doc[$i]";
		}
	if ($doc[$i] =~ m/^\s/)
		{
		$doc[$i]="\t$doc[$i]";
		}
	

	}

#########################################

print OUT @doc;
close IN;
close OUT;
print "Done";
<>;
end;