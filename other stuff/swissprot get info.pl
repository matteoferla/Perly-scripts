#!/usr/bin/perl
require LWP::UserAgent;
sub got {
	my $home=$_[0];	
	my $ua = LWP::UserAgent->new;
	$ua->timeout(60);
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

$file="in need.txt";
open(FILE,$file) or die "Bugger";
$file=">out.txt";
open(OUT,$file) or die "Bugger";

@line=<FILE>;
chomp(@line);
print OUT "query\tcode\trev\tsize\tac\torg\ttaxid\tNCBI_DNA\tNCBI_AA\tip\tpfam\n";

for $n (0..$#line) {
	$query=$line[$n];
	$url="http://www.uniprot.org/uniprot/$query\.txt";
	$data=got($url);
	$data=~ s/\t//g;
	@datum=split(/\n/,$data);
	chomp (@datum);
	foreach (@datum) {
		if (/ID\s+(\w+)\s+([\w\s]+);\s+(\d+) AA./) {$gene[$n]{code}=$1; $gene[$n]{rev}=$2;$gene[$n]{size}=$3;}
		if (/AC\s+(\w+)\;/) {$gene[$n]{ac}=$1;}
		if (/OS\s+(.+)/) {$gene[$n]{org}=$1;}
		if (/OX\s+NCBI\_TaxID\=(\d+)\;/i) {$gene[$n]{taxid}=$1;}
		if (/DR\s+EMBL\;\s+(\w+);\s+([\w\.]+);/) {$gene[$n]{base}=$1; $gene[$n]{amino}=$2;}
		if (/DR\s+InterPro; (\w+)\;/i) {$gene[$n]{ip}=$1;}
		if (/DR\s+pfam; (\w+)\;/i) {$gene[$n]{pfam}=$1;}
	}
	print OUT "$query\t$gene[$n]{code}\t$gene[$n]{rev}\t$gene[$n]{size}\t$gene[$n]{ac}\t$gene[$n]{org}\t$gene[$n]{taxid}\t$gene[$n]{base}\t$gene[$n]{amino}\t$gene[$n]{ip}\t$gene[$n]{pfam}\n"
}


