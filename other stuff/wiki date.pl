use strict;
use constant T=>"\t";
use constant N=>"\n";
use sub;
use strict;
use warnings;



if ( $ARGV[0]==0) {annual_article_edits();}
elsif ($ARGV[0]==1) {monthly_article_edits();}
elsif ($ARGV[0]==2) {monthly_article_edits_bot();}




#Translational%20efficiency\tBjchua\t62\t62\t17:57 26/10/2006







sub annual_article_edits {
	my %master=();
	my $blank='human';
	
	for my $n (0..20) {
		sub::clear;
		print N.N.$n.N.N;
		my @edit=sub::table(sub::readfile("out_$n.txt"));
		for my $a (0..$#edit) {
			
			if ($edit[$a][4]=~ m/2010/) {$master{$edit[$a][0]}[0]++;}
			if ($edit[$a][4]=~ m/2009/) {$master{$edit[$a][0]}[1]++;}
			if ($edit[$a][4]=~ m/2008/) {$master{$edit[$a][0]}[2]++;}
			if ($edit[$a][4]=~ m/2007/) {$master{$edit[$a][0]}[3]++;}
			if ($edit[$a][4]=~ m/2006/) {$master{$edit[$a][0]}[4]++;}
		}
	}
	
	open(FILE,'>','date.txt') or die 'crap';
	foreach my $n (keys %master) {
		print FILE $n.T.join(T,@{$master{$n}}).N;
	}
}

sub monthly_article_edits_bot {
	my %master=();
	my $blank='human';
	my @gods=<DATA>;
	chomp(@gods);
	
	for my $n (0..20) {
		sub::clear;
		print N.N.$n.N.N;
		my @edit=sub::table(sub::readfile("out_$n.txt"));
		for my $a (0..$#edit) {
			my $type='lost';
			if (($edit[$a][4]=~m/bot/)||($edit[$a][1]=~ m/bot$/)) {$type='bot';}
			elsif (grep(/^\Q$edit[$a][1]\E$/, @gods)) {$type=$edit[$a][1];}
			else {$type='human';}
			
			
			
			
			if ($edit[$a][4]=~ m/\/(\d+)\/20(\d\d)/) {$master{$type}[$2][$1]++;}
		}
	}
	
	open(FILE,'>','monthly bot.txt') or die 'crap';
	print FILE 'article'.T;
	for my $m (0..10) {print FILE join(T,map("$_ 200$m",0..13)).T;} print FILE N;
	foreach my $n (keys %master) {
		for my $m (0..10) {$master{$n}[$m][13]='-';}
		print FILE $n.T;
		for my $m (0..10) {print FILE join(T,@{$master{$n}[$m]}).T;} print FILE N;
	}
}

sub monthly_article_edits {
	my %master=();
	my $blank='human';
	
	for my $n (0..20) {
		sub::clear;
		print N.N.$n.N.N;
		my @edit=sub::table(sub::readfile("out_$n.txt"));
		for my $a (0..$#edit) {
			if ($edit[$a][4]=~ m/\/(\d+)\/20(\d\d)/) {$master{$edit[$a][0]}[$2][$1]++;}
		}
	}
	
	open(FILE,'>','monthly.txt') or die 'crap';
	print FILE 'article'.T;
	for my $m (0..10) {print FILE join(T,map("$_ 200$m",0..13)).T;} print FILE N;
	foreach my $n (keys %master) {
		for my $m (0..10) {$master{$n}[$m][13]='-';}
		print FILE $n.T;
		for my $m (0..10) {print FILE join(T,@{$master{$n}[$m]}).T;} print FILE N;
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