#!/usr/local/bin/bash

#echo "loading function.sh"

# Automatically mark variables and functions which are modified or
# created for export to the environment of subsequent commands.
set -a
# BUT NOTE: doing so causes SGE error
# c.f. http://gridengine.sunsource.net/issues/show_bug.cgi?id=2173

################################################################################
#                  bash MACROS
################################################################################


function lnsMatching {
# PURPOSE: Mirror (a portion of) a directory hierarchy by creating
# (absolute) symbolic links to the subset of files along with the
# parent directories for those directories holding mirrored files.
# 
# The files to by symlinked are specified using gnu `find`
# expression(s).
#
# Any pre-existing target link is re-created, regardless of whether
# its new referent is the same as its old (due to using `cp -f`).
#
# TODO: 
#  use getopt ?
#  new option: -v(erbose) or -q(uiet) - to toglle `mkdir -v` and `cp -v`
#  considerations need for odd filenames (i.e. containing whitespace, quotes, control chars, etc)
#
# SEE ALSO: 
#  * gnu `find` command
#  * lndir command - which is nice, but does not allow you to select specify which files
# get links
#  * lns (http://www.chiark.greenend.org.uk/~sgtatham/utils/lns.html)
#
# EXAMPLES:   
# create links to selected .jpg files in a sister directory to PWD:
# > lnsMatching ../t1/t2 . -name '*BMP*.bam' 
#
# AUTHOR: malcolm_cook@stowers.org
  local dstPath=$1 ;
  local srcPath=$2 ;
  shift 2 ;
  local findExpr="$@";
  find ${srcPath} -xtype f ${findExpr} -printf 'mkdir -v -p ${dstPath}/%h && cp -v -f -s -t ${dstPath}/%h $(readlink -f %p)\n' | sh
}



#find files with the same name as each other (in different directories) subordinate to current dir
function dupfind_name { 
    find $1 -type f -printf '%h\t%f\n' | sort --field-separator='	' --key=2 | uniq --skip-fields=1 --all-repeated | perl -a -n -e 'print "dupfilename: $F[1]\n" unless $lastkey eq $F[1];  $lastkey = pop(@F); print "\t@F\n"' ;
}


