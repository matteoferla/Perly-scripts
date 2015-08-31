#!/usr/bin/perl
use strict;
use warnings;
use constant N => "\n";
use constant T => "\t";
my @matrix=();
my $dim=$ARGV[0];
my $vector=[map($_+1,0..$dim)]; #my $mat=matrix_multi($vector,transpose($vector)); @matrix=@$mat;
for my $n (0..$dim) {$matrix[$n]=[map($_+1+($n*(1+$dim)),0..$dim)];}
#for my $n (0..$dim) {$matrix[$n]=[map(rand(),0..$dim)];}
print N;



matrix_print(\@matrix);


my $ref_ev=eigenvector(\@matrix);
my $c=eigenvalue(\@matrix,$ref_ev);
#print 'DETERMINANT IS '.laplace(\@matrix).N;
print 'EIGENVECTOR IS '.join(T,@$ref_ev).N;
print 'EIGENVALUE  IS '.$c.N.N;

my ($ref_M,$ref_C)=omnieigenvectors(\@matrix);
my $trace=trace(\@matrix);
my $sum=0;
for my $n (0..$#matrix) {$sum+=$ref_C->[$n];}
print 'Trace '.$trace.N;
print 'sum of eigenvalues '.int($sum).N;


for my $n (0..$dim) {
	#print $n.' EIGENVECTOR IS '.join(T,@{$ref_M->[$n]}).N;
	print $n.' EIGENVALUE  IS '.$ref_C->[$n].N;
	print '........accounting for '.int($ref_C->[$n] /$sum*100 ).'% of variation'.N;
}

sub trace {
	my $ref=shift;
	my @A=@$ref;
	my $trace=0;
	for my $n (0..$#A) {$trace+=$A[$n][$n];}
	return $trace;
}

sub determinant {
	#laplace method
	my $refA=shift;
	my @A=@$refA;
	my $det=0;
	if ($#A==0) {$det=$A[0][0];}
	elsif ($#A==1) {$det=($A[0][0]*$A[1][1]-$A[1][0]*$A[0][1]);}
	else {
		my $i=0;
		for my $j (0..$#A) {
			my $coff=(-1)**($i+$j)*laplace(matrix_slice(\@A,$i,$j));
			$det+=($coff*$A[$i][$j]);
		}
	}
	return $det;
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

sub eigenvector {
	#square matrix power iteration
	my $ref=shift;
	my @T=@$ref;
	my @A=();
	for my $n (0..$#T) {for my $m (0..$#{$T[0]}) {$A[$n][$m]=$T[$n][$m];}}
	my $c_new=1000;
	my $c_old=0;
	my $e=1;
	my @X=map(1,0..$#A);
	while (log($e)>-10) {
		my $r_tmp=matrix_multi(\@A,\@X);
		my @tmp=@$r_tmp;
		my $norm_factor=0;
		for  my $k (0..$#A) {
			$norm_factor += $tmp[$k]**2;
		}

		$norm_factor=sqrt($norm_factor);
		@X=map($tmp[$_]/$norm_factor,0..$#A);
		$c_old=$c_new;
		$c_new=$norm_factor;
		$e=abs(($c_old-$c_new)/$c_new);
		if ($e==0) {return \@X; print 'just in case imposibility escape was activated!'.N;}
	}
	return \@X;
	
	
}

sub omnieigenvectors {
	my $temp_A=shift;
	my $dim=$#{$temp_A};
	my @M=(); my @C=();
	for my $n (0..$dim) {
		#print 'round'.$n.N;
		#matrix_print($temp_A);
		my $temp_V=eigenvector($temp_A);
		#matrix_print($temp_V);
		my $temp_c=eigenvalue($temp_A,$temp_V);
		push(@M,$temp_V); push(@C,$temp_c);
		my $refNum=matrix_multi($temp_V,transpose($temp_V));
		my $refDen=matrix_multi(transpose($temp_V),$temp_V);
		my $den=$refDen->[0]; #should be one...
		my @Z=(); foreach my $k (0..$dim) {$Z[$k]=[map(($temp_c / $den * $refNum->[$k]->[$_]),0..$dim)];}
		$temp_A=matrix_minus($temp_A,\@Z);
		#print 'Eigenvalue..'.$temp_c.N.N;
	}
	return (\@M,\@C);
}


sub next_eigenvector {
	#deflation iteration
	my ($refA,$refV,$c)=@_;
	my $dim=$#{$refA};
	#print 'vector..'.N;
	#matrix_print($refV); 
	#print 'transpose..'.N;
	#matrix_print(transpose($refV)); 
	my $refZ=matrix_multi($refV,transpose($refV));
	my @Z=(); foreach my $k (0..$dim) {$Z[$k]=[map(($c * $refZ->[$k]->[$_]),0..$dim)];}
	my $B=matrix_minus($refA,\@Z);
	
	#print 'HELLOOOO'.N;
	#matrix_print($B);
	return eigenvector($B);
}

sub psize {
	my $ref=shift;
	if (! ref($ref->[0])) {return ((1+$#$ref).' x '.(1));} else {
		return ((1+$#$ref).' x '.(1+$#{$ref->[0]}));
	}
}

sub matrix_minus {
	my ($refA,$refB)=@_;
	my @A=@$refA;
	my @B=@$refB;
	my @C=();
	for my $n (0..$#A) {
		for my $m (0..$#{$A[0]}) {
			$C[$n][$m]=$A[$n][$m]-$B[$n][$m];
		}
	}
	#print 'this is C'.N;
	#matrix_print(\@C);
	return \@C;
}

sub matrix_plus {
	my ($refA,$refB)=@_;
	my @A=@$refA;
	my @B=@$refB;
	my @C=0;
	for my $n (0..$#A) {
		for my $m (0..$#A) {
			$C[$n][$m]=$A[$n][$m]+$B[$n][$m];
		}
	}
	return \@C;
	
}

sub v_to_m {
	my $ref=shift;
	my @M=();
	if (! ref($ref)) {my @tmp=($ref); push(@M,[@tmp]); print 'Matrix of 1 x 1 made from scalar... This is an unusual request!'.N;}
	elsif (ref($ref) eq 'ARRAY') {
		my @bob=@$ref; 
		if (! ref($bob[0])) {for my $n (0..$#bob) {$M[$n][0]=$bob[$n];}} else {print 'Wrongly sent down... '.psize($ref).N; @M=@$ref;}
	}
	return \@M;
}





sub eigenvalue {
	my ($a,$v)=@_;
	my @A=@$a;
	my @V=@$v;
	my $mp=matrix_multi(\@A,\@V);
	my @values=map($mp->[$_]/$V[$_],0..$#V);
	my $evl=0;
	foreach (@values) {$evl+=$_/(1+$#values);}
	return $evl;
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

sub matrix_multi_broken {
	
	# ruins a ref somewhere...
	my ($refA,$refB)=@_;
	my @A=();
	my @B=();
	if (! ref($refA->[0])) {my $tmpA=v_to_m($refA); @A=@$tmpA; print 'vector A!'.N;} else {@A=@$refA;  print 'matrix A!'.N;}
	if (! ref($refB->[0])) {my $tmpB=v_to_m($refB); @B=@$tmpB;  print 'vector B!'.N;} else {@B=@$refB; print 'matrix B!'.N;}
	if ($#B != $#{$A[0]}) {die "Huston we have a problem in A ($#A x $#{$A[0]}) times B ($#B x $#{$B[0]})\n";}
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