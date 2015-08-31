#!/usr/bin/perl
use lib::sub;
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';
sub::clear;




my $max_names=50;

#my $ref_p=markov_name_train('all genomes/inventory.txt',1);
my $ref_p=markov_name_train('protein list.txt',2);
for my $m (1..$max_names) {
	print markov_name_gen($ref_p,6,40,2).N;
} 



sub markov_name_train {
	my $file=shift;
	my $filter=shift;
	my @lines=sub::table(sub::readfile($file));
	my @fullabc=("A".."Z");
	push(@fullabc,'_');
	my @names=map($lines[$_][0],0..$#lines);
	shift @names;
	my %prob;
	my $total=0;
	foreach (@names) {
		
		if ($filter==1) {if (m/^(\w+) (\w+)/) {$_='_'.$1.'_'.$2.'_';} elsif (m/^(\w+)/) {$_='_'.$1.'_';}}
		elsif ($filter==2) {$_='_'.$_.'_'; s/\_\w{0,4}\_/\_/g;}
		s/\s+/\_/g;
		s/[\d\W]//g;
		$total++;
		$_=lc($_);
		my @temp=split //;
		for my $i (0..($#temp-2)) {$prob{$temp[$i]}{$temp[$i+1]}++;$prob{$temp[$i].$temp[$i+1]}{$temp[$i+2]}++;}
	}
	return \%prob;
}

sub markov_name_gen {
	my ($prob,$min_len, $max_len,$words)=@_;
	my @abc=(sort keys %$prob);
	my $new='_';
	my $string=$new;
	my $len=0;
	my $counter=0;
	while ($counter<$words) {
		my @loc_prob=map($prob->{$new}{$_},@abc);
		my $t=0;
		foreach my $l (0..$#abc) {if ($prob->{$new}{$abc[$l]}) {$loc_prob[$l]=$prob->{$new}{$abc[$l]}; $t+=$loc_prob[$l];} else {$loc_prob[$l]=0;}}
		if ($t==0) {
			print "$new of $string has no following".N; return markov_name_gen($prob,$min_len, $max_len);
		}
		else {
			foreach my $l (0..$#abc) {$loc_prob[$l]=$loc_prob[$l]/$t;}
			$new=$abc[wrand(\@loc_prob)];
			if ($len>=$max_len) {$len=0;$string.='_';$counter++;}
			elsif (($new ne '_')) {$len++;$string.=$new;}
			elsif (($new eq '_')&&($len>=$min_len)) {$len=0;$string.=$new;$counter++;}
		}
		if ((length($string)==1)||(substr($string,-1,1) eq '_')) {$new=substr($string,-1,1);} else {$new=substr($string,-2,2)};
	}
	$string=~s/^\_//g;
	$string=~s/\_$//g;
	$string=~s/\_/ /g;
	
	return uc(substr($string,0,1)).substr($string,1);
}


sub wrand {
	my @weight=@{$_[0]};
	my $x=rand();
	my $n=-1;
	while (($x>0)&&($n<$#weight)) {$n++; $x-=$weight[$n];}
	return $n;
}