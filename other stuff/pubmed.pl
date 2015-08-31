#!/usr/bin/perl

use utf8;




############################################################################################################
################SETTINGS##########################################################################################
############################################################################################################
my @terms=qw(novel speculat improv revolution therefore hypothes theor possib socks contrary);
my $query ="bioremediation";
## " in HTML is %22
############################################################################################################
################# for simple word list see bottom of code ###########################################################################################
############################################################################################################

print "Query:";
my $query =<>;
chomp $query;
my $timer=time();
require LWP::UserAgent;
@eng=<DATA>;
chomp(@eng);

my %word=();
my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
my $db ="pubmed";

my $report ="abstract";
my $esearch = "$utils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query";
my $esearch_result = got($esearch);
#3088101NCID_1_79507543_130.14.22.28_9001_1281041501_467740893 20681521 "bioremediation"[All Fields] All Fields 3088 Y GROUP "bioremediation"[All Fields]
$esearch_result =~
m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count = $1;
my $QueryKey = $2;
my $WebEnv = $3;

print "$Count articles for $query\n";
print "Start from...";
$go=<>;
chomp($go);
$go=abs($go);

# ---------------------------------------------------------------------------



open(OUT,'>articles.txt') or die "Can't make file: $!";
print OUT ("index\tpmid\ttitle\tjournal\tabs\tdate\tauthor\tdoi".join("\t",@terms));

