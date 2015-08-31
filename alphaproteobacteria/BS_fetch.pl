#!/usr/bin/perl
use strict;
use warnings;
use constant N=>"\n";
use constant T=>"\t";

####################################################################
###### Subs ########################################################
####################################################################

sub in {
	open FILE,$_[0] or die 'could not open '.$_[0].N;
	my @array=<FILE>;
	@array=split(/\r/,$array[0]) if ! $#array;
	close FILE;
	chomp(@array);
	return @array;
}

sub out {
	open(FILE,'>',$_[0]) or die 'could not open '.$_[0].N;
	print FILE $_[1];
	close FILE;
}


sub write_clp {  
	my $content=$_[0];
	my $os=$^O;
	if ($_[1]) {$content=$_[1];} #static method
	if ($os eq "MSWin32") {
		eval 'use Win32::Clipboard;
		my $CLIP = Win32::Clipboard();
		$CLIP->Set($content);';
		return ();
	}
	elsif ($os eq "darwin") {
		open (TO_CLIPBOARD, "|pbcopy");
		print TO_CLIPBOARD $content;
		close (TO_CLIPBOARD);
	}
	else {
		die "CRASH! I cannot paste the data to your clipboard. And what kind of a man uses a $os, anyway?!\n";
	}
}

####################################################################
###### Main ########################################################
####################################################################

system("clear");
print "Kia ora\n";
my %data=();


foreach my $file (<RAxML_bootstrap*>) {
	$file=~s/RAxML_bootstrap\.//;
	system("./nw_reroot RAxML_bootstrap.".$file." Campylobacter_jejuni_ICDCCJ07001_ > RRBS.".$file);
	($file=~/mt/) ? (system("./nw_support ref_mt_reroot.tree RRBS.".$file." |./nw_rename - small.map |./nw_condense - |./nw_topology - > processed.".$file)):(system("./nw_support ref_reroot.tree RRBS.".$file." |./nw_rename - small.map |./nw_condense - |./nw_topology - > processed.".$file));
	my ($tree)=(in("processed.".$file));
	$file=~s/\W/\_/g;
	
	print $tree.N;
	#(outgroup,(outgroup,((Magnetococcales,(((Candidatus_Odyssella_thessalonicensis_L13_,Caedibacter_caryophilus_221_)219,((Acetobacteraceae,(Rhodospirillaceae,RhodospirillaceaeM)429)772,Crown)140)141,((Anaplasmataceae,(Midichloria,Rickettsiaceae)910)1000,(Pelagibacterales,PelagibacteralesB)999)426)1000)1000,outgroup)883)1000)1000;
	#(outgroup,(outgroup,((Magnetococcales,(((Candidatus_Odyssella_thessalonicensis_L13_,Caedibacter_caryophilus_221_)992,((Acetobacteraceae,(Rhodospirillaceae,RhodospirillaceaeM)122)111,Crown)904)968,((Mitochondria,(Anaplasmataceae,(Midichloria,Rickettsiaceae)606)995)1000,(Pelagibacterales,PelagibacteralesB)1000)941)1000)1000,outgroup)489)1000)1000;

	if ($tree=~m/221_.*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?Mitochondria.*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+)/) {
		
		$data{$file}[0]=$1; # Holo mono
		$data{$file}[1]=$2; # Rhodospirillaceae mono
		$data{$file}[2]=$3; # Rhodospirillales mono
		$data{$file}[3]=$4; # Rhodospirillales + Crown
		$data{$file}[4]=$5; # Caulobacteridae
		$data{$file}[5]=$6; # Midi + Rickettsiaceae
		$data{$file}[6]=$7; # Rickettsiales
		$data{$file}[7]=$8; # mito+Rickettsiales
		$data{$file}[8]=$9; # Pelagibacterales mono
		$data{$file}[9]=$10; # Rickettsidae
		$data{$file}[10]=$11; # inner alpha
		
		#print join(",",@{$data{$file}}).N;
		
	} elsif ($tree=~m/221_.*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+)/) {
		
		$data{$file}[0]=$1; # Holo mono
		$data{$file}[1]=$2; # Rhodospirillaceae mono
		$data{$file}[2]=$3; # Rhodospirillales mono
		$data{$file}[3]=$4; # Rhodospirillales + Crown
		$data{$file}[4]=$5; # Caulobacteridae
		$data{$file}[5]=$6; # Midi + Rickettsiaceae
		$data{$file}[6]=$7; # Rickettsiales
		$data{$file}[7]='N/A'; # mito+Rickettsiales
		$data{$file}[8]=$8; # Pelagibacterales mono
		$data{$file}[9]=$9; # Rickettsidae
		$data{$file}[10]=$10; # inner alpha
		
		#print join(",",@{$data{$file}}).N;
		
	}
	
	
	else {die "ARGGG!\n"}
}

