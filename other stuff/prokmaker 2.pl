#!/usr/bin/perl
require LWP::UserAgent;
sub got {
	my $home=$_[0];	
	my $ua = LWP::UserAgent->new;
	$ua->timeout(500);
	$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
	$ua->env_proxy;
	
	my $response = $ua->get($home);
	
	if ($response->is_success) {
		return $response->decoded_content;  
	}
	else {
		print $response->status_line; # or whatever to do when the internet sucks
	}
}




$tableurl="http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Protein+Table&list_uids=";
$fastaurl="http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Protein+fasta&list_uids=";
$overurl="http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Overview&list_uids=";
my $timer=time();
$file='proklist.txt';
open(PROKS,$file) or die "Can't make file: $!";
$file='>prok_out.txt';
open(OUT,$file) or die "Can't make file: $!";
@id=<PROKS>;
chomp(@id);

for $x (0..$#id) {
	####TABLE
	$url=$tableurl.$id[$x];
	$table=got($url);
	$table=~ m/\<pre\>(.*?)\, complete genome/msgi;
	$who=$1;
	$table=~ s/^.*\<pre\>//sgi;
	$table=~ s/\<\/pre\>//sgi;
	if ($who eq "") {$who="nothing";}
	$file='>genomes/table/'.$who.'.txt';
	open(TABLE,$file) or print "Can't make table file: $!";
	print TABLE $table;
	close TABLE;
	##FASTA
	$url=$fastaurl.$id[$x];
	$fasta=got($url);
	$fasta=~ s/^.*\<pre\>//sgi;
	$fasta=~ s/\<\/pre\>//sgi;
	$fasta=~ s/\&gt\;/\>/sgi;
	$file='>genomes/fasta/'.$who.'.txt';
	open(FASTA,$file) or print "Can't make fasta file: $!";
	print FASTA $fasta;
	close FASTA;
	###OVERVIEW
	$url=$overurl.$id[$x];
	$over=got($url);
	$over=~ s/^.*\<pre\>//sgi;
	$over=~ s/\<\/pre\>//sgi;
	$file='>genomes/overview/'.$who.'.txt';
	open(OVER,$file) or print "Can't make overview file: $!";
	print OVER $over;
	close OVER;
	###OUT
	print OUT (($x+1)."$who\t$id[$x]\n");
	$now=time()-$timer;
	print (int(1000*$x/$#id)/10)."percent ";
	printf(" Done. Time: %02d:%02d:%02d. Current: $who\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
}



#http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Overview&list_uids=25031

__END__
overview
Genome > Bacteria > Acetobacter pasteurianus IFO 3283-01, complete genomeLineage:Bacteria; Proteobacteria; Alphaproteobacteria; Rhodospirillales; Acetobacteraceae; Acetobacter; Acetobacter pasteurianus; Acetobacter pasteurianus IFO 3283-01
Chromosomes:
Plasmids:pAPA01-011, pAPA01-020, pAPA01-030, pAPA01-040, pAPA01-050, pAPA01-060
Refseq:NC_013209
GenBank:AP011121
Genes:2700
Protein coding:2628
Structural RNAs::72
Pseudo genes:0
Others:0
Contigs:0
Publications:1
Refseq FTP:ftp://ftp.ncbi.nih.gov/genomes/Bacteria/Acetobacter_pasteurianus_IFO_3283_01
GenBank FTP:ftp://ftp.ncbi.nih.gov/genbank/genomes/Bacteria/Acetobacter_pasteurianus_IFO_3283_01
Refseq Status::PROVISIONAL
Length:2,907,495 nt
Seq.Status:Completed
GC Content:53%
Sequencing center:Acetobacter pasteurianus genome sequencing consortium; Contact:Yoshinao Azuma Yamaguchi University School of Medicine, Department of Microbiology and Immunology; Minami-Kogushi 1-1-1, Ube, Yamaguchi 755-8505, Japan URL    :http://www.bio.nite.go.jp/dogan/Top; Yamaguchi University School of Medicine
% Coding:89%
Completed:2009/09/14
Topology:circular
Molecule:DNA
