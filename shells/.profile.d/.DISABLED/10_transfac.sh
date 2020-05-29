
export TRANSFAC=/n/data1/biobase/transfac/current

function transfacmatch {
## documented in ${TRANSFAC}/match/doc/Match_command_line.txt
${TRANSFAC}/match/bin/match $@ ;
}
export -f transfacmatch

function transfacpatsearch {
## documented in ${TRANSFAC}/patch/doc/Patch_command_line.txt
${TRANSFAC}/patch/bin/patsearch $@ ;
}
export -f transfacpatsearch
