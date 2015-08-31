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

sub boots {
	my $seq=$_[0];
	my @boots=( $seq=~ /\W(\d{1,3})[^\.\w]./g);
	my $n=0;
	my $d=0;
	$n+=$_/($#boots+1) foreach @boots;
	$d+=(($n-$_)*($n-$_)) foreach @boots;
	$d=sqrt($d/($#boots+1)) if (@boots);
	return int($n).T.int($d).T.join(T,@boots);
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



####################################################################
###### Main ########################################################
####################################################################

system("clear");
print "Kia ora\n";

###PART 1
my $out="average bootstrap support\tAVG\tSTDEV\tNodes...\n";
my @trees=<bipartitions/*>; chomp(@trees);
$out.=$_.T.(boots(in($_))).N foreach (@trees);	#rather confusing.
#my $out="";
(! $ARGV[0]) ? (out('summary.txt',$out)): (write_clp($out));
exit;
###PART 2
mkdir "pruned";
$out.="node support\tRickettsidae. Support for (Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_))\tRickettsiales (senu novo). support for (Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)\tCrown. Support for (Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)\tCaulobacteridae_excl_Holosporales. Support for ((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_))\tCaulobacteridae incl Holo. SUpport (Candidatus_Odyssella_thessalonicensis_L13_,((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)))\tRick+Holo. Support for (Candidatus_Odyssella_thessalonicensis_L13_,(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)))\tbasal_holo. support for clade with Rickettsiadae and Caulobacteridae minus Holo\tPelagi in Caulo\tHolo in Rick\tPel and Holo in Caulo\tCaulo + Pelagi - Holo\n";
foreach my $file (<boots/*>) {
	
	$file=~s/boots\/RAxML_bootstrap\.//;
	my @support=("Error");
	
	#BACTERIA
	if (($file!~m/less/)&&($file!~m/trimmed/)) { #skip foo-less files.
		print "Normal. Looking at ".$file.N;
		
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Candidatus_Odyssella_thessalonicensis_L13_ ".
		"Acetobacter_pasteurianus_IFO_328301_ ".
		"Pelagibacteraceae_HIMB59_ ".
		"Magnetococcus_MC1_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rickettsia_bellii_RML369C_ ".
		"Rhodospirillum_rubrum_S1_ATCC_11170_ ".
		"Anaplasma_marginale_Puerto_Rico_|./nw_reroot - Magnetococcus_MC1_ > temp");
		my @arbors=`./nw_support -p ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /9/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}
		print "\n";
		system("rm temp");
		
		out('pruned/support-'.$file,join(N,@arbors));
		
		#(Magnetococcus_MC1_,((Candidatus_Odyssella_thessalonicensis_L13_,((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_))),(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_))));
		#(Magnetococcus_MC1_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),(Candidatus_Odyssella_thessalonicensis_L13_,(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)))));
		#(Magnetococcus_MC1_,(Candidatus_Odyssella_thessalonicensis_L13_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)))));
		
		#(Magnetococcus_MC1_,((Pelagibacteraceae_HIMB59_,((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_))),(Candidatus_Odyssella_thessalonicensis_L13_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_))));
		#(Magnetococcus_MC1_,(Candidatus_Odyssella_thessalonicensis_L13_,((Pelagibacteraceae_HIMB59_,((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)))),(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)));
		
		#(Magnetococcus_MC1_,((Rickettsia_bellii_RML369C_,Anaplasma_marginale_Puerto_Rico_),((((Sphingomonas_wittichii_RW1_,Rhizobium_leguminosarum_bv_trifolii_WSM1325_),Candidatus_Odyssella_thessalonicensis_L13_),(Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1_ATCC_11170_)),Pelagibacteraceae_HIMB59_)));

		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+)\)(\d+).*Rickettsia_bellii_RML369C_\)(\d+)\)(\d+)\)/) {
			$support[2]=$1;	#crown
			$support[3]=$2;	#Caulobacteridae_minus_Holosporales
			$support[4]=$3;	#Caulobacteridae+Holo
			$support[1]=$4; #Rickettsiales (senu novo)
			$support[0]=$5;  #Rickettsidae
		} else {print 'here (1): '.$file.N; goto SKIPPER;}
		
		if ($arbors[1]=~ /Rickettsia_bellii_RML369C_\)\d+\)\d+\)(\d+)/) {
			$support[5]=$1; #Rick+Holo
		} else {print 'here (2): '.$file.N; goto SKIPPER;}
		
		if ($arbors[2]=~ /Rickettsia_bellii_RML369C_\)\d+\)\d+\)(\d+)/) {
			$support[6]=$1; #basal_holo
		} else {print 'here (3): '.$file.N; goto SKIPPER;}
		
		if ($arbors[3]=~ /Sphingomonas_wittichii_RW1_\)\d+\)\d+\)(\d+).*Rickettsia_bellii_RML369C_\)\d+\)(\d+)\)/) {
			$support[7]=$1; #Pelagi in Caulo
			$support[8]=$2; #Ody in Rick
		} else {print 'here (4): '.$file.N; goto SKIPPER;}
		
		if ($arbors[4]=~ /Sphingomonas_wittichii_RW1_\)\d+\)\d+\)(\d+)\)(\d+)/) {
			$support[9]=$2; #Pelagi and Holo in Caulo
			$support[10]=$1; #Holo basal to Pelagi in Caulo: anti case S4
		} else {print 'here (5): '.$file.N; goto SKIPPER;}
		
	
	}
	
	#RHODOLESS/EXORHODOLESS
	elsif ($file=~m/rhodo/) {
		print "Rhodoless. Looking at ".$file.N;
		
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Candidatus_Odyssella_thessalonicensis_L13_ ".
		"Pelagibacteraceae_HIMB59_ ".
		"Magnetococcus_MC1_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rickettsia_bellii_RML369C_ ".
		"Anaplasma_marginale_Puerto_Rico_|./nw_reroot - Magnetococcus_MC1_ > temp");
		my @arbors=`./nw_support -p rhodo-ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /7/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}		
		system("rm temp");
		out('pruned/rhodo-support-'.$file,join(N,@arbors));
		
		#print N.N.join(N,@arbors).N;
		
		#(Magnetococcus_MC1_,((Candidatus_Odyssella_thessalonicensis_L13_,(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)100)50,(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)100)31)100)100;
		#(Magnetococcus_MC1_,((Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)100,(Candidatus_Odyssella_thessalonicensis_L13_,(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)100)31)6)100)100;
		#(Magnetococcus_MC1_,(Candidatus_Odyssella_thessalonicensis_L13_,((Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)100,(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)100)31)5)100)100;
		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+).*Rickettsia_bellii_RML369C_\)(\d+)\)(\d+)\)/) {
			$support[2]=$1;	#crown
			$support[3]="N/A";	#Caulobacteridae_minus_Holosporales
			$support[4]=$2;	#Caulobacteridae+Holo
			$support[1]=$3; #Rickettsiales (senu novo)
			$support[0]=$4;  #Rickettsidae
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[1]=~ /Rickettsia_bellii_RML369C_\)\d+\)\d+\)(\d+)/) {
			$support[5]=$1; #Rick+Holo
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[2]=~ /Rickettsia_bellii_RML369C_\)\d+\)\d+\)(\d+)/) {
			$support[6]=$1; #basal_holo
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[3]=~ /Sphingomonas_wittichii_RW1_\)\d+\)(\d+).*Rickettsia_bellii_RML369C_\)\d+\)(\d+)\)/) {
			$support[7]=$1; #Pelagi in Caulo
			$support[8]=$2; #Ody in Rick
		} else {print 'here (4): '.$file.N; goto SKIPPER;}
		
		if ($arbors[4]=~ /Sphingomonas_wittichii_RW1_\)\d+\)(\d+)\)(\d+)/) {
			$support[9]=$2; #Pelagi and Holo in Caulo
			$support[10]=$1; #Holo basal to Pelagi in Caulo: anti case S4
		} else {print 'here (5): '.$file.N; goto SKIPPER;}
		
		
	}
	
	#MAGNETOLESS
	elsif (($file=~m/magneto/)||($file=~m/trimmed/)) {  #or trimmedMg
		print "Magnetoless. Looking at ".$file.N;
				
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Candidatus_Odyssella_thessalonicensis_L13_ ".
		"Acetobacter_pasteurianus_IFO_328301_ ".
		"Pelagibacteraceae_HIMB59_ ".
		"Escherichia_coli_MG1655_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rickettsia_typhi_Wilmington_ ".
		"Magnetospirillum_magneticum_AMB1_ ".
		"Anaplasma_marginale_Puerto_Rico_|./nw_reroot - Escherichia_coli_MG1655_ > temp");
		my @arbors=`./nw_support -p magneto-ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /9/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}
		system("rm temp");
		
		out('pruned/magneto-support-'.$file,join(N,@arbors));
		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+)\)(\d+).*Rickettsia_typhi_Wilmington_\)(\d+)\)(\d+)\)/) {
			$support[2]=$1;	#crown
			$support[3]=$2;	#Caulobacteridae_minus_Holosporales
			$support[4]=$3;	#Caulobacteridae+Holo
			$support[1]=$4; #Rickettsiales (senu novo)
			$support[0]=$5;  #Rickettsidae
		} else {print 'here: A '.$file.N; goto SKIPPER;}
		
		if ($arbors[1]=~ /Rickettsia_typhi_Wilmington_\)\d+\)\d+\)(\d+)/) {
			$support[5]=$1; #Rick+Holo
		} else {print 'here: B '.$file.N; goto SKIPPER;}
		
		if ($arbors[2]=~ /Rickettsia_typhi_Wilmington_\)\d+\)\d+\)(\d+)/) {
			$support[6]=$1; #basal_holo
		} else {print 'here: C '.$file.N; goto SKIPPER;}
		
		if ($arbors[3]=~ /Sphingomonas_wittichii_RW1_\)\d+\)\d+\)(\d+).*Rickettsia_typhi_Wilmington_\)\d+\)(\d+)\)/) {
			$support[7]=$1; #Pelagi in Caulo
			$support[8]=$2; #Ody in Rick
		} else {print 'here (4): '.$file.N; goto SKIPPER;}
		
		if ($arbors[4]=~ /Sphingomonas_wittichii_RW1_\)\d+\)\d+\)(\d+)\)(\d+)/) {
			$support[9]=$2; #Pelagi and Holo in Caulo
			$support[10]=$1; #Holo basal to Pelagi in Caulo: anti case S4
		} else {print 'here (5): '.$file.N; goto SKIPPER;}
		
	}
	
	
	#Rickettiales -old meaning
	elsif ($file=~m/exorickettsia/) {
		print "ERick. Looking at ".$file.N;
		
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Acetobacter_pasteurianus_IFO_328301_ ".
		"Magnetococcus_MC1_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rhodospirillum_rubrum_S1_ATCC_11170_ ".
		"Pelagibacteraceae_HIMB59_ ".
		"|./nw_reroot - Magnetococcus_MC1_ > temp");
		my @arbors=`./nw_support -p exorickettsia-ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /6/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}
		system("rm temp");
		
		out('pruned/exorickettia-support-'.$file,join(N,@arbors));
		
		#(Magnetococcus_MC1_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),Pelagibacteraceae_HIMB59_));		
		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+)/) {
			$support[2]=$1;	#crown
			$support[3]=$2;	#Caulobacteridae_minus_Holosporales
			$support[4]="N\A";	#Caulobacteridae+Holo
			$support[1]="N\A"; #Rickettsiales (senu novo)
			$support[0]="N\A";  #Rickettsidae
		} else {print 'here: '.$file.N; goto SKIPPER;}
		$support[5]='N/A';
		$support[6]='N/A';
		$support[7]='N/A';
		$support[8]='N/A';
		$support[9]='N/A';
		$support[10]='N/A';
	}
	
	#RICKESTTIALES new
	elsif ($file=~m/rickettsia/) {
		print "Rickless. Looking at ".$file.N;
		
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Candidatus_Odyssella_thessalonicensis_L13_ ".
		"Acetobacter_pasteurianus_IFO_328301_ ".
		"Pelagibacteraceae_HIMB59_ ".
		"Magnetococcus_MC1_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rhodospirillum_rubrum_S1_ATCC_11170_ ".
		"|./nw_reroot - Magnetococcus_MC1_ > temp");
		
		my @arbors=`./nw_support -p rickettsia-ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /7/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}
		system("rm temp");
		
		out('pruned/rickettsia-support-'.$file,join(N,@arbors));
		
		#(Magnetococcus_MC1_,((Candidatus_Odyssella_thessalonicensis_L13_,((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_))),Pelagibacteraceae_HIMB59_));
		#(Magnetococcus_MC1_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),(Candidatus_Odyssella_thessalonicensis_L13_,Pelagibacteraceae_HIMB59_)));
		#(Magnetococcus_MC1_,(Candidatus_Odyssella_thessalonicensis_L13_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),Pelagibacteraceae_HIMB59_)));		
		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+)\)(\d+).*Pelagibacteraceae_HIMB59_\)(\d+)\)(\d+)/) {
			$support[2]=$1;	#crown
			$support[3]=$2;	#Caulobacteridae_minus_Holosporales
			$support[4]=$3;	#Caulobacteridae+Holo
			$support[1]="N\A"; #Rickettsiales (senu novo)
			$support[0]="N\A";  #Rickettsidae
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[1]=~ /Pelagibacteraceae_HIMB59_\)(\d+)\)/) {
			$support[5]=$1; #Rick+Holo
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[2]=~ /Pelagibacteraceae_HIMB59_\)(\d+)\)/) {
			$support[6]=$1; #basal_holo
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		$support[7]='N/A';
		$support[8]='N/A';
		$support[9]='N/A';
		$support[10]='N/A';
	}
	
	#Pelagi
	elsif ($file=~m/pelagi/) {
		print "pelagiless. Looking at ".$file.N;
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Candidatus_Odyssella_thessalonicensis_L13_ ".
		"Acetobacter_pasteurianus_IFO_328301_ ".
		"Magnetococcus_MC1_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rickettsia_bellii_RML369C_ ".
		"Rhodospirillum_rubrum_S1_ATCC_11170_ ".
		"Anaplasma_marginale_Puerto_Rico_|./nw_reroot - Magnetococcus_MC1_ > temp");
		my @arbors=`./nw_support -p pelagi-ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /8/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}
		system("rm temp");
		
		out('pruned/pelagi-support-'.$file,join(N,@arbors));
		
		#(Magnetococcus_MC1_,((Candidatus_Odyssella_thessalonicensis_L13_,((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_))),(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_)));
		#(Magnetococcus_MC1_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),(Candidatus_Odyssella_thessalonicensis_L13_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_))));
		#(Magnetococcus_MC1_,(Candidatus_Odyssella_thessalonicensis_L13_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_))));		
		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+)\)(\d+).*Rickettsia_bellii_RML369C_\)(\d+)\)(\d+)\)/) {
			$support[2]=$1;	#crown
			$support[3]=$2;	#Caulobacteridae_minus_Holosporales
			$support[4]=$3;	#Caulobacteridae+Holo
			$support[1]=$4; #Rickettsiales (senu novo)
			$support[0]="N\A";  #Rickettsidae
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[1]=~ /Rickettsia_bellii_RML369C_\)\d+\)(\d+)/) {
			$support[5]=$1; #Rick+Holo
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[2]=~ /Rickettsia_bellii_RML369C_\)\d+\)(\d+)/) {
			$support[6]=$1; #basal_holo
		} else {print 'here: '.$file.N; goto SKIPPER;}
		$support[7]='N/A';
		$support[8]='N/A';
		$support[9]='N/A';
		$support[10]='N/A';
		
	}
	
	
	#holo
	elsif ($file=~m/holo/) {
		print "Hololess. Looking at ".$file.N;
				
		system("./nw_prune -v boots/RAxML_bootstrap.$file ".
		"Acetobacter_pasteurianus_IFO_328301_ ".
		"Pelagibacteraceae_HIMB59_ ".
		"Magnetococcus_MC1_ ".
		"Rhizobium_leguminosarum_bv_trifolii_WSM1325_ ".
		"Sphingomonas_wittichii_RW1_ ".
		"Rickettsia_bellii_RML369C_ ".
		"Rhodospirillum_rubrum_S1_ATCC_11170_ ".
		"Anaplasma_marginale_Puerto_Rico_|./nw_reroot - Magnetococcus_MC1_ > temp");
		my @arbors=`./nw_support -p holo-ref.nw temp`;  #DAMN BUG IN NW. ./nw_support -p - bs_trees.nw does not work, so it has to be done in two steps.
		chomp(@arbors);
		
		my $leaves=`head -1 temp | ./nw_labels - |wc -l`; if ($leaves !~ /8/) {print "Missing leave(s). I have:\n".(`head -1 temp | ./nw_labels -`).N; goto SKIPPER;}
		system("rm temp");
		
		out('pruned/support-'.$file,join(N,@arbors));
		
		#(Magnetococcus_MC1_,(((Acetobacter_pasteurianus_IFO_328301_,Rhodospirillum_rubrum_S1__ATCC_11170_),(Rhizobium_leguminosarum_bv_trifolii_WSM1325_,Sphingomonas_wittichii_RW1_)),(Pelagibacteraceae_HIMB59_,(Anaplasma_marginale_Puerto_Rico_,Rickettsia_bellii_RML369C_))));		
		
		if ($arbors[0]=~ /Sphingomonas_wittichii_RW1_\)(\d+)\)(\d+).*Rickettsia_bellii_RML369C_\)(\d+)\)(\d+)\)/) {
			$support[2]=$1;	#crown
			$support[3]=$2;	#Caulobacteridae_minus_Holosporales
			$support[4]="N\A";	#Caulobacteridae+Holo
			$support[1]=$3; #Rickettsiales (senu novo)
			$support[0]=$4;  #Rickettsidae
		} else {print 'here: '.$file.N; goto SKIPPER;}
		
		if ($arbors[1]=~ /Sphingomonas_wittichii_RW1_\)\d+\)\d+\)(\d+)/) {
			$support[7]=$1; #Pelagi in Caulo
		} else {print 'here (4): '.$file.N; goto SKIPPER;}
		
		$support[8]='N/A';
		$support[9]='N/A';
		$support[10]='N/A';
	}
	
	else {print "Not sure what this is... ".$file.N;}
	
	
	#OUTPUT
SKIPPER:
	$out.=$file.T.join(T,@support).N;
	print N.N;
	
}


#END
(! $ARGV[0]) ? (out('summary.txt',$out)): (write_clp($out));


print "\nHaere mai\n\a";
exit;



__END__
#JUNK



