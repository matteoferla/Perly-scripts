use LWP::Simple;
my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
my $db     ="pubmed";
my $query  ="nanosensor%20glucose";
my $report ="abstract";
my $esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";
my $esearch_result = get($esearch);

$esearch_result =~ 
  m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count    = $1;
my $QueryKey = $2;
my $WebEnv   = $3;

print "$Count articles for $QueryKey\n";

# ---------------------------------------------------------------------------
my @pmid=();
my @journal=();
my @title=();
my @abs=();
my @date=();
my @doi=();
my $index=0; #redundant?

my $temp="";
my $retstart;
my $retmax=1;
my @content= ();
#$Count
for($retstart = 0; $retstart < $Count; $retstart += $retmax) {
my $efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$retstart&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
my $efetch_result = get($efetch);
@content= ();
@content = split(/\n/, $efetch_result);
my $size=@content;
$index++;
print "#";
for(my $i=0; $i <$size; $i++)
	{
	chomp($content[$i]);
  	if ($content[$i] =~ /<PMID>/)
		{
		$pmid[$index]=$content[$i];
		$pmid[$index]=~ s/<PMID>//s;
		$pmid[$index]=~ s/<\/PMID>//s;
		$pmid[$index]=~ s/^\s+//s;
		#print $pmid[$index];
		}
  	if ($content[$i] =~ /<Title>/)
		{
		$journal[$index]=$content[$i];
		$journal[$index]=~ s/<Title>//s;
		$journal[$index]=~ s/<\/Title>//s;
		$journal[$index]=~ s/^\s+//s;
		#print $journal[$index];
		}
  	if ($content[$i] =~ /<ArticleTitle>/)
		{
		$title[$index]=$content[$i];
		$title[$index]=~ s/<ArticleTitle>//s;
		$title[$index]=~ s/<\/ArticleTitle>//s;
		$title[$index]=~ s/^\s+//s;
		#print $title[$index];
		}
  	if ($content[$i] =~ /<AbstractText>/)
		{
		$abs[$index]=$content[$i];
		$abs[$index]=~ s/<AbstractText>//s;
		$abs[$index]=~ s/<\/AbstractText>//s;
		$abs[$index]=~ s/^\s+//s;
		#print $abs[$index];
		}
  	if ($content[$i] =~ /<LastName>/)
		{		
		$temp=0;
		$temp=$content[$i];
		$temp=~ s/^\s+<LastName>//s;
		$temp=~ s/<\/LastName>//s;
		$author[$index]="$author[$index]\:$temp";
		}
  	if ($content[$i] =~ /<DateCreated>/)
		{
		$temp=0;
		$temp=$content[$i+3];
		$temp=~ s/^\s+<Day>//s;
		$temp=~ s/<\/Day>//s;
		$date[$index]="$temp\:";
		$temp=$content[$i+2];
		$temp=~ s/^\s+<Month>//s;
		$temp=~ s/<\/Month>//s;
		$date[$index]="$date[$index]$temp\:";
		$temp=$content[$i+1];
		$temp=~ s/^\s+<Year>//s;
		$temp=~ s/<\/Year>//s;
		$date[$index]="$date[$index]$temp";
		}
  	if ($content[$i] =~ /<ArticleId IdType\=\"doi\">/)
		{
		$doi[$index]=$content[$i];
		$doi[$index]=~ s/^\s+<ArticleId IdType\=\"doi\">//s;
		$doi[$index]=~ s/<\/ArticleId>//s;
		}
  	if ($content[$i] =~ /<Affiliation>/)
		{
		$place[$index]=$content[$i];
		$place[$index]=~ s/^\s+<Affiliation>//s;
		$place[$index]=~ s/<\/Affiliation>//s;
		}


	}

  
}

open(OUT,'>out.txt') or die "Can't make file: $!";
print OUT "$query\n";
for(my $j=1; $j <$index; $j++)
	{
	print OUT "$j:\t$pmid[$j]\t$title[$j]\t$journal[$j]\t$abs[$j]\t$date[$j]\t$doi[$j]\n";
	}

my @pmid=();
my @journal=();
my @title=();
my @abs=();
my @date=();
my @doi=();

print "\ndone\a";
