
open(IN,'test_set.txt')
	or die "Can't open file: $!";
open(OUT,'>test_out.txt')
	or die "Can't open file: $!";


##########################################


my @doc=<IN>;
my $size=@doc;

my $index="hello";
my @pmid=();
my @journal=();
my @title=();
my @abs=();
my @date=();
my @doi=();
my @c_nanosensor=();
my @c_biosensor=();
my @c_sensor=();
my @c_clinical=();
my @c_diabetes=();

print "$size sized\n";
for(my $i=0; $i <$size; $i++)
	{
	chomp($doc[$i]);
	$_=$doc[$i];
	s/ /_/g;#s/://g;
($index,$pmid[$i],$title[$i],$journal[$i],$abs[$i],$date[$i],$doi[$i])= /(\d+)\:\t(\d+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)/;
print "$index\t";
	}

#########################################

for(my $j=0; $j <$index; $j++)
	{
	if ($abs[$j] =~ m/_sensor/i){$c_sensor[$j]="1"}else{$c_sensor[$j]="0"}
	if ($abs[$j] =~ m/biosensor/i){$c_biosensor[$j]="1"}else{$c_biosensor[$j]="0"}
	if ($abs[$j] =~ m/nanosensor/i){$c_nanosensor[$j]="1"}else{$c_nanosensor[$j]="0"}
	if ($abs[$j] =~ m/diabetes/i){$c_diabetes[$j]="1"}else{$c_diabetes[$j]="0"}
	if ($abs[$j] =~ m/clinical/i){$c_clinical[$j]="1"}else{$c_clinical[$j]="0"}
	print OUT "$j:\t$pmid[$j]\t$title[$j]\t$journal[$j]\t$abs[$j]\t$date[$j]\t$doi[$j]\t$c_sensor[$j]\t$c_biosensor[$j]\t$c_nanosensor[$j]\t$c_diabetes[$j]\t$c_clinical[$j]\t\n";
	}
$j=0;
	

close IN;
close OUT;
print "\n$c_nanosensor[0]\n\x01\a";
<>;
end;