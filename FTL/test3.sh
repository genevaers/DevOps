#!/bin/bash

####  tsocmd "LISTDS 'GEBT.NEILB.PM501001.*.GVBLOAD'"

# Find last index of test we're searching for
len=$(awk -F".GVBLOAD" '{print length($0) - length($NF)}' < "tstlist.txt");
echo "len $len";

# Calculate starting index
startidx=$((len-12));
echo "startidx $startidx";

# Extract numerical value after "B"
# bnumber=$(awk '{print substr($0,'$startidx',5)}' "tstlist.txt");
bnumber=$(awk '{print substr($0,'$startidx',13)}' "tstlist.txt");
echo "Build number and GVBLOAD string: $bnumber";

# Extract the corresponding B000n part that precedes .GVBLOAD
if [[ $bnumber == *([B][0-9][0-9][0-9][0-9])* ]]; then
    echo "Matched pattern B000n.GVBLOAD: $bnumber";
else
    echo "No match found";
fi

number=${bnumber:1:4};
echo "Last build number: $number";

nextnumber=$(echo "$number" | awk '{ printf "%04.0f\n", $1+1 }');
echo "Next build qualifier: B$nextnumber";

export BLD_Nbr=B$nextnumber;
