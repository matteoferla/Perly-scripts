#!/usr/bin/perl


print OUT "hello World\n";
require LWP::UserAgent;
 
 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
 $ua->env_proxy;

	$esearch = "$utils/esearch.fcgi?db=protein&retmax=1&usehistory=y&term=txid469008[ORGN]";
	$esearch_result = $ua->get($esearch);
 if ($esearch_result->is_success) {
     print $esearch_result->decoded_content;  # fuck you Trebech
 }
 else {
     die $esearch_result->status_line;
 }
print $esearch_result;





end;