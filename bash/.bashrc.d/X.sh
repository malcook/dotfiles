export TERM=xterm-256color
function xclip2org {
##    xclip -o -t TARGETS | grep -q text/html && (xclip -o -t text/html | iconv -t UTF-8 | pandoc -f html -t json | pandoc -f json -t org | iconv -f UTF-8) || xclip -o ;
       xclip -o -t text/html | iconv -t utf-8 | pandoc -f html -t json | pandoc -f json -t org | iconv -f utf-8
}
