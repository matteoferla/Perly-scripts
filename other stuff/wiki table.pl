print "Hello\n\a";

$filein="table.txt";
$fileout="wikitabled.txt";
open(FILEOUT,">$fileout");
open(FILEIN,"$filein");
print FILEOUT "\{\| class\=\"wikitable sortable\"\n\|\-\n";
@foo=<FILEIN>;
print @foo+1;
$foo[0]="\!$foo[0]\|\-\n";
$foo[0]=~s/\t/ \!\! /;
print FILEOUT $foo[0];
shift(@foo);
foreach (@foo) {
s/\[\[/\[\[wikt\:/sg;
s/\t/\|\| /sg;
s/\n/\n\|\-\n\| /sg;
print FILEOUT $_;
}
print FILEOUT "\}";
