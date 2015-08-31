print "Hello World\n";
use constant PI => 3.1415926535;
my $now = time;
my @who=qw(Ala Arg Asn Asp Cys Gln Glu Gly His Ile Leu Lys Met Phe Pro Ser Thr Trp Tyr Val stop);

print "Insert codon frequency in the code...\n";

#equiprobable. NNN

for $n (0..11) {
	$freq[$n]=0.25;
} 

@prot=trans(\@freq);

##################################


for $n (0..20) {print "$who[$n]\t$prot[$n]\n";}



###########################
sub trans {
	my @base=@{ $_[0] };
	my @cc=();
	my @prot=();
	my $checksum=0;
	for $u (0..3) {
		for $v (0..3) {
			for $w (0..3) {
				$cc[$u][$v][$w]=$base[$u]*$base[4+$v]*$base[8+$w];
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
	
	return (@prot);
}