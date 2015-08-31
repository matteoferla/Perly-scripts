my $dir='raw\ data/fasta/';
my @files=<$dir*>;
foreach (@files) {
	open (FILE,'<',$_) or print "bugger $file $!\n";
	my @data=<FILE>; close FILE;
	open (FILE,'>',$_) or print "bugger $file $!\n";
	foreach my $n (0..$#data) {if ($data[$n]!~/^\<[?!]/) {$data[$n]=~s/\<pre\>//g;$data[$n]=~s/\<\/pre\>//g; print FILE $data[$n];}}
	close FILE;
}
#<?xml version="1.0" encoding="utf-8"?>
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">