my @header=qw(Holosporaceae Rhodospirillaceae Rhodospirillales Rhodospirillales+Crown Caulobacteridae Midichloria+Rickettsiaceae Rickettsiales Mitochondria+Rickettsiales Pelagibacterales Rickettsidae inner_alpha);
print N.N.T.join(T,(sort keys %data)).N;

for my $n (0..10) {
	print $header[$n];
	foreach my $m (sort keys %data) {
		print T.$data{$m}[$n];
	}
	print "\n";
}



print "\nHaere mai\n\a";
exit;

__END__
./nw_reroot RAxML_bootstrap.mus-bij_bacteria_mt-RYKM.gamma Campylobacter_jejuni_ICDCCJ07001_ > RRBS.arb-bij_bacteria_mt-RYKM.gamma
./nw_support ref_reroot.tree RRBS.arb-bij_bacteria-RYKM.cat |./nw_rename - small.map |./nw_condense - |./nw_topology - |./nw_display -

(outgroup,(outgroup,((Magnetococcales,(((Candidatus_Odyssella_thessalonicensis_L13_,Caedibacter_caryophilus_221_)912,((Acetobacteraceae,(Rhodospirillaceae,RhodospirillaceaeM)130)350,Crown)866)649,((Anaplasmataceae,(Midichloria,Rickettsiaceae)273)1000,(Pelagibacterales,PelagibacteralesB)998)953)1000)983,outgroup)518)1000)1000;



Acanthamoeba_castellanii_mitochondrion_ Arabidopsis_thaliana_mitochondrion_ Chaetosphaeridium_globosum_mitochondrion_ Chara_vulgaris_mitochondrion_ Chattonella_marina_mitochondrion_ Chlorokybus_atmophyticus_strain_SAG_4880_mitochondrion_ Chondrus_crispus_mitochondrion_ Cyanidioschyzon_merolae_mitochondrion_ Cyanophora_paradoxa_strain_CCMP_329_mitochondrion_ Dictyostelium_discoideum_mitochondrion_ Glaucocystis_nostochinearum_mitochondrion_ Hartmannella_vermiformis_mitochondrion_ Malawimonas_jakobiformis_mitochondrion_ Marchantia_polymorpha_mitochondrion_ Megaceros_aenigmaticus_mitochondrion_ Naegleria_gruberi_mitochondrion_ Nephroselmis_olivacea_mitochondrion_ Ochromonas_danica_mitochondrion_ Phytophthora_infestans_mitochondrion_ Pilayella_littoralis_mitochondrion_ Polysphondylium_pallidum_mitochondrion_ Prototheca_wickerhamii_263-11_mitochondrion_ Reclinomonas_americana_mitochondrion_ Saprolegnia_ferax_strain_ATCC_36051_mitochondrion_
Ralstonia_solanacearum_GMI1000_ Thiobacillus_denitrificans_ATCC_25259_ Campylobacter_jejuni_ICDCCJ07001_ Acidithiobacillus_ferrooxidans_ATCC_23270_ Escherichia_coli_MG1655_ Xanthomonas_campestris_8004_ Mariprofundus_ferrooxydans_PV1_