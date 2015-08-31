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
	$name=~ s/ /_/g;
	$name=~ s/\W//g;
	$name=~ s/$_//g foreach qw(Candidatus_ sp_ strain_ subsp_ endosymbiont_of_ alpha_proteobacterium Alphaproteobacteria _contig1 _cons);
	$name=~ s/^_+//g;
	$name='blank' if ($name !~ /\w/);
	return lc $name;
}

sub ask_yn {
	my ($default)=@_;
	if ($default==1) {print 'option >Y< / N :'.T;}
	else {print 'option Y / >N< :'.T;}
	my $input=<STDIN>;
	chomp($input);
	if ($input=~ /[QE]/i) {die 'User request to quit'.N;} 
	elsif ($input=~ /[YS]/i) {return 1;} #S as in Si. Not really needed
	elsif ($input=~ /N/i) {return 0;}
	else {return $default;}
}


sub ask_number {
	my ($default,$max)=@_;
	if ($max) {print 'Input number (in digits) upto '.$max.' inclusive (default is '.$default.'):'.T;}
	else {print 'Input number (in digits) (default is '.$default.'):'.T; $max=10^100;} #a googol!
	my $input=<>; chomp($input);
	if ($input=~ /[QE]/i) {die 'User request to quit'.N;} 
	elsif ($input=~ /(\d+)/) {$input=$1; if ($max<$input) {$input=$max;}; return $input;} 
	else {return $default;}
}
####################################################################
###### Main ########################################################
####################################################################



print "Kia ora\n";

open(OUT,'>out_listmaker.txt') or die 'I died making the output file'.N;

print "Sister species will be eliminated from three lists.\n";

my @inlist;
push(@inlist,[sort split(/\n/,$_)]) foreach split(/CUT_HERE/,join("",<DATA>));
close DATA;

#For some reason I thought it funny to give Old English names to variables.
#wight=updated spelling of the Old English word for Creature; hoss=group
#reshape the matrix
my %wighthoss;
foreach my $unit (0..2) {
	foreach my $wight (@{$inlist[$unit]}) {
		#index 0 1 5S, 16S, 23S (true names)
		$wighthoss{name($wight)}[$unit]=$wight;
	}
}

#cluster sister species
my %kinhoss;
foreach my $wight (keys %wighthoss) {
	push(@{$kinhoss{shift @{[split(/_/,$wight)]}}},$wight);
}

