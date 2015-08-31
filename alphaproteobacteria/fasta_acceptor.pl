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

sub name{
	my $name=$_[0];
	$name=~ s/ /_/smg;
	$name=~ s/\W//smg;
	$name=~ s/$_//g foreach qw(Candidatus_ sp_ strain_ subsp_ endosymbiont_of_ alpha_proteobacterium Alphaproteobacteria _contig1 _cons);
	$name=~ s/^_+//g;
	$name='blank' if ($name !~ /\w/);
	return lc $name;
}

sub fasta_mod {
	my @fasta;
	my $key;
	foreach (in($_[0])) {
		if (/>/) {$key++; $_=~s/.*\[(.*)\].*/$1/; $fasta[$key][0]=name($_); $fasta[$key][1]="";}
		else {$fasta[$key][1].=$_}
	}
	shift(@fasta);
	#print "VERBOSE: (Error above is good) ",@{[shift(@fasta)]},N;
	return @fasta; #changed from ref!
}


####################################################################
###### Main ########################################################
####################################################################

print "Kia ora\n";

open(FIVE,'>out 5S.fasta') or die 'I died making the output file'.N;
open(SIXTEEN,'>out 16S.fasta') or die 'I died making the output file'.N;
open(TWENTYTHREE,'>out 23S.fasta') or die 'I died making the output file'.N;

my @five=fasta_mod('Alphaproteobacteria_5S_ed.fna');
my @sixteen=fasta_mod('Alphaproteobacteria_16S_ed.fna');
my @twentythree=fasta_mod('Alphaproteobacteria_23S_ed.fna');

foreach (<DATA>) {
	chomp;
	my $wight=$_;
	my $munted=name($wight);
	
	###FIVE######
	my @find=grep($_->[0] =~ /$munted/,@five);
	if (! @find) {
		print "$wight ($munted) was not found in 5S\n";
	} 
	#elsif ($#find>0) {print FIVE ">$wight\n$find[0][1]\n"; print "VERBOSE: $wight found ".($#find+1)." times as ".join(" and ",map($_->[0],@find))."\n";}
	else {print FIVE ">$wight\n$find[0][1]\n";}
	undef @find;
	
	###16######(copy-paste!)
	my @find=grep($_->[0] =~ /$munted/,@sixteen);
	if (! @find) {
		print "$wight ($munted) was not found in 16S\n";
	} 
	#elsif ($#find>0) {print FIVE ">$wight\n$find[0][1]\n"; print "VERBOSE: $wight found ".($#find+1)." times as ".join(" and ",map($_->[0],@find))."\n";}
	else {print SIXTEEN ">$wight\n$find[0][1]\n";}
	undef @find;
	
	###23######(copy-paste!)
	my @find=grep($_->[0] =~ /$munted/,@twentythree);
	if (! @find) {
		print "$wight ($munted) was not found in 23S\n";
	} 
	#elsif ($#find>0) {print FIVE ">$wight\n$find[0][1]\n"; print "VERBOSE: $wight found ".($#find+1)." times as ".join(" and ",map($_->[0],@find))."\n";}
	else {print TWENTYTHREE ">$wight\n$find[0][1]\n";}
	undef @find;
}

print "\nHaere mai\n\a";
exit;

