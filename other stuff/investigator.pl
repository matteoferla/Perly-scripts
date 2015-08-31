#!/usr/bin/perl
use sub;
use strict;
#use warnings;
sub::clear;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =localtime(time);
$year += 1900;
my $dir="results $hour.$min.$sec $mday-$mon-$year";
mkdir $dir or die "could not make directory";


my $x=0;
my $y=0;
my $n=0;
my $m=0;

open(REPORT,">$dir/report.txt") or die "Can't make report: $!";

print "This script will:\n";
print "a)\tGet list of genome identifiers from http://www.ncbi.nlm.nih.gov/genomes/lproks.cgi\n";
print "b)\tDownload the protein tables of those organisms\n";
print "c)\tLook at the content for a given group of COG groups\n";
print "d)\tLook for protein annotated as a given name\n";
print "e)\tDownload protein annotated as a given name\n";
print "f)\tRetrieve a given Pfam protein\n";
print "g)\tSomething\n";
my @cog=();
my @desc=();
my @pfam=();
my $input="";
if ($ARGV[0]) {
	$input=$ARGV[0];
} else {
	print "How many protein are there to compare? (type [D]efault or [A]ll for special operations)";
	$input=<>; chomp($input); 
}
my @cogfile=sub::readfile('data/cog list.txt');
	########################################################################################
if ($input=~ m/^a/i) {
	foreach (@cogfile) {
		my @tab=split(/\t/); push(@cog,shift(@tab)); push(@desc,shift(@tab));
	}
}	

if ($input=~ m/^d/i) {
	@cog=qw(COG0787 COG0626);
	@desc=('alanine racemase', 'Cystathionine beta lyase');
	@pfam;
	
}

if ($input=~ m/(\d+)/) {
	$input=$1;
	for $n (1..$input) {
	FLASHBACK:
		print ordinal($n)." COG id number: ";	my $input_i=<>; chomp($input_i); if ($input_i=~m/(\d+)/) {$cog[$n-1]="COG$1";} else {print "That did not contain a number. Please re-enter\n"; goto FLASHBACK;}
		foreach (@cogfile) {if (/$cog[$n-1]\t/) {my @temp=split(/\t/); shift(@temp); $desc[$n-1]=shift(@temp);}}
		print ordinal($n)." name (enter 0 if not wanted, blank if \"$desc[$n-1]\"): ";	$input_i=<>; chomp($input_i); if ($input_i == 0) {$desc[$n-1]='random unmatchable nonsense';} elsif (length($input_i) > 2) {$desc[$n-1]=$input_i;} 
	}
	
}

undef @cogfile;

