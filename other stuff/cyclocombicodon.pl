print "Hello World\n";
use constant PI => 3.1415926535;
my $now = time;
my $epsilon=0.10;
my @who=qw(Ala Arg Asn Asp Cys Gln Glu Gly His Ile Leu Lys Met Phe Pro Ser Thr Trp Tyr Val stop);

my @weight=map{1} (0..20);
$weight[20]=5;
print ("weights:".join("\t",@weight)."\n");
#ecoli actual composition
my @aim=qw(0.094979205 0.054762039 0.039295849 0.051377411 0.011528026 0.044228438 0.057407375 0.073685219 0.022536085 0.059915446 0.106453518 0.043765169 0.028084876 0.038805723 0.044209042 0.057755759 0.053796707 0.015220008 0.028365374 0.070635547 0.003193184);
$target[0]=[@aim];
#equiprob
my @aim=qw(0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048  0.047619048);
$target[1]=[@aim];
for $a (0..2) {
	for $b (0..3) {
		$best[$a][$b]=10**100;
	}
}

#$freq[CODON][BASE]
my @freq=();
for ($freq[0][0]=0;$freq[0][0]<=1;$freq[0][0]+=$epsilon) {
	for ($freq[0][1]=0;$freq[0][1]<=(1-$freq[0][0]);$freq[0][1]+=$epsilon) {
		for ($freq[0][2]=0;$freq[0][2]<=(1-$freq[0][0]-$freq[0][1]);$freq[0][2]+=$epsilon) {
			$freq[0][3]=(1-$freq[0][0]-$freq[0][1]-$freq[0][2]); if ($freq[0][3]<0) {print "sum error!\n"}
			
			for ($freq[1][0]=0;$freq[1][0]<=1;$freq[1][0]+=$epsilon) {
				for ($freq[1][1]=0;$freq[1][1]<=(1-$freq[1][0]);$freq[1][1]+=$epsilon) {
					for ($freq[1][2]=0;$freq[1][2]<=(1-$freq[1][0]-$freq[1][1]);$freq[1][2]+=$epsilon) {
						$freq[1][3]=(1-$freq[1][0]-$freq[1][1]-$freq[1][2]); if ($freq[1][3]<0) {print "sum error!\n"}
						
						for ($freq[2][0]=0;$freq[2][0]<=1;$freq[2][0]+=$epsilon) {
							for ($freq[2][1]=0;$freq[2][1]<=(1-$freq[2][0]);$freq[2][1]+=$epsilon) {
								for ($freq[2][2]=0;$freq[2][2]<=(1-$freq[2][0]-$freq[2][1]);$freq[2][2]+=$epsilon) {
									$freq[2][3]=(1-$freq[2][0]-$freq[2][1]-$freq[2][2]); if ($freq[2][3]<0) {print "sum error!\n"}
									my @prot=();
									my $checksum=0;
									for $u (0..3) {
										for $v (0..3) {
											for $w (0..3) {
												$cc[$u][$v][$w]=$freq[0][$u]*$freq[1][$v]*$freq[2][$w];
												$checksum+=$cc[$u][$v][$w];
											}
										}
									} 
									if (($checksum>1.05) || ($checksum<0.95)) {print "WARNING... checksum: $checksum\n";}
									$prot[0]=$cc[3][2][1]+$cc[3][2][2]+$cc[3][2][0]+$cc[3][2][3];
									$prot[1]=$cc[2][3][1]+$cc[2][3][2]+$cc[2][3][0]+$cc[2][3][3]+$cc[0][3][0]+$cc[0][3][3];
									$prot[2]=$cc[0][0][1]+$cc[0][0][2];
									$prot[3]=$cc[3][0][1]+$cc[3][0][2];
									$prot[4]=$cc[1][3][1]+$cc[1][3][2];
									$prot[5]=$cc[2][0][0]+$cc[2][0][3];
									$prot[6]=$cc[3][0][0]+$cc[3][0][3];
									$prot[7]=$cc[3][3][1]+$cc[3][3][2]+$cc[3][3][0]+$cc[3][3][3];
									$prot[8]=$cc[2][0][1]+$cc[2][0][2];
									$prot[9]=$cc[0][1][1]+$cc[0][1][2]+$cc[0][1][0];
									$prot[10]=$cc[1][1][0]+$cc[1][1][3]+$cc[2][1][1]+$cc[2][1][2]+$cc[2][1][0]+$cc[2][1][3];
									$prot[11]=$cc[0][0][0]+$cc[0][0][3];
									$prot[12]=$cc[0][1][3];
									$prot[13]=$cc[1][1][1]+$cc[1][1][2];
									$prot[14]=$cc[2][2][1]+$cc[2][2][2]+$cc[2][2][0]+$cc[2][2][3];
									$prot[15]=$cc[1][2][1]+$cc[1][2][2]+$cc[1][2][0]+$cc[1][2][3]+$cc[0][3][1]+$cc[0][3][2];
									$prot[16]=$cc[0][2][1]+$cc[0][2][2]+$cc[0][2][0]+$cc[0][2][3];
									$prot[17]=$cc[1][3][3];
									$prot[18]=$cc[1][0][1]+$cc[1][0][2];
									$prot[19]=$cc[3][1][1]+$cc[3][1][2]+$cc[3][1][0]+$cc[3][1][3];
									$prot[20]=$cc[1][0][0]+$cc[1][3][0]+$cc[1][0][3];
									
									for $a (0..2) {
										for $b (0..1) {
											$dist[$a][$b]=0;
										}
									}
									for $a (0..1) {
										
										for $p (0..20) {
											$dist[$a][0]+= ($target[$a][$p] - $prot[$p])**2;
											$dist[$a][1]+= 1-(cos(abs($target[$a][$p] - $prot[$p])*PI));
											
											$dist[$a][2]+= ($weight[$p] * ($target[$a][$p] - $prot[$p])**2);
											$dist[$a][3]+= ($weight[$p] * (1-(cos(abs($target[$a][$p] - $prot[$p])*PI))));
											
										}
										for $b (0..3) {
											$survey[int(abs(log($dist[$a][$b]))*10)][$b]++;
											if ($dist[$a][$b]<$best[$a][$b]) {
												$best[$a][$b]=$dist[$a][$b]; for $g (0..2) {for $h (0..3) {$bestfreq[$a][$b][$g][$h]=$freq[$g][$h];}} for $i (0..20) {$bestpro[$a][$b][$i]=$prot[$i];}
											}
											
										}
										
									}
	
									$counter++;	
									
								}
							}
						}
						
						
					}
				}
			}
			
		}
	}
$done++; print ($done."\/".(1+1/$epsilon)." ($counter permutations tried)\n");
}

