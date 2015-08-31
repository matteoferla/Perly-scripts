#! /usr/bin/perl
print "Hello World\n";
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5;


my $timer=time();
###################################
#	parameters:
@fullabc=("A".."Z");
#@fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
#@fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
my @Hydroref=(1.8, 0, 2.5, -3.5, -3.5, 2.8, -0.4, -3.2, 4.5, 0, -3.9, 3.8, 1.9, -3.5, 0, -1.6, -3.5, -4.5, -0.8, -0.7, 0, 4.2, -0.9, 0, -1.3);
my $Hstep=2; # number of steps per hydropathy score unit, so it increases in 1/step increments.
my $Sstep=100; #idem but for size...
@Cats=("A ( RNA processing and modification)","B ( Chromatin structure and dynamics)","C ( Energy production and conversion)","D ( Cell cycle control, cell division, chromosome partitioning)","E ( Amino acid transport and metabolism)","F ( Nucleotide transport and metabolism)","G ( Carbohydrate transport and metabolism)","H ( Coenzyme transport and metabolism)","I ( Lipid transport and metabolism)","J ( Translation, ribosomal structure and biogenesis)","K ( Transcription)","L ( Replication, recombination and repair)","M ( Cell wall/membrane/envelope biogenesis)","N ( Cell motility)","O ( Posttranslational modification, protein turnover, chaperones)","P ( Inorganic ion transport and metabolism)","Q ( Secondary metabolites biosynthesis, transport and catabolism)","R ( General function prediction only)","S ( Function unknown)","T ( Signal transduction mechanisms)","U ( Intracellular trafficking, secretion, and vesicular transport)","V ( Defense mechanisms)","W ( Extracellular structures)","X (Blank)","Y ( Nuclear structure)","Z ( Cytoskeleton)");
##################################



$file=">inventory.txt"; open(INFO,$file) 	or die "Can't create file: $!";
print INFO "name\tuid\tlineage";

$file=">error_report.txt"; open(ERRATUM,$file) 	or die "Can't create file: $!";
print ERRATUM "name\tuid\tissue";



open(ORG,'prok_out.txt') or die "Can't find microbe inventory: $!";
@micro=<ORG>;
chomp(@micro);
for $x (0..$#micro) {
	@{$org[$x]}=split(/\t/,$micro[$x]);
	shift(@{$org[$x]});
}




######################################LOOP START##################################################################################################################
$go=0;
for $whom ($go..$#org) {
	
	my $error=0;
	print "\n\n$org[$whom][0]\n";
	
	if (($whom>1)&&($whom % 5 == 0)) {
		$now=time()-$timer;
		$est=$now*($#org-$whom)/($whom-$go);
		print ("Organisms done: $whom (".(int(($whom-$go)/($#org)*100))."\%) in ");
		printf("%02d:%02d:%02d", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
		printf(" Est. time remaining: %02d %02d:%02d:%02d\n", int($est / 86400), int($est / 3600), int(($est % 3600) / 60), int($est % 60));
	}
	
	
	if ($org[$whom][0] eq "nothing") {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\tnothingness"); goto JUMP;}
	if ($org[$whom][0] eq "") {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\tblankness"); goto JUMP;}
	
	$file="genomes/fasta/".$org[$whom][0].".txt"; open(FASTA,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\tfastalss"); goto JUMP;}
	my @fastalist=<FASTA>; chomp(@fastalist);
	close FASTA;
	
	$file="genomes/table/".$org[$whom][0].".txt"; open(TABLE,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\ttableless"); goto JUMP;}
	my @tablelist=<TABLE>; chomp(@tablelist);
	close TABLE;
	
	$file="genomes/overview/".$org[$whom][0].".txt"; open(OVER,$file) 	or $error=1;
	if ($error==1) {print ERRATUM ("\n".join("\t",@{$org[$whom]})."\toverviewless"); goto JUMP;}
	my @overlist=<OVER>; chomp(@overlist);
	close OVER;
	
	
	
	
	
	for ($n=0;$n<=$#fastalist;$n++)
	{
		
		#>gi|51594360|ref|YP_068551.1| flavodoxin [Yersinia pseudotuberculosis IP 32953]
		if ($fastalist[$n]=~ m/\>/msg) {
			
			@temp=split(/\|/,$fastalist[$n]);
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
	for ($n=0;$n<=$#gene;$n++)
	{
		
		#Acaryochloris marina MBIC11017, complete genome
		#Product Name	Start	End	Strand	Length	Gi	GeneID	Locus	Locus_tag	COG(s)
		$gene[$n][4]=0;
		push(@{$gene[$n]},split(/\t/,$tablelist[$n]));
		$gene[$n][4]=$gene[$n][$#{$gene[$n]}];
	
	}
	
	$lineus=$overlist[0];
	$lineus=~ s/^.*Lineage://msgi;
	#
	
	@tablelist=();
	@fastalist=();
	@temp=();

	
	
		
	###############SAVE THE GENES! (& the whales)########################################################################################################################################################################################################################
	$file=">omninice/".$org[$whom][0].".txt";	
	open(AAOUT,$file) 	or die "Can't open file: $!";
	print AAOUT ("internal\tkey\tref key\tdescr\tsequence\tCOG(s)\tProduct Name\tStart\tEnd\tStrand\tLength\tGi\tGeneID\tLocus\tLocus_tag\n");
	for $i ( 0 .. $#gene ) {
		print AAOUT (($i+1)."\t".join("\t",@{$gene[$i]})."\n");
	}
	close AAOUT;
	
	
	print INFO ("\n".join("\t",@{$org[$whom]})."\t$lineus");
	
	@gene=();
	$genenumber=0;
	#############
	
JUMP:
######################################LOOP START##################################################################################################################
}


print "All done!\n\a";