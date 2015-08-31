#!/usr/bin/perl
use LWP::Simple;
require Encode;

#copy paste of code need a clean up... make A-Z in array and use ord and chr loops
#======================Open file and add header


$file="wikioutput.txt";
open(FILE,">$file")
	or die "Can't open file: $!";

			
	print FILE "word\tlink\tid\tordered\tsize\tletters\tvowel\tpair\tTriplet\tQuadruplet\tnon-ascii\tid_of_non-ascii\textravowel\tnonvowel\tQ_without_U\tHash\t";
	print FILE "C_a\tC_b\tC_c\tC_d\tC_e\tC_f\tC_g\tC_h\tC_i\tC_j\tC_k\tC_l\tC_m\tC_n\tC_o\tC_p\tC_q\tC_r\tC_s\tC_t\tC_u\tC_v\tC_w\tC_x\tC_y\tC_z\t";
	print FILE "D_a\tD_b\tD_c\tD_d\tD_e\tD_f\tD_g\tD_h\tD_i\tD_j\tD_k\tD_l\tD_m\tD_n\tD_o\tD_p\tD_q\tD_r\tD_s\tD_t\tD_u\tD_v\tD_w\tD_x\tD_y\tD_z\t";
	print FILE "T_a\tT_b\tT_c\tT_d\tT_e\tT_f\tT_g\tT_h\tT_i\tT_j\tT_k\tT_l\tT_m\tT_n\tT_o\tT_p\tT_q\tT_r\tT_s\tT_t\tT_u\tT_v\tT_w\tT_x\tT_y\tT_z\t";
		print FILE "phrase\tnoun\tverb\tproper\tadj\tadv\tconj\tinvalid\tletter\tint\tsymbol\tabbr\tinit\tfix\tprep\n";
print "hello World\n";
print "\n++++++++++++++++++++++++++++++++++++++++++++++++++\n";

#a to z using http://en.wiktionary.org/w/index.php?title=Template:index/English&action=edit

#====================pages to look at
#testmode 
@wiktindex=("0","a1");
#full mode
@wiktindex=("0","a1","a2","b1","b2","c1","c2","d","e","f","g","h","i","j","k","l","m1","m2","n","o","p1","p2","q","r","s1","s2","t1","t2","u","v","w","x","y","z");

#====================loop for each page of @wiktindex


