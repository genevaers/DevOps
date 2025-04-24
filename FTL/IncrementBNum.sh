#!/bin/bash
touch temp.txt;
touch lst.txt;
rm temp.txt;
rm lst.txt;
tsocmd "LISTDS '$GERS_BUILD_HLQ.PM$BLDVER$BLDMAJ$BLDMIN.*.GVBLOAD';" > lst.txt;
x=$?;
if test $x -eq 0 ; then
 echo $x;
. INCRBLD.sh;
else
    if test $x -eq 8 ; then
       BLDNBR="0000";
    else
        cat lst.txt;
        echo "*** Process Terminated in IncrementBNum.sh ***" ;
    fi
fi
echo "Next number: $BLDNBR";