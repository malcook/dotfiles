#set -a # export these functions!

function fastaLackingInitialMet {
    ## find fasta entries in stdin lacking initial Met (M) using grep.
    ## Display the defline and the first line of sequence.
    grep  --no-group-separator -A 1 '>' "$@"  | grep  --no-group-separator -B 1 -P '^[^>M]' | grep '^>'
     ##| grep -i  --no-group-separator -A 1 hox
}

function gffoffset {
    seqid=$1
    offset=$2;
    shift 2;
    perl -e  'my ($seqid, $offset);  ($seqid, $offset, @ARGV) = @ARGV;  $"="\t"; while (<>) {my @F = split; $F[0]=$seqid; $F[3] += $offset ;$F[4] += $offset; print "@F\n"}' $seqid $offset $@ ;
}

##alias gffsort="sort --field-separator='	' --key=1,1 --key=4,5n"
##alias gffmerge="sort --merge --field-separator='	' --key=1,1 --key=4,5n"

function gffsort {
    ### Used by: /n/facility/Bioinformatics/analysis/Yu/v1r/README.sh
    ###
    ### NB: --merge can be provided.  Also, sort allows --out to be
    ### provided as same file as in, which works without corruption.
 /home/mec/local/src/coreutils-8.6/src/sort --field-separator='	' --key=1,1 --key=4,5n $@ ;
}

function gffseqoffset {

# PURPUOSE: stream-edit GFF lines whose first column contains seqid
# with embedded coordinates to add the start coordinates to the GFF
# start and end values.  

# TODO: ignore ill-formed GFF lines (like comments, blanks)?

# TODO?:

# INPUT: GFF looking like:
#chr9:44549350-44637269	Fgenesh	GenePrediction1	1061	5829	.	-	. ID=chr9:44549350-44637269_fgenesh_1
#chr9:44549350-44637269	Fgenesh	Poly_A_site	1061	1061	0.93	-	. Parent=chr9:44549350-44637269_fgene
# OUTPUT:
#chr9	Fgenesh	GenePrediction1	44550411	44555179	.	-	.	ID=chr9:44549350-44637269_fgenesh_1
#chr9	Fgenesh	Poly_A_site	44550411	44550411	0.93	-	.	Parent=chr9:44549350-44637269_fgenesh_1
    # $F[8] =~ s/$F[0]//;
    perl -lane 'die "1st GFF column: $F[0] $seqid, $start, $stop" unless (($seqid, $start, $stop) = ($F[0] =~ m/^(\w+):(\d+)-(\d+)$/)); $start -= 1;  $F[0] = $seqid; $F[3] += $start; $F[4] += $start;$,="\t";print @F' $@
}


function exonerateGFF {
    ## extract uncommented portion of GFF from exonerate output
    ##
    ## Used by: /n/facility/Bioinformatics/analysis/Yu/v1r/README.sh
    perl -ne 'print if ($range = m/^# --- START OF GFF DUMP ---/...m/^# --- END OF GFF DUMP ---/) && ($range ne 1) && ($range !~ /E0$/) && ! m/^#/'  $@
}


#perl -MTFBS::DB::LocalTRANSFAC -e 'print TFBS::DB::TRANSFAC->connect( -accept_conditions => 1)->get_Matrix_by_acc("M00001","PWM")->rawprint'

function TFMatID2 {
 # PURPOSE: convert a transfac matrix into one of the formats: position frequency (PFM) matrix
 # position weight matrix (PWM) or Information Content Matrix (ICM).  $2, if supplied, is common prefix for a file to put 
 # each matrix in.
 # EXAMPLE: echo 'M00001' | TFMatID2 'pwm' './' #creates a file named M00001.pwm whose contents are the pwm
 perl -w -MTFBS::DB::LocalTRANSFAC -ne 'BEGIN{our $localdir = shift; our $db = TFBS::DB::LocalTRANSFAC->connect(-accept_conditions => 1, -localdir => $localdir ); our $fmt = shift; our $o = shift;} chomp; open(STDOUT,">","${o}${_}\.${fmt}") if $o;  print STDOUT $db->get_Matrix_by_acc($_,$fmt)->rawprint;'  --  $TRANSFAC/data $@
}

function TFmatrix2files {
 # PURPOSE: print Transfac matrix identifiers
 # EXAMPLE: create directory of position weight matrices for each transface matrix, named after the ID
 # mkdir  $TRANSFAC/data/pfm
 # TFmatrix2files pfm "$TRANSFAC/data/pfm/"
  perl -ne 'print "$1\n" if m/^AC\s*(.*)/' $TRANSFAC/data/matrix.dat | TFMatID2 $@
}

function faunwrapseq {
  # PURPOSE: "unwrap" the sequence of fasta file(s) so that all
  # sequence is on one line. (remove trailing linefeeds except: those
  # at end of deflines, those immediately preceeding deflines, or the
  # one at the end of file)
  # 
  # OPTIONS: -i : perlform edit fasta file in-place (and nothing to stdout)
  #           with no other options, unwrap stdin, otherwise  
  # EXAMPLE faunwrapseq -i myseq.fa
   perl -0 -p -e 's/^([^>][^\n]*)\n(?!>)(?=.)/$1/gims;' $@ 
}


