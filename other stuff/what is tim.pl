use strict;
use warnings;
#use LWP::UserAgent;


#print join("\n",grep(!/</,(sub::download('http://scop.mrc-lmb.cam.ac.uk/scop/data/scop.b.d.b.A.html')=~ m/<a href.*?>(.*?)<\/a>/smgi)));

my @id;
push(@id,m/\(PF(\d+)\)/gi) foreach <DATA>;
#print join("\n",map('PF'.$_,@id));




__DATA__

The table below shows the number of occurrences of each domain throughout the sequence database. More...

Pfam family	Num. domains	Alignment
AP_endonuc_2 (PF01261)	5878 (6.5%)	View
HMGL-like (PF00682)	4892 (5.4%)	View
Ala_racemase_N (PF01168)	4341 (4.8%)	View
Orn_Arg_deC_N (PF02784)	4182 (4.7%)	View
Oxidored_FMN (PF00724)	4066 (4.5%)	View
DHDPS (PF00701)	3723 (4.1%)	View
Dus (PF01207)	3291 (3.7%)	View
Pterin_bind (PF00809)	3215 (3.6%)	View
TIM (PF00121)	3141 (3.5%)	View
DAHP_synth_1 (PF00793)	3126 (3.5%)	View
His_biosynth (PF00977)	2962 (3.3%)	View
IMPDH (PF00478)	2490 (2.8%)	View
DeoC (PF01791)	2439 (2.7%)	View
F_bP_aldolase (PF01116)	2363 (2.6%)	View
OMPdecase (PF00215)	2318 (2.6%)	View
NPD (PF03060)	2290 (2.5%)	View
Transaldolase (PF00923)	2283 (2.5%)	View
DHO_dh (PF01180)	2283 (2.5%)	View
FMN_dh (PF01070)	2255 (2.5%)	View
Glu_synthase (PF01645)	2153 (2.4%)	View
IGPS (PF00218)	2141 (2.4%)	View
TMP-TENI (PF02581)	2058 (2.3%)	View
Ribul_P_3_epim (PF00834)	1995 (2.2%)	View
Trp_syntA (PF00290)	1599 (1.8%)	View
NAPRTase (PF04095)	1522 (1.7%)	View
ALAD (PF00490)	1510 (1.7%)	View
QRPTase_C (PF01729)	1510 (1.7%)	View
PRAI (PF00697)	1427 (1.6%)	View
continued
Pfam family	Num. domains	Alignment
Aldolase (PF01081)	1351 (1.5%)	View
Glu_syn_central (PF04898)	1313 (1.5%)	View
ThiG (PF05690)	1076 (1.2%)	View
iPGM_N (PF06415)	1046 (1.2%)	View
PdxJ (PF03740)	820 (0.9%)	View
CutC (PF03932)	706 (0.8%)	View
SOR_SNZ (PF01680)	663 (0.7%)	View
DHquinase_I (PF01487)	655 (0.7%)	View
NeuB (PF03102)	635 (0.7%)	View
NanE (PF04131)	550 (0.6%)	View
UxuA (PF03786)	471 (0.5%)	View
DUF692 (PF05114)	406 (0.5%)	View
G3P_antiterm (PF04309)	368 (0.4%)	View
Tagatose_6_P_K (PF08013)	294 (0.3%)	View
UvdE (PF03851)	292 (0.3%)	View
PhosphMutase (PF10143)	253 (0.3%)	View
PcrB (PF01884)	252 (0.3%)	View
RhaA (PF06134)	216 (0.2%)	View
BtpA (PF03437)	210 (0.2%)	View
DUF1341 (PF07071)	198 (0.2%)	View
TIM-br_sig_trns (PF09370)	187 (0.2%)	View
CdhD (PF03599)	129 (0.1%)	View
DUF993 (PF06187)	80 (0.1%)	View
DUF561 (PF04481)	75 (0.1%)	View
DUF556 (PF04476)	75 (0.1%)	View
MtrH (PF02007)	48 (0.1%)	View
Total: 54	Total: 89822	 Clan alignment
