print "Hello World\n";
my $now = time;
my $epsilon=0.5;
#Ala Arg Asn Asp Cys Gln Glu Gly His Ile Leu Lys Met Phe Pro Ser Thr Trp Tyr Val stop 
my @aim=qw(0.094979205 0.054762039 0.039295849 0.051377411 0.011528026 0.044228438 0.057407375 0.073685219 0.022536085 0.059915446 0.106453518 0.043765169 0.028084876 0.038805723 0.044209042 0.057755759 0.053796707 0.015220008 0.028365374 0.070635547 0.003193184);
my $bls=1000000000;

#$freq[CODON][BASE]

@freq=();
while ($freq[0][0]<=1) {	
	
	while ($freq[0][1]<=(1-$freq[0][0])) {print (1-$freq[0][0]); print "\n";
		
		while ($freq[0][2]<=(1-$freq[0][0]-$freq[0][1])) {
			$freq[0][3]=(1-$freq[0][0]-$freq[0][1]-$freq[0][2]);
			while ($freq[1][0]<=1) {
				while ($freq[1][1]<=(1-$freq[1][0])) {
					while ($freq[1][2]<=(1-$freq[1][0]-$freq[1][1])) {
						$freq[1][3]=(1-$freq[1][0]-$freq[1][1]-$freq[1][2]);
						while ($freq[2][0]<=1) {
							while ($freq[2][1]<=(1-$freq[2][0])) {
								while ($freq[2][2]<=(1-$freq[2][0]-$freq[2][1])) {
									$freq[2][3]=(1-$freq[2][0]-$freq[2][1]-$freq[2][2]);
									
									######################
									
									my $checksum=0;
									for $u (0..3) {
										for $v (0..3) {
											for $w (0..3) {
												$cc[$u][$v][$w]=$freq[0][$u]*$freq[1][$v]*$freq[2][$w];
												$checksum+=$cc[$u][$v][$w];
											}
										}
									} 
									#print "checksum: $checksum\n";
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
									my $dist;
									for $p (0..20) {
										$ls+= ($aim[$p] - $prot[$p])**2;
									}
									if ($ls<$bls) {$bls=$ls; @bestls=@freq;}
									
									
									
									
									
									$counter++;	
									#####################
									
									$freq[2][2]+=$epsilon;
								}
								$freq[2][1]+=$epsilon;
							}
							$freq[2][0]+=$epsilon;
						}
						$freq[1][2]+=$epsilon;
					}
					$freq[1][1]+=$epsilon;
				}
				$freq[1][0]+=$epsilon;
			}
			$freq[0][2]+=$epsilon;
		}
		$freq[0][1]+=$epsilon;
	}
	$freq[0][0]+=$epsilon;
}




#$file=">bestfit.txt";
#open(OUT,$file) 	or die "Can't open file: $!";
print "This is the best...\n\tA\tT\tC\tG";
for $cod (0..2) {
	print "\n\#".($cod+1)."\t";
	for $bass (0..3) {
		print $bestls[$cod][$bass]."\t";
	}
}
$now = time - $now;
printf("\nTotal running time: %02d:%02d:%02d\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
print "Combinations tried: $counter\a\n";
end;