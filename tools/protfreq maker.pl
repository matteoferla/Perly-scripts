require LWP::UserAgent;

sub got {
	
	
	my $street = $_[0];
	
	
	my $ua = LWP::UserAgent->new; $ua->timeout(10); $ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/'); $ua->env_proxy;
	
	my $response = $ua->get($street); if ($response->is_success) {     $home = $response->decoded_content;} else {   print $response->status_line; }
	
	
	return $home;
	
}

$query = "$query AND refseq[FILT]";

$utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";

$db     ="protein"; 

$report ="fasta";

$esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";

$esearch_result = got($esearch);

print "\nSearching for $query in $db database\n";

$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

# print "\nbug spot: $esearch_result\n";

$Count    = $1;

$QueryKey = $2;

$WebEnv   = $3;