function dupfind_path {
    path=$1
    x=$(echo "$path" | awk -v RS=':' -v ORS=":" '!a[$1]++')
    find ${x//:/ } -maxdepth 1 -printf '%h\t%f\n' | sort --field-separator='	' --key=2 | uniq --skip-fields=1 --all-repeated | perl -a -n -e 'print "dupfilename: $F[1]\n" unless $lastkey eq $F[1];  $lastkey = pop(@F); print "\t@F\n"' ;
}




function sortByTabCount {
  # example of sorting based on computed value, which is then cut back off the output
  perl -ap -e '$_="$#F\t$_"' "$@" | sort -nr | cut -f 1 --complement ;
}

#find files subordinate to  directory $1 with PROBABLY the same content as each other.  group the output 
function dupfind_md5sum () { 
    find $1 -type f -print0 | \
	xargs -0 md5sum | sort | \
	uniq --check-fields=1 --all-repeated | \
	perl -a -n -e 'print "\n" unless $lastmd5 == $F[0];  $lastmd5 = shift(@F); print "@F\n"' ; 
}

################################################################################
##################### PERL DEV RELATED
################################################################################

function pM {
 # Purpose: contrive to run perl using a (single) module which MUST
 # implement `new`.  $M is set to a ->new instance of the class.  All
 # additional options to pM are taken as perl switches.
 #
 # EXAMPLE: load ASA module
 #  pM DBI
 #      pM ASA -MYAML -p -e '$_ = $M->outdir . $_' -- --outd asdf
    local m=$1 ;
    local a=$2 ;
    shift 2;
#    echo "$@" ;
    local e="BEGIN{\$new||=q{new}; \$M = $m->\$new($a);}"\  ; 
    echo perl -w -M${m} -e "$e" "$@" ;
         perl -w -M${m} -e "$e" "$@"  ;
 #   local E=\''BEGIN{$new||="new"; $M'=${M}'->$new(@ARGV)};'\'
    #echo perl -M${M} -e ${E} "$@" 
    #eval perl -M${M} -e ${E} "$@" 
}


function biodbfasta {
    # PURPOSE: perform standard Perl option processing (esp. -e, -n
    # and -p) with $db set to the fasta database in path $1 randomly
    # accessible using Bio::DBI::Fasta methods.
    #
    # EXMPLE:
    # 
    # biodbfasta /n/data1/genomes/Mus_musculus_37/all_chr.fa  -e 'print $db->get_all_ids'
    #
    # echo -e "chr10 12 23\nchr12 123 125\nchr666 666 666" | biodbfasta /n/data1/genomes/Mus_musculus_37/all_chr.fa  -an -e 'print ">$_". $db->subseq(@F) || die $! ."\n"'
    # echo -e "10 12 23\n12 12300000 12300010\n666 666 666" | biodbfasta  ${GenomeFasta}  -an -e '$seq=$db->seq(@F) || die "no seq for: $_"; print ">$_$seq"'
    #
    # echo -e "12:12300000-12300010" | biodbfasta  ${GenomeFasta}  -pan -e '$_=$db->seq(@F)."\n"'

    path=$1; # 's/>(chr)?([\w\.]+)/
    shift;
    perl -M'Bio::DB::Fasta' -e "BEGIN {\$db=Bio::DB::Fasta->new(q{$path})}" "$@" ;
}



function pDBI {
  pM DBI  -s -- -new=connect "$@"
}


#pM DBI -s -- new=connect

#pm C -MData::Dumper  -e 'print "asdf" . Dumper(\$m)' -s -- -new=new_with_option\ s --x 22


function quotearg {
# quotes all args and echos them.
# no purpose - just thinking.
#    echo perl ;
#    IFS='' ;
    local q=( "$@" ) ;
    echo ${q[0]} - ${q[@]} ;
    q=( "${q[@]/#/\'}" )
    echo ${q[0]} - ${q[@]} ;
    q=( "${q[@]/%/\'}" )
    echo ${q[1]} - ${q[@]} ;
    echo "${q[@]}" ;
    #eval "perl ${q[@]}" ;
}




# pDBI -MYAML -n -e  'print Dump($M->fetchrow_array("select count(*) from foo"));'

function pMooseCmd {
 # Purpose: treat a perl module, assumed to `use Moose` and `use
 # MooseX::Getopt`, like a command.
 #
 # EXAMPLE: load ASA module
 #      pMooseCmd ASA -MYAML -p -e '$_ = $M->outdir . $_' -- --outd asdf
    
    local M=$1 ;
    shift ;
    local E='BEGIN{$M'=${M}'->new_with_options();@ARGV=@{$M->extra_argv}}'
    perl -M${M} -e ${E} "$@"
}



################################################################################
# HowTo: find files named 'Root' containing string 'mcook'
# find . -type f -name 'Root' -print0 | xargs -0 grep -l mcook

################################################################################
# HOWTO: edit files containing -w 1st line to 'use warnings' isntaed
# perl -piorig -e 's/(.*) \-w(.*)/$1$2\nuse warnings;/ if $. == 1; close ARGV if eof(ARGV) ' file1 file2....

################################################################################
# find path of installed perl module
# echo Bio::SeqIO | perl -M'UNIVERSAL::require' -e '$_= shift; $_->require; s/\:\:/\//; $_ .= ".pm"; $_ = $INC{$_}; print' "Bio::SearchIO" 
# echo Bio::SeqIO | perl -M'UNIVERSAL::require' -n -e 'chomp; $_->require or die "could not require $_ "; s{::}{/}g; s/$/.pm/; print $INC{$_}, "\n"'ra
# or, using installed Class::Inspector
# perl -M'UNIVERSAL::require' -M'Class::Inspector' -e '$_= shift; $_->require; print Class::Inspector->resolved_filename($_)' "Bio::SearchIO"


################################################################################

################################################################################

# HOWTO: convert fasta records to have all sequence on one line (i.e. alternating deflines and sequence lines)
#NOT function fa1 () { perl -pe 'chomp; $_ m/^>/' $@ ; }

################################################################################
# HOWTO: extract predicted genes from a genmark analysis
# perl -MBio::SeqIO -ne 'BEGIN{$s = Bio::SeqIO->new(-file => shift)->next_seq; $o =  Bio::SeqIO->newFh(-format => "fasta")}; next unless m/\s+(\d+)\s+(\+|-)\s+(\d+)\s+(\d+)/;$t = $s->trunc($3,$4); if ($2 eq "-") {$t = $t->revcom; $t->display_id($t->display_id . "_rc")};  $t->display_id($t->display_id . "_$1:$3-$4"); print $o $t->translate;' Eco32_new.fa Genmark_new1.txt


################################################################################
# HOWTO: list the distinct feature types (FT line) in a bunch of EMBL formatted contig files
# perl -ne 'END{$,="\n"; print sort keys(%FT)}; next unless m/FT   (\S+)/; $FT{$1}++' *.contig

################################################################################
# HOWTO: print fasta records on STDIN whose defline matches (according to a pattern) a list of identifiers, one per line, in a file (id.dat)
# perl -n -e 'BEGIN{$pattern = shift; open(idfile, shift) or die "no open"; @ID = <idfile>; chomp @ID; %ID = map {($_, 1)} @ID;}  $inmatch = exists($ID{$1}) if m/$pattern/; print if $inmatch' '^>probe:\w+:(\w+):' id.dat

################################################################################
# convert gi numbers to taxon lineage
# perl -MSeqHound -p -e 's/(.*)/SHoundGetTaxLineageFromTaxID(SHoundTaxIDFromGi($1),10)/e'
# function gi2taxon () { perl -MSeqHound -p -e 's/(.*)/SHoundGetTaxLineageFromTaxID(SHoundTaxIDFromGi($1),10)/e' ; }

################################################################################
# convert hierarchical directoy of dna strider files to embl library
# find ./JaspersenDNAsequences/ -name '*.xdna' -print0 | xargs -0 seqio --file2id 's/\s/_/g' --informat strider --outformat embl > ./JaspersenDNAsequences/converted.embl

################################################################################
# convert aligment formats - bioperl one-liner
# cat myfile.pfam | perl -MBio::AlignIO -e 'select Bio::AlignIO->newFh(-format => "fasta"); $in = Bio::AlignIO->newFh(-format => "pfam", -fh => \*STDIN); print while <$in>' > myfile.pfam.fasta

################################################################################
# PURPOSE: apply command individually to every fasta record in a multi fasta file. 
#            \{\} or '{}' will be replaced by the file for executing the command. (just like find, which it uses
# DEPENDS: fastashatter
# EXAMPLE: fastamap LanFPmRNA fgenesh /n/site/inst/Linux-i686/bioinfo/fgenesh/fgenesh/Chicken '{}'
# WORK IN PROGRESS - different version - main problem is currying down a pipe our redirect
#function fastamap { fastafile=$1; shift; cmd=$@; tmp="/tmp/fastamap/$$/"; mkdir -p $tmp; rm $tmp*; fastashatter -d $tmp $fastafile; find $tmp -type f -exec eval [$cmd] \; ;}
#function fastamap { fastafile=$1; shift; cmd=$@; dir="$FUNCNAME.XXXXXX"; tmp=`mktemp -t -d $dir`;  fastashatter -d "$tmp/" $fastafile; find $tmp -type f -print0 | xargs  -0 -n 1  $cmd  \; ;}
#function fastamap { fastafile=$1; shift; cmd=$@; dir="$FUNCNAME.XXXXXX"; tmp=`mktemp -t -d $dir`;  fastashatter -d "$tmp/" $fastafile; find $tmp -type f -exec sh -c $cmd {}  \;" ;}

#xargs usage
#map $cmd = $1 ; shift
#reduce
#fastaargs 
# splitinput => process => reduce/combine/append => cleanup (optional if in tmp dir?!?)
#fashatter
#fasplit : shatter fasta records on std input into files in directory (defaulting to mktemp) return name of directory
#find `fasplit` -print0 | xargs -n 3 qsub
#fastargs | xargs -i  fgenesh /n/site/inst/Linux-i686/bioinfo/fgenesh/fgenesh/Chicken '{}'

#fastargs ./LanFP_DNA1 | xargs -i sh -c 'fgenesh /n/site/inst/Linux-i686/bioinfo/fgenesh/fgenesh/Fish  {} | fgenesh2gff'

################################################################################
# 
function nthline { 
# get nth line of file (starting from 1)
 N=$1 ;
 file=$2 ;
 sed $N'!d;q' $file
}

# function everyNth {
#  # OBSOLETE: USED nth instead (below)
#  # PURPOSE:

#  #  echo every [-n]th (default=2, i.e. "every other") line, starting
#  #  at -m (0-based, defaulting to $n - 1) using $i as and $o as $OUTPUT_RECORD_SEPARATOR 

#  # USAGE:
#  # bash> everyNth -n=3 -m=1 < myFile.txt
#  # bash> everyNth -n=3 -m=0 -i=$'\n>'
#  perl -sne 'BEGIN { $n ||= 2; $m = ($n - 1) unless defined($m) ; $/ = $i || $/; $\ = $o || $/}; if (($. -1) % $n == $m) {chomp;print}' -- "$@"
# }


#function filetypematches (){ file=$1; pattern=$2; [[ `file $file` =~ $pattern ]] ; }


function perlClassWhich {
# PURPOSE: report on where methods are defined in perl classes inheritnace tree
# EXAMPLE: perlClassWhich 'Bio::DB::SeqFeature' add_tag_value get_tag_values
#Bio::DB::SeqFeature:	
#add_tag_value:	Bio::Graphics::FeatureBase	Bio::AnnotatableI
#get_tag_values:	Bio::Graphics::FeatureBase	Bio::AnnotatableI
classname=$1
perl -MClass::ISA -MClass::Inspector -M$classname -e 'my $c = shift; my @c = Class::ISA::self_and_super_path("$c"); foreach my $fn (@ARGV) {print "\n$fn:\t", join "\t", (grep {Class::Inspector->function_exists($_, $fn)} @c),"\n"}'   $classname $@
}



## 
function perlWhichModuleVersion {
    local module=$1;
    shift;
    perl -M${module} -w -e 'my $modname = shift; my $VERS = $modname->VERSION; my $modfile = $modname;  $modfile =~ s/\:\:/\//g; $modfile .= q{.pm}; print qq{$modname\t$VERS\t$modfile\t$INC{$modfile}\n}' -- ${module} ;
}



function gfftabmap {
    # PURPOSE: -eval perlcode once for each GFF feature (skipping comments, blanks, and other non GFF lines (hueristically)) 
    local perlcode=$1;     #to offset, pass in: '@F[3] -= 11815951; @F[4] -= 11815951;';
    shift;
    perl -F'\t' -lap -e 'BEGIN{$"="\t"}; next unless $#F == 8;' -e  "$perlcode" -e'$_= "@F"' $@
}

function gffoffset {
    local offset=$1;
    shift;
    local perlcode="@F[3] -= $offset; @F[4] -= $offset;";
    gfftabmap "$perlcode" $@;
}

### OLD VERSION
### function dbimapqry {
###  
###  # PURPOSE:
###  #  Connect as -user using -password to a database -dsn, run sql query found in -query file repeatedly, using successive lines of <STDINPUT> as query parameters (split on whitespace).  
###  #  Print tab-delimited results to <STDOUT>
### 
###  # EXAMPLE USAGE: 
### 
###  # >echo 18950 | dbimapqry -query=./EntrezGene2GO.sql -dsn='dbi:mysql:database=mus_musculus_core_45_36f;host=ensembldb.ensembl.org' -user=anonymous
### 
###  # >echo 18950 | dbimapqry -query=./EntrezGene2GO.sql -dsn='dbi:mysql:database=mus_musculus_core_45_36f;host=ensembldb.ensembl.org' -user=anonymous
### 
### #    perl -MDBI -sane 'BEGIN{$sql = `cat $query`; our $sth = DBI->connect($dsn, $user, $password)->prepare($sql);  $,="\t";  $\="\n";} $sth->execute(@F); map {print @$_} @{$sth->fetchall_arrayref}' -- $@
### 
###     perl -MDBI -MSQL::Library -sane 'BEGIN{our $sth = DBI->connect($dsn, $user, $password)->prepare(SQL::Library->new({lib => $sqllib})->retr($qname));  $,="\t";  $\="\n";} $sth->execute(@F); map {print @$_} @{$sth->fetchall_arrayref}' -- $@
### 
### }


################################################################################
### DBI Related
################################################################################

function dbimapqry {

#  prefer not to use this.  see ~mec/bin/dbimap for improvement
 
# PURPOSE: Connected as -user using -password to database given by DBI
# connection -dsn, repeatedly run the query named -qry appearing in
# the -lib file, using successive lines of <STDINPUT> as query
# parameters (split on whitespace, filtering blank and #comment
# lines).  Print tab-delimited results to <STDOUT>


# EXAMPLE USAGE: 
# echo '/n/analysis' 6152JAAXX  |  dbimapqry -lib=/home/mec/nhome/projects/ngslims/qrylib.sql -qry=flowcell_lane_info -dsn='dbi:mysql:database=ngslims;host=ngslims' -user=webuser -password=welcome323
 
 #cd /n/facility/Bioinformatics/analysis/BioInfo/hul/dai/
 # >echo 18950 | dbimapqry -lib=~mec/.sql_library/ensembl.sql -qry=EntrezGene2GO -dsn='dbi:mysql:database=mus_musculus_core_45_36f;host=ensembldb.ensembl.org' -user=anonymous
 # >echo 18950 | dbimapqry -lib=~mec/.sql_library/ensembl.sql.sql -qry=EntrezGene2GO -dsn='dbi:mysql:database=mus_musculus_core_45_36f;host=ensembldb.ensembl.org' -user=anonymous

# SQL::Library
  perl -MDBI -MSQL::Library -sane 'BEGIN{our $dbh = DBI->connect($dsn, $user, $password); our $sth = $dbh->prepare(SQL::Library->new({lib => $lib})->retr($qry));  $,="\t";  $\="\n";}; next if /^\s*#/ or /^\s*$/ ; $sth->execute(@F)  or die $dbh->errstr; map {print @$_} @{$sth->fetchall_arrayref}' -- $@

}

# function dbimap {
#     echo this has quoting problems.   see ~mec/bin/dbimap ;
#     return ;
#  # PURPOSE:
#  #  Connect as -user using -password to a database using DBI connection -dsn. Then, run -sql repeatedly, using successive lines of <STDINPUT> as parameters (split on whitespace, filtering blank and #comment lines ).  
#  #  Print tab-delimited results to <STDOUT>
#  # EXAMPLE USAGE: 
#  # echo "1\t2\3\n4\t5\t6"  | dbimap -sql="insert match_gff (c1,c2,c3) values (?,?,?)" -dsn='DBI:CSV:f_dir=~/csvdb' 
# echo perl -MDBI -sa -n -e 'BEGIN{my $con = DBI->connect($dsn, $user, $password) or die "couldnt connect"; our $sth = $con->prepare($sql); local($,,$\) =("\t","\n");}; next if /^\s*#/ or /^\s*$/ ;  next $sth->execute(@F); map {print @$_} @{$sth->fetchall_arrayref}; ' -- "${@}"
# }



################################################################################
### FASTA
################################################################################

function fasplit {
 # PURPOSE: split a fasta formatted file into sections
 # USAGE: fasplit <same options as csplit>
 # EXAMPLE: run program DoItNow 
 # mkdir delme
 # fasplit -f ./delme/ <(fastacmd -D 1 | head)
 # find ./delme/* -print0 | xargs -I{} -0 transfacmatch $TRANSFAC/match/data/matrixTFP111.lib \{\}  \{\}.out $TRANSFAC/match/data/prfs/muscle_specific.prf
    csplit --quiet $@  "%^>%" "/^>/" "{*}" 

}

function fasta_item { 
    # PURPOSE: extract selected records from fasta file
    # USAGE `fasta_item 3,5 ./Hox_Petromyzon_marinus.fa`
    java -cp /n/facility/Bioinformatics/Software/Readseq/readseq.jar run f=fasta -pipe informat=fa format=fa -item=$@ ;
}


function fastargs { local fastafile=$1; shift; local cmd=$@; 
 seqcnt=`grep -c '^>' $fastafile` ;
 seqcnt=4 ;
# echo $seqcnt ;
# for ((i=1 ; $i <= seqcnt ; i++)) ; do fasta_item $i $fastafile 2> /dev/null   ; done 
# for ((seqi=1 ; $seqi <= seqcnt ; seqi++)) ; do $cmd <(fasta_item $seqi $fastafile 2> /dev/null)   ; done 
 for ((seqi=1 ; $seqi <= seqcnt ; seqi++)) ; do  echo -ne "<(fasta_item $seqi $fastafile 2> /dev/null)\0000"  ; done  | xargs -0 -i /usr/local/bin/bash -c "'$cmd'" ;
#xargs -i /usr/local/bin/bash -c  $cmd \; ;
# -i bash -c $@
}

function readseq { 
    # PURPOSE: extract selected records from fasta file
    # USAGE `fasta_item 3,5 ./Hox_Petromyzon_marinus.fa`
    java -cp /n/facility/Bioinformatics/Software/Readseq/readseq.jar run   -pipe $@
    #f=fasta -pipe informat=fa format=fa -item=$@ ;
}

function llpfind {
    # PURPOSE: search $LD_LIBRARY_PATH 
    # RAISON D'ETRE: $LD_LIBRARY_PATH, being colon-delimited, is not
    # suitable argument for the unix `find` command.
    # EXAMPLE: 
    #     llpfind -name libreadline.*
    #     llpfind -name '*libz*'
    find ${LD_LIBRARY_PATH//:/ } /lib /usr/lib /usr/lib64 -maxdepth 1    $@  -print
}

export -f llpfind

# function flockOutputEval {

# # PURPOSE: append to file <appendingTo> ($1) the result of running
# # <cmdToEval> ($2..n) , but only after the command has completed (with
# # results having been accumlated in a temporary file which gets
# # deleted after its contents are appended).

# # flockOutputEval /tmp/$$.lockme 'testout' 'ls'

# LOCKFILE=$1 ;
# appendingTo=$2 ;
# shift 2 ;
# cmdToEval=$@ ;
# TMPFILE=`mktemp -t flockOutputEval.XXXXXXXXXX` || return;
# #echo "TMPFILE=$TMPFILE" ;
# #echo "cmdToEval=$cmdToEval" ;
# eval "$cmdToEval" "> $TMPFILE" || return;
# flock $LOCKFILE -c 'cat $TMPFILE >> "$appendingTo"' ;
# rm -f $TMPFILE ; 
# }

# function flockOutputEval {

# # PURPOSE: append to file <appendingTo> ($1) the result of running
# # <cmdToEval> ($2..n) , but only after the command has completed (with
# # results having been accumlated in a temporary file which gets
# # deleted after its contents are appended).

# # flockOutputEval /tmp/$$.lockme 'testout' 'ls'

# LOCKFILE=$1 ;
# appendingTo=$2 ;
# shift 2 ;
# cmdToEval=$@ ;
# TMPFILE=`mktemp -t flockOutputEval.XXXXXXXXXX` || return;
# #echo "TMPFILE=$TMPFILE" ;
# #echo "cmdToEval=$cmdToEval" ;
# eval "$cmdToEval" "> $TMPFILE" || return;
# flock $LOCKFILE --command 'cat $TMPFILE >> "$appendingTo"' ;
# rm -f $TMPFILE ; 
# }

function nth {
 # PURPOSE: After an optional -h lines of header (which are echoed
 # unless supressed with <-sh>), echo every <-n>th line (default:
 # every 1 line) starting with the <-m>th (counted from zero, starting
 # with the first line after the header, default: starting with the
 # <n-1>th line.
 # 
 # EXAMPLE: nth -h=1 -sh -n=5 foo.tab > foo_every_fifth_line_after_the_one_line_header.tab
# set -e ;
 perl -snwe 'BEGIN{our $n||=1; our $m=($n-1) unless defined($m); our $h||=0; die "required: m < n" unless $m < $n; our $sh} print $_ if (($. > $h ) ? (($. -1 - $h) % $n == $m) : ! $sh)' -- $@
}

## nth renamed slice below and changed to 1-based indexing:

function slice {
 # PURPOSE: After an optional -h lines of header (which are echoed
 # unless supressed with <-sh>), echo every <-n>th line (default:
 # every line) starting with the <-m>th (counting from 1, starting
 # with the first line after the header, default: starting with the
 # <n-1>th line.)
 # AUTHOR: malcolm_cook@stowers.org
 # EXAMPLE: slice -h=1 -sh -n=5 foo.tab > foo_every_fifth_line_after_the_one_line_header.tab
# set -e ;
 perl -snwe 'BEGIN{our $n||=1; our $m=($n) unless defined($m); $m-=1; our $h||=0; die "required: m < n" unless $m < $n; our $sh} print $_ if (($. > $h ) ? (($. -1 - $h) % $n == $m) : ! $sh)' -- $@
}
export -f slice

function tmpflockappend {
# PURPOSE: cat all of STDIN to temporary file.  When done, append all
# of it to <appendingTo> and delete the temp file (except skip ${H}
# header lines all but the first time).
# set -e ;
local H=$1 ;
local APPENDTO=$2 ;
shift 2 ;
local MKTEMPARGS=$@;
# TMPFILE=`mktemp -p ./ -t tmpflockappend.$$.XXXXXXXXXX` || return;
 TMPFILE=`mktemp ${MKTEMPARGS}` || return;
# echo TMPFILE = $TMPFILE > /dev/stderr
cat > $TMPFILE ;  # cat doesn't return until EOF on STDIN
# echo cat complete of $TMPFILE > /dev/stderr
# echo flocking for ${TMPFILE} > /dev/stderr ;
# flock $APPENDTO --command "cat $TMPFILE >> $APPENDTO" ;
flock $APPENDTO --command \
  "if [[ ! -s $APPENDTO ]] ; then cat $TMPFILE > $APPENDTO ; elif [[ 0 == ${H} ]] ; then cat $TMPFILE >> $APPENDTO ; else tail --lines=+$(( 1 + ${H} )) $TMPFILE >> $APPENDTO ; fi"  ;
# echo flock complete of $TMPFILE > /dev/stderr
 rm -f $TMPFILE ; 
}


function seqargsflock  {
# divide <INF> into separate blocks, each containing <N> lines
# (preceeded by <H1> header lines).  Process each block as a STDIN to
# command <CMD>, running across upto <P> simultaneous processes, and
# appending their outputs into a single <OUTF> (minus <H2> header
# lines remvoed from all but the first).
#    set -e ;
    local N=$1 ;
    local P=$2 ;
    local H1=$3 ;
    local H2=$4 ;
    local INF=$5 ;
    local OUTF=$6 ;
    shift 6 ;
    local CMD=$@ ;
    rm -f $OUTF ;
    #seq 0 $(( ${N} - 1 )) | \
    eval 'printf "%s\n"' {1..$(( ${N} - 1 ))}
	xargs -P ${P} -i bash -c \
	"nth -h=${H1} -n=${N} -m={} \"${INF}\" | ${CMD} | tmpflockappend ${H2} \"${OUTF}\""
}

# function test1 {
#  echo N > zeroTo1000.txt ;
#  seq 0 100 >> zeroTo1000.txt ;
#  seqargsflock 20 0 1 1 zeroTo1000.txt zeroTo1000_copy.txt cat ;
# # rm -f zeroTo1000_copy.txt ;
# # seq 0 20 |  xargs -P 0 -i bash -c 'nth -h=1 -n=19 -m={} zeroTo1000.txt | cat  | tmpflockappend zeroTo1000_copy.txt'
#  diff <(wc zeroTo1000_copy.txt) <(wc  zeroTo1000.txt) ;
# }

#t1;



# 1001 1001 3895 zeroTo1000_copy.txt
# mec@genekc03> wc zeroTo1000.txt 
# 1001 1001 3895 zeroTo1000.txt
# mec@genekc03> rm -f zeroTo1000_copy.txt 

function flockappend { local APPENDTO=$1 ; shift ; flock $APPENDTO --command "cat $@ >> $APPENDTO"; }


function peval {
# PURPOSE: shortcut for xargs idiom which evals successive lines from
# standard input in parallel using $1 processes.
#
# EXAMPLE: echo the date 20 times, 10 at a time:
    # for i in {0..19} ; do cmd="'{ sleep 1; echo $i \`date\` ; }'" && echo $cmd ; done | peval 10
#
local P=$1 ;
shift;
xargs -P $P -L 1 bash --noprofile --norc -c 'eval "$@"' --  ;
}


# simplest case
# bash -c "flockOutputEval /tmp/flock.13948 testout '{ sleep 1; echo 1234 ; }'"
# now put in a loop:
# for i in {0..2} ; do cmd="flockOutputEval /tmp/flock.$$ testout \'{ sleep 1; echo $i ; }\'" && echo $cmd ; done |  xargs -P 0 -L 1 bash -c 'eval $@' --
# use peval instead:
# for i in {0..2} ; do cmd="flockOutputEval /tmp/flock.$$ testout \'{ sleep 1; echo $i ; }\'" && echo $cmd ; done |  peval 10
# add in the date
# for i in {0..19} ; do cmd="flockOutputEval /tmp/flock.$$ testout \'{ sleep 1; echo $i \`date\` ; }\'" && echo $cmd ; done | peval 10



##  TRYING TO PUT peval and flockOutputEval TOGETHER
## 
## function pevalflockout {
## P=$1 ;
## appendingTo=$2 ;
## LOCKFILE=`mktemp -t peval.XXXXXXXXXX` || return ;
## shift 2 ;
## echo xargs -P $P -L 1 bash --noprofile --norc -c "eval flockOutputEval '$LOCKFILE' '$appendingTo' '$@'"  --  ;
## #xargs -P $P -L 1 bash --noprofile --norc -c 'eval flockOutputEval "$LOCKFILE" "$appendingTo" "$@"'  --  ;
## }


#for i in {0..19} ; do cmd="\'{ sleep 1; echo $i \`date\` ; }\'" && echo $cmd ; done | pevalflockout 10 delme


function joinlines {
	 # PURPOSE: echo lines appear on stdin to stdout joined with delimiter $1 (instead of linefeeds)
	 # EXAMPLE: create comma delimited string of 'fsa' files in current working directory:
	 #          ls -1 *.fsa | joinlines ','
	 local DELIM=$1 ;
	 shift;
	 perl -s -F'\n'  -0ape '$_=join($d,@F)' -- -d=${DELIM} $@ ;
}






################################################################################
### SUN GRID ENGINE RELATED
################################################################################
function xxxxxasdf {
    local FINDARG=$1;
    local QSUBARG=$2;
    shift 2;
    find $FINDARG -print0 |  xargs -0 -I{} qsub -j y -o /dev/null -terse -shell n  -cwd -b y $@
}

################################################################################

# rw: my (recent) work
export MRWPATH=/n/projects/mec/ShilatifardLab/analysis

function mrw {
    ##local spec="${@--name \"*.org\"}"
    ##echo ${spec} > /dev/stderr
    ##shift ;
    #find  ${MRWPATH} -user ${USER} ${spec} # | xargs ls -t -1 | tac
    ##find  ${MRWPATH} -user ${USER} ${@--name '*.org'}    | xargs ls -t -1 | tac
    find  ${MRWPATH} -user ${USER} -name '*.org'    | xargs ls -t -1 | tac
    # local cmd="find  ${MRWPATH} -user ${USER} ${spec} | xargs ls -t -1 | tac"
    # /bin/echo ${cmd} > /dev/stderr
    # eval ${cmd}
} 

################################################################################
alias p=parallel

# function aog { 
#     find  ${LOOKHERE} -user ${USER} -name '*.org' | xargs ls -tl | parallel  grep -H "$@"

#     ##find  /n/projects/mec/ShilatifardLab/analysis -name '*.org' | parallel -q bash -c 'grep -H "$@"'
# }
# export -f aog



function doi2bibtex {
    ## EXAMPLE: doi2bibtex '10.1016/j.bbr.2011.03.031'
    local doi=$1
    shift
    curl -LH 'Accept: application/x-bibtex' "http://dx.doi.org/${doi}"
}


function rdt {
  # R data.table used to filter stdin
  Rscript --vanilla --default-packages=data.table,utils -e "dt=fread('file:///dev/stdin')" -e "invisible(write.table("$@",file=stdout(),quote=FALSE,sep='\t',row.names=FALSE))"
  #EXAMPLE: 
  # (echo 'x' & seq 5) | dt 'colSums(dt)'

 # seq 10 | Rscript --default-packages=utils,data.table   -e "print(read.table(pipe('cat /dev/stdin')))"
}


function rtab {
    ## Purpose: write to stdout the tab-delimited table resulting from
    ## evaluating a single R expression ($1) with "x" set to a
    ## data.frame read from stdin using read.table().  Arguments beyond $1 are passed to read.table ( usefull for header=TRUE,as.is=TRUE)
    ##
    ## EXAMPLE: (echo '' & seq 5) | rtab 'summary(x)' header=TRUE 
    local expr=$1
    local readTableArgs=$2
    shift 2
    Rscript --vanilla \
	    -e "x=read.table('file:///dev/stdin',"${readTableArgs}")" \
	    -e "invisible(write.table("${expr}",file=stdout(),quote=FALSE,sep='\t',row.names=FALSE))"
    #EXAMPLE: 
    # (echo 'x' & seq 5) | dt 'colSums(dt)'
    # seq 10 | Rscript --default-packages=utils,data.table   -e "print(read.table(pipe('cat /dev/stdin')))"
}
