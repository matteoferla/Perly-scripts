#!/usr/bin/perl
use strict;
use warnings;
use constant N=>"\n";
use constant T=>"\t";

####################################################################
###### Subs ########################################################
####################################################################

sub in {
	open FILE,$_[0] or die 'could not open '.$_[0].N;
	my @array=<FILE>;
	@array=split(/\r/,$array[0]) if ! $#array;
	close FILE;
	chomp(@array);
	return @array;
}

sub out {
	open(FILE,'>',$_[0]) or die 'could not open '.$_[0].N;
	print FILE $_[1];
	close FILE;
}


sub write_clp {  
	my $content=$_[0];
	my $os=$^O;
	if ($_[1]) {$content=$_[1];} #static method
	if ($os eq "MSWin32") {
		eval 'use Win32::Clipboard;
		my $CLIP = Win32::Clipboard();
		$CLIP->Set($content);';
		return ();
	}
	elsif ($os eq "darwin") {
		open (TO_CLIPBOARD, "|pbcopy");
		print TO_CLIPBOARD $content;
		close (TO_CLIPBOARD);
	}
	else {
		die "CRASH! I cannot paste the data to your clipboard. And what kind of a man uses a $os, anyway?!\n";
	}
}

sub number_tree_splitter {
	return "0\tnone" if (! $_[0]);  #really possible with only 5?
	$_[0] =~ s/^\D+//;
	my @array=split(/\s+/,$_[0]);
	return $array[0].T.$array[1]; #it ain't chomped?
}

####################################################################
###### Main ########################################################
####################################################################

system("clear");
print "Kia ora\n";

my @first_taxonomy=qw(Magnetococcales Pelagibacterales Mitochondria Anaplasmataceae Midichloria Rickettsiaceae Holosporales Sphingomonadales Maricaulis_group sub_Caulobacterales Parvularculales Acetobacteraceae Rhodospirillaceae sub_Rhizobiales Rhodobacterales Kordiimonadales Kiloniellales Sneathiellales Parvibaculum);
my @second_taxonomy=qw(Rickettsiales Rhodospirillales Rhizobiales Caulobacterales); # some of the above are already present. Theoretically the list could be combined.
my @third_taxonomy=qw(Rickettsidae Caulobacteridae);
my @ref_trees=in('topologies.txt');  #There are comment lines there: I am leaving them to make them markers.

####HEADER####

my $out="\t";
$out.="mono $_\t" foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
$out.="di $_\t" foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
$out.="poly $_\t" foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
$out.="zero $_\t" foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
$out.='X'.T;
$out.="(check) no issues at family\t(check) no issues at order\t";
$out.="Midichloria + Rickettsiaceae clade\tMidichloria + Anaplasmataceae clade\tAnaplasmataceae + Rickettsiaceae clade without Midichloria\tother (unknown midichlorian topology)".T.
'Holosporales: monophyletic and basal in the Caulobacter clade /Rhodospirillales\)\,Holosporales/'.T.
'Holosporales: monophyletic but sister to a Rhodospirillales subclade or clade, depending on monophyly of latter /\(Holosporales\,Rhodospirillales\)/'.T.
'Holosporales: monophyletic but sister to a Pelagibacterales subclade or clade, depending on monophyly of latter /\(Holosporales\,Pelagibacterales\)/'.T.
'Holosporales: monophyletic but sister to a clade of more than one order /Holosporales\,\(/ or /\)\,Holosporales\/'.T.
'Holosporales: monophyletic but sister to a clade of Rickettsiales, Pelagibacterales and Mitochondria (if present) /Holosporales\,\(\(Mitochondria\,Rickettsiales\)\,Pelagibacterales\)/ or /Holosporales\,\(Pelagibacterales\,Rickettsiales\)/ or /Holosporales\,\(\(Mitochondria\,Pelagibacterales\)\,Rickettsiales\)/'.T.
'Holosporales: monophylic in other topology'.T.
'Holosporales: Paraphyletic with 2 holosporacean subclades /Holosporales\)\,Holosporales/ or /Holosporales\,\(Holosporales/ and some more cases'.T.
'Holosporales: Polyphyletic with 2 holosporacean subclades'.T.
'Holosporales: topology with more than holosporacean subclades)'.T.
'Mitochondria: monophyletic but sister to a Rickettsiales subclade or clade, depending on monophyly of latter'.T.
'Mitochondria: monophyletic but sister to a Pelagibacterales subclade or clade, depending on monophyly of latter'.T.
'Mitochondria: monophyletic but sister to a Rhodospirillales subclade or clade, depending on monophyly of latter'.T.
'Mitochondria: monophyletic but sister to a clade of more than one order'.T.
'Mitochondria: other monophyletic topology'.T;
$out.="X\tcount of Most freq tree\t Most freq tree\t2nd most\t2nd most\t3rd most\t3rd most\t4th most\t4th most\t5th most\t5th most\tX\t";
$out.='Topologies missed'.T.join(T,@ref_trees);
$out.=N;


