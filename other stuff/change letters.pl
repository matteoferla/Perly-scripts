#!/usr/bin/perl

use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant A=>"\a";
my $os = $^O;


print 'This Script changes the the string stored in the clipboard from one encoding to another'.N;
my @from=pick_encoding('source');
my @to=pick_encoding('result');
print 'Add spaces/delimitor between elements? simply press enter if not or type the delimitor followed by enter'; my $del=<>; chomp($del);
my $data=read_clp();
$data=~s/@from/@to/;

$data=~s/$from[$_]/\(\!$_\!\)/msgi for (0..$#from);
if ($del) {
	$data=~s/\(\!$_\!\)/$del$to[$_]$del/g for (0..$#from);
	$data=~s/$del+/$del/g;
	$data=~s/^$del//g;
	$del=~s/$del$//g;
} else {$data=~s/\(\!$_\!\)/$to[$_]/g for (0..$#from)}

write_clp($data);
print 'String in clipboard changed'.N.A;

exit;

sub pick_encoding {
	my @abc_set=([('A'..'Z')],[qw(Ala Asx Cys Asp Glu Phe Gly His Ile Xle Lys Leu Met Asn Pyl Pro Gln Arg Ser Thr Sec Val Trp Xaa Tyr Glx)],[qw(Alanine Asparagine_or_aspartic_acid Cysteine Aspartic_acid Glutamic_acid Phenylalanine Glycine Histidine Isoleucine Leucine_or_Isoleucine Lysine Leucine Methionine Asparagine Pyrrolysine Proline Glutamine Arginine Serine Threonine Selenocysteine Valine Tryptophan Unspecified_or_unknown_amino_acid Tyrosine Glutamine_or_glutamic_acid)]);
	print 'Specify '.shift(@_).':'.N.T.'0 single letter'.N.T.'1 three letter'.N.T.'2 words'.N;
	my $input=<>;
	chomp($input);
	return (@{$abc_set[$input]});
}



sub read_clp {
	my $data="ERROR";
	if ($os eq "MSWin32") {
		eval 'use Win32::Clipboard;
		my $CLIP = Win32::Clipboard();
		$data=$CLIP->Get();';
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
		die "What is a $os?\n";
	}
}