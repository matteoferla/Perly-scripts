#!/usr/bin/perl
use lib::sub;
use strict;
#use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';
use constant PI=> 3.1415926535;


############## main #######################################

sub::clear;
my $p=1;
my @gene=sub::table(sub::readfile('lib/E.coli.txt'));
my @header=@{shift(@gene)};
my $x=0;
my @name=();
foreach (@gene) {
	$name[$x++]=shift(@$_);
}

my @mean=map(0,0..$#header);
for my $n (1..$#header) {
	$mean[$n]=gen_mean([map($gene[$_][$n],0..$#gene)],$p);
}

nanbanjin(\@gene);
my $d;
my $dmode=$ARGV[0];
if ($dmode eq 'M') {print 'Calculating Mahalanobis..'.N; $d=mahalanobis_dist_from_mean(\@gene);}
if ($dmode=~ /(\d+)/) {$p=$1; print 'Calculating '.$p.'-Distance..'.N; $d=gen_dist_from_mean(\@gene,$p);}
if ($dmode eq 'C') {print 'Calculating Cosine..'.N; $d=cosine_dist_from_mean(\@gene);}
if ($dmode eq 'G') {print 'Calculating Gauss..'.N; $d=multivar_gauss(\@gene);}
if ($dmode eq 'N') {print 'Calculating many Gauss..'.N; $d=gauss_vector(\@gene);
	print 'Sorting'.N;
	my @unsorted=map([($name[$_],$d->[$_])],0..$#name);
	my @sort= sort{$b->[1] <=> $a->[1]} @unsorted;
	for my $n (0..9) {print sub::ordinal(1+$n).T.$sort[$n][0].T.join(T,@{$sort[$n][1]}).N;}
	exit;
} else {#test spot
	matrix_print(cov(\@gene));
}

print 'Sorting'.N;
my @unsorted=map([($name[$_],$d->[$_])],0..$#name);
my @sort= sort{$b->[1] <=> $a->[1]} @unsorted;
for my $n (0..9) {print sub::ordinal(1+$n).T.$sort[$n][0].T.$sort[$n][1].N;}






exit;

############## sub #######################################

sub matrix_print {
	my $ref=shift;
	if (! ref($ref->[0])) {$ref=v_to_m($ref);}
	@_=@$ref;
	
	print T.T.join(T,(0..$#{$_[0]})).N;
	print T.T;
	for my $n (0..$#{$_[0]}) {print '-'.T;} print N;
	for my $n (0..$#_) {print $n.T.'|'.T.join(T,@{$_[$n]}).N;}
	print N;
	
}

sub matrix_eps {
	my $matrix=shift;
	my $eps=shift;
	for my $m (0..$#$matrix) {for my $n (0..$#{$matrix->[0]}) {if (abs($matrix->[$m][$n]) < $eps) {$matrix->[$m][$n]=0;}}}
}


sub multivar_gauss {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	my $mean=mean_vector($matrix);
	my $cov=cov($matrix,$mean);
	matrix_print($cov);
	my $det=determinant($cov);
	print $det.'DET of Cov'.N;

	print ((2*PI)**(($max+1)/2)).'etc'.N;
	my $scale=1/sqrt($det*((2*PI)**($max+1)));
	print N.$scale.' is the scaling pre-exponential factor'.N;
	my @p=map(0,0..$#$matrix);
	my $icov=inverse($cov);
	print 'Starting gene by gene p-value calculations'.N;
	for my $n (0..$#$matrix) {
		my $x=vector_minus($matrix->[$n],$mean);
		my $t=matrix_multi(matrix_multi(transpose($x),$icov),$x);#copy paste from Mahalanobis...
		$p[$n]=exp($t->[0] * (-1/2));
		$p[$n]*=$scale;
	}
	return \@p;
}

sub gauss_vector {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	my $mean=mean_vector($matrix);
	my $dev=dev_vector($matrix,$mean);
	my @scale=map(1/(sqrt(2*PI)*$dev->[$_]),0..$max);
	@scale=map(1,0..$max);
	my @p=map([map(0,0..$max)],0..$#$matrix);
	print 'Starting gene by gene p-value vector calculations'.N;
	for my $m (0..$#$matrix) {
		for my $a (0..$max) {$p[$m][$a]=$scale[$a]*exp(-($matrix->[$m][$a] - $mean->[$a])**2/(2* ($dev->[$a] **2)));}
		print $m.':'.join(T,@{$p[$m]}).N;
	}
	return \@p;
}



sub slow_determinant {
	#laplace method
	my $matrix=shift;
	#print ('Size is '.($#$matrix+1).' x'.($#{$matrix->[0]}+1).' matrix'. N);
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



sub determinant {
	#LU
	my $matrix=shift;
	my ($l,$u)=LU($matrix);
	my $det=1;
	for my $n (0..$#$u) {$det*=$u->[$n][$n];}
	return $det;
}

sub LU {
	#doolittle
	my $U=duplicate($_[0]);
	my $dim=$#$U;
	my $L=[map([map(0,0..$dim)],0..$dim)];
	for my $i (0..$dim) {$L->[$i][$i]=1;}
	for my $n (0..($dim-1)) {
		if ($U->[$n][$n] ==0) {print 'Problem...'.$U->[$n][$n].' for '.$n.'th passage'.N;}
		my $l=[map([map(0,0..$dim)],0..$dim)];
		for my $i (0..$dim) {$l->[$i][$i]=1;}
		for my $i ($n+1..$dim) {
			$l->[$i][$n]=- $U->[$i][$n]/$U->[$n][$n];
			$L->[$i][$n]=$l->[$i][$n];
		}
		$U=matrix_multi($l,$U);
	}
	matrix_eps($L,1e-15);
	matrix_eps($U,1e-15);
	return ($L,$U);
}

sub duplicate {
	my $matrix=shift;
	my $copy;
	for my $i (0..$#$matrix) {
		for my $j (0..$#{$matrix->[$i]}) {$copy->[$i][$j]=$matrix->[$i][$j];}
 }
 return $copy;
}



sub matrix_slice {
	#Leave reference alone!
	my ($ref,$i, $j) =@_;
	my @major=@$ref;
	my @minor=();
	my @range_i=(0..$#major); splice(@range_i,$i,1);
	my @range_j=(0..$#major); splice(@range_j,$j,1);
	for my $n (@range_i) {my @temp=@{$major[$n]}; push(@minor,[@temp[@range_j]]);}
	return \@minor;
}


sub gen_mean {
	my $aref=shift;
	my $p=shift;
	my $average=0;
	if ($p==0) {
		for my $n (0..$#$aref) {
			if (abs($aref->[$n]) >0) {$average+=(1/(1+$#$aref)*log($aref->[$n]));}

		}
		
		$average=exp($average);
		#} elsif ($p=~ /inf/i) { if ($p=~ /[n\-]/i) {min} else {max}}
	}
	else {
		for my $n (0..$#$aref) {
			if ($aref->[$n]) {$average+=($aref->[$n]**$p);}
		}
		$average=($average/(1+$#$aref))**(1/$p);
	}
	
	return $average;
}

sub mean_vector {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	my @mean=map(0,0..$max);
	for my $n (0..$#$matrix) {
		for my $a (0..$max) {$mean[$a]+=$matrix->[$n][$a];}
	}
	for my $a (0..$max) {$mean[$a]/=(1+$#$matrix);}
	return \@mean;
}

sub dev_vector {
	my $matrix=shift;
	my $mean=shift;
	my $max=$#{$matrix->[0]};
	my @dev=map(0,0..$max);
	for my $n (0..$#$matrix) {
		for my $a (0..$max) {$dev[$a]+=($matrix->[$n][$a] - $mean->[$a])**2;}
	}
	for my $a (0..$max) {$dev[$a]=sqrt($dev[$a]/(1+$#$matrix));}
	return \@dev;
}


sub gen_dist_from_mean {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	my $p=shift;
	my @dist=map(0,0..$#$matrix);
	if ($p==0) {
		@dist=map(1,0..$max);
		print 'Zero norm will be interpreted as a geometric-mean--like, not as the count of non-zero elements'.N;  
		my @mean=map(1,0..$max);
		for my $n (0..$max) {
			$mean[$n]=gen_mean([map($matrix->[$_]->[$n],0..$#$matrix)],$p);
			for my $m (0..$#$matrix) {my $temp=abs($matrix->[$m]->[$n] - $mean[$n]); if ($temp>0) {$dist[$m]*=$temp;}}
		}
		for my $m (0..$#$matrix) {$dist[$m]=$dist[$m]**(1/$#$matrix);}
		
	} else {
		my @mean=();
		for my $n (0..$max) {
			$mean[$n]=gen_mean([map($matrix->[$_]->[$n],0..$#$matrix)],$p);
			for my $m (0..$#$matrix) {$dist[$m]+=abs($matrix->[$m]->[$n] - $mean[$n])**$p;}
		}
		for my $m (0..$#$matrix) {$dist[$m]=$dist[$m]**(1/$p);}
	}
	
	return \@dist;
}



sub cov {
	my $matrix=shift;
	my $mean=shift;
	my $max=$#{$matrix->[0]};
	my @cov=map([map(0,0..$max)],0..$max);
	for my $n (0..$#$matrix) {
		for my $m (0..$max) {
			for my $o (0..$max) {
				$cov[$m][$o]+=(($matrix->[$n]->[$m]) - $mean->[$m])*(($matrix->[$n]->[$o])- $mean->[$o]);
			}
		}
	}
	for my $m (0..$max) {for my $o (0..$max) {$cov[$m][$o]=$cov[$m][$o]/(1+$max);}}
	return \@cov;
}

sub inverse {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	my @inv=();
	my $max=$#{$matrix->[0]};
	for my $n (0..$#$matrix) {for my $m (0..$max) {$inv[$n][$m]=1/$matrix->[$n]->[$n];}}
	return \@inv;

}



sub mahalanobis_dist_from_mean {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	
	my @dist=map(0,0..$#$matrix);
	my $mean=mean_vector($matrix);
	my $cov=inverse(cov($matrix,$mean));
	for my $n (0..$#$matrix) {
		my $x=vector_minus($matrix->[$n],$mean);
		my $t=matrix_multi(matrix_multi(transpose($x),$cov),$x);
		$dist[$n]=sqrt(abs($t->[0]));
	}
	return \@dist;
}

sub cosine_dist_from_mean {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	my $mean=mean_vector($matrix);
	my @dist=map(0,0..$#$matrix);
	my $mean_norm=0;
	for my $n (0..$max) {$mean_norm += ($mean->[$n])**2;}
	$mean_norm=$mean_norm**(1/2);
	if ($mean_norm==0) {die 'Zero mean'.N;}
	for my $m (0..$#$matrix) {
		my $dot=0; my $norm=0;
		for my $n (0..$max) {$dot += ($mean->[$n]) * ($matrix->[$m]->[$n]); $norm+=(($matrix->[$m]->[$n]) **2);}
		if ($norm==0) {print 'DivZero for gene '.$m.N;} else {$dist[$m]=$dot/($mean_norm*$norm);}
		
	}
	return \@dist;
}

sub nanbanjin {
	my $matrix=shift;
	my $max=$#{$matrix->[0]};
	for my $n (0..$#$matrix) {for my $m (0..$max) {if (! $matrix->[$n]->[$m]) {$matrix->[$n]->[$m]=0;}}}
}


sub vector_minus {
	my $a=shift;
	my $b=shift;
	my @d=();
	foreach my $n (0..$#$a) {$d[$n]=$a->[$n] - $b->[$n];}
	return \@d;
}


sub matrix_multi {
	my ($refA,$refB)=@_;
	#print 'Here'.N;
	#matrix_print($refA); matrix_print($refB); 
	my @A=@$refA;
	my @B=@$refB;
	if ((ref($A[0]) eq 'ARRAY')&&(ref($B[0]) eq 'ARRAY')) {
		if ($#B != $#{$A[0]}) {die "1: Huston we have a problem in A ($#A x $#{$A[0]}) times B ($#B x $#{$B[0]})\n";}
		my @P=map([map(0,0..$#{$B[0]})],0..$#A);
		for my $n (0..$#A) {
			for my $m  (0..$#{$B[0]}) {
				for my $k (0..$#B) {
					$P[$n][$m]+=$A[$n][$k]*$B[$k][$m];
				}
			}
		}
		return \@P;
	}
	elsif ((ref($A[0]) eq 'ARRAY') && (! ref($B[0]))) {
		if ($#B != $#{$A[0]}) {die "2: Huston we have a problem in A ($#A x $#{$A[0]}) times B ($#B x 1)\n";}
		my @P=map(0,0..$#A);
		for my $n (0..$#A) {
			for my $k (0..$#B) {
				$P[$n]+=$A[$n][$k]*$B[$k];
			}
		}
		return \@P;
	}
	elsif ((ref($B[0]) eq 'ARRAY') && (! ref($A[0]))) {
		if ($#B != 0) {die "3: Huston we have a problem in A ($#A x 1) times B ($#B x $#{$B[0]})\n";}
		my @P=map([map(0,0..$#{$B[0]})],0..$#A);
		for my $n (0..$#A) {
			for my $m  (0..$#{$B[0]}) {
				$P[$n][$m]=$A[$n]*$B[0][$m];
			}
		}
		return \@P;
	}
	elsif ((! ref($A[0])) && (! ref($B[0]))) {die 'TBA 177'.N;}
	else {die 'TBA 178'.N;}
	
}

sub transpose {
	my ($refA)=@_;
	my @A=@$refA;
	my @T=();
	if (ref($A[0]) eq 'ARRAY') {
		for my $n (0..$#A) {
			for my $m (0..$#{$A[0]}) {
				$T[$m][$n]=$A[$n][$m];
			}
		}
	} else {
		$T[0]=[@A];
	}
	
	return \@T;
}