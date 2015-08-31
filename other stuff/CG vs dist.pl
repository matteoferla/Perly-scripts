use aacomp;   # call the core
use strict;
use warnings;
use constant N=>"\n";
use constant EXT=>'.txt';

settings->change('ask')=0; # Do not ask anything at all, just deal with it. ps. the depracated lvalue. 

for my $k (1..4) {
	my @tensor;
	my (@cogness,@phylum)=();
	foreach my $file (<allgenomes/*>) {
		next if $file eq 'info.txt';
		next if -d $file;
		next if $file eq 'inventory.txt';
		my $genome=genome->read($file);
		print "Genome retrieved ${\$genome->species()}\n";
		my $stats=$genome->halfstats(max=>$k,freq=>1,name=>$genome->species(),out=>'CG/genomes/'.$genome->species().' k'.$k.EXT);
		push(@tensor,$stats);
		my @details=genome->details($genome->species());
		$cogness[$#tensor]=int($details[6]*10); #there may be a blank in the midst.
		$phylum[$#tensor]=$details[4];
	}
	my $stack=matrix->regroup(\@tensor);
	my @todo=(0);
	@todo=(0,2,3) if $k>1;
	for my $m (@todo) {
		my $regrouped=$stack->[$m]; # a species per row not per table.
		my $dist=$regrouped->pdist('cosine',out=>'CG/dist '.$regrouped->name().' k'.$k.EXT); # get cosine distance on to it.
		
		my ($p_map,$keys)=sub::categories_to_numbers(@phylum);
		
		$dist->vector_from_col($dist->_find_col_index('Escherichia coli str. K-12 substr. DH10B'))
		->remap(\@cogness,$p_map,name=>'COG vs distance from E.coli',rowhead=>[map($_/10,0..999)],colhead=>$keys,out=>'CG/CG vs dist '.$regrouped->name().' k'.$k.EXT);
		# remap is similar to pivot table but does not do counts it assummes each value is unique, it just reassings the positions.
	}
}

exit;