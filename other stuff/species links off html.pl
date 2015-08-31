#a title="Neisseria meningitidis MC58" href=cogenome.cgi?g=122586>Nme</a>
open(OUT,'>out.txt') or die "bugger";
@line=<DATA>;
foreach $n (@line) {
BACK:
	if ($n=~ m/\<a title\=\"(.+?)\" href\=cogenome\.cgi\?g\=(\d+)\>(\w+)\<\/a\>/msg) {print OUT "$1\t$2\t$3\n"; $x++; goto BACK;}
}
print $x." done!\n";

__DATA__
<HTML> 
<HEAD> 
<title>COGs - Clusters of Orthologous Groups</title> 
    <meta name="author" content="Roman Tatusov"> 
    <meta name="keywords" content="national center for biotechnology information, ncbi, national library of medicine, nlm, national institutes of health, nih, COG, genome, cluster, bioinformatics, phylogeny"> 
    <meta name="description" content="Each COG (Cluster of Orthologous Groups of proteins) assembles the descendants from the same ancestor protein."> 
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
</HEAD> 
<BODY bgcolor="#fefefe"> 
<table border=1><tr><td colspan=3><table width=100% cellspacing=4><tr> 
<td rowspan=4 align = center><a href=/COG/><img border=0 src=gog.gif></a><br> 
<br><a href=wiew.cgi>List of COGs</a><br> 
<br><a href = ftp://ftp.ncbi.nih.gov/pub/COG/COG/>FTP</a><br> 
</td> 
<td rowspan=4 colspan=2></td> 
<td rowspan=4>192,987&nbsp;proteins<br> 
66&nbsp;genomes<br> 
38&nbsp;<i>orders</i><br> 
28&nbsp;<i>classes</i><br> 
14&nbsp;<i>phyla</i><br> 
3&nbsp;<i>kingdoms</i></td> 
<td rowspan=4 colspan=1></td><th><font size=+1><font color=purple size=+2>C</font>lusters of
<font color=purple size=+2>O</font>rthologous
<font color=purple size=+2>G</font>roups
</th><th></th> 
<td rowspan=4><table cellspacing=0 cellpadding=0> 
<tr><td><font size=-1><a href=fiew.cgi>Functional<br>categories</a></td></tr> 
<tr><td align=center> 
<table cellspacing=0 cellpadding=0> 
<tr><td bgcolor=#ffffff> 
<table cellspacing=1 cellpadding=3> 
<tr><td gbcolor=#ffffff><a title="Information starage and processing"><img height=4 width=100% src=onepixel.gif></td> 
<td gbcolor=#ffffff><a title="Cellular processes and signaling"><img height=4 width=100% src=onepixel.gif></td> 
<td gbcolor=#ffffff><a title="Metabolism"><img height=4 width=100% src=onepixel.gif></td> 
</tr> 
<tr><td bgcolor=#fcccfc><a title="Translation, ribosomal structure and biogenesis" href=wiew.cgi?fun=J><font size=-1>J</font></td> 
<td bgcolor=#fcfcdc><a title="Cell cycle control, cell division, chromosome partitioning" href=wiew.cgi?fun=D><font size=-1>D</font></td> 
<td bgcolor=#bcfcfc><a title="Energy production and conversion" href=wiew.cgi?fun=C><font size=-1>C</font></td> 
</tr> 
<tr><td bgcolor=#fcdcfc><a title="RNA processing and modification" href=wiew.cgi?fun=A><font size=-1>A</font></td> 
<td bgcolor=#fcfccc><a title="Nuclear structure" href=wiew.cgi?fun=Y><font size=-1>Y</font></td> 
<td bgcolor=#ccfcfc><a title="Carbohydrate transport and metabolism" href=wiew.cgi?fun=G><font size=-1>G</font></td> 
</tr> 
<tr><td bgcolor=#fcdcec><a title="Transcription" href=wiew.cgi?fun=K><font size=-1>K</font></td> 
<td bgcolor=#fcfcbc><a title="Defense mechanisms" href=wiew.cgi?fun=V><font size=-1>V</font></td> 
<td bgcolor=#dcfcfc><a title="Amino acid transport and metabolism" href=wiew.cgi?fun=E><font size=-1>E</font></td> 
</tr> 
<tr><td bgcolor=#fcdcdc><a title="Replication, recombination and repair" href=wiew.cgi?fun=L><font size=-1>L</font></td> 
<td bgcolor=#fcfcac><a title="Signal transduction mechanisms" href=wiew.cgi?fun=T><font size=-1>T</font></td> 
<td bgcolor=#dcecfc><a title="Nucleotide transport and metabolism" href=wiew.cgi?fun=F><font size=-1>F</font></td> 
</tr> 
<tr><td bgcolor=#fcdccc><a title="Chromatin structure and dynamics" href=wiew.cgi?fun=B><font size=-1>B</font></td> 
<td bgcolor=#ecfcac><a title="Cell wall/membrane/envelope biogenesis" href=wiew.cgi?fun=M><font size=-1>M</font></td> 
<td bgcolor=#dcdcfc><a title="Coenzyme transport and metabolism" href=wiew.cgi?fun=H><font size=-1>H</font></td> 
</tr> 
<tr><td bgcolor=#ffffff><a title="Poorly characterized"><img height=100% width=100% src=onepixel.gif></td> 
<td bgcolor=#dcfcac><a title="Cell motility" href=wiew.cgi?fun=N><font size=-1>N</font></td> 
<td bgcolor=#dcccfc><a title="Lipid transport and metabolism" href=wiew.cgi?fun=I><font size=-1>I</font></td> 
</tr> 
<tr><td bgcolor=#ffffff><a title="Poorly characterized"><img height=100% width=100% src=onepixel.gif></td> 
<td bgcolor=#ccfcac><a title="Cytoskeleton" href=wiew.cgi?fun=Z><font size=-1>Z</font></td> 
<td bgcolor=#ccccfc><a title="Inorganic ion transport and metabolism" href=wiew.cgi?fun=P><font size=-1>P</font></td> 
</tr> 
<tr><td bgcolor=#e0e0e0><a title="General function prediction only" href=wiew.cgi?fun=R><font size=-1>R</font></td> 
<td bgcolor=#bcfcac><a title="Extracellular structures" href=wiew.cgi?fun=W><font size=-1>W</font></td> 
<td bgcolor=#bcccfc><a title="Secondary metabolites biosynthesis, transport and catabolism" href=wiew.cgi?fun=Q><font size=-1>Q</font></td> 
</tr> 
<tr><td bgcolor=#cccccc><a title="Function unknown" href=wiew.cgi?fun=S><font size=-1>S</font></td> 
<td bgcolor=#acfcac><a title="Intracellular trafficking, secretion, and vesicular transport" href=wiew.cgi?fun=U><font size=-1>U</font></td> 
<td bgcolor=#9cfcac><a title="Posttranslational modification, protein turnover, chaperones" href=wiew.cgi?fun=O><font size=-1>O</font></td> 
</tr> 
</table></td> 
</tr></table> 
</td></tr></table> 
</td></tr> 
<tr><td colspan=2 align=center> 
  <table widteh=100% border=1 cellpadding=8> 
    <tr align=center><td bgcolor=#ddeeff> 
      <a href=http://www.ncbi.nlm.nih.gov:80/entrez/query.fcgi?cmd=Retrieve&db=PubMed&list_uids=9381173&dopt=Abstract><i>Science</i> 1997 Oct 24;278(5338):631-7</a>,<br> 
      <a href=http://www.ncbi.nlm.nih.gov:80/entrez/query.fcgi?cmd=Retrieve&db=PubMed&list_uids=12969510&dopt=Abstract><i>BMC Bioinformatics</i> 2003 Sep 11;4(1):41</a>.
    </td></tr> 
  </table> 
</td></tr> 
<tr><td><form method=get action=wiew.cgi><font color=green>Text search:</font> 
<input type=text name=txt></td></tr> 
<tr><td><table border=1><tr> 
<td bgcolor=#ffeeff><table cellpadding=0 cellspacing=1> 
<tr><th colspan=67 align=center><font color=#e07070><a href=diew.cgi>Distribution</a></font></td></tr> 
<tr><td><img width=3 height=10 src=onepixel.gif></td><td valign=bottom width=5><a href=wiew.cgi?k=1><img border=0 title="0 COGs" width=3 height=0 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=2><img border=0 title="0 COGs" width=3 height=0 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=3><img border=0 title="626 COGs" width=3 height=63 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=4><img border=0 title="389 COGs" width=3 height=39 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=5><img border=0 title="353 COGs" width=3 height=36 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=6><img border=0 title="279 COGs" width=3 height=28 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=7><img border=0 title="233 COGs" width=3 height=24 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=8><img border=0 title="242 COGs" width=3 height=25 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=9><img border=0 title="178 COGs" width=3 height=18 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=10><img border=0 title="154 COGs" width=3 height=16 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=11><img border=0 title="126 COGs" width=3 height=13 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=12><img border=0 title="126 COGs" width=3 height=13 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=13><img border=0 title="150 COGs" width=3 height=16 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=14><img border=0 title="96 COGs" width=3 height=10 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=15><img border=0 title="83 COGs" width=3 height=9 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=16><img border=0 title="125 COGs" width=3 height=13 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=17><img border=0 title="62 COGs" width=3 height=7 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=18><img border=0 title="69 COGs" width=3 height=7 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=19><img border=0 title="69 COGs" width=3 height=7 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=20><img border=0 title="62 COGs" width=3 height=7 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=21><img border=0 title="57 COGs" width=3 height=6 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=22><img border=0 title="54 COGs" width=3 height=6 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=23><img border=0 title="58 COGs" width=3 height=6 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=24><img border=0 title="61 COGs" width=3 height=7 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=25><img border=0 title="62 COGs" width=3 height=7 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=26><img border=0 title="45 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=27><img border=0 title="42 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=28><img border=0 title="29 COGs" width=3 height=3 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=29><img border=0 title="48 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=30><img border=0 title="43 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=31><img border=0 title="33 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=32><img border=0 title="32 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=33><img border=0 title="37 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=34><img border=0 title="39 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=35><img border=0 title="38 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=36><img border=0 title="32 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=37><img border=0 title="35 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=38><img border=0 title="34 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=39><img border=0 title="34 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=40><img border=0 title="28 COGs" width=3 height=3 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=41><img border=0 title="31 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=42><img border=0 title="38 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=43><img border=0 title="33 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=44><img border=0 title="39 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=45><img border=0 title="26 COGs" width=3 height=3 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=46><img border=0 title="34 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=47><img border=0 title="40 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=48><img border=0 title="43 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=49><img border=0 title="23 COGs" width=3 height=3 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=50><img border=0 title="45 COGs" width=3 height=5 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=51><img border=0 title="28 COGs" width=3 height=3 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=52><img border=0 title="32 COGs" width=3 height=4 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=53><img border=0 title="23 COGs" width=3 height=3 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=54><img border=0 title="18 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=55><img border=0 title="10 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=56><img border=0 title="13 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=57><img border=0 title="15 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=58><img border=0 title="11 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=59><img border=0 title="3 COGs" width=3 height=1 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=60><img border=0 title="1 COGs" width=3 height=1 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=61><img border=0 title="2 COGs" width=3 height=1 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=62><img border=0 title="9 COGs" width=3 height=1 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=63><img border=0 title="10 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=64><img border=0 title="7 COGs" width=3 height=1 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=65><img border=0 title="14 COGs" width=3 height=2 src=r.gif></a></td><td valign=bottom width=5><a href=wiew.cgi?k=66><img border=0 title="63 COGs" width=3 height=7 src=r.gif></a></td></tr><tr> 
<td colspan=10></td><td><font size=-2>1</font></td><td colspan=9></td><td><font size=-2>2</font></td><td colspan=9></td><td><font size=-2>3</font></td><td colspan=9></td><td><font size=-2>4</font></td><td colspan=9></td><td><font size=-2>5</font></td><td colspan=9></td><td><font size=-2>6</font></td><td colspan=6></td></tr><tr> 
<td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td><td align=right><font size=-2>7</font></td><td align=right><font size=-2>8</font></td><td align=right><font size=-2>9</font></td><td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td><td align=right><font size=-2>7</font></td><td align=right><font size=-2>8</font></td><td align=right><font size=-2>9</font></td><td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td><td align=right><font size=-2>7</font></td><td align=right><font size=-2>8</font></td><td align=right><font size=-2>9</font></td><td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td><td align=right><font size=-2>7</font></td><td align=right><font size=-2>8</font></td><td align=right><font size=-2>9</font></td><td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td><td align=right><font size=-2>7</font></td><td align=right><font size=-2>8</font></td><td align=right><font size=-2>9</font></td><td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td><td align=right><font size=-2>7</font></td><td align=right><font size=-2>8</font></td><td align=right><font size=-2>9</font></td><td align=right><font size=-2>0</font></td><td align=right><font size=-2>1</font></td><td align=right><font size=-2>2</font></td><td align=right><font size=-2>3</font></td><td align=right><font size=-2>4</font></td><td align=right><font size=-2>5</font></td><td align=right><font size=-2>6</font></td></tr> 
</table></td> 
</tr></table> 
</td></tr></table> 
</td> 
</tr><tr> 
<td bgcolor=#eeeeff valign=top> 
<table width=100% cellpadding=1 cellspacing=0 border=0> 
<tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Euryarchaeota</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2158 title="Methanobacteria">Methanobacteriales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Methanothermobacter thermautotrophicus" href=cogenome.cgi?g=145262>Mth</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2182 title="Methanococci">Methanococcales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Methanococcus jannaschii" href=cogenome.cgi?g=2190>Mja</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=94695 title="Methanomicrobia">Methanosarcinales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Methanosarcina acetivorans str.C2A" href=cogenome.cgi?g=188937>Mac</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2235 title="Halobacteria">Halobacteriales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Halobacterium sp. NRC-1" href=cogenome.cgi?g=64091>Hbs</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2301 title="Thermoplasmata">Thermoplasmatales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Thermoplasma acidophilum" href=cogenome.cgi?g=2303>Tac</a>&nbsp;<a title="Thermoplasma volcanium" href=cogenome.cgi?g=50339>Tvo</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2258 title="Thermococci">Thermococcales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Pyrococcus horikoshii" href=cogenome.cgi?g=29292>Pho</a>&nbsp;<a title="Pyrococcus abyssi" href=cogenome.cgi?g=53953>Pab</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2231 title="Archaeoglobi">Archaeoglobales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Archaeoglobus fulgidus" href=cogenome.cgi?g=2234>Afu</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=68985 title="Methanopyri">Methanopyrales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Methanopyrus kandleri AV19" href=cogenome.cgi?g=190192>Mka</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Crenarchaeota</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2266 title="Thermoprotei">Thermoproteales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Pyrobaculum aerophilum" href=cogenome.cgi?g=13773>Pya</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2281 title="Thermoprotei">Sulfolobales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Sulfolobus solfataricus" href=cogenome.cgi?g=2287>Sso</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=114380 title="Thermoprotei">Desulfurococcales</a></font>&nbsp;</td><td bgcolor=#fcee85><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Aeropyrum pernix" href=cogenome.cgi?g=56636>Ape</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeeeff><font color=#11aaaa size=-1><i>Ascomycota</i></font></td></tr><tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=4892 title="Saccharomycetes">Saccharomycetales</a></font>&nbsp;</td><td bgcolor=#ffbcff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Saccharomyces cerevisiae" href=cogenome.cgi?g=4932>Sce</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=34346 title="Schizosaccharomycetes">Schizosaccharomycetales</a></font>&nbsp;</td><td bgcolor=#ffbcff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Schizosaccharomyces pombe" href=cogenome.cgi?g=4896>Spo</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeeeff><font color=#11aaaa size=-1><i>Microsporidia</i></font></td></tr><tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=6032 title="Microsporidia">Apansporoblastina</a></font>&nbsp;</td><td bgcolor=#ffbcff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Encephalitozoon_cuniculi" href=cogenome.cgi?g=6035>Ecu</a></td></tr> 
</table></td> 
<td bgcolor=#eeeeff valign=top> 
<table width=100% cellpadding=1 cellspacing=0 border=0> 
<tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Aquificae</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=32069 title="Aquificae (class)">Aquificales</a></font>&nbsp;</td><td bgcolor=#7aff7a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Aquifex aeolicus" href=cogenome.cgi?g=63363>Aae</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeeeff><font color=#11aaaa size=-1><i>Thermotogae</i></font></td></tr><tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2419 title="Thermotogae (class)">Thermotogales</a></font>&nbsp;</td><td bgcolor=#7aff7a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Thermotoga maritima" href=cogenome.cgi?g=2336>Tma</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Cyanobacteria</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=1161 title="Nostocali">Nostocales</a></font>&nbsp;</td><td bgcolor=#7aff7a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Nostoc sp. PCC 7120" href=cogenome.cgi?g=103690>Nos</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=1118 title="Chroococcali">Chroococcales</a></font>&nbsp;</td><td bgcolor=#7aff7a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Synechocystis" href=cogenome.cgi?g=1148>Syn</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Deinococcus-Thermus</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=118964 title="Deinococci">Deinococcales</a></font>&nbsp;</td><td bgcolor=#7aff7a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Deinococcus radiodurans" href=cogenome.cgi?g=1299>Dra</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeeeff><font color=#11aaaa size=-1><i>Fusobacteria</i></font></td></tr><tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=203491 title="Fusobacteria (class)">Fusobacterales</a></font>&nbsp;</td><td bgcolor=#7aff7a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Fusobacterium nucleatum" href=cogenome.cgi?g=190304>Fnu</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Chlamydiae</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=51291 title="Chlamydiae (class)">Chlamydiales</a></font>&nbsp;</td><td bgcolor=#fcc485><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Chlamydia trachomatis" href=cogenome.cgi?g=813>Ctr</a>&nbsp;<a title="Chlamydophila pneumoniae CWL029" href=cogenome.cgi?g=115713>Cpn</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeeeff><font color=#11aaaa size=-1><i>Spirochaetes</i></font></td></tr><tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=136 title="Spirochaetes (class)">Spirochaetales</a></font>&nbsp;</td><td bgcolor=#fcc485><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Treponema pallidum" href=cogenome.cgi?g=160>Tpa</a>&nbsp;<a title="Borrelia burgdorferi" href=cogenome.cgi?g=139>Bbu</a></td></tr> 
</table></td> 
<td bgcolor=#eeeeff valign=top> 
<table width=100% cellpadding=1 cellspacing=0 border=0> 
<tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Actinobacteria</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2037 title="Actinobacteria (class)">Actinomycetales</a></font>&nbsp;</td><td bgcolor=#7ae07a><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Corynebacterium glutamicum" href=cogenome.cgi?g=1718>Cgl</a>&nbsp;<a title="Mycobacterium tuberculosis H37Rv" href=cogenome.cgi?g=83332>Mtu</a>&nbsp;<a title="Mycobacterium tuberculosis CDC1551" href=cogenome.cgi?g=83331>MtC</a>&nbsp;<a title="Mycobacterium leprae" href=cogenome.cgi?g=1769>Mle</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeeeff><font color=#11aaaa size=-1><i>Firmicutes</i></font></td></tr><tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=186802 title="Clostridia">Clostridiales</a></font>&nbsp;</td><td bgcolor=#e0e0bd><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Clostridium acetobutylicum" href=cogenome.cgi?g=1488>Cac</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=1385 title="Bacilli">Bacillales</a></font>&nbsp;</td><td bgcolor=#e0e0bd><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Staphylococcus aureus N315" href=cogenome.cgi?g=158879>Sau</a>&nbsp;<a title="Listeria innocua" href=cogenome.cgi?g=1642>Lin</a>&nbsp;<a title="Bacillus subtilis" href=cogenome.cgi?g=1423>Bsu</a>&nbsp;<a title="Bacillus halodurans" href=cogenome.cgi?g=86665>Bha</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=186826 title="Bacilli">Lactobacillales</a></font>&nbsp;</td><td bgcolor=#e0e0bd><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Lactococcus lactis" href=cogenome.cgi?g=1360>Lla</a>&nbsp;<a title="Streptococcus pyogenes M1 GAS" href=cogenome.cgi?g=160490>Spy</a>&nbsp;<a title="Streptococcus pneumoniae TIGR4" href=cogenome.cgi?g=170187>Spn</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=2085 title="Mollicutes">Mycoplasmatales</a></font>&nbsp;</td><td bgcolor=#fca185><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Ureaplasma urealyticum" href=cogenome.cgi?g=2130>Uur</a>&nbsp;<a title="Mycoplasma pulmonis" href=cogenome.cgi?g=2107>Mpu</a>&nbsp;<a title="Mycoplasma pneumoniae" href=cogenome.cgi?g=2104>Mpn</a>&nbsp;<a title="Mycoplasma genitalium" href=cogenome.cgi?g=2097>Mge</a></td></tr> 
<tr><td colspan=3 bgcolor=#eeffff><hr></td></tr><tr><td colspan=3 align=center bgcolor=#eeffff><font color=#11aaaa size=-1><i>Proteobacteria</i></font></td></tr><tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=72274 title="Gammaproteobacteria">Pseudomonadales</a></font>&nbsp;</td><td bgcolor=#9ddada><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Pseudomonas aeruginosa" href=cogenome.cgi?g=287>Pae</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=91347 title="Gammaproteobacteria">Enterobacteriales</a></font>&nbsp;</td><td bgcolor=#9ddada><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Escherichia coli K12" href=cogenome.cgi?g=83333>Eco</a>&nbsp;<a title="Escherichia coli O157:H7 EDL933" href=cogenome.cgi?g=155864>EcZ</a>&nbsp;<a title="Escherichia coli O157:H7" href=cogenome.cgi?g=83334>Ecs</a>&nbsp;<a title="Yersinia pestis" href=cogenome.cgi?g=632>Ype</a>&nbsp;<a title="Salmonella typhimurium LT2" href=cogenome.cgi?g=99287>Sty</a>&nbsp;<a title="Buchnera sp. APS" href=cogenome.cgi?g=107806>Buc</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=135614 title="Gammaproteobacteria">Xanthomonadales</a></font>&nbsp;</td><td bgcolor=#9ddada><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Xylella fastidiosa 9a5c" href=cogenome.cgi?g=160492>Xfa</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=135623 title="Gammaproteobacteria">Vibrionales</a></font>&nbsp;</td><td bgcolor=#9ddada><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Vibrio cholerae" href=cogenome.cgi?g=666>Vch</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=135625 title="Gammaproteobacteria">Pasteurellales</a></font>&nbsp;</td><td bgcolor=#9ddada><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Haemophilus influenzae" href=cogenome.cgi?g=71421>Hin</a>&nbsp;<a title="Pasteurella multocida" href=cogenome.cgi?g=747>Pmu</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=80840 title="Betaproteobacteria">Burkholderiales</a></font>&nbsp;</td><td bgcolor=#7abcff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Ralstonia solanacearum" href=cogenome.cgi?g=305>Rso</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=206351 title="Betaproteobacteria">Neisseriales</a></font>&nbsp;</td><td bgcolor=#7abcff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Neisseria meningitidis MC58" href=cogenome.cgi?g=122586>Nme</a>&nbsp;<a title="Neisseria meningitidis Z2491" href=cogenome.cgi?g=122587>NmA</a></td></tr> 
<tr><td bgcolor=#eeffff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=213849 title="Epsilonproteobacteria">Campylobacterales</a></font>&nbsp;</td><td bgcolor=#7abcff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeffff> 
&nbsp;<a title="Helicobacter pylori 26695" href=cogenome.cgi?g=85962>Hpy</a>&nbsp;<a title="Helicobacter pylori J99" href=cogenome.cgi?g=85963>jHp</a>&nbsp;<a title="Campylobacter jejuni" href=cogenome.cgi?g=197>Cje</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=204458 title="Alphaproteobacteria">Caulobacterales</a></font>&nbsp;</td><td bgcolor=#7a9bff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Caulobacter vibrioides" href=cogenome.cgi?g=155892>Ccr</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=356 title="Alphaproteobacteria">Rhizobiales</a></font>&nbsp;</td><td bgcolor=#7a9bff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Agrobacterium tumefaciens strain C58 (Cereon)" href=cogenome.cgi?g=181661>Atu</a>&nbsp;<a title="Sinorhizobium meliloti" href=cogenome.cgi?g=382>Sme</a>&nbsp;<a title="Brucella melitensis" href=cogenome.cgi?g=29459>Bme</a>&nbsp;<a title="Mesorhizobium loti" href=cogenome.cgi?g=381>Mlo</a></td></tr> 
<tr><td bgcolor=#eeeeff> 
<font size=-1><a href=http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=info&id=766 title="Alphaproteobacteria">Rickettsiales</a></font>&nbsp;</td><td bgcolor=#7a9bff><img width=1 src=onepixel.gif> 
</td><td bgcolor=#eeeeff> 
&nbsp;<a title="Rickettsia prowazekii" href=cogenome.cgi?g=782>Rpr</a>&nbsp;<a title="Rickettsia conorii" href=cogenome.cgi?g=781>Rco</a></td></tr> 
</table></td> 
</tr></table></td> 
</tr></table> 
 
<br><hr> 
  Comments and questions to
  <A HREF="mailto:info@ncbi.nlm.nih.gov">info@ncbi.nlm.nih.gov</A> or to the <A HREF="mailto:tatusov@ncbi.nlm.nih.gov">Author</a> 
 
</BODY> 
</HTML> 