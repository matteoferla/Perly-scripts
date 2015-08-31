#!/usr/bin/perl
use sub;
use strict;
#use warnings;
sub::clear;

my $x=0;
my $y=0;
my $n=0;
my $m=0;


print "This script will:\n";
print "a)\tGet list of genome identifiers from http://www.ncbi.nlm.nih.gov/genomes/lproks.cgi\n";
print "b)\tDownload the protein tables of those organisms\n";
print "c)\tLook at the content for a given group of COG groups\n";
print "d)\tLook for protein annotated as a given name\n";
print "e)\tClassify taxonomically the species\n";
print "f)\tRetrieve a given Pfam protein\n";
print "g)\tSomething\n";

########################################################################################
my @cog=qw(COG0787 COG0626);
my @desc=('alanine racemase', 'random unmatchable nonsense');
my @pfam;
########################################################################################
print "How many protein are there to compare?";
my $input=<>; chomp($input); $input+=0;
for $n (1..$input) {
	print "COG #$n: ";	$cog[$n-1]=<>; chomp($cog[$n-1]);
	print "name (leave blank if not wanted) #$n: ";	$desc[$n-1]=<>; chomp($desc[$n-1]); if (length($desc[$n-1])<2) {$desc[$n-1]='random unmatchable nonsense';}
}

############################## get list ####################################################
my @list=();

my $file='>data/prok gen id list.txt';
open(PROKO,$file) or die "Can't make file: $!";
my @detail=();

