#http://en.wikipedia.org/w/index.php?title=Special:Contributions&limit=500&target=$username


use strict;
use constant T=>"\t";
use constant N=>"\n";

sub got {
use LWP::UserAgent;
my $url = $_[0];

my $ua = LWP::UserAgent->new();
my $res = $ua->get($url);

return $res->content;
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

#http://en.wikipedia.org/w/index.php?title=Main_Page&limit=500&action=history
open(LOG,'>out.txt');

#use sub;
use strict;
use warnings;
use LWP::Simple;
my $url='http://toolserver.org/~enwp10/bin/list2.fcgi?run=yes&projecta=MCB&namespace=&pagename=&quality=&importance=&score=&limit=20020&offset=1&sorta=Importance&sortb=Quality';
#$url='http://toolserver.org/~enwp10/bin/list2.fcgi?run=yes&projecta=MCB';
my $list_html=got($url);
my @botch_url_list=($list_html=~ m/http\:\/\/en\.wikipedia\.org\/w\/index\.php\?title\=(\S+)\&action\=history/sg);
print "I have found ".($#botch_url_list+1)."pages to analyse\n";
foreach my $wikiurl (@botch_url_list) {
	my $history_url='http://en.wikipedia.org/w/index.php?title='.$wikiurl.'&limit=5000&action=history';
	my $history=got($history_url);
	
	open(DUMP,'>',"wiki/$wikiurl.txt"); print DUMP $history; close DUMP;
	$history=~s/[\t\n\r]//msg;
	if ($history=~m/\<ul id\=\"pagehistory\"\>(.*?)\<\/ul\>/s) {
	my $history=$1;
		my @edits=($history=~m/\<li\>(.*?)\<\/li\>/g);

		print "$wikiurl has ".($#edits+1)." edits\n";
			
		my $was=0;
		my $error=0;
		foreach my $edit (reverse @edits) {
		if ($edit=~m/(.*)talk\<\/a\>/) {my $user=user($1); if ($user eq '!') {$error++; goto WELL;} print LOG $wikiurl.T.$user.T;} else {$error++; goto WELL;}
			if ($edit=~m/\((\d+\,?\d+) bytes\)/) {print LOG $1.T;} else {print LOG T;}
			if ($edit=~m/\((\d+) bytes\)/) {print LOG ($1-$was).T;$was=$1;} elsif ($edit=~m/\((\d+\,\d+) bytes\)/) {my $temp=$1; $temp=~ s/\,//; print LOG ($temp-$was).T;$was=$temp;} else {print LOG ''.T;;}
			if ($edit=~m/(\d{1,2}\:\d{1,2})\, (\d{1,2}) (\w+) (\d{4})/) {print LOG $1.' '.$2.'/'.month($3).'/'.$4.T} else {print LOG T}
			if ($edit=~m/Reverted edits by \<(.*?)\>/) {my $reverted=$1; print LOG 'R ('.user($reverted).')'.T;} else {print LOG T;}
			if ($edit=~m/This is a minor edit/) {print LOG "M".T;} else {print LOG T;}
			if ($edit=~m/typo/i) {print LOG "typo".T;} else {print LOG T;}
			if (($edit=~m/\Wbot\W/i)||($edit=~m/robot/i)) {print LOG "bot".N;} else {print LOG N;}
			WELL:
		}

	}
	}