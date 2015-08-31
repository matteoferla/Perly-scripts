#!/usr/bin/perl


print "hello World\n";
open(IN,'whog') or die "Can't open file: $!";
open(OUT,'>cog.txt') 	or die "Can't open file: $!";
@lines=<IN>;

foreach $item (@lines)
{
	
	if ($item =~ m/\[/)
	{
		#[H] COG0001 Glutamate-1-semialdehyde aminotransferase
			@col=();
		$item =~ m/\[(\w)*?\] (\w*?) (.*)/;
		$col[0] =$1;
		$col[1] =$2;
		$col[2] =$3;
	}

	if ($item =~ m/ Aae\:/) { $item =~ m/ Aae\: (.*)/; $col[3] =$1;}
	if ($item =~ m/ Afu\:/) { $item =~ m/ Afu\: (.*)/; $col[4] =$1;}
	if ($item =~ m/ Ape\:/) { $item =~ m/ Ape\: (.*)/; $col[5] =$1;}
	if ($item =~ m/ Atu\:/) { $item =~ m/ Atu\: (.*)/; $col[6] =$1;}
	if ($item =~ m/ Bbu\:/) { $item =~ m/ Bbu\: (.*)/; $col[7] =$1;}
	if ($item =~ m/ Bha\:/) { $item =~ m/ Bha\: (.*)/; $col[8] =$1;}
	if ($item =~ m/ Bme\:/) { $item =~ m/ Bme\: (.*)/; $col[9] =$1;}
	if ($item =~ m/ Bsu\:/) { $item =~ m/ Bsu\: (.*)/; $col[10] =$1;}
	if ($item =~ m/ Buc\:/) { $item =~ m/ Buc\: (.*)/; $col[11] =$1;}
	if ($item =~ m/ Cac\:/) { $item =~ m/ Cac\: (.*)/; $col[12] =$1;}
	if ($item =~ m/ Ccr\:/) { $item =~ m/ Ccr\: (.*)/; $col[13] =$1;}
	if ($item =~ m/ Cgl\:/) { $item =~ m/ Cgl\: (.*)/; $col[14] =$1;}
	if ($item =~ m/ Cje\:/) { $item =~ m/ Cje\: (.*)/; $col[15] =$1;}
	if ($item =~ m/ Cpn\:/) { $item =~ m/ Cpn\: (.*)/; $col[16] =$1;}
	if ($item =~ m/ Ctr\:/) { $item =~ m/ Ctr\: (.*)/; $col[17] =$1;}
	if ($item =~ m/ Dra\:/) { $item =~ m/ Dra\: (.*)/; $col[18] =$1;}
	if ($item =~ m/ Eco\:/) { $item =~ m/ Eco\: (.*)/; $col[19] =$1;}
	if ($item =~ m/ Ecs\:/) { $item =~ m/ Ecs\: (.*)/; $col[20] =$1;}
	if ($item =~ m/ Ecu\:/) { $item =~ m/ Ecu\: (.*)/; $col[21] =$1;}
	if ($item =~ m/ EcZ\:/) { $item =~ m/ EcZ\: (.*)/; $col[22] =$1;}
	if ($item =~ m/ Fnu\:/) { $item =~ m/ Fnu\: (.*)/; $col[23] =$1;}
	if ($item =~ m/ Hbs\:/) { $item =~ m/ Hbs\: (.*)/; $col[24] =$1;}
	if ($item =~ m/ Hin\:/) { $item =~ m/ Hin\: (.*)/; $col[25] =$1;}
	if ($item =~ m/ Hpy\:/) { $item =~ m/ Hpy\: (.*)/; $col[26] =$1;}
	if ($item =~ m/ jHp\:/) { $item =~ m/ jHp\: (.*)/; $col[27] =$1;}
	if ($item =~ m/ Lin\:/) { $item =~ m/ Lin\: (.*)/; $col[28] =$1;}
	if ($item =~ m/ Lla\:/) { $item =~ m/ Lla\: (.*)/; $col[29] =$1;}
	if ($item =~ m/ Mac\:/) { $item =~ m/ Mac\: (.*)/; $col[30] =$1;}
	if ($item =~ m/ Mge\:/) { $item =~ m/ Mge\: (.*)/; $col[31] =$1;}
	if ($item =~ m/ Mja\:/) { $item =~ m/ Mja\: (.*)/; $col[32] =$1;}
	if ($item =~ m/ Mka\:/) { $item =~ m/ Mka\: (.*)/; $col[33] =$1;}
	if ($item =~ m/ Mle\:/) { $item =~ m/ Mle\: (.*)/; $col[34] =$1;}
	if ($item =~ m/ Mlo\:/) { $item =~ m/ Mlo\: (.*)/; $col[35] =$1;}
	if ($item =~ m/ Mpn\:/) { $item =~ m/ Mpn\: (.*)/; $col[36] =$1;}
	if ($item =~ m/ Mpu\:/) { $item =~ m/ Mpu\: (.*)/; $col[37] =$1;}
	if ($item =~ m/ MtC\:/) { $item =~ m/ MtC\: (.*)/; $col[38] =$1;}
	if ($item =~ m/ Mth\:/) { $item =~ m/ Mth\: (.*)/; $col[39] =$1;}
	if ($item =~ m/ Mtu\:/) { $item =~ m/ Mtu\: (.*)/; $col[40] =$1;}
	if ($item =~ m/ NmA\:/) { $item =~ m/ NmA\: (.*)/; $col[41] =$1;}
	if ($item =~ m/ Nme\:/) { $item =~ m/ Nme\: (.*)/; $col[42] =$1;}
	if ($item =~ m/ Nos\:/) { $item =~ m/ Nos\: (.*)/; $col[43] =$1;}
	if ($item =~ m/ Pab\:/) { $item =~ m/ Pab\: (.*)/; $col[44] =$1;}
	if ($item =~ m/ Pae\:/) { $item =~ m/ Pae\: (.*)/; $col[45] =$1;}
	if ($item =~ m/ Pho\:/) { $item =~ m/ Pho\: (.*)/; $col[46] =$1;}
	if ($item =~ m/ Pmu\:/) { $item =~ m/ Pmu\: (.*)/; $col[47] =$1;}
	if ($item =~ m/ Pya\:/) { $item =~ m/ Pya\: (.*)/; $col[48] =$1;}
	if ($item =~ m/ Rco\:/) { $item =~ m/ Rco\: (.*)/; $col[49] =$1;}
	if ($item =~ m/ Rpr\:/) { $item =~ m/ Rpr\: (.*)/; $col[50] =$1;}
	if ($item =~ m/ Rso\:/) { $item =~ m/ Rso\: (.*)/; $col[51] =$1;}
	if ($item =~ m/ Sau\:/) { $item =~ m/ Sau\: (.*)/; $col[52] =$1;}
	if ($item =~ m/ Sce\:/) { $item =~ m/ Sce\: (.*)/; $col[53] =$1;}
	if ($item =~ m/ Sme\:/) { $item =~ m/ Sme\: (.*)/; $col[54] =$1;}
	if ($item =~ m/ Spn\:/) { $item =~ m/ Spn\: (.*)/; $col[55] =$1;}
	if ($item =~ m/ Spo\:/) { $item =~ m/ Spo\: (.*)/; $col[56] =$1;}
	if ($item =~ m/ Spy\:/) { $item =~ m/ Spy\: (.*)/; $col[57] =$1;}
	if ($item =~ m/ Sso\:/) { $item =~ m/ Sso\: (.*)/; $col[58] =$1;}
	if ($item =~ m/ Sty\:/) { $item =~ m/ Sty\: (.*)/; $col[59] =$1;}
	if ($item =~ m/ Syn\:/) { $item =~ m/ Syn\: (.*)/; $col[60] =$1;}
	if ($item =~ m/ Tac\:/) { $item =~ m/ Tac\: (.*)/; $col[61] =$1;}
	if ($item =~ m/ Tma\:/) { $item =~ m/ Tma\: (.*)/; $col[62] =$1;}
	if ($item =~ m/ Tpa\:/) { $item =~ m/ Tpa\: (.*)/; $col[63] =$1;}
	if ($item =~ m/ Tvo\:/) { $item =~ m/ Tvo\: (.*)/; $col[64] =$1;}
	if ($item =~ m/ Uur\:/) { $item =~ m/ Uur\: (.*)/; $col[65] =$1;}
	if ($item =~ m/ Vch\:/) { $item =~ m/ Vch\: (.*)/; $col[66] =$1;}
	if ($item =~ m/ Xfa\:/) { $item =~ m/ Xfa\: (.*)/; $col[67] =$1;}
	if ($item =~ m/ Ype\:/) { $item =~ m/ Ype\: (.*)/; $col[68] =$1;}
	if ($item =~ m/___/) {print OUT join("\t",@col)."\n";}

	
}	
end;