@model =("least square", "cosine basin","weighted least square", "weighted cosine basin");
@fit=("E.coli frequency","Equiprobable","Nil");
print "\nThis is the least square best fit to E.coli freq ($best[0][0])...\n\tA\tT\tC\tG";
for $cod (0..2) {
	print "\n\#".($cod+1)."\t";
	for $bass (0..3) {
		print $bestfreq[0][0][$cod][$bass]."\t";
	}
}
	
$file=(">bestfit".$epsilon.".txt");
open(OUT,$file) 	or die "Can't open file: $!";
print OUT ("epsilon:$epsilon\t".join("\t",@weight)."\n");

for $a (0..1) {
	for $b (0..3) {
		print OUT "\nThis is the (fit:$fit[$a] & method:$model[$b]) best ($best[$a][$b])...\n\tA\tT\tC\tG";
		for $cod (0..2) {
			print OUT "\n\#".($cod+1)."\t";
			for $bass (0..3) {
				print OUT $bestfreq[$a][$b][$cod][$bass]."\t";
			}
		}
	}
}


print OUT "\nProteinwise...\n\tEcoli_aim\tls_fit\tcb_fit\tw_ls_fit\tw_cb_fit\tequi_aim\tls_fit\tcb_fit\tw_ls_fit\tw_cb_fit";
for $viginti (0..20) {
	print OUT ("\n".$who[$viginti]);
	for $a (0..1) {
		print OUT ("\t".$target[$a][$viginti]);
		for $b (0..3) {
			print OUT ("\t".$bestpro[$a][$b][$viginti]);
		}
	}
	}
print OUT "\n\nDistance Survey\n";
print OUT "ln d\tls_fit\tcb_fit\tw_ls_fit\tw_cb_fit\n";
for $s (0..$#survey) {
	print OUT ($s."\t".join("\t",@{$survey[$s]})."\n");
}

print OUT "\n";
$now = time - $now;
printf("\nTotal running time: %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
print "Combinations tried: $counter\a\n";
end;