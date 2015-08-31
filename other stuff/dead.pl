###DEAD CODE

my ($k,$genetag,$local_freq,$alphabet)=();

if ($options{max}) {$k=$options{max}} else {$k=settings->get('max')}
if ($options{gene_tag}) {$genetag=$options{gene_tag}} else {$genetag=settings->get('gene_tag')}
if ($options{freq}) {$local_freq=$options{freq}} else {$local_freq=settings::get('freq')}
if ($options{alphabet}) {$alphabet=$options{alphabet}} else {$alphabet=settings::get('alphabet')}

my @alphabet=@{${sub::permute_alphabet($alphabet,$k)}[$k]};



############### MULTIPLE!







sub multiget {
	shift if ($_[0] eq 'genome');
	my ($way,$name)=@_;
	$way=settings->get('many_get') if not defined $way;
	if (settings->get('many_get')==0) {$name=genome->details($name)} #NCBI requires an internet address. note that genome->details() can return more details.
	my $subs=settings->get('many_get_do');
	return $subs->[settings->get('many_get')]->('genome',$name);  #note that can be genome->ncbi(url) or genome->ncbi(who, url)
}

sub org_list {
	shift if ($_[0] eq 'genome');
	my $way=@_;
	
}





sub get_all_biocyc {
	my $files=available_biocyc();
	die unless (@$files); # no valid biocyc files!
	foreach my $dir (@$files)  {
		my $genome=genome->biocyc($dir);
		$genome->savetable();
		print {settings::get('inventory')} $genome->species().N;
	}
}

