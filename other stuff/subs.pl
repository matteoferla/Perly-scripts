#! /usr/bin/perl

require LWP::UserAgent;
#use Math::MatrixReal;
use strict;
#=================================================================

#=================================================================

#=================================================================

#----Subroutines ------------

#=================================================================

sub gauss{

my ($x, $n, $p) = @_;
my $mu=$n*$p;
my $sigma=$n*$p*(1-$p);#actually its variance
my $f=0;
if ($p=>1) {$f=1; goto EXIT;}
if ($x>$n) {$x=$n; print "dodgy correction for over-sucess\n";}
if ($x<0) {$x=0; $f="0"; goto EXIT;}
if ($n<0) {$n=0;$f="0"; goto EXIT;}
if ($sigma==0) {goto EXIT;}
$f=(2*($sigma));
$f=(($x-$mu)**2)/$f;
$f=exp(-$f);
$f=$f/((2*3.14159265*$sigma)**(1/2));


EXIT: 
return ($f);

}

sub multigauss{


my @x = @{ $_[0] }; my $n = $_[1]; my @p = @{ $_[2] };
@x=zeroed(\@x);
@p=zeroed(\@p);

my $f=0;
my @mu=map {$n*$p[$_]} (0..19);
my $string="";
my $i=0;
my $j=0;
my $check=0;
my @s=();
my $covrix= new Math::MatrixReal(20,20);
for $i (0..19) {
	for $j (0..19) {
$s[$i][$j]=-$n*$p[$i]*$p[$j];
$covrix->assign($i+1,$j+1,$s[$i][$j]);
}
$check+=$x[$i];
}
#if ($check>$n) {print "over-sucess\n"; $f="!"; goto EXIT;}
#if ($check<0) { $f="!"; goto EXIT;}
#if ($n<0) {$f="!"; goto EXIT;}

print "\n\n\n\n";
$covrix->display_precision(0);
my $det = $covrix->det();
my $twin_matrix = $covrix->clone();
$covrix->transpose($twin_matrix);
print $covrix; 
EXIT: 
#return ($f);

}

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


sub probably{





my ($x, $n, $p) = @_;

$x=int($x);
if ($x>$n) {$x=$n; print "dodgy correction for over-sucess\n";}
if ($p=>1) {return 1;}
return unless $x >= 0 && $x == int $x && $n > 0 &&

$n == int $n && $p > 0 && $p <1;

return choose($n,$x) * ($p ** $x) * ((1-$p) ** ($n-$x));
if ($p=>1) {return 1;}


}



sub choose {

my ($n,$k) = @_;

my ($result,$j) = (1,1);



return 0 if $k>$n||$k<0;

$k = ($n - $k) if ($n - $k) <$k;



while ($j <= $k ) {

$result *= $n--;

$result /= $j++;

}

return $result;

}




sub multi{

my @x = @{ $_[0] }; my $n = $_[1]; my @p = @{ $_[2] };
int ($n);
foreach (@x) {int($_); 
if ($_>$n) {$_=$n; print "dodgy correction for over-sucess\n";}}
return unless  $n > 0;

$p[26]=1;
$x[26]=$n;
my $m=1;
my $d=1;
for (my $i=0; $i<=25; $i++) {int(abs($x[$i]));abs($p[$i]);$p[26] -=$p[$i];$x[26] -=$x[$i];if ($p[$i]=>1) {return 1;}}
for (my $i=0; $i<=26; $i++) {if ($p[$i]>0) {$m *=$p[$i]**$x[$i]; $d *=fack($x[$i]);}}
my $result=fack($n)* $m /$d;
return $result;

}


sub fack { my ($n) = @_; if ($n ==0) {$n=1;} if ($n < 2) { return $n;} else { return $n * fack($n-1);} }


