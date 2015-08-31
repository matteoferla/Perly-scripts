package sub;
#17-9-10
my $start_time=time();
my $os = $^O;

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

sub get {
	return got($_[0]);
}

sub got {
	my $home=$_[0];
	require LWP::UserAgent;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(200);
	$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
	$ua->env_proxy;
	
	my $response = $ua->get($home);
	
	if ($response->is_success) {
		return $response->decoded_content;  # or whatever
	}
	else {
		print "Internet problems again.. Could you check the router for me?\n";
		print $response->status_line;
	}
}

sub clean_array {
	my @array=@_;
	my @tempus=();
	for $n (@array) {
		if (length($n)>0) {
			if (grep(/$n/,@tempus)==0){push(@tempus,$n);}
		}
	}
	return sort(@tempus);
}

sub clean_hash {
	my %hash=%_;
	my %tempus=();
	for $n (keys %hash) {
		if (length($hash{$n})>0) {
			if (grep(/$n/,(keys %tempus))==0) {$tempus{$n}=$hash{$n};}
		}
	}
	return %tempus;
}

sub taken {
	$now = time - $start_time;
	$string=sprintf("%02d:%02d:%02d", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
	return $string;
}

sub projected {
	my ($percent)=@_;
	if ($percent>1) {$percent=$percent/100;} #the variable should be called fraction really...
	$now = (time - $start_time)/$percent;
	$string=sprintf("%02d:%02d:%02d", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
	return $string;
}

sub read_clp {
	my $data="ERROR";
	if ($os eq "MSWin32") {
		eval "use Win32::Clipboard;
		my $CLIP = Win32::Clipboard();
		$data=$CLIP->Get();";
		chomp($data);
	}
	elsif ($os eq "darwin") {
		open (FROM_CLIPBOARD, "pbpaste|");
		
		$data=<FROM_CLIPBOARD>;
		chomp($data);
		close (FROM_CLIPBOARD);
	}
	else {
		die "What is a $os?\n";
	}
	return $data;
}

sub write_clp {  
	my $content=$_[0];
	if ($_[1]) {$content=$_[1];} #static method
	if ($os eq "MSWin32") {
		eval "use Win32::Clipboard;
		my $CLIP = Win32::Clipboard();
		$CLIP->Set($content);";
		return ();
	}
	elsif ($os eq "darwin") {
		open (TO_CLIPBOARD, "|pbcopy");
		print TO_CLIPBOARD $content;
		close (TO_CLIPBOARD);
	}
	else {
		die "What is a $os?\n";
	}
}

sub clear {
	if ($os eq "MSWin32") {system("cls");}
	elsif ($os eq "darwin") {system("clear");}
	else {print "Could not clean the screen as I do not know what operating system $os is.\n";}
	
}

sub filegroup {
	#array of names, header to print in array (if a LoL it will print out a different array per file), type, mode) 
	my ($ref_name,$ref_header,$type,$mode,$ref_keys) = @_;
	@name=@$ref_name;
	@header=@$ref_header;
	my $looper="off";
	if ($type=~/[><]/) {my $temp=$mode; $mode=$type; $type=$temp;}
	if (($mode ne '>')||($mode ne '>>')||($mode ne '<')) {$mode='>';}
	if ($type=~/h/i) {
		@key=@$ref_keys;
		if (($#key<$#name)&&($#key>0)) {die "Smaller number of names for the files than files!\n\a";}
		if ($#key<0) {@key=@name;}
		
		if (ref($header[0]) eq "ARRAY") {$looper=0;}
		my %handle;
		foreach $n (0..$#name) {
			my $file=$name[$n];
			open my $file, '>', $file or die "Error with $file $!";
			if ($looper eq "off") {	print $file (join("\t",@header)); }
			else {print $file (join("\t",@{$header[$looper]})."\n"); $looper++;} 
			$handle{$key[$n]}=$file;
		}
		return %handle;
		
	} else {
		if (ref($header[0]) eq "ARRAY") {$looper=0;}
		my @handle;
		foreach $file (@name) {
			open my $file, '>', $file or die "Error with $file $!";
			if ($looper eq "off") {	print $file (join("\t",@header)); }
			else {print $file (join("\t",@{$header[$looper]})."\n"); $looper++;} 
			push (@handle, $file);
		}
		return @handle;
	}
}

1