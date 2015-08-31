#! /usr/bin/perl

#code last modified 27-5-10


	$switch=0;	#if zero, the probabilities are disabled!

print "hello World\b\b\b\n";

require LWP::UserAgent;
require 'subs.pl';
@emp=empiricalfrq();

#loading of frequency tables##
open(PHOBE,'freqphobe.txt') 	or die "Can't open file: $!";

@phobelist=<PHOBE>;
shift(@phobelist);
foreach $item (@phobelist)
{
@phobeline = split(/\t/, $item);
for ($aleph = 1; $aleph <= 26; $aleph++) {$hydros[$phobeline[0]][$aleph-1]=$phobeline[$aleph];}
}

#ref table... will be needed in future...
#open(REF,'freqref.txt') 	or die "Can't open file: $!";

#@reflist=<ref>;
#foreach $item (@reflist)
#{
	#@refline = split(/\t/, $item);
	#$hydroref[$refline[0]]=$refline[1];
	#}



PICKER:

print "\n++++++++++++++++++++++++++++++++++++++++++++++++++\n";

print "Which one of these queries will the program run?\n";

print "\n\?\:  Get help any time during a prompt";
print "\nQ\:  Exit any time during a prompt";

print "\n0\:  Escherichia coli BL21(DE3)";

print "\n1\:  Saccharomyces cerevisiae S288c"; 

print "\n2\:  Mammuthus primigenius";

print "\n3\:  Tyrannosaurus rex";

print "\n4\:  Deinococcus radiodurans";

print "\n5\:  Homo sapiens";

print "\n6\:  artificial";

print "\n7\:  Haloferax volcanii";

print "\n8\:  Sulfolobus islandicus";

print "\n9\:  Pseudomonas aeruginosa";

print "\n10\: Human immunodeficiency virus 1";

print "\n11\: user input taxon id";

print "\n12\: user input general";

print "\n13\: Everything!";

print "\n14\: user paste";

print "\n15\: Test (15B has no pairs)";

print "\n16\: (Basic) from file with codon comparison";
print "\nAdding an exclamation mark skips all questions and just accepts default settings.";

print "\nnumber:";



$sphynx=<STDIN>;

chomp $sphynx;

$query  ="Dragon"; #if file comes out as this mythical query something is wrong

$jumper=0; $chuckula=1;$abbrev=0;$givenseq="";$marmite=1;$turbp=0;