sub stirmulti{
my @x = @{ $_[0] }; my $n = $_[1]; my @p = @{ $_[2] };
int ($n);
foreach (@x) {int($_);if ($_>$n) {$_=$n; print "dodgy correction for over-sucess\n";}}
return unless  $n > 0;

$p[26]=1;
$x[26]=$n;
my $m=1;
my $ld=0;
for (my $i=0; $i<=25; $i++) {abs($x[$i]);abs($p[$i]);$p[26] -=$p[$i];$x[26] -=$x[$i];}
for (my $i=0; $i<=26; $i++) {if ($p[$i]>0) {$m *=$p[$i]**$x[$i] ;} $ld +=stirling($x[$i]);}
if ($p[26]<0) {print "probability sum violation\n";$p[26]=0;}
if ($x[26]<0) {print "probability sum-length violation\n";$x[26]=0;}
my $ln=stirling($n);
my $lm=log ($m);
my $result=$ln + $lm - $ld;
if ($result>0) {print "probability combinatorial violation\n";$result=0;}
return exp($result);

}

sub logmulti{
my @x = @{ $_[0] }; my $n = $_[1]; my @p = @{ $_[2] };
int ($n);
my $q=0;
foreach $q (@x) {int($q);}
return unless  $n > 0;

$p[26]=1;
$x[26]=$n;
my $m=1;
my $ld=0;
my $abort=0;
for (my $i=0; $i<=25; $i++) {abs($x[$i]);abs($p[$i]);if($x[$i]<1){$x[$i]=0;}if($p[$i]>1){$p[$i]=0;print "p-issue\n";$abort=1;goto LOO;} $p[26] -=$p[$i];$x[26] -=$x[$i];}
if ($p[26]<0) {print "probability sum violation\n@p\n";$abort=1; goto LOO;}
if ($x[26]<0) {print "\!";$n+=abs($x[26]);$x[26]=0;}
for (my $i=0; $i<=26; $i++) {if ($p[$i]>0) {$m *=$p[$i]**$x[$i];$ld +=logfack($x[$i]);}}
my $ln=logfack($n);
my $lm=0;
if ($m>0) {$lm=log ($m);} else {print "impossibility encountered\n"; $abort=1;goto LOO;}
my $result=$ln + $lm - $ld;
if (($ln - $ld) <0) {print "Broken combinatorial\n";}
if ($result>0) {print "probability combinatorial violation\n$result\n";print  join("\:", @x) ."\n\n". join("\:", @p) . "\n\nlog multi\: $ln \- $ld\nlog prod $lm";<>;$abort=1;goto LOO;}
LOO:
if ($abort==0) {return exp($result);} else {return 1;print "here\n";}

}

sub logfack { my ($n) = @_; if ($n < 2) { return 0;} else { return log ($n) + logfack($n-1);} }



sub stirling { my ($n) = @_; my $x=0;if ($n <2) {$x=0;} else {$x=($n*log ($n))-$n+(0.5*log(6.28318530717958*$n));} return $x; }


#=================================================================

#=================================================================

#=================================================================



sub counter {

my $paper = $_[0];
my @counts=();
for (my $paperround=65;$paperround<=90;$paperround++) { if (ord($paper) == $paperround) {$counts[$paperround-65]=1;} else {$counts[$paperround-65]=0;}}

return @counts;

}





#=================================================================

#=================================================================

#=================================================================








sub whatamess {

my @mess = @{ $_[0] };

my $clean="\t\-\t$mess[17]\t$mess[7]\t$mess[10]\t$mess[3]\t$mess[4]\t$mess[18]\t$mess[19]\t$mess[13]\t$mess[16]\t$mess[2]\t$mess[20]\t$mess[6]\t$mess[15]\t$mess[8]\t$mess[21]\t$mess[24]\t$mess[22]\t$mess[5]\t$mess[12]\t$mess[11]\t$mess[0]\t$mess[1]\t$mess[25]\t$mess[9]\t$mess[23]\t$mess[14]";

#nice order is Arginine	Histidine	Lysine	Aspartic acid	Glutamic acid	Serine	Threonine	Asparagine	Glutamine	Cysteine	selenocysteine	Glycine	Proline	Isoleucine	Valine	Tyrosine	Tryptophan	Phenylalanine	Methionine	Leucine	Alanine	Asparagine or aspartic acid	Glutamine or glutamic acid	Leucine or Isoleucine	Unspecified or unknown amino acid	unallocated

#which corresponds to 	17	7		10	3	4	18		19	13		16	2	20	6		15	8	21		24	22	5	12		11	0	1		25		9	23	14

return $clean;



}



