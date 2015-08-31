open(FILE,'file.txt') or die "no file mate!";
open(OUT,'>file_out.txt') or die "no file mate!";
open(OUTTWO,'>file_two.txt') or die "no file mate!";
@line=<FILE>;
chomp(@line);
foreach $n (@line) {
	$n=~ s/^ //msg;
	$n=~ s/\t /\t/msg;
	$n=~ s/ \t/\t/msg;
	print OUT "$n\n";
	@tab=split(/\t/,$n);
	foreach $m (@tab) {
		@words=($m=~ m/(\S+)/g);
		print OUTTWO ($#words+1)."\t";
	}
	print OUTTWO "\n";
}