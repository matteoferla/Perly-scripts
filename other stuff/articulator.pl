use LWP::Simple;
my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
my $db     ="pubmed";
my $query  ="glucose%20AND%20(nanosensor%20OR%20sensor%20OR%20biosensor)";
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
my @c_sensor=();
my @c_biosensor=();
my @c_nanosensor=();
my @c_diabetes=();
my @c_clinical=();
my @c_fluoresc=();
my @c_electrode=();
my @c_lactose=();
my @c_polypyrrole=();
my @c_Au=();
my @c_quantum=();
my @c_oxidase=();
my @c_binding=();
my @c_novel=();
my @c_vivo=();
my @c_vitro=();
my @c_raman=();
my @c_con=();



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

	if ($abs[$index] =~ m/ sensor/i){$c_sensor[$index]="1"}else{$c_sensor[$index]="0"}
	if ($abs[$index] =~ m/biosensor/i){$c_biosensor[$index]="1"}else{$c_biosensor[$index]="0"}
	if ($abs[$index] =~ m/nanosensor/i){$c_nanosensor[$index]="1"}else{$c_nanosensor[$index]="0"}
	if ($abs[$index] =~ m/diabetes/i){$c_diabetes[$index]="1"}else{$c_diabetes[$index]="0"}
	if ($abs[$index] =~ m/clinical/i){$c_clinical[$index]="1"}else{$c_clinical[$index]="0"}
	if ($abs[$index] =~ m/fluoresc/i){$c_fluoresc[$index]="1"}else{$c_fluoresc[$index]="0"}
	if ($abs[$index] =~ m/electrode/i){$c_electrode[$index]="1"}else{$c_electrode[$index]="0"}
	if ($abs[$index] =~ m/lactose/i){$c_lactose[$index]="1"}else{$c_lactose[$index]="0"}
	if ($abs[$index] =~ m/polypyrrole/i){$c_polypyrrole[$index]="1"}else{$c_polypyrrole[$index]="0"}
	if ($abs[$index] =~ m/Au/i){$c_Au[$index]="1"}else{$c_Au[$index]="0"}
	if ($abs[$index] =~ m/quantum/i){$c_quantum[$index]="1"}else{$c_quantum[$index]="0"}
	if ($abs[$index] =~ m/oxidase/i){$c_oxidase[$index]="1"}else{$c_oxidase[$index]="0"}
	if ($abs[$index] =~ m/binding/i){$c_binding[$index]="1"}else{$c_binding[$index]="0"}
	if ($abs[$index] =~ m/novel/i){$c_novel[$index]="1"}else{$c_novel[$index]="0"}
	if ($abs[$index] =~ m/vivo/i){$c_vivo[$index]="1"}else{$c_vivo[$index]="0"}
	if ($abs[$index] =~ m/vitro/i){$c_vitro[$index]="1"}else{$c_vitro[$index]="0"}
	if ($abs[$index] =~ m/raman/i){$c_raman[$index]="1"}else{$c_raman[$index]="0"}
	if ($abs[$index] =~ m/con A/i){$c_con[$index]="1"}else{$c_con[$index]="0"}
	


	}

  
}

open(OUT,'>final.txt') or die "Can't make file: $!";
print OUT "$query\n";
for(my $j=1; $j <$index; $j++)
	{
	print OUT "$j:\t$pmid[$j]\t$title[$j]\t$journal[$j]\t$abs[$j]\t$date[$j]\t$author[$j]\t$doi[$j]\t$c_sensor[$j]\t$c_biosensor[$j]\t$c_nanosensor[$j]\t$c_diabetes[$j]\t$c_clinical[$j]\t$c_fluoresc[$j]\t$c_electrode[$j]\t$c_raman[$j]\t$c_vitro[$j]\t$c_vivo[$j]\t$c_novel[$j]\t$c_binding[$j]\t$c_oxidase[$j]\t$c_quantum[$j]\t$c_polypyrrole[$j]\t$c_Au[$j]\t$c_lactose[$j]\t$c_con[$j]\n";
	}

my @pmid=();
my @journal=();
my @title=();
my @abs=();
my @date=();
my @doi=();

print "\ndone\a";
