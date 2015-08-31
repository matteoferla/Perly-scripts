die("No file name given as cmd-line argument, you bloomin' idiot\n") unless @ARGV;
@line=readfile($ARGV[0]);
foreach $n (@line) {
	@temp=($n=~ m/([\@\$\%\&]\w+)/g);
	push(@vars,@temp);
}
print join("\n",clean_array(@vars));




sub clean_array {
	my @array=@_;
	my @tempus=();
	for $n (@array) {
		if (length($n)>0) {
			$mi=0;
			$go=0;
			while ($go==0) {
				if ($mi>$#tempus) {
					push(@tempus,$n); $go=1;
				} else {
					$m=$tempus[$mi];
					if ($n eq $m) {$go=1;}
				}
				$mi++;
			}
		}
	}
	return sort(@tempus);
}

sub readfile {
	my ($file)=@_;
BACK:
	open(FILE,$file) or do {print "Cannot find file called $file, what is it's real name?\n"; $file=<>; chomp $file; goto BACK;};	
	my @line=<FILE>;
	close FILE;
	chomp(@line);
	if ($#line<2) {
		@temp=split(/\r/,$line[0]);
		@tempo=split(/\r/,$line[1]); #pretty sure cannot be.
		@line=@temp;
		push(@line,@tempo);
	}
	return (@line);
}