foreach my $kin (sort keys %kinhoss) {
	if ($#{$kinhoss{$kin}}==0) {print OUT $kin.T.'Singleton'.T.$kinhoss{$kin}[0].T.$wighthoss{$kinhoss{$kin}[0]}[0].T.$wighthoss{$kinhoss{$kin}[0]}[1].T.$wighthoss{$kinhoss{$kin}[0]}[2].N;}
	else {
		#find complete ones
		##if there are complete one:
		###if one is a type strain add
		###if one is a type species add
		###else pick the first
		
		my @wholeones;
		foreach my $wight (@{$kinhoss{$kin}}) {push(@wholeones, $wight) if (($wighthoss{$wight}[0]) and ($wighthoss{$wight}[1]) and ($wighthoss{$wight}[2]));}
		if ($#wholeones==0) {print OUT $kin.T.'only whole one'.T.$kinhoss{$kin}[0].T.$wighthoss{$kinhoss{$kin}[0]}[0].T.$wighthoss{$kinhoss{$kin}[0]}[1].T.$wighthoss{$kinhoss{$kin}[0]}[2].N;}
		elsif ($#wholeones>0) {
			my $file='LPSN/'.substr($kin,0,1).'/'.uc(substr($kin,0,1)).substr($kin,1).'.html';
			if (!-e $file) {
				print N;
				print "$kin may not be a valid species ($file). Options:\n\t> ";
				print join("\n\t> ",@wholeones).N;
				print "Keep only one?".N;
				
				print N;
				if (ask_yn(1)) {print OUT $kin.T.'invalid genus (one picked)'.T.$wholeones[0].T.$wighthoss{$wholeones[0]}[0].T.$wighthoss{$wholeones[0]}[1].T.$wighthoss{$kinhoss{$kin}[0]}[2].N;}
				else {print OUT $kin.T.'invalid genus (all picked)'.T.$_.T.$wighthoss{$_}[0].T.$wighthoss{$_}[1].T.$wighthoss{$_}[2].N foreach @wholeones;}
			} else {
				
				print N;
				print "LPSN check needed for $kin.\n";
				my $leaf=join(" ",in($file));
				$leaf=~ s/<br>/\n/smg;
				$leaf=~ s/<.*?>//smg;
				print "LPSN says...".join("\nand ",grep(/Type species:/smgi,@{[split(/\n/,$leaf)]})).N;
				
				print "Options:\n";
				print map(N.($_+1).'> '.T.$wholeones[$_],(0..$#wholeones)),N;
				print "number?".N;
				my $choice=ask_number(1,($#wholeones+1))-1;
				print N;print OUT $kin.T.'Valid genus (one picked)'.T.$wholeones[$choice].T.$wighthoss{$wholeones[$choice]}[$choice].T.$wighthoss{$wholeones[$choice]}[1].T.$wighthoss{$kinhoss{$kin}[$choice]}[2].N;
			}
			}
		else {exit "DEATH: empty values issue with $kin\n\a";}
	}
	
}
 








print "\nHaere mai\n";
exit;

__DATA__
Candidatus Pelagibacter sp HTCC7211 : HTCC7211_HTCC7211
alpha proteobacterium sp. SAR11 HIMB114 : HIMB114_HIMB114
Candidatus Pelagibacter ubique SAR11 HTCC9565 : HTCC9565_HTCC9565_contig1
Alphaproteobacteria sp. SAR11 HIMB5 : HIMB5b_HIMB5_cons
alpha proteobacterium sp. HIMB59 : HIMB59b_HIMB59_cons
Nitrobacter sp. Nb-311A
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Aurantimonas manganoxydans SI85-9A1
Aurantimonas manganoxydans SI85-9A1
Aurantimonas manganoxydans SI85-9A1
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Fulvimarina pelagi HTCC2506
Fulvimarina pelagi HTCC2506
Fulvimarina pelagi HTCC2506
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Rhizobium etli CFN 42, DSM 11541
Rhizobium etli CFN 42, DSM 11541
Rhizobium etli CFN 42, DSM 11541
Novosphingobium aromaticivorans DSM 12444
Novosphingobium aromaticivorans DSM 12444
Novosphingobium aromaticivorans DSM 12444
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Bradyrhizobium sp. ORS278
Bradyrhizobium sp. ORS278
Acidiphilium cryptum JF-5
Acidiphilium cryptum JF-5
Bradyrhizobium sp. BTAi1
Bradyrhizobium sp. BTAi1
Orientia tsutsugamushi Boryong
Brucella ovis ATCC 25840
Brucella ovis ATCC 25840
Brucella ovis ATCC 25840
Sphingomonas wittichii RW1
Sphingomonas wittichii RW1
Sagittula stellata E-37
Sagittula stellata E-37
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Rickettsia prowazekii Madrid E
Mesorhizobium loti MAFF303099
Mesorhizobium loti MAFF303099
Caulobacter crescentus CB15
Caulobacter crescentus CB15
Wolbachia endosymbiont of Drosophila melanogaster
Ensifer meliloti 1021
Ensifer meliloti 1021
Ensifer meliloti 1021
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Rickettsia conorii Malish 7
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Brucella melitensis bv 1, 16M
Brucella melitensis bv 1, 16M
Brucella melitensis bv 1, 16M
Ruegeria pomeroyi DSS-3
Ruegeria pomeroyi DSS-3
Ruegeria pomeroyi DSS-3
Brucella suis bv 1,1330
Brucella suis bv 1,1330
Brucella suis bv 1,1330
Bradyrhizobium japonicum USDA 110
Anaplasma marginale St. Maries
Ehrlichia ruminantium Welgevonden, ARC-OVI
Rhodopseudomonas palustris CGA009
Rhodopseudomonas palustris CGA009
Bartonella quintana Toulouse
Bartonella quintana Toulouse
Bartonella henselae Houston-1
Bartonella henselae Houston-1
Bartonella henselae Houston-1
Rickettsia typhi Wilmington
Zymomonas mobilis mobilis ZM4
Zymomonas mobilis mobilis ZM4
Zymomonas mobilis mobilis ZM4
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Ehrlichia ruminantium Gardel
Wolbachia endosymbiont TRS of Brugia malayi
Brucella abortus bv 1, 9-941
Brucella abortus bv 1, 9-941
Brucella abortus bv 1, 9-941
Rickettsia felis URRWXCal2
Candidatus Pelagibacter ubique SAR11 HTCC1062
Ehrlichia canis Jake
Nitrobacter winogradskyi Nb-255
Rhodobacter sphaeroides 2.4.1
Rhodobacter sphaeroides 2.4.1
Brucella melitensis bv. 1 Abortus 2308
Brucella melitensis bv. 1 Abortus 2308
Brucella melitensis bv. 1 Abortus 2308
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodopseudomonas palustris HaA2
Anaplasma phagocytophilum HZ
Neorickettsia sennetsu Miyayama
Ehrlichia chaffeensis Arkansas
Jannaschia sp. CCS1
Rhodopseudomonas palustris BisB18
Rhodopseudomonas palustris BisB18
Rickettsia bellii RML369-C
Rhodopseudomonas palustris BisB5
Rhodopseudomonas palustris BisB5
Nitrobacter hamburgensis X14
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Sphingopyxis alaskensis RB2256
Roseobacter denitrificans OCh 114
Chelativorans sp. BNC1
Granulibacter bethesdensis CGDNIH1
Granulibacter bethesdensis CGDNIH1
Granulibacter bethesdensis CGDNIH1
Maricaulis maris MCS10
Maricaulis maris MCS10
Hyphomonas neptunium ATCC 15444
Rhizobium leguminosarum bv. viciae 3841
Rhizobium leguminosarum bv. viciae 3841
Rhizobium leguminosarum bv. viciae 3841
Rhodopseudomonas palustris BisA53
Rhodopseudomonas palustris BisA53
Paracoccus denitrificans PD1222
Paracoccus denitrificans PD1222
Paracoccus denitrificans PD1222
Bartonella bacilliformis KC583
Bartonella bacilliformis KC583
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Ensifer medicae WSM419
Ensifer medicae WSM419
Ensifer medicae WSM419
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Parvibaculum lavamentivorans DS-1
Xanthobacter autotrophicus Py2
Xanthobacter autotrophicus Py2
Rickettsia canadensis McKiel
Rickettsia akari Hartford
Rickettsia rickettsii Sheila Smith
Rickettsia bellii OSU 85-389
Erythrobacter sp, SD-21
Rickettsia massiliae MTU5
Azorhizobium caulinodans ORS 571
Azorhizobium caulinodans ORS 571
Azorhizobium caulinodans ORS 571
Dinoroseobacter shibae DFL-12, DSM 16493
Dinoroseobacter shibae DFL-12, DSM 16493
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Bartonella tribocorum CIP 105476
Bartonella tribocorum CIP 105476
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Nisaea sp BAL199
Nisaea sp BAL199
Hoeflea phototrophica DFL-43
Hoeflea phototrophica DFL-43
Rickettsia rickettsii Iowa
Caulobacter sp. K31
Caulobacter sp. K31
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Beijerinckia indica indica ATCC 9039
Beijerinckia indica indica ATCC 9039
Beijerinckia indica indica ATCC 9039
Erythrobacter litoralis HTCC2594
Magnetospirillum magneticum AMB-1
Magnetospirillum magneticum AMB-1
Oceanicola batsensis HTCC2597
Oceanicola granulosus HTCC2516
Oceanicola granulosus HTCC2516
Rickettsia sibirica 246
Roseovarius nubinhibens ISM
Roseovarius nubinhibens ISM
Roseovarius sp. 217
Roseovarius sp. 217
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Wolbachia endosymbiont of Drosophila ananassae
Wolbachia endosymbiont of Drosophila willistoni TSC#14030-0811.24
Candidatus Pelagibacter ubique SAR11 HTCC1002
Erythrobacter sp. NAP1
Loktanella vestfoldensis SKA53
Loktanella vestfoldensis SKA53
Magnetospirillum magnetotacticum MS-1
Magnetospirillum magnetotacticum MS-1
Magnetospirillum magnetotacticum MS-1
Oceanicaulis alexandrii HTCC2633
Oceanicaulis alexandrii HTCC2633
Labrenzia aggregata IAM 12614
Labrenzia aggregata IAM 12614
Labrenzia aggregata IAM 12614
Rhodobacter sphaeroides 2.4.1
Rhodobacterales sp. HTCC2150
Rhodobacterales sp. HTCC2150
Loktanella sp. CCS2
Roseobacter sp. AzwK-3b
Roseobacter sp. AzwK-3b
Erythrobacter sp, SD-21
Roseovarius sp. TM1035
Roseovarius sp. TM1035
Oceanibulbus indolifex HEL-45
Oceanibulbus indolifex HEL-45
Oceanibulbus indolifex HEL-45
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Brucella abortus S19
Brucella abortus S19
Brucella abortus S19
Orientia tsutsugamushi Ikeda
Wolbachia endosymbiont of Culex quinquefasciatus Pel
Rhizobium etli CIAT 652
Rhizobium etli CIAT 652
Rhizobium etli CIAT 652
Rhodopseudomonas palustris TIE-1
Rhodopseudomonas palustris TIE-1
Phenylobacterium zucineum HLK1
Rhizobium etli Kim 5
Rhizobium etli Kim 5
Rhizobium etli Brasil 5
Rhizobium etli Brasil 5
Rhizobium etli Brasil 5
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli GR56
Rhizobium etli GR56
Rhizobium etli GR56
Rhizobium etli IE4771
Rhizobium etli IE4771
Rhizobium etli CIAT 894
Wolbachia endosymbiont of Culex quinquefasciatus JHB
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Rhizobium leguminosarum bv. trifolii WSM2304
Rhizobium leguminosarum bv. trifolii WSM2304
Rhizobium leguminosarum bv. trifolii WSM2304
Rhodocista centenaria SW
Rhodocista centenaria SW
Rhodocista centenaria SW
Methylocella silvestris BL2, DSM 15510
Methylocella silvestris BL2, DSM 15510
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Caulobacter crescentus NA1000
Caulobacter crescentus NA1000
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhizobium rhizogenes K84
Rhizobium rhizogenes K84
Rhizobium rhizogenes K84
Agrobacterium vitis S4
Agrobacterium vitis S4
Agrobacterium vitis S4
Agrobacterium vitis S4
Anaplasma marginale Florida
Wolbachia sp. wRi
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Rhizobium sp. NGR234 (ANU265)
Rhizobium sp. NGR234 (ANU265)
Rhizobium sp. NGR234 (ANU265)
Brucella ceti Cudo
Brucella ceti Cudo
Brucella ceti Cudo
Rickettsia africae ESF-5
Rickettsia peacockii Rustic
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Bartonella grahamii as4aup
Bartonella grahamii as4aup
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium leguminosarum bv. trifolii WSM1325
Hirschia baltica ATCC 49814
Hirschia baltica ATCC 49814
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter asiaticus psy62
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Neorickettsia risticii Illinois
Brucella microti CCM 4915
Brucella microti CCM 4915
Brucella microti CCM 4915
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Anaplasma marginale Mississippi
Anaplasma marginale Puerto Rico
Anaplasma marginale Virginia
Brucella abortus bv 6, 870
Brucella abortus bv 4, 292
Brucella abortus bv 3, Tulya
Brucella abortus bv 2, 86/8/59
Brucella suis bv 5, 513
Brucella suis bv 3, 686
Brucella pinnipedialis M163/99/10
Brucella pinnipedialis B2/94
Brucella ceti M644/93/1
Brucella ceti M13/05/1
Brucella sp. 83/13
Brucella pinnipedialis M292/94/1
Brucella melitensis bv 1, Rev.1
Brucella neotomae 5K33, ATCC 23459
Brucella melitensis bv 3, Ether
Brucella ceti M490/95/1
Brucella ceti B1/94
Brucella abortus bv 9, C68
Brucella melitensis bv 2, 63/9
Brucella abortus 2308 A
Brucella abortus 2308 A
Brucella abortus 2308 A
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Zymomonas mobilis mobilis T.H.Delft 1, ATCC 10988
Brucella sp. F5/99
Zymomonas mobilis subsp. mobilis NCIMB 11163
Zymomonas mobilis subsp. mobilis NCIMB 11163
Zymomonas mobilis subsp. mobilis NCIMB 11163
Anaplasma centrale str. Israel
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Sphingobium japonicum UT26S
Candidatus Puniceispirillum marinum IMCC1322
Sphingobium japonicum UT26S
Sphingobium japonicum UT26S
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Caulobacter segnis ATCC 21756
Caulobacter segnis ATCC 21756
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Rickettsia prowazekii Rp22
Citromicrobium bathyomarinum JL354
Methylosinus trichosporium OB3b
Rickettsia endosymbiont of Ixodes scapularis
Thalassiobium sp. R2A62
Thalassiobium sp. R2A62
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter lacuscaerulensis ITI-1157
Silicibacter lacuscaerulensis ITI-1157
Silicibacter lacuscaerulensis ITI-1157
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Rhodobacter sp. SW2
Mesorhizobium opportunistum WSM2075
Brevundimonas sp. BAL3
Brevundimonas sp. BAL3
Octadecabacter antarcticus 307
Octadecabacter antarcticus 307
Octadecabacter antarcticus 238
Octadecabacter antarcticus 238
Rhodobacterales sp. HTCC2083
Rhodobacterales sp. HTCC2083
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Nautella italica R11
Nautella italica R11
Nautella italica R11
Nautella italica R11
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Ruegeria sp. KLH11
Ruegeria sp. KLH11
Ruegeria sp. KLH11
Labrenzia alexandrii DFL-11
Labrenzia alexandrii DFL-11
Labrenzia alexandrii DFL-11
Brucella abortus NCTC 8038
Brucella melitensis bv. 1, 16M
Brucella suis bv 4, 40
Brucella sp. NVSL 07-0026
Brucella abortus bv 5, B3196
Starkeya novella DSM 506
Hyphomicrobium denitrificans ATCC 51888
Brevundimonas subvibrioides ATCC 15264
Brevundimonas subvibrioides ATCC 15264
Parvularcula bermudensis HTCC2503
Brucella sp. BO1
Brucella sp. BO2
Brucella sp. NF 2653
Afipia sp. 1NLS2
Ensifer meliloti BL225C
Ensifer meliloti BL225C
Ensifer meliloti BL225C
Sphingobium chlorophenolicum L-1
Sphingobium chlorophenolicum L-1
Sphingobium chlorophenolicum L-1
Ahrensia sp. R2A130
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Rhodomicrobium vannielii ATCC 17100
Rhodomicrobium vannielii ATCC 17100
Candidatus Liberibacter solanacearum CLso-ZC1
Candidatus Liberibacter solanacearum CLso-ZC1
Candidatus Liberibacter solanacearum CLso-ZC1
Asticcacaulis excentricus CB 48
Asticcacaulis excentricus CB 48
Asticcacaulis excentricus CB 48
Rhodopseudomonas palustris DX-1
Rhodopseudomonas palustris DX-1
Mesorhizobium ciceri bv biserrulae WSM1271
Mesorhizobium ciceri bv biserrulae WSM1271
Bartonella clarridgeiae 73
Bartonella clarridgeiae 73
Maritimibacter alkaliphilus HTCC2654
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Methylocystis sp. Rockwell, ATCC 49242
Methylocystis sp. Rockwell, ATCC 49242
Methylocystis sp. Rockwell, ATCC 49242
Oligotropha carboxidovorans OM5
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Acidiphilium multivorum AIU301
Acidiphilium multivorum AIU301
Candidatus Pelagibacter sp. IMCC9063
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Novosphingobium sp. PP1Y
Novosphingobium sp. PP1Y
Novosphingobium sp. PP1Y
Sinorhizobium meliloti AK83
Sinorhizobium meliloti AK83
Sinorhizobium meliloti AK83
Oligotropha carboxidovorans OM5
Zymomonas mobilis subsp. pomaceae ATCC 29192
Zymomonas mobilis subsp. pomaceae ATCC 29192
Zymomonas mobilis subsp. pomaceae ATCC 29192
Hyphomicrobium sp. MC1
Candidatus Midichloria mitochondrii IricVA
Roseobacter litoralis Och 149
Rickettsia heilongjiangensis 054
Sinorhizobium meliloti SM11
Sinorhizobium meliloti SM11
Sinorhizobium meliloti SM11
Brucella melitensis M5-90
Brucella melitensis M5-90
Brucella melitensis M5-90
Brucella melitensis M28
Brucella melitensis M28
Brucella melitensis M28
Oligotropha carboxidovorans OM4
Asticcacaulis biprosthecum C19
Brevundimonas diminuta ATCC 11568
Agrobacterium sp. ATCC 31749
Paracoccus sp. TRP
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Rhodobacter sphaeroides WS8N
Rhodobacter sphaeroides WS8N
Rhodobacter sphaeroides WS8N
Sphingomonas sp. S17
Bradyrhizobiaceae bacterium SG-6C
Acidiphilium sp. PM
Novosphingobium nitrogenifigens DSM 19370
Acetobacter pomorum DM001
Acetobacter tropicalis NBRC 101654
CUT_HERE
Candidatus Pelagibacter sp HTCC7211 : HTCC7211_HTCC7211
alpha proteobacterium sp. SAR11 HIMB114 : HIMB114_HIMB114
Candidatus Pelagibacter ubique SAR11 HTCC9565 : HTCC9565_HTCC9565_contig1
Alphaproteobacteria sp. SAR11 HIMB5 : HIMB5b_HIMB5_cons
alpha proteobacterium sp. HIMB59 : HIMB59b_HIMB59_cons
Ehrlichia chaffeensis Sapulpa
Sulfitobacter sp. EE-36
Sulfitobacter sp. NAS-14.1
Oceanicaulis alexandrii HTCC2633
Oceanicaulis alexandrii HTCC2633
Loktanella vestfoldensis SKA53
Roseovarius sp. 217
Erythrobacter sp. NAP1
Nitrobacter sp. Nb-311A
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Oceanicola granulosus HTCC2516
Oceanicola granulosus HTCC2516
Aurantimonas manganoxydans SI85-9A1
Aurantimonas manganoxydans SI85-9A1
Aurantimonas manganoxydans SI85-9A1
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Labrenzia aggregata IAM 12614
Rhizobium etli CFN 42, DSM 11541
Rhizobium etli CFN 42, DSM 11541
Rhizobium etli CFN 42, DSM 11541
Novosphingobium aromaticivorans DSM 12444
Novosphingobium aromaticivorans DSM 12444
Novosphingobium aromaticivorans DSM 12444
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Bradyrhizobium sp. ORS278
Bradyrhizobium sp. ORS278
Acidiphilium cryptum JF-5
Acidiphilium cryptum JF-5
Bradyrhizobium sp. BTAi1
Bradyrhizobium sp. BTAi1
Orientia tsutsugamushi Boryong
Brucella ovis ATCC 25840
Brucella ovis ATCC 25840
Brucella ovis ATCC 25840
Sphingomonas wittichii RW1
Sphingomonas wittichii RW1
Roseobacter sp. SK209-2-6
Rickettsia prowazekii Madrid E
Mesorhizobium loti MAFF303099
Mesorhizobium loti MAFF303099
Caulobacter crescentus CB15
Caulobacter crescentus CB15
Wolbachia endosymbiont of Drosophila melanogaster
Ensifer meliloti 1021
Ensifer meliloti 1021
Ensifer meliloti 1021
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Rickettsia conorii Malish 7
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Brucella melitensis bv 1, 16M
Brucella melitensis bv 1, 16M
Brucella melitensis bv 1, 16M
Ruegeria pomeroyi DSS-3
Ruegeria pomeroyi DSS-3
Ruegeria pomeroyi DSS-3
Brucella suis bv 1,1330
Brucella suis bv 1,1330
Brucella suis bv 1,1330
Bradyrhizobium japonicum USDA 110
Anaplasma marginale St. Maries
Rhodopseudomonas palustris CGA009
Rhodopseudomonas palustris CGA009
Bartonella quintana Toulouse
Bartonella quintana Toulouse
Bartonella henselae Houston-1
Bartonella henselae Houston-1
Rickettsia typhi Wilmington
Zymomonas mobilis mobilis ZM4
Zymomonas mobilis mobilis ZM4
Zymomonas mobilis mobilis ZM4
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Ehrlichia ruminantium Gardel
Ehrlichia ruminantium Welgevonden, CIRAD
Wolbachia endosymbiont TRS of Brugia malayi
Brucella abortus bv 1, 9-941
Brucella abortus bv 1, 9-941
Brucella abortus bv 1, 9-941
Rickettsia felis URRWXCal2
Candidatus Pelagibacter ubique SAR11 HTCC1062
Ehrlichia canis Jake
Nitrobacter winogradskyi Nb-255
Rhodobacter sphaeroides 2.4.1
Rhodobacter sphaeroides 2.4.1
Rhodobacter sphaeroides 2.4.1
Brucella melitensis bv. 1 Abortus 2308
Brucella melitensis bv. 1 Abortus 2308
Brucella melitensis bv. 1 Abortus 2308
Magnetospirillum magneticum AMB-1
Magnetospirillum magneticum AMB-1
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Erythrobacter litoralis HTCC2594
Rhodopseudomonas palustris HaA2
Anaplasma phagocytophilum HZ
Neorickettsia sennetsu Miyayama
Ehrlichia chaffeensis Arkansas
Jannaschia sp. CCS1
Rhodopseudomonas palustris BisB18
Rhodopseudomonas palustris BisB18
Rickettsia bellii RML369-C
Rhodopseudomonas palustris BisB5
Rhodopseudomonas palustris BisB5
Nitrobacter hamburgensis X14
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Sphingopyxis alaskensis RB2256
Roseobacter denitrificans OCh 114
Chelativorans sp. BNC1
Chelativorans sp. BNC1
Granulibacter bethesdensis CGDNIH1
Granulibacter bethesdensis CGDNIH1
Granulibacter bethesdensis CGDNIH1
Maricaulis maris MCS10
Maricaulis maris MCS10
Hyphomonas neptunium ATCC 15444
Rhizobium leguminosarum bv. viciae 3841
Rhizobium leguminosarum bv. viciae 3841
Rhizobium leguminosarum bv. viciae 3841
Rhodopseudomonas palustris BisA53
Rhodopseudomonas palustris BisA53
Paracoccus denitrificans PD1222
Paracoccus denitrificans PD1222
Paracoccus denitrificans PD1222
Bartonella bacilliformis KC583
Bartonella bacilliformis KC583
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Ensifer medicae WSM419
Ensifer medicae WSM419
Ensifer medicae WSM419
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Parvibaculum lavamentivorans DS-1
Xanthobacter autotrophicus Py2
Xanthobacter autotrophicus Py2
Rickettsia canadensis McKiel
Rickettsia akari Hartford
Rickettsia rickettsii Sheila Smith
Rickettsia bellii OSU 85-389
Erythrobacter sp, SD-21
Erythrobacter sp, SD-21
Roseovarius sp. TM1035
Rickettsia massiliae MTU5
Azorhizobium caulinodans ORS 571
Azorhizobium caulinodans ORS 571
Azorhizobium caulinodans ORS 571
Dinoroseobacter shibae DFL-12, DSM 16493
Dinoroseobacter shibae DFL-12, DSM 16493
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Bartonella tribocorum CIP 105476
Bartonella tribocorum CIP 105476
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Nisaea sp BAL199
Nisaea sp BAL199
Hoeflea phototrophica DFL-43
Rickettsia rickettsii Iowa
Caulobacter sp. K31
Caulobacter sp. K31
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Beijerinckia indica indica ATCC 9039
Beijerinckia indica indica ATCC 9039
Beijerinckia indica indica ATCC 9039
Oceanicola batsensis HTCC2597
Rickettsia sibirica 246
Roseovarius nubinhibens ISM
Roseovarius nubinhibens ISM
Wolbachia endosymbiont of Drosophila ananassae
Wolbachia endosymbiont of Drosophila simulans
Wolbachia endosymbiont of Drosophila willistoni TSC#14030-0811.24
Candidatus Pelagibacter ubique SAR11 HTCC1002
Magnetospirillum magnetotacticum MS-1
Magnetospirillum magnetotacticum MS-1
Magnetospirillum magnetotacticum MS-1
Fulvimarina pelagi HTCC2506
Fulvimarina pelagi HTCC2506
Fulvimarina pelagi HTCC2506
Rhodobacterales sp. HTCC2150
Rhodobacterales sp. HTCC2150
Sagittula stellata E-37
Sagittula stellata E-37
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Loktanella sp. CCS2
Roseobacter sp. AzwK-3b
Roseobacter sp. AzwK-3b
Roseovarius sp. TM1035
Roseovarius sp. TM1035
Oceanibulbus indolifex HEL-45
Oceanibulbus indolifex HEL-45
Oceanibulbus indolifex HEL-45
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Hoeflea phototrophica DFL-43
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Brucella abortus S19
Brucella abortus S19
Brucella abortus S19
Orientia tsutsugamushi Ikeda
Wolbachia endosymbiont of Culex quinquefasciatus Pel
Rhizobium etli CIAT 652
Rhizobium etli CIAT 652
Rhizobium etli CIAT 652
Rhodopseudomonas palustris TIE-1
Rhodopseudomonas palustris TIE-1
Phenylobacterium zucineum HLK1
Oceanicola granulosus HTCC2516
Oceanicola granulosus HTCC2516
Roseobacter sp. MED193
Roseovarius sp. 217
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Loktanella vestfoldensis SKA53
Rhodobacterales sp.HTCC2255
Labrenzia aggregata IAM 12614
Labrenzia aggregata IAM 12614
Labrenzia aggregata IAM 12614
Rhizobium etli Kim 5
Rhizobium etli Brasil 5
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli GR56
Rhizobium etli GR56
Rhizobium etli GR56
Rhizobium etli IE4771
Rhizobium etli IE4771
Rhizobium etli IE4771
Rhizobium etli CIAT 894
Wolbachia endosymbiont of Culex quinquefasciatus JHB
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Rhizobium leguminosarum bv. trifolii WSM2304
Rhizobium leguminosarum bv. trifolii WSM2304
Rhizobium leguminosarum bv. trifolii WSM2304
Rhodocista centenaria SW
Rhodocista centenaria SW
Rhodocista centenaria SW
Rhodocista centenaria SW
Methylocella silvestris BL2, DSM 15510
Methylocella silvestris BL2, DSM 15510
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Caulobacter crescentus NA1000
Caulobacter crescentus NA1000
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhizobium rhizogenes K84
Rhizobium rhizogenes K84
Rhizobium rhizogenes K84
Agrobacterium vitis S4
Agrobacterium vitis S4
Agrobacterium vitis S4
Agrobacterium vitis S4
Anaplasma marginale Florida
Wolbachia sp. wRi
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Rhizobium sp. NGR234 (ANU265)
Rhizobium sp. NGR234 (ANU265)
Rhizobium sp. NGR234 (ANU265)
Brucella ceti Cudo
Brucella ceti Cudo
Brucella ceti Cudo
Rickettsia africae ESF-5
Rickettsia peacockii Rustic
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Bartonella grahamii as4aup
Bartonella grahamii as4aup
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium leguminosarum bv. trifolii WSM1325
Hirschia baltica ATCC 49814
Hirschia baltica ATCC 49814
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter asiaticus psy62
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Neorickettsia risticii Illinois
Brucella microti CCM 4915
Brucella microti CCM 4915
Brucella microti CCM 4915
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Anaplasma marginale Mississippi
Anaplasma marginale Puerto Rico
Anaplasma marginale Virginia
Brucella abortus bv 6, 870
Brucella abortus bv 4, 292
Brucella abortus bv 3, Tulya
Brucella abortus bv 2, 86/8/59
Brucella suis bv 5, 513
Brucella suis bv 3, 686
Brucella suis bv 3, 686
Brucella pinnipedialis M163/99/10
Brucella pinnipedialis M163/99/10
Brucella pinnipedialis B2/94
Brucella pinnipedialis B2/94
Brucella ceti M644/93/1
Brucella ceti M644/93/1
Brucella ceti M13/05/1
Brucella ceti M13/05/1
Brucella sp. 83/13
Brucella pinnipedialis M292/94/1
Brucella pinnipedialis M292/94/1
Brucella melitensis bv 1, Rev.1
Brucella neotomae 5K33, ATCC 23459
Brucella melitensis bv 3, Ether
Brucella ceti M490/95/1
Brucella ceti M490/95/1
Brucella ceti B1/94
Brucella ceti B1/94
Brucella abortus bv 9, C68
Brucella melitensis bv 2, 63/9
Brucella abortus 2308 A
Brucella abortus 2308 A
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Zymomonas mobilis mobilis T.H.Delft 1, ATCC 10988
Brucella sp. F5/99
Brucella sp. F5/99
Zymomonas mobilis subsp. mobilis NCIMB 11163
Zymomonas mobilis subsp. mobilis NCIMB 11163
Zymomonas mobilis subsp. mobilis NCIMB 11163
Anaplasma centrale str. Israel
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Sphingobium japonicum UT26S
Candidatus Puniceispirillum marinum IMCC1322
Sphingobium japonicum UT26S
Sphingobium japonicum UT26S
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Caulobacter segnis ATCC 21756
Caulobacter segnis ATCC 21756
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Rickettsia prowazekii Rp22
Rhodobacter sp. SW2
Mesorhizobium opportunistum WSM2075
Methylosinus trichosporium OB3b
Rickettsia endosymbiont of Ixodes scapularis
Wolbachia sp. wUni (Muscidifurax uniraptor)
Wolbachia sp. wUni (Muscidifurax uniraptor)
Citromicrobium bathyomarinum JL354
Gluconacetobacter hansenii ATCC 23769
Octadecabacter antarcticus 307
Octadecabacter antarcticus 307
Octadecabacter antarcticus 238
Octadecabacter antarcticus 238
Rhodobacterales sp. HTCC2083
Rhodobacterales sp. HTCC2083
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Nautella italica R11
Nautella italica R11
Nautella italica R11
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Ruegeria sp. KLH11
Ruegeria sp. KLH11
Labrenzia alexandrii DFL-11
Labrenzia alexandrii DFL-11
Labrenzia alexandrii DFL-11
Thalassiobium sp. R2A62
Thalassiobium sp. R2A62
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Brucella abortus NCTC 8038
Brucella melitensis bv. 1, 16M
Brucella suis bv 4, 40
Brucella suis bv 4, 40
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Brucella sp. NVSL 07-0026
Brucella abortus bv 5, B3196
Starkeya novella DSM 506
Hyphomicrobium denitrificans ATCC 51888
Brevundimonas subvibrioides ATCC 15264
Brevundimonas subvibrioides ATCC 15264
Parvularcula bermudensis HTCC2503
Pelagibaca bermudensis HTCC2601
Brucella sp. BO1
Brucella sp. BO2
Brucella sp. NF 2653
Afipia sp. 1NLS2
Ensifer meliloti BL225C
Sphingobium chlorophenolicum L-1
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Rhodomicrobium vannielii ATCC 17100
Rhodomicrobium vannielii ATCC 17100
Candidatus Liberibacter solanacearum CLso-ZC1
Candidatus Liberibacter solanacearum CLso-ZC1
Candidatus Liberibacter solanacearum CLso-ZC1
Asticcacaulis excentricus CB 48
Asticcacaulis excentricus CB 48
Asticcacaulis excentricus CB 48
Rhodopseudomonas palustris DX-1
Rhodopseudomonas palustris DX-1
Mesorhizobium ciceri bv biserrulae WSM1271
Mesorhizobium ciceri bv biserrulae WSM1271
Bartonella clarridgeiae 73
Bartonella clarridgeiae 73
Methylocystis sp. Rockwell, ATCC 49242
Maritimibacter alkaliphilus HTCC2654
Brevundimonas sp. BAL3
Brevundimonas sp. BAL3
Silicibacter lacuscaerulensis ITI-1157
Silicibacter lacuscaerulensis ITI-1157
Silicibacter lacuscaerulensis ITI-1157
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Ahrensia sp. R2A130
Oligotropha carboxidovorans OM5
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Acidiphilium multivorum AIU301
Acidiphilium multivorum AIU301
Candidatus Pelagibacter sp. IMCC9063
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Novosphingobium sp. PP1Y
Novosphingobium sp. PP1Y
Novosphingobium sp. PP1Y
Sinorhizobium meliloti AK83
Sinorhizobium meliloti AK83
Sinorhizobium meliloti AK83
Oligotropha carboxidovorans OM5
Zymomonas mobilis subsp. pomaceae ATCC 29192
Zymomonas mobilis subsp. pomaceae ATCC 29192
Zymomonas mobilis subsp. pomaceae ATCC 29192
Hyphomicrobium sp. MC1
Candidatus Midichloria mitochondrii IricVA
Roseobacter litoralis Och 149
Rickettsia heilongjiangensis 054
Sinorhizobium meliloti SM11
Sinorhizobium meliloti SM11
Sinorhizobium meliloti SM11
Brucella melitensis M5-90
Brucella melitensis M5-90
Brucella melitensis M5-90
Brucella melitensis M28
Brucella melitensis M28
Brucella melitensis M28
Oligotropha carboxidovorans OM4
Asticcacaulis biprosthecum C19
Brevundimonas diminuta ATCC 11568
Agrobacterium sp. ATCC 31749
Paracoccus sp. TRP
Paracoccus sp. TRP
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Rhodobacter sphaeroides WS8N
Rhodobacter sphaeroides WS8N
Rhodobacter sphaeroides WS8N
Sphingomonas sp. S17
Bradyrhizobiaceae bacterium SG-6C
Acidiphilium sp. PM
Novosphingobium nitrogenifigens DSM 19370
Acetobacter pomorum DM001
Acetobacter tropicalis NBRC 101654
CUT_HERE
Candidatus Pelagibacter sp HTCC7211 : HTCC7211_HTCC7211
alpha proteobacterium sp. SAR11 HIMB114 : HIMB114_HIMB114
Candidatus Pelagibacter ubique SAR11 HTCC9565 : HTCC9565_HTCC9565_contig1
Alphaproteobacteria sp. SAR11 HIMB5 : HIMB5b_HIMB5_cons
alpha proteobacterium sp. HIMB59 : HIMB59b_HIMB59_cons
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. EE-36
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Sulfitobacter sp. NAS-14.1
Oceanicaulis alexandrii HTCC2633
Roseovarius sp. 217
Roseovarius sp. 217
Nitrobacter sp. Nb-311A
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Roseobacter sp. MED193
Oceanicola granulosus HTCC2516
Oceanicola granulosus HTCC2516
Aurantimonas manganoxydans SI85-9A1
Aurantimonas manganoxydans SI85-9A1
Aurantimonas manganoxydans SI85-9A1
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Sphingomonas sp. SKA58
Fulvimarina pelagi HTCC2506
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Rhodobacterales sp.HTCC2255
Labrenzia aggregata IAM 12614
Rhizobium etli CFN 42, DSM 11541
Rhizobium etli CFN 42, DSM 11541
Rhizobium etli CFN 42, DSM 11541
Novosphingobium aromaticivorans DSM 12444
Novosphingobium aromaticivorans DSM 12444
Novosphingobium aromaticivorans DSM 12444
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Rhodobacter sphaeroides ATCC 17025
Bradyrhizobium sp. ORS278
Bradyrhizobium sp. ORS278
Acidiphilium cryptum JF-5
Acidiphilium cryptum JF-5
Bradyrhizobium sp. BTAi1
Bradyrhizobium sp. BTAi1
Orientia tsutsugamushi Boryong
Brucella ovis ATCC 25840
Brucella ovis ATCC 25840
Brucella ovis ATCC 25840
Sphingomonas wittichii RW1
Sphingomonas wittichii RW1
Rickettsia prowazekii Madrid E
Mesorhizobium loti MAFF303099
Mesorhizobium loti MAFF303099
Caulobacter crescentus CB15
Caulobacter crescentus CB15
Wolbachia endosymbiont of Drosophila melanogaster
Ensifer meliloti 1021
Ensifer meliloti 1021
Ensifer meliloti 1021
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Agrobacterium tumefaciens C58-Cereon
Rickettsia conorii Malish 7
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Agrobacterium tumefaciens C58-UWash
Brucella melitensis bv 1, 16M
Brucella melitensis bv 1, 16M
Brucella melitensis bv 1, 16M
Ruegeria pomeroyi DSS-3
Ruegeria pomeroyi DSS-3
Ruegeria pomeroyi DSS-3
Brucella suis bv 1,1330
Brucella suis bv 1,1330
Brucella suis bv 1,1330
Bradyrhizobium japonicum USDA 110
Anaplasma marginale St. Maries
Rhodopseudomonas palustris CGA009
Rhodopseudomonas palustris CGA009
Bartonella quintana Toulouse
Bartonella quintana Toulouse
Bartonella henselae Houston-1
Bartonella henselae Houston-1
Rickettsia typhi Wilmington
Zymomonas mobilis mobilis ZM4
Zymomonas mobilis mobilis ZM4
Zymomonas mobilis mobilis ZM4
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Gluconobacter oxydans 621H
Ehrlichia ruminantium Gardel
Wolbachia endosymbiont TRS of Brugia malayi
Brucella abortus bv 1, 9-941
Brucella abortus bv 1, 9-941
Brucella abortus bv 1, 9-941
Rickettsia felis URRWXCal2
Candidatus Pelagibacter ubique SAR11 HTCC1062
Ehrlichia canis Jake
Nitrobacter winogradskyi Nb-255
Rhodobacter sphaeroides 2.4.1
Rhodobacter sphaeroides 2.4.1
Rhodobacter sphaeroides 2.4.1
Brucella melitensis bv. 1 Abortus 2308
Brucella melitensis bv. 1 Abortus 2308
Brucella melitensis bv. 1 Abortus 2308
Magnetospirillum magneticum AMB-1
Magnetospirillum magneticum AMB-1
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodospirillum rubrum S1, ATCC 11170
Rhodopseudomonas palustris HaA2
Anaplasma phagocytophilum HZ
Neorickettsia sennetsu Miyayama
Ehrlichia chaffeensis Arkansas
Jannaschia sp. CCS1
Rhodopseudomonas palustris BisB18
Rhodopseudomonas palustris BisB18
Rickettsia bellii RML369-C
Rhodopseudomonas palustris BisB5
Rhodopseudomonas palustris BisB5
Nitrobacter hamburgensis X14
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Ruegeria sp. TM1040
Sphingopyxis alaskensis RB2256
Roseobacter denitrificans OCh 114
Chelativorans sp. BNC1
Chelativorans sp. BNC1
Chelativorans sp. BNC1
Granulibacter bethesdensis CGDNIH1
Granulibacter bethesdensis CGDNIH1
Granulibacter bethesdensis CGDNIH1
Maricaulis maris MCS10
Maricaulis maris MCS10
Hyphomonas neptunium ATCC 15444
Rhizobium leguminosarum bv. viciae 3841
Rhizobium leguminosarum bv. viciae 3841
Rhizobium leguminosarum bv. viciae 3841
Rhodopseudomonas palustris BisA53
Rhodopseudomonas palustris BisA53
Paracoccus denitrificans PD1222
Paracoccus denitrificans PD1222
Paracoccus denitrificans PD1222
Bartonella bacilliformis KC583
Bartonella bacilliformis KC583
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Rhodobacter sphaeroides ATCC 17029
Ensifer medicae WSM419
Ensifer medicae WSM419
Ensifer medicae WSM419
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Ochrobactrum anthropi ATCC 49188
Parvibaculum lavamentivorans DS-1
Xanthobacter autotrophicus Py2
Xanthobacter autotrophicus Py2
Roseovarius sp. TM1035
Roseovarius sp. TM1035
Rickettsia massiliae MTU5
Azorhizobium caulinodans ORS 571
Azorhizobium caulinodans ORS 571
Azorhizobium caulinodans ORS 571
Dinoroseobacter shibae DFL-12, DSM 16493
Dinoroseobacter shibae DFL-12, DSM 16493
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Brucella canis ATCC 23365
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Bartonella tribocorum CIP 105476
Bartonella tribocorum CIP 105476
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Brucella suis ATCC 23445
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Methylobacterium extorquens PA1
Nisaea sp BAL199
Rickettsia rickettsii Iowa
Caulobacter sp. K31
Caulobacter sp. K31
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium radiotolerans JCM 2831
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Methylobacterium sp. 4-46
Beijerinckia indica indica ATCC 9039
Beijerinckia indica indica ATCC 9039
Beijerinckia indica indica ATCC 9039
Erythrobacter litoralis HTCC2594
Bartonella henselae Houston-1
Bartonella quintana Toulouse
Oceanicola batsensis HTCC2597
Oceanicola batsensis HTCC2597
Rickettsia sibirica 246
Roseovarius nubinhibens ISM
Roseovarius nubinhibens ISM
Wolbachia endosymbiont of Drosophila ananassae
Wolbachia endosymbiont of Drosophila simulans
Wolbachia endosymbiont of Drosophila simulans
Wolbachia endosymbiont of Drosophila willistoni TSC#14030-0811.24
Wolbachia endosymbiont of Drosophila willistoni TSC#14030-0811.24
Candidatus Pelagibacter ubique SAR11 HTCC1002
Ehrlichia chaffeensis Sapulpa
Erythrobacter sp. NAP1
Loktanella vestfoldensis SKA53
Magnetospirillum magnetotacticum MS-1
Magnetospirillum magnetotacticum MS-1
Rhodobacterales sp. HTCC2150
Rhodobacterales sp. HTCC2150
Sagittula stellata E-37
Sagittula stellata E-37
Sagittula stellata E-37
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Roseobacter sp. SK209-2-6
Loktanella sp. CCS2
Rickettsia akari Hartford
Rickettsia bellii OSU 85-389
Rickettsia canadensis McKiel
Rickettsia rickettsii Sheila Smith
Roseobacter sp. AzwK-3b
Roseobacter sp. AzwK-3b
Roseobacter sp. AzwK-3b
Roseobacter sp. AzwK-3b
Roseovarius sp. TM1035
Oceanibulbus indolifex HEL-45
Oceanibulbus indolifex HEL-45
Oceanibulbus indolifex HEL-45
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis BS107
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Phaeobacter gallaeciensis 2.10
Hoeflea phototrophica DFL-43
Hoeflea phototrophica DFL-43
Nisaea sp BAL199
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Methylobacterium populi BJ001
Brucella abortus S19
Brucella abortus S19
Brucella abortus S19
Orientia tsutsugamushi Ikeda
Wolbachia endosymbiont of Culex quinquefasciatus Pel
Rhizobium etli CIAT 652
Rhizobium etli CIAT 652
Rhizobium etli CIAT 652
Rhodopseudomonas palustris TIE-1
Rhodopseudomonas palustris TIE-1
Phenylobacterium zucineum HLK1
Roseobacter sp. MED193
Fulvimarina pelagi HTCC2506
Fulvimarina pelagi HTCC2506
Rhodobacterales sp.HTCC2255
Labrenzia aggregata IAM 12614
Labrenzia aggregata IAM 12614
Rhizobium etli Kim 5
Rhizobium etli Kim 5
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli 8C-3
Rhizobium etli IE4771
Rhizobium etli CIAT 894
Rhizobium etli CIAT 894
Wolbachia endosymbiont of Culex quinquefasciatus JHB
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Gluconacetobacter diazotrophicus PAl 5, DSM 5601
Rhizobium leguminosarum bv. trifolii WSM2304
Rhizobium leguminosarum bv. trifolii WSM2304
Rhizobium leguminosarum bv. trifolii WSM2304
Rhodocista centenaria SW
Rhodocista centenaria SW
Rhodocista centenaria SW
Rhodocista centenaria SW
Methylocella silvestris BL2, DSM 15510
Methylocella silvestris BL2, DSM 15510
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium chloromethanicum CM4
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Methylobacterium nodulans ORS 2060
Caulobacter crescentus NA1000
Caulobacter crescentus NA1000
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhodobacter sphaeroides KD131
Rhizobium rhizogenes K84
Rhizobium rhizogenes K84
Rhizobium rhizogenes K84
Agrobacterium vitis S4
Agrobacterium vitis S4
Agrobacterium vitis S4
Agrobacterium vitis S4
Rhizobium etli Brasil 5
Rhizobium etli GR56
Anaplasma marginale Florida
Wolbachia sp. wRi
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Brucella melitensis ATCC 23457
Rhizobium sp. NGR234 (ANU265)
Rhizobium sp. NGR234 (ANU265)
Rhizobium sp. NGR234 (ANU265)
Brucella ceti Cudo
Brucella ceti Cudo
Brucella ceti Cudo
Rickettsia africae ESF-5
Rickettsia peacockii Rustic
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Methylobacterium extorquens AM1
Bartonella grahamii as4aup
Bartonella grahamii as4aup
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium leguminosarum bv. trifolii WSM1325
Rhizobium leguminosarum bv. trifolii WSM1325
Hirschia baltica ATCC 49814
Hirschia baltica ATCC 49814
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter asiaticus psy62
Candidatus Liberibacter asiaticus psy62
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Methylobacterium extorquens DM4
Neorickettsia risticii Illinois
Brucella microti CCM 4915
Brucella microti CCM 4915
Brucella microti CCM 4915
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Acetobacter pasteurianus IFO 3283-01
Brucella ceti M490/95/1
Brucella ceti M490/95/1
Brucella abortus 2308 A
Brucella abortus 2308 A
Brucella abortus 2308 A
Brucella abortus 2308 A
Brucella abortus 2308 A
Brucella abortus 2308 A
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Ochrobactrum intermedium LMG 3301
Zymomonas mobilis mobilis T.H.Delft 1, ATCC 10988
Anaplasma marginale Mississippi
Brucella abortus bv 6, 870
Brucella melitensis bv 2, 63/9
Brucella melitensis bv 3, Ether
Anaplasma marginale Puerto Rico
Brucella abortus bv 4, 292
Brucella abortus bv 3, Tulya
Brucella melitensis bv 1, Rev.1
Brucella pinnipedialis M163/99/10
Brucella abortus bv 2, 86/8/59
Brucella suis bv 5, 513
Brucella ceti M644/93/1
Brucella suis bv 3, 686
Brucella ceti M13/05/1
Brucella pinnipedialis M292/94/1
Brucella abortus bv 9, C68
Brucella sp. 83/13
Brucella neotomae 5K33, ATCC 23459
Anaplasma marginale Virginia
Brucella pinnipedialis B2/94
Brucella ceti B1/94
Brucella sp. F5/99
Zymomonas mobilis subsp. mobilis NCIMB 11163
Zymomonas mobilis subsp. mobilis NCIMB 11163
Zymomonas mobilis subsp. mobilis NCIMB 11163
Anaplasma centrale str. Israel
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Azospirillum sp. B510
Sphingobium japonicum UT26S
Candidatus Puniceispirillum marinum IMCC1322
Sphingobium japonicum UT26S
Sphingobium japonicum UT26S
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Rhodobacter capsulatus SB1003
Caulobacter segnis ATCC 21756
Caulobacter segnis ATCC 21756
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-03
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-07
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-22
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-26
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-32
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-01-42C
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Acetobacter pasteurianus IFO 3283-12
Rickettsia prowazekii Rp22
Rhodobacter sp. SW2
Mesorhizobium opportunistum WSM2075
Methylosinus trichosporium OB3b
Rickettsia endosymbiont of Ixodes scapularis
Wolbachia sp. wUni (Muscidifurax uniraptor)
Wolbachia sp. wUni (Muscidifurax uniraptor)
Wolbachia sp. wUni (Muscidifurax uniraptor)
Citromicrobium bathyomarinum JL354
Gluconacetobacter hansenii ATCC 23769
Brevundimonas sp. BAL3
Brevundimonas sp. BAL3
Octadecabacter antarcticus 307
Octadecabacter antarcticus 307
Octadecabacter antarcticus 238
Octadecabacter antarcticus 238
Rhodobacterales sp. HTCC2083
Rhodobacterales sp. HTCC2083
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Rhodobacterales sp. Y4I
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Pseudovibrio sp. JE062
Nautella italica R11
Nautella italica R11
Nautella italica R11
Nautella italica R11
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Sulfitobacter sp. GAI101
Ruegeria sp. KLH11
Ruegeria sp. KLH11
Ruegeria sp. KLH11
Thalassiobium sp. R2A62
Thalassiobium sp. R2A62
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Silicibacter sp. TrichCH4B
Brucella abortus NCTC 8038
Brucella melitensis bv. 1, 16M
Brucella suis bv 4, 40
Silicibacter lacuscaerulensis ITI-1157
Silicibacter lacuscaerulensis ITI-1157
Silicibacter lacuscaerulensis ITI-1157
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Citreicella sp. SE45
Brucella sp. NVSL 07-0026
Brucella sp. NVSL 07-0026
Brucella abortus bv 5, B3196
Starkeya novella DSM 506
Hyphomicrobium denitrificans ATCC 51888
Brevundimonas subvibrioides ATCC 15264
Brevundimonas subvibrioides ATCC 15264
Parvularcula bermudensis HTCC2503
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Pelagibaca bermudensis HTCC2601
Brucella sp. BO1
Brucella sp. NF 2653
Afipia sp. 1NLS2
Ensifer meliloti BL225C
Sphingobium chlorophenolicum L-1
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Ketogulonicigenium vulgare Y25
Rhodomicrobium vannielii ATCC 17100
Rhodomicrobium vannielii ATCC 17100
Candidatus Liberibacter solanacearum CLso-ZC1
Candidatus Liberibacter solanacearum CLso-ZC1
Candidatus Liberibacter solanacearum CLso-ZC1
Asticcacaulis excentricus CB 48
Asticcacaulis excentricus CB 48
Asticcacaulis excentricus CB 48
Rhodopseudomonas palustris DX-1
Rhodopseudomonas palustris DX-1
Mesorhizobium ciceri bv biserrulae WSM1271
Mesorhizobium ciceri bv biserrulae WSM1271
Bartonella clarridgeiae 73
Bartonella clarridgeiae 73
Methylocystis sp. Rockwell, ATCC 49242
Maritimibacter alkaliphilus HTCC2654
Labrenzia alexandrii DFL-11
Labrenzia alexandrii DFL-11
Labrenzia alexandrii DFL-11
Ahrensia sp. R2A130
Brucella sp. BO2
Brucella sp. BO2
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Roseibium sp. TrichSKD4
Oligotropha carboxidovorans OM5
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Acidiphilium multivorum AIU301
Acidiphilium multivorum AIU301
Candidatus Pelagibacter sp. IMCC9063
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Agrobacterium sp. H13-3
Novosphingobium sp. PP1Y
Novosphingobium sp. PP1Y
Novosphingobium sp. PP1Y
Sinorhizobium meliloti AK83
Sinorhizobium meliloti AK83
Sinorhizobium meliloti AK83
Oligotropha carboxidovorans OM5
Zymomonas mobilis subsp. pomaceae ATCC 29192
Zymomonas mobilis subsp. pomaceae ATCC 29192
Zymomonas mobilis subsp. pomaceae ATCC 29192
Hyphomicrobium sp. MC1
Candidatus Midichloria mitochondrii IricVA
Roseobacter litoralis Och 149
Rickettsia heilongjiangensis 054
Sinorhizobium meliloti SM11
Sinorhizobium meliloti SM11
Sinorhizobium meliloti SM11
Brucella melitensis M5-90
Brucella melitensis M5-90
Brucella melitensis M5-90
Brucella melitensis M28
Brucella melitensis M28
Brucella melitensis M28
Oligotropha carboxidovorans OM4
Asticcacaulis biprosthecum C19
Brevundimonas diminuta ATCC 11568
Agrobacterium sp. ATCC 31749
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Gluconacetobacter sp. SXCC-1
Rhodobacter sphaeroides WS8N
Rhodobacter sphaeroides WS8N
Rhodobacter sphaeroides WS8N
Sphingomonas sp. S17
Bradyrhizobiaceae bacterium SG-6C
Acidiphilium sp. PM
Novosphingobium nitrogenifigens DSM 19370
Paracoccus sp. TRP
Acetobacter pomorum DM001
Acetobacter tropicalis NBRC 101654