foreach (@desc) {s/\-//g;s/\.//g;s/\*//g;s/\?//g;s/\+//g;}

my $announcement="input opt:\tinput\t".join("\t",@cog);
print REPORT $announcement;
my $announcement="\n\t\t".join("\t",@desc);
print REPORT $announcement;

undef $input;
############################## get list ####################################################
my @list=();
my @detail=();
my $file='data/prok gen id list.txt';
if (-e $file) {
	print "The list of ids of the fully sequenced prokaryotic genomes already exists. Shall I use that?\n";
	my $input=<>; chomp($input);
	if (($input=~m/[ys]/)||($input eq "")) {
		my @line=sub::readfile($file);
		foreach (@line) {
			my @tab=split(/\t/); push(@list,shift(@tab)); push(@detail,\@tab);
		} goto LAZY;
	}
} 
open(PROKO,'>',$file) or die "Can't make $file: $!";



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

LAZY:
$announcement="List retrieved: ".(1+$#list)." out of ".(1+$#line)." have a protein table (".sub::taken.")\n";
print $announcement;
print REPORT $announcement;

########################################################################################
############################## download and analyse list ################################################

my @oddgi=();
my @oddcog=();
my %cogof=();
my $good=0;
my $existing=0;
my @oddity=map(0,0..$#cog);
my $b_count=0;my $a_count=0;
my @b_cog_count=();my @a_cog_count=();
my @b_oddcog_count=();my @a_oddcog_count=();
my @b_cog_ratio=();my @a_cog_ratio=();
my @b_oddcog_ratio=();my @a_oddcog_ratio=();

$file=">$dir/annotation mismatch gi list.txt";
open(GI,$file) or die "Can't make $file: $!";
print GI "organism\tProduct Name\tStart\tEnd\tStrand\tLength\tGi\tGeneID\tLocus\tLocus_tag\tCOG(s)\n";

$file=">$dir/inter organism statistics.txt";
open(ORG,$file) or die "Can't make $file: $!";

print ORG "organisms name\tAnalysis\t";
for $n (0..$#cog) {	print ORG "count of $cog[$n]\t";}
for $n (0..$#desc) {print ORG "count of non-$cog[$n] $desc[$n]\t";}
for $n (0..$#desc) {print ORG "ids of non-$cog[$n] $desc[$n]\t";}
print ORG "flagged gi\n";


for $x (0..$#list) {
	my $note="";
	my @cog_count=();
	my @odd_count=();
	my $ptable="";
	my @seq=();
	my $who=legal($detail[$x][3]);
	$file='data/tables/'.$who.'.txt';  
	if (-e $file) {
		@seq=sub::readfile($file);$ptable=join("\n",@seq); $existing++;
	} else {
		print "!"; goto SKIPPER;
		$list[$x]=~s/Retrieve/text/msgi;
		my $attempt=1;
	GETTHEM:
		my $ptable=sub::got($list[$x]);
		$ptable=~ m/\<pre\>(.*?)\, complete genome/msgi;
		$who=$1;
		if ($who eq "") {$who="nothing"; if ($attempt <3) {$attempt++; goto GETTHEM;} $note="retrival error"; print "Count not retrieve $list[$x] for $file\n"; goto WELL;}
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
		$file='>data/tables/'.legal($who).'.txt';
		open(GEN,$file) or print "Can't make $file: $!";
		print GEN $ptable;
		close GEN;
		@seq=split(/\n/,$ptable);
	SKIPPER:
	}
	if ($ptable!~ m/COG\d+/msgi) {$note="COG-less"; goto WELL;}
	my @localoddgi=();
	foreach (@seq) {
		s/\-//g;s/\.//g;s/\*//g;s/\?//g;s/\+//g;
		for $n (0..$#cog) {
			if (/$cog[$n]/) {$cog_count[$n]++;$oddcog[$n]{$cog[$n]}++;}
			else {if (/$desc[$n]/i) {
				print GI "$who\t$_\t$n\n"; 
				$odd_count[$n]++;
				my @temp=split(/\t/); $oddity[$n]=1; push(@{$oddgi[$n]},$temp[5]); push(@{$localoddgi[$n]},$temp[5]); 
				if (/(COG\d+\w+)/) {$oddcog[$n]{$1}++; $cogof{$temp[5]}=$1;}
			}}
		}
	}
	
	if ($detail[$x][4] eq 'B') {$b_count++;
		for $n (0..$#cog) {
			$b_cog_count[$n]+=$cog_count[$n];$b_oddcog_count[$n]+=$odd_count[$n]; 
			if ($cog_count[$n] >0) {$b_cog_ratio[$n]++;} elsif ($odd_count[$n]>0) {$b_oddcog_ratio[$n]++;}
		}
	}
	if ($detail[$x][4] eq 'A') {$a_count++; for $n (0..$#cog) {$a_cog_count[$n]+=$cog_count[$n];$a_oddcog_count[$n]+=$odd_count[$n]; if ($cog_count[$n] >0) {$a_cog_ratio[$n]++;} elsif ($odd_count[$n]>0) {$a_oddcog_ratio[$n]++;}}}
	$good++;
WELL:
	
	print ORG "$who\t$note\t";
	for $n (0..$#cog) {	print ORG "$cog_count[$n]\t";}
	for $n (0..$#cog) {print ORG "$odd_count[$n]\t";}
	for $n (0..$#cog) {if ($localoddgi[$n]) {print ORG join(", ",@{$localoddgi[$n]})."\t";} else {print ORG "\t";}}
	print ORG join("\t",@{$detail[$x]})."\n";
}	


for $n (0..$#cog) {
	$file=">$dir/annotation mismatch $cog[$n].txt";
	open(COG,$file) or die "Can't make file: $!";
	foreach (sort(keys %{$oddcog[$n]})) {
		print COG "$_\t$oddcog[$n]{$_}\n";
	}
	close COG;
}


$announcement="Protein tables retrieved: $good out of ".(1+$#list)." have been analysed and $existing previous files found (".sub::taken.")\n";
print $announcement;
print REPORT $announcement;
########################################################################################
##############################     report        ######################################
print REPORT "Bacteria\t$b_count\t"; for $n (0..$#cog) {print REPORT "$b_cog_count[$n] ($b_oddcog_count[$n]): $b_cog_ratio[$n] (+$b_oddcog_ratio[$n])\t";} print REPORT "\n";
print REPORT "Archaea\t$a_count\t"; for $n (0..$#cog) {print REPORT "$a_cog_count[$n] ($a_oddcog_count[$n]): $a_cog_ratio[$n] (+$a_oddcog_ratio[$n])\t";} print REPORT "\n";

$file=">$dir/in detail summary.txt";
open(DETAIL,$file) or die "$file making: $!";
print DETAIL "Bacteria\t\t\t\t\t\t\t\tArchaea\n";
print DETAIL "cog\tdecription\ttally\tnot-blast homologue but annotated\torg with cog (tot:$b_count)\tcog missing but annotated\tpercent no trace\t\t";
print DETAIL "tally\tnot-blast homologue but annotated\torg with cog (tot:$a_count)\tcog missing but annotated\tpercent no trace\n";
for $n (0..$#cog) {
	print DETAIL "$cog[$n]\t$desc[$n]\t";
	print DETAIL "$b_cog_count[$n]\t$b_oddcog_count[$n]\t$b_cog_ratio[$n]\t$b_oddcog_ratio[$n]\t".int(($b_cog_ratio[$n]+$b_oddcog_ratio[$n])/$b_count*100)."\t\t";
	print DETAIL "$a_cog_count[$n]\t$a_oddcog_count[$n]\t$a_cog_ratio[$n]\t$a_oddcog_ratio[$n]\t".int(($a_cog_ratio[$n]+$a_oddcog_ratio[$n])/$a_count*100)."\n";
}
print DETAIL "\n";




########################################################################################
############################## download and analyse odd gi list ########################
print "Do you want to retrieve the protein annotated as the homologue but are not homologous?\n";
my $in=<>; if ($in=~/n/i) {exit;}


my @gene;
for $x (0..$#cog) {
	
	if ($oddity[$x] == 1) {
		$file=">$dir/annotation mismatch protein table for $cog[$x].txt";
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
		$announcement="non-$cog[$x] but annotated protein retrieved: $good out of ".(1+$#{$oddgi[$x]})." have been analysed (".sub::taken.")\n";
		print $announcement;
		print REPORT $announcement;
	}
	close(OUT);
}

######################### If I were to do a pivot not in exel ###################################
for $x (0..$#cog) {
	if ($oddity[$x] == 1) {
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
		
		$file=">$dir/pivot pfam vs.cog for $cog[$x].txt";
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

sub ordinal {
	my ($n) = @_;
	my $last=substr(sprintf("%d",$n ),-1,1);
	if ($n == 11) {return "$n-th";}
	elsif ($last eq '1') {return "$n-st";}
	elsif ($last eq '2') {return "$n-nd";}
	elsif ($last eq '3') {return "$n-rd";}
	else {return "$n-th";}
}

sub legal {
	my ($n)=@_;
	chomp($n);
	$n=~s/\///g;
	$n=~s/\$//g;
	$n=~s/\://g;
	return $n;
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