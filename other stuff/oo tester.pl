use sub;
use tree;
sub::clear;

#my $tree=tree->new('((Alice,Bob),((Dave,Eve),Charlie,((Isaac,Fran),Gordon)))');
print "\n";
my $tree=tree->star();
$tree->describe;
$tree->split_poly(4,7);
#$tree->check;
#print 'description...'."\n\n\n";
$tree->describe;