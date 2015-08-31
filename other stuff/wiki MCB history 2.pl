#http://en.wikipedia.org/w/index.php?title=Special:Contributions&limit=500&target=$username



use sub;
use strict;
use warnings;
use LWP::Simple;
use constant T=>"\t";
use constant N=>"\n";
my $data;
my $option=1;
if ($option==0) {dl_and_analyse();}
elsif ($option==1) {$data=read_and_analyse();}


my $pref=sub::fpivot('bot_dist',$data,1,8);

exit;

if ( $ARGV[0]==0) {annual_article_edits();}
elsif ($ARGV[0]==1) {monthly_article_edits();}
elsif ($ARGV[0]==2) {monthly_article_edits_bot();}

#Translational%20efficiency\tBjchua\t62\t62\t17:57 26/10/2006



#http://en.wikipedia.org/w/index.php?title=Main_Page&limit=500&action=history

exit;
######################################################################################################
######################################################################################################



sub read_and_analyse {
	my @files=<wiki/*>;
	my @data;
	foreach my $file (@files) {
		my @lines=sub::readfile($file); $file="";
		my @edits=();
		foreach (@lines) {if (/^\<li\>/) {push(@edits,$_);}}
		foreach (reverse @edits) {push(@data,analyse_this($_));}
	}
	open(FILE,'>megaout.txt');
	print 'page name'.T.'user'.T.'bytes'.T.'date'.T.'revertion'.T.'comment'.T.'typo/mistake/error/wrong'.T.'bot'.T.'Rev'.N;
	my $omerta=0;
	my @gods=<DATA>;
	chomp(@gods);
	
	foreach (@data) {
		if ($omerta==1) {$_->[9]='Revered'; $omerta=0} elsif ($_->[4]) {$omerta=1;$_->[9]='Reversion';}
		#if (grep(/^\Q$_->[1]\E$/, @gods)) {'god';}
		print FILE join(T,@$_).N;
	}
	return \@data;
}

sub dl_and_analyse {
	for my $i (1..21) {
		open(LOG,'>',"out_$i.txt");
		my $url='http://toolserver.org/~enwp10/bin/list2.fcgi??importance=&namespace=&score=&sorta=Importance&run=yes&pagename=&sortb=Quality&projecta=MCB&limit=1000&quality=&&offset='.($i*1000+1);
		#$url='http://toolserver.org/~enwp10/bin/list2.fcgi?run=yes&projecta=MCB';
		my $list_html=sub::got($url);
		my @botch_url_list=($list_html=~ m/http\:\/\/en\.wikipedia\.org\/w\/index\.php\?title\=(\S+)\&action\=history/sg);
		print "I have found ".($#botch_url_list+1)."pages to analyse\n";
		foreach my $wikiurl (@botch_url_list) {
			my $history_url='http://en.wikipedia.org/w/index.php?title='.$wikiurl.'&limit=5000&action=history';
			my $history=sub::got($history_url);
			
			open(DUMP,'>',"wiki/$wikiurl.txt"); print DUMP $history; close DUMP;
			$history=~s/[\t\n\r]//msg;
			if ($history=~m/\<ul id\=\"pagehistory\"\>(.*?)\<\/ul\>/s) {
				my $history=$1;
				my @edits=($history=~m/\<li\>(.*?)\<\/li\>/g);
				
				print "$wikiurl has ".($#edits+1)." edits\n";
				
				foreach (reverse @edits) {my $ref=analyse_this($_); print LOG join(T,@$ref).N;}
				
			}
		}
	}
	
}



sub analyse_this {
	my $error=0;
	my @array=();
	my $_=shift;
	if (/title\=\"(.*?)\"\>cur\<\/a\>/) {$array[0]=$1;}
	elsif (/title\=\"(.*?)\"\>prev\<\/a\>/) {$array[0]=$1;}
	else {print "No title in $_".N;}
	if (/(.*)talk\<\/a\>/) {my $user=user($1); if ($user eq '!') {$error++; return ();} $array[1]=$user;} else {print "No user in $_".N;}
	if (/\((\d+)\,?(\d+) bytes\)/) {$array[2]=$1.$2;} else {print "No bytes in $_".N;}
	if (/(\d{1,2}\:\d{1,2})\, (\d{1,2}) (\w+) (\d{4})/) {$array[3]=$1.' '.$2.'/'.month($3).'/'.$4;} else {print "No time in $_".N;}
	if (/Reverted edits by \<(.*?)\>/) {$array[3]=user($1);}
	if (/This is a minor edit/) {$array[4]=1;}
	if (/\<span class\=\"comment\"\>(.*?)\<\/span\>/) {$array[5]=$1;}
	if (/typo/i) {$array[6]=1;} elsif (/mistake/i) {$array[6]=2;} elsif (/error/i) {$array[6]=3;} elsif (/wrong/i) {$array[6]=4;} 
	if ((/\Wbot\W/i)||(/robot/i)||($array[1]=~m/bot\_?$/i)) {$array[8]=1;}
	return \@array;
}

sub month {
	my $month=$_[0];
	my @calendar=qw(Error January February March April May June July August September October November December);
	if ($month=~/\w+/) {
		for my $n (0..12) {if ($month=~/$calendar[$n]/) {return $n;}}
	}
	elsif($month=~/\d/) {
		$month+=0;
		return $calendar[$month];
	}
	else {return 'Error';}
	
}

sub user {
	my $string=$_[0];
	if ($string=~m/\/wiki\/User\:(.*?)\"/) {return $1;
	} elsif ($string=~m/\/w\/index\.php\?title\=User\:(.*?)\&amp\;action\=edit\&amp\;redlink\=1/) {return $1;
	} elsif ($string=~m/\/Special\:Contributions\/(\d+\.\d+\.\d+\.\d+)/) {return $1;
	} else { return '!';
	}
	
}


__DATA__
Boghog2
Arcadian
TimVickers
Yeast2Hybrid
WillowW
Jfdwolff
Mikael_H%C3%A4ggstr%C3%B6m
Edgar181
Ebizur
Pdeitiker
Andrew_Lancaster
Biophys
El3ctr0nika
Ciar
Narayanese
AndrewGNF
CopperKettle
Rich_Farmbrough
Moxy
JWSchmidt
GrahamColm
168...
Meodipt
Lexor
Hempelmann
Rjwilmsi
ClockworkSoul
Banus
Opabinia_regalis
Vsmith
Drphilharmonic
Cosmic_Latte
DMacks
Bensaccount
J.delanoy
DO11.10
Ppgardne
Fvasconcellos
Casliber
Forluvoft