if ($sphynx=~ /\!/) {print "\nTurbo Mode ON\n"; $sphynx=~ s/\!//; $turbo=1;}

if (($sphynx=~ /Q/i) || ($sphynx=~ /E/i)) {goto FUGIT;}

if (($sphynx=~ /\?/) || ($sphynx=~ /h/)) {helper(0); goto PICKER;}

if ($sphynx=~ /^0$/) {$query  ="txid469008[ORGN]";}

elsif ($sphynx=~ /^1$/) {$query  ="txid559292[ORGN]";}

elsif ($sphynx =~ /^2$/) {$query  ="txid37349[ORGN]";}

elsif ($sphynx=~ /^3$/) {$query  ="txid436495[ORGN]";}

elsif ($sphynx=~ /^4$/) {$query  ="txid1299[ORGN]";}

elsif ($sphynx=~ /^5$/) {$query  ="txid9606[ORGN]";}

elsif ($sphynx=~ /^6$/) {$query  ="txid28384[ORGN]";}

elsif ($sphynx=~ /^7$/) {$query  ="txid8239[ORGN]";}

elsif ($sphynx=~ /^8$/) {$query  ="txid40757[ORGN]";}

elsif ($sphynx=~ /^9$/) {$query  ="txid87336[ORGN]";}

elsif ($sphynx=~ /^10$/) {$query  ="txid344465[ORGN]";}

elsif ($sphynx=~ /^11$/) {print "\n Taxon id:"; $freedom=<STDIN>; $freedom=chomp($freedom); $query  ="txid$freedom\[ORGN\]";}

elsif ($sphynx=~ /^12$/) {print "\n Query:"; $freedom=<STDIN>; $freedom=chomp($freedom); $query  ="$freedom";}

elsif ($sphynx=~ /^13$/) {$query  =" txid131567[ORGN] OR txid12884[ORGN] OR txid10239[ORGN] OR txid28384[ORGN] OR txid12908[ORGN]";

print "\n*****************************************************************************\n";

print "\nNunc computator venerabilis Utentis mandato omniarum creaturarum secretum reperiet. \nIta utentis voluntas est.\n";}

elsif ($sphynx=~ /^14$/) {$jumper  =1;print "\nSequence:";$givenseq=<STDIN>; chomp $givenseq;}

elsif ($sphynx=~ /^15$/) {$jumper  =2; $givenseq="THEQUICKFOXJUMPEDOVERTHELAZYDOGGGWHYHESHOULDDOSUCHATHINGIDONTKNOWIDOKNOWTHATSOMEWORDSINENGLISHHAVETRIPLETSLIKEHEADMISTRESSSHIPORINVERNESSSHIREALTHOUGHMYFAVOURITELINGUISTICALODDITYISWELSHDIGRYPHLLLIKEINLLANELLIANOTHERISTHATTHETHGROUPUSEDTOBEWRITTENWITHSOISHOULDHAVEWRITTENANOERINGISATEGROUPISWRITTENTHAABBBCCCCDDDDDEEEEEEYOURSSINCERELYMATTEO";}

elsif ($sphynx=~ /^16$/) {

			$jumper  =3;

			open(SESAME,'fastaaa.txt') or die "Can't open file: $!";

			

			print "\nAs this fuction requires two list, one a aa and dna where every element matches, it will only accept two files named fastaaa\.txt and fastadna\.txt in the same folder as this, the fasta is doctored beforehand to be \>index tab symbol tab  second index tab trimmed sequence finishing in a line break";

			@fastalist=<SESAME>;

			$wonder=@fastalist;



			open(ALIBABA,'fastadna.txt') or die "Can't open file: $!";

			@fastaDnalist=<ALIBABA>;

			$wonderDna=@fastaDnalist;

			}

elsif ($sphynx=~ /^15B$/) {$jumper  =2; $givenseq="THE QUICK FOX JUMPED OVER THE LAZY DOG B C C D D E E E E F F F G G G G H H H N S";$sphynx=15;}



else {print "How many roads must a man walk down,\nbefore you call him a man?\nHow many seas must a white dove sail,\nbefore she sleeps in the sand?\nyes and how many times must a cannon ball fly,\nbefore they're forever banned?\n\nThe answer my friend is blowing in the wind,\nthe answer is blowing in the wind.\n";

			$jumper  =2; $sphynx=17;

			$givenseq="HOWMANYROADSMUSTAMANWALKDOWNBEFOREYOUCALLHIMAMANYESNHOWMANYSEASMUSTAWHITEDOVESAILBEFORESHESLEEPSINTHESANDYESNHOWMANYTIMESMUSTTHECANNONBALLSFLYBEFORETHEYREFOREVERBANNEDTHEANSWERMYFRIENDISBLOWININTHEWINDTHEANSWERISBLOWININTHEWINDHOWMANYTIMESMUSTAMANLOOKUPBEFOREHECANSEETHESKYYESNHOWMANYEARSMUSTONEMANHAVEBEFOREHECANHEARPEOPLECRYYESNHOWMANYDEATHSWILLITTAKETILLHEKNOWSTHATTOOMANYPEOPLEHAVEDIEDTHEANSWERMYFRIENDISBLOWININTHEWINDTHEANSWERISBLOWININTHEWINDHOWMANYYEARSCANAMOUNTAINEXISTBEFOREITSWASHEDTOTHESEAYESNHOWMANYYEARSCANSOMEPEOPLEEXISTBEFORETHEYREALLOWEDTOBEFREEYESNHOWMANYTIMESCANAMANTURNHISHEADPRETENDINGHEJUSTDOESNTSEETHEANSWERMYFRIENDISBLOWININTHEWINDTHEANSWERISBLOWININTHEWIND";}



if ($turbo==0) {
ALPHACHOICE:

	print "\n=============================================================================\n";
	print "\nThe program's output file can contain the amino acids in\.\.\.\n\.\.\.alphabetical order or in accordance to their proprieties. The latter is currently set as default. Type y to change to alphabetical order\nChoice:";
$chuckula=<STDIN>;

	chomp $chuckula;
	if (($chuckula=~ /Q/i) || ($chuckula=~ /E/i)) {goto FUGIT;}

	if (($chuckula=~ /\?/) || ($chuckula=~ /h/)) {helper(1); goto ALPHACHOICE;}

	if (($chuckula=~ /y/)||($refask=~ /Y/)) {$chuckula = 1;}
ABBACHOICE:
	print "\n=============================================================================\n";
	print "\nThe header can have the amino acids in various ways\.\.\.\n\.\.\.as words. Type 0 or simply enter\n\.\.\.three-letter code. Type 1\n\.\.\.as single letter code, Type 2\n Choice:";
	$abbrev=<STDIN>;

	chomp $abbrev;
	if (($abbrev=~ /Q/i) || ($abbrev=~ /e/i)) {goto FUGIT;}

	if (($abbrev=~ /\?/) || ($abbrev=~ /h/)) {helper(2); goto ABBACHOICE;}

	if (($abbrev=~ /1/)||($abbrev=~ /3/)) {$abbrev = 1;}

	elsif ($abbrev=~ /2/) {$abbrev = 2;} else {$abbrev = 0;}


}





# Questions 2-5, which are skipped for options 14-16.











if (($jumper==0) && ($turbo==0)) {
FILTERCHOICE:

	print "\n=============================================================================\n";

	print "\nWill search without a filter, For RefSeq only press n:";

	$refask=<STDIN>;

	chomp $refask;

	if (($refask=~ /n/)||($refask=~ /N/)) {$query = "$query AND refseq[FILT]";}
if (($refask=~ /Q/) || ($refask=~ /q/)) {goto FUGIT;}

if (($refask=~ /\?/) || ($refask=~ /h/)) {helper(3); goto FILTERCHOICE;}

KLEPTOCHOICE:

	print "\n=============================================================================\n";

	print "\nWill log every entry, if not press n:";

	$squirrel=<STDIN>;

	chomp $squirrel;

	$cutoff="none";
if (($squirrel=~ /Q/) || ($squirrel=~ /q/)) {goto FUGIT;}

if (($squirrel=~ /\?/) || ($squirrel=~ /h/)) {helper(4); goto KLEPTOCHOICE;}

	if (($squirrel=~ /n/)||($squirrel=~ /N/)) {$squirrel=0; print "\nWhat is the cutoff as in (R-P)/P > S:"; $cutoff=<STDIN>; chomp $cutoff; $cutoff=int($cutoff || 0)} else {$squirrel=1;}


	print "\n=============================================================================\n";

}
if ($jumper==0) {



	$utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";

	$db     ="protein"; 

	$report ="fasta";

	$esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";

	$esearch_result = got($esearch);

	print "\nSearching for $query in $db database\n";

	$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

	# print "\nbug spot: $esearch_result\n";

	$Count    = $1;

	$QueryKey = $2;

	$WebEnv   = $3;



	print "$Count entries for $QueryKey\n";

	# http://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?term=&db=protein&qty=16744&c_start=1&query_key=23&WebEnv=1ZQndZWxNtXUqsqnGN2g3q-Td4kztUZGUN2AHUcVKzVzw7-IprsClTfmPVbStuywA0@396D3324BB3E0CC1_0042SID&uids=&dopt=fasta&dispmax=500&sendto=t&page=1 

if ($turbo==0) {
BLINKCHOICE:

	print "\nTEST MODE: Do you want the screen to display junk? Type y for yes:";

	$blinkask    = <STDIN>;

if (($blinkask=~ /Q/) || ($blinkask=~ /q/)) {goto FUGIT;}

if (($blinkask=~ /\?/) || ($blinkask=~ /h/)) {helper(5); goto BLINKCHOICE;}

	if (($blinkask=~ /y/)||($blinkask=~ /Y/)) {$blinky = 1;}


TOTCHOICE:

	print "\nTEST MODE: The number of entries analysed will be $Count,\nif that is ok, just hit enter if not type the required number:";

	$asked    = <STDIN>;

if (($asked=~ /Q/) || ($asked=~ /q/)) {goto FUGIT;}

if (($asked=~ /\?/) || ($asked=~ /h/)) {helper(6); goto TOTCHOICE;}

	if (int($asked || 0)>0) {$Count = int($asked || 0);}

}

} elsif ($jumper==3) {

		$Count=$wonder;$retmax=1;$blinky=0; $squirrel=1;$givenseq="";

		

}

else {$Count=1;$retmax=1;$blinky=0; $squirrel=1;}









#name question













$temp="";

$indexomic;

$retmax=1;

@content= ();

#TESTING++++++++++++++++++++++++++++++++++++++++++++++++++

$file="report_$query.txt";

if ($sphynx=~ /13/) {$file="Omnia_secreta.txt";$query  ="Saint Francis on a mission";}

if ($sphynx=~ /14/) {$file="userpaste.txt";$query  ="Art-attack";}

if ($sphynx=~ /15/) {$file="gobbledeegook.txt";$query  ="Quack!";}

if ($sphynx=~ /16/) {$file="aska.txt";$query  ="Aska collection";}

if ($sphynx=~ /17/) {$file="in_the_wind.txt";$query  ="Bob Dylan";}
if ($turbo==0) {

NAMECHOICE:
print "\nthe file will be $file\.\.\.\n\.\.\.press Enter to confirm\n\.\.\.or type valid name (without extension)\nChoice\: ";

$namechange=<STDIN>;

chomp $namechange;
if (($asked=~ /^Q$/) || ($asked=~ /^quit$/)) {print "\nVery funny. Do you want to quit (type q) or call your file $asked\.txt (type any key)?"; $retard=<STDIN>; if ($retard=~ /q/) {goto FUGIT;}}

if (($asked=~ /\?/) || ($asked=~ /h/)) {helper(7); goto NAMECHOICE;}

if ($namechange ne "") {$file="$namechange.txt";}
} #snail loop


open(FILE,">$file")

	or die "Can't open file: $!";

$file="matrix_$file";
open(MATRIX,">$file") 	or die "Can't open file: $! (Please close any files with such name)";




print FILE "Hello World\n";

print FILE "Query\t$query\tEntires\t$Count\tcoutoff\t$cutoff\n";


$printout="gi_number";
if ($jumper==3) {$printout.="\t";}

$printout.="\tname\tsize\tk\/t\tpairs\texpected_pairs\ttriplets\texpected_triplets\tquadruplets\texpected_quadruplets\tquintuples\thigher_tuple_multiplets\tHisTag";
if ($switch==1) {$printout.="\tScored\tM1 binomial (0.005)\tM2 binomial (0.006)\tM3 multinomial\tM4 hydropathy multinomial\tM1 fudge\tM2 fudge\tM3 fudge\tM4 fudge\tM1 precorrection\tM2 binomial precorrection\tM3 precorrection\tM4 precorrection\tM5 precorrection\tM9 precorrection\tM10 precorrection\tgauss one\tgauss two\tgauss five\tgauss nine\tgauss ten\tsequence\trepeat_pattern\tavg_hydopathy_index";}

if ($chuckula==0) {

@whatachamacallit=namebadge($abbrev,"1x"); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"k"); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"2x"); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"3x"); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"4x"); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"5x"); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,'nx'); $printout .= whatamess( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,'p'); $printout .= whatamess( \@whatachamacallit);

} else {

@whatachamacallit=namebadge($abbrev,"1x"); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"k"); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"2x"); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"3x"); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"4x"); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,"5x"); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,'nx'); $printout .= alphabet( \@whatachamacallit);

