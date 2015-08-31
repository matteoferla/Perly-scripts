#! /usr/bin/perl
#code last modified 23-7-10
print "Hello World\n";
use constant PI => 3.1415926536;
use constant SIGNIFICANT => 5;



###################################
#	parameters:
#  $cogable is the index on the Cog.xlsx table.
#  why $mill? To mill a deck is a Magic the Gathering phrase meaning to wastefully use up a whole deck
#   leio- = smooth... rounding
#   en- = in, ec-= out.
#
# disable hydrophobicity H, cross-ref X, matrices M, size S, cog C, cog distributions G, tandem T, aa triplets N, O Cog matrices
#$Dis="CGHXMSCGTNO";
@Fullabc=("A".."Z");
#@Fullabc=qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx);
#@Fullabc=qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid);
@Abc=zeroed(\@Fullabc);
my @Hydroref=(1.8, 0, 2.5, -3.5, -3.5, 2.8, -0.4, -3.2, 4.5, 0, -3.9, 3.8, 1.9, -3.5, 0, -1.6, -3.5, -4.5, -0.8, -0.7, 0, 4.2, -0.9, 0, -1.3);
my $Hstep=2; # number of steps per hydropathy score unit, so it increases in 1/step increments.
my $Sstep=100; #idem but for size...
@Cats=("A ( RNA processing and modification)","B ( Chromatin structure and dynamics)","C ( Energy production and conversion)","D ( Cell cycle control, cell division, chromosome partitioning)","E ( Amino acid transport and metabolism)","F ( Nucleotide transport and metabolism)","G ( Carbohydrate transport and metabolism)","H ( Coenzyme transport and metabolism)","I ( Lipid transport and metabolism)","J ( Translation, ribosomal structure and biogenesis)","K ( Transcription)","L ( Replication, recombination and repair)","M ( Cell wall/membrane/envelope biogenesis)","N ( Cell motility)","O ( Posttranslational modification, protein turnover, chaperones)","P ( Inorganic ion transport and metabolism)","Q ( Secondary metabolites biosynthesis, transport and catabolism)","R ( General function prediction only)","S ( Function unknown)","T ( Signal transduction mechanisms)","U ( Intracellular trafficking, secretion, and vesicular transport)","V ( Defense mechanisms)","W ( Extracellular structures)","X (Blank)","Y ( Nuclear structure)","Z ( Cytoskeleton)");

@Todo=qw(Aae Aca Afu Ala Ape Asp Atu Bsu Cac Cau Cje Cpn Csa Csy Dra Eco Fnu Gth Hbs homo Hwa Kcr Mac Mae Mbu Mja Mka Mpu Mru Mth Mtu Nap Neq Nos Pab Pae Par Pfu Pho Pin Pmu Pox Pya Rpr Rso Rxy Sau Sce Sso Sty Syn Tac Taq Tga Tma Tpa Tth Tvo Uur Fno Pmo Sth Tra Msi Oih Sul Hth Gau Emi Psp Lar Nma Mse Asa Iho Lca Hbu Sma Tpe Mbo Mst Mma Abo Msm Pac Cwo Afe Blo Cgl Mle Cin Bbu Lbo Nde Tye Tpe Kra Kol Taf Tnv Ste Dpe Lbu Smo Msz Dth Nit Det Pli Tm7 S5 Tte Tic Cpr);	
#Aae Aca Afu Ala Ape Asp Atu Bsu Cac Cau Cje Cpn Csa Csy Dra Eco Fnu Gth Hbs homo Hwa Kcr Mac Mae Mbu Mja Mka Mpu Mru Mth Mtu Nap Neq Nos Pab Pae Par Pfu Pho Pin Pmu Pox Pya Rpr Rso Rxy Sau Sce Sso Sty Syn Tac Taq Tga Tma Tpa Tth Tvo Uur Fno Pmo Sth Tra Msi Oih Sul Hth Gau Emi Psp Lar Nma Mse Asa Iho Lca Hbu Sma Tpe Mbo Mst Mma Abo Msm Pac Cwo Afe Blo Cgl Mle Cin Bbu Lbo Nde Tye Tpe Kra Kol Taf Tnv Ste Dpe Lbu Smo Msz Dth Nit Det Pli Tm7 S5 Tte
##################################


my $Whom=0;

my $Hmin=int($Hstep*0.5);
my $Hmax=int($Hstep*9.5);

#$file=">analysis/all.txt";	
#open(ALL,$file) 	or die "Can't create file: $!";

open(ORG,'microbes.txt') or die "Can't find microbes: $!";
@micro=<ORG>;
chomp(@micro);
shift(@micro);
for $x (0..$#micro) {
	@{$Org[$x]}=split(/\t/,$micro[$x]);
}

