#!/usr/bin/perl

use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';

open(LOG,'>','sub analysis.txt');
my @files;
if ($ARGV[0]) {print 'Target given:'.$ARGV[0].N; if (-d $ARGV[0]) {push(@files,<$ARGV[0]/*>);} else {my @files=($ARGV[0])}} else {@files=<*>; foreach (@files){if (-d) {push(@files,<$_/*>);}}}

foreach (@files) {print LOG spot_em($_).N;}





sub spot_em {
	my $file=shift;
	open(my $handle,'<',$file) or return 0;
	my @subs=split(/CUT HEREsub /,join('CUT HERE',<$handle>));
	my $detail;
	foreach (@subs) {
		if (/(.*?) \{/) {$detail.=N.T.$1;
			if (/my(.*?)\=\@_\;/) {$detail.=' <<'.$1;} elsif (/my (.*?)\=shift\;/) {$detail.=' <<'.$1;}
			if (/return(.*?)\;/) {$detail.=' >>'.$1;}
		}
	}
	close $handle;
		return $file.' contains'.$detail;
}




#return N.'The file '.$file.' contains the following subs...'.N;.N.join(T.N,(join(N,<$handle>)=~ m/^sub (.*?) \{/smgi)).N;






