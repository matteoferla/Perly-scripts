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
		print "WTF\n\n\n";
		print $response->status_line;
	}
}

sub retrieve {
	my $query=$_[0]; 
	my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
	my $db ="protein";
	my $report ="gp";
	my $esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";
	my $esearch_result = got($esearch);
	$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;
	my $Count = $1;
	my $QueryKey = $2;
	my $WebEnv = $3;
	$esearch_result="";
	my $retstart=1;
	my $retmax=1;
	my $efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$lbv&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
	my $data = got($efetch);
	$data=~ s/\n//g;
	return ($data);
}

sub clean {
	my $str=$_[0];
	$str=~ s/<\/.*?>/;/g;
	$str=~ s/<.*?>//g;
	$str=~ s/\s+/ /g;
	$str=~ s/[\t\n\r]/ /g;
	$str=~ s/^\s//g;
	$str=~ s/\s$//g;
	return ($str);
}

$file="redux_gi.txt";
open(FILE,$file) or die "Bugger";
$file=">out.txt";
open(OUT,$file) or die "Bugger";

@tag=<DATA>;
chomp(@tag);
foreach (@tag) {s/[<>]//g;}

@line=<FILE>;
chomp(@line);

$max=$#line;
print "Retrieving ".(1+$max)." protein\n";
for $n (0..$max) {
	$query=$line[$n];
	$data=retrieve($query);
	for $m (@tag) {
		if ($m=~ m/PART2/) {$p=1;}
		if ($p==0) {
			if ($data=~ m/<$m>(.*)<\/$m>/smi) {$gene[$n]{$m}=clean($1);}
		}
		else {
			if ($data=~ m/<GBQualifier_name>$m<\/GBQualifier_name>\s+<GBQualifier_value>(.*?)<\/GBQualifier_value>/smi) {
				if(length($gene[$n]{$m})>0) {$gene[$n]{$m}.="\; ".clean($1);} 
				else {$gene[$n]{$m}=clean($1);}
			}
		}
	}
	if ($data=~ m/PFAM:(PF\d+)/) {$gene[$n]{pfam}=$1;}
	if ($data=~ m/<GBSeq_comment>.*?(\w+\d+)/) {
		$gene[$n]{predecessor}=$1;
		$ancestordata=retrieve($gene[$n]{predecessor});
		if ($ancestordata=~ m/<GBSeq_definition>(.*)<\/GBSeq_definition>/smi) {$gene[$n]{predecessor_description}=clean($1);}
	}
	$p=0;
}
print OUT "\t".join("\t",@tag)."\n";
for $n (0..$max) {
	print OUT "$line[$n]\t".join("\t",map($gene[$n]{$_},@tag))."\n";
}

__DATA__
<GBSeq_locus>
<GBSeq_length>
<GBSeq_moltype>
<GBSeq_topology>
<GBSeq_division>
<GBSeq_update-date>
<GBSeq_create-date>
<GBSeq_definition>
<GBSeq_primary-accession>
<GBSeq_other-seqids>
<GBSeq_project>
<GBSeq_source>
<GBSeq_organism>
<GBSeq_taxonomy>
<GBSeq_references>
<GBSeq_comment>
<GBSeq_feature-table>
<GBFeature_quals>
<GBQualifier>
<GBSeq_sequence>
PART2
organism
strain
culture_collection
db_xref
note
EC_number
product
calculated_mol_wt
region_name
site_type
coded_by
inference
transl_table
locus_tag
predecessor
predecessor_description
pfam