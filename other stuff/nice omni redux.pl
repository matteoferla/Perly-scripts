#!/usr/bin/perl
use sub;
use strict;
#use warnings;
sub::clear;



my $x=0;
my $y=0;
my $n=0;
my $m=0;

my $file=">inventory redux.txt"; open(INFO,$file) 	or die "Can't create file: $!";
print INFO "name\tuid\tlineage";

$file=">error_report.txt"; open(ERRATUM,$file) 	or die "Can't create file: $!";
print ERRATUM "name\tuid\tissue";



############################## get list ####################################################
my @list=();
my @line=();
my @detail=();
my $file='prok gen id list.txt';
if (-e $file) {print "The list of ids of the fully sequenced prokaryotic genomes already exists. Shall I use that?\n";
	my $input=<>; chomp($input);
	if (($input=~m/[ys]/)||($input eq "")) {
		@line=sub::readfile($file);
		foreach (@line) {
			my @tab=split(/\t/); push(@list,(shift(@tab))); push(@detail,[@tab]);
		}}
} else {
	open(PROKO,'>',$file) or die "Can't make file: $!";
	
	
	my $url='http://www.ncbi.nlm.nih.gov/genomes/lproks.cgi';
	my $html=sub::got($url);
	$html=~ s/\n//sg;
	$html=~ s/\r//sg;
	$html=~ s/\t//sg;
	@line=split(/<tr.*?>/,$html);
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
	
}
print "List retrieved: ".(1+$#list)." out of ".(1+$#line)." have a protein table (".sub::taken.")\n";


########################################################################################
############################## download and analyse list ################################################


my $good=0;
my $existing=0;
my @fastalist=();
my @tablelist=();
for my $x (0..$#list) {
	my @gene;
	my $note="";
	my $fasta="";
	my $ptable="";
	my @seq=();
	my $file='genome redux/fasta/'.sub::legal($detail[$x][3]).'.txt';  ###that two was taken out of a hat... 
	my $filep='genome redux/table/'.sub::legal($detail[$x][3]).'.txt';
	if ((-e $file)&&(-e $filep)) {
		@fastalist=sub::readfile($file); $fasta=join("\n",@fastalist); $existing++;
		@tablelist=sub::readfile($filep); $ptable=join("\n",@tablelist); $existing++;
	} else {
		$list[$x]=~s/Retrieve/text/msgi;
		my $urlp=$list[$x];
		$list[$x]=~s/Protein\+Table/Protein\+fasta/msgi;
		my $fasta=sub::got($list[$x]);
		my $ptable=sub::got($urlp);
		$fasta=~ m/\<pre\>(.*?)\, complete genome/msgi;
		my $who=$1;
		if ($who eq "") {$who="nothing"; $note="retrival error"; goto WELL;}
		if ($who=~ m/chromosome/) {
			my @chromosome=();
			$who=~ s/ chromosome.*//msg; my $temp=$list[$x]; $temp=~s/text/Retrieve/msgi; $temp=~s/Protein\+fasta/Overview/msgi;
			my $html=sub::got($temp);
			$html=~ s/\n//sg;
			$html=~ s/\r//sg;
			if ($html=~m/Chromosomes:(.+?)<br \/>/smgi) {
				my $junk=$1;
				@chromosome=($junk=~ m/\".*?(\d+)\"/g);
				my $url='http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Protein+fasta&list_uids=';
				my $urli='http://www.ncbi.nlm.nih.gov/sites/entrez?db=genome&cmd=text&dopt=Protein+fasta&list_uids=';
				foreach (@chromosome) {
					$fasta.=sub::got($url.$_);
					$ptable.=sub::got($urli.$_);
				}
			}
			open(FASTA,'>',$file) or die "$file $!";
			print FASTA $fasta;
			close FASTA;
			
			open(PTABLE,'>',$filep) or die "$filep $!";
			print PTABLE $ptable;
			close PTABLE;
			
		}
		@fastalist=split(/\n/,$fasta);
		@tablelist=split(/\n/,$ptable);
	}

	$good++;
	my $genenumber=0;
	for (my $n=0;$n<=$#fastalist;$n++)
	{
		
		#>gi|51594360|ref|YP_068551.1| flavodoxin [Yersinia pseudotuberculosis IP 32953]
		if ($fastalist[$n]=~ m/\>/msg) {
			
			my @temp=split(/\|/,$fastalist[$n]);
			$genenumber++;
			shift(@temp);
			$gene[$genenumber][0]=shift(@temp);
			shift(@temp);
			$gene[$genenumber][1]=shift(@temp);
			$gene[$genenumber][2]=shift(@temp);
			
		} else
		{$fastalist[$n]=~s/\W//msg;$fastalist[$n]=~s/\r//msg;$fastalist[$n]=~s/\n//msg;$fastalist[$n]=~s/\d//msg;$fastalist[$n]=~s/X//msgi;$fastalist[$n]=~s/\_//msg;$gene[$genenumber][3].=uc($fastalist[$n]);}
	}
	
	
	shift(@gene);
	shift(@tablelist);
	shift(@tablelist);
	for (my $n=0;$n<=$#gene;$n++)
	{
		
		#Acaryochloris marina MBIC11017, complete genome
		#Product Name	Start	End	Strand	Length	Gi	GeneID	Locus	Locus_tag	COG(s)
		$gene[$n][4]=0;
		push(@{$gene[$n]},split(/\t/,$tablelist[$n]));
		$gene[$n][4]=$gene[$n][$#{$gene[$n]}];
		
	}
	
	#my $lineus=$overlist[0];
	#$lineus=~ s/^.*Lineage://msgi;
	#
	
	@tablelist=();
	@fastalist=();
	
	
	
	
	###############SAVE THE GENES! (& the whales)########################################################################################################################################################################################################################
	$file=">omni redux/".sub::legal($detail[$x][3]).".txt";	
	open(AAOUT,$file) 	or die "Can't open file $file: $!";
	print AAOUT ("internal\tkey\tref key\tdescr\tsequence\tCOG(s)\tProduct Name\tStart\tEnd\tStrand\tLength\tGi\tGeneID\tLocus\tLocus_tag\n");
	for my $i ( 0 .. $#gene ) {
		print AAOUT (($i+1)."\t".join("\t",@{$gene[$i]})."\n");
	}
	close AAOUT;
	
	
	print INFO ("\n".join("\t",@{$detail[$x]}));
	
	@gene=();
	$genenumber=0;
	#############
	
	
WELL:

}	
