#! /usr/bin/perl
use strict;
use LWP::UserAgent;



sub got {
	
	
	my $street = $_[0];
	
	#use LWP::simple;
	my $home="";
	
	my $ua = LWP::UserAgent->new; $ua->timeout(10); $ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/'); $ua->env_proxy;
	
	my $response = $ua->get($street); if ($response->is_success) { $home = $response->decoded_content;} else {   $home = $response->status_line; }
	
	
	return $home;
	
}

my $deli="\t";

open(SESAME,'index.txt') or die "Can't open file: $!";
open(GOLD,'>out.txt') 	or die "Can't open file: $!";
open(SILVER,'>out2.txt') 	or die "Can't open file: $!";

print GOLD "query\tname\tsynonym\tsummary\tEcoGene identifier\tBlattner Genbank record identifier\tE. coli K-12 indifier\tASAP\tEchoBASE\tEcoGene\tEcoliHub\tEcoliWiki\tOU-Microarray\tRefSeq\tRegulonDB\tUniProt\n";

my $indexes=<SESAME>;
chomp($indexes);
my @indices=split(/\t/,$indexes);


foreach (@indices) {s/\W//msg;}


foreach my $index (@indices) {
print GOLD $index.$deli;
	#	if ($index eq "ECK1224") {last;}
	#my $index = "ECK1224";	
my $url="http://biocyc.org/ECOLI/NEW-IMAGE?type=GENE&object=$index&redirect=T";
	#substring-search?type=GENE&object=phtL&geneSearch=Gene+Search

my $fetched=got($url);


#the last 4 letters in the line after after the line finishing in Gene:...
	my $intro =$fetched;
$intro =~ s/<[^>]*>//imsg;
$intro =~ s/onMouseOver.*?onmouseout//imsg;
$intro =~ s/\r/\n/imsg;
$intro =~ s/\s*\n+/\n/imsg;
	#$intro =~ s/Gene Local Context.*$//imsg;
	#$intro =~ s/Genetic Regulation Schematic.*$//imsg;	
	
print SILVER $intro;
$intro =~ m/\s*Gene\:\n\s*(\w+)/;
print GOLD $1.$deli;

$intro =~ m/Accession Numbers\:(.*)[\s*\n]\w+\:/;
my @key=split(/\,/,$1);
$key[0]=~ s/\s+//msg;	$key[1]=~ s/\s+//msg;$key[2]=~ s/\s+//msg;
	$key[0]=~ s/\(EcoCyc\)//msg;
	
	
	""=~m/(.)/;
	$intro =~ m/\s*Synonyms\:\s*(\w+)\s*Summary/;
	print GOLD $1.$deli;


if ($intro =~ m/Gene Citations/) { 
	$intro =~ m/Summary\:(.*)Gene Citations/msg;
	my $t=$1;
	$t =~ s/^\s+//msg;$t =~ s/\n//msg;
	print GOLD $t.$deli;}
elsif ($intro =~ m/Map Position/msg)  {$intro =~ m/Summary\:(.*)Map Position/msg;	my $t=$1;$t =~ s/^\s+//msg;$t =~ s/\n//msg;print GOLD $t.$deli;}
else {$intro =~ m/Summary\:(.*)$/msg;	my $t=$1;			$t =~ s/^\s+//msg;$t =~ s/\n//msg;print GOLD $t.$deli;}
	
	$intro =~ m/   Unification Links\:\n(.*)$/msg;
	my $t=$1;			$t =~ s/^\s+//msg;$t =~ s/\n/ /msg;
	$t=~ m/ASAP:(.*?),/msg;
	$key[3]=$1;
	$t=~ m/EchoBASE:(.*?),/msg;
	$key[4]=$1;
	$t=~ m/EcoGene:(.*?),/msg;
	$key[5]=$1;
	if ($key[5]="") {last; print "\nThere is talk of sealing wax\n";}
	$t=~ m/EcoliHub:(.*?),/msg;
	$key[6]=$1;
	$t=~ m/EcoliWiki:(.*?),/msg;
	$key[7]=$1;
	$t=~ m/OU-Microarray:(.*?),/msg;
	$key[8]=$1;
	$t=~ m/RefSeq:(.*?),/msg;
	$key[9]=$1;
	$t=~ m/RegulonDB:(.*?),/msg;
	$key[10]=$1;
	$t=~ s/Gene/, /msg;
	$t=~ s/GO term/, /msg;
	$t=~ m/UniProt:(.*?)[\,\s\n]/msg;
	$key[11]=$1;
	print GOLD join($deli,@key);
	my $t="\-";
	$t=~m/(\-)/;
	$t =~ s/\n//msg;
	$intro=~ m/GO Term(.*?)MultiFun/msgi;
	my $s=$1;			$s =~ s/^\s+//msg;$s =~ s/\n//msg;
	print GOLD $deli.$s;
	
print GOLD "\n";
}

print "\a";