function fatab {
    ## PURPOSE: create 'tab' version of input fasta, appending all sequence to the defline after a tab
    ##
    ## EXAMPLE: tab -i myseq.fa
   perl -0 -p -e 's/^([^>][^\n]*)\n(?!>)(?=.)/$1/gims; s/^(>[^\n]*)\n/$1\t/gms; ' $@ 
}


function demo_molecular_weight {
    ## purpose: output tab delimited table of computed molecular
    ## weights (least and greatest) for peptides in a fasta file
    ##
    ## example: echo -e ">asdf\nMAG" | demo_molecular_weight
    bioio --Module Bio::Tools::SeqStats --inopt format=fasta -n -e 'local ($,,$\)=("\t","\n"); print $_->display_id, @{Bio::Tools::SeqStats->new($_)->get_mol_wt};' 
}



################################################################################
### UCSC Genome Browser RELATED
################################################################################
#query ucsc genome browser for track data, example (flyBaseGene from dm2 for 
#c.f. /n/facility/Bioinformatics/analysis/Workman/VMW/Lsp1alpha/Makefile
#POSITION=ChrX:100000-120000; wget --progress=dot "http://genome.ucsc.edu/cgi-bin/hgTables?db=dm2&hgta_compressType=none&hgta_outputType=gff&outGff=1&hgta_regionType=range&hgta_table=flyBaseGene&hgta_track=genscan&position=${POSITION}&submit=submit&hgta_doTopSubmit=1" -O '-'

#perl -an -e '$F[0]~=s/^(\d+\t)/chr$1/;$F[5]=~s/^1$/+1/' dmel_4_asa.bed 

################################################################################
### QUERY A DAS SERVER
################################################################################

# example query DAS server for sequence data (hardcoded to ucsc genome
# browser) (allows maximum 1 hit every 15 seconds, 5K hits per day)

# function DASdna { perl -MBio::Das -pe 'BEGIN {$das = Bio::Das->new(-source => "http://genome.ucsc.edu/cgi-bin/das/", -dsn=>"hg18") || die "could not connect: $!";}  $_ = ($das->segment($_) || die "no segement for $_: $!")->dna;' ; }

################################################################################
function vntigff_fuzztran { 
# search genbank formatted nucleotide sequence for protein motif,
# producing gff output suitable for Vector NTI consumption (i.e. having in column 9 a 'lable' and and 'vntifkey')
# changing the misc feature
# (It uses emboss' fuzztran http://emboss.sourceforge.net/apps/release/4.0/emboss/apps/fuzztran.html)
# usage:  vntigff_fuzztran vntifkey pattern frame <more fuzztran args>
# TIPS: 
#  * uses perl -s to pass vntifkey and pattern as switches to perl.
#  * hardcodes the  -filter -auto -rformat gff arguments to fuzztran.
#  * recodes gff column 3 to be 'match', and throws out fuzztran's normal column 9 feature attribute notes.
#  * passes <more fuzztran args> to fuzztran (useful values --table (for codon table) --pmismatch (percent allowed mismatch: 0-100))
#vntifkey=$1; pattern=$2; frame=$3; fuzztran -filter -auto -rformat gff -pattern $pattern -frame $frame | perl -a -F'\t' -p -s -e  'next unless $#F == 8; $F[2]="match";  $F[8]="label $p ; vntifkey $v"; $_ = join("\t", @F) ' -- -p=$pattern -v=$vntifkey ;
vntifkey=$1; pname=$2; pattern=$3; shift 3; 
fuzztran -filter -auto -rformat gff -pattern $pattern -pname $pname $@ | 
perl -a -F'\t' -p -s -e  'next unless $#F == 8; $F[2]="match";  $F[8]="label $p ; vntifkey $v"; $_ = join("\t", @F) . "\n" ' -- -p=$pname -v=$vntifkey ;
}


function famers {
    ## PURPOSE: 'shred' a multi-fasta file into all reads of size N
    ## offset 1 bp at a time.
    ##
    ## Edit splitter's output format to reformat the defline to be of
    ## the form: <IDENTIFIER>:<START>-<END>
    local N=$1 ;
    shift ;
    splitter -filter -osformat2 fasta -size ${N} -overlap $((${N} - 1)) "$@" | perl -p -e 's/>(.*)\_(\d+)\-(\d+)/>$1:$2-$3/'
}

function fastaSubsetByIndex {
# extract subset of fasta sequences on STDIN to STDOUT
# USAGE: extract fasta records 1,2,3 and 6 from my.fasta 
#	 > fastaSplice 1-3,6 my.fasta
    local indices=$1
    shift;
    perl -MSet::IntSpan -wsne 'BEGIN{$r=Set::IntSpan->new("0,$r");$r->first}; if (m/^>/) {$current++; if ($current > $r->current) {$r->next; $rcurrent = $r->current; last unless $rcurrent}}; print if $rcurrent == $current' -- -r=${indices}
}



#function Rcolsum perl -n -e '$x += $_; END{print("$x\n")}

#Rscript -e 'colSums(read.csv("stdin"))'
