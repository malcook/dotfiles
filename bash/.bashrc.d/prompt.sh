# Make the bash prompt colorful.  
Black='\e[0;30m'        # Black 
Red='\e[0;31m'          # Red 
Green='\e[0;32m'        # Green 
Yellow='\e[0;33m'       # Yellow 
Blue='\e[0;34m'         # Blue	
Magenta='\e[0;35m'      # Magenta 
Cyan='\e[0;36m'         # Cyan	
White='\e[0;37m'        # White 
NC='\e[0m'		# No color
export PROMPT_DIRTRIM=2
export PS1="\[$Red\]\u\[$Blue\]@\[$Green\]\h\[$Magenta\] \w\[$NC\]$ "
