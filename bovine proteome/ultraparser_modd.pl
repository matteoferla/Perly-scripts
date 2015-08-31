use strict;
use warnings;
use constant N=>"\n";
use constant T=>"\t";
use Spreadsheet::WriteExcel;

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

sub cache_blast {
	my @ref=('Query','Subject','ident', 'total_match_length','no_idea1','no_idea2','query_start','Query_end','Subject_start','Subject_end','Evalue','bit_score'); 
	my @hit=({map{$_=>''}(@ref)}); # just in case!
	foreach my $line (in($_[0])) {
		my @temp=split(/\t/,$line);
		my %match=map{$ref[$_]=>$temp[$_]}(0..$#ref);
		#print $tab[0].N; exit;
		#push(@hit,[@tab]) if ($hit[-1]->[0] ne $tab[0]);
		#$hit[-1]=[@tab] if ($tab[11]>$hit[-1]->[11]);
		push(@hit,\%match) if ($hit[-1]{Query} ne $match{Query}); # new query reset.
		$hit[-1]=\%match if ($match{bit_score}>$hit[-1]{bit_score});
	}
	return \@hit;
}

sub table {  #abandonned.
	my $data=shift;
	my $query_animal=shift;
	my $sub_animal=shift;
	my $line=shift;
	my $field=shift;
	if ($_[0]) {}
	else {}
}

####################################################################
###### Main ########################################################
####################################################################

system("clear");
print "Kia ora\n";

my @farm=qw(first second ovine bovine);
#my @farm=qw(bovine);
my @primary=('Query', 'ori_gene', 'human_gene', 'alt_ID', 'Seq');
my @secondary=('Subject', 'Subject_ori_gene','Subject_human_gene','ident', 'total_match_length','bit_score', 'direction_check', 'duplicate','no_idea1','no_idea2','query_start','Query_end','Subject_start','Subject_end','Evalue');
my @ref=(@primary,@secondary);

my $cutoff=65;

my %data=();

# load data ######################################################
foreach my $query_animal (@farm) {
	foreach my $sub_animal ('ref') {
		if ($query_animal ne $sub_animal) {
			my $match=$query_animal."_".$sub_animal;
			$data{$query_animal}->{$sub_animal}=cache_blast($match);
			print 'loaded '.$match.N;
		}
	}
}

# xref human ######################################################
my @humanref=();
push(@humanref,[split("\t",$_)]) foreach (in('bovine_genes.txt'));

#print "here\n";
foreach my $query_animal (@farm) {
	#print $query_animal.N;
	foreach my $l (1..$#{$data{$query_animal}{ref}}) {
		#print $query_animal.T.$gene.N;
		if ($data{$query_animal}{ref}[$l]{Subject} =~ m/(\wP_\w+)/) {
			my $temp=$1;
			my ($match)=grep($_->[0]=~ /$temp/,@humanref);
			$data{$query_animal}{$_}[$l]{human_gene}=$match->[1] foreach ('ref');
		}
		else {print "UNMATCHED ".($data{$query_animal}{ref}[$l]{human_gene}).N}
		#gi|91823271|ref|NP_000370.2|
	}
}

# fecth gene symbol ######################################################
#DELETED


# check if matches both ways ######################################################
#DELETED



# Flag repeats ######################################################
foreach my $query_animal (@farm) {
	foreach my $sub_animal ('ref') {
		if ($query_animal ne $sub_animal) {
			my @list=map($_->{Subject},@{$data{$query_animal}{$sub_animal}});
			my %seen;
			$seen{$_}++ foreach (@list);
			foreach my $gene (keys %seen) {
				next unless $seen{$gene}>1;
				my @indices= grep { $list[$_] eq $gene } 0..$#list;
				#print "In $query_animal, the $sub_animal gene $gene was matched ".($#indices+1)." times (".join(', ', @indices).").\n";
				my @id=map($data{$query_animal}{$sub_animal}[$_]{ident},@indices);
				my $max;
				foreach my $i (@indices) {$data{$query_animal}{$sub_animal}[$i]{duplicate}='More_distant';}
				for (0..$#id) {$max = $_ if (!$max || $id[$_] > $max)}
				$data{$query_animal}{$sub_animal}[$max]{duplicate}='Closest';
			}
		}
	}
}

# write Excel ######################################################
my $workbook = Spreadsheet::WriteExcel->new('parsed.xls');

foreach my $query_animal (@farm) {
	# Add a worksheet
	my $worksheet = $workbook->add_worksheet($query_animal);
	#add header
	my $y=0;
	$worksheet->write(0,$_, $primary[$_]) for (0..$#primary);
	$y+=$#primary+1;
	foreach my $sub_animal ('ref') {
		next if ($query_animal eq $sub_animal);
		$worksheet->write(0,$y, $sub_animal); $y+=1;
		$worksheet->write(0,$_+$y, $secondary[$_]) for (0..$#secondary);
		$y+=($#secondary+2);
	}
	#add data
	foreach my $l (1..$#{$data{$query_animal}{ref}}) {  #they all have the same genes.
		my $x=0;
		$worksheet->write($l,$_, $data{$query_animal}{ref}[$l]{$primary[$_]}) for (0..$#primary);
		$x+=$#primary+1;
		foreach my $sub_animal ('ref') {
			next if ($query_animal eq $sub_animal);
			$worksheet->write($l,$x,$sub_animal);
			$worksheet->write($l,$_+$x+1, $data{$query_animal}{$sub_animal}[$l]{$secondary[$_]}) for (0..$#secondary);
			$x+=($#secondary+3);
		}
	}
}
$workbook->close();

# Extra… ######################################################
#so lazy!
foreach my $query_animal (@farm) {
	open(TEMP,'>gene_'.$query_animal.'.txt');
	print TEMP $data{$query_animal}{ref}[$_]{human_gene}.N foreach (0..$#{$data{$query_animal}{ref}});
	close TEMP;
}

# say Goodbye ######################################################
print "\nHaere mai\n\a";
exit;


# JUNK ######################################################
__END__




