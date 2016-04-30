#!/bin/bash

curl --silent https://www.w3.org/TR/html5/entities.json | grep -oh '\&[^;]\+;' | sed --expression='s/^\&//;s/;$//' | {
    rule_line=""

    while read line
    do
        new_line="${rule_line}|${line});\""
        if [[ "${#new_line}" -gt 120 ]]
        then
            echo "${rule_line});\""
            rule_line=""
        fi

        if [[ -z "$rule_line" ]]
        then
            rule_line='CHARREF:    "&('
            rule_line="${rule_line}$line"
        else
            rule_line="${rule_line}|$line"
        fi
    done

    echo "${rule_line});\""
}