foreach $query (@wiktindex){

#====================extract only [[name]], the last ] is kept as a delimitator

$url="http://en.wiktionary.org/w/index.php?title=Index:English/$query&action=raw";
$query_result = get($url);
$query_result =~ s/\=\=\=.*?\=\=\=//g;
$query_result =~ s/\=\=.*?\=\=//g;
$query_result =~ s/\{\{.*?\}\}//g;
$query_result =~ s/\<\/div\>.*$//msg;

#====================make list of words in @list

@list= ();
@list = split(/\# /, $query_result);

foreach $currententry (@list) {
if ($currententry =~ /\[\[(.*?)\]\] \'\'(.*?)\'\'/) {
        $currentword = $1;
        $currentid = $2;
	$link= "\[\[$currentword\]\]";

# reset all counters

	$pair=0; $triplet=0;$quadruplet=0;$eszett=0;$apostrophe=0;$thorn=0;$edh=0;$accents=0;$cedilla=0;$hash=0;
	$Ca=0;$Cb=0;$Cc=0;$Cd=0;$Ce=0;$Cf=0;$Cg=0;$Ch=0;$Ci=0;$Cj=0;$Ck=0;$Cl=0;$Cm=0;$Cn=0;$Co=0;$Cp=0;$Cq=0;$Cr=0;$Cs=0;$Ct=0;$Cu=0;$Cv=0;$Cw=0;$Cx=0;$Cy=0;$Cz=0;
	$Da=0;$Db=0;$Dc=0;$Dd=0;$De=0;$Df=0;$Dg=0;$Dh=0;$Di=0;$Dj=0;$Dk=0;$Dl=0;$Dm=0;$Dn=0;$Do=0;$Dp=0;$Dq=0;$Dr=0;$Ds=0;$Dt=0;$Du=0;$Dv=0;$Dw=0;$Dx=0;$Dy=0;$Dz=0;
	$Ta=0;$Tb=0;$Tc=0;$Td=0;$Te=0;$Tf=0;$Tg=0;$Th=0;$Ti=0;$Tj=0;$Tk=0;$Tl=0;$Tm=0;$Tn=0;$To=0;$Tp=0;$Tq=0;$Tr=0;$Ts=0;$Tt=0;$Tu=0;$Tv=0;$Tw=0;$Tx=0;$Ty=0;$Tz=0;
	$Nqu=0;$size=0;$flagged=0;$ordered="";$space=0;$vowel=0;$nonascii=0;$utf="";


#remove non ascii <<no, and fix some errors such as hello#English|hello into hello=========
 
	$currentword =~s/.*\#English\|//;
	$currentword =~ s/^\s//;
	
#============Name is saved before op==========================
	$extravowel=0;$nonvowel=0;
	$name=$currentword;
	$currentword =~ tr/\=/ /; #impossible but better safe than sorry
	$extravowel += ($currentword=~ s/\x{00C0}/A/g);
	$extravowel += ($currentword=~ s/\x{00C1}/A/g);
	$extravowel += ($currentword=~ s/\x{00C2}/A/g);
	$extravowel += ($currentword=~ s/\x{00C3}/A/g);
	$extravowel += ($currentword=~ s/\x{00C4}/A/g);
	$extravowel += ($currentword=~ s/\x{00C6}/AE/g);
	$nonvowel += ($currentword=~ s/\x{00C7}/C/g);
	$extravowel += ($currentword=~ s/\x{00C8}/E/g);
	$extravowel += ($currentword=~ s/\x{00C9}/E/g);
	$extravowel += ($currentword=~ s/\x{00CA}/E/g);
	$extravowel += ($currentword=~ s/\x{00CB}/E/g);
	$extravowel += ($currentword=~ s/\x{00CC}/I/g);
	$extravowel += ($currentword=~ s/\x{00CD}/I/g);
	$extravowel += ($currentword=~ s/\x{00CE}/I/g);
	$extravowel += ($currentword=~ s/\x{00CF}/I/g);
	$nonvowel += ($currentword=~ s/\x{00D0}/Dh/g);
	$nonvowel += ($currentword=~ s/\x{00D1}/N/g);
	$extravowel += ($currentword=~ s/\x{00D2}/O/g);
	$extravowel += ($currentword=~ s/\x{00D3}/O/g);
	$extravowel += ($currentword=~ s/\x{00D4}/O/g);
	$extravowel += ($currentword=~ s/\x{00D5}/O/g);
	$extravowel += ($currentword=~ s/\x{00D6}/O/g);
	$extravowel += ($currentword=~ s/\x{00D8}/O/g);
	$extravowel += ($currentword=~ s/\x{00D9}/U/g);
	$extravowel += ($currentword=~ s/\x{00DA}/U/g);
	$extravowel += ($currentword=~ s/\x{00DB}/U/g);
	$extravowel += ($currentword=~ s/\x{00DC}/U/g);
	$extravowel += ($currentword=~ s/\x{00DD}/Y/g);
	$nonvowel += ($currentword=~ s/\x{00DE}/Th/g);
	$nonvowel += ($currentword=~ s/\x{00DF}/ss/g);

	$extravowel += ($currentword=~ s/\x{00E0}/A/g);
	$extravowel += ($currentword=~ s/\x{00E1}/A/g);
	$extravowel += ($currentword=~ s/\x{00E2}/A/g);
	$extravowel += ($currentword=~ s/\x{00E3}/A/g);
	$extravowel += ($currentword=~ s/\x{00E4}/A/g);
	$extravowel += ($currentword=~ s/\x{00E6}/AE/g);
	$nonvowel += ($currentword=~ s/\x{00E7}/C/g);
	$extravowel += ($currentword=~ s/\x{00E8}/E/g);
	$extravowel += ($currentword=~ s/\x{00E9}/E/g);
	$extravowel += ($currentword=~ s/\x{00EA}/E/g);
	$extravowel += ($currentword=~ s/\x{00EB}/E/g);
	$extravowel += ($currentword=~ s/\x{00EC}/I/g);
	$extravowel += ($currentword=~ s/\x{00ED}/I/g);
	$extravowel += ($currentword=~ s/\x{00EE}/I/g);
	$extravowel += ($currentword=~ s/\x{00EF}/I/g);
	$nonvowel += ($currentword=~ s/\x{00F0}/Dh/g);
	$nonvowel += ($currentword=~ s/\x{00F1}/N/g);
	$extravowel += ($currentword=~ s/\x{00F2}/O/g);
	$extravowel += ($currentword=~ s/\x{00F3}/O/g);
	$extravowel += ($currentword=~ s/\x{00F4}/O/g);
	$extravowel += ($currentword=~ s/\x{00F5}/O/g);
	$extravowel += ($currentword=~ s/\x{00F6}/O/g);
	$extravowel += ($currentword=~ s/\x{00F8}/O/g);
	$extravowel += ($currentword=~ s/\x{00F9}/U/g);
	$extravowel += ($currentword=~ s/\x{00FA}/U/g);
	$extravowel += ($currentword=~ s/\x{00FB}/U/g);
	$extravowel += ($currentword=~ s/\x{00FC}/U/g);
	$extravowel += ($currentword=~ s/\x{00FD}/Y/g);
	$nonvowel += ($currentword=~ s/\x{00FE}/Th/g);
	$nonvowel += ($currentword=~ s/\x{00DF}/y/g);

	$nonascii=$extravowel+$nonvowel;


#==================upPER casE===========================================

	$currentword =uc ($currentword);
	#$currentword =chomp ($currentword);

#analyse=============================================================

	@word = split(//, $currentword);
	$size=@word;
	
	for ($mill = 0; $mill <= $size; $mill++) { 	if( ord($word[$mill]) > 127 ) {$nonascii++;$utf .= $word[$mill];$word[$mill]="\?";} } 
	for ($mill = 0; $mill <= $size; $mill++) {

		if ($word[$mill+1] eq "$word[$mill]") {
			if ($word[$mill+2] eq "$word[$mill]") {
				if ($word[$mill+3] eq "$word[$mill]") {if ($word[$mill+5] eq "$word[$mill]") {$runaway++;} else {$quadruplet++;}} else {
					$triplet++;
					if ($word[$mill] eq "A") {$Ta++;$Tvowel++;}
					if ($word[$mill] eq "B") {$Tb++;}
					if ($word[$mill] eq "C") {$Tc++;}
					if ($word[$mill] eq "D") {$Td++;}
					if ($word[$mill] eq "E") {$Te++;$Tvowel++;}
					if ($word[$mill] eq "F") {$Tf++;}
					if ($word[$mill] eq "G") {$Tg++;}
					if ($word[$mill] eq "H") {$Th++;}
					if ($word[$mill] eq "I") {$Ti++;$Tvowel++;}
					if ($word[$mill] eq "J") {$Tj++;}
					if ($word[$mill] eq "K") {$Tk++;}
					if ($word[$mill] eq "L") {$Tl++;}
					if ($word[$mill] eq "M") {$Tm++;}
					if ($word[$mill] eq "N") {$Tn++;}
					if ($word[$mill] eq "O") {$To++;$Tvowel++;}
					if ($word[$mill] eq "P") {$Tp++;}
					if ($word[$mill] eq "Q") {$Tq++;}
					if ($word[$mill] eq "R") {$Tr++;}
					if ($word[$mill] eq "S") {$Ts++;}
					if ($word[$mill] eq "T") {$Tt++;}
					if ($word[$mill] eq "U") {$Tu++;$Tvowel++;}
					if ($word[$mill] eq "V") {$Tv++;}
					if ($word[$mill] eq "W") {$Tw++;}
					if ($word[$mill] eq "X") {$Tx++;}
					if ($word[$mill] eq "Y") {$Ty++;}
					if ($word[$mill] eq "Z") {$Tz++;}
				}
			} else {$pair++;
				if ($word[$mill] eq "A") {$Da++;$Dvowel++;}
				if ($word[$mill] eq "B") {$Db++;}
				if ($word[$mill] eq "C") {$Dc++;}
				if ($word[$mill] eq "D") {$Dd++;}
				if ($word[$mill] eq "E") {$De++;$Dvowel++;}
				if ($word[$mill] eq "F") {$Df++;}
				if ($word[$mill] eq "G") {$Dg++;}
				if ($word[$mill] eq "H") {$Dh++;}
				if ($word[$mill] eq "I") {$Di++;$Dvowel++;}
				if ($word[$mill] eq "J") {$Dj++;}
				if ($word[$mill] eq "K") {$Dk++;}
				if ($word[$mill] eq "L") {$Dl++;}
				if ($word[$mill] eq "M") {$Dm++;}
				if ($word[$mill] eq "N") {$Dn++;}
				if ($word[$mill] eq "O") {$Do++;$Dvowel++;}
				if ($word[$mill] eq "P") {$Dp++;}
				if ($word[$mill] eq "Q") {$Dq++;}
				if ($word[$mill] eq "R") {$Dr++;}
				if ($word[$mill] eq "S") {$Ds++;}
				if ($word[$mill] eq "T") {$Dt++;}
				if ($word[$mill] eq "U") {$Du++;$Dvowel++;}
				if ($word[$mill] eq "V") {$Dv++;}
				if ($word[$mill] eq "W") {$Dw++;}
				if ($word[$mill] eq "X") {$Dx++;}
				if ($word[$mill] eq "Y") {$Dy++;}
				if ($word[$mill] eq "Z") {$Dz++;}
			}
		}
		
		if ($word[$mill] eq "A") {$Ca++;$Cvowel++;}
		if ($word[$mill] eq "B") {$Cb++;}
		if ($word[$mill] eq "C") {$Cc++;}
		if ($word[$mill] eq "D") {$Cd++;}
		if ($word[$mill] eq "E") {$Ce++;$Cvowel++;}
		if ($word[$mill] eq "F") {$Cf++;}
		if ($word[$mill] eq "G") {$Cg++;}
		if ($word[$mill] eq "H") {$Ch++;}
		if ($word[$mill] eq "I") {$Ci++;$Cvowel++;}
		if ($word[$mill] eq "J") {$Cj++;}
		if ($word[$mill] eq "K") {$Ck++;}
		if ($word[$mill] eq "L") {$Cl++;}
		if ($word[$mill] eq "M") {$Cm++;}
		if ($word[$mill] eq "N") {$Cn++;}
		if ($word[$mill] eq "O") {$Co++;$Cvowel++;}
		if ($word[$mill] eq "P") {$Cp++;}
		if ($word[$mill] eq "Q") {$Cq++; if ($word[$mill+1] ne "U") {$Nqu++;}}
		if ($word[$mill] eq "R") {$Cr++;}
		if ($word[$mill] eq "S") {$Cs++;}
		if ($word[$mill] eq "T") {$Ct++;}
		if ($word[$mill] eq "U") {$Cu++;$Cvowel++;}
		if ($word[$mill] eq "V") {$Cv++;}
		if ($word[$mill] eq "W") {$Cw++;}
		if ($word[$mill] eq "X") {$Cx++;}
		if ($word[$mill] eq "Y") {$Cy++;}
		if ($word[$mill] eq "Z") {$Cz++;}
		if ($word[$mill] eq "-") {$hyphen++;}
		if ($word[$mill] eq "\#") {$hash++;}
		if ($word[$mill] eq "\s") {$space++;}

	}
	
		for ($i=0;$i<$Ca;$i++) {$ordered.="a";}
		for ($i=0;$i<$Cb;$i++) {$ordered.="b";}
		for ($i=0;$i<$Cc;$i++) {$ordered.="c";}
		for ($i=0;$i<$Cd;$i++) {$ordered.="d";}
		for ($i=0;$i<$Ce;$i++) {$ordered.="e";}
		for ($i=0;$i<$Cf;$i++) {$ordered.="f";}
		for ($i=0;$i<$Cg;$i++) {$ordered.="g";}
		for ($i=0;$i<$Ch;$i++) {$ordered.="h";}
		for ($i=0;$i<$Ci;$i++) {$ordered.="i";}
		for ($i=0;$i<$Cj;$i++) {$ordered.="j";}
		for ($i=0;$i<$Ck;$i++) {$ordered.="k";}
		for ($i=0;$i<$Cl;$i++) {$ordered.="l";}
		for ($i=0;$i<$Cm;$i++) {$ordered.="m";}
		for ($i=0;$i<$Cn;$i++) {$ordered.="n";}
		for ($i=0;$i<$Co;$i++) {$ordered.="o";}
		for ($i=0;$i<$Cp;$i++) {$ordered.="p";}
		for ($i=0;$i<$Cq;$i++) {$ordered.="q";}
		for ($i=0;$i<$Cr;$i++) {$ordered.="r";}
		for ($i=0;$i<$Cs;$i++) {$ordered.="s";}
		for ($i=0;$i<$Ct;$i++) {$ordered.="t";}
		for ($i=0;$i<$Cu;$i++) {$ordered.="u";}
		for ($i=0;$i<$Cv;$i++) {$ordered.="v";}
		for ($i=0;$i<$Cw;$i++) {$ordered.="w";}
		for ($i=0;$i<$Cx;$i++) {$ordered.="x";}
		for ($i=0;$i<$Cy;$i++) {$ordered.="y";}
		for ($i=0;$i<$Cz;$i++) {$ordered.="z";}
		for ($i=0;$i<$space;$i++) {$ordered.="_";}



$phrase="";$prep="";$noun="";$verb="";$proper="";$adj="";$adv="";$conj="";$invalid="";$letter="";$int="";$symbol="";$abbr="";$init="";$fix="";

	
	$letters=0; $numbers=0; 
	$letters=($currentword=~tr/[A-Z]//);
	$numbers=($currentword=~tr/[0-9]//);
	if ($size==0) {$flagged++;}
	if ($letters==0) {$flagged++;}
	if ($numbers>0) {$flagged++;}
	if ($hash>0) {$flagged++;}
	if (($currentid =~ /abbr/)||($currentid =~ /cont/)) {$abbr=1;$invalid=1;}
	if ($currentid =~ /init/) {$init=1;$invalid=1;}
	if ($currentid =~ /symbol/) {$symbol=1;$invalid=1;}
	if ($currentid =~ /int/) {$int=1;}
	if ($currentid =~ /letter/) {$letter=1;}
	if (($currentid =~ /idiom/)||($currentid =~ /proverb/) || ($currentid =~ /phrase/)) {$phrase=1;$invalid=1;}
	if ($currentid =~ /n/) {$noun=1;}
	if ($currentid =~ /v/) {$verb=1;}
	if ($currentid =~ /proper/) {$proper=1;}
	if ($currentid =~ /adj/) {$adj=1;}
	if ($currentid =~ /adv/) {$adv=1;}
	if ($currentid =~ /conj/) {$conj=1;}
	if ($currentid =~ /prep/) {$prep=1;}
	if ($currentid =~ /fix/) {$fix=1;$invalid=1;}



	if ($flagged==0){
	print FILE "$name\t$link\t$currentid\t$ordered\t$size\t$letters\t$Cvowel\t$pair\t$triplet\t$quadruplet\t$nonascii\t$utf\t$extravowel\t$nonvowel\t$Nqu\t$hash\t";
	print FILE "$Ca\t$Cb\t$Cc\t$Cd\t$Ce\t$Cf\t$Cg\t$Ch\t$Ci\t$Cj\t$Ck\t$Cl\t$Cm\t$Cn\t$Co\t$Cp\t$Cq\t$Cr\t$Cs\t$Ct\t$Cu\t$Cv\t$Cw\t$Cx\t$Cy\t$Cz\t";
	print FILE "$Da\t$Db\t$Dc\t$Dd\t$De\t$Df\t$Dg\t$Dh\t$Di\t$Dj\t$Dk\t$Dl\t$Dm\t$Dn\t$Do\t$Dp\t$Dq\t$Dr\t$Ds\t$Dt\t$Du\t$Dv\t$Dw\t$Dx\t$Dy\t$Dz\t";
	print FILE "$Ta\t$Tb\t$Tc\t$Td\t$Te\t$Tf\t$Tg\t$Th\t$Ti\t$Tj\t$Tk\t$Tl\t$Tm\t$Tn\t$To\t$Tp\t$Tq\t$Tr\t$Ts\t$Tt\t$Tu\t$Tv\t$Tw\t$Tx\t$Ty\t$Tz\t";
	print FILE "$phrase\t$noun\t$verb\t$proper\t$adj\t$adv\t$conj\t$invalid\t$letter\t$int\t$symbol\t$abbr\t$init\t$fix\t$prep\n";
	}

}} # word loop

} # @wiktindex pageloop
end;
