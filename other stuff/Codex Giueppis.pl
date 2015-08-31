#!/usr/bin/perl

use LWP::UserAgent;



open(FILE,">whatchamacallit.txt") 	or die "Can't open file: $! (Please close any files with such name)";

open(MATRIX,">whatchamacallit_matrix.txt") 	or die "Can't open file: $! (Please close any files with such name)";



open(SERA,"sera-1.txt") or die "Can't open file: $! (Program needs a list called sera.txt)";







@gilist=<SERA>;
close SERA;



print FILE "index\tname\tsequence\t\t";

for $i (65..92) {print FILE ("subt\_" .  chr($i) . "\t");}

print "\t";

for $i (65..92) {print FILE ("freq\_" .  chr($i) . "\t");}

print "\n";
print @gilist+1;
pop @gilist; 
foreach $item (@gilist) {
$item=int($item);			
if ($item>0) {


$query  ="$item \[GI\]";





	$utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";

	$db     ="protein"; 

	$report ="fasta";

	$esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";

	$esearch_result = got($esearch);

	print "\nSearching for $query in $db database\n";

	$esearch_result =~ m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;


	$Count    = $1;

	$QueryKey = $2;

	$WebEnv   = $3;


	@onecounter= ();



	$efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=0&retmax=1&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";

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

chomp ($seq);
print FILE "$gi\t$name\t$seq\t\t";

@aa = split(//, $seq);
$size=@aa;
for ($mill = 0; $mill <= $size-1; $mill++)

{

	@thisround=();

	@thisround=counter($aa[$mill]);				

	@onecounter= map { $onecounter[$_] + $thisround[$_] } ( 0..25 );

	@globalcounter= map { $globalcounter[$_] + $thisround[$_] } ( 0..25 );



	for ($paperround=65;$paperround<=90;$paperround++) { if (ord($aa[$mill]) == $paperround) {for ($mailrun=65;$mailrun<=90;$mailrun++) { if (ord($aa[$mill+1]) == $mailrun) {$pinomatrix[$mailrun-65][$mailrun-65]++;}}}}

    



}




$total=$onecounter[0]+$onecounter[1]+$onecounter[2]+$onecounter[3]+$onecounter[4]+$onecounter[5]+$onecounter[6]+$onecounter[7]+$onecounter[8]+$onecounter[9]+$onecounter[10]+$onecounter[11]+$onecounter[12]+$onecounter[13]+$onecounter[14]+$onecounter[15]+$onecounter[16]+$onecounter[17]+$onecounter[18]+$onecounter[19]+$onecounter[20]+$onecounter[21]+$onecounter[22]+$onecounter[23]+$onecounter[24]+$onecounter[25];


	$totalite="";

	$frequalite="";

	for $i (0..25) {

		$totalite .="$onecounter[$i]\t";

		if ($total>0) {$calculator=$onecounter[$i]/$total;} else {$calculator="?";}

		$frequalite.="$calculator\t";
		}



print FILE "$totalite\t$frequalite\n";


}}





print "all done\n\a";

end;





sub counter {

    my $paper = $_[0];

    for ($paperround=65;$paperround<=90;$paperround++) { if (ord($paper) == $paperround) {$counts[$paperround-65]=1;} else {$counts[$paperround-65]=0;}}

    return @counts;

}




sub got {


my $street = $_[0];


 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
 $ua->env_proxy;
 
 my $response = $ua->get($street);
 if ($response->is_success) {     $home = $response->decoded_content;} else {   print $response->status_line; }


return $home;


}