####################################################################################################################################################################
sub kstring {
	my $alphabet_set=sub::permute_alphabet(settings::get('alphabet'),settings::get('max'));
	
	my %a=map{$_=>filegroup_to_k(settings::get('write_dir')."/$_",settings::get('max'),$alphabet_set)} (@{settings::get('file_label')});
	my %b=map{$_=>filegroup_to_k(settings::get('write_dir')."/extra/$_",settings::get('max'),$alphabet_set)} (@{settings::get('stat_label')});
	my %Files=(%a,%b);
	
	######################################LOOP START##################################################################################################################
	for my $Whom (@{settings::get('species')}) {
		
		#sleep 60; # Decomment if overheating becomes an issue...
		
		my $genome=load_and_filter($Whom);		
		print_to_filegroup(\%Files,"$Whom\t");
		
		my %kbag=();
		my %kstring=();
		my %devstring=();
		
		print {settings::get('info')} $Whom.T.($genome->size+1).T.$genome->avglen.N;
		
		for my $k (1..settings::get('max')) {
			for my $mill (0..$genome->size)	{
				for my $n (0..length($genome->seq($mill))-$k+1) {$kbag{substr($genome->seq($mill),$n,$k)}[$mill]++;} #count
			}
			
			$genome->data_to_file(settings::get('write_dir')."/genome/count $k $Whom.txt",\%kbag,$alphabet_set->[$k]); #count
			
			
			for my $mill (0..$genome->size)	{
				my $totlen=0;
				if (! settings::get('freq')) {$totlen=$genome->avglen -$k+1;} else {$totlen=length($genome->seq($mill)) -$k+1;}
				if ($totlen==0) {die $mill.': '.$genome->display($mill).N;};
				for my $letter (@{$alphabet_set->[$k]}) {if($kbag{$letter}[$mill]) {$kbag{$letter}[$mill]/=$totlen;}} #freq
			}
			$genome->data_to_file(settings::get('write_dir')."/genome/freq $k ".legal($Whom).".txt",\%kbag,$alphabet_set->[$k]); #freq
			
			
			
			foreach my $letter (@{$alphabet_set->[$k]}) {
				my $momk=moments($kbag{$letter},$letter);
				if ($momk->[0]) {$kstring{$letter}=$momk->[0];}
				if ($momk->[1]) {$devstring{$letter}=$momk->[1];}
				foreach my $stat (0..$#{settings::get('stat_label')}) {print_if($Files{${settings::get('stat_label')}[$stat]}[$k],$momk->[$stat]);}
				delete $kbag{$letter};
			}
			
			# need to compute all mean freqs for reverse to work
			%kbag=();
			
			if ($k>1) {
				foreach my $letter (@{$alphabet_set->[$k]}) {   #FORMER MAP FUNCTION GROUP
					my $x=substr($letter,0,$k-1);
					my $y=substr($letter,1,$k-1);
					my $z=0; if ($k>2) {$z=substr($letter,1,$k-2);}
					my $p_kstring=predict_mean(\%kstring,$x,$y,$z);
					my $p_devstring=predict_dev(\%kstring,\%devstring,$x,$y,$z);
					
					#('freq','relative_difference','std_score','asymmetry','asymmetry_std_score','alt_relative_difference') unless settings changed by user
					foreach (@{settings::get('file_label')}) {my $temp=\&{"special_sub_$_"}; print_if($Files{$_}[$k],&$temp($letter,\%kstring,\%devstring,$p_kstring,$p_devstring));}
				} #key				
			}	else {foreach my $letter (@{$alphabet_set->[1]}) {print_if($Files{freq}[$k],$kstring{$letter});}}
			print "$k-string done\n";
		} #ks
		
		#############
		print_to_filegroup(\%Files,N);	
		######################################LOOP END##################################################################################################################
	}
	file_botch_fix();
}

###############################################################################################################

sub largek {
	my $alphabet_set=sub::permute_alphabet(settings::get('alphabet'),settings::get('max'));
	my %Files=map{$_=>filegroup_to_k(settings::get('write_dir')."/$_",settings::get('max'),$alphabet_set)} (@{settings::get('file_label')});
	
	
	######################################LOOP START##################################################################################################################
	for my $Whom (@{settings::get('species')}) {
		
		my $genome=load_and_filter($Whom);	
		print_to_filegroup(\%Files,"$Whom\t");
		
		###################################################################################################################################
		
		
		for my $k (1..settings::get('max')) {
			my $megagene=$genome->consolidate;
			my $tot_aa=length($megagene)-$k+1;
			my $tot_de=length($megagene)-$k;
			my $tot_dde=length($megagene)-$k-1;
			#('count','freq','relative_difference')
			foreach my $letter (@{$alphabet_set->[$k]}) {
				my $tally=tally($genome,$letter);
				print $letter.' appears '.$tally.' times'.N;
				print_if($Files{count}[$k],$tally);
				$tally=$tally/$tot_aa;
				print_if($Files{freq}[$k],$tally);
				if ($k==2) {
					my @subbag=(substr($letter,0,$k-1),substr($letter,1,$k-1));
					my @subtally=map(tally(\$megagene,$_),@subbag); #returns counts not freq...
					$subtally[0]/=$tot_de;
					$subtally[1]/=$tot_de;
					my $p=$subtally[0]*$subtally[1]; # predict mean
					print_if($Files{relative_difference}[$k],per_error($tally,$p)); 
				}
				elsif ($k>2) {
					my @subbag=(substr($letter,0,$k-1),substr($letter,1,$k-1),substr($letter,1,$k-2));
					my @subtally=map(tally(\$megagene,$_),@subbag); #returns counts not freq...
					$subtally[0]/=$tot_de;
					$subtally[1]/=$tot_de;
					$subtally[2]/=$tot_dde;
					my $p=$subtally[0]*$subtally[1]/$subtally[2]; # predict mean
					print_if($Files{relative_difference}[$k],per_error($tally,$p)); 
				}
			}
			print "$k-string done\n";
		}
		######################################LOOP END##################################################################################################################
	}
	file_botch_fix();
}

### 
sub analysis_long {
	my ($genome,$k)=@_;
	my $alphabet_set=sub::permute_alphabet(settings::get('alphabet'),settings::get('max'));
	my $file=settings::get('write_dir')."/stats ".legal($genome->species).".txt"; #returned value
	my $handle=sub::handle($file);
	print $handle $genome->species.T.($genome->size+1).T.$genome->avglen.N;
	print $handle 'letter'.T.join(T,@{settings::get('stat_label')}).T;
	if ($k>1) {print $handle join(T,@{settings::get('file_label')}).N;} else {print $handle 'freq'.N;}
	
	
	my %kbag=(); my %kstring; my %devstring;
	for my $mill (0..$genome->size)	{
		my $totlen=0;
		for my $n (0..length($genome->seq($mill))-$k+1) {$kbag{substr($genome->seq($mill),$n,$k)}[$mill]++;} #count
		if (! settings::get('freq')) {$totlen=$genome->avglen -$k+1;} else {$totlen=length($genome->seq($mill)) -$k+1;} die $genome->display($mill) if $totlen==0;
		for my $letter (@{$alphabet_set->[$k]}) {if($kbag{$letter}[$mill]) {$kbag{$letter}[$mill]/=$totlen;}} #freq
	}
	
	$genome->data_to_file(settings::get('write_dir')."/freq ".legal($genome->species).".txt",\%kbag,$alphabet_set->[$k]); #freq
	
	foreach my $letter (@{$alphabet_set->[$k]}) {
		
		print $handle $letter.T;
		my $momk=moments($kbag{$letter},$letter);
		if ($momk->[0]) {$kstring{$letter}=$momk->[0];}
		if ($momk->[1]) {$devstring{$letter}=$momk->[1];}
		foreach my $stat (0..$#{settings::get('stat_label')}) {print_if($handle,$momk->[$stat]);}
		delete $kbag{$letter};
		
		if ($k>1) {
			my $x=substr($letter,0,$k-1);
			my $y=substr($letter,1,$k-1);
			my $z=0; if ($k>2) {$z=substr($letter,1,$k-2);}
			my $p_kstring=predict_mean(\%kstring,$x,$y,$z);
			my $p_devstring=predict_dev(\%kstring,\%devstring,$x,$y,$z);
			
			#('freq','relative_difference','std_score','asymmetry','asymmetry_std_score','alt_relative_difference') unless settings changed by user
			foreach (@{settings::get('file_label')}) {my $temp=\&{"special_sub_$_"}; print_if($handle,&$temp($letter,\%kstring,\%devstring,$p_kstring,$p_devstring));}			
		}	else {print_if($handle,$kstring{$letter});}
		print $handle N;
	}
	close $handle;
	return $file;
}


###
sub tandem {
	my $alphabet_set=[];
	my $n=0;
	open(SNARE,'>',settings::get('write_dir')."/special_TR.txt") 	or die "Can't create file: $!";
	open(TANDEM,'>',settings::get('write_dir')."/tandem.txt") 	or die "Can't create file file: $!";
	for my $y (0..19) {
		for my $x (2..10)	{
			$alphabet_set->[0][$n++]=$x.'x'.${settings::get('alphabet')}[$y];
		}
	}
	
	my %Files=map{$_=>filegroup_to_k(settings::get('write_dir')."/extra/$_",settings::get('max'),$alphabet_set)} (@{settings::get('stat_label')});
	
	
	for my $Whom (@{settings::get('species')}) {
		
		
		my $genome=load_and_filter($Whom);	
		my @temp=();
		
		my $file='>',settings::get('write_dir')."/genome/tandem ".legal($Whom).".txt"; open(GEN,$file) or die "Can't create file $file: $!";
		print GEN "gene\t".join("\t",@{$alphabet_set->[0]}).N;
		
		my @momtandem=(); 
		my @tandem=();
		my @aa=(); my @len=(); my @char=(); 
		print {settings::get('info')} $Whom.T.($genome->size+1).T.($genome->avglen).N;
		
		for my $mill (0..$genome->size)	{
			print GEN "$genome->key($mill)";
			@aa=split(//,$genome->seq($mill));
			push(@aa,'!');
			for my $n (0..$#aa-1) {
				my $multiloop=0;
				while ($aa[$multiloop+$n] eq "$aa[$n]") {$multiloop++;}
				$multiloop--;$multiloop--;
				
				if ($multiloop > -1) {
					if ($multiloop > 9) {
						print "WARNING: A homopolymeric track of ".($multiloop+2)." tandem repeats was encountered! This is very Unusual for Prokaryotes!!\n";
						print SNARE $Whom.T.$genome->display($mill,T).T.($multiloop+2).'x'.$aa[$n];
						$multiloop=8;
					} 
					my $div=0;
					if (! settings::get('freq')) {$div=$genome->avglen;} else {$div=$#{$aa[$mill]};}  # does adjust for length of string... not really necessary really.. 300 or 295 are the same
					$tandem[$multiloop][ord($aa[$n])-65][$mill]+=(1/$div);
					$mill+=$multiloop+2;
				}
			}
			for my $y (0,2..8,10..13,15..19,21,22,24) {
				for my $x (0..8) {
					print_if (*GEN,$tandem[$x][$y][$mill]);
				}
			}
			print GEN N;
		}
		close GEN;
		
		########Stats##############################################
		for my $y (0,2..8,10..13,15..19,21,22,24) {
			for my $x (0..8) {
				$momtandem[$x][$y]=moments($tandem[$x][$y],($x+2).'x'.chr(65+$y));
				delete $tandem[$x][$y];
				foreach my $stat (0..$#{settings::get('stat_label')}) {print_if($Files{${settings::get('stat_label')}[$stat]}[0],$momtandem[$x][$y][$stat]);}
			}
		}
		
		
		print TANDEM "$Whom\t";
		for my $y (0,2..8,10..13,15..19,21,22,24) {
			for my $x (0..8)	{
				print TANDEM "$momtandem[$x][$y][0]\t";
			}
		}
		
		
	}
}


########################################################################################################################################################







sub filegroup_to_k {
	my ($file,$max,$head)=@_;
	return filegroup([map("$file k$_.txt",0..$max)],$head);
}

########################################################################################################################################################
sub load_and_filter {
	my ($who)=@_;
	my $genome=genome->multiget($who);
	$genome=$genome->cog_filter();
	print "Analysis $who (".(1+$genome->size)." out of ".(1+$genome->{orginalsize})." genes)\n";
	return $genome;
}

########################################################################################################################################################
sub file_botch_fix {
	#### delete useless files (they exist due to an odd bug)
	my $dir=settings->get('write_file');
	unlink("$dir/freq k0.txt");
	unlink("$dir/count k0.txt");
	unlink("$dir/relative_difference k0.txt");
	unlink("$dir/relative_difference k1.txt");
	unlink("$dir/std_score k0.txt");
	unlink("$dir/std_score k1.txt");
	unlink("$dir/asymmetry k0.txt");
	unlink("$dir/asymmetry k1.txt");
	unlink("$dir/asymmetry_std_score k0.txt");
	unlink("$dir/asymmetry_std_score k1.txt");
	unlink("$dir/alt_relative_difference k0.txt");
	unlink("$dir/alt_relative_difference k1.txt");
	unlink("$dir/extra/avg k0.txt");      
	unlink("$dir/extra/stdev k0.txt");
	unlink("$dir/extra/skew k0.txt");
	unlink("$dir/extra/kurt k0.txt");
	unlink("$dir/extra/cv k0.txt");
	unlink("$dir/extra/min k0.txt");
	unlink("$dir/extra/max k0.txt");
}

sub print_to_filegroup {
	my ($filehash,$string)=@_;
	foreach my $n (keys %$filehash) {
		for my $k (0..$#{$filehash->{$n}}) {
			print {$filehash->{$n}[$k]} ($string) or die;
		}
	}
}


sub print_if {
	my ($handle,$value)=@_;
	if ($value) {print $handle ($value.T) or die "cannot find file handle $handle";}
	else {print $handle ('0'.T) or die "cannot find file handle $handle";}
}


########################################################################################################################################################

sub filegroup {
	my ($ref_name,$ref_header) = @_;
	my $looper="off";
	if (ref($ref_header->[0]) eq 'ARRAY') {$looper=0;}
	my $file;
	my @handle=();
	foreach my $file (@$ref_name) {
		my $hand=sub::handle($file);
		if ($looper eq "off") {	print $hand ("Org\t".join("\t",@$ref_header)); }
		else {print $hand ("Org\t".join(T,@{$ref_header->[$looper]}).N); $looper++;} 
		push (@handle, $hand);
	}
	return \@handle;
}







######################### These appear twice! Damn.
sub moments {
	#avg, stdev, skew, kurt, followed by non-moments but useful descriptors... cv, min and max
	my ($ref,$label)=@_;
	my $n=0;
	for my $n (0..$#$ref)	{if(! $ref->[$n]) {$ref->[$n]=0;}}
	if ($#$ref>0) {
		my @moment=map(0,0..3); #preallocation
		for my $n (0..$#$ref)	{ $moment[0]+=$ref->[$n]/($#$ref+1);}
		for my $n (0..$#$ref)	{ $moment[1]+=($ref->[$n]-$moment[0])**2;} $moment[1]=sqrt($moment[1]/($#$ref+1));
		if ($moment[1] >0) {
			for my $n (0..$#$ref)	{ $moment[2]+=($ref->[$n]-$moment[0])**3;} $moment[2]=($moment[2]/(($#$ref+1)*($moment[1]**3)));
			for my $n (0..$#$ref)	{ $moment[3]+=($ref->[$n]-$moment[0])**4;} $moment[3]=($moment[3]/(($#$ref+1)*($moment[1]**4)))-3;
		}
		$moment[4]=$moment[1]/$moment[0];
		$moment[5]=$moment[0]; $moment[6]=$moment[0];
		for my $n (0..$#$ref)	{ if ($moment[5]>$ref->[$n]) {$moment[5]=$ref->[$n];}}
		for my $n (0..$#$ref)	{ if ($moment[6]<$ref->[$n]) {$moment[6]=$ref->[$n];}}
		return (\@moment);
	}
	else {print "$label is absent in current species\n"; return [(0,0)];}
}




sub special_sub_freq {
	my ($x, $ref_mean,$ref_dev,$p_mean,$p_dev)=@_;
	return $ref_mean->{$x};
}

sub special_sub_relative_difference {
	my ($x, $ref_mean,$ref_dev,$p_mean,$p_dev)=@_;
	return sub::per_error($ref_mean->{$x},$p_mean);
}

sub special_sub_std_score {
	my ($x,$ref_mean,$ref_dev,$p_mean,$p_dev)=@_;
	return sub::zscore($ref_mean->{$x},$p_mean,$p_dev);
}

sub special_sub_asymmetry {
	my ($x, $ref_mean,$ref_dev,$p_mean,$p_dev)=@_;
	return sub::per_error($ref_mean->{$x},$ref_mean->{reverse $x});
}

sub special_sub_asymmetry_std_score {
	my ($x, $ref_mean,$ref_dev,$p_mean,$p_dev)=@_;
	return sub::zscore($ref_mean->{$x},$ref_mean->{reverse $x},$ref_dev->{reverse $x});
}

sub special_sub_alt_relative_difference {
	my ($x, $ref_mean,$ref_dev,$p_mean,$p_dev)=@_;
	return sub::rel_diff($ref_mean->{$x},$p_mean);
}

######################### end of subs to be referenced

########################################################################################################################################################


sub predict_mean {
	my ($mean,$x,$y,$z)=@_;
	if ((! $mean->{$x})||(! $mean->{$y})) {return 0;}
	if (! $z) {return $mean->{$x}*$mean->{$y};}
	else {return $mean->{$x}*$mean->{$y}/$mean->{$z};}
}

sub predict_dev {
	my ($mean,$dev,$x,$y,$z)=@_;
	if ((! $dev->{$x})||(! $dev->{$y})) {return 0;}
	my $sigma=0;
	if (! $z) {
		$sigma=($dev->{$x}*$dev->{$y})**2+($dev->{$x}*$mean->{$y})**2+($mean->{$x}*$dev->{$y})**2;
	}
	else {
		$sigma=((
		$mean->{$x}+$mean->{$y}
		)/$mean->{$z}
		)**2
		*(($dev->{$x}*$dev->{$y})**2
		+($dev->{$x}*$mean->{$y})**2
		+($mean->{$x}*$dev->{$y})**2
		/($mean->{$x}+$mean->{$y})**2
		+($dev->{$z}/$mean->{$z})**2);
		
	}
	return $sigma;
}

#DEAD CODE
sub matrix_slice {
	#Leave reference alone! used for the laplace determinant
	my ($ref,$i, $j) =@_;
	my @major=@$ref;
	my @minor=();
	my @range_i=(0..$#major); splice(@range_i,$i,1);
	my @range_j=(0..$#major); splice(@range_j,$j,1);
	for my $n (@range_i) {my @temp=@{$major[$n]}; push(@minor,[@temp[@range_j]]);}
	return \@minor;
}

sub slow_determinant {
	#laplace method...
	my $matrix=shift;
	my $det=0;
	if ($#$matrix==0) {$det=$matrix->[0]->[0];}
	elsif ($#$matrix==1) {$det=($matrix->[0]->[0]*$matrix->[1]->[1]-$matrix->[1]->[0]*$matrix->[0]->[1]);}
	else {
		my $i=0;
		for my $j (0..$#$matrix) {
			my $coff=(-1)**($i+$j)*determinant(matrix_slice($matrix,$i,$j));
			$det+=($coff*$matrix->[$i]->[$j]);
		}
	}
	return $det;
}

sub issue_of_sum {
	my $vector=shift; # row vector
	my $s=1;
	for my $n (0..$vector->size(2)) {$s-=$vector->element(0,$n);}
	return $s;
}

sub read_nomarker {
	#constructor method
	my ($class,$file,$row_head)=@_;
	$row_head=2 if not defined $row_head;
	if (not defined $file) {$file=settings->get('stats_file'); $row_head=2;}
	my $table=sub::table(sub::readfile($file));
	my $header;
	while ($row_head) {$header=shift(@$table); $row_head--;}
	shift @$header;
	my $x=0;
	my @name=();
	foreach (@$table) {
		$name[$x++]=shift(@$_);
	}
	my $ref={name=>$file, data=>$table, colhead=>$header, rowhead=>\@name};
	bless $ref;
	return $ref;
}