my $url='http://www.ncbi.nlm.nih.gov/genomes/lproks.cgi';
my $html=sub::got($url);
$html=~ s/\n//sg;
$html=~ s/\r//sg;
$html=~ s/\t//sg;
my @line=split(/<tr.*?>/,$html);
chomp(@line);
for $x (0..$#line) {
	if ($line[$x]=~ m/a title=\"ProtTable\" href=\"(.*?)\"/mgsi) {
		print PROKO "$1\t";
		my @tab=split(/<td.*?>/,$line[$x]);
		foreach (@tab) {s/<\!\-\-.*?\-\-\>//smg; s/<.*?>//smg; s/\&nbsp;//smg; s/<\/.*?>//smg; print PROKO "$_\t"; $tab[10]="-";}
		print PROKO "\n";
		push(@list,$1);
		push(@detail,[@tab]);
	}
}

print "List retrieved: ".(1+$#list)." out of ".(1+$#line)." have a protein table (".sub::taken.")\n";


########################################################################################
############################## download and analyse list ################################################

my @oddgi=();
my @oddcog=();
my %cogof=();
my $good=0;
my @oddity=map(0,0..$#cog);

$file='>data/annotation mismatch gi list.txt';
open(GI,$file) or die "Can't make file: $!";
print GI "organism\tProduct Name\tStart\tEnd\tStrand\tLength\tGi\tGeneID\tLocus\tLocus_tag\tCOG(s)\n";

$file='>data/inter organism statistics.txt';
open(ORG,$file) or die "Can't make file: $!";

print ORG "organisms name\tAnalysis\t";
for $n (0..$#cog) {	print ORG "count of $cog[$n]\t";}
for $n (0..$#desc) {print ORG "count of non-$cog[$n] $desc[$n]\t";}
print ORG "flagged gi\n";


for $x (0..$#list) {
	my $note="";
	my @cog_count=();
	my @odd_count=();
	$list[$x]=~s/Retrieve/text/msgi;
	my $ptable=sub::got($list[$x]);
	$ptable=~ m/\<pre\>(.*?)\, complete genome/msgi;
	my $who=$1;
	if ($who eq "") {$who="nothing"; $note="retrival error"; goto WELL;}
	if ($who=~ m/chromosome/) {
		my @chromosome=();
		$who=~ s/ chromosome.*//msg; my $temp=$list[$x]; $temp=~s/text/Retrieve/msgi; $temp=~s/Protein\+Table/Overview/msgi;
		my $html=sub::got($temp);
		$html=~ s/\n//sg;
		$html=~ s/\r//sg;
		if ($html=~m/Chromosomes:(.+?)<br \/>/smgi) {
			my $junk=$1;
			@chromosome=($junk=~ m/\".*?(\d+)\"/g);
			foreach (@chromosome) {
				$url='http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Protein+Table&list_uids=';
				$ptable.=sub::got($url.$_);
			}
		}
	}
	$file='>data/tables/'.$who.'.txt';
	open(GEN,$file) or print "Can't make file: $!";
	print GEN $ptable;
	close GEN;
	if ($ptable!~ m/COG\d+/msgi) {$note="COG-less"; goto WELL;}
	my @seq=split(/\n/,$ptable);
	my @localoddgi=();
	foreach (@seq) {
		for $n (0..$#cog) {
			if (/$cog[$n]/) {$cog_count[$n]++;$oddcog[$n]{$cog[$n]}++;}
			else {if (/$desc[$n]/i) {
				print GI "$who\t$_\n"; 
				$odd_count[$x]++;
				my @temp=split(/\t/); $oddity[$n]=1; push(@{$oddgi[$n]},$temp[5]); push(@{$localoddgi[$n]},$temp[5]); 
				if (/(COG\d+\w+)/) {$oddcog[$n]{$1}++; $cogof{$temp[5]}=$1;}
			}}
		}
	}
	
	$good++;
	WELL:
	
	print ORG "$who\t$note\t".join("\t",@{$detail[$x]})."\t";
	for $n (0..$#cog) {	print ORG "$cog_count[$n]\t";}
	for $n (0..$#cog) {print ORG "$odd_count[$n]\t";}
	for $n (0..$#cog) {if ($localoddgi[$n]) {print ORG join(", ",@{$localoddgi[$n]})."\t";} else {print ORG "\t";}}
	print ORG "\n";
}	


for $n (0..$#cog) {
	$file='>data/annotation mismatch cog list'.$cog[$n].'.txt';
	open(COG,$file) or die "Can't make file: $!";
	foreach (sort(keys %{$oddcog[$n]})) {
		print COG "$_\t$oddcog[$n]{$_}\n";
	}
	close COG;
}


print "Protein tables retrieved: $good out of ".(1+$#list)." have been analysed (".sub::taken.")\n";
########################################################################################
############################## download and analyse odd gi list ########################
my @gene;
for $x (0..$#cog) {
	if ($oddity[$x]==1) {
		$file=">data/annotation mismatch protein table for $cog[$x].txt";
		open(OUT,$file) or die "Bugger";
		$good=$#{$oddgi[$x]}+1;
		my @tag=<DATA>; close(DATA);
		chomp(@tag);
		foreach (@tag) {s/[<>]//g;}
		print OUT "\t".join("\t",@tag)."\n";
		
		
		#my %preallocator=map {$_=>""} (@tag);
		#my @gene=map([%preallocator],0..$#oddgi);
		
		
		for $n (0..$#{$oddgi[$x]}) {
			my $query=$oddgi[$x][$n];
			my $data=retrieve($query);
			if ($data=~ m/<\/Error>/) {$good--; goto SINK;}
			my $p=0;
			for $m (@tag) {
				if ($m=~ m/PART2/) {$p=1;}
				if ($p==0) {
					if ($data=~ m/<$m>(.*)<\/$m>/smi) {
						$gene[$x][$n]{$m}=clean($1);
					}
				}
				else {
					if ($data=~ m/<GBQualifier_name>$m<\/GBQualifier_name>\s+<GBQualifier_value>(.*?)<\/GBQualifier_value>/smi) {
						if(length($gene[$x][$n]{$m})>0) {$gene[$x][$n]{$m}.="\; ".clean($1);} 
						else {$gene[$x][$n]{$m}=clean($1);}
					}
				}
			}
			if ($data=~ m/PFAM:(.*?);/) {$gene[$x][$n]{pfam}=$1;}
			if ($data=~ m/PFAM:(PF\d+)/) {$gene[$x][$n]{pfam}=$1;}
			if ($data=~ m/<GBSeq_comment>.*?(\w+\d+)/) {
				$gene[$x][$n]{predecessor}=$1;
				my $ancestordata=retrieve($gene[$x][$n]{predecessor});
				if ($ancestordata=~ m/<GBSeq_definition>(.*)<\/GBSeq_definition>/smi) {$gene[$x][$n]{predecessor_description}=clean($1);}
			}
			$gene[$x][$n]{cog}=$cogof{$query};
			
		SINK:
			print OUT "$oddgi[$n]\t".join("\t",map($gene[$x][$n]{$_},@tag))."\n";
			
		}
		print "non-$cog[$x] but annotated protein retrieved: $good out of ".(1+$#{$oddgi[$x]})." have been analysed (".sub::taken.")\n";
	}
}

######################### If I were to do a pivot not in exel ###################################
for $x (0..$#cog) {
	if ($oddity==1) {
		my %pivot=();
		my %row=();
		my %col=();
		my $r;
		my $c;
		
		for $n (0..$#{$gene[$x]}) {
			$pivot{$gene[$x][$n]{pfam}}{$gene[$x][$n]{cog}}++;
			$col{$gene[$x][$n]{pfam}}++;
			$row{$gene[$x][$n]{cog}}++;
		}
		
		$file=">data/pivot pfam vs.cog for $cog[$x].txt";
		open(FILE,$file) or die "Fatal error in pivot\n";
		for $r (sort (keys %row)) {print FILE "\t$r";} print FILE "\tTotal"; 
		for $c (sort (keys %col)) {print FILE "\n$c"; for $r (sort (keys %row)) {print FILE "\t$pivot{$c}{$r}";} print FILE "\t$col{$c}";}
		print FILE "\nTotal"; for $r (sort (keys %row)) {print FILE "\t$row{$r}";}
	}
}
########################################################################################
sub retrieve {
	my $query=$_[0]; 
	my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
	my $db ="protein";
	my $report ="gp";
	my $esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";
	my $esearch_result = sub::got($esearch);
	$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;
	my $Count = $1;
	my $QueryKey = $2;
	my $WebEnv = $3;
	$esearch_result="";
	my $retstart=0;
	my $retmax=1;
	my $efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$retstart&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
	my $data = sub::got($efetch);
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
cog