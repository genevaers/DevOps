#!/bin/bash
touch temp.txt;
touch lst.txt;
rm temp.txt;
rm lst.txt;
tsocmd "LISTDS '$GERS_BUILD_HLQ.PM$GERS_BUILD_VERSION$GERS_BUILD_MAJOR$GERS_BUILD_MINOR.*.GVBLOAD';" > lst.txt 2> $err_log;
x=$?;
if test $x -eq 0 ; then
# echo $x;
. IncrementBuildNum.sh;
else
    if test $x -eq 8 ; then
       export BUILD_NBR="0000";
    else
        cat lst.txt;
        echo "$(date) ${BASH_SOURCE##*/} *** Process Terminated in IncrementBNum.sh ***" ;
    fi
fi
echo "$(date) ${BASH_SOURCE##*/} HLQ for this build: $GERS_BUILD_HLQ.PM$GERS_BUILD_VERSION$GERS_BUILD_MAJOR$GERS_BUILD_MINOR.B$BUILD_NBR" | tee -a $out_log;