my $temp="";
my $retstart;
my $retmax=200;
my @content= ();
for $index ($go..$Count) {
	if ($index % (5*$retmax) == 0) {
		$now=time()-$timer;
		$est=$now*$loops/(0.00001+$index)-$now;
		print ("Papers done: $index (".(int($index/$loops*100))."\%) in ");
		printf("%02d:%02d:%02d", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
		printf(" Est. time remaining: %02d %02d:%02d:%02d\n", int($est / 86400), int($est / 3600), int(($est % 3600) / 60), int($est % 60));
	}

	my $efetch = "$utils/efetch.fcgi?rettype=$report&retmode=XML&retstart=$index&retmax=$retmax&db=$db&query_key=$QueryKey&WebEnv=$WebEnv";
	my $efetch_result = got($efetch);
	my @bag=split(/\<\/PubmedArticle\>/, $efetch_result);
	foreach $article (@bag) {
		$index++;
		@content= ();
		@content = split(/\n/, $article);
		my $size=@content;
		for(my $i=0; $i <$size; $i++)
		{
			chomp($content[$i]);
			if ($content[$i] =~ /<PMID>/)
			{
				$pmid[$index]=$content[$i];
				$pmid[$index]=~ s/<PMID>//s;
				$pmid[$index]=~ s/<\/PMID>//s;
				$pmid[$index]=~ s/^\s+//s;
				#print $pmid[$index];
			}
			if ($content[$i] =~ /<Title>/)
			{
				$journal[$index]=$content[$i];
				$journal[$index]=~ s/<Title>//s;
				$journal[$index]=~ s/<\/Title>//s;
				$journal[$index]=~ s/^\s+//s;
				#print $journal[$index];
			}
			if ($content[$i] =~ /<ArticleTitle>/)
			{
				$title[$index]=$content[$i];
				$title[$index]=~ s/<ArticleTitle>//s;
				$title[$index]=~ s/<\/ArticleTitle>//s;
				$title[$index]=~ s/^\s+//s;
				#print $title[$index];
			}
			if ($content[$i] =~ /<AbstractText>/)
			{
				$abs[$index]=$content[$i];
				$abs[$index]=~ s/<AbstractText>//s;
				$abs[$index]=~ s/<\/AbstractText>//s;
				$abs[$index]=~ s/^\s+//s;
				#print $abs[$index];
			}
			if ($content[$i] =~ /<Author/)
			{
				while ($content[$i] !~ /<\/Author>/) {
					if ($content[$i] =~ /<LastName>/){
						$temp=0;
						$temp=$content[$i];
						$temp=~ s/^\s+<LastName>//s;
						$temp=~ s/<\/LastName>//s;
						$last=$temp;
					}
					if ($content[$i] =~ /<Initials>/){
						$temp=0;
						$temp=$content[$i];
						$temp=~ s/^\s+<Initials>//s;
						$temp=~ s/<\/Initials>//s;
						$initial=$temp;
					}
					$i++;
				}
				$author[$index]="$author[$index]\:$initial\_$last";
			}
			if ($content[$i] =~ /<DateCreated>/)
			{
				$temp=0;
				$temp=$content[$i+3];
				$temp=~ s/^\s+<Day>//s;
				$temp=~ s/<\/Day>//s;
				$date[$index]="$temp\:";
				$temp=$content[$i+2];
				$temp=~ s/^\s+<Month>//s;
				$temp=~ s/<\/Month>//s;
				$date[$index]="$date[$index]$temp\:";
				$temp=$content[$i+1];
				$temp=~ s/^\s+<Year>//s;
				$temp=~ s/<\/Year>//s;
				$date[$index]="$date[$index]$temp";
				$year[$index]=$temp;
			}
			if ($content[$i] =~ /<ArticleId IdType\=\"doi\">/)
			{
				$doi[$index]=$content[$i];
				$doi[$index]=~ s/^\s+<ArticleId IdType\=\"doi\">//s;
				$doi[$index]=~ s/<\/ArticleId>//s;
			}
			if ($content[$i] =~ /<Affiliation>/)
			{
				$place[$index]=$content[$i];
				$place[$index]=~ s/^\s+<Affiliation>//s;
				$place[$index]=~ s/<\/Affiliation>//s;
			}
			if (($content[$i] =~ /<PublicationType>/)&&($typer==0))
			{
				$type[$index]=$content[$i];
				$type[$index]=~ s/^\s+<PublicationType>//s;
				$type[$index]=~ s/<\/PublicationType>//s;
				$typer=1;
			}
			if (($content[$i] =~ /<PublicationType>/)&&($typer==1))
			{
				$supp[$index]=$content[$i];
				$supp[$index]=~ s/^\s+<PublicationType>//s;
				$supp[$index]=~ s/<\/PublicationType>//s;
			}
			
			
		}
		$typer=0;
		if ($author[$index] eq "") {print "\aNo author for $index!\n";}
		
		print OUT "\n$index\t$pmid[$index]\t$title[$index]\t$journal[$index]\t$abs[$index]\t$date[$index]\t$author[$index]\t$doi[$index]\t$place[$index]\t$type[$index]\t$supp[$index]";
		for $j (0..$#terms) {
			if ($abs[$index] =~ m/$terms[$j]/msi) {print OUT "\ty";} else {\print OUT "\tn";}
		}
		@wabs=split(" ",$abs[$index]);
		chomp(@wabs);
		foreach $item (@wabs) {
			lc($item);
			$item=~ s/\x{00B5}/micro/msgi;
			$item=~ s/\x{03BC}/micro/msgi;
			$item=~ s/\x{03D0}/beta/msgi;
			$item=~ s/\x{03B2}/beta/msgi;
			$item=~ s/\x{00DF}/esszett/msgi; #dumbass... wrote eszett instead of beta
			$item=~ s/\x{03B1}/alpha/msgi;
			$item=~ s/\heavy metal/heavymetal/msgi; #word pair
			$item=~ s/\W//msgi;
			$item=~ s/\d//msgi;
			foreach $simple (@eng) {$item =~ s/^$simple$/simple\_word/msgi;}
			$temp=$item;
			$temp=~ s/ies$/y/msgi;
			$temp=~ s/es$//msgi;
			$temp=~ s/ed$//msgi;
			$temp=~ s/er$//msgi;
			$temp=~ s/est$//msgi;
			$temp=~ s/ing$//msgi;
			foreach $simple (@eng) {if ($temp =~ m/^$simple$/msgi) {$item="simple_word";}}
			$temp=$item;
			$temp=~ s/s$//msgi;
			$temp=~ s/d$//msgi;
			$temp=~ s/r$//msgi;
			$temp=~ s/st$//msgi;
			$temp=~ s/ing$/e/msgi;
			foreach $simple (@eng) {if ($temp =~ m/^$simple$/msgi) {$item="simple_word";}}
			if ($item ne "") {$word{$item}++;$ultraword[$index]{$item}++;}
			
		}
		@pau=split("\:",$author[$index]);
		shift(@pau); #A small bug as the author list starts with a semicolon...
		$aleph{$pau[0]}++;
		if ($aleph{$pau[0]}==1) {$alephstart{$pau[0]}=$year[$index];$alephend{$pau[0]}=$year[$index];}
		else {
			if ($year[$index]<$alephstart{$pau[0]}) {$alephstart{$pau[0]}=$year[$index];}
			if ($year[$index]>$alephend{$pau[0]}) {$alephend{$pau[0]}=$year[$index];}
		}
		$omega{$pau[-1]}++;
		if ($omega{$pau[-1]}==1) {$omegastart{$pau[-1]}=$year[$index];$omegaend{$pau[-1]}=$year[$index];}
		else {
			if ($year[$index]<$omegastart{$pau[-1]}) {$omegastart{$pau[-1]}=$year[$index];}
			if ($year[$index]>$omegaend{$pau[-1]}) {$omegaend{$pau[-1]}=$year[$index];}
		}
		foreach $man (@pau) {
			$egocentre{$man}++;
			if ($egocentre{$man}==1) {$start{$man}=$year[$index];$end{$man}=$year[$index];}
			else {
				if ($year[$index]<$start{$man}) {$start{$man}=$year[$index];}
				if ($year[$index]>$end{$man}) {$end{$man}=$year[$index];}
			}
			foreach $hombre (@pau) {
				if (($man ne $hombre) && ($man ne "") && ($hombre ne "")) {$friend{$man}{$hombre}++;}
			}
		}
		
	}

}

close OUT;

for $index (0..$Count) {
	for $item (keys (%word)) {
		$devword{$item}+=($ultraword[$index]{$item}-($word{$item}/$Count))**2;
		if ($maxword{$item}<$ultraword[$index]{$item}) {$maxword{$item}=$ultraword[$index]{$item};}
		if (int($ultraword[$index]{$item}) != 0) {$onceword{$item}++;}
	}
	$devword{$item}=($devword{$item}/$Count)**0.5;
}

open(WORDS,'>words.txt') or die "Can't make file: $!";
print WORDS ("word\tCount\tStDev\tMaximum number in single abstract\tCount once\n");

for $x (sort hashValueNum (keys(%word))) {
	print WORDS "$x\t$word{$x}\t$devword{$x}\t$maxword{$x}\t$onceword{$x}\n";
}
close WORDS;

open(FOLKS,'>authors.txt') or die "Can't make file: $!";

for $y (sort keys(%friend)) {
	print FOLKS "\t$y";
}

for $x (sort keys(%friend)) {
	print FOLKS "\n$x";
	for $y (sort keys(%friend)) {
		print FOLKS "\t$friend{$x}{$y}";
	}
}
close FOLKS;

open(CHUMS,'>authors_details.txt') or die "Can't make file: $!";

print CHUMS "name\t\# papers\tstart date\tend date\t\# first authored papers\tfirst start\tfirst end\t\# last authored papers\tlast start\tlast end\n";
for $x (sort keys(%friend)) {
	print CHUMS "$x\t$egocentre{$x}\t$start{$x}\t$end{$x}\t$aleph{$x}\t$alephstart{$x}\t$alephend{$x}\t$omega{$x}\t$omegastart{$x}\t$omegaend{$x}\n";
}
close CHUMS;

for $x (keys(%egocentre)) {
	$egodist[$egocentre{$x}]++;
}
open(INFO,'>authors_info.txt') or die "Can't make file: $!";
print INFO ("number of authors:\t".$#line);
print INFO ("\nDISTRIBUTION\n");
for $x (0..$#egodist) {
	print INFO ("$x\t$egodist[$x]\n");
}


for $z (1..20) {
	@cleanlist=();
	for $x (keys(%egocentre)) {
		if ($egocentre{$x}>$z) {
			push(@cleanlist, $x);
		}
	}
	$file=('>authors_fix'.$z.'.txt');
	open(CHAPS,$file) or die "Can't make file: $!";
	
	print CHAPS "\t\# Papers";
	foreach $y (@cleanlist) {
		print CHAPS "\t$y";
	}
	print CHAPS "\t\# Papers\n".$egocentre{$x};
	
	foreach $x (@cleanlist) {
		foreach $y (@cleanlist) {
			print CHAPS "\t".$friend{$x}{$y};
		}
		print CHAPS "\t$x\n".$egocentre{$x};
	}
	close CHAPS;
}

#############Islands###########
%shrink=%friend;
@dodgyfix=keys %shrink;
$x=0;
for $y (0..$#dodgyfix) {
	$man=$dodgyfix[$y];
	if ($man ne "") {
		$tempcount=1;
		@todo=keys %{$shrink{$man}};
		delete $shrink{$man};
		$link=$man;
		@gone=();
		$gone[0]=$man;
		foreach $hombre (@todo) {
			for $desaparesido (@gone) {
				delete $shrink{$desaparesido}{$hombre};
			}
			@temp=keys %{$shrink{$hombre}};
			delete $shrink{$hombre};
			foreach $dago (@dodgyfix) {if ($dago eq $hombre) {$dago="";}}
			push(@todo,@temp);
			$link=$hombre;
			push(@gone,$hombre); #Desaparesido!
			$tempcount++;
		}
		print "this group is $tempcount people big\n";
		$group[$x]=join("\:",@gone);
		$gsize[$x]=$tempcount;
		$x++;
	}
	
}

print "There are $#gsize groups\n";
open (GROUPS,'>groups.txt') or die "Can't make file: $!";
for $x (0..$#group) {
	print GROUPS "$x\t$gsize[$x]\t$group[$x]\n";
}



$now=time()-$timer;
printf("\nScript execution completed (%02d:%02d:%02d)\n\a", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
#######################################
sub hashValueNum {
	$word{$b} <=> $word{$a};
}

sub got {
	my $home=$_[0];	
	my $ua = LWP::UserAgent->new;
	$ua->timeout(5000);
	$ua->proxy(['http', 'ftp'], 'http://tur-cache.massey.ac.nz:8080/');
	$ua->env_proxy;
	
	my $response = $ua->get($home);
	
	if ($response->is_success) {
		return $response->decoded_content;  # or whatever
	}
	else {
		print $response->status_line;
	}
}

#### TOP 2000 words in english plus some obvious non technicals
__DATA__
using
been
has
two
did
four
being
found
three
five
six
seven
eight
nine
ten
eleven
was
were
are
is
a
ability
able
about
about
above
above
absence
absolutely
academic
accept
access
accident
accompany
according
to
account
account
achieve
achievement
acid
acquire
across
act
act
action
active
activity
actual
actually
add
addition
additional
address
address
administration
admit
adopt
adult
advance
advantage
advice
advise
affair
affect
afford
afraid
after
after
afternoon
afterwards
again
against
age
agency
agent
ago
agree
agreement
ahead
aid
aim
aim
air
aircraft
all
all
allow
almost
alone
alone
along
along
already
alright
also
alternative
alternative
although
always
among
amongst
amount
an
analysis
ancient
and
animal
announce
annual
another
answer
answer
any
anybody
anyone
anything
anyway
apart
apparent
apparently
appeal
appeal
appear
appearance
application
apply
appoint
appointment
approach
approach
appropriate
approve
area
argue
argument
arise
arm
army
around
around
arrange
arrangement
arrive
art
article
artist
as
as
as
ask
aspect
assembly
assess
assessment
asset
associate
association
assume
assumption
at
atmosphere
attach
attack
attack
attempt
attempt
attend
attention
attitude
attract
attractive
audience
author
authority
available
average
avoid
award
award
aware
away
aye
baby
back
back
background
bad
bag
balance
ball
band
bank
bar
base
base
basic
basis
battle
be
bear
beat
beautiful
because
become
bed
bedroom
before
before
before
begin
beginning
behaviour
behind
belief
believe
belong
below
below
beneath
benefit
beside
best
better
between
beyond
big
bill
bind
bird
birth
bit
black
block
blood
bloody
blow
blue
board
boat
body
bone
book
border
both
both
bottle
bottom
box
boy
brain
branch
break
breath
bridge
brief
bright
bring
broad
brother
budget
build
building
burn
bus
business
busy
but
buy
by
cabinet
call
call
campaign
can
candidate
capable
capacity
capital
car
card
care
care
career
careful
carefully
carry
case
cash
cat
catch
category
cause
cause
cell
central
centre
century
certain
certainly
chain
chair
chairman
challenge
chance
change
change
channel
chapter
character
characteristic
charge
charge
cheap
check
chemical
chief
child
choice
choose
church
circle
circumstance
citizen
city
civil
claim
claim
class
clean
clear
clear
clearly
client
climb
close
close
close
closely
clothes
club
coal
code
coffee
cold
colleague
collect
collection
college
colour
combination
combine
come
comment
comment
commercial
commission
commit
commitment
committee
common
communication
community
company
compare
comparison
competition
complete
complete
completely
complex
component
computer
concentrate
concentration
concept
concern
concern
concerned
conclude
conclusion
condition
conduct
conference
confidence
confirm
conflict
congress
connect
connection
consequence
conservative
consider
considerable
consideration
consist
constant
construction
consumer
contact
contact
contain
content
context
continue
contract
contrast
contribute
contribution
control
control
convention
conversation
copy
corner
corporate
correct
cos
cost
cost
could
council
count
country
county
couple
course
court
cover
cover
create
creation
credit
crime
criminal
crisis
criterion
critical
criticism
cross
crowd
cry
cultural
culture
cup
current
currently
curriculum
customer
cut
cut
damage
damage
danger
dangerous
dark
data
date
date
daughter
day
dead
deal
deal
death
debate
debt
decade
decide
decision
declare
deep
deep
defence
defendant
define
definition
degree
deliver
demand
demand
democratic
demonstrate
deny
department
depend
deputy
derive
describe
description
design
design
desire
desk
despite
destroy
detail
detailed
determine
develop
development
device
die
difference
different
difficult
difficulty
dinner
direct
direct
direction
directly
director
disappear
discipline
discover
discuss
discussion
disease
display
display
distance
distinction
distribution
district
divide
division
do
doctor
document
dog
domestic
door
double
doubt
down
down
draw
drawing
dream
dress
dress
drink
drink
drive
drive
driver
drop
drug
dry
due
during
duty
each
ear
early
early
earn
earth
easily
east
easy
eat
economic
economy
edge
editor
education
educational
effect
effective
effectively
effort
egg
either
either
elderly
election
element
else
elsewhere
emerge
emphasis
employ
employee
employer
employment
empty
enable
encourage
end
end
enemy
energy
engine
engineering
enjoy
enough
enough
ensure
enter
enterprise
entire
entirely
entitle
entry
environment
environmental
equal
equally
equipment
error
escape
especially
essential
establish
establishment
estate
estimate
even
evening
event
eventually
ever
every
everybody
everyone
everything
evidence
exactly
examination
examine
example
excellent
except
exchange
executive
exercise
exercise
exhibition
exist
existence
existing
expect
expectation
expenditure
expense
expensive
experience
experience
experiment
expert
explain
explanation
explore
express
expression
extend
extent
external
extra
extremely
eye
face
face
facility
fact
factor
factory
fail
failure
fair
fairly
faith
fall
fall
familiar
family
famous
far
far
farm
farmer
fashion
fast
fast
father
favour
fear
fear
feature
fee
feel
feeling
female
few
few
field
fight
figure
file
fill
film
final
finally
finance
financial
find
finding
fine
finger
finish
fire
firm
first
fish
fit
fix
flat
flight
floor
flow
flower
fly
focus
follow
following
food
foot
football
for
for
force
force
foreign
forest
forget
form
form
formal
former
forward
foundation
free
freedom
frequently
fresh
friend
from
front
front
fruit
fuel
full
fully
function
fund
funny
further
future
future
gain
game
garden
gas
gate
gather
general
general
generally
generate
generation
gentleman
get
girl
give
glass
go
goal
god
gold
good
good
government
grant
grant
great
green
grey
ground
group
grow
growing
growth
guest
guide
gun
hair
half
half
hall
hand
hand
handle
hang
happen
happy
hard
hard
hardly
hate
have
he
head
head
health
hear
heart
heat
heavy
hell
help
help
hence
her
her
here
herself
hide
high
high
highly
hill
him
himself
his
his
historical
history
hit
hold
hole
holiday
home
home
hope
hope
horse
hospital
hot
hotel
hour
house
household
housing
how
however
huge
human
human
hurt
husband
i
idea
identify
if
ignore
illustrate
image
imagine
immediate
immediately
impact
implication
imply
importance
important
impose
impossible
impression
improve
improvement
in
in
incident
include
including
income
increase
increase
increased
increasingly
indeed
independent
index
indicate
individual
individual
industrial
industry
influence
influence
inform
information
initial
initiative
injury
inside
inside
insist
instance
instead
institute
institution
instruction
instrument
insurance
intend
intention
interest
interested
interesting
internal
international
interpretation
interview
into
introduce
introduction
investigate
investigation
investment
invite
involve
iron
island
issue
issue
it
item
its
itself
job
join
joint
journey
judge
judge
jump
just
justice
keep
key
key
kid
kill
kind
king
kitchen
knee
know
knowledge
labour
labour
lack
lady
land
language
large
largely
last
last
late
late
later
latter
laugh
launch
law
lawyer
lay
lead
lead
leader
leadership
leading
leaf
league
lean
learn
least
leave
left
leg
legal
legislation
length
less
less
let
letter
level
liability
liberal
library
lie
life
lift
light
light
like
like
likely
limit
limit
limited
line
link
link
lip
list
listen
literature
little
little
little
live
living
loan
local
location
long
long
look
look
lord
lose
loss
lot
love
love
lovely
low
lunch
machine
magazine
main
mainly
maintain
major
majority
make
male
male
man
manage
management
manager
manner
many
map
mark
mark
market
market
marriage
married
marry
mass
master
match
match
material
matter
matter
may
may
maybe
me
meal
mean
meaning
means
meanwhile
measure
measure
mechanism
media
medical
meet
meeting
member
membership
memory
mental
mention
merely
message
metal
method
middle
might
mile
military
milk
mind
mind
mine
minister
ministry
minute
miss
mistake
model
modern
module
moment
money
month
more
more
morning
most
most
mother
motion
motor
mountain
mouth
move
move
movement
much
much
murder
museum
music
must
my
myself
name
name
narrow
nation
national
natural
nature
near
nearly
necessarily
necessary
neck
need
need
negotiation
neighbour
neither
network
never
nevertheless
new
news
newspaper
next
next
nice
night
no
no
no
no-one
nobody
nod
noise
none
nor
normal
normally
north
northern
nose
not
note
note
nothing
notice
notice
notion
now
nuclear
number
nurse
object
objective
observation
observe
obtain
obvious
obviously
occasion
occur
odd
of
off
off
offence
offer
offer
office
officer
official
official
often
oil
okay
old
on
on
once
once
one
only
only
onto
open
open
operate
operation
opinion
opportunity
opposition
option
or
order
order
ordinary
organisation
organise
organization
origin
original
other
other
other
otherwise
ought
our
ourselves
out
outcome
output
outside
outside
over
over
overall
own
own
owner
package
page
pain
paint
painting
pair
panel
paper
parent
park
parliament
part
particular
particularly
partly
partner
party
pass
passage
past
past
past
path
patient
pattern
pay
pay
payment
peace
pension
people
per
percent
perfect
perform
performance
perhaps
period
permanent
person
personal
persuade
phase
phone
photograph
physical
pick
picture
piece
place
place
plan
plan
planning
plant
plastic
plate
play
play
player
please
pleasure
plenty
plus
pocket
point
point
police
policy
political
politics
pool
poor
popular
population
position
positive
possibility
possible
possibly
post
potential
potential
pound
power
powerful
practical
practice
prefer
prepare
presence
present
present
present
president
press
press
pressure
pretty
prevent
previous
previously
price
primary
prime
principle
priority
prison
prisoner
private
probably
problem
procedure
process
produce
product
production
professional
profit
program
programme
progress
project
promise
promote
proper
properly
property
proportion
propose
proposal
prospect
protect
protection
prove
provide
provided
provision
pub
public
public
publication
publish
pull
pupil
purpose
push
put
quality
quarter
question
question
quick
quickly
quiet
quite
race
radio
railway
rain
raise
range
rapidly
rare
rate
rather
reach
reaction
read
reader
reading
ready
real
realise
reality
realize
really
reason
reasonable
recall
receive
recent
recently
recognise
recognition
recognize
recommend
record
record
recover
red
reduce
reduction
refer
reference
reflect
reform
refuse
regard
region
regional
regular
regulation
reject
relate
relation
relationship
relative
relatively
release
release
relevant
relief
religion
religious
rely
remain
remember
remind
remove
repeat
replace
reply
report
report
represent
representation
representative
request
require
requirement
research
resource
respect
respond
response
responsibility
responsible
rest
rest
restaurant
result
result
retain
return
return
reveal
revenue
review
revolution
rich
ride
right
right
right
ring
ring
rise
rise
risk
river
road
rock
role
roll
roof
room
round
round
route
row
royal
rule
run
run
rural
safe
safety
sale
same
sample
satisfy
save
say
scale
scene
scheme
school
science
scientific
scientist
score
screen
sea
search
search
season
seat
second
secondary
secretary
section
sector
secure
security
see
seek
seem
select
selection
sell
send
senior
sense
sentence
separate
separate
sequence
series
serious
seriously
servant
serve
service
session
set
set
settle
settlement
several
severe
sex
sexual
shake
shall
shape
share
share
she
sheet
ship
shoe
shoot
shop
short
shot
should
shoulder
shout
show
show
shut
side
sight
sign
sign
signal
significance
significant
silence
similar
simple
simply
since
since
sing
single
sir
sister
sit
site
situation
size
skill
skin
sky
sleep
slightly
slip
slow
slowly
small
smile
smile
so
so
social
society
soft
software
soil
soldier
solicitor
solution
some
somebody
someone
something
sometimes
somewhat
somewhere
son
song
soon
sorry
sort
sound
sound
source
south
southern
space
speak
speaker
special
species
specific
speech
speed
spend
spirit
sport
spot
spread
spring
staff
stage
stand
standard
standard
star
star
start
start
state
state
statement
station
status
stay
steal
step
step
stick
still
stock
stone
stop
store
story
straight
strange
strategy
street
strength
strike
strike
strong
strongly
structure
student
studio
study
study
stuff
style
subject
substantial
succeed
success
successful
such
suddenly
suffer
sufficient
suggest
suggestion
suitable
sum
summer
sun
supply
supply
support
support
suppose
sure
surely
surface
surprise
surround
survey
survive
switch
system
table
take
talk
talk
tall
tape
target
task
tax
tea
teach
teacher
teaching
team
tear
technical
technique
technology
telephone
television
tell
temperature
tend
term
terms
terrible
test
test
text
than
thank
thanks
that
that
the
theatre
their
them
theme
themselves
then
theory
there
there
therefore
these
they
thin
thing
think
this
those
though
though
thought
threat
threaten
through
through
throughout
throw
thus
ticket
time
tiny
title
to
to
to
today
together
tomorrow
tone
tonight
too
tool
tooth
top
top
total
total
totally
touch
touch
tour
towards
town
track
trade
tradition
traditional
traffic
train
train
training
transfer
transfer
transport
travel
treat
treatment
treaty
tree
trend
trial
trip
troop
trouble
TRUE
trust
truth
try
turn
turn
twice
type
typical
unable
under
under
understand
understanding
undertake
unemployment
unfortunately
union
unit
united
university
unless
unlikely
until
until
up
up
upon
upper
urban
us
use
use
used
used
useful
user
usual
usually
value
variation
variety
various
vary
vast
vehicle
version
very
very
via
victim
victory
video
view
village
violence
vision
visit
visit
visitor
vital
voice
volume
vote
vote
wage
wait
walk
walk
wall
want
war
warm
warn
wash
watch
water
wave
way
we
weak
weapon
wear
weather
week
weekend
weight
welcome
welfare
well
well
west
western
what
whatever
when
when
where
where
whereas
whether
which
while
while
whilst
white
who
whole
whole
whom
whose
why
wide
widely
wife
wild
will
will
win
wind
window
wine
wing
winner
winter
wish
with
withdraw
within
without
woman
wonder
wonderful
wood
word
work
work
worker
working
works
world
worry
worth
would
write
writer
writing
wrong
yard
yeah
year
yes
yesterday
yet
you
young
your
yourself
youth