@whatachamacallit=namebadge($abbrev,'p'); $printout .= alphabet( \@whatachamacallit);

}


if ($jumper==3) {$printout.="\tseqDna\trepliDna\ttandemDna";}

print FILE "$printout\n";
print "\n\n\tcode running,\n\t\tplease be patient\n";



#==================================================================================



# loop for each protein, the idex for the proteome loop is called indexomic



#==================================================================================





for($indexomic = 0; $indexomic < $Count; $indexomic += $retmax)

{











$bamboo=25; #as it is growing fast, currently A-Z

#get the sequence






$size=0;


if ($jumper==0) {



	$efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$indexomic&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";

	$efetch_result = got($efetch);

	@content= ();

	@content = split(/\n/, $efetch_result);

	$bigness=@content;

	$index++;

	$name="";

	$gi=0;

	$seq="";

	$size=0;





	for($i=0; $i <$bigness; $i++)

	{

		if($blinky == 1) {print "$content[$i]\n";} else {print ".";}

		chomp($content[$i]);

  		if ($content[$i] =~ /<TSeq_gi>/) 

		{

				$gi=$content[$i];

				$gi=~ s/<TSeq_gi>//s;

				$gi=~ s/<\/TSeq_gi>//s;

				$gi=~ s/^\s+//s;

		}

  		if ($content[$i] =~ /<TSeq_defline>/)

		{

			$name=$content[$i];

			$name=~ s/<TSeq_defline>//s;

			$name=~ s/<\/TSeq_defline>//s;

			$name=~ s/^\s+//s;

		}

  		if ($content[$i] =~ /<TSeq_sequence>/)

		{

			$seq=$content[$i];

			$seq=~ s/<TSeq_sequence>//s;

			$seq=~ s/<\/TSeq_sequence>//s;

			$seq=~ s/^\s+//s;

		}

	

	} #tag sorting loop





}    # end of jumper exception



if ($jumper>0) {$seq=$givenseq;}





#================FASTA====================================



if ($jumper==3) {

	@fastaline = split(/\t/, $fastalist[$indexomic]);$seq=$fastaline[3]; chomp($seq);

	@fastaDnaline = split(/\t/, $fastaDnalist[$indexomic]);$seqDna=$fastaDnaline[3]; chomp($seqDna);

	@dna= $seqDna =~ /(.{1,3})/g;

}



#====================FASTA========================================	









# look for doubles in sequence














$seq=~ s/\n//msg;
$seq=~ s/\W//g;

chomp($seq);
@aa = split(//, $seq);

$size=@aa;
if ($size<1) {goto CODSWALLOP;}



		$predict=int($size/20);

		$predict3=int($size/400);

		$predict4=int($size/8000);

		$double=0;

		$triple=0;

		$quad=0;

		$quint=0;

		$multi=0;

		$repli="";

		$histag=0;

@onecounter=();

@twocounter=();

@threecounter=();

@fourcounter=();

@fivecounter=();

@manycounter=();		
@listerine=map {0} (0..25);
@onecounter=@listerine;
@twocounter=@listerine;
@threecounter=@listerine;
@fourcounter=@listerine;
@fivecounter=@listerine;
@manycounter=@listerine;
@totalcounter=@listerine;
@hydrocounter=();
@probcounter=@listerine;
@prosp=@listerine;
@pronp=@listerine;
@hp=();
@xp=();
@bisp=();
@binp=();
@hydron=();


for ($mill = 0; $mill <= $size-1; $mill++)

{

 if (ord($aa[$mill]) ==65) {$hp[$mill]=1.8;}
 if (ord($aa[$mill]) ==82) {$hp[$mill]=-4.5;}
 if (ord($aa[$mill]) ==78) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==68) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==67) {$hp[$mill]=2.5;}
 if (ord($aa[$mill]) ==81) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==69) {$hp[$mill]=-3.5;}
 if (ord($aa[$mill]) ==71) {$hp[$mill]=-0.4;}
 if (ord($aa[$mill]) ==72) {$hp[$mill]=-3.2;}
 if (ord($aa[$mill]) ==73) {$hp[$mill]=4.5;}
 if (ord($aa[$mill]) ==76) {$hp[$mill]=3.8;}
 if (ord($aa[$mill]) ==75) {$hp[$mill]=-3.9;}
 if (ord($aa[$mill]) ==77) {$hp[$mill]=1.9;}
 if (ord($aa[$mill]) ==70) {$hp[$mill]=2.8;}
 if (ord($aa[$mill]) ==80) {$hp[$mill]=-1.6;}
 if (ord($aa[$mill]) ==83) {$hp[$mill]=-0.8;}
 if (ord($aa[$mill]) ==84) {$hp[$mill]=-0.7;}
 if (ord($aa[$mill]) ==87) {$hp[$mill]=-0.9;}
 if (ord($aa[$mill]) ==89) {$hp[$mill]=-1.3;}
 if (ord($aa[$mill]) ==86) {$hp[$mill]=4.2;}
}

