#! /usr/bin/perl

print "hello World\b\b\b\n";

require LWP::UserAgent;
require 'subs.pl';
$n=2;
@x=map { 0} (0..25);
$x[3]=1;
@p=map { 0} (0..19);
$p[3]=0.1;
$m=multi(\@x, $n, \@p);
print "this is perl's maths: $m \n";
end;