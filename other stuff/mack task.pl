use constant T=>"\t";
use constant N=>"\n";
print 'script running..'.N;
print 'name of tab separanted file?';
my $data=readfile(ask());
print 'what is the start of the range to use as a background?'; my $start=ask_number();
print 'what is the end of the range to use as a background?'; my $end=ask_number();

#the table does not start at zero.
$start-=$data->[0][0];
$end-=$data->[0][0];


#assumption made that the first column is the header!
my @background=map(0,0..$#{$data->[0]}); #why did I just bother to preallocate memory?
for my $n (1..$#{$data->[0]}) {
	for my $m ($start..$end) {
		$background[$n]+=$data->[$m][$n];
	}
	$background[$n]/=($end-$start);
}
open my $handle,'>out.txt';
for my $m (0..$#$data) {
	print $handle $data->[$m][0];
	for my $n (1..$#{$data->[0]}) {
		$data->[$m][$n]-=$background[$n];
		print $handle T.$data->[$m][$n];
	}
	print $handle N;
}
print 'file out made'.N;





exit;





sub readfile {
	my ($file)=@_;
BACK:
	open(FILE,$file) or do {print "Cannot find file called $file, what is it's real name?\n"; $file=<>; chomp $file; goto BACK;};	
	my @line=<FILE>;
	close FILE;
	chomp(@line);
	@line=split(/\r/,$line[0]) if ! $#line;
	return (\@line);
}

sub ask {
	my ($name)=@_;
	print "Simply press enter for default name ($name) or type:\n" if defined $name;
	my $input=<>; chomp($input);
	if (length($input)>0) {$name=$input;}
	if ((lc($name) eq 'quit')||(lc($name) eq 'q')||(lc($name) eq 'exit')) {
		print "Did you wish to give the command to exit? (>y<)\n if not (n), \"$name\" will be used as a name\n"; die if (ask_yn(1));
	}
	return $name;
}

sub ask_number {
	my ($default,$max)=@_;
	if ($max) {print 'Input number (in digits) upto '.$max.' inclusive (default is '.$default.'):'.T;}
	else {print 'Input number (in digits) (default is '.$default.'):'.T; $max=10^100;} #a googol!
	my $input=<>; chomp($input);
	if ($input=~ /[QE]/i) {die 'User request to quit'.N;} 
	elsif ($input=~ /(\d+)/) {$input=$1; if ($max<$input) {$input=$max;}; return $input;} 
	else {return $default;}
}