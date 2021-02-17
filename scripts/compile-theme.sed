# remove excess whitespace
s/#.*$//
s/^[[:space:]]+|[[:space:]]+$//
/^[[:space:]]*$/d
s/^[[:space:]]+|[[:space:]]+$//

# convert statements to substitutions
s/^([^[:space:]]+)[[:space:]]+([^[:space:]]+)$/s|^\1:|color \2|/

# add case-insensitive variants
s/((s\|\^)(.*))/\1\
\2~\3/i