sub alphabet {

my @alpha = @{ $_[0] };
my $blankphobe=0;
foreach $blankphobe (@alpha) {if (($blankphobe eq "") || ($blankphobe eq "0")) {$blankphobe="";}}

my $beta="\t\-\t$alpha[0]\t$alpha[1]\t$alpha[2]\t$alpha[3]\t$alpha[4]\t$alpha[5]\t$alpha[6]\t$alpha[7]\t$alpha[8]\t$alpha[9]\t$alpha[10]\t$alpha[11]\t$alpha[12]\t$alpha[13]\t$alpha[14]\t$alpha[15]\t$alpha[16]\t$alpha[17]\t$alpha[18]\t$alpha[19]\t$alpha[20]\t$alpha[21]\t$alpha[22]\t$alpha[23]\t$alpha[24]\t$alpha[25]\t";

return $beta;



}



sub namebadge {



my ($nickname, $cognomen) = @_;

my @monicker=();

if ($nickname==0) {

$monicker[0]="$cognomen Alanine";

$monicker[1]="$cognomen Asparagine or aspartic acid";

$monicker[2]="$cognomen Cysteine";

$monicker[3]="$cognomen Aspartic acid";

$monicker[4]="$cognomen Glutamic acid";

$monicker[5]="$cognomen Phenylalanine";

$monicker[6]="$cognomen Glycine";

$monicker[7]="$cognomen Histidine";

$monicker[8]="$cognomen Isoleucine";

$monicker[9]="$cognomen Leucine or Isoleucine";

$monicker[10]="$cognomen Lysine";

$monicker[11]="$cognomen Leucine";

$monicker[12]="$cognomen Methionine";

$monicker[13]="$cognomen Asparagine";

$monicker[14]="$cognomen Pyrrolysine";

$monicker[15]="$cognomen Proline";

$monicker[16]="$cognomen Glutamine";

$monicker[17]="$cognomen Arginine";

$monicker[18]="$cognomen Serine";

$monicker[19]="$cognomen Threonine";

$monicker[20]="$cognomen Selenocysteine";

$monicker[21]="$cognomen Valine";

$monicker[22]="$cognomen Tryptophan";

$monicker[23]="$cognomen Unspecified or unknown amino acid";

$monicker[24]="$cognomen Tyrosine";

$monicker[25]="$cognomen Glutamine or glutamic acid";

} elsif ($nickname==1) {

$monicker[0]="$cognomen Ala";

$monicker[1]="$cognomen Asx";

$monicker[2]="$cognomen Cys";

$monicker[3]="$cognomen Asp";

$monicker[4]="$cognomen Glu";

$monicker[5]="$cognomen Phe";

$monicker[6]="$cognomen Gly";

$monicker[7]="$cognomen His";

$monicker[8]="$cognomen Ile";

$monicker[9]="$cognomen Xle";

$monicker[10]="$cognomen Lys";

$monicker[11]="$cognomen Leu";

$monicker[12]="$cognomen Met";

$monicker[13]="$cognomen Asn";

$monicker[14]="$cognomen Pyl";

$monicker[15]="$cognomen Pro";

$monicker[16]="$cognomen Gln";

$monicker[17]="$cognomen Arg";

$monicker[18]="$cognomen Ser";

$monicker[19]="$cognomen Thr";

$monicker[20]="$cognomen Sec";

$monicker[21]="$cognomen Val";

$monicker[22]="$cognomen Trp";

$monicker[23]="$cognomen Xaa";

$monicker[24]="$cognomen Tyr";

$monicker[25]="$cognomen Glx";

} else {

$monicker[0]="$cognomen A";

$monicker[1]="$cognomen B";

$monicker[2]="$cognomen C";

$monicker[3]="$cognomen D";

$monicker[4]="$cognomen E";

$monicker[5]="$cognomen F";

$monicker[6]="$cognomen G";

$monicker[7]="$cognomen H";

$monicker[8]="$cognomen I";

$monicker[9]="$cognomen J";

$monicker[10]="$cognomen K";

$monicker[11]="$cognomen L";

$monicker[12]="$cognomen M";

$monicker[13]="$cognomen N";

$monicker[14]="$cognomen O";

$monicker[15]="$cognomen P";

$monicker[16]="$cognomen Q";

$monicker[17]="$cognomen R";

$monicker[18]="$cognomen S";

$monicker[19]="$cognomen T";

$monicker[20]="$cognomen U";

$monicker[21]="$cognomen V";

$monicker[22]="$cognomen W";

$monicker[23]="$cognomen X";

$monicker[24]="$cognomen Y";

$monicker[25]="$cognomen Z";

}

return (@monicker);

}



