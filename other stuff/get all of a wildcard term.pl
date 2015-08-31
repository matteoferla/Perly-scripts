

$file="in.txt";
open(FILE,$file) or die "Bugger";
$file=">out.txt";
open(OUT,$file) or die "Bugger";

@line=<FILE>;
chomp(@line);
if ($#line<2) {
	@temp=split(/\r/,$line[0]);
	@tempo=split(/\r/,$line[1]); #pretty sure cannot be.
	@line=@temp;
	push(@line,@tempo);
}
sub clean {
	my $str=$_[0];
	$str=~ s/<\/.*?>/;/g;
	$str=~ s/<.*?>//g;
	$str=~ s/\s+/ /g;
	$str=~ s/[\t\n\r]/ /g;
	$str=~ s/^\s//g;
	$str=~ s/\s$//g;
	return ($str);
}

######CHANGE THIS#############
$n='PFAM:(.*?);';

foreach (@line) {
	if (/$n/) {print OUT clean($1)."\n";} else {print OUT "\-\n";}
}