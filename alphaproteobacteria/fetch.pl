#!/usr/bin/perl
# Most of the subs are salvaged from my sub.pm list.


use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";

#use LWP::Simple; ### Working from home: it does not uses user agent to bypass proxy settings.

#use LWP::Simple qw($ua get); #DamnÉ issuesÉ
#$ua->timeout(300);
use LWP::Simple;

sub retrieve {
	my $query=$_[0]; 
	my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
	my $db ="protein";
	my $report ="gp";
	my $esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";
	my $esearch_result = get($esearch);
	$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;
	my $Count = $1;
	my $QueryKey = $2;
	my $WebEnv = $3;
	$esearch_result="";
	my $retstart=0;
	my $retmax=1;
	my $efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$retstart&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
	my $data = get($efetch);
	$data=~ s/\n//g;
	return ($data);
}

sub protein { #modified herein (deletion job)
	my $query=$_[0];
	my %protein;
	my @tag=qw(GBSeqid GBSeq_locus gene GBSeq_sequence);
    my $data=retrieve($query);
	if ($data=~ m/<\/Error>/) {return "error";}
	for my $m (@tag) {
		if ($data=~ m/<$m>(.*)<\/$m>/smi) {
			$protein{$m}=protein_clean($1);
		}
		if ($data=~ m/<GBQualifier_name>$m<\/GBQualifier_name>\s+<GBQualifier_value>(.*?)<\/GBQualifier_value>/smi) {
			$protein{$m}=protein_clean($1);
			#if($protein{$m}) {$protein{$m}.="\; ".$protein{$m}($1);} 
			#else {$protein{$m}=protein_clean($1);}
		}
	}
	return \%protein;
}

sub protein_clean {
	my $str=$_[0];
	$str=~ s/<\/.*?>/;/g;
	$str=~ s/<.*?>//g;
	$str=~ s/\s+/ /g;
	$str=~ s/[\t\n\r]/ /g;
	$str=~ s/^\s//g;
	$str=~ s/\s$//g;
	return ($str);
}

sub in {
	open FILE,$_[0] or die 'could not open '.$_[0].N;
	my @array=<FILE>;
	@array=split(/\r/,$array[0]) if ! $#array;
	close FILE;
	chomp(@array);
	return @array;
}

sub fasta_mod {#where is the original?
	my @fasta;
	my $key;
	foreach (in($_[0])) {
		if (/>/) {$key++; s/>//; s/\(.*\)//; $fasta[$key][0]=$_; $fasta[$key][1]="";}  #MOD: parenthesis kill. #what does that mean?!
		else {$fasta[$key][1].=$_}
	}
	shift(@fasta);
	#print "VERBOSE: (Error above is good) ",@{[shift(@fasta)]},N;
	return \@fasta; #ref w/ two indices: the first marks the sequences, the second as 0 has the name, as 1 has the sequence.  
}

sub fasta_write {
	my $fasta=shift;
	my $file=shift;
	open(OUT,'>',$file) or die 'I died making the output file '.$file.N;
	print OUT '>'.$fasta->[$_][0].N.$fasta->[$_][1].N for (0..$#{$fasta});
	close OUT;
}


my @list=in($ARGV[0]);
#my @list=qw(119920505);
#my @list=qw(117306219);
my @tag=qw(GBSeqid GBSeq_locus gene GBSeq_sequence);
print T.join(T,@tag).N;

foreach my $id (@list) {
    print $id;
	my $p=protein($id);
	print T.$p->{$_} foreach(@tag);
	print N;
}


