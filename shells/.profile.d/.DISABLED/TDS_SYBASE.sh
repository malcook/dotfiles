################################################################################
#used by TDS and http://www.freetds.org/userguide/envvar.htm

#################################################################################
#SYBASE initializations for bash
#source /var/spool/sybase/products/SYBASE.sh
#which defines  SYBASE=/var/spool/sybase/products

#location of sybase libraries.  TODO: express as architecture dependent!
#export SYBASE=/n/site/inst/Linux-i686/sys/ 

export TDSQUERY=SQLDEV01
export DSQUERY=SQLDEV01

#to monitor / log the effect of tds option processing:
export TDSDUMPCONFIG=~/.TDSDUMPCONFIG