__DATA__
Acetobacter pasteurianus IFO 3283-01
Acetobacter pomorum DM001
Acetobacter tropicalis NBRC 101654
Acidiphilium cryptum JF-5
Acidiphilium multivorum AIU301
Acidiphilium sp. PM
Afipia sp. 1NLS2
Agrobacterium sp. ATCC 31749
Agrobacterium sp. H13-3
Agrobacterium tumefaciens C58-UWash
Agrobacterium vitis S4
Ahrensia sp. R2A130
Anaplasma centrale str. Israel
Anaplasma marginale Puerto Rico
Anaplasma phagocytophilum HZ
Asticcacaulis biprosthecum C19
Asticcacaulis excentricus CB 48
Aurantimonas manganoxydans SI85-9A1
Azorhizobium caulinodans ORS 571
Azospirillum sp. B510
Bartonella bacilliformis KC583
Bartonella clarridgeiae 73
Bartonella grahamii as4aup
Bartonella henselae Houston-1
Bartonella quintana Toulouse
Bartonella tribocorum CIP 105476
Beijerinckia indica indica ATCC 9039
Bradyrhizobiaceae bacterium SG-6C
Bradyrhizobium sp. BTAi1
Bradyrhizobium japonicum USDA 110
Bradyrhizobium sp. ORS278
Brevundimonas sp. BAL3
Brevundimonas diminuta ATCC 11568
Brevundimonas subvibrioides ATCC 15264
Brucella sp. 83/13
Brucella abortus NCTC 8038
Brucella sp. BO1
Brucella sp. BO2
Brucella canis ATCC 23365
Brucella ceti M13/05/1
Brucella sp. F5/99
Brucella melitensis M28
Brucella microti CCM 4915
Brucella neotomae 5K33, ATCC 23459
Brucella sp. NF 2653
Brucella sp. NVSL 07-0026
Brucella ovis ATCC 25840
Brucella pinnipedialis M292/94/1
Brucella suis ATCC 23445
Caulobacter crescentus CB15
Caulobacter sp. K31
Caulobacter segnis ATCC 21756
Chelativorans sp. BNC1
Citreicella sp. SE45
Citromicrobium bathyomarinum JL354
Dinoroseobacter shibae DFL-12, DSM 16493
Ehrlichia canis Jake
Ehrlichia chaffeensis Arkansas
Ehrlichia ruminantium Gardel
Ensifer medicae WSM419
Ensifer meliloti BL225C
Erythrobacter litoralis HTCC2594
Erythrobacter sp. NAP1
Erythrobacter sp, SD-21
Fulvimarina pelagi HTCC2506
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter hansenii ATCC 23769
Gluconacetobacter sp. SXCC-1
Gluconobacter oxydans 621H
Granulibacter bethesdensis CGDNIH1
alpha proteobacterium sp. HIMB59 : HIMB59b_HIMB59_cons
Hirschia baltica ATCC 49814
Hoeflea phototrophica DFL-43
Hyphomicrobium denitrificans ATCC 51888
Hyphomicrobium sp. MC1
Hyphomonas neptunium ATCC 15444
Jannaschia sp. CCS1
Ketogulonicigenium vulgare Y25
Labrenzia aggregata IAM 12614
Labrenzia alexandrii DFL-11
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter solanacearum CLso-ZC1
Loktanella sp. CCS2
Loktanella vestfoldensis SKA53
Magnetospirillum magneticum AMB-1
Magnetospirillum magnetotacticum MS-1
Maricaulis maris MCS10
Maritimibacter alkaliphilus HTCC2654
Mesorhizobium ciceri bv biserrulae WSM1271
Mesorhizobium loti MAFF303099
Mesorhizobium opportunistum WSM2075
Methylobacterium sp. 4-46
Methylobacterium chloromethanicum CM4
Methylobacterium extorquens AM1
Methylobacterium nodulans ORS 2060
Methylobacterium populi BJ001
Methylobacterium radiotolerans JCM 2831
Methylocella silvestris BL2, DSM 15510
Methylocystis sp. Rockwell, ATCC 49242
Methylosinus trichosporium OB3b
Candidatus Midichloria mitochondrii IricVA
Nautella italica R11
Neorickettsia risticii Illinois
Neorickettsia sennetsu Miyayama
Nisaea sp BAL199
Nitrobacter hamburgensis X14
Nitrobacter sp. Nb-311A
Nitrobacter winogradskyi Nb-255
Novosphingobium aromaticivorans DSM 12444
Novosphingobium nitrogenifigens DSM 19370
Novosphingobium sp. PP1Y
Oceanibulbus indolifex HEL-45
Oceanicaulis alexandrii HTCC2633
Oceanicola batsensis HTCC2597
Oceanicola granulosus HTCC2516
Ochrobactrum anthropi ATCC 49188
Ochrobactrum intermedium LMG 3301
Octadecabacter antarcticus 307
Oligotropha carboxidovorans OM5
Orientia tsutsugamushi Ikeda
Paracoccus denitrificans PD1222
Paracoccus sp. TRP
Parvibaculum lavamentivorans DS-1
Parvularcula bermudensis HTCC2503
Pelagibaca bermudensis HTCC2601
Candidatus Pelagibacter sp HTCC7211 : HTCC7211_HTCC7211
Candidatus Pelagibacter sp. IMCC9063
Candidatus Pelagibacter ubique SAR11 HTCC1002
Phaeobacter gallaeciensis 2.10
Phenylobacterium zucineum HLK1
Pseudovibrio sp. JE062
Candidatus Puniceispirillum marinum IMCC1322
Rhizobium etli Brasil 5
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium sp. NGR234 (ANU265)
Rhizobium rhizogenes K84
Rhodobacter capsulatus SB1003
Rhodobacter sphaeroides WS8N
Rhodobacter sp. SW2
Rhodobacterales sp. HTCC2083
Rhodobacterales sp. HTCC2150
Rhodobacterales sp.HTCC2255
Rhodobacterales sp. Y4I
Rhodocista centenaria SW
Rhodomicrobium vannielii ATCC 17100
Rhodopseudomonas palustris BisB5
Rhodospirillum rubrum S1, ATCC 11170
Rickettsia africae ESF-5
Rickettsia akari Hartford
Rickettsia bellii RML369-C
Rickettsia canadensis McKiel
Rickettsia conorii Malish 7
Rickettsia felis URRWXCal2
Rickettsia heilongjiangensis 054
Rickettsia endosymbiont of Ixodes scapularis
Rickettsia massiliae MTU5
Rickettsia peacockii Rustic
Rickettsia prowazekii Madrid E
Rickettsia rickettsii Sheila Smith
Rickettsia sibirica 246
Rickettsia typhi Wilmington
Roseibium sp. TrichSKD4
Roseobacter sp. AzwK-3b
Roseobacter denitrificans OCh 114
Roseobacter litoralis Och 149
Roseobacter sp. MED193
Roseobacter sp. SK209-2-6
Roseovarius sp. 217
Roseovarius nubinhibens ISM
Roseovarius sp. TM1035
Ruegeria sp. KLH11
Ruegeria pomeroyi DSS-3
Ruegeria sp. TM1040
Sagittula stellata E-37
alpha proteobacterium sp. SAR11 HIMB114 : HIMB114_HIMB114
Alphaproteobacteria sp. SAR11 HIMB5 : HIMB5b_HIMB5_cons
Silicibacter lacuscaerulensis ITI-1157
Silicibacter sp. TrichCH4B
Sinorhizobium meliloti AK83
Sphingobium chlorophenolicum L-1
Sphingobium japonicum UT26S
Sphingomonas sp. S17
Sphingomonas sp. SKA58
Sphingomonas wittichii RW1
Sphingopyxis alaskensis RB2256
Starkeya novella DSM 506
Sulfitobacter sp. EE-36
Sulfitobacter sp. GAI101
Sulfitobacter sp. NAS-14.1
Thalassiobium sp. R2A62
Wolbachia endosymbiont of Culex quinquefasciatus JHB
Wolbachia endosymbiont of Drosophila melanogaster
Wolbachia endosymbiont TRS of Brugia malayi
Wolbachia sp. wRi
Wolbachia sp. wUni (Muscidifurax uniraptor)
Xanthobacter autotrophicus Py2
Zymomonas mobilis subsp. mobilis NCIMB 11163
Wolbachia endosymbiont of Drosophila willistoni TSC#14030-0811.24