# remove excess whitespace
s/#.*$//
s/^[[:space:]]+|[[:space:]]+$//
/^[[:space:]]*$/d
s/^[[:space:]]+|[[:space:]]+$//

# convert statements to substitutions
s/^([^[:space:]]+)[[:space:]]+([^[:space:]]+)$/s|^\1:|color \2|/

# legacy substitution-patterns allowed in theme
#s/s\|\^([^:]+):\|([^\|]+)\|/&\ns|^~\1:|i\2|/
