

require LWP::UserAgent;
my $home=$_[0];	
my $ua = LWP::UserAgent->new;
$ua->timeout(200);
$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
$ua->env_proxy;


$url='http://admin-apps.isiknowledge.com/JCR/JCR?RQ=SELECT_ALL&cursor=41?SID=U1NGl%40El2dLdJKFd4F6';



my $response = $ua->get($url);

if ($response->is_success) {
	$data=$response->decoded_content;  # or whatever
}
else {
	print $response->status_line;
}

#print $data;


$form{edition}='science';
$form{RQ}='SELECT_ALL';


#$data="";

#my $response = $ua->post($url, \%form);

#if ($response->is_success) {
#	$data=$response->decoded_content;  # or whatever
#}
#else {
#	print $response->status_line;
#}

print 50x"Q";
print $data;