if ($size<13) {
	$xpt=0;
	for ($mill = 0; $mill <= $size; $mill++) { $xpt +=$hp[$mill];}
	$xpt = int(10*($xpt/$size))+50;
	@xp=map {$xpt} ( 0 .. $size );
} else {
$xpt=0;
for ($mill = 0; $mill <= 5; $mill++) { $xpt +=$hp[$mill];}
$xpt = int(10*($xpt/6))+50;
for ($mill = 0; $mill <= 5; $mill++) { $xp[$mill]=$xpt;}
for ($mill = 6; $mill <= ($size-6); $mill++)
	{
	$xp[$mill]=0;
	for ($deca = ($mill-5); $deca <= ($mill+4); $deca++) { $xp[$mill] +=$hp[$deca];}
	$xp[$mill] = int($xp[$mill])+50;
	}

$xpt=0;
for ($mill = ($size-5); $mill <= $size; $mill++) { $xpt +=$hp[$mill];}
$xpt = int(10*($xpt/5))+50;
for ($mill = ($size-5); $mill <= $size; $mill++) { $xp[$mill]=$xpt;}


}
	

		$tandemDna=0;$repliDna="";




# Analyse!			

for ($mill = 0; $mill <= $size-1; $mill++)

{





#C-counters are the total number of aa.

@thisround=();

@thisround=counter($aa[$mill]);				

@onecounter= map { $onecounter[$_] + $thisround[$_] } ( 0..$bamboo );
$hydron[$xp[$mill]]++;

@globalcounter= map { $globalcounter[$_] + $thisround[$_] } ( 0..25 );
for ($paperround=65;$paperround<=90;$paperround++) { if (ord($aa[$mill]) == $paperround) {
	for ($mailrun=65;$mailrun<=90;$mailrun++) {
		if (ord($aa[$mill+1]) == $mailrun) {$pinomatrix[$paperround-65][$mailrun-65]++;}}
	}
}




if ($skipper<=0) {
$skipper=0;


if ($aa[$mill] eq "$aa[$mill+1]")

	{

		if ($aa[$mill] eq "$aa[$mill+2]")

		{

				if ($aa[$mill] eq "$aa[$mill+3]")

				{

					if ($aa[$mill] eq "$aa[$mill+4]")

					{

						

						if ($aa[$mill] eq "$aa[$mill+5]")

						{

						if (($aa[$mill] ne "$aa[$mill+6]") && ($aa[$mill] eq "H")) {$histag++;}

						else {							

							$multiCount=$mill;

							if ($jumper==3) {$repliDna="$repliDna\-";}

							until ($aa[$mill] ne "$aa[($multiCount)]")

								{

								$multiCount++;

								}

							$multi++;$multiCount=$multiCount-$mill;

												

							$repli="$repli\:$gap:$aa[$mill]x$multiCount";

							@thisround=();

							@thisround=counter($aa[$mill]);				

							@manycounter= map { $manycounter[$_] + $thisround[$_] } ( 0..$bamboo );

							if ($jumper==3) { $repliDna="$repliDna:$dna[$mill]";}

							$skipper=$multiCount-1;

							$gap=0;$multiCount=0;
							



				







						}} else

						{	# quintuplet (else of multiplet if)

							$quint++;

				$repli="$repli\:$gap:$aa[$mill]$aa[$mill]$aa[$mill]$aa[$mill]$aa[$mill]";

				$gap=0;

				@thisround=();

				@thisround=counter($aa[$mill]);				

				@fivecounter= map { $fivecounter[$_] + $thisround[$_] } ( 0..$bamboo );

				if ($jumper==3) { $repliDna="$repliDna:$dna[$mill]";}
				$skipper=4;

						}	# quintuplet (else of multiplet if)

					} else

					{	# quadruplet (else of quintuplet if)

						$quad++;

				$repli="$repli\:$gap:$aa[$mill]$aa[$mill]$aa[$mill]$aa[$mill]";

				$gap=0;

				@thisround=();

				@thisround=counter($aa[$mill]);				

				@fourcounter= map { $fourcounter[$_] + $thisround[$_] } ( 0..$bamboo );

				if ($jumper==3) { $repliDna="$repliDna:$dna[$mill]";}
				$skipper=3;

					}	# quadruplet (else of quintuplet if)

				} else

				{	# triplet (else of quadruplet if)

				$triple++;

				$repli="$repli\:$gap:$aa[$mill]$aa[$mill]$aa[$mill]";

				$gap=0;

				@thisround=();

				@thisround=counter($aa[$mill]);				

				@threecounter= map { $threecounter[$_] + $thisround[$_] } ( 0..$bamboo );
				if ($jumper==3) { $repliDna="$repliDna:$dna[$mill]";}
				$skipper=2;

				}	# triplet (else of quadruplet if)

		} else

		{	# pair (else of triplet if)

				$double++;

				$repli="$repli\:$gap:$aa[$mill]$aa[$mill]";

				$gap=0;

				@thisround=();

				@thisround=counter($aa[$mill]);				

				@twocounter= map { $twocounter[$_] + $thisround[$_] } ( 0..$bamboo );

				if ($jumper==3) { $repliDna="$repliDna:$dna[$mill]";}

				$skipper=1;

		}	# pair (else of triplet if)



	a} else

	{	# no pair (else of pair if)

				$gap++;

	}	# no pair (else of pair if)




			

} else {$skipper--;
if ($jumper==3) { $repliDna="$repliDna:$dna[$mill]"; $redundant++; if ($dna[$mill-1] eq "$dna[$mill]") {$tandemDna++; $pdna *= dnachance($aa[$mill]);} else {$npdna *= 1-dnachance($aa[$mill]);}  #codon equlity else of if
		} #end of if codons
$hydrocounter[$xp[$mill]][ord($aa[$mill])-65]++;
$totalcounter[ord($aa[$mill])-65]++;
} #end of else of skipper

																
} # double checker loop





	$repli="$repli\:$gap";

	if ($predict>0) {if ($predict3>0) {$scored=($double-$predict)/$predict+($triple-$predict3)/$predict3} else {$scored=($double-$predict)/$predict;}} else {$score=$double;}

	if ($jumper>0) {$gi="NA";$name="custom";}

	if ($jumper==3) {$gi="$fastaline[0]\t$fastaline[2]";$name=$fastaline[1];}




