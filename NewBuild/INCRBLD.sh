#!/bin/bash

#### THIS SCRIPT MUST BE DOTTED IN TO EXECUTE INLINE WITH CALLING SCRIPT
####
#### IT PROCESSES THE OUTPUT OF AN MVS DATASET LIST
####
####  tsocmd "LISTDS 'GEBT.NEILB.PM501001.*.GVBLOAD'"

# Find last index of test we're searching for
endidx=$(awk -F".GVBLOAD" '{print length($0) - length($NF)}' < "lst.txt");
echo "Ending index $endidx";

# Calculate starting index
startidx=$((endidx-12));
echo "startidx $startidx";

# Extract numerical value after "B"
bnumber=$(awk '{print substr($0,'$startidx',13)}' "lst.txt");
echo "Build number and GVBLOAD string: $bnumber";

# === DISABLED AS I CAN'T GET SQUARE BRACKETS TO WORK ON USS

# Extract the corresponding B000n part that precedes .GVBLOAD
# if [[ $bnumber == *([B][0-9][0-9][0-9][0-9])* ]]; then
#     echo "Matched pattern B000n.GVBLOAD: $bnumber";
# else
#     echo "No match found";
# fi

echo "bnumber $bnumber";

number=$(expr substr "$bnumber" 2 4);

echo "Last build number: $number";

nextnumber=$(echo "$number" | awk '{ printf "%04.0f\n", $1+1 }');
echo "Next build qualifier: B$nextnumber";

export BLD_Nbr=B$nextnumber;
