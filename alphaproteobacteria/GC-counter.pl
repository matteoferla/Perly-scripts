use strict;
use warnings;
use constant N=>"\n";
use constant T=>"\t";

####################################################################
###### Subs ########################################################
####################################################################

sub in {
	open FILE,$_[0] or die 'could not open '.$_[0].N;
	my @array=<FILE>;
	@array=split(/\r/,$array[0]) if ! $#array;
	close FILE;
	chomp(@array);
	return @array;
}

sub dehyphenate {
	foreach (@_) {s/\-//gi if !/>/;}
	return @_;
}

sub count {
	my $seq=shift;
	$seq=~ s/\W//g;
	my $l=length($seq)-($seq =~ tr/Nn/Nn/);
	print "A pack of vicious and voracious wildcards was attacked the script. If it died it means one species had only wild cards\n" if ($seq=~/N/);
	my $cg=($seq =~ tr/GgCc/GgCc/);
	return int($cg/$l*1000)/10;
}

sub write_clp {  
	my $content=$_[0];
	my $os=$^O;
	if ($_[1]) {$content=$_[1];} #static method
	if ($os eq "MSWin32") {
		eval 'use Win32::Clipboard;
		my $CLIP = Win32::Clipboard();
		$CLIP->Set($content);';
		return ();
	}
	elsif ($os eq "darwin") {
		open (TO_CLIPBOARD, "|pbcopy");
		print TO_CLIPBOARD $content;
		close (TO_CLIPBOARD);
	}
	else {
		die "CRASH! What kind of a man uses a $os?!\n";
	}
}

sub ask_yn {
	my ($default)=@_;
	if ($default==1) {print 'option >Y< / N :'.T;}
	else {print 'option Y / >N< :'.T;}
	my $input=<STDIN>;
	chomp($input);
	if ($input=~ /[QE]/i) {die 'User request to quit'.N;} 
	elsif ($input=~ /[YS]/i) {return 1;} #S as in Si. Not really needed
	elsif ($input=~ /N/i) {return 0;}
	else {return $default;}
}
	
	
####################################################################
###### Main ########################################################
####################################################################

print "Kia ora\n";
die "CRASH! Add the name of the fasta file to be analysed as the first argument.\n" if ! $ARGV[0];
#print "I have no added for the contigency of gaps: remove them beforehand!".N;
my $key="ERROR";
my %seq=();
foreach (in($ARGV[0])) {
	if (/>(.*)/) {$key=$1; $seq{$key}='';}
	else {$seq{$key}.=$_}
}

my $output='';
$output.=$_.T.count($seq{$_}).'%'.N foreach sort keys %seq;

print "Shall I print it in a file? (if not, I'll just put it in your clipboard)\n";
if (ask_yn(0))
{print "Creating file called $ARGV[0].CG.txt\n"; open(SESAME,">$ARGV[0].CG.txt"); print SESAME $output; close SESAME;}
else {write_clp($output)}


print "\nHaere mai\n\a";
exit;