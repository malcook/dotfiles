function grepwork () {
    ## on beta is mounted	    /n/genekc07/Users/lab_project/**/**/ 
	parallel -j 10 -k grep -PHi "$@" :::: <(
	    find \
		/home/mec/project/ \
		/n/projects/mec/ShilatifardLab/analysis/**/**/ \
		/n/core/Bioinformatics/analysis/**/**/ \
		-maxdepth  2 \
		-type  f \
		-regextype  posix-extended \
		-iregex  '.*(org|rmd|r|sh|md|mk|rnw)' -o -iregex 'makefile|readme'
	) ;
}


export grepwork
