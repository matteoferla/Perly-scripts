use sub;

my %keychain;
my @line=sub::readfile('in.txt');
foreach (@line) {my @tab=split(/\t/); foreach my $n (@tab) {$keychain{$n}++;}}
$file=">out.txt";
open(FILE,$file) or die "$file: $!\n";
foreach (sort (keys %keychain)) {print FILE "$_\t$keychain{$_}\n";}


