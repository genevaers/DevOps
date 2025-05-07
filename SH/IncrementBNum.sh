#!/bin/bash
touch temp.txt;
touch lst.txt;
rm temp.txt;
rm lst.txt;
tsocmd "LISTDS '$GERS_BUILD_HLQ.PM$BUILD_VERSION$BUILD_MAJOR$BUILD_MINOR.*.GVBLOAD';" > lst.txt;
x=$?;
if test $x -eq 0 ; then
 echo $x;
. INCRBLD.sh;
else
    if test $x -eq 8 ; then
       export BUILD_NBR="0000";
    else
        cat lst.txt;
        echo "*** Process Terminated in IncrementBNum.sh ***" ;
    fi
fi
echo "HLQ for this build: $GERS_BUILD_HLQ.PM$BUILD_VERSION$BUILD_MAJOR$BUILD_MINOR.$BUILD_NBR";