$printout="";
	###################

	$total=$double+$triple*2+$quad*3+$quint*4+$multi*6;
	$kt=int($total/$size*100)/100;	
	
	
	if ($switch==1) {	
	
######ORIGINAL##############

#pppppppppppppppppppppppppppppppppppp
#PROBABILITY MODEL ZONE

if ($size<1) {$size=1; print "codswallop\n"; goto CODSWALLOP;}


#model 1 assumed equiprobability of amino acids and totally random distribution of amino acids: binomial
$total=$double+$triple*2+$quad*3+$quint*4+$multi*6;
$modelone=probably($total,$size,0.05);
$dividend=probably(int($size*0.05),$size,0.05);
if ($dividend>0)  {$cormodelone=$modelone/$dividend*0.0965365491651628;} else {$$cormodelone="\!";}

#model 2 assumed totally random distribution of amino acids and a skewed distribution of probability of amino acids which is nothing to worry about so the sum of the elements in the probability vector: binomial 
$modeltwo=probably($total,$size,0.06);
$dividend=probably(int($size*0.06),$size,0.06);
if ($dividend>0)  {$cormodeltwo=$modeltwo/$dividend*0.0965365491651628;} else {$$cormodeltwo="\!";}

#model 3 assumed totally random distribution of amino acids and a skewed distribution of probability of amino acids which is taken into account: multinomial
$modelfour=1;
$dividend=1;
@ricimer=();
@meds=();
@ricimer=map {$emp[$_]**2} (0..25);

$modelthree=logmulti(\@totalcounter,$size,\@ricimer);
for ($mill = 0; $mill <= 25; $mill++) {$meds[$mill]=int($size*$ricimer[$mill]);}
$dividend=logmulti(\@meds,$size,\@ricimer);
if ($dividend>0)  {$cormodelthree=$modelthree/$dividend*0.0965365491651628;} else {$cormodelthree="\!";}
#if ($cormodelthree>1) {print "Model 3 error: $modelthree and $dividend\n";for ($mill = 0; $mill <= 25; $mill++) {print chr($mill+65) . "\:\t$totalcounter[$mill]\t$ricimer[$mill]\n";}}

#model 4 takes into account the skewed distribution of probability of amino acids and the fact that it is influenced by hydrophobicity: multinomial
$modelfour=1;
$dividend=1;
@nero=();
@peracles=();
@leonidas=();
@vercingetorix=();
for ($mill = 0; $mill <= 100; $mill++) {
if ($hydron[$mill]>0) {
	@peracles=@{ $hydrocounter[$mill]};
	@nero=@{ $hydros[$mill]};
	@leonidas=map {$nero[$_]**2}(0..25);
	$modelfour *=logmulti(\@peracles,$hydron[$mill],\@leonidas);
	@vercingetorix=map {int($hydron[$mill] * $leonidas[$_])} (0..25);
	$dividend *=logmulti(\@vercingetorix,$hydron[$mill],\@leonidas);
	$outlet=$mill/10-5;
}
}


if ($dividend>0)  {$cormodelfour=$modelfour/$dividend*0.0965365491651628;} else {$cormodelfour="\!";}



#model 5 is a fit with a posteriori knowledge

#model 6 is a local model 2, just for fun

#model 7 is a local model 3, just for fun

#aa specific
for ($prindex=0; $prindex<=$bamboo; $prindex++) {$dividend=probably((($onecounter[$prindex]/$size)**2)*$size,$size,($onecounter[$prindex]/$size)**2); if ($dividend>0) {$probcounter[$prindex]=probably($twocounter[$prindex]+$threecounter[$prindex]*2+$fourcounter[$prindex]*3+$fivecounter[$prindex]*4+$manycounter[$prindex]*6,$size,($onecounter[$prindex]/$size)**2)/$dividend*0.09653654916516280;}}

#total xp
$DnD=0; #remeber that your character is dead only when it reaches -10...if only you hadn't called your teammate a lardball, he would save you now...
for ($mill = 0; $mill <= $size; $mill++) {$DnD +=$xp[$mill]/$size;}

#pppppppppppppppppppppppppppppppppppppppp

############################################################################
######REDUX##############


#pppppppppppppppppppppppppppppppppppp
#PROBABILITY MODEL ZONE

if ($size<1) {$size=1; print "codswallop\n"; goto CODSWALLOP;}
$weight=300/$size;

#model 1 assumed equiprobability of amino acids and totally random distribution of amino acids: binomial
$total=$double+$triple*2+$quad*3+$quint*4+$multi*6;
$kt=int($total/$size*100)/100;
$totale =int($total *$weight +0.5);
$premodelone=probably($totale,300,0.05);
$gaussone=gauss($total,300,0.05);

#model 2 assumed totally random distribution of amino acids and a skewed distribution of probability of amino acids which is nothing to worry about so the sum of the elements in the probability vector: binomial 
$premodeltwo=probably($totale,300,0.06);
$gausstwo=probably($total,300,0.06);

#local prob... model 5
$localp=0;
foreach $sindex (@onecounter) {$localp += ($onecounter[$sindex]/$size)**2; $megasum += $twocounter[$prindex]+$threecounter[$prindex]*2+$fourcounter[$prindex]*3+$fivecounter[$prindex]*4+$manycounter[$prindex]*6;}
$premodelfive=probably($totale,300,$localp);
$gaussfive=gauss($total,300,$localp);


#model 3 assumed totally random distribution of amino acids and a skewed distribution of probability of amino acids which is taken into account: multinomial
$premodelthree=1;
@ricimer=();
@meds=();
@ricimer=map {$emp[$_]**2} (0..25);
@elagabalus=map {int($totalcounter[$_]*$weight+0.5)}
$premodelthree=logmulti(\@elagabalus,300,\@ricimer);
$gaussthree=0;
#$gaussthree=multigauss(\@elagabalus,300,\@ricimer);

#model 4 takes into account the skewed distribution of probability of amino acids and the fact that it is influenced by hydrophobicity: multinomial
$premodelfour=1;
$premodelnine=1;
$premodelten=1;
$gaussnine=1;
$gaussten=1;
@nero=();
@peracles=();
@leonidas=();
@vercingetorix=();
for ($mill = 0; $mill <= 100; $mill++) {

if ($hydron[$mill]>0) {
	$localp=0;
	@peracles=map{$hydrocounter[$mill][$_]} (0..25);
	foreach $sindex (@peracles) {$localp += ($peracles[$sindex]/$hydron[$mill])**2;}
}

$nhydro=$hydron[$mill]*$weight;	
$hydron[$mill]=int($hydron[$mill]*$weight+0.5);
if ($hydron[$mill]>0) {
	@peracles=map{int($hydrocounter[$mill][$_]*$weight+0.5)} (0..25);
	@nero=@{ $hydros[$mill]};
	@leonidas=map {$nero[$_]**2}(0..25);
	$premodelfour *=logmulti(\@peracles,$hydron[$mill],\@leonidas);
	$augustus=0;$caesar=0;
	for ($aleph=0; $aleph<=25; $aleph++) {$augustus +=$leonidas[$aleph];$caesar +=$hydrocounter[$mill][$aleph];}
	$khydro=$caesar*$weight;
	$caesar=int(0.5+$caesar*$weight);
	if ($caesar>$hydron[$mill]) {$caesar=$hydron[$mill]; print "whale\n";}
	$temp=probably($caesar, $hydron[$mill],$augustus);
	if ($temp>0) {$premodelnine *=$temp;}
	$temp=probably($caesar,$hydron[$mill],$localp);
	if ($temp>0) {$premodelten *=$temp;}
	
	
}
if ($nhydro>1) {
	$temp=gauss($khydro,$nhydro,$augustus);
	if ($temp>0) {$gaussnine *=$temp;}  

	$temp=gauss($khydro, $nhydro, $localp);
	if ($temp>0) {$gaussten *=$temp;}
}
}





#pppppppppppppppppppppppppppppppppppppppp


















if ($modelone>1) {$modelone="!";}
if ($modeltwo>1) {$modeltwo="!";}
if ($modelthree>1) {$modelthree="!";}
if ($modelfour>1) {$modelfour="!";}
if ($cormodelone>1) {$cormodelone="!";}
if ($cormodeltwo>1) {$cormodeltwo="!";}
if ($cormodelthree>1) {$cormodelthree="!";}
if ($cormodelfour>1) {$cormodelfour="!";}
if ($premodelone>1) {$premodelone="!";}
if ($premodeltwo>1) {$premodeltwo="!";}
if ($premodelthree>1) {$premodelthree="!";}
if ($premodelfour>1) {$premodelfour="!";}
if ($$premodelfive>1) {$premodelfive="!";}
if ($$premodelnine>1) {$premodelnine="!";}
if ($$premodelten>1) {$premodelten="!";}

	}

