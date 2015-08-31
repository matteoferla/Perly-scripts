#!/usr/bin/perl
$dir=$ARGV[0];
my @files=();
system("clear");
while (<$dir*>) 
{
    push (@files,$_) if (-f "$_");
}
print "There are ".($#files+1)." files\n";
@handles=filegroup(\@files,[()]);

foreach (@handles) {
	@stuff=<$_>;
	$lines=$#stuff+1;
	$char=0;
	foreach $item (@stuff) {$char+=length($item);}
	print "File $files[$x] has $lines lines and $char characters\n";
	$x++;
} 


sub filegroup {
	my ($ref_name,$ref_header) = @_;
	@name=@$ref_name;
	@header=@$ref_header;
	my $looper="off";
	if (ref($header[0]) eq "ARRAY") {$looper=0;}
	my @handle;
	foreach $file (@name) {
		open my $file, '<', $file or die "Error $file $!";
		#if ($looper eq "off") {	print $file ("org\t".join("\t",@header)); }
		#else {print $file ("org\t".join("\t",@{$header[$looper]})."\n"); $looper++;} 
		push (@handle, $file);
	}
	return @handle;
}