#! /usr/bin/perl
#code last modified 23-7-10
print "Hello World\n";

@todo=<DATA>;	




open(ORG,'microbes.txt') or die "Can't find microbes: $!";
@micro=<ORG>;
chomp(@micro);
shift(@micro);
for $x (0..$#micro) {
	@{$org[$x]}=split(/\t/,$micro[$x]);
}

foreach $whom (0..$#org) {

	$genenumber=0;
	@gene=();
	@fastalist=();
	@cross=();

	$who=$todo[$whom];
	$who=$org[$whom][0];
	$emprefix=$org[$whom][1];       #in
	$ecprefix=$org[$whom][2];       #out
	$species=$org[$whom][3];
	$disable=$org[$whom][4];
	$what=$org[$whom][5];

	if ($who eq "") {
		print "WARNING: incorrect Id ($who)./n";
		goto VORTEX;
	}
	
	
	
	print "\n\n$species\n($what)\n";
	
	
	###################################
	###FILES###########################
	
	
	$file=$emprefix.'/data/protseq.fsa';
	open(AA,$file) or die "Can't open the amino acid file: $!";
	
	print "Reading sequences...\n";
	@fastalist=<AA>;
	close AA;


	for ($n=0;$n<=$#fastalist;$n++)
	{
		chomp($fastalist[$n]);
		#>EG12096-MONOMER ChpB toxin of the ChpB-ChpS toxin-antitoxin system 4446715..4447065 Escherichia coli K-12 substr. MG1655
		if ($fastalist[$n]=~ m/\>(\S*)\s(.*)/msg) {
			$genenumber++;
			$gene[$genenumber][0]=$1;
			$gene[$genenumber][2]=$2;
			$gene[$genenumber][0]=~ s/\-//msg;
			$gene[$genenumber][0]=~s/MONOMER//msg;
			#no ref $gene[$genenumber][1];
			$gene[$genenumber][2]=~s/$species .*//msg;
			$gene[$genenumber][2]=~ s/\S*\.\.\S*\s*$//msg;
			$gene[$genenumber][2]=~ s/\s$//msg;
			$gene[$genenumber][4]="";
			
		} else
		{$fastalist[$n]=~s/\W//msg;$fastalist[$n]=~s/\r//msg;$fastalist[$n]=~s/\d//msg;$fastalist[$n]=~s/X//msgi;$fastalist[$n]=~s/\_//msg;$gene[$genenumber][3].=uc($fastalist[$n]);}
	}
	shift (@gene);
if ($disable !~ m/X/msg) {	
	print "Cross referencing with other indices...\n";
	$file=$emprefix.'/data/genes.col';	
	open(CREF,$file) or goto COLUMMNLESS;
	@cross=<CREF>;
	chomp @cross;
	for $n (0..$#cross) {
		@temp=split(/\t/,$cross[$n]);
		foreach (@temp) {if ($_=~/^$/) {$_="...";}}
		if ($temp[0] =~ m/\#/) {$intro++;} else {$cref[$n-$intro]=[@temp]; $cref[$n-$intro][0]=~ s/\-//msg;}
			}
	close CREF;
	
	$match=0;
	$blamatch=0;
	$lettermatch=0;
	$missing=0;
	for $i ( 0 .. $#gene ) {
		for $n ( 0 .. $#cref ) {
			if (uc($gene[$i][0]) eq uc($cref[$n][0])) {$match++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY;}
			elsif (uc($gene[$i][0]) eq uc($cref[$n][1])) {$blamatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5]=$cref[$n][$x];} goto AWAY; }		
			elsif (uc($gene[$i][2]) eq uc($cref[$n][3])) {$defmatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }
			elsif (uc($cref[$n][2]) eq uc($gene[$i][2])) {$lettermatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }
			elsif (uc($cref[$n][2]) eq uc($gene[$i][0])) {$lettermatch++; for $x (0..$#{$cref[0]}) {$gene[$i][5+$x]=$cref[$n][$x];} goto AWAY; }
			#UNIQUE-ID	NAME	PRODUCT-NAME	SWISS-PROT-ID	REPLICON	START-BASE	END-BASE	SYNONYMS	SYNONYMS	SYNONYMS	SYNONYMS	GENE-CLASS	GENE-CLASS	GENE-CLASS	GENE-CLASS
		}
		$missing++;	
	AWAY:
	}

	print "There are ". ($match+$blamatch+$defmatch+$lettermatch)." matched and ".$missing." unmatched genes out of $genenumber (".int(($match+$blamatch+$defmatch+$lettermatch)/$genenumber*100+0.5)."\% done: ".int($match/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100+0.5)."% by ID, ".int($blamatch/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100+0.5)."% by blatter, ".int($defmatch/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100)."% by definition and ".int($lettermatch/($match+$blamatch+$defmatch+$lettermatch+0.00000000001)*100)."% by definition)\n";
	
}
if (($disable !~ m/C/msg)) {
	print "Cross referencing with COG list...\n";

	open(COG,'whog') or die "Can't open file: whog, please could you download ftp://ftp.ncbi.nih.gov/pub/COG/COG/whog?\n";
	@lines=<COG>;
	
	$maxcog=0;
	for ($n=1;$n<=$#lines; $n++)
	{
		$item=$lines[$n];
		chomp($item);
		
		if ($item =~ m/\[/)
		{
			#[H] COG0001 Glutamate-1-semialdehyde aminotransferase
			$maxcog++;
			$item =~ m/\[(\w)*\] (\w*?) (.*)/;
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
	$cogle=0; 
	$mill="wind"; $n="dummy";
	for $mill (0..$#gene) {
		for $n (0..$maxcog) {
			
			for $q (0,4..10) { 
				#try all keys
				for $z (0..10) {
					#multiple protein per cog
					if (uc($gene[$mill][$q]) eq uc($cog[3+$z][$n])) {$cogle++; $gene[$mill][4]=$cog[1][$n].$cog[0][$n]; goto HOLIDAY;}
				}}}
		$scogle++;	
	HOLIDAY:
	} #gene mill
	$coogle=0;
	for $n (0..$#gene) {if (length($gene[$n][21])>0) {$coogle++;}}
	print "There are ". ($cogle)." cogs matched ($coogle actual) and ".$scogle." unassigned genes out of $#gene\n";	
}	
	
	COLUMMNLESS:
	
	###############SAVE THE GENES! (& the whales)########################################################################################################################################################################################################################
	$file=">nice/".$emprefix.".txt";	
	open(AAOUT,$file) 	or die "Can't open file: $!";
	#print AAOUT ("local index\tkey\tdescription\tsequence\tmonomer\tuseless\tunique-ID\tblattner-ID\tname\tproduct-name\tswiss-prot-ID\treplicon\tstart-base\tend-base\tsynonyms\tsynonyms\tsynonyms\tsynonyms\tgene-class\tgene-class\tgene-class\tgene-class\tcog category\tcog number\tcog function\ttandem pairs\ttandem triplets\ttandem quadruplets\ttandem quintuplets\ttandem hexaplets\ttandem heptaplet\ttandem octuplets\ttandem nonaplets\ttandem plusdecaplet\t".join("\t",@Fullabc)."\n");
	print AAOUT ("internal\tkey\tref key\tdescr\tsequence\tCOG(s)\tother stuff\n");
	for $i ( 0 .. $#gene ) {
		print AAOUT (($i+1)."\t".join("\t",@{$gene[$i]})."\n");
	}
	close AAOUT;
	print "Saving $file...\n";
	#############All below does not modify the list of genes....
	
	
VORTEX:
} ###for each org!



print "All done!\n\a";



__DATA__
a.aeolicus
a.boonei
a.caulinodans
a.ferrooxidans
a.fulgidus
a.laidlawii
a.pernix
a.saccharovorans
a.sp
a.tumefaciens
b.burgdorferi
b.longum
b.subtilis
b.thetaiotaomicron
c.acetobutylicum
c.aurantiacus
c.flavus
c.glutamicum
c.hydrogenoformans
c.intestinalis
c.jejuni
c.pneumoniae
c.salexigens
c.symbiosum
c.thalassium
c.woesei
d.ethenogenes
d.peptidovorans
d.radiodurans
d.thermophilum
e.coli
e.minutum
f.nodosum
f.nucleatum
g.aurantiaca
g.thermodenitrificans
h.nrc
h.butylicus
h.thermophilus
h.walsbyi
i.hospitalis
k.cryptofilum
k.olearia
k.radiotolerans
l.araneos
l.borgpetersenii
l.buccalis
l.casei
m.acetivorans
m.aeolicus
m.boonei
m.burtonii
m.infernorum
m.jannaschii
m.kandleri
m.leprae
m.mahii
m.sp
m.pulmonis
m.ruber
m.sedula
m.silvanus
m.smithii
m.thermophila
m.mazei
m.thermautotrophicus
m.tubercolosis
n.pharaonis
n.defluvii
n.equitans
n.sp
n.maritimus
nostoc
o.iheyensis
p.abyssi
p.acanthamoebae
p.aeruginosa
p.arcticus
p.furiosus
p.horikoshii
p.ingrahamii
p.limnophilus
p.mobilis
p.multocida
p.aerophilum
r.baltica
r.marinus
r.prowazekii
r.solanacearum
r.xylanophilus
S5
s.aureus
yeast
s.marinus
s.moniliformis
s.solfataricus
s.termitidis
s.thermophilus
s.typhimurium
sul
s.sp
t.acidophilum
t.africanus
t.aquaticus
t.gammatolerans
TM7
t.maritima
t.acidaminovorans
t.pallidum
t.pendens
t.petrophila
t.radiovictrix
t.terrenum
t.thermophilus
t.volcanium
t.yellowstonii
u.urealyticum
t.italicus
c.proteolyticus