foreach my $file (<../../datasets/boots/*>) {
	#next if ($file !~/bacteria/);
	
	####PARSING BOOTS######
	#$file=~s/\.\.\/boots\///;
	
	
	#$out.=$file.T;
	#### MOD TO MATCH THE TREE SPREADSHEET MADE BY CAMERON.
	my $name=$file;
	$name=~s/\.\.\/\.\.\/datasets\/boots\///;
	$name=~s/BS\.//;
	$name=~s/\.tree//;
	$name=~s/\.gamma/_gamma/;
	$name=~s/\.cat/_cat/;
	$name=~s/BS\.//;
	$name=~s/_mt\-RY/_RY_mt/;
	$name=~s/\-RY/_RY/;
	$name=~s/Mg_//; #The sets marked as having magnetococcus, do not need to be marked.
	$name=~s/exorickettsiales_/exorickettsialess_/;  #this should be fixed in the files names really. Interesting typing error though.
	$out.=$name.T;
	
	
	print $file.N;
	my %zero =map{$_=>0}(@first_taxonomy,@second_taxonomy,@third_taxonomy);
	my %mono =map{$_=>0}(@first_taxonomy,@second_taxonomy,@third_taxonomy);
	my %di =map{$_=>0}(@first_taxonomy,@second_taxonomy,@third_taxonomy);
	my %poly =map{$_=>0}(@first_taxonomy,@second_taxonomy,@third_taxonomy);
	my @midi =(0,0,0,0);
	my @holo =map(0,0..8);
	my @mt =map(0,0..4);
	my ($fam,$ord)=(0,0);
	system('./nw_reroot '.$file.' Escherichia_coli_MG1655_ | ./nw_rename - small.map |./nw_condense - |./nw_order - > temp');
	system('./nw_reroot '.$file.' Escherichia_coli_MG1655_ | ./nw_rename - mid.map |./nw_condense - |./nw_order - > temp2');
	system('./nw_reroot '.$file.' Escherichia_coli_MG1655_ | ./nw_prune - Mariprofundus_ferrooxydans_PV1_ Ralstonia_solanacearum_GMI1000_ Thiobacillus_denitrificans_ATCC_25259_ Campylobacter_jejuni_ICDCCJ07001_ Acidithiobacillus_ferrooxidans_ATCC_23270_ Escherichia_coli_MG1655_ Xanthomonas_campestris_8004_ '.
	'| ./nw_rename - big.map |./nw_topology - |./nw_condense - |./nw_order -c n - |./nw_order -c a -| sort | uniq -c |sort -r >tempX');
	system('./nw_reroot '.$file.' Escherichia_coli_MG1655_ | ./nw_rename - huge.map |./nw_condense - |./nw_order - > temp3');
	system('cp tempX toptrees/top'.$name);

	####count topologies in first map####
		foreach my $ent (in('temp')) {
			my $fam_check=1;
			
		foreach my $taxon (@first_taxonomy) {
			my $n =($ent =~ s/$taxon/$taxon/g);
			if ($n==0) {$zero{$taxon}++}
			elsif ($n==1) {$mono{$taxon}++}
			elsif ($n==2) {$di{$taxon}++; $fam_check=0;}
			else {$poly{$taxon}++; $fam_check=0;}
		}
		###Do a little check up on Midichloria###
		if ($ent =~ /\(Midichloria\,Rickettsiaceae\)/) {$midi[0]++}
		elsif ($ent =~ /\(Anaplasmataceae\,Midichloria\)/) {$midi[1]++}
		elsif ($ent =~ /\(Anaplasmataceae\,Rickettsiaceae\)/) {$midi[2]++}
		else {$midi[3]++}
			
			$fam++ if $fam_check;
		}
	
	####count topologies in second map####
	
	foreach my $ent (in('temp2')) {
		my $ord_check=1;
		
		foreach my $taxon (@second_taxonomy) {
			my $n =($ent =~ s/$taxon/$taxon/g);
			if ($n==0) {$zero{$taxon}++}
			elsif ($n==1) {$mono{$taxon}++}
			elsif ($n==2) {$di{$taxon}++; $ord_check=0;}
			else {$poly{$taxon}++; $ord_check=0;}
		}
		


		
		
		###Do a little check up on Holosporaceae###
		if (($ent =~ s/Holos/Holos/g) == 1) {
			if ($ent =~ /Rhodospirillales\)\,Holosporales/) {$holo[0]++} #basal mono
			elsif ($ent =~ /\(Holosporales\,Rhodospirillales\)/) {$holo[1]++} #with rhodo
			elsif ($ent =~ /\(Holosporales\,Pelagibacterales\)/) {$holo[2]++} #with Pelagibacterales    ###
			elsif (($ent =~ /Holosporales\,\(/)||($ent =~ /\)\,Holosporales/)) {
				$holo[3]++;
				if (($ent =~ /Holosporales\,\(\(Mitochondria\,Rickettsiales\)\,Pelagibacterales\)/)||($ent =~ /Holosporales\,\(Pelagibacterales\,Rickettsiales\)/)||($ent =~ /Holosporales\,\(\(Mitochondria\,Pelagibacterales\)\,Rickettsiales\)/)) {$holo[4]++} ##mono, basal to Rickettsidae (assuming Mitochondria is a Rickettsidae if present)			
			} #mono, sister to clade of more than one order
			else {$holo[5]++} #not above but mono
		}
		elsif (($ent =~ s/Holos/Holos/g) == 2) {
			if (($ent =~ /Holosporales\)\,Holosporales/)||($ent =~ /Holosporales\,\(Holosporales/)||($ent =~ /Holosporales\,\w+\),Holosporales/)||($ent =~ /Holosporales\,\(\w+\,\w+\)\),Holosporales/)||($ent =~ /Holosporales\,\(\(\w+\,\w+\),\w+\)\),Holosporales/)) {$holo[6]++} # para x2  This assumption was flawed when ((H,(X,Z)),H) where X and Z are taxa alphabetically later than Holosporales. ((Mitochondria, Rickettsiales),Pelagibacterales) are such cases.)
			#elsif ($ent =~ /Rhodospirillales\)\,Holosporales\)\,Holosporales/) {$holo[8]++} #para basal
			#elsif ($ent =~ /\(Holosporales\,Rhodospirillales\)\,Holosporales/) {$holo[9]++} #with rhodo
			else {$holo[7]++} # x2 but not paraphyletic
		}
		
		else {$holo[8]++} # xn para
		
		#There is somethingw wrong with topology 4.
		#/Holosporales\,\(\(Mitochondria\,Rickettsiales\)\,Pelagibacterales\)/
		# Holosporales,((Mitochondria,Rickettsiales),Pelagibacterales)));
		#/Holosporales\,\(Pelagibacterales\,Rickettsiales\)/
		# Holosporales,(Pelagibacterales,Rickettsiales));
		# Holosporales,((Mitochondria,Pelagibacterales),Rickettsiales)));

		
		
		
		###Do a little check up on Mito###
		if (($ent =~ s/Mitochondria/Mitochondria/g) == 1) {
			if ($ent =~ /Mitochondria\,Rickettsiales/) {$mt[0]++} #mono with Rickettsiales
			elsif ($ent =~ /Mitochondria\,Pelagibacterales/) {$mt[1]++} #mono with Pelagibacterales
			elsif ($ent =~ /Mitochondria\,Rhodospirillales/) {$mt[2]++} #mono with Rhodospirillales
			elsif (($ent =~ /Mitochondria\,\(/)||($ent =~ /\)\,Mitochondria/)) {$mt[3]++} #mono, sister to clade of more than one order
			else {$mt[4]++} #not above but mono
		} 
		# alternative cases are too inane. Mitochondria is monophyletic. Full stop.
		
		
		
		$ord++ if $ord_check;
	}
	
	foreach my $ent (in('temp3')) {
		my $ord_check=1;
		
		foreach my $taxon (@third_taxonomy) {
			my $n =($ent =~ s/$taxon/$taxon/g);
			if ($n==0) {$zero{$taxon}++}
			elsif ($n==1) {$mono{$taxon}++}
			elsif ($n==2) {$di{$taxon}++;}
			else {$poly{$taxon}++;}
		}
	}
	
	
	####top trees######
	my @count=map(0,0..$#ref_trees);
	my @trees=in('tempX');
	foreach my $i (0..$#ref_trees) {
		my @temp=grep(/\Q$ref_trees[$i]\E/,@trees);
		if ($#temp==0) {if ($temp[0]=~/(\d+)/) {$count[$i]=$1} else {print "IMPOSSIBLE\n"}} else {}
	}
	
	
	
	#(Crown:0.02507325377462450364,Rhodospirillales:0.01261202125365339446)92:0.01850185626950196643,Holosporales:0.02286561098790190760)

	my $tally=0; $tally+=$_ foreach @count;
	print "$file... $tally\n";
	
	$out.=$mono{$_}.T foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
	$out.=$di{$_}.T foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
	$out.=$poly{$_}.T foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
	$out.=$zero{$_}.T foreach (@first_taxonomy,@second_taxonomy,@third_taxonomy);
	$out.='X'.T;
	$out.=$fam.T.$ord.T;
	$out.=join(T,@midi).T;
	$out.=join(T,@holo).T;
	$out.=join(T,@mt).T;
	$out.='X'.T;
	$out.=number_tree_splitter($trees[$_]).T for (0..4); # changed to 4.
	$out.='X'.T;
	$out.=(1000-$tally).T.join(T,@count).T;
	$out.=N;
	#exit;
	system('rm temp; rm temp2; rm tempX');
	
}




#END
(! $ARGV[0]) ? (out('summary.txt',$out)): (write_clp($out));


print "\nHaere mai\n\a";
exit;


#Variants were made via ./nw_prune test Holosporales |./nw_condense - | ./nw_order -c n - |./nw_order -c a -
#not ./nw_prune test Holosporales |./nw_condense - | ./nw_order -c n - |./nw_order -c a - | sort | uniq
#or similar
#for ease of analysis
__DATA__
# NOW READ FROM FILE topologies.txt