foreach $Phenix (@Todo) {


	reset 'a-z';
	$disable=$Dis;
	$who=$Phenix;
	@abc=@Abc;
	
	
	for $x (0..$#Org) {
		if ($who=~ m/$Org[$x][0]/i) {
			$emprefix=$Org[$x][1];       #in
			$ecprefix=$Org[$x][2];       #out
			$species=$Org[$x][3];
			$cogable=0; $disable.=$Org[$x][4];
			$what=$Org[$x][5];
		}
	}
	
	
	
	
	if ($who=~ m/xxx/i) {
		#custom job overide!
		$ecprefix="CUSTOM-";
		$cogable=0; $disable.="CX";
		$temp="        1 mvfcgdggls cesidfalcc lrgrsgnyvq srilpmadas pdpskpdtlv lidghalafr
		61 syfalpplnn skgemthaiv gfmklllrla rqksnqvivv fdppvktfrh eqyegyksgr
		121 aqtpedlpgq inriralvda lgfprleepg yeaddviasl trmaegkgye vrivtsdrda
		181 yqlldehvkv iandfsligp aqveekygvt vrqwvdyral tgdasdnipg akgigpktaa
		241 kllqeygtle kvyeaahagt lkpdgtrkkl ldseenvkfs hdlscmvtdl pldiefgvrr
		301 lpdnplvted lltelelhsl rpmilglngp eqdghapddl lerehaqtpe edeaaalpaf
		361 sapelaewqt paegavwgyv lsreddltaa llaaatfedg varpapvsep dewaqaeape
		421 nlfgellpsd kpltkkeqka lekaqkdaek araklreqfp atvdeaefvg qrtvtaaaak
		481 alaahlsvrg tvvepgddpl lyaylldpan tnmpvvakry ldrewpadap traaitghll
		541 relpplldda rrkmydemek plsgvlgrme vrgvqvdsdf lqtlsiqagv rladlesqih
		601 eyageefhir spkqletvly dklelasskk tkltgqrsta vsaleplrda hpiiplvlef
		661 reldklrgty ldpipnlvnp htgrlhttfa qtavatgrls slnpnlqnip irselgreir
		721 kgfiaedgft liaadysqie lrllahiadd plmqqafveg adihrrtaaq vlgldeatvd
		781 anqrraaktv nfgvlygmsa hrlsndlgip yaeaatfiei yfatypgirr yinhtldfgr
		841 thgyvetlyg rrryvpglss rnrvqreaee rlaynmpiqg taadimklam vqldpqldai
		901 garmllqvhd ellieapldk aeqvaaltkk vmenvvqlkv plavevgtgp nwfdtk";
		$file=">analysis/list_CUSTOM.txt";
		$temp=~s/\W//msg;$temp=~s/\r//msg;$temp=~s/\d//msg;$temp=~s/\_//msg;$gene[0][2]=uc($temp);
		print "custom sequence: $gene[0][2]\n";
		open(MASTER,$file) 	or die "Can't create file: $!";
		goto BACKDOOR;
	}
	
	
	if ($ecprefix eq "") {
		print "WARNING: incorrect Id ($who)./n";
		goto VORTEX;
	}
	
	
	
	print "\n\n$species\n($what)\n";
	
	
	###################################
	###FILES###########################
	$file=">analysis/list_".$ecprefix.".txt";	
	open(MASTER,$file) 	or die "Can't create file: $!";
	print MASTER "$species\t\t($what)\n"; ########## MASTERLIST
	$Ultimus[0][$Whom]="$species ($what)";
	$Exodus[0][$Whom]="$species ($what)";
	##########	
	
	$file=$emprefix.'/data/protseq.fsa';
	open(AA,$file) or die "Can't open the amino acid file: $!";
	
	print "Reading sequences...\n";
	@fastalist=<AA>;
	close AA;

	
	for ($n=0;$n<=$#fastalist;$n++)
	{
		chomp($fastalist[$n]);
		#>EG12096-MONOMER ChpB toxin of the ChpB-ChpS toxin-antitoxin system 4446715..4447065 Escherichia coli K-12 substr. MG1655
		#gene... 0 key, 1 description, 2 sequence, 3 monomer flag, 4 lettercode
		if ($fastalist[$n]=~ m/\>(\S*)\s(.*)/msg) {
			$genenumber++;
			$gene[$genenumber][0]=$fastalist[$n];
			$gene[$genenumber][0]=$1;
			$gene[$genenumber][1]=$2;
			$gene[$genenumber][0]=~ s/\-//msg;
			$gene[$genenumber][1]=~s/$species .*//msg;
			$gene[$genenumber][3]= ($gene[$genenumber][0]=~s/MONOMER//msg);
			$gene[$genenumber][1]=~ s/\S*\.\.\S*\s*$//msg;
			$gene[$genenumber][4]= $&;
			$gene[$genenumber][1]=~ s/\s$//msg;
			#if ($gene[$genenumber][1] =~ m/^(\w{3,4})\s/) {$match= $1; $gene[$genenumber][4]=$match; print "$gene[$genenumber][4]\n";} else {$gene[$genenumber][4]= "?";}
			
		} else
		{$fastalist[$n]=~s/\W//msg;$fastalist[$n]=~s/\r//msg;$fastalist[$n]=~s/\d//msg;$fastalist[$n]=~s/X//msgi;$fastalist[$n]=~s/\_//msg;$gene[$genenumber][2].=uc($fastalist[$n]);}
	}
	shift (@gene);
	my $tg=$#gene+1;
	print MASTER "\# genes\t".$tg."\n"; ########## MASTERLIST
	$Ultimus[1][$Whom]=$tg;
	
	
	
	
	# cross ref keys
	if ($disable !~ m/X/msg) {
		print "Cross referencing with other indices...\n";
		$file=$emprefix.'/data/genes.col';	
		open(CREF,$file) or die "Can't open the crossref file: $!";
		@cross=<CREF>;
		chomp @cross;
		for $n (0..$#cross) {
			@temp=split(/\t/,$cross[$n]);
			foreach (@temp) {if ($_=~/^$/) {$_="...";}}
			if ($temp[0] =~ m/\#/) {$intro++;} else {$cref[$n-$intro]=[@temp]; $cref[$n-$intro][0]=~ s/\-//msg;}
				}
		close CREF;
		
		
		for $i ( 0 .. $#gene ) {
			for $n ( 0 .. $#cref ) {
				if (uc($gene[$i][0]) eq uc($cref[$n][0])) {$match++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY;}
				elsif (uc($gene[$i][0]) eq uc($cref[$n][1])) {$blamatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }		
				elsif (uc($gene[$i][1]) eq uc($cref[$n][3])) {$defmatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }
				elsif (uc($cref[$n][2]) eq uc($gene[$i][1])) {$lettermatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }
				elsif (uc($cref[$n][2]) eq uc($gene[$i][0])) {$lettermatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }
			}
			$missing++;	
		AWAY:
		}
		
		
		print "There are ". ($match+$blamatch+$defmatch+$lettermatch)." matched and ".$missing." unmatched genes out of $genenumber (".int(($match+$blamatch+$defmatch+$lettermatch)/$genenumber*100+0.5)."\% done: ".int($match/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100+0.5)."% by ID, ".int($blamatch/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100+0.5)."% by blatter, ".int($defmatch/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100)."% by definition and ".int($lettermatch/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100)."% by definition)\n";
		print MASTER ("xref unmatched\t$missing\n"); ########## MASTERLIST
	}	
	
	
	#######COG##################################################################################################################################################
	
	
	if (($disable !~ m/C/msg) && ($cogable>0)) {
		print "Cross referencing with COG list...\n";
		open(COG,'whog') or die "Can't open file: whog, please could you download ftp://ftp.ncbi.nih.gov/pub/COG/COG/whog?\n";
		@lines=<COG>;
		
		
		for ($n=1;$n<=$#lines; $n++)
		{
			$item=$lines[$n];
			chomp($item);
			
			if ($item =~ m/\[/)
			{
				#[H] COG0001 Glutamate-1-semialdehyde aminotransferase
				$maxcog++;
				$item =~ m/\[(\w)*?\] (\w*?) (.*)/;
				$cog[0][$maxcog] =$1;
				$cog[1][$maxcog] =$2;
				$cog[2][$maxcog] =$3;
			}
			
			if ($item =~ m/ $who\:/i) { $item =~ m/ $who\: (.*)/i; $t =$1; @temp=split(/ /,$t);
				for $z ( 0 .. $#temp ) {
					$cog[3+$z][$maxcog]=$temp[$z];
					$cog[3+$z][$maxcog]=~s/\W//msg; 
					$cog[3+$z][$maxcog]=~s/\s//msg; 
					$cog[3+$z][$maxcog]=~s/_.*//msg;
					if (length($cog[3+$z][$maxcog])==0) {delete $cog[3+$z][$maxcog];}
				}		
				
			}
			
		}
		
		$mill="wind"; $n="dummy";
		for $mill (0..$#gene) {
			for $n (0..$maxcog) {
				
				for $q (6..7,14..17) { 
					#try all keys
					for $z (0..10) {
						#multiple protein per cog
						if (uc($gene[$mill][$q]) eq uc($cog[3+$z][$n])) {$cogle++; $gene[$mill][21]=$cog[0][$n]; $gene[$mill][22]=$cog[1][$n]; $gene[$mill][23]=$cog[2][$n]; goto HOLIDAY;}
					}}}
			$scogle++;	
		HOLIDAY:
		} #gene mill
		$coogle=0;
		for $n (0..$#gene) {if (length($gene[$n][21])>0) {$coogle++;}}
		print "There are ". ($cogle)." cogs matched ($coogle actual) and ".$scogle." unassigned genes out of $#gene\n";
		print MASTER ("cog unmatched\t$scogle\n"); ########## MASTERLIST
		$Ultimus[2][$Whom]=$coogle;
		
	}#COGed
	
	
	
	
	
BACKDOOR:	
	
	#########SINGLE##############################################################################################################################################################################################################################################
	print "Calculation amino acid composition statistics...\n";
	print MASTER ("#########Singles\tavg\tstdev\tskew\tkurt\t");
	for $n (0..100) {print MASTER "\t$n";}
	print MASTER "\n";
	my @aa=(); my @len=(); my $char=(); 
	for ($n=0;$n<=$#gene;$n++)	{
		$aa[$n]=[split(//, $gene[$n][2])];
		$len[$n]=$#{$aa[$n]}+2; #start from 1 and count stop...good as a number, minus 2 as an index
		$char[$n]=[map {ord($aa[$n][$_])-65} (0..$#{$aa[$n]})];
		
		for $i (0..$#{$aa[$n]}) {$compo[$char[$n][$i]][$n]+=(1/($len[$n]));
			$avgcompo[$char[$n][$i]]+=(1/(($len[$n])*$tg));}
		$compo[25][$n]+=(1/($len[$n])); $avgcompo[25]+=(1/(($len[$n])*$tg));#stop
	}#layer matrix maker
	
	@zeroes=map{0}(0..100);
	for $ante (0,2..8,10..13,15..19,21,22,24,25) {
		$distcompo[$ante]=[@zeroes];
		for ($n=0;$n<=$#gene;$n++) {
			$gene[$n][33+$ante]=$compo[$ante][$n];
			$devcompo[$ante]+=(($compo[$ante][$n]-$avgcompo[$ante])**2);
			$skewcompo[$ante]+=(($compo[$ante][$n]-$avgcompo[$ante])**3);
			$kurtcompo[$ante]+=(($compo[$ante][$n]-$avgcompo[$ante])**4);
			$distcompo[$ante][int(abs($compo[$ante][$n]*100))]+=1/$tg; #one percent increases from 0 to 1
		}
		$devcompo[$ante]=sqrt($devcompo[$ante]/$tg);
		if ($devcompo[$ante]>0) {$skewcompo[$ante]=$skewcompo[$ante]/($tg*($devcompo[$ante]**3));$kurtcompo[$ante]=$kurtcompo[$ante]/($tg*($devcompo[$ante]**4))-3;} else {$skewcompo[$ante]="\#";$kurtcompo[$ante]="\#";}
	}
	for $ante (0,2..8,10..13,15..19,21,22,24,25) {
		for ($n=0;$n<=$#gene;$n++) {
			if ($devcompo[$ante]>0) {
				$zcompo[$ante][$n]=(($compo[$ante][$n]-$avgcompo[$ante])/$devcompo[$ante]);
				$taxicompo[$n]+=abs($zcompo[$ante][$n])**1;
				$pythacompo[$n]+=abs($zcompo[$ante][$n])**2;
			}
			$pythacompo[$n]=($zcompo[$ante][$n])**(1/2);
			$avgpythacompo+=$pythacompo[$n]/$tg;
			$avgtaxicompo+=$taxicompo[$n]/$tg;
		}
	}
	
	for ($n=0;$n<=$#gene;$n++) {
		$devtaxicompo+=(($taxicompo[$n]-$avgtaxicompo)**2);
		$skewtaxicompo+=(($taxicompo[$ante][$n]-$avgtaxicompo)**3);
		$kurttaxicompo+=(($taxicompo[$n]-$avgtaxicompo)**4);
		$disttaxicompo[int(abs($taxicompo[$n]))]+=1/$tg;
	}
	$devtaxicompo=sqrt($devtaxicompo/$tg);
	if ($devtaxicompo>0) {$skewtaxicompo=$skewtaxicompo/($tg*($devtaxicompo**3));$kurttaxicompo=$kurttaxicompo/($tg*($devtaxicompo**4))-3;} else {$skewtaxicompo="\#";$kurttaxicompo="\#";}
	
	
	
	for ($n=0;$n<=$#gene;$n++) {
		$devpythacompo+=(($pythacompo[$n]-$avgpythacompo)**2);
		$skewpythacompo+=(($pythacompo[$ante][$n]-$avgpythacompo)**3);
		$kurtpythacompo+=(($pythacompo[$n]-$avgpythacompo)**4);
		$distpythacompo[int(abs($pythacompo[$n]*10))]+=1/$tg;
	}
	$devpythacompo=sqrt($devpythacompo/$tg);
	if ($devpythacompo>0) {$skewpythacompo=$skewpythacompo/($tg*($devpythacompo**3));$kurtpythacompo=$kurtpythacompo/($tg*($devpythacompo**4))-3;} else {$skewpythacompo="\#";$kurtpythacompo="\#";}
	
	$j=0;
	for $k (0,2..8,10..13,15..19,21,22,24) {
		print MASTER ($Fullabc[$k]."\t$avgcompo[$k]\t$devcompo[$k]\t$skewcompo[$k]\t$kurtcompo[$k]\t"); ########## MASTERLIST
		for $n (0..100) {print MASTER "\t$distcompo[$k][$n]";}
		print MASTER "\n";
		$Ultimus[3+$j][$Whom]=$avgcompo[$k];
		$Exodus[1+$j][$Whom]=$avgcompo[$k];
		$j++;
	}
	print MASTER ("Stop\t$avgcompo[25]\t$devcompo[25]\t$skewcompo[25]\t$kurtcompo[25]\t"); ########## MASTERLIST
	for $n (0..100) {print MASTER "\t$distcompo[25][$n]";}
	print MASTER "\n";
	$Ultimus[23][$Whom]=$avgcompo[25];
	$Exodus[21][$Whom]=$avgcompo[25];
	$Ultimus[24][$Whom]="---";
	
	$file=">analysis/".$ecprefix."zorg.txt";	
	open(ZORG,$file) 	or die "Can't create file: $!";
	print ZORG ("\zorg flavour\tavg\tstdev\tskew\tkurt\t".join("\t",(0..100))."\n");
	print ZORG ("single manhattan distance\t$avgtaxicompo\t$devtaxicompo\t$skewtaxicompo\t$kurttaxicompo\t".join("\t",@disttaxicompo)."\n");
	print ZORG ("single euclides distance\t$avgpythacompo\t$devpythacompo\t$skewpythacompo\t$kurtpythacompo\t".join("\t",@distpythacompo)."\n");
	close ZORG;
	
	
	##########COVARIANCE####################
	
	if ($disable !~ m/V/msg) {
		$file=">analysis/".$ecprefix."cov.txt";	
		open(COV,$file) 	or die "Can't create file: $!";
		for ($n=0;$n<=$#gene;$n++)	{
			for $ante (0,2..8,10..13,15..19,21,22,24) {
				for $post (0,2..8,10..13,15..19,21,22,24) {
					$covcompo[$ante][$post]+=($compo[$ante][$n]-$avgcompo[$ante])*($compo[$post][$n]-$avgcompo[$post])/$tg;
				}
			}
		}
		
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				$pearcompo[$ante][$post]=$covcompo[$ante][$post]/($devcompo[$ante]*$devcompo[$post]);
			}
		}
		print COV ("Covariance\nV 1st > 2nd\t".join("\t",@Abc)."\n");
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			print COV (chr($ante+65)."\t".join("\t",zeroed(\@{$covcompo[$ante]}))."\n");
		}
		
		print COV ("\nPearson\nV 1st > 2nd\t".join("\t",@Abc)."\n");
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			print COV (chr($ante+65)."\t".join("\t",zeroed(\@{$pearcompo[$ante]}))."\n");
		}
		close COV;
		$j=0;
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				if ($ante<$post) {
					$Exodus[22+$j][$Whom]= $pearcompo[$ante][$post];
					$j++;
				}
			}
		}
	}
	
	
	
	
	##################TANDEM######################################################################################################################################################################################################################
	if ($disable !~ m/T/msg) {
		print "Analysis tandem repeats...\n";
		for ($n=0;$n<=$#gene;$n++)	{
			
			for ($mill = 0; $mill <= $#{$aa[$n]}; $mill++)
			{
				
				if ($aa[$n][$mill] !~ "X") {
					$multiloop=0;
					until ($aa[$n][$multiloop+$mill] ne "$aa[$n][$mill]")
					{
						$multiloop++;
					}
					$multiloop--;$multiloop--;
					if ($multiloop > 9) {
						print "WARNING: A homopolymeric track of ".($multiloop+2)." tandem repeats was encountered! This is very Unusual for Prokaryotes!!\n";
						$freqtandem[$n][8][ord($aa[$n][$mill])-65]+=1/$len[$n];
						$omnifreqtandem[$n][8]+=1/$len[$n];
						$avgtandem[8][ord($aa[$n][$mill])-65]+=1/($len[$n]*$tg);
						$omniavgtandem[8]+=1/($len[$n]*$tg);
						$mill+=$multiloop+2;
					}
					elsif ($multiloop > -1) {
						$freqtandem[$n][$multiloop][ord($aa[$n][$mill])-65]+=(1/$len[$n]);
						$omnifreqtandem[$n][$multiloop]+=(1/$len[$n]);
						$avgtandem[$multiloop][ord($aa[$n][$mill])-65]+=1/($len[$n]*$tg);
						$omniavgtandem[$multiloop]+=1/($len[$n]*$tg);
						$omnidisttandem[$multiloop][int(abs($freqtandem[$n][$x][$y]*100))]+=1/$tg;
						$mill+=$multiloop+2;
					}
					
				}
				
				
			}
		}
		for $y (0..25) {
			for $x (0..8) {
				for ($n=0;$n<=$#gene;$n++)	{
					$devtandem[$x][$y] += ($freqtandem[$n][$x][$y]-$avgtandem[$x][$y])**2;
					$skewtandem[$x][$y] += ($freqtandem[$n][$x][$y]-$avgtandem[$x][$y])**3;
					$kurttandem[$x][$y] += ($freqtandem[$n][$x][$y]-$avgtandem[$x][$y])**4;
					$gene[$n][24+$x]=$omnifreqtandem[$n][$x];
					$disttandem[$x][$y][int(abs($freqtandem[$n][$x][$y]*100))]+=1/$tg;
				}
				$devtandem[$x][$y]=sqrt($devtandem[$x][$y]/$tg);
				if ($devtandem[$x][$y]>0) {$skewtandem[$x][$y]=($skewtandem[$x][$y]/$tg)/($devtandem[$x][$y])**3;$kurttandem[$x][$y]=($kurttandem[$x][$y]/$tg)/($devtandem[$x][$y])**4-3;} else {$skewtandem[$x][$y]="\#";$kurttandem[$x][$y]="\#";}
			}
		}
		@omnidevtandem=();
		for $x (0..8) {
			for ($n=0;$n<=$#gene;$n++)	{
				$omnidevtandem[$x] += ($omnifreqtandem[$n][$x]-$omniavgtandem[$x])**2;
				$omniskewtandem[$x] += ($omnifreqtandem[$n][$x]-$omniavgtandem[$x])**3;
				$omnikurttandem[$x] += ($omnifreqtandem[$n][$x]-$omniavgtandem[$x])**4;
			}
			$omnidevtandem[$x]=sqrt($omnidevtandem[$x]/$tg);
			if ($omnidevtandem[$x]>0) {$omniskewtandem[$x]=($omniskewtandem[$x]/$tg)/($omnidevtandem[$x])**3;$omnikurttandem[$x]=($omnikurttandem[$x]/$tg)/($omnidevtandem[$x])**4-3;} else {$omnikurttandem[$x]="\#";$omniskewtandem[$x]="\#";}
		}
		$file=">analysis/".$ecprefix."tandem.txt";	
		open(TANDEM,$file) 	or die "Can't open file: $!";
		print TANDEM "\#tandem amino acid frequencies\nTandem length\\Amino acid freq.\tTotal\t".join("\t",@abc)."\n";
		for ($row=0;$row<=8;$row++) {
			print TANDEM (2+$row)."-tuplet\t";
			print TANDEM $omniavgtandem[$row]."\t".join("\t",zeroed(\@{$avgtandem[$row]}))."\n";
		}
		print TANDEM "\n\n\#tandem amino acid stdev\nTandem length\\Amino acid stdev.\tTotal\t".join("\t",@abc)."\n";
		for ($row=0;$row<=8;$row++) {
			print TANDEM (2+$row)."-tuplet\t";
			print TANDEM $omnidevtandem[$row]."\t".join("\t",zeroed(\@{$devtandem[$row]}))."\n";
		}
		print "Saving $file...\n";
		close TANDEM;
		print MASTER ("#########Tandem\tavg\tstdev\tskew\tkurt\n");
		for $n (0..100) {print MASTER "\t$n";}
		print MASTER "\n";
		
		for $l (0..8) {
			$calc=$l+2; if ($calc==8) {$calc="10+";}
			print MASTER ($calc."\-tuplet\t$omniavgtandem[$l]\t$omnidevtandem[$l]\t$omniskewtandem[$l]\t$omnikurttandem[$l]\t"); ########## MASTERLIST
			for $n (0..100) {print MASTER "\t$omnidisttandem[$l][$n]";}
			print MASTER "\n";
			$Ultimus[25+$l][$Whom]=$omniavgtandem[$l];
		}
		$j=0;
		for $k (0,2..8,10..13,15..19,21,22,24) {
			for $l (0..8) {
				$calc=$l+2; if ($calc==8) {$calc="10+";}
				print MASTER (chr($k+65)." ".$calc."\-tuplet\t$avgtandem[$l][$k]\t$devtandem[$l][$k]\t$skewtandem[$l][$k]\t$kurttandem[$l][$k]\t"); ########## MASTERLIST
				for $n (0..100) {print MASTER "\t$disttandem[$l][$k][$n]";}
				print MASTER "\n";
				$Ultimus[34+$j][$Whom]=$avgtandem[$l][$k];
				$j++;
			}
		}$Ultimus[214][$Whom]="---";
		
	}# end of tandem
	
	###############SAVE THE GENES! (& the whales)########################################################################################################################################################################################################################
	$file=">analysis/".$ecprefix."genes.txt";	
	open(AAOUT,$file) 	or die "Can't open file: $!";
	print AAOUT ("local index\tkey\tdescription\tsequence\tmonomer\tuseless\tunique-ID\tblattner-ID\tname\tproduct-name\tswiss-prot-ID\treplicon\tstart-base\tend-base\tsynonyms\tsynonyms\tsynonyms\tsynonyms\tgene-class\tgene-class\tgene-class\tgene-class\tcog category\tcog number\tcog function\ttandem pairs\ttandem triplets\ttandem quadruplets\ttandem quintuplets\ttandem hexaplets\ttandem heptaplet\ttandem octuplets\ttandem nonaplets\ttandem plusdecaplet\t".join("\t",@Fullabc)."\n");
	for $i ( 0 .. $#gene ) {
		print AAOUT (($i+1)."\t".join("\t",@{$gene[$i]})."\n");
	}
	close AAOUT;
	print "Saving $file...\n";
	#############All below does not modify the list of genes....
	
	
	
	
	#COG dist####################################################################################################################################################################################################
	
	if (($disable !~ m/G/msg) && ($disable !~ m/C/msg) && ($cogable>0)) {
		print "Calculating COG distribution...\n";
		$cogdist[26]=$tg;
		for ($n=0;$n<=$#gene;$n++)	{
			if (length($gene[$n][21])>0) {
				$cogdist[ord($gene[$n][21])-65]++;$cogdist[26]--;
				$leiocogsizedist[int($len[$n]/100+0.5)][ord($gene[$n][21])-65]++;
				for ($m=0;$m<=$#{$aa[$n]};$m++) {$aacogdist[ord($gene[$n][21])-65][$char[$n][$m]]++;}
				$aacogdist[ord($gene[$n][21])-65][25]++;  #one stop per protein
			}}
		$file=">analysis/".$ecprefix."cogdist.txt";	
		open(COGOUT,$file) 	or die "Can't open file: $!";
		# this table has the amino acids as rows and categories as columns...
		print COGOUT ("\t".join("\t",@Cats)."\n");
		for $i (0,2..8,10..13,15..19,21,22,24) {
			print COGOUT chr($i+65);
			for $j (0..25) {print COGOUT "\t".$aacogdist[$j][$i];}
			print COGOUT "\n";
		}
		print COGOUT "protein count\t".join("\t",@cogdist)."\n\n";
		print COGOUT "\#COGs per size rounded to 100\n\t";
		print COGOUT join("\t",@Cats);
		for $x (0..$#leiocogsizedist) {print COGOUT "\n".$x*100;
			for $y (0..25) {print COGOUT "\t$leiocogsizedist[$x][$y]";
			}}
		print COGOUT "\n";
		
		
		close COGOUT;
		print "Saving $file...\n";
		
		print MASTER "\#COG categories\n";
		$j=0;
		for $j (0..25) {print MASTER ($Cats[$j]."\t".($cogdist[$j]/$tg)."\n"); $Ultimus[215+$j][$Whom]=$cogdist[$j];} print MASTER ("Not COG\t".($cogdist[26]/$tg)."\n");
		$Ultimus[241][$Whom]=$cogdist[26];
		$Ultimus[242][$Whom]="---";

		
		
	} #end of cog distr
	
	
	# hydropathy frequency calculation############################################################################################################################################
	
	if ($disable !~ m/H/msgi) {
		
		print "Calculating hydropathy frequencies...\n";
		for ($n=1;$n<=$#gene;$n++)	{
			$size=$#{$aa[$n]};
			@hp=();
			@xp=();
			@hp= map {$Hydroref[$char[$n][$_]]} (0..$size);
			
			
			if ($size<13) {
				$xpt=0;
				for ($mill = 0; $mill <= $size; $mill++) { $xpt +=$hp[$mill];}
				$xpt = int($Hstep*(($xpt/$size)+5));
				@xp=map {$xpt} ( 0 ..$size);
			} else {
				$xpt=0;
				for ($mill = 0; $mill <= 5; $mill++) { $xpt +=$hp[$mill];}
				$xpt = int($Hstep*(($xpt/6)+5));
				for ($mill = 0; $mill <= 5; $mill++) { $xp[$mill]=$xpt;}
				for ($mill = 6; $mill <= ($size-6); $mill++)
				{
					$xp[$mill]=0;
					for ($deca = ($mill-5); $deca <= ($mill+4); $deca++) { $xp[$mill] +=$hp[$deca];}
					$xp[$mill] = int($Hstep*(($xp[$mill]/10)+5));
				}
				
				$xpt=0;
				for ($mill = ($size-5); $mill <= $size; $mill++) { $xpt +=$hp[$mill];}
				$xpt = int($Hstep*(($xpt/5)+5));
				for ($mill = ($size-5); $mill <= $size; $mill++) { $xp[$mill]=$xpt;}
				
				
			}
			
			for ($mill = 1; $mill <= $size; $mill++) {
				$counthydro[$xp[$mill]][$char[$n][$mill]]++;
				$freqhydro[$n][$xp[$mill]][$char[$n][$mill]]++;
				$omnifreqhydro[$n][$xp[$mill]]++;
				#$avghydro[$xp[$mill]][$char[$n][$mill]]+=1/($len[$n]*$tg);
			}
			$counthydro[$xp[$size]][25]++; # stop codons.
			$freqhydro[$n][$xp[$mill]][25]++; # stop codons.
			for $x ($Hmin..$Hmax) {
				if ($omnifreqhydro[$n][$x]>0){
					$blanklesshydro[$x]++;
					for $y (0,2..8,10..13,15..19,21,22,24,25) {$freqhydro[$n][$x][$y]=$freqhydro[$n][$x][$y]/$omnifreqhydro[$n][$x];}
				} else {for $y (0,2..8,10..13,15..19,21,22,24,25) {$freqhydro[$n][$x][$y]=0;}}
				
				$omnifreqhydro[$n][$x]=$omnifreqhydro[$n][$x]/$len[$n];
			}
			
		}#each protein
		
		for $y (0,2..8,10..13,15..19,21,22,24,25) {
			for $x ($Hmin..$Hmax) {
				for ($n=0;$n<=$#gene;$n++)	{
					if ($omnifreqhydro[$n][$x]>0){
						$avghydro[$x][$y]+=($freqhydro[$n][$x][$y]/$blanklesshydro[$x]);
					}
				}
			}
		}
		
		for $x ($Hmin..$Hmax) {
			for ($n=0;$n<=$#gene;$n++)	{
				$omniavghydro[$x]+=($omnifreqhydro[$n][$x]/$tg);
			}
		}
		
		
		for $y (0,2..8,10..13,15..19,21,22,24,25) {
			for $x ($Hmin..$Hmax) {
				for ($n=0;$n<=$#gene;$n++)	{
					if ($omnifreqhydro[$n][$x]>0){
						$devhydro[$x][$y] += ($freqhydro[$n][$x][$y]-$avghydro[$x][$y])**2;
						$skewhydro[$x][$y] += ($freqhydro[$n][$x][$y]-$avghydro[$x][$y])**3;
						$kurthydro[$x][$y] += ($freqhydro[$n][$x][$y]-$avghydro[$x][$y])**4;
					}
				}
				if ($blanklesshydro[$x]>0) {$devhydro[$x][$y]=sqrt($devhydro[$x][$y]/$blanklesshydro[$x]);
					if (($devhydro[$x][$y]>0)) {$skewhydro[$x][$y]=($skewhydro[$x][$y]/$blanklesshydro[$x])/($devhydro[$x][$y])**3;$kurthydro[$x][$y]=($kurthydro[$x][$y]/$blanklesshydro[$x])/($devhydro[$x][$y])**4-3;} else {$skewhydro[$x][$y]="\#";$kurthydro[$x][$y]="\#";}}
			}
		}
		
		
		
		for $x ($Hmin..$Hmax) {
			for ($n=0;$n<=$tg;$n++)	{
				$omnidevhydro[$x] += ($omnifreqhydro[$n][$x]-$omniavghydro[$x])**2;
				$omniskewhydro[$x] += ($omnifreqhydro[$n][$x]-$omniavghydro[$x])**3;
				$omnikurthydro[$x] += ($omnifreqhydro[$n][$x]-$omniavghydro[$x])**4;
			}
			$omnidevhydro[$x]=sqrt($omnidevhydro[$x]/$tg);
			if ($omnidevhydro[$x]>0) {$omniskewhydro[$x]=($omniskewhydro[$x]/$tg)/($omnidevhydro[$x])**3;$omnikurthydro[$x]=($omnikurthydro[$x]/$tg)/($omnidevhydro[$x])**4-3;} else {$omnikurthydro[$x]="\#";$omniskewhydro[$x]="\#";}
		}
		
		
		$file=">analysis/".$ecprefix."hydropath.txt";	
		open(HCOUT,$file) 	or die "Can't open file: $!";
		print HCOUT ("\#amino acid counts per hydropathy of the neighbourhood\n\t".join("\t",@abc)."\tstop");
		for $row ($Hmin..$Hmax) {
			$calc=($row)/$Hstep-5; 	print HCOUT "\n$calc\t"; $freqtally=0;
			print HCOUT (join("\t",zeroed(\@{$counthydro[$row]}))."\t".$counthydro[$row][25]);
		} 
		
		print HCOUT ("\n\n\#amino acid frequencies per hydropathy of the neighbourhood\n\t".join("\t",@abc)."\tstop");
		for $row ($Hmin..$Hmax) {
			$calc=($row)/$Hstep-5; 	print HCOUT "\n$calc\t"; $freqtally=0;
			for ($col=0;$col<=25;$col++) {$freqtally+=$counthydro[$row][$col];}
			if ($freqtally==0) {
				@{$hydros[$row]}=map {0} (0..25);} 
			else {
				@{$hydros[$row]}=map {$counthydro[$row][$_]/$freqtally;} (0..25);
			}
			print HCOUT (join("\t",zeroed(\@{$hydros[$row]}))."\t".$hydros[$row][25]);
		}
		
		print "Saving $file...\n";
		close HCOUT;
		
		
		print MASTER ("#########Hydropathy\n");
		for $l ($Hmin..$Hmax) {
			for $k (0,2..8,10..13,15..19,21,22,24) {
				print MASTER (chr($k+65)." i\:".($l/$Hstep-5)."\t$avghydro[$l][$k]\t$devhydro[$l][$k]\t$skewhydro[$l][$k]\t$kurthydro[$l][$k]\n"); ########## MASTERLIST
			}
		}
		for $l ($Hmin..$Hmax) {
			print MASTER ("Stop i\:".($l/$Hstep-5)."\t$avghydro[$l][25]\t$devhydro[$l][25]\t$skewhydro[$l][25]\t$kurthydro[$l][25]\n"); ########## MASTERLIST
		}
		for $l ($Hmin..$Hmax) {
			print MASTER ("Distribution i\:".($l/$Hstep-5)."\t$omniavghydro[$l]\t$omnidevhydro[$l]\t$omniskewhydro[$l]\t$omnikurthydro[$l]\t$blanklesshydro[$l]\n"); ########## MASTERLIST
			
			
			@freqhydro=(); #save memory...
		}
		
		
	} else {
		$file="analysis/".$ecprefix."hydropath.txt";	
		open(HCIN,$file) 	or die "Can't open reading file: $!";
		@hydroline=<HCIN>;
		close HCIN;
		for $row ($Hmin..$Hmax) {
			@hydroword=split(/\t/,$hydroline[$row+1]);
			
			$n=0;
			for $abacus (0,2..8,10..13,15..19,21,22,24) {$n++;$counthydro[$row][$abacus]=$hydroword[$n];}
		} 
		
	} # hydropath end
	
	
	######################MATRIX###########################################################
	if ($disable !~ m/M/) {
		print "Calculating amino acid pair matrices...\n";
		# calculate freq matrix	
		for ($n=0;$n<=$#gene;$n++)	{
			for $i (0..$#{$aa[$n]}) {$matrix[$char[$n][$i]][$char[$n][$i+1]]++;$genematrix[$char[$n][$i]][$char[$n][$i+1]][$n]++;}
			for $ante (0,2..8,10..13,15..19,21,22,24) {
				for $post (0,2..8,10..13,15..19,21,22,24) {$gefrematrix[$ante][$post][$n]=$genematrix[$ante][$post][$n]/$len[$n];
				}} #antepost
		}#layer matrix maker
		
		$file=">analysis/".$ecprefix."matrixcounts.txt";	
		open(AMOUT,$file) 	or die "Can't open file: $!";
		print AMOUT "\#amino acid pair count\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $x (0,2..8,10..13,15..19,21,22,24) {
			print AMOUT "\n".chr(65+$x)."\t".join("\t",zeroed(\@{$matrix[$x]}));
		}
		print AMOUT "\n";
		
		print AMOUT "\n\#amino acid pair freq avg\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				for $layer (0..$tg) {$avgmatrix[$ante][$post]+=$gefrematrix[$ante][$post][$layer]/$tg;} 
				print AMOUT "\t".$avgmatrix[$ante][$post];}}
		print AMOUT "\n";
		
		print AMOUT "\n\#amino acid pair stdev\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				for $layer (0..$#gene) {
					$devmatrix[$ante][$post]+=($gefrematrix[$ante][$post][$layer]-$avgmatrix[$ante][$post])**2;
					$skewmatrix[$ante][$post]+=($gefrematrix[$ante][$post][$layer]-$avgmatrix[$ante][$post])**3;
					$kurtmatrix[$ante][$post]+=($gefrematrix[$ante][$post][$layer]-$avgmatrix[$ante][$post])**4;
				}
				$devmatrix[$ante][$post]=sqrt($devmatrix[$ante][$post]/$tg); print AMOUT "\t".$devmatrix[$ante][$post];
				if ($devmatrix[$ante][$post]>0) {
					$skewmatrix[$ante][$post]=$skewmatrix[$ante][$post]/($tg*$devmatrix[$ante][$post]**3); 
					$kurtmatrix[$ante][$post]=$kurtmatrix[$ante][$post]/($tg*$devmatrix[$ante][$post]**4)-3;}
			}
		}
		print AMOUT "\n";
		
		
		#Fitting data...
		#$counts[HYDROPHOBIC INDEX][A-Z]
		for $i ( 0 .. $#counthydro ) {
			for $j ( 0 .. $#{$counthydro[$i]} ) {
				$totalaa+=$counthydro[$i][$j];
			}
		}
		
		for $i ( 0 .. $#counthydro ) {
			for $j ( 0 .. $#{$counthydro[$i]} ) {
				$hydrofreq[$i][$j]=$counthydro[$i][$j]/$totalaa;
				$aafreq[$j]+=($counthydro[$i][$j]/$totalaa);
			}
		}
		
		
		for $i ( 0 .. 25 ) {
			for $j ( 0 .. 25 ) {
				for $k ($Hmin..$Hmax) {
					#HYDRO
					$fitmatrix[$i][$j]+=($hydrofreq[$k][$i]*$hydrofreq[$k][$j]);
					$dodgycheck+=$hydrofreq[$k][$i]*$hydrofreq[$k][$j];
				}
				#NON
				$unfitmatrix[$i][$j]=($aafreq[$j]*$aafreq[$i]);
			}
		}
		
		
		#### need to fix this sooner or later...	
		if ($dodgycheck>0) {
			for $i ( 0 .. 25 ) {
				for $j ( 0 .. 25 ) {
					$fitmatrix[$i][$j]=$fitmatrix[$i][$j]/$dodgycheck;
				}
			}	
		}
		
		
		
		
		
		print AMOUT "\n\#simple expected dataset (pi x pj)\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				print AMOUT "\t".$unfitmatrix[$ante][$post];}}
		print AMOUT "\n";	
		
		
		print AMOUT "\n\#simple fit amino acid pair tvalue (one sample against fit)\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				if ($devmatrix[$ante][$post] !=0){$untmatrix[$ante][$post]=($avgmatrix[$ante][$post]-($unfitmatrix[$ante][$post]))/($devmatrix[$ante][$post]/sqrt($tg));} else {$untmatrix[$ante][$post]=0;}  print AMOUT "\t".$untmatrix[$ante][$post];}}
		print AMOUT "\n";
		
		print AMOUT "\n\#amino acid pair ttest pvalue (one sample against simple fit)\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				$untpmatrix[$ante][$post]=tprob(($tg-1),abs($untmatrix[$ante][$post])); print AMOUT "\t".$untpmatrix[$ante][$post];}}
		print AMOUT "\n";
		
		
		print AMOUT "\n\#hydrophobicity corrected expected dataset (with dodgy fix)\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				print AMOUT "\t".$fitmatrix[$ante][$post];}}
		print AMOUT "\n";
		
		print AMOUT "\n\#amino acid pair tvalue (one sample against fit)\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				if ($devmatrix[$ante][$post] !=0){$tmatrix[$ante][$post]=($avgmatrix[$ante][$post]-($fitmatrix[$ante][$post]))/($devmatrix[$ante][$post]/sqrt($tg));} else {$tmatrix[$ante][$post]=0; print "WARNING: ".chr($ante+65).chr($post+65)." pair appears only once\n";} print AMOUT "\t".$tmatrix[$ante][$post];}}
		print AMOUT "\n";
		
		print AMOUT "\n\#amino acid pair ttest pvalue\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				$tpmatrix[$ante][$post]=tprob(($tg-1),abs($tmatrix[$ante][$post])); print AMOUT "\t".$tpmatrix[$ante][$post];}}
		print AMOUT "\n";
		
		print AMOUT "\n\#amino acid assymetry (ttest pvalues)\nvv1nd 2st\>\>\t";
		print AMOUT join("\t",@abc);
		for $ante (0,2..8,10..13,15..19,21,22,24) {print AMOUT "\n".chr(65+$ante);
			for $post (0,2..8,10..13,15..19,21,22,24) {
				if (($devmatrix[$ante][$post] !=0) && ($devmatrix[$post][$ante] !=0)) {$tassmatrix[$ante][$post]=($devmatrix[$ante][$post]-$devmatrix[$post][$ante])/((sqrt(($devmatrix[$ante][$post]**2+$devmatrix[$post][$ante]**2)/2))*(sqrt(2/$tg)));
					$passmatrix[$ante][$post]=tprob((2*$tg-2),abs($tassmatrix[$ante][$post]));} print AMOUT "\t".$passmatrix[$ante][$post];
			}}
		print AMOUT "\n";
		
		$j=0;
		print MASTER ("\#Dipeptides\n");
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				print MASTER (chr(65+$ante).chr(65+$post)."\t$avgmatrix[$post][$ante]\t$devmatrix[$post][$ante]\t$skewmatrix[$post][$ante]\t$kurtmatrix[$post][$ante]\t$untmatrix[$ante][$post]\t$untpmatrix[$ante][$post]\n");
				$Ultimus[243+$j][$Whom]=$avgmatrix[$post][$ante];
				$Exodus[212+$j][$Whom]=$avgmatrix[$post][$ante];
				$j++;
			}
		}
		$Ultimus[643][$Whom]="---";
		$j=0;
		print MASTER ("\#Dipeptide Assymetry (T-test t value and p-value\n");
		for $ante (0,2..8,10,11) {
			for $post (12,13,15..19,21,22,24) {
				print MASTER (chr(65+$ante).chr(65+$post)."\t$tassmatrix[$ante][$post]\t$passmatrix[$ante][$post]\n");
				$Ultimus[644+$j][$Whom]=$tassmatrix[$ante][$post];
				$j++;
			}
		}
		$Ultimus[744][$Whom]="---";
		
		$j=0;
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				if ($ante<$post) {
					$Exodus[612+$j][$Whom]=$tassmatrix[$ante][$post];
					$j++;
				}
			}
		}
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				$Exodus[612+$j][$Whom]=$untmatrix[$ante][$post];
			}
		}
		
		
		
		print "Saving $file...\n";
		close AMOUT;
		@genematrix=(); #save some memory
		
		
		
		
	}#####MATRIX END
	if (($disable !~ m/M/msg) && ($disable !~ m/O/msg) && ($disable !~ m/C/msg)) {
		print "Calculating amino acid pair in relation to Cog categories...\n";
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				for ($n=0;$n<=$#gene;$n++)	{
					if (length($gene[$n][21])>0) {
						$cogfrematrix[$ante][$post][ord($gene[$n][21])-65]+=$gefrematrix[$ante][$post][$n];$divisor[$ante][$post][ord($gene[$n][21])-65]++;
					}
				}
				for $cate (0..25) { #@{$cogfrematrix[$ante][$post]}...
					if ($divisor[$ante][$post][$cate]>0) {$cogfrematrix[$ante][$post][$cate]=$cogfrematrix[$ante][$post][$cate]/$divisor[$ante][$post][$cate]++;} else {$cogfrematrix[$ante][$post][$cate]=0;}
				}
			}
		}
		
		
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $post (0,2..8,10..13,15..19,21,22,24) {
				for ($n=0;$n<=$#gene;$n++)	{
					if (length($gene[$n][21])>0) {
						$cogdevmatrix[$ante][$post][ord($gene[$n][21])-65]+=($gefrematrix[$ante][$post][$n]-$cogfrematrix[$ante][$post][ord($gene[$n][21])-65])**2;
						$cogskewmatrix[$ante][$post][ord($gene[$n][21])-65]+=($gefrematrix[$ante][$post][$n]-$cogfrematrix[$ante][$post][ord($gene[$n][21])-65])**3;
						$cogkurtmatrix[$ante][$post][ord($gene[$n][21])-65]+=($gefrematrix[$ante][$post][$n]-$cogfrematrix[$ante][$post][ord($gene[$n][21])-65])**4;
					}
				}
				for $cate (0..25) {
					if ($divisor[$ante][$post][$cate]>0) {$cogdevmatrix[$ante][$post][$cate]=sqrt($cogdevmatrix[$ante][$post][$cate]/$divisor[$ante][$post][$cate]);
						if($cogdevmatrix[$ante][$post][$cate]>0){
							$cogskewmatrix[$ante][$post][$cate]=($cogskewmatrix[$ante][$post][$cate]/($divisor[$ante][$post][$cate]*$cogdevmatrix[$ante][$post][$cate]**3));
							$cogkurtmatrix[$ante][$post][$cate]=($cogkurtmatrix[$ante][$post][$cate]/($divisor[$ante][$post][$cate]*$cogdevmatrix[$ante][$post][$cate]**4)-3);
						}
					} else {$cogdevmatrix[$ante][$post][$cate]=0;}
				}
			}
		}
		
		
		$file=">analysis/".$ecprefix."cogmatrix.txt";	
		open(CMOUT,$file) 	or die "Can't open file: $!";
		print CMOUT "\n";
		for $alpha (0..25) {
			print CMOUT "\n\n\#CATEGORY:".$Cats[$alpha]."\n\tAvg";
			print CMOUT join("\t",@abc)."\tStDev\t".join("\t",@abc);
			for $ante (0,2..8,10..13,15..19,21,22,24) {
				print CMOUT "\n".chr(65+$ante);
				for $post (0,2..8,10..13,15..19,21,22,24) {
					print CMOUT "\t".$cogfrematrix[$ante][$post][$alpha]."\t\t".$cogdevmatrix[$ante][$post][$alpha];
				}
			}
		}
		print MASTER "\#AA Pairs and categories\n";
		for $alpha (0..25) {
			for $ante (0,2..8,10..13,15..19,21,22,24) {
				for $post (0,2..8,10..13,15..19,21,22,24) {
					print MASTER ("Cat:".chr(65+$alpha)." ".chr(65+$ante).chr(65+$post)."\t$cogfrematrix[$ante][$post][$alpha]\t$cogdevmatrix[$ante][$post][$alpha]\t$cogskewmatrix[$ante][$post][$alpha]\t$cogkurtmatrix[$ante][$post][$alpha]\n");
				}
			}
		}
		
		
		
		print CMOUT "\n";
		print "Saving $file...\n";
		close CMOUT;
		@cogfrematrix=();
		@cogdevmatrix=();
		
		
	} # end of MOC
	
	
	### tri tensor printouts
	if ($disable !~ m/N/) {
		print "Calculating amino acid triplet tensors...\n";
		# calculate freq matrix
		for ($n=0;$n<=$#gene;$n++)	{
			for $i (0..$#{$aa[$n]}) {$gftensor[$n][$char[$n][$i]][$char[$n][$i+1]][$char[$n][$i+2]]+=(1/($#{$aa[$n]}));$ftensor[$char[$n][$i]][$char[$n][$i+1]][$char[$n][$i+2]]+=(1/($#{$aa[$n]}*$tg));}
		}#layer matrix maker
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $mid (0,2..8,10..13,15..19,21,22,24) {
				for $post (0,2..8,10..13,15..19,21,22,24) {
					for ($n=0;$n<=$#gene;$n++)	{
						$sdtensor[$ante][$mid][$post]+=($gftensor[$n][$ante][$mid][$post]-$ftensor[$ante][$mid][$post])**2;
						$skewtensor[$ante][$mid][$post]+=($gftensor[$n][$ante][$mid][$post]-$ftensor[$ante][$mid][$post])**3;
						$kurttensor[$ante][$mid][$post]+=($gftensor[$n][$ante][$mid][$post]-$ftensor[$ante][$mid][$post])**4;
					}
					$sdtensor[$ante][$mid][$post]=sqrt($sdtensor[$ante][$mid][$post]/$tg);
					if ($sdtensor[$ante][$mid][$post]>0) {
						$skewtensor[$ante][$mid][$post]=($skewtensor[$ante][$mid][$post]/($tg*$sdtensor[$ante][$mid][$post]**3));
						$kurttensor[$ante][$mid][$post]=($kurttensor[$ante][$mid][$post]/($tg*$sdtensor[$ante][$mid][$post]**4));
					}
				}
			}
		}
		print MASTER "\#tripeptides\n";
		$j=0;
		$file=">analysis/".$ecprefix."tensorlist.txt";	
		open(LISTOUT,$file) 	or die "Can't open file: $!";
		print LISTOUT "\#amino acid triplet count\nTriplet\tAvg freq\tStDev\n";
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $mid (0,2..8,10..13,15..19,21,22,24) {
				for $post (0,2..8,10..13,15..19,21,22,24) {
					print LISTOUT chr(65+$ante).chr(65+$mid).chr(65+$post)."\t".$ftensor[$ante][$mid][$post]."\t".$sdtensor[$ante][$mid][$post]."\t".$skewtensor[$ante][$mid][$post]."\t".$kurttensor[$ante][$mid][$post]."\n";
					print MASTER chr(65+$ante).chr(65+$mid).chr(65+$post)."\t".$ftensor[$ante][$mid][$post]."\t".$sdtensor[$ante][$mid][$post]."\t".$skewtensor[$ante][$mid][$post]."\t".$kurttensor[$ante][$mid][$post]."\n";
					$Ultimus[745+$j][$Whom]=$ftensor[$ante][$mid][$post];
					$j++;
				}
			}
		}
		
		print LISTOUT "\n";
		close LISTOUT;
		@gftensor=();
		@sdtensor=();
		@ftensor=();
	}	## end of tensor
	
	### quad tensor
	if ($disable !~ m/N/) {
		print "Calculating amino acid quadruplet tensors...\n";
		# calculate freq matrix
		for ($n=0;$n<=$#gene;$n++)	{
			for $i (0..$#{$aa[$n]}) {
				$fqtensor[$char[$n][$i]][$char[$n][$i+1]][$char[$n][$i+2]][$char[$n][$i+3]]+=(1/($#{$aa[$n]}*$tg));}
		}#layer matrix maker
		
		print MASTER "\#quadruplets\n";
		$j=0;
		for $ante (0,2..8,10..13,15..19,21,22,24) {
			for $amid (0,2..8,10..13,15..19,21,22,24) {
				for $pmid (0,2..8,10..13,15..19,21,22,24) {
					for $post (0,2..8,10..13,15..19,21,22,24) {
						$Ultimus[8746+$j][$Whom]=$fqtensor[$ante][$amid][$pmid][$post];
						$j++;
				}
				}
			}
		}
		
		@fqtensor=();
	}	## end of tensor
	
	
	
	
	##########Size matters###################
	if ($disable !~m/s/i) {
		print "Calculating distributions in relation to protein length...\n";
		
		# calculate size	
		for ($n=0;$n<=$#gene;$n++)	{
			$leiosizedist[int($len[$n]/$Sstep+0.5)]++;
			$sizedist[int($len[$n])]++;
			for ($m=0;$m<=$#{$aa[$n]};$m++) {
				$aadist[int($len[$n])][$char[$n][$m]]++;
				$leioaadist[int($len[$n]/$Sstep+0.5)][$char[$n][$m]]++;
				$leioaaavg[int($len[$n]/$Sstep+0.5)][$char[$n][$m]]+=(1/($len[$n]*$tg));
				$leioaafreq[$n][int($len[$n]/$Sstep+0.5)][$char[$n][$m]]+=(1/($len[$n]));
			}
		}#gene loop
		
		for ($n=0;$n<=$#gene;$n++) {
			for $x (0..$#leiosizedist) {
				for $y (0,2..8,10..13,15..19,21,22,24) {
					$leioaadev[$x][$y]+=($leioaafreq[$n][$x][$y]-$leioaaavg[$x][$y])**2;
					$leioaaskew[$x][$y]+=($leioaafreq[$n][$x][$y]-$leioaaavg[$x][$y])**3;
					$leioaakurt[$x][$y]+=($leioaafreq[$n][$x][$y]-$leioaaavg[$x][$y])**4;
				}
			}
		}
		
		$leioaadev[$x][$y]=sqrt($leioaadev[$x][$y]/$tg);
		if ($leioaadev[$x][$y]>0) {$leioaaskew[$x][$y]=($leioaaskew[$x][$y]/($tg*$leioaadev[$x][$y]**3));
			$leioaakurt[$x][$y]=($leioaakurt[$x][$y]/($tg*$leioaadev[$x][$y]**4))-3;} else {$leioaaskew[$x][$y]="\#";$leioaakurt[$x][$y]="\#";}
		
		print MASTER "\#size";
		$file=">analysis/".$ecprefix."size.txt";	
		open(SIZE,$file) 	or die "Can't open file: $!";
		print SIZE "\#amino acid counts per size rounded to 10\n\t";
		print SIZE join("\t",@abc)."\tNumber of protein\n";
		for $x (0..$#leiosizedist) {print SIZE $x*$Sstep;$yy=0;
			for $y (0,2..8,10..13,15..19,21,22,24) {print SIZE "\t$leioaadist[$x][$y]"; print MASTER ($Abc[$yy]." \@".($x*$Sstep)."length\t$leioaaavg[$x][$y]\t$leioaadev[$x][$y]\t$leioaaskew[$x][$y]\t$leioaakurt[$x][$y]\n");$yy++;}
			print SIZE "\t$leiosizedist[$x]\n";}
		print SIZE "\n";
		
		print SIZE "\n\#amino acid counts per size (unrounded)\n\t";
		print SIZE join("\t",@abc)."\tTotal\n";
		for $x (0..$#sizedist) {print SIZE $x;
			for $y (0,2..8,10..13,15..19,21,22,24) {print SIZE "\t$aadist[$x][$y]";
			}
			print SIZE "\t$sizedist[$x]\n";}
		print SIZE "\n";
		print "Saving $file...\n";
		close SIZE;
		
		
		
	}#end of size
	
	close MASTER;
	$Whom++;
VORTEX:
} ###for each org!

open(ULTIMA,'>list.txt') 	or die "Can't create file: $!";
open(PAIR,'>pair.txt') 	or die "Can't create file: $!";

@col=qw("" #_genes #matched_cog A C D E F G H I K L M N P Q R S T V W Y Stop - 2-tuplet 3-tuplet 4-tuplet 5-tuplet 6-tuplet 7-tuplet 8-tuplet 9-tuplet 10+-tuplet A_2-tuplet A_3-tuplet A_4-tuplet A_5-tuplet A_6-tuplet A_7-tuplet A_8-tuplet A_9-tuplet A_10+-tuplet C_2-tuplet C_3-tuplet C_4-tuplet C_5-tuplet C_6-tuplet C_7-tuplet C_8-tuplet C_9-tuplet C_10+-tuplet D_2-tuplet D_3-tuplet D_4-tuplet D_5-tuplet D_6-tuplet D_7-tuplet D_8-tuplet D_9-tuplet D_10+-tuplet E_2-tuplet E_3-tuplet E_4-tuplet E_5-tuplet E_6-tuplet E_7-tuplet E_8-tuplet E_9-tuplet E_10+-tuplet F_2-tuplet F_3-tuplet F_4-tuplet F_5-tuplet F_6-tuplet F_7-tuplet F_8-tuplet F_9-tuplet F_10+-tuplet G_2-tuplet G_3-tuplet G_4-tuplet G_5-tuplet G_6-tuplet G_7-tuplet G_8-tuplet G_9-tuplet G_10+-tuplet H_2-tuplet H_3-tuplet H_4-tuplet H_5-tuplet H_6-tuplet H_7-tuplet H_8-tuplet H_9-tuplet H_10+-tuplet I_2-tuplet I_3-tuplet I_4-tuplet I_5-tuplet I_6-tuplet I_7-tuplet I_8-tuplet I_9-tuplet I_10+-tuplet K_2-tuplet K_3-tuplet K_4-tuplet K_5-tuplet K_6-tuplet K_7-tuplet K_8-tuplet K_9-tuplet K_10+-tuplet L_2-tuplet L_3-tuplet L_4-tuplet L_5-tuplet L_6-tuplet L_7-tuplet L_8-tuplet L_9-tuplet L_10+-tuplet M_2-tuplet M_3-tuplet M_4-tuplet M_5-tuplet M_6-tuplet M_7-tuplet M_8-tuplet M_9-tuplet M_10+-tuplet N_2-tuplet N_3-tuplet N_4-tuplet N_5-tuplet N_6-tuplet N_7-tuplet N_8-tuplet N_9-tuplet N_10+-tuplet P_2-tuplet P_3-tuplet P_4-tuplet P_5-tuplet P_6-tuplet P_7-tuplet P_8-tuplet P_9-tuplet P_10+-tuplet Q_2-tuplet Q_3-tuplet Q_4-tuplet Q_5-tuplet Q_6-tuplet Q_7-tuplet Q_8-tuplet Q_9-tuplet Q_10+-tuplet R_2-tuplet R_3-tuplet R_4-tuplet R_5-tuplet R_6-tuplet R_7-tuplet R_8-tuplet R_9-tuplet R_10+-tuplet S_2-tuplet S_3-tuplet S_4-tuplet S_5-tuplet S_6-tuplet S_7-tuplet S_8-tuplet S_9-tuplet S_10+-tuplet T_2-tuplet T_3-tuplet T_4-tuplet T_5-tuplet T_6-tuplet T_7-tuplet T_8-tuplet T_9-tuplet T_10+-tuplet V_2-tuplet V_3-tuplet V_4-tuplet V_5-tuplet V_6-tuplet V_7-tuplet V_8-tuplet V_9-tuplet V_10+-tuplet W_2-tuplet W_3-tuplet W_4-tuplet W_5-tuplet W_6-tuplet W_7-tuplet W_8-tuplet W_9-tuplet W_10+-tuplet Y_2-tuplet Y_3-tuplet Y_4-tuplet Y_5-tuplet Y_6-tuplet Y_7-tuplet Y_8-tuplet Y_9-tuplet Y_10+-tuplet - A_(_RNA_processing_and_modification) B_(_Chromatin_structure_and_dynamics) C_(_Energy_production_and_conversion) D_(_Cell_cycle_control,_cell_division,_chromosome_partitioning) E_(_Amino_acid_transport_and_metabolism) F_(_Nucleotide_transport_and_metabolism) G_(_Carbohydrate_transport_and_metabolism) H_(_Coenzyme_transport_and_metabolism) I_(_Lipid_transport_and_metabolism) J_(_Translation,_ribosomal_structure_and_biogenesis) K_(_Transcription) L_(_Replication,_recombination_and_repair) M_(_Cell_wall/membrane/envelope_biogenesis) N_(_Cell_motility) O_(_Posttranslational_modification,_protein_turnover,_chaperones) P_(_Inorganic_ion_transport_and_metabolism) Q_(_Secondary_metabolites_biosynthesis,_transport_and_catabolism) R_(_General_function_prediction_only) S_(_Function_unknown) T_(_Signal_transduction_mechanisms) U_(_Intracellular_trafficking,_secretion,_and_vesicular_transport) V_(_Defense_mechanisms) W_(_Extracellular_structures) X_(Blank) Y_(_Nuclear_structure) Z_(_Cytoskeleton) Not_COG - AA AC AD AE AF AG AH AI AK AL AM AN AP AQ AR AS AT AV AW AY CA CC CD CE CF CG CH CI CK CL CM CN CP CQ CR CS CT CV CW CY DA DC DD DE DF DG DH DI DK DL DM DN DP DQ DR DS DT DV DW DY EA EC ED EE EF EG EH EI EK EL EM EN EP EQ ER ES ET EV EW EY FA FC FD FE FF FG FH FI FK FL FM FN FP FQ FR FS FT FV FW FY GA GC GD GE GF GG GH GI GK GL GM GN GP GQ GR GS GT GV GW GY HA HC HD HE HF HG HH HI HK HL HM HN HP HQ HR HS HT HV HW HY IA IC ID IE IF IG IH II IK IL IM IN IP IQ IR IS IT IV IW IY KA KC KD KE KF KG KH KI KK KL KM KN KP KQ KR KS KT KV KW KY LA LC LD LE LF LG LH LI LK LL LM LN LP LQ LR LS LT LV LW LY MA MC MD ME MF MG MH MI MK ML MM MN MP MQ MR MS MT MV MW MY NA NC ND NE NF NG NH NI NK NL NM NN NP NQ NR NS NT NV NW NY PA PC PD PE PF PG PH PI PK PL PM PN PP PQ PR PS PT PV PW PY QA QC QD QE QF QG QH QI QK QL QM QN QP QQ QR QS QT QV QW QY RA RC RD RE RF RG RH RI RK RL RM RN RP RQ RR RS RT RV RW RY SA SC SD SE SF SG SH SI SK SL SM SN SP SQ SR SS ST SV SW SY TA TC TD TE TF TG TH TI TK TL TM TN TP TQ TR TS TT TV TW TY VA VC VD VE VF VG VH VI VK VL VM VN VP VQ VR VS VT VV VW VY WA WC WD WE WF WG WH WI WK WL WM WN WP WQ WR WS WT WV WW WY YA YC YD YE YF YG YH YI YK YL YM YN YP YQ YR YS YT YV YW YY - AM_assym. AN_assym. AP_assym. AQ_assym. AR_assym. AS_assym. AT_assym. AV_assym. AW_assym. AY_assym. CM_assym. CN_assym. CP_assym. CQ_assym. CR_assym. CS_assym. CT_assym. CV_assym. CW_assym. CY_assym. DM_assym. DN_assym. DP_assym. DQ_assym. DR_assym. DS_assym. DT_assym. DV_assym. DW_assym. DY_assym. EM_assym. EN_assym. EP_assym. EQ_assym. ER_assym. ES_assym. ET_assym. EV_assym. EW_assym. EY_assym. FM_assym. FN_assym. FP_assym. FQ_assym. FR_assym. FS_assym. FT_assym. FV_assym. FW_assym. FY_assym. GM_assym. GN_assym. GP_assym. GQ_assym. GR_assym. GS_assym. GT_assym. GV_assym. GW_assym. GY_assym. HM_assym. HN_assym. HP_assym. HQ_assym. HR_assym. HS_assym. HT_assym. HV_assym. HW_assym. HY_assym. IM_assym. IN_assym. IP_assym. IQ_assym. IR_assym. IS_assym. IT_assym. IV_assym. IW_assym. IY_assym. KM_assym. KN_assym. KP_assym. KQ_assym. KR_assym. KS_assym. KT_assym. KV_assym. KW_assym. KY_assym. LM_assym. LN_assym. LP_assym. LQ_assym. LR_assym. LS_assym. LT_assym. LV_assym. LW_assym. LY_assym. - AAA AAC AAD AAE AAF AAG AAH AAI AAK AAL AAM AAN AAP AAQ AAR AAS AAT AAV AAW AAY ACA ACC ACD ACE ACF ACG ACH ACI ACK ACL ACM ACN ACP ACQ ACR ACS ACT ACV ACW ACY ADA ADC ADD ADE ADF ADG ADH ADI ADK ADL ADM ADN ADP ADQ ADR ADS ADT ADV ADW ADY AEA AEC AED AEE AEF AEG AEH AEI AEK AEL AEM AEN AEP AEQ AER AES AET AEV AEW AEY AFA AFC AFD AFE AFF AFG AFH AFI AFK AFL AFM AFN AFP AFQ AFR AFS AFT AFV AFW AFY AGA AGC AGD AGE AGF AGG AGH AGI AGK AGL AGM AGN AGP AGQ AGR AGS AGT AGV AGW AGY AHA AHC AHD AHE AHF AHG AHH AHI AHK AHL AHM AHN AHP AHQ AHR AHS AHT AHV AHW AHY AIA AIC AID AIE AIF AIG AIH AII AIK AIL AIM AIN AIP AIQ AIR AIS AIT AIV AIW AIY AKA AKC AKD AKE AKF AKG AKH AKI AKK AKL AKM AKN AKP AKQ AKR AKS AKT AKV AKW AKY ALA ALC ALD ALE ALF ALG ALH ALI ALK ALL ALM ALN ALP ALQ ALR ALS ALT ALV ALW ALY AMA AMC AMD AME AMF AMG AMH AMI AMK AML AMM AMN AMP AMQ AMR AMS AMT AMV AMW AMY ANA ANC AND ANE ANF ANG ANH ANI ANK ANL ANM ANN ANP ANQ ANR ANS ANT ANV ANW ANY APA APC APD APE APF APG APH API APK APL APM APN APP APQ APR APS APT APV APW APY AQA AQC AQD AQE AQF AQG AQH AQI AQK AQL AQM AQN AQP AQQ AQR AQS AQT AQV AQW AQY ARA ARC ARD ARE ARF ARG ARH ARI ARK ARL ARM ARN ARP ARQ ARR ARS ART ARV ARW ARY ASA ASC ASD ASE ASF ASG ASH ASI ASK ASL ASM ASN ASP ASQ ASR ASS AST ASV ASW ASY ATA ATC ATD ATE ATF ATG ATH ATI ATK ATL ATM ATN ATP ATQ ATR ATS ATT ATV ATW ATY AVA AVC AVD AVE AVF AVG AVH AVI AVK AVL AVM AVN AVP AVQ AVR AVS AVT AVV AVW AVY AWA AWC AWD AWE AWF AWG AWH AWI AWK AWL AWM AWN AWP AWQ AWR AWS AWT AWV AWW AWY AYA AYC AYD AYE AYF AYG AYH AYI AYK AYL AYM AYN AYP AYQ AYR AYS AYT AYV AYW AYY CAA CAC CAD CAE CAF CAG CAH CAI CAK CAL CAM CAN CAP CAQ CAR CAS CAT CAV CAW CAY CCA CCC CCD CCE CCF CCG CCH CCI CCK CCL CCM CCN CCP CCQ CCR CCS CCT CCV CCW CCY CDA CDC CDD CDE CDF CDG CDH CDI CDK CDL CDM CDN CDP CDQ CDR CDS CDT CDV CDW CDY CEA CEC CED CEE CEF CEG CEH CEI CEK CEL CEM CEN CEP CEQ CER CES CET CEV CEW CEY CFA CFC CFD CFE CFF CFG CFH CFI CFK CFL CFM CFN CFP CFQ CFR CFS CFT CFV CFW CFY CGA CGC CGD CGE CGF CGG CGH CGI CGK CGL CGM CGN CGP CGQ CGR CGS CGT CGV CGW CGY CHA CHC CHD CHE CHF CHG CHH CHI CHK CHL CHM CHN CHP CHQ CHR CHS CHT CHV CHW CHY CIA CIC CID CIE CIF CIG CIH CII CIK CIL CIM CIN CIP CIQ CIR CIS CIT CIV CIW CIY CKA CKC CKD CKE CKF CKG CKH CKI CKK CKL CKM CKN CKP CKQ CKR CKS CKT CKV CKW CKY CLA CLC CLD CLE CLF CLG CLH CLI CLK CLL CLM CLN CLP CLQ CLR CLS CLT CLV CLW CLY CMA CMC CMD CME CMF CMG CMH CMI CMK CML CMM CMN CMP CMQ CMR CMS CMT CMV CMW CMY CNA CNC CND CNE CNF CNG CNH CNI CNK CNL CNM CNN CNP CNQ CNR CNS CNT CNV CNW CNY CPA CPC CPD CPE CPF CPG CPH CPI CPK CPL CPM CPN CPP CPQ CPR CPS CPT CPV CPW CPY CQA CQC CQD CQE CQF CQG CQH CQI CQK CQL CQM CQN CQP CQQ CQR CQS CQT CQV CQW CQY CRA CRC CRD CRE CRF CRG CRH CRI CRK CRL CRM CRN CRP CRQ CRR CRS CRT CRV CRW CRY CSA CSC CSD CSE CSF CSG CSH CSI CSK CSL CSM CSN CSP CSQ CSR CSS CST CSV CSW CSY CTA CTC CTD CTE CTF CTG CTH CTI CTK CTL CTM CTN CTP CTQ CTR CTS CTT CTV CTW CTY CVA CVC CVD CVE CVF CVG CVH CVI CVK CVL CVM CVN CVP CVQ CVR CVS CVT CVV CVW CVY CWA CWC CWD CWE CWF CWG CWH CWI CWK CWL CWM CWN CWP CWQ CWR CWS CWT CWV CWW CWY CYA CYC CYD CYE CYF CYG CYH CYI CYK CYL CYM CYN CYP CYQ CYR CYS CYT CYV CYW CYY DAA DAC DAD DAE DAF DAG DAH DAI DAK DAL DAM DAN DAP DAQ DAR DAS DAT DAV DAW DAY DCA DCC DCD DCE DCF DCG DCH DCI DCK DCL DCM DCN DCP DCQ DCR DCS DCT DCV DCW DCY DDA DDC DDD DDE DDF DDG DDH DDI DDK DDL DDM DDN DDP DDQ DDR DDS DDT DDV DDW DDY DEA DEC DED DEE DEF DEG DEH DEI DEK DEL DEM DEN DEP DEQ DER DES DET DEV DEW DEY DFA DFC DFD DFE DFF DFG DFH DFI DFK DFL DFM DFN DFP DFQ DFR DFS DFT DFV DFW DFY DGA DGC DGD DGE DGF DGG DGH DGI DGK DGL DGM DGN DGP DGQ DGR DGS DGT DGV DGW DGY DHA DHC DHD DHE DHF DHG DHH DHI DHK DHL DHM DHN DHP DHQ DHR DHS DHT DHV DHW DHY DIA DIC DID DIE DIF DIG DIH DII DIK DIL DIM DIN DIP DIQ DIR DIS DIT DIV DIW DIY DKA DKC DKD DKE DKF DKG DKH DKI DKK DKL DKM DKN DKP DKQ DKR DKS DKT DKV DKW DKY DLA DLC DLD DLE DLF DLG DLH DLI DLK DLL DLM DLN DLP DLQ DLR DLS DLT DLV DLW DLY DMA DMC DMD DME DMF DMG DMH DMI DMK DML DMM DMN DMP DMQ DMR DMS DMT DMV DMW DMY DNA DNC DND DNE DNF DNG DNH DNI DNK DNL DNM DNN DNP DNQ DNR DNS DNT DNV DNW DNY DPA DPC DPD DPE DPF DPG DPH DPI DPK DPL DPM DPN DPP DPQ DPR DPS DPT DPV DPW DPY DQA DQC DQD DQE DQF DQG DQH DQI DQK DQL DQM DQN DQP DQQ DQR DQS DQT DQV DQW DQY DRA DRC DRD DRE DRF DRG DRH DRI DRK DRL DRM DRN DRP DRQ DRR DRS DRT DRV DRW DRY DSA DSC DSD DSE DSF DSG DSH DSI DSK DSL DSM DSN DSP DSQ DSR DSS DST DSV DSW DSY DTA DTC DTD DTE DTF DTG DTH DTI DTK DTL DTM DTN DTP DTQ DTR DTS DTT DTV DTW DTY DVA DVC DVD DVE DVF DVG DVH DVI DVK DVL DVM DVN DVP DVQ DVR DVS DVT DVV DVW DVY DWA DWC DWD DWE DWF DWG DWH DWI DWK DWL DWM DWN DWP DWQ DWR DWS DWT DWV DWW DWY DYA DYC DYD DYE DYF DYG DYH DYI DYK DYL DYM DYN DYP DYQ DYR DYS DYT DYV DYW DYY EAA EAC EAD EAE EAF EAG EAH EAI EAK EAL EAM EAN EAP EAQ EAR EAS EAT EAV EAW EAY ECA ECC ECD ECE ECF ECG ECH ECI ECK ECL ECM ECN ECP ECQ ECR ECS ECT ECV ECW ECY EDA EDC EDD EDE EDF EDG EDH EDI EDK EDL EDM EDN EDP EDQ EDR EDS EDT EDV EDW EDY EEA EEC EED EEE EEF EEG EEH EEI EEK EEL EEM EEN EEP EEQ EER EES EET EEV EEW EEY EFA EFC EFD EFE EFF EFG EFH EFI EFK EFL EFM EFN EFP EFQ EFR EFS EFT EFV EFW EFY EGA EGC EGD EGE EGF EGG EGH EGI EGK EGL EGM EGN EGP EGQ EGR EGS EGT EGV EGW EGY EHA EHC EHD EHE EHF EHG EHH EHI EHK EHL EHM EHN EHP EHQ EHR EHS EHT EHV EHW EHY EIA EIC EID EIE EIF EIG EIH EII EIK EIL EIM EIN EIP EIQ EIR EIS EIT EIV EIW EIY EKA EKC EKD EKE EKF EKG EKH EKI EKK EKL EKM EKN EKP EKQ EKR EKS EKT EKV EKW EKY ELA ELC ELD ELE ELF ELG ELH ELI ELK ELL ELM ELN ELP ELQ ELR ELS ELT ELV ELW ELY EMA EMC EMD EME EMF EMG EMH EMI EMK EML EMM EMN EMP EMQ EMR EMS EMT EMV EMW EMY ENA ENC END ENE ENF ENG ENH ENI ENK ENL ENM ENN ENP ENQ ENR ENS ENT ENV ENW ENY EPA EPC EPD EPE EPF EPG EPH EPI EPK EPL EPM EPN EPP EPQ EPR EPS EPT EPV EPW EPY EQA EQC EQD EQE EQF EQG EQH EQI EQK EQL EQM EQN EQP EQQ EQR EQS EQT EQV EQW EQY ERA ERC ERD ERE ERF ERG ERH ERI ERK ERL ERM ERN ERP ERQ ERR ERS ERT ERV ERW ERY ESA ESC ESD ESE ESF ESG ESH ESI ESK ESL ESM ESN ESP ESQ ESR ESS EST ESV ESW ESY ETA ETC ETD ETE ETF ETG ETH ETI ETK ETL ETM ETN ETP ETQ ETR ETS ETT ETV ETW ETY EVA EVC EVD EVE EVF EVG EVH EVI EVK EVL EVM EVN EVP EVQ EVR EVS EVT EVV EVW EVY EWA EWC EWD EWE EWF EWG EWH EWI EWK EWL EWM EWN EWP EWQ EWR EWS EWT EWV EWW EWY EYA EYC EYD EYE EYF EYG EYH EYI EYK EYL EYM EYN EYP EYQ EYR EYS EYT EYV EYW EYY FAA FAC FAD FAE FAF FAG FAH FAI FAK FAL FAM FAN FAP FAQ FAR FAS FAT FAV FAW FAY FCA FCC FCD FCE FCF FCG FCH FCI FCK FCL FCM FCN FCP FCQ FCR FCS FCT FCV FCW FCY FDA FDC FDD FDE FDF FDG FDH FDI FDK FDL FDM FDN FDP FDQ FDR FDS FDT FDV FDW FDY FEA FEC FED FEE FEF FEG FEH FEI FEK FEL FEM FEN FEP FEQ FER FES FET FEV FEW FEY FFA FFC FFD FFE FFF FFG FFH FFI FFK FFL FFM FFN FFP FFQ FFR FFS FFT FFV FFW FFY FGA FGC FGD FGE FGF FGG FGH FGI FGK FGL FGM FGN FGP FGQ FGR FGS FGT FGV FGW FGY FHA FHC FHD FHE FHF FHG FHH FHI FHK FHL FHM FHN FHP FHQ FHR FHS FHT FHV FHW FHY FIA FIC FID FIE FIF FIG FIH FII FIK FIL FIM FIN FIP FIQ FIR FIS FIT FIV FIW FIY FKA FKC FKD FKE FKF FKG FKH FKI FKK FKL FKM FKN FKP FKQ FKR FKS FKT FKV FKW FKY FLA FLC FLD FLE FLF FLG FLH FLI FLK FLL FLM FLN FLP FLQ FLR FLS FLT FLV FLW FLY FMA FMC FMD FME FMF FMG FMH FMI FMK FML FMM FMN FMP FMQ FMR FMS FMT FMV FMW FMY FNA FNC FND FNE FNF FNG FNH FNI FNK FNL FNM FNN FNP FNQ FNR FNS FNT FNV FNW FNY FPA FPC FPD FPE FPF FPG FPH FPI FPK FPL FPM FPN FPP FPQ FPR FPS FPT FPV FPW FPY FQA FQC FQD FQE FQF FQG FQH FQI FQK FQL FQM FQN FQP FQQ FQR FQS FQT FQV FQW FQY FRA FRC FRD FRE FRF FRG FRH FRI FRK FRL FRM FRN FRP FRQ FRR FRS FRT FRV FRW FRY FSA FSC FSD FSE FSF FSG FSH FSI FSK FSL FSM FSN FSP FSQ FSR FSS FST FSV FSW FSY FTA FTC FTD FTE FTF FTG FTH FTI FTK FTL FTM FTN FTP FTQ FTR FTS FTT FTV FTW FTY FVA FVC FVD FVE FVF FVG FVH FVI FVK FVL FVM FVN FVP FVQ FVR FVS FVT FVV FVW FVY FWA FWC FWD FWE FWF FWG FWH FWI FWK FWL FWM FWN FWP FWQ FWR FWS FWT FWV FWW FWY FYA FYC FYD FYE FYF FYG FYH FYI FYK FYL FYM FYN FYP FYQ FYR FYS FYT FYV FYW FYY GAA GAC GAD GAE GAF GAG GAH GAI GAK GAL GAM GAN GAP GAQ GAR GAS GAT GAV GAW GAY GCA GCC GCD GCE GCF GCG GCH GCI GCK GCL GCM GCN GCP GCQ GCR GCS GCT GCV GCW GCY GDA GDC GDD GDE GDF GDG GDH GDI GDK GDL GDM GDN GDP GDQ GDR GDS GDT GDV GDW GDY GEA GEC GED GEE GEF GEG GEH GEI GEK GEL GEM GEN GEP GEQ GER GES GET GEV GEW GEY GFA GFC GFD GFE GFF GFG GFH GFI GFK GFL GFM GFN GFP GFQ GFR GFS GFT GFV GFW GFY GGA GGC GGD GGE GGF GGG GGH GGI GGK GGL GGM GGN GGP GGQ GGR GGS GGT GGV GGW GGY GHA GHC GHD GHE GHF GHG GHH GHI GHK GHL GHM GHN GHP GHQ GHR GHS GHT GHV GHW GHY GIA GIC GID GIE GIF GIG GIH GII GIK GIL GIM GIN GIP GIQ GIR GIS GIT GIV GIW GIY GKA GKC GKD GKE GKF GKG GKH GKI GKK GKL GKM GKN GKP GKQ GKR GKS GKT GKV GKW GKY GLA GLC GLD GLE GLF GLG GLH GLI GLK GLL GLM GLN GLP GLQ GLR GLS GLT GLV GLW GLY GMA GMC GMD GME GMF GMG GMH GMI GMK GML GMM GMN GMP GMQ GMR GMS GMT GMV GMW GMY GNA GNC GND GNE GNF GNG GNH GNI GNK GNL GNM GNN GNP GNQ GNR GNS GNT GNV GNW GNY GPA GPC GPD GPE GPF GPG GPH GPI GPK GPL GPM GPN GPP GPQ GPR GPS GPT GPV GPW GPY GQA GQC GQD GQE GQF GQG GQH GQI GQK GQL GQM GQN GQP GQQ GQR GQS GQT GQV GQW GQY GRA GRC GRD GRE GRF GRG GRH GRI GRK GRL GRM GRN GRP GRQ GRR GRS GRT GRV GRW GRY GSA GSC GSD GSE GSF GSG GSH GSI GSK GSL GSM GSN GSP GSQ GSR GSS GST GSV GSW GSY GTA GTC GTD GTE GTF GTG GTH GTI GTK GTL GTM GTN GTP GTQ GTR GTS GTT GTV GTW GTY GVA GVC GVD GVE GVF GVG GVH GVI GVK GVL GVM GVN GVP GVQ GVR GVS GVT GVV GVW GVY GWA GWC GWD GWE GWF GWG GWH GWI GWK GWL GWM GWN GWP GWQ GWR GWS GWT GWV GWW GWY GYA GYC GYD GYE GYF GYG GYH GYI GYK GYL GYM GYN GYP GYQ GYR GYS GYT GYV GYW GYY HAA HAC HAD HAE HAF HAG HAH HAI HAK HAL HAM HAN HAP HAQ HAR HAS HAT HAV HAW HAY HCA HCC HCD HCE HCF HCG HCH HCI HCK HCL HCM HCN HCP HCQ HCR HCS HCT HCV HCW HCY HDA HDC HDD HDE HDF HDG HDH HDI HDK HDL HDM HDN HDP HDQ HDR HDS HDT HDV HDW HDY HEA HEC HED HEE HEF HEG HEH HEI HEK HEL HEM HEN HEP HEQ HER HES HET HEV HEW HEY HFA HFC HFD HFE HFF HFG HFH HFI HFK HFL HFM HFN HFP HFQ HFR HFS HFT HFV HFW HFY HGA HGC HGD HGE HGF HGG HGH HGI HGK HGL HGM HGN HGP HGQ HGR HGS HGT HGV HGW HGY HHA HHC HHD HHE HHF HHG HHH HHI HHK HHL HHM HHN HHP HHQ HHR HHS HHT HHV HHW HHY HIA HIC HID HIE HIF HIG HIH HII HIK HIL HIM HIN HIP HIQ HIR HIS HIT HIV HIW HIY HKA HKC HKD HKE HKF HKG HKH HKI HKK HKL HKM HKN HKP HKQ HKR HKS HKT HKV HKW HKY HLA HLC HLD HLE HLF HLG HLH HLI HLK HLL HLM HLN HLP HLQ HLR HLS HLT HLV HLW HLY HMA HMC HMD HME HMF HMG HMH HMI HMK HML HMM HMN HMP HMQ HMR HMS HMT HMV HMW HMY HNA HNC HND HNE HNF HNG HNH HNI HNK HNL HNM HNN HNP HNQ HNR HNS HNT HNV HNW HNY HPA HPC HPD HPE HPF HPG HPH HPI HPK HPL HPM HPN HPP HPQ HPR HPS HPT HPV HPW HPY HQA HQC HQD HQE HQF HQG HQH HQI HQK HQL HQM HQN HQP HQQ HQR HQS HQT HQV HQW HQY HRA HRC HRD HRE HRF HRG HRH HRI HRK HRL HRM HRN HRP HRQ HRR HRS HRT HRV HRW HRY HSA HSC HSD HSE HSF HSG HSH HSI HSK HSL HSM HSN HSP HSQ HSR HSS HST HSV HSW HSY HTA HTC HTD HTE HTF HTG HTH HTI HTK HTL HTM HTN HTP HTQ HTR HTS HTT HTV HTW HTY HVA HVC HVD HVE HVF HVG HVH HVI HVK HVL HVM HVN HVP HVQ HVR HVS HVT HVV HVW HVY HWA HWC HWD HWE HWF HWG HWH HWI HWK HWL HWM HWN HWP HWQ HWR HWS HWT HWV HWW HWY HYA HYC HYD HYE HYF HYG HYH HYI HYK HYL HYM HYN HYP HYQ HYR HYS HYT HYV HYW HYY IAA IAC IAD IAE IAF IAG IAH IAI IAK IAL IAM IAN IAP IAQ IAR IAS IAT IAV IAW IAY ICA ICC ICD ICE ICF ICG ICH ICI ICK ICL ICM ICN ICP ICQ ICR ICS ICT ICV ICW ICY IDA IDC IDD IDE IDF IDG IDH IDI IDK IDL IDM IDN IDP IDQ IDR IDS IDT IDV IDW IDY IEA IEC IED IEE IEF IEG IEH IEI IEK IEL IEM IEN IEP IEQ IER IES IET IEV IEW IEY IFA IFC IFD IFE IFF IFG IFH IFI IFK IFL IFM IFN IFP IFQ IFR IFS IFT IFV IFW IFY IGA IGC IGD IGE IGF IGG IGH IGI IGK IGL IGM IGN IGP IGQ IGR IGS IGT IGV IGW IGY IHA IHC IHD IHE IHF IHG IHH IHI IHK IHL IHM IHN IHP IHQ IHR IHS IHT IHV IHW IHY IIA IIC IID IIE IIF IIG IIH III IIK IIL IIM IIN IIP IIQ IIR IIS IIT IIV IIW IIY IKA IKC IKD IKE IKF IKG IKH IKI IKK IKL IKM IKN IKP IKQ IKR IKS IKT IKV IKW IKY ILA ILC ILD ILE ILF ILG ILH ILI ILK ILL ILM ILN ILP ILQ ILR ILS ILT ILV ILW ILY IMA IMC IMD IME IMF IMG IMH IMI IMK IML IMM IMN IMP IMQ IMR IMS IMT IMV IMW IMY INA INC IND INE INF ING INH INI INK INL INM INN INP INQ INR INS INT INV INW INY IPA IPC IPD IPE IPF IPG IPH IPI IPK IPL IPM IPN IPP IPQ IPR IPS IPT IPV IPW IPY IQA IQC IQD IQE IQF IQG IQH IQI IQK IQL IQM IQN IQP IQQ IQR IQS IQT IQV IQW IQY IRA IRC IRD IRE IRF IRG IRH IRI IRK IRL IRM IRN IRP IRQ IRR IRS IRT IRV IRW IRY ISA ISC ISD ISE ISF ISG ISH ISI ISK ISL ISM ISN ISP ISQ ISR ISS IST ISV ISW ISY ITA ITC ITD ITE ITF ITG ITH ITI ITK ITL ITM ITN ITP ITQ ITR ITS ITT ITV ITW ITY IVA IVC IVD IVE IVF IVG IVH IVI IVK IVL IVM IVN IVP IVQ IVR IVS IVT IVV IVW IVY IWA IWC IWD IWE IWF IWG IWH IWI IWK IWL IWM IWN IWP IWQ IWR IWS IWT IWV IWW IWY IYA IYC IYD IYE IYF IYG IYH IYI IYK IYL IYM IYN IYP IYQ IYR IYS IYT IYV IYW IYY KAA KAC KAD KAE KAF KAG KAH KAI KAK KAL KAM KAN KAP KAQ KAR KAS KAT KAV KAW KAY KCA KCC KCD KCE KCF KCG KCH KCI KCK KCL KCM KCN KCP KCQ KCR KCS KCT KCV KCW KCY KDA KDC KDD KDE KDF KDG KDH KDI KDK KDL KDM KDN KDP KDQ KDR KDS KDT KDV KDW KDY KEA KEC KED KEE KEF KEG KEH KEI KEK KEL KEM KEN KEP KEQ KER KES KET KEV KEW KEY KFA KFC KFD KFE KFF KFG KFH KFI KFK KFL KFM KFN KFP KFQ KFR KFS KFT KFV KFW KFY KGA KGC KGD KGE KGF KGG KGH KGI KGK KGL KGM KGN KGP KGQ KGR KGS KGT KGV KGW KGY KHA KHC KHD KHE KHF KHG KHH KHI KHK KHL KHM KHN KHP KHQ KHR KHS KHT KHV KHW KHY KIA KIC KID KIE KIF KIG KIH KII KIK KIL KIM KIN KIP KIQ KIR KIS KIT KIV KIW KIY KKA KKC KKD KKE KKF KKG KKH KKI KKK KKL KKM KKN KKP KKQ KKR KKS KKT KKV KKW KKY KLA KLC KLD KLE KLF KLG KLH KLI KLK KLL KLM KLN KLP KLQ KLR KLS KLT KLV KLW KLY KMA KMC KMD KME KMF KMG KMH KMI KMK KML KMM KMN KMP KMQ KMR KMS KMT KMV KMW KMY KNA KNC KND KNE KNF KNG KNH KNI KNK KNL KNM KNN KNP KNQ KNR KNS KNT KNV KNW KNY KPA KPC KPD KPE KPF KPG KPH KPI KPK KPL KPM KPN KPP KPQ KPR KPS KPT KPV KPW KPY KQA KQC KQD KQE KQF KQG KQH KQI KQK KQL KQM KQN KQP KQQ KQR KQS KQT KQV KQW KQY KRA KRC KRD KRE KRF KRG KRH KRI KRK KRL KRM KRN KRP KRQ KRR KRS KRT KRV KRW KRY KSA KSC KSD KSE KSF KSG KSH KSI KSK KSL KSM KSN KSP KSQ KSR KSS KST KSV KSW KSY KTA KTC KTD KTE KTF KTG KTH KTI KTK KTL KTM KTN KTP KTQ KTR KTS KTT KTV KTW KTY KVA KVC KVD KVE KVF KVG KVH KVI KVK KVL KVM KVN KVP KVQ KVR KVS KVT KVV KVW KVY KWA KWC KWD KWE KWF KWG KWH KWI KWK KWL KWM KWN KWP KWQ KWR KWS KWT KWV KWW KWY KYA KYC KYD KYE KYF KYG KYH KYI KYK KYL KYM KYN KYP KYQ KYR KYS KYT KYV KYW KYY LAA LAC LAD LAE LAF LAG LAH LAI LAK LAL LAM LAN LAP LAQ LAR LAS LAT LAV LAW LAY LCA LCC LCD LCE LCF LCG LCH LCI LCK LCL LCM LCN LCP LCQ LCR LCS LCT LCV LCW LCY LDA LDC LDD LDE LDF LDG LDH LDI LDK LDL LDM LDN LDP LDQ LDR LDS LDT LDV LDW LDY LEA LEC LED LEE LEF LEG LEH LEI LEK LEL LEM LEN LEP LEQ LER LES LET LEV LEW LEY LFA LFC LFD LFE LFF LFG LFH LFI LFK LFL LFM LFN LFP LFQ LFR LFS LFT LFV LFW LFY LGA LGC LGD LGE LGF LGG LGH LGI LGK LGL LGM LGN LGP LGQ LGR LGS LGT LGV LGW LGY LHA LHC LHD LHE LHF LHG LHH LHI LHK LHL LHM LHN LHP LHQ LHR LHS LHT LHV LHW LHY LIA LIC LID LIE LIF LIG LIH LII LIK LIL LIM LIN LIP LIQ LIR LIS LIT LIV LIW LIY LKA LKC LKD LKE LKF LKG LKH LKI LKK LKL LKM LKN LKP LKQ LKR LKS LKT LKV LKW LKY LLA LLC LLD LLE LLF LLG LLH LLI LLK LLL LLM LLN LLP LLQ LLR LLS LLT LLV LLW LLY LMA LMC LMD LME LMF LMG LMH LMI LMK LML LMM LMN LMP LMQ LMR LMS LMT LMV LMW LMY LNA LNC LND LNE LNF LNG LNH LNI LNK LNL LNM LNN LNP LNQ LNR LNS LNT LNV LNW LNY LPA LPC LPD LPE LPF LPG LPH LPI LPK LPL LPM LPN LPP LPQ LPR LPS LPT LPV LPW LPY LQA LQC LQD LQE LQF LQG LQH LQI LQK LQL LQM LQN LQP LQQ LQR LQS LQT LQV LQW LQY LRA LRC LRD LRE LRF LRG LRH LRI LRK LRL LRM LRN LRP LRQ LRR LRS LRT LRV LRW LRY LSA LSC LSD LSE LSF LSG LSH LSI LSK LSL LSM LSN LSP LSQ LSR LSS LST LSV LSW LSY LTA LTC LTD LTE LTF LTG LTH LTI LTK LTL LTM LTN LTP LTQ LTR LTS LTT LTV LTW LTY LVA LVC LVD LVE LVF LVG LVH LVI LVK LVL LVM LVN LVP LVQ LVR LVS LVT LVV LVW LVY LWA LWC LWD LWE LWF LWG LWH LWI LWK LWL LWM LWN LWP LWQ LWR LWS LWT LWV LWW LWY LYA LYC LYD LYE LYF LYG LYH LYI LYK LYL LYM LYN LYP LYQ LYR LYS LYT LYV LYW LYY MAA MAC MAD MAE MAF MAG MAH MAI MAK MAL MAM MAN MAP MAQ MAR MAS MAT MAV MAW MAY MCA MCC MCD MCE MCF MCG MCH MCI MCK MCL MCM MCN MCP MCQ MCR MCS MCT MCV MCW MCY MDA MDC MDD MDE MDF MDG MDH MDI MDK MDL MDM MDN MDP MDQ MDR MDS MDT MDV MDW MDY MEA MEC MED MEE MEF MEG MEH MEI MEK MEL MEM MEN MEP MEQ MER MES MET MEV MEW MEY MFA MFC MFD MFE MFF MFG MFH MFI MFK MFL MFM MFN MFP MFQ MFR MFS MFT MFV MFW MFY MGA MGC MGD MGE MGF MGG MGH MGI MGK MGL MGM MGN MGP MGQ MGR MGS MGT MGV MGW MGY MHA MHC MHD MHE MHF MHG MHH MHI MHK MHL MHM MHN MHP MHQ MHR MHS MHT MHV MHW MHY MIA MIC MID MIE MIF MIG MIH MII MIK MIL MIM MIN MIP MIQ MIR MIS MIT MIV MIW MIY MKA MKC MKD MKE MKF MKG MKH MKI MKK MKL MKM MKN MKP MKQ MKR MKS MKT MKV MKW MKY MLA MLC MLD MLE MLF MLG MLH MLI MLK MLL MLM MLN MLP MLQ MLR MLS MLT MLV MLW MLY MMA MMC MMD MME MMF MMG MMH MMI MMK MML MMM MMN MMP MMQ MMR MMS MMT MMV MMW MMY MNA MNC MND MNE MNF MNG MNH MNI MNK MNL MNM MNN MNP MNQ MNR MNS MNT MNV MNW MNY MPA MPC MPD MPE MPF MPG MPH MPI MPK MPL MPM MPN MPP MPQ MPR MPS MPT MPV MPW MPY MQA MQC MQD MQE MQF MQG MQH MQI MQK MQL MQM MQN MQP MQQ MQR MQS MQT MQV MQW MQY MRA MRC MRD MRE MRF MRG MRH MRI MRK MRL MRM MRN MRP MRQ MRR MRS MRT MRV MRW MRY MSA MSC MSD MSE MSF MSG MSH MSI MSK MSL MSM MSN MSP MSQ MSR MSS MST MSV MSW MSY MTA MTC MTD MTE MTF MTG MTH MTI MTK MTL MTM MTN MTP MTQ MTR MTS MTT MTV MTW MTY MVA MVC MVD MVE MVF MVG MVH MVI MVK MVL MVM MVN MVP MVQ MVR MVS MVT MVV MVW MVY MWA MWC MWD MWE MWF MWG MWH MWI MWK MWL MWM MWN MWP MWQ MWR MWS MWT MWV MWW MWY MYA MYC MYD MYE MYF MYG MYH MYI MYK MYL MYM MYN MYP MYQ MYR MYS MYT MYV MYW MYY NAA NAC NAD NAE NAF NAG NAH NAI NAK NAL NAM NAN NAP NAQ NAR NAS NAT NAV NAW NAY NCA NCC NCD NCE NCF NCG NCH NCI NCK NCL NCM NCN NCP NCQ NCR NCS NCT NCV NCW NCY NDA NDC NDD NDE NDF NDG NDH NDI NDK NDL NDM NDN NDP NDQ NDR NDS NDT NDV NDW NDY NEA NEC NED NEE NEF NEG NEH NEI NEK NEL NEM NEN NEP NEQ NER NES NET NEV NEW NEY NFA NFC NFD NFE NFF NFG NFH NFI NFK NFL NFM NFN NFP NFQ NFR NFS NFT NFV NFW NFY NGA NGC NGD NGE NGF NGG NGH NGI NGK NGL NGM NGN NGP NGQ NGR NGS NGT NGV NGW NGY NHA NHC NHD NHE NHF NHG NHH NHI NHK NHL NHM NHN NHP NHQ NHR NHS NHT NHV NHW NHY NIA NIC NID NIE NIF NIG NIH NII NIK NIL NIM NIN NIP NIQ NIR NIS NIT NIV NIW NIY NKA NKC NKD NKE NKF NKG NKH NKI NKK NKL NKM NKN NKP NKQ NKR NKS NKT NKV NKW NKY NLA NLC NLD NLE NLF NLG NLH NLI NLK NLL NLM NLN NLP NLQ NLR NLS NLT NLV NLW NLY NMA NMC NMD NME NMF NMG NMH NMI NMK NML NMM NMN NMP NMQ NMR NMS NMT NMV NMW NMY NNA NNC NND NNE NNF NNG NNH NNI NNK NNL NNM NNN NNP NNQ NNR NNS NNT NNV NNW NNY NPA NPC NPD NPE NPF NPG NPH NPI NPK NPL NPM NPN NPP NPQ NPR NPS NPT NPV NPW NPY NQA NQC NQD NQE NQF NQG NQH NQI NQK NQL NQM NQN NQP NQQ NQR NQS NQT NQV NQW NQY NRA NRC NRD NRE NRF NRG NRH NRI NRK NRL NRM NRN NRP NRQ NRR NRS NRT NRV NRW NRY NSA NSC NSD NSE NSF NSG NSH NSI NSK NSL NSM NSN NSP NSQ NSR NSS NST NSV NSW NSY NTA NTC NTD NTE NTF NTG NTH NTI NTK NTL NTM NTN NTP NTQ NTR NTS NTT NTV NTW NTY NVA NVC NVD NVE NVF NVG NVH NVI NVK NVL NVM NVN NVP NVQ NVR NVS NVT NVV NVW NVY NWA NWC NWD NWE NWF NWG NWH NWI NWK NWL NWM NWN NWP NWQ NWR NWS NWT NWV NWW NWY NYA NYC NYD NYE NYF NYG NYH NYI NYK NYL NYM NYN NYP NYQ NYR NYS NYT NYV NYW NYY PAA PAC PAD PAE PAF PAG PAH PAI PAK PAL PAM PAN PAP PAQ PAR PAS PAT PAV PAW PAY PCA PCC PCD PCE PCF PCG PCH PCI PCK PCL PCM PCN PCP PCQ PCR PCS PCT PCV PCW PCY PDA PDC PDD PDE PDF PDG PDH PDI PDK PDL PDM PDN PDP PDQ PDR PDS PDT PDV PDW PDY PEA PEC PED PEE PEF PEG PEH PEI PEK PEL PEM PEN PEP PEQ PER PES PET PEV PEW PEY PFA PFC PFD PFE PFF PFG PFH PFI PFK PFL PFM PFN PFP PFQ PFR PFS PFT PFV PFW PFY PGA PGC PGD PGE PGF PGG PGH PGI PGK PGL PGM PGN PGP PGQ PGR PGS PGT PGV PGW PGY PHA PHC PHD PHE PHF PHG PHH PHI PHK PHL PHM PHN PHP PHQ PHR PHS PHT PHV PHW PHY PIA PIC PID PIE PIF PIG PIH PII PIK PIL PIM PIN PIP PIQ PIR PIS PIT PIV PIW PIY PKA PKC PKD PKE PKF PKG PKH PKI PKK PKL PKM PKN PKP PKQ PKR PKS PKT PKV PKW PKY PLA PLC PLD PLE PLF PLG PLH PLI PLK PLL PLM PLN PLP PLQ PLR PLS PLT PLV PLW PLY PMA PMC PMD PME PMF PMG PMH PMI PMK PML PMM PMN PMP PMQ PMR PMS PMT PMV PMW PMY PNA PNC PND PNE PNF PNG PNH PNI PNK PNL PNM PNN PNP PNQ PNR PNS PNT PNV PNW PNY PPA PPC PPD PPE PPF PPG PPH PPI PPK PPL PPM PPN PPP PPQ PPR PPS PPT PPV PPW PPY PQA PQC PQD PQE PQF PQG PQH PQI PQK PQL PQM PQN PQP PQQ PQR PQS PQT PQV PQW PQY PRA PRC PRD PRE PRF PRG PRH PRI PRK PRL PRM PRN PRP PRQ PRR PRS PRT PRV PRW PRY PSA PSC PSD PSE PSF PSG PSH PSI PSK PSL PSM PSN PSP PSQ PSR PSS PST PSV PSW PSY PTA PTC PTD PTE PTF PTG PTH PTI PTK PTL PTM PTN PTP PTQ PTR PTS PTT PTV PTW PTY PVA PVC PVD PVE PVF PVG PVH PVI PVK PVL PVM PVN PVP PVQ PVR PVS PVT PVV PVW PVY PWA PWC PWD PWE PWF PWG PWH PWI PWK PWL PWM PWN PWP PWQ PWR PWS PWT PWV PWW PWY PYA PYC PYD PYE PYF PYG PYH PYI PYK PYL PYM PYN PYP PYQ PYR PYS PYT PYV PYW PYY QAA QAC QAD QAE QAF QAG QAH QAI QAK QAL QAM QAN QAP QAQ QAR QAS QAT QAV QAW QAY QCA QCC QCD QCE QCF QCG QCH QCI QCK QCL QCM QCN QCP QCQ QCR QCS QCT QCV QCW QCY QDA QDC QDD QDE QDF QDG QDH QDI QDK QDL QDM QDN QDP QDQ QDR QDS QDT QDV QDW QDY QEA QEC QED QEE QEF QEG QEH QEI QEK QEL QEM QEN QEP QEQ QER QES QET QEV QEW QEY QFA QFC QFD QFE QFF QFG QFH QFI QFK QFL QFM QFN QFP QFQ QFR QFS QFT QFV QFW QFY QGA QGC QGD QGE QGF QGG QGH QGI QGK QGL QGM QGN QGP QGQ QGR QGS QGT QGV QGW QGY QHA QHC QHD QHE QHF QHG QHH QHI QHK QHL QHM QHN QHP QHQ QHR QHS QHT QHV QHW QHY QIA QIC QID QIE QIF QIG QIH QII QIK QIL QIM QIN QIP QIQ QIR QIS QIT QIV QIW QIY QKA QKC QKD QKE QKF QKG QKH QKI QKK QKL QKM QKN QKP QKQ QKR QKS QKT QKV QKW QKY QLA QLC QLD QLE QLF QLG QLH QLI QLK QLL QLM QLN QLP QLQ QLR QLS QLT QLV QLW QLY QMA QMC QMD QME QMF QMG QMH QMI QMK QML QMM QMN QMP QMQ QMR QMS QMT QMV QMW QMY QNA QNC QND QNE QNF QNG QNH QNI QNK QNL QNM QNN QNP QNQ QNR QNS QNT QNV QNW QNY QPA QPC QPD QPE QPF QPG QPH QPI QPK QPL QPM QPN QPP QPQ QPR QPS QPT QPV QPW QPY QQA QQC QQD QQE QQF QQG QQH QQI QQK QQL QQM QQN QQP QQQ QQR QQS QQT QQV QQW QQY QRA QRC QRD QRE QRF QRG QRH QRI QRK QRL QRM QRN QRP QRQ QRR QRS QRT QRV QRW QRY QSA QSC QSD QSE QSF QSG QSH QSI QSK QSL QSM QSN QSP QSQ QSR QSS QST QSV QSW QSY QTA QTC QTD QTE QTF QTG QTH QTI QTK QTL QTM QTN QTP QTQ QTR QTS QTT QTV QTW QTY QVA QVC QVD QVE QVF QVG QVH QVI QVK QVL QVM QVN QVP QVQ QVR QVS QVT QVV QVW QVY QWA QWC QWD QWE QWF QWG QWH QWI QWK QWL QWM QWN QWP QWQ QWR QWS QWT QWV QWW QWY QYA QYC QYD QYE QYF QYG QYH QYI QYK QYL QYM QYN QYP QYQ QYR QYS QYT QYV QYW QYY RAA RAC RAD RAE RAF RAG RAH RAI RAK RAL RAM RAN RAP RAQ RAR RAS RAT RAV RAW RAY RCA RCC RCD RCE RCF RCG RCH RCI RCK RCL RCM RCN RCP RCQ RCR RCS RCT RCV RCW RCY RDA RDC RDD RDE RDF RDG RDH RDI RDK RDL RDM RDN RDP RDQ RDR RDS RDT RDV RDW RDY REA REC RED REE REF REG REH REI REK REL REM REN REP REQ RER RES RET REV REW REY RFA RFC RFD RFE RFF RFG RFH RFI RFK RFL RFM RFN RFP RFQ RFR RFS RFT RFV RFW RFY RGA RGC RGD RGE RGF RGG RGH RGI RGK RGL RGM RGN RGP RGQ RGR RGS RGT RGV RGW RGY RHA RHC RHD RHE RHF RHG RHH RHI RHK RHL RHM RHN RHP RHQ RHR RHS RHT RHV RHW RHY RIA RIC RID RIE RIF RIG RIH RII RIK RIL RIM RIN RIP RIQ RIR RIS RIT RIV RIW RIY RKA RKC RKD RKE RKF RKG RKH RKI RKK RKL RKM RKN RKP RKQ RKR RKS RKT RKV RKW RKY RLA RLC RLD RLE RLF RLG RLH RLI RLK RLL RLM RLN RLP RLQ RLR RLS RLT RLV RLW RLY RMA RMC RMD RME RMF RMG RMH RMI RMK RML RMM RMN RMP RMQ RMR RMS RMT RMV RMW RMY RNA RNC RND RNE RNF RNG RNH RNI RNK RNL RNM RNN RNP RNQ RNR RNS RNT RNV RNW RNY RPA RPC RPD RPE RPF RPG RPH RPI RPK RPL RPM RPN RPP RPQ RPR RPS RPT RPV RPW RPY RQA RQC RQD RQE RQF RQG RQH RQI RQK RQL RQM RQN RQP RQQ RQR RQS RQT RQV RQW RQY RRA RRC RRD RRE RRF RRG RRH RRI RRK RRL RRM RRN RRP RRQ RRR RRS RRT RRV RRW RRY RSA RSC RSD RSE RSF RSG RSH RSI RSK RSL RSM RSN RSP RSQ RSR RSS RST RSV RSW RSY RTA RTC RTD RTE RTF RTG RTH RTI RTK RTL RTM RTN RTP RTQ RTR RTS RTT RTV RTW RTY RVA RVC RVD RVE RVF RVG RVH RVI RVK RVL RVM RVN RVP RVQ RVR RVS RVT RVV RVW RVY RWA RWC RWD RWE RWF RWG RWH RWI RWK RWL RWM RWN RWP RWQ RWR RWS RWT RWV RWW RWY RYA RYC RYD RYE RYF RYG RYH RYI RYK RYL RYM RYN RYP RYQ RYR RYS RYT RYV RYW RYY SAA SAC SAD SAE SAF SAG SAH SAI SAK SAL SAM SAN SAP SAQ SAR SAS SAT SAV SAW SAY SCA SCC SCD SCE SCF SCG SCH SCI SCK SCL SCM SCN SCP SCQ SCR SCS SCT SCV SCW SCY SDA SDC SDD SDE SDF SDG SDH SDI SDK SDL SDM SDN SDP SDQ SDR SDS SDT SDV SDW SDY SEA SEC SED SEE SEF SEG SEH SEI SEK SEL SEM SEN SEP SEQ SER SES SET SEV SEW SEY SFA SFC SFD SFE SFF SFG SFH SFI SFK SFL SFM SFN SFP SFQ SFR SFS SFT SFV SFW SFY SGA SGC SGD SGE SGF SGG SGH SGI SGK SGL SGM SGN SGP SGQ SGR SGS SGT SGV SGW SGY SHA SHC SHD SHE SHF SHG SHH SHI SHK SHL SHM SHN SHP SHQ SHR SHS SHT SHV SHW SHY SIA SIC SID SIE SIF SIG SIH SII SIK SIL SIM SIN SIP SIQ SIR SIS SIT SIV SIW SIY SKA SKC SKD SKE SKF SKG SKH SKI SKK SKL SKM SKN SKP SKQ SKR SKS SKT SKV SKW SKY SLA SLC SLD SLE SLF SLG SLH SLI SLK SLL SLM SLN SLP SLQ SLR SLS SLT SLV SLW SLY SMA SMC SMD SME SMF SMG SMH SMI SMK SML SMM SMN SMP SMQ SMR SMS SMT SMV SMW SMY SNA SNC SND SNE SNF SNG SNH SNI SNK SNL SNM SNN SNP SNQ SNR SNS SNT SNV SNW SNY SPA SPC SPD SPE SPF SPG SPH SPI SPK SPL SPM SPN SPP SPQ SPR SPS SPT SPV SPW SPY SQA SQC SQD SQE SQF SQG SQH SQI SQK SQL SQM SQN SQP SQQ SQR SQS SQT SQV SQW SQY SRA SRC SRD SRE SRF SRG SRH SRI SRK SRL SRM SRN SRP SRQ SRR SRS SRT SRV SRW SRY SSA SSC SSD SSE SSF SSG SSH SSI SSK SSL SSM SSN SSP SSQ SSR SSS SST SSV SSW SSY STA STC STD STE STF STG STH STI STK STL STM STN STP STQ STR STS STT STV STW STY SVA SVC SVD SVE SVF SVG SVH SVI SVK SVL SVM SVN SVP SVQ SVR SVS SVT SVV SVW SVY SWA SWC SWD SWE SWF SWG SWH SWI SWK SWL SWM SWN SWP SWQ SWR SWS SWT SWV SWW SWY SYA SYC SYD SYE SYF SYG SYH SYI SYK SYL SYM SYN SYP SYQ SYR SYS SYT SYV SYW SYY TAA TAC TAD TAE TAF TAG TAH TAI TAK TAL TAM TAN TAP TAQ TAR TAS TAT TAV TAW TAY TCA TCC TCD TCE TCF TCG TCH TCI TCK TCL TCM TCN TCP TCQ TCR TCS TCT TCV TCW TCY TDA TDC TDD TDE TDF TDG TDH TDI TDK TDL TDM TDN TDP TDQ TDR TDS TDT TDV TDW TDY TEA TEC TED TEE TEF TEG TEH TEI TEK TEL TEM TEN TEP TEQ TER TES TET TEV TEW TEY TFA TFC TFD TFE TFF TFG TFH TFI TFK TFL TFM TFN TFP TFQ TFR TFS TFT TFV TFW TFY TGA TGC TGD TGE TGF TGG TGH TGI TGK TGL TGM TGN TGP TGQ TGR TGS TGT TGV TGW TGY THA THC THD THE THF THG THH THI THK THL THM THN THP THQ THR THS THT THV THW THY TIA TIC TID TIE TIF TIG TIH TII TIK TIL TIM TIN TIP TIQ TIR TIS TIT TIV TIW TIY TKA TKC TKD TKE TKF TKG TKH TKI TKK TKL TKM TKN TKP TKQ TKR TKS TKT TKV TKW TKY TLA TLC TLD TLE TLF TLG TLH TLI TLK TLL TLM TLN TLP TLQ TLR TLS TLT TLV TLW TLY TMA TMC TMD TME TMF TMG TMH TMI TMK TML TMM TMN TMP TMQ TMR TMS TMT TMV TMW TMY TNA TNC TND TNE TNF TNG TNH TNI TNK TNL TNM TNN TNP TNQ TNR TNS TNT TNV TNW TNY TPA TPC TPD TPE TPF TPG TPH TPI TPK TPL TPM TPN TPP TPQ TPR TPS TPT TPV TPW TPY TQA TQC TQD TQE TQF TQG TQH TQI TQK TQL TQM TQN TQP TQQ TQR TQS TQT TQV TQW TQY TRA TRC TRD TRE TRF TRG TRH TRI TRK TRL TRM TRN TRP TRQ TRR TRS TRT TRV TRW TRY TSA TSC TSD TSE TSF TSG TSH TSI TSK TSL TSM TSN TSP TSQ TSR TSS TST TSV TSW TSY TTA TTC TTD TTE TTF TTG TTH TTI TTK TTL TTM TTN TTP TTQ TTR TTS TTT TTV TTW TTY TVA TVC TVD TVE TVF TVG TVH TVI TVK TVL TVM TVN TVP TVQ TVR TVS TVT TVV TVW TVY TWA TWC TWD TWE TWF TWG TWH TWI TWK TWL TWM TWN TWP TWQ TWR TWS TWT TWV TWW TWY TYA TYC TYD TYE TYF TYG TYH TYI TYK TYL TYM TYN TYP TYQ TYR TYS TYT TYV TYW TYY VAA VAC VAD VAE VAF VAG VAH VAI VAK VAL VAM VAN VAP VAQ VAR VAS VAT VAV VAW VAY VCA VCC VCD VCE VCF VCG VCH VCI VCK VCL VCM VCN VCP VCQ VCR VCS VCT VCV VCW VCY VDA VDC VDD VDE VDF VDG VDH VDI VDK VDL VDM VDN VDP VDQ VDR VDS VDT VDV VDW VDY VEA VEC VED VEE VEF VEG VEH VEI VEK VEL VEM VEN VEP VEQ VER VES VET VEV VEW VEY VFA VFC VFD VFE VFF VFG VFH VFI VFK VFL VFM VFN VFP VFQ VFR VFS VFT VFV VFW VFY VGA VGC VGD VGE VGF VGG VGH VGI VGK VGL VGM VGN VGP VGQ VGR VGS VGT VGV VGW VGY VHA VHC VHD VHE VHF VHG VHH VHI VHK VHL VHM VHN VHP VHQ VHR VHS VHT VHV VHW VHY VIA VIC VID VIE VIF VIG VIH VII VIK VIL VIM VIN VIP VIQ VIR VIS VIT VIV VIW VIY VKA VKC VKD VKE VKF VKG VKH VKI VKK VKL VKM VKN VKP VKQ VKR VKS VKT VKV VKW VKY VLA VLC VLD VLE VLF VLG VLH VLI VLK VLL VLM VLN VLP VLQ VLR VLS VLT VLV VLW VLY VMA VMC VMD VME VMF VMG VMH VMI VMK VML VMM VMN VMP VMQ VMR VMS VMT VMV VMW VMY VNA VNC VND VNE VNF VNG VNH VNI VNK VNL VNM VNN VNP VNQ VNR VNS VNT VNV VNW VNY VPA VPC VPD VPE VPF VPG VPH VPI VPK VPL VPM VPN VPP VPQ VPR VPS VPT VPV VPW VPY VQA VQC VQD VQE VQF VQG VQH VQI VQK VQL VQM VQN VQP VQQ VQR VQS VQT VQV VQW VQY VRA VRC VRD VRE VRF VRG VRH VRI VRK VRL VRM VRN VRP VRQ VRR VRS VRT VRV VRW VRY VSA VSC VSD VSE VSF VSG VSH VSI VSK VSL VSM VSN VSP VSQ VSR VSS VST VSV VSW VSY VTA VTC VTD VTE VTF VTG VTH VTI VTK VTL VTM VTN VTP VTQ VTR VTS VTT VTV VTW VTY VVA VVC VVD VVE VVF VVG VVH VVI VVK VVL VVM VVN VVP VVQ VVR VVS VVT VVV VVW VVY VWA VWC VWD VWE VWF VWG VWH VWI VWK VWL VWM VWN VWP VWQ VWR VWS VWT VWV VWW VWY VYA VYC VYD VYE VYF VYG VYH VYI VYK VYL VYM VYN VYP VYQ VYR VYS VYT VYV VYW VYY WAA WAC WAD WAE WAF WAG WAH WAI WAK WAL WAM WAN WAP WAQ WAR WAS WAT WAV WAW WAY WCA WCC WCD WCE WCF WCG WCH WCI WCK WCL WCM WCN WCP WCQ WCR WCS WCT WCV WCW WCY WDA WDC WDD WDE WDF WDG WDH WDI WDK WDL WDM WDN WDP WDQ WDR WDS WDT WDV WDW WDY WEA WEC WED WEE WEF WEG WEH WEI WEK WEL WEM WEN WEP WEQ WER WES WET WEV WEW WEY WFA WFC WFD WFE WFF WFG WFH WFI WFK WFL WFM WFN WFP WFQ WFR WFS WFT WFV WFW WFY WGA WGC WGD WGE WGF WGG WGH WGI WGK WGL WGM WGN WGP WGQ WGR WGS WGT WGV WGW WGY WHA WHC WHD WHE WHF WHG WHH WHI WHK WHL WHM WHN WHP WHQ WHR WHS WHT WHV WHW WHY WIA WIC WID WIE WIF WIG WIH WII WIK WIL WIM WIN WIP WIQ WIR WIS WIT WIV WIW WIY WKA WKC WKD WKE WKF WKG WKH WKI WKK WKL WKM WKN WKP WKQ WKR WKS WKT WKV WKW WKY WLA WLC WLD WLE WLF WLG WLH WLI WLK WLL WLM WLN WLP WLQ WLR WLS WLT WLV WLW WLY WMA WMC WMD WME WMF WMG WMH WMI WMK WML WMM WMN WMP WMQ WMR WMS WMT WMV WMW WMY WNA WNC WND WNE WNF WNG WNH WNI WNK WNL WNM WNN WNP WNQ WNR WNS WNT WNV WNW WNY WPA WPC WPD WPE WPF WPG WPH WPI WPK WPL WPM WPN WPP WPQ WPR WPS WPT WPV WPW WPY WQA WQC WQD WQE WQF WQG WQH WQI WQK WQL WQM WQN WQP WQQ WQR WQS WQT WQV WQW WQY WRA WRC WRD WRE WRF WRG WRH WRI WRK WRL WRM WRN WRP WRQ WRR WRS WRT WRV WRW WRY WSA WSC WSD WSE WSF WSG WSH WSI WSK WSL WSM WSN WSP WSQ WSR WSS WST WSV WSW WSY WTA WTC WTD WTE WTF WTG WTH WTI WTK WTL WTM WTN WTP WTQ WTR WTS WTT WTV WTW WTY WVA WVC WVD WVE WVF WVG WVH WVI WVK WVL WVM WVN WVP WVQ WVR WVS WVT WVV WVW WVY WWA WWC WWD WWE WWF WWG WWH WWI WWK WWL WWM WWN WWP WWQ WWR WWS WWT WWV WWW WWY WYA WYC WYD WYE WYF WYG WYH WYI WYK WYL WYM WYN WYP WYQ WYR WYS WYT WYV WYW WYY YAA YAC YAD YAE YAF YAG YAH YAI YAK YAL YAM YAN YAP YAQ YAR YAS YAT YAV YAW YAY YCA YCC YCD YCE YCF YCG YCH YCI YCK YCL YCM YCN YCP YCQ YCR YCS YCT YCV YCW YCY YDA YDC YDD YDE YDF YDG YDH YDI YDK YDL YDM YDN YDP YDQ YDR YDS YDT YDV YDW YDY YEA YEC YED YEE YEF YEG YEH YEI YEK YEL YEM YEN YEP YEQ YER YES YET YEV YEW YEY YFA YFC YFD YFE YFF YFG YFH YFI YFK YFL YFM YFN YFP YFQ YFR YFS YFT YFV YFW YFY YGA YGC YGD YGE YGF YGG YGH YGI YGK YGL YGM YGN YGP YGQ YGR YGS YGT YGV YGW YGY YHA YHC YHD YHE YHF YHG YHH YHI YHK YHL YHM YHN YHP YHQ YHR YHS YHT YHV YHW YHY YIA YIC YID YIE YIF YIG YIH YII YIK YIL YIM YIN YIP YIQ YIR YIS YIT YIV YIW YIY YKA YKC YKD YKE YKF YKG YKH YKI YKK YKL YKM YKN YKP YKQ YKR YKS YKT YKV YKW YKY YLA YLC YLD YLE YLF YLG YLH YLI YLK YLL YLM YLN YLP YLQ YLR YLS YLT YLV YLW YLY YMA YMC YMD YME YMF YMG YMH YMI YMK YML YMM YMN YMP YMQ YMR YMS YMT YMV YMW YMY YNA YNC YND YNE YNF YNG YNH YNI YNK YNL YNM YNN YNP YNQ YNR YNS YNT YNV YNW YNY YPA YPC YPD YPE YPF YPG YPH YPI YPK YPL YPM YPN YPP YPQ YPR YPS YPT YPV YPW YPY YQA YQC YQD YQE YQF YQG YQH YQI YQK YQL YQM YQN YQP YQQ YQR YQS YQT YQV YQW YQY YRA YRC YRD YRE YRF YRG YRH YRI YRK YRL YRM YRN YRP YRQ YRR YRS YRT YRV YRW YRY YSA YSC YSD YSE YSF YSG YSH YSI YSK YSL YSM YSN YSP YSQ YSR YSS YST YSV YSW YSY YTA YTC YTD YTE YTF YTG YTH YTI YTK YTL YTM YTN YTP YTQ YTR YTS YTT YTV YTW YTY YVA YVC YVD YVE YVF YVG YVH YVI YVK YVL YVM YVN YVP YVQ YVR YVS YVT YVV YVW YVY YWA YWC YWD YWE YWF YWG YWH YWI YWK YWL YWM YWN YWP YWQ YWR YWS YWT YWV YWW YWY YYA YYC YYD YYE YYF YYG YYH YYI YYK YYL YYM YYN YYP YYQ YYR YYS YYT YYV YYW YYY);

for $x (0..$#Ultimus) {
	print ULTIMA ($col[$x]."\t".join("\t",@{$Ultimus[$x]})."\n");
}
close ULTIMA;
@col=qw("" "" A C D E F G H I K L M N P Q R S T V W Y Stop AC_pear AD_pear AE_pear AF_pear AG_pear AH_pear AI_pear AK_pear AL_pear AM_pear AN_pear AP_pear AQ_pear AR_pear AS_pear AT_pear AV_pear AW_pear AY_pear CD_pear CE_pear CF_pear CG_pear CH_pear CI_pear CK_pear CL_pear CM_pear CN_pear CP_pear CQ_pear CR_pear CS_pear CT_pear CV_pear CW_pear CY_pear DE_pear DF_pear DG_pear DH_pear DI_pear DK_pear DL_pear DM_pear DN_pear DP_pear DQ_pear DR_pear DS_pear DT_pear DV_pear DW_pear DY_pear EF_pear EG_pear EH_pear EI_pear EK_pear EL_pear EM_pear EN_pear EP_pear EQ_pear ER_pear ES_pear ET_pear EV_pear EW_pear EY_pear FG_pear FH_pear FI_pear FK_pear FL_pear FM_pear FN_pear FP_pear FQ_pear FR_pear FS_pear FT_pear FV_pear FW_pear FY_pear GH_pear GI_pear GK_pear GL_pear GM_pear GN_pear GP_pear GQ_pear GR_pear GS_pear GT_pear GV_pear GW_pear GY_pear HI_pear HK_pear HL_pear HM_pear HN_pear HP_pear HQ_pear HR_pear HS_pear HT_pear HV_pear HW_pear HY_pear IK_pear IL_pear IM_pear IN_pear IP_pear IQ_pear IR_pear IS_pear IT_pear IV_pear IW_pear IY_pear KL_pear KM_pear KN_pear KP_pear KQ_pear KR_pear KS_pear KT_pear KV_pear KW_pear KY_pear LM_pear LN_pear LP_pear LQ_pear LR_pear LS_pear LT_pear LV_pear LW_pear LY_pear MN_pear MP_pear MQ_pear MR_pear MS_pear MT_pear MV_pear MW_pear MY_pear NP_pear NQ_pear NR_pear NS_pear NT_pear NV_pear NW_pear NY_pear PQ_pear PR_pear PS_pear PT_pear PV_pear PW_pear PY_pear QR_pear QS_pear QT_pear QV_pear QW_pear QY_pear RS_pear RT_pear RV_pear RW_pear RY_pear ST_pear SV_pear SW_pear SY_pear TV_pear TW_pear TY_pear VW_pear VY_pear WY_pear AA AC AD AE AF AG AH AI AK AL AM AN AP AQ AR AS AT AV AW AY CA CC CD CE CF CG CH CI CK CL CM CN CP CQ CR CS CT CV CW CY DA DC DD DE DF DG DH DI DK DL DM DN DP DQ DR DS DT DV DW DY EA EC ED EE EF EG EH EI EK EL EM EN EP EQ ER ES ET EV EW EY FA FC FD FE FF FG FH FI FK FL FM FN FP FQ FR FS FT FV FW FY GA GC GD GE GF GG GH GI GK GL GM GN GP GQ GR GS GT GV GW GY HA HC HD HE HF HG HH HI HK HL HM HN HP HQ HR HS HT HV HW HY IA IC ID IE IF IG IH II IK IL IM IN IP IQ IR IS IT IV IW IY KA KC KD KE KF KG KH KI KK KL KM KN KP KQ KR KS KT KV KW KY LA LC LD LE LF LG LH LI LK LL LM LN LP LQ LR LS LT LV LW LY MA MC MD ME MF MG MH MI MK ML MM MN MP MQ MR MS MT MV MW MY NA NC ND NE NF NG NH NI NK NL NM NN NP NQ NR NS NT NV NW NY PA PC PD PE PF PG PH PI PK PL PM PN PP PQ PR PS PT PV PW PY QA QC QD QE QF QG QH QI QK QL QM QN QP QQ QR QS QT QV QW QY RA RC RD RE RF RG RH RI RK RL RM RN RP RQ RR RS RT RV RW RY SA SC SD SE SF SG SH SI SK SL SM SN SP SQ SR SS ST SV SW SY TA TC TD TE TF TG TH TI TK TL TM TN TP TQ TR TS TT TV TW TY VA VC VD VE VF VG VH VI VK VL VM VN VP VQ VR VS VT VV VW VY WA WC WD WE WF WG WH WI WK WL WM WN WP WQ WR WS WT WV WW WY YA YC YD YE YF YG YH YI YK YL YM YN YP YQ YR YS YT YV YW YY AC_asym AD_asym AE_asym AF_asym AG_asym AH_asym AI_asym AK_asym AL_asym AM_asym AN_asym AP_asym AQ_asym AR_asym AS_asym AT_asym AV_asym AW_asym AY_asym CD_asym CE_asym CF_asym CG_asym CH_asym CI_asym CK_asym CL_asym CM_asym CN_asym CP_asym CQ_asym CR_asym CS_asym CT_asym CV_asym CW_asym CY_asym DE_asym DF_asym DG_asym DH_asym DI_asym DK_asym DL_asym DM_asym DN_asym DP_asym DQ_asym DR_asym DS_asym DT_asym DV_asym DW_asym DY_asym EF_asym EG_asym EH_asym EI_asym EK_asym EL_asym EM_asym EN_asym EP_asym EQ_asym ER_asym ES_asym ET_asym EV_asym EW_asym EY_asym FG_asym FH_asym FI_asym FK_asym FL_asym FM_asym FN_asym FP_asym FQ_asym FR_asym FS_asym FT_asym FV_asym FW_asym FY_asym GH_asym GI_asym GK_asym GL_asym GM_asym GN_asym GP_asym GQ_asym GR_asym GS_asym GT_asym GV_asym GW_asym GY_asym HI_asym HK_asym HL_asym HM_asym HN_asym HP_asym HQ_asym HR_asym HS_asym HT_asym HV_asym HW_asym HY_asym IK_asym IL_asym IM_asym IN_asym IP_asym IQ_asym IR_asym IS_asym IT_asym IV_asym IW_asym IY_asym KL_asym KM_asym KN_asym KP_asym KQ_asym KR_asym KS_asym KT_asym KV_asym KW_asym KY_asym LM_asym LN_asym LP_asym LQ_asym LR_asym LS_asym LT_asym LV_asym LW_asym LY_asym MN_asym MP_asym MQ_asym MR_asym MS_asym MT_asym MV_asym MW_asym MY_asym NP_asym NQ_asym NR_asym NS_asym NT_asym NV_asym NW_asym NY_asym PQ_asym PR_asym PS_asym PT_asym PV_asym PW_asym PY_asym QR_asym QS_asym QT_asym QV_asym QW_asym QY_asym RS_asym RT_asym RV_asym RW_asym RY_asym ST_asym SV_asym SW_asym SY_asym TV_asym TW_asym TY_asym VW_asym VY_asym WY_asym AA_fit AC_fit AD_fit AE_fit AF_fit AG_fit AH_fit AI_fit AK_fit AL_fit AM_fit AN_fit AP_fit AQ_fit AR_fit AS_fit AT_fit AV_fit AW_fit AY_fit CA_fit CC_fit CD_fit CE_fit CF_fit CG_fit CH_fit CI_fit CK_fit CL_fit CM_fit CN_fit CP_fit CQ_fit CR_fit CS_fit CT_fit CV_fit CW_fit CY_fit DA_fit DC_fit DD_fit DE_fit DF_fit DG_fit DH_fit DI_fit DK_fit DL_fit DM_fit DN_fit DP_fit DQ_fit DR_fit DS_fit DT_fit DV_fit DW_fit DY_fit EA_fit EC_fit ED_fit EE_fit EF_fit EG_fit EH_fit EI_fit EK_fit EL_fit EM_fit EN_fit EP_fit EQ_fit ER_fit ES_fit ET_fit EV_fit EW_fit EY_fit FA_fit FC_fit FD_fit FE_fit FF_fit FG_fit FH_fit FI_fit FK_fit FL_fit FM_fit FN_fit FP_fit FQ_fit FR_fit FS_fit FT_fit FV_fit FW_fit FY_fit GA_fit GC_fit GD_fit GE_fit GF_fit GG_fit GH_fit GI_fit GK_fit GL_fit GM_fit GN_fit GP_fit GQ_fit GR_fit GS_fit GT_fit GV_fit GW_fit GY_fit HA_fit HC_fit HD_fit HE_fit HF_fit HG_fit HH_fit HI_fit HK_fit HL_fit HM_fit HN_fit HP_fit HQ_fit HR_fit HS_fit HT_fit HV_fit HW_fit HY_fit IA_fit IC_fit ID_fit IE_fit IF_fit IG_fit IH_fit II_fit IK_fit IL_fit IM_fit IN_fit IP_fit IQ_fit IR_fit IS_fit IT_fit IV_fit IW_fit IY_fit KA_fit KC_fit KD_fit KE_fit KF_fit KG_fit KH_fit KI_fit KK_fit KL_fit KM_fit KN_fit KP_fit KQ_fit KR_fit KS_fit KT_fit KV_fit KW_fit KY_fit LA_fit LC_fit LD_fit LE_fit LF_fit LG_fit LH_fit LI_fit LK_fit LL_fit LM_fit LN_fit LP_fit LQ_fit LR_fit LS_fit LT_fit LV_fit LW_fit LY_fit MA_fit MC_fit MD_fit ME_fit MF_fit MG_fit MH_fit MI_fit MK_fit ML_fit MM_fit MN_fit MP_fit MQ_fit MR_fit MS_fit MT_fit MV_fit MW_fit MY_fit NA_fit NC_fit ND_fit NE_fit NF_fit NG_fit NH_fit NI_fit NK_fit NL_fit NM_fit NN_fit NP_fit NQ_fit NR_fit NS_fit NT_fit NV_fit NW_fit NY_fit PA_fit PC_fit PD_fit PE_fit PF_fit PG_fit PH_fit PI_fit PK_fit PL_fit PM_fit PN_fit PP_fit PQ_fit PR_fit PS_fit PT_fit PV_fit PW_fit PY_fit QA_fit QC_fit QD_fit QE_fit QF_fit QG_fit QH_fit QI_fit QK_fit QL_fit QM_fit QN_fit QP_fit QQ_fit QR_fit QS_fit QT_fit QV_fit QW_fit QY_fit RA_fit RC_fit RD_fit RE_fit RF_fit RG_fit RH_fit RI_fit RK_fit RL_fit RM_fit RN_fit RP_fit RQ_fit RR_fit RS_fit RT_fit RV_fit RW_fit RY_fit SA_fit SC_fit SD_fit SE_fit SF_fit SG_fit SH_fit SI_fit SK_fit SL_fit SM_fit SN_fit SP_fit SQ_fit SR_fit SS_fit ST_fit SV_fit SW_fit SY_fit TA_fit TC_fit TD_fit TE_fit TF_fit TG_fit TH_fit TI_fit TK_fit TL_fit TM_fit TN_fit TP_fit TQ_fit TR_fit TS_fit TT_fit TV_fit TW_fit TY_fit VA_fit VC_fit VD_fit VE_fit VF_fit VG_fit VH_fit VI_fit VK_fit VL_fit VM_fit VN_fit VP_fit VQ_fit VR_fit VS_fit VT_fit VV_fit VW_fit VY_fit WA_fit WC_fit WD_fit WE_fit WF_fit WG_fit WH_fit WI_fit WK_fit WL_fit WM_fit WN_fit WP_fit WQ_fit WR_fit WS_fit WT_fit WV_fit WW_fit WY_fit YA_fit YC_fit YD_fit YE_fit YF_fit YG_fit YH_fit YI_fit YK_fit YL_fit YM_fit YN_fit YP_fit YQ_fit YR_fit YS_fit YT_fit YV_fit YW_fit YY_fit);

for $x (0..$#Exodus) {
	print PAIR ($col[$x]."\t".join("\t",@{$Exodus[$x]})."\n");
}

print "All done!\n\a";

######################################################
####################################################
################################# SUBS... ##########
sub zeroed {
	my @a = @{ $_[0] };
	
	delete $a[25]; #Z
	splice(@a, 25, 1);
	delete $a[23]; #X
	splice(@a, 23, 1);
	delete $a[20]; #U
	splice(@a, 20, 1);
	delete $a[14]; #O
	splice(@a, 14, 1);
	delete $a[9]; #J
	splice(@a, 9, 1);
	delete $a[1]; #B
	splice(@a, 1, 1);
	
	return (@a);
}

sub tprob { # Upper probability   t(x,n)
	my ($n, $x) = @_;
	if (($n <= 0) || ((abs($n) - abs(int($n))) !=0)) {
		die "Invalid n: $n\n"; # degree of freedom
	}
	return precision_string(_subtprob($n, $x));
}

sub _subtprob {
	my ($n, $x) = @_;
	
	my ($a,$b);
	my $w = atan2($x / sqrt($n), 1);
	my $z = cos($w) ** 2;
	my $y = 1;
	
	for (my $i = $n-2; $i >= 2; $i -= 2) {
		$y = 1 + ($i-1) / $i * $z * $y;
	} 
	
	if ($n % 2 == 0) {
		$a = sin($w)/2;
		$b = .5;
	} else {
		$a = ($n == 1) ? 0 : sin($w)*cos($w)/PI;
		$b= .5 + $w/PI;
	}
	return max(0, 1 - $b - $a * $y);
}

sub max {
	my $max = shift;
	my $next;
	while (@_) {
		$next = shift;
		$max = $next if ($next > $max);
	}	
	return $max;
}

sub min {
	my $min = shift;
	my $next;
	while (@_) {
		$next = shift;
		$min = $next if ($next < $min);
	}	
	return $min;
}

sub precision {
	my ($x) = @_;
	return abs int(log10(abs $x) - SIGNIFICANT);
}

sub precision_string {
	my ($x) = @_;
	if ($x) {
		return sprintf "%." . precision($x) . "f", $x;
	} else {
		return "0";
	}
}

sub log10 {
	my $n = shift;
	return log($n) / log(10);
}
