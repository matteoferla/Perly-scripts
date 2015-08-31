print "AA\tMEAN CG\tDEV CG\tN codons\n";
foreach (<DATA>) {
	s/\,//g;
	my @codon=split /\s/;
	my $header=shift(@codon);
	my $content=0;
	foreach my $x (@codon) {$content+=cg($x)}
	$content=$content/($#codon+1);
	my $dev=0;
	foreach my $x (@codon) {$dev+=($content-cg($x))**2}
	$dev=sqrt($dev/($#codon+1));
	print "${\substr($header,-1,1)}\t${\int($content*100)}%\t${\int($dev*100)}%\t${\scalar(@codon)}\n";
}

exit;


sub cg {return ((shift=~ tr/CG//)/3)}



__DATA__
Ala/A	GCU, GCC, GCA, GCG
Leu/L	UUA, UUG, CUU, CUC, CUA, CUG
Arg/R	CGU, CGC, CGA, CGG, AGA, AGG
Lys/K	AAA, AAG
Asn/N	AAU, AAC
Met/M	AUG
Asp/D	GAU, GAC
Phe/F	UUU, UUC
Cys/C	UGU, UGC
Pro/P	CCU, CCC, CCA, CCG
Gln/Q	CAA, CAG
Ser/S	UCU, UCC, UCA, UCG, AGU, AGC
Glu/E	GAA, GAG
Thr/T	ACU, ACC, ACA, ACG
Gly/G	GGU, GGC, GGA, GGG
Trp/W	UGG
His/H	CAU, CAC
Tyr/Y	UAU, UAC
Ile/I	AUU, AUC, AUA
Val/V	GUU, GUC, GUA, GUG