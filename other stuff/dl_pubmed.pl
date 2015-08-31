#!/usr/bin/perl

use utf8;




############################################################################################################
################SETTINGS##########################################################################################
############################################################################################################
my @terms=qw(novel speculat improv revolution therefore hypothes theor possib socks contrary);
my $query ="bioremediation";
## " in HTML is %22
############################################################################################################
################# for simple word list see bottom of code ###########################################################################################
############################################################################################################

print "Query:";
my $query =<>;
chomp $query;
my $timer=time();
require LWP::UserAgent;
@eng=<DATA>;
chomp(@eng);

my %word=();
my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
my $db ="pubmed";

my $report ="abstract";
my $esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";
my $esearch_result = got($esearch);
#3088101NCID_1_79507543_130.14.22.28_9001_1281041501_467740893 20681521 "bioremediation"[All Fields] All Fields 3088 Y GROUP "bioremediation"[All Fields]
$esearch_result =~
m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count = $1;
my $QueryKey = $2;
my $WebEnv = $3;

print "$Count articles for $query\n";
print "Start from...";
$go=<>;
chomp($go);
$go=abs($go);

# ---------------------------------------------------------------------------



open(OUT,'>articles.txt') or die "Can't make file: $!";
print OUT ("index\tpmid\ttitle\tjournal\tabs\tdate\tauthor\tdoi".join("\t",@terms));

my $temp="";
my $retstart;
my $retmax=200;
my @content= ();
my $index=$go;
for (my $lbv=$go;$lbv<=$Count;$lbv+=$retmax) {
	if (($lbv>1)&&($index % 5 == 0)) {
		$now=time()-$timer;
		$est=$now*($Count-$index)/($index-$go);
		print ("Papers done: $index (".(int($lbv/$Count*100))."\%) in ");
		printf("%02d:%02d:%02d", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
		printf(" Est. time remaining: %02d %02d:%02d:%02d\n", int($est / 86400), int($est / 3600), int(($est % 3600) / 60), int($est % 60));
	}
	
	
	my $efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$lbv&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
	my $efetch_result = got($efetch);
	my @bag=split(/\<\/PubmedArticle\>/, $efetch_result);
	foreach $article (@bag) {
		$index++;
		@content= ();
		@content = split(/\n/, $article);
		my $i=0;
		while ($i <$#content) {
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
			if ($content[$i] =~ /<Author/)
			{
				while ($content[$i] !~ /<\/Author>/) {
					if ($content[$i] =~ /<LastName>/){
						$temp=0;
						$temp=$content[$i];
						$temp=~ s/^\s+<LastName>//s;
						$temp=~ s/<\/LastName>//s;
						$last=$temp;
					}
					if ($content[$i] =~ /<Initials>/){
						$temp=0;
						$temp=$content[$i];
						$temp=~ s/^\s+<Initials>//s;
						$temp=~ s/<\/Initials>//s;
						$initial=$temp;
					}
					$i++;
				}
				$author[$index].="\:$initial\_$last";
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
				$year[$index]=$temp;
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
			if (($content[$i] =~ /<PublicationType>/)&&($typer==0))
			{
				$type[$index]=$content[$i];
				$type[$index]=~ s/^\s+<PublicationType>//s;
				$type[$index]=~ s/<\/PublicationType>//s;
				$typer=1;
			}
			if (($content[$i] =~ /<PublicationType>/)&&($typer==1))
			{
				$supp[$index]=$content[$i];
				$supp[$index]=~ s/^\s+<PublicationType>//s;
				$supp[$index]=~ s/<\/PublicationType>//s;
			}
			
			$i++;
			
		}
		$typer=0;
		if ($author[$index] eq "") {print "\aNo author for $index!\n";}
		
		print OUT "\n$index\t$pmid[$index]\t$title[$index]\t$journal[$index]\t$abs[$index]\t$date[$index]\t$author[$index]\t$doi[$index]\t$place[$index]\t$type[$index]\t$supp[$index]";
		for $j (0..$#terms) {
			if ($abs[$index] =~ m/$terms[$j]/msi) {print OUT "\ty";} else {\print OUT "\tn";}
		}
				
	}

}

close OUT;





$now=time()-$timer;
printf("\nScript execution completed (%02d:%02d:%02d)\n\a", int($now / 3600), int(($now % 3600) / 60), int($now % 60));



sub got {
	my $home=$_[0];	
	my $ua = LWP::UserAgent->new;
	$ua->timeout(200);
	$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
	$ua->env_proxy;
	
	my $response = $ua->get($home);
	
	if ($response->is_success) {
		return $response->decoded_content;  # or whatever
	}
	else {
		print $response->status_line;
	}
}
