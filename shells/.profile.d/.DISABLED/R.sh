function rnews {
    ## EXAMPLE: find R libraries updated in last 3 days and head the NEWS file, if any:
    ## > rnews -mtime -3
    ##
    ## NOTE: often released packages have bug-fixes which are not
    ## recorded in the NEWS file.  TODO: contrive to query the
    ## subversion repo for commits from the last same time period.
    find /n/local/stage/r/R-3.0.2/install/lib64/R/library/* -maxdepth 0  ${@} | parallel -j 1 'echo {} & head {}/NEWS'
}