$seq=~ s/\n//msg;
$seq=~ s/\r//msg;  #I hate Macs! Why does nobody have a clue? They barely have unicode support in 2010! Just because Paup* has a menu (completely useless) and MacVector (identical to VectorNTI) but most importantly it looks pretty?!?! 
$gi=~ s/\>//msg;		
$gi=~ s/\x3E//msg;
$printout="$gi\t$name\t$size\t$kt\t$double\t$predict\t$triple\t$predict3\t$quad\t$predict4\t$quint\t$multi\t$histag";
	if ($switch==1) {$printout.="\t$scored\t$modelone\t$modeltwo\t$modelthree\t$modelfour\t$cormodelone\t$cormodeltwo\t$cormodelthree\t$cormodelfour\t$premodelone\t$premodeltwo\t$premodelthree\t$premodelfour\t$premodelfive\t$premodelnine\t$premodelten\t$gaussone\t$gausstwo\t$gaussfive\t$gaussnine\t$gaussten\t$seq\t$repli\t$DnD";}



if ($chuckula==0) {

$printout .= whatamess(\@onecounter);

$printout .= whatamess(\@totalcounter);

$printout .= whatamess(\@twocounter);

$printout .= whatamess(\@threecounter);

$printout .= whatamess(\@fourcounter);

$printout .= whatamess(\@fivecounter);

$printout .= whatamess(\@manycounter);

$printout .= whatamess(\@probcounter);
#$printout .= whatamess(\@prosp);

} else {

$printout .= alphabet(\@onecounter);


$printout .= alphabet(\@totalcounter);

$printout .= alphabet(\@twocounter);

$printout .= alphabet(\@threecounter);

$printout .= alphabet(\@fourcounter);

$printout .= alphabet(\@fivecounter);

$printout .= alphabet(\@manycounter);

$printout .= alphabet(\@probcounter);
#$printout .= alphabet(\@prosp);

}

if ($jumper==3) {$printout.="\t$seqDna\t$repliDna\t$tandemDna";}
	
$printout=~ s/\r//msg;
$printout=~ s/\n//msg;

	if ($squirrel==1){print FILE "$printout\n";}

	else {if ($scored>$cutoff) {print FILE "$printout\n";}}		

$printout="";  

CODSWALLOP:

}  #loop to get each sequences



#==================================================================================



print MATRIX "\/\t";
for $i (0..25) {print MATRIX (chr($i+65) . "\t");}
print MATRIX "\n";
for $i ( 0 .. $#pinomatrix ) {
        for $j ( 0 .. $#{$pinomatrix[$i]} ) {
            print MATRIX "$pinomatrix[$i][$j]\t";
        }
	print MATRIX "\n";
	print MATRIX (chr($i+65) . "\t");
}


close FILE; close SESAME; close MATRIX;

print "=====================================================================";

print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";

print "\nDone\a";

FUGIT:

end;
