#!/bin/bash

function printUsage {
    echo "generate-rules-for-web-highlighting.sh html5-char-ent-refs|css3-colors"
    echo
}

url_address=
grep_regexp=
sed_regexp=
rule_line_prefix=
rule_line_postfix=
make_unique=

case $1 in
    html5-char-ent-refs)
        url_address=https://www.w3.org/TR/html5/entities.json
        grep_regexp='&[^;]+;'
        sed_regexp='s/^\&//;s/;$//'
        rule_line_prefix='CHARREF:    "&('
        rule_line_postfix=');"'
        make_unique=false
        ;;
    css3-colors)
        url_address=https://www.w3.org/TR/css3-color
        grep_regexp='"background:\s*[A-Za-z]+"'
        sed_regexp='s/"background:\s*//g;s/"//g'
        rule_line_prefix='~ESCAPE:    "(^|\*/|[[:space:]:])('
        rule_line_postfix=')([[:space:];]|/\*|$)"'
        make_unique=true
        ;;
    *)
        printUsage
        exit 1
esac

curl -L --silent $url_address | grep -Eoh "$grep_regexp" | sed --expression="$sed_regexp" | ([[ "$make_unique" == "true" ]] && sort -u || cat) | {
    rule_line=""

    while read line
    do
        new_line="${rule_line}|${line}${rule_line_postfix}"
        if [[ "${#new_line}" -gt 120 ]]
        then
            echo "${rule_line}${rule_line_postfix}"
            rule_line=""
        fi

        if [[ -z "$rule_line" ]]
        then
            rule_line=$rule_line_prefix
            rule_line="${rule_line}$line"
        else
            rule_line="${rule_line}|$line"
        fi
    done

    echo "${rule_line}${rule_line_postfix}"
}