#=================================================================

#=================================================================

#=================================================================


sub got {


my $street = $_[0];
	
	#use LWP::simple;
	#my $home=get($street);
	
	use LWP::UserAgent;

my $ua = LWP::UserAgent->new; $ua->timeout(10); $ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/'); $ua->env_proxy;

my $response = $ua->get($street); if ($response->is_success) {     my $home = $response->decoded_content; return $home;} else {   print $response->status_line; }


}




sub dayo {

my @banana = @{ $_[0] };

my $plus=$banana[8]+$banana[11]+$banana[18];

my $minus=$banana[3]+$banana[4];

#unfinisehed tally

return ();

}



sub helper {

my $santa = $_[0];

if ($santa==0) {print "Aa pair hunter searches NCBI protein database for a given organism or user inputted query and counts the appearance of amino-acid identical pair, triplets, quadruplets or a his tag. Alternatively the sequence can be pasted into the running program or a test sequence is analysed.\nAll NCBI sequences have a database accession number (gi) and additional external keys, such as the key linking it to a specific organism called a taxon ID number.\nIn this question the script asks what sequences to look at, to do so it has a list of some organisms to choose from (options 0-10). Alternatively the user can choose the option which allows the insertion of a taxon ID (option 11) or any query, such as a name of a protein (option 12). Option 13 is not recommended as there are 30 million sequences. Option 14 allows the input of a sequence an option 15 uses a preset sequence in the script. If 14 or 15 is chosen, questions 2, 3, 4, 5 are skipped.\nFor options 11, 12 and 14, first the option is entered, after which a new prompt will ask for the required input.\nIn linux and Windows, to paste in the terminal the right click must be used or shift and ctr V, in Mac command V.\nThe quit option is for users who have a snazzy keyboard with volume control etc but no retro break key, it accepts variants such as quit, Quit, Q\!, Exit, exit etc).\nThe file with name established in input 6 is created with a series of values separated by tab allowing it to be pasted into excel the columns are\:\n\tgi number\n\tsequence name\n\tsize\n\tnumber of pairs\n\texpected pairs (size divided by 20)\n\tnumber of triplets\n\texpected triplets (size divided by 400) \n\tnumber of quadruplets\n\texpected quadruplets (size divided by 8000)\n\tsequence\n\ttrimmed sequence for repeats is a value in the format\: \:36\:LL\:16\:AA\:21\:AAA\:21\:AA\:3\:II\:27\: where the numbers represent the residues between the repeats \n\tcount of positively, negatively and hydrophobically charged pairs \n\tcount of the pairs according to individual aminoacid (all letters used, including sec, Asx, glx, xle, xaa and carboxybenzyl (symbol Z, used in peptide synthesis) and \_ just in case (thor appears as viking in the output) a sign the input is encoded incorrectly as the icelandic letter is not a valid code \n\tcount of individual amino acids, pair are counted as one. \n\tHistag, for artificial protein \n\tScore, the ratio of the difference in observed and expected values over the expected values, consequently a protein that meets the expectations will score 0.\n Press to Continue.";<>;} elsif ($santa==1) {print "There are twenty amino acids plus redundant codes for MS ambiguous residues. These can be written as a single letter code, which, with the exception of \"O\" which is refereed to on the output as unallocated, comprise all 26 letter of the Latin alphabet used in English. The alphabet is by convention written in a set order \(A, B, C, D etc.\), which means little in amino acid terms. Amino acids, instead, may be apolar, or be polar with or without a charge. On the output file the amino acid list of frequencies will be in one of the two styles. This question allows the user to change the default, which is the latter, to the former.\n Press to Continue.";<>;} elsif ($santa==2) {print "Amino acids can be written as words \"glycine\" or a code \"gly\" or \"G\". By choosing one of these the header of the output table changes.\n Press to Continue.";<>;} elsif ($santa==3) {print "The next question is if the refseq filter should be activated. This is a curated set of sequences without repeats. Type N or n \(or no, no\!, Noo etc\) to activate the filter. Anykey or simply enter to continue.\n Press to Continue.";<>;} elsif ($santa==4) {print "The next question asks what it should save, by default it saves everything, which may be problematic for a long search consequently if no is typed it will ask what score threshold to use (0\= all overrepresenting, 1\=overrepresenting by two\-fold etc). Anykey or simply enter to continue.\n Press to Continue.";<>;} elsif ($santa==5) {print "The next question asks if it should display on the screen the downloads, by default it is off, but it is useful to see what is going on (i.e. is it running\?). Anykey or simply enter to continue.\n Press to Continue.";<>;} elsif ($santa==6) {print "The next question asks how many of the sequences it should do. Pressing enter continues (and does the whole lot) while a number results it it doing that amount.\n Press to Continue.";<>;} elsif ($santa==7) {print "Asks if the name of the file is ok, enter to confirm, anything else to rename it (.txt is added by the script)\n Press to Continue.";<>;} elsif ($santa==8) {print "How did you get here\?\n Press to Continue.";<>;}

return ();

}

