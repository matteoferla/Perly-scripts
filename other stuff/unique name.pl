use sub;
my @table=sub::table(sub::readfile('names.txt'));
my %name;
foreach (@table) {$name{$_->[1]}++;}
open(FILE,'>name list.txt');
print FILE join("\n",sort keys %name);