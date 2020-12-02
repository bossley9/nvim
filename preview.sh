#!/bin/sh

# $1 represents the matching line
# $2 represents the query typed (unused in this situation)
# $3 represents the number of terminal rows

# set shell delimiter to colon
OIFS="$IFS"
IFS=:

# extract variables
arr=($1)
file="${arr[0]}"
# line="${arr[1]}"
# col="${arr[2]}"
[ -z "$col" ] && col=0
str="${arr[3]}"
# query="$2"
rows="$3"

# number of lines surrounding match preview
padding="$(( (($rows - 1) / 2) - 1 ))"

grep -i --color=always "$str" -A "$padding" -B "$padding" -n "$file"

# reset shell delimiter
IFS="$OIFS"
