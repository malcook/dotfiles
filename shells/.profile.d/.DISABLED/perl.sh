alias reperl='perl -de0'


#- useful while developing
#setenv PERL5LIB="~/PerlModule/:$PERL5LIB"
#setenv PERL5LIB="./blib/lib/:$PERL5LIB"

#export PERL5OPT=-MCarp::Always
#export PATH="~/cvs/bioperl-live/scripts/Bio-DB-GFF:${PATH}"
#export PATH="~/cvs/bioperl-live/scripts/Bio-SeqFeature-Store:${PATH}"
#~/cvs/bioperl-live/scripts/Bio-SeqFeature-Store/
#export PATH="~/cvs/bioperl-live/scripts/searchio:${PATH}"
export PERL5LIB="~/svn/bioperl-live:${PERL5LIB}" 
#export PERL5LIB="~/svn/bioperl-network:${PERL5LIB}" 
#export PERL5LIB="~/cvs/TFBS:${PERL5LIB}" 
#export PERL5LIB="~/cvs/ensembl/modules:${PERL5LIB}" 
export PERL5LIB="~/svn/bioperl-ext:${PERL5LIB}" 
#export PERL5LIB="~/svn/bioperl-db:${PERL5LIB}" 
#export PERL5LIB="~/svn/biosql-schema:${PERL5LIB}" 
#export PERL5LIB="./:${PERL5LIB}" 


################################################################################
# c.f. `man DBI`
#          As a convenience, if the $data_source parameter is undefined or
#        empty, the DBI will substitute the value of the environment variable
#        "DBI_DSN". If just the *driver_name* part is empty (i.e., the
#        $data_source prefix is ""dbi::""), the environment variable
#        "DBI_DRIVER" is used. If neither variable is set, then "connect"
#        dies.
export DBI_DSN='DBI:mysql:test;host=mysql-dev'
export DBI_DRIVER='mysql:test;host=mysql-dev'
# export DBI_AUTOPROXY
export DBI_USER mec
export DBI_PASS mec
# export DBI_TRACE
# export DBI_PROFILE
# export DBI_PUREPERL
# c.f. as used by perl module Config::DBI
export DBI_CONF=$HOME/.dbirc
# dbish 'dbi:mysql:test;host=mysql-dev' mec mec



################################################################################
# SBEAMS 

#- useful while developing
# export PERL5LIB="/home/mec/PerlModule/:$PERL5LIB"
# export PERL5LIB="./blib/lib/:$PERL5LIB"

# export PATH="/home/mec/cvs/bioperl-live/scripts/Bio-DB-GFF:${PATH}"
# export PATH="/home/mec/cvs/bioperl-live/scripts/searchio:${PATH}"
# export PERL5LIB="/home/mec/cvs/bioperl-live:$PERL5LIB" 
# export PERL5LIB="/n/facility/Bioinformatics/analysis/Genomics/GenotypingDataMgmt:$PERL5LIB" 
# export PERL5LIB="/home/mec/cvs/TFBS:$PERL5LIB" 
# export PERL5LIB="/home/mec/cvs/ensembl/modules:$PERL5LIB" 


# export PERL5LIB="/home/mec/cvs/bioperl-ext:$PERL5LIB" 
# export PERL5LIB="/home/mec/cvs/bioperl-db:$PERL5LIB" 
# export PERL5LIB="/home/mec/cvs/biosql-schema:$PERL5LIB" 

# #do this only if perl gets upgraded and the new libs were not upgraded at the same time...
# export PERL5LIB="/n/site/inst/shared/sys/lib/perl5/site_perl/5.8.6/i686-linux-thread-multi-ld/:$PERL5LIB"
