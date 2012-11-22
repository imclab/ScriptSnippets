#!/bin/sh

INSTANCE=$1

# convert "word*here" instance input to the actual instance number
if [[ $INSTANCE =~ word(.*)here ]]
then
        echo "${BASH_REMATCH[1]}"
fi