sub dnachance {
my $p=0;
my $residue = $_[0]; if (($residue eq "M") || ($residue eq "W")) {my $p=1;} elsif ($residue eq "I") {my $p=0.33;} if (($residue eq "A") || ($residue eq "G") || ($residue eq "P") || ($residue eq "T") || ($residue eq "V")) {my $p=0.25;} if (($residue eq "R") || ($residue eq "L") || ($residue eq "S")) {my $p=0.15;} else {my $p=0.5;} return $p;
}


sub empiricalfrq {
my @p=();
$p[0]=0.0950868059265132;
$p[1]=0;
$p[2]=0.0115721587388366;
$p[3]=0.0514683290807774;
$p[4]=0.0576309125324284;
$p[5]=0.0388793882803342;
$p[6]=0.0737719593611367;
$p[7]=0.0227317102642676;
$p[8]=0.0599724584685052;
$p[9]=0;
$p[10]=0.0440355048507136;
$p[11]=0.106643491894847;
$p[12]=0.0282348589730649;
$p[13]=0.0394761951425816;
$p[14]=0;
$p[15]=0.0442742275956125;
$p[16]=0.0444650584318126;
$p[17]=0.0553026289710681;
$p[18]=0.0580457301416201;
$p[19]=0.053999969054459;
$p[20]=0;
$p[21]=0.0706582484971151;
$p[22]=0.0153224635892554;
$p[23]=0;
$p[24]=0.028427900205051;
$p[25]=0;
return (@p);
}