#!/usr/bin/perl
require LWP::UserAgent;
sub got {
	my $home=$_[0];	
	my $ua = LWP::UserAgent->new;
	$ua->timeout(60);
	$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
	$ua->env_proxy;
	
	my $response = $ua->get($home);
	
	if ($response->is_success) {
		return $response->decoded_content;  # or whatever
	}
	else {
		print $response->status_line;
	}
}

my $timer=time();
$file='prok2.txt';
open(PROKS,$file) or die "Can't make file: $!";
$file='>prok_out.txt';
open(OUT,$file) or die "Can't make file: $!";
@line=<PROKS>;
chomp(@line);

for $x (0..$#line) {
	$res=got($line[$x]);
	$res=~ m/\<pre\>(.*?)\, complete genome/msgi;
	$who=$1;
	if ($who eq "") {$who="nothing";}
	$file='>genomes/'.$who.'.txt';
	open(TEST,$file) or print "Can't make file: $!";
	print TEST $res;
	close TEST;
	$test=$res;
	$testo=$res;
	if ($test=~ m/COG0787/msi) {$alr=1;}
	if ($testo=~ m/COG0626/msi) {$met=1;}
	#if ($res=~ m/alanine racemase(.*)/i) {$temp=$1; if ($test !~ m/COG0787/msi) {print "The Issue has appeared and it is in $who";}}
	if (($met==1) && ($alr==1)) {$note="Happy chappy";}
	elsif (($met==0) && ($alr==1)) {print "$who does not have MetC homologue but has a Alr homologue\n"; $note="MetC missing";}
	elsif (($met==1) && ($alr==0)) {print "$who has MetC homologue but does not have a Alr homologue\n"; $note="Alr missing";}
	elsif (($met==0) && ($alr==0)) {
		if (length($res)<100) { print "Possible error in reading $who\n"; $note="Reading Error"; }
		else {
			if ($res!~ m/COG\d+/msgi) {print "$who is COG-less\n"; $note="COG-less";} else {
				print "$who does not have both a MetC homologue nor a Alr homologue\n"; $note="both missing";
			}
		}
		
		
		
	}


	print OUT (($x+1)."\t$who\t$note\t$line[$x]\n");
	$note="!!";
$met=0; $alr=0;

}
