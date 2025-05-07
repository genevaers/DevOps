#!/bin/sh

FILE="lst.txt"; # File to parse to get highest build number

if [ ! -f "$FILE" ]; then
  echo "Error: File '$FILE' not found.";
  exit 1;
fi

while IFS= read -r line; do
  # Process each line (record) here
  # echo "Record: $line";

  # Find last index of test we're searching for
  echo $line > temp.txt;
  endidx=$(awk -F".GVBLOAD" '{print length($0) - length($NF)}' "temp.txt" );
  # echo "Endidx: $endidx";

  if [ $endidx -gt 0 ]; then

    # Calculate starting index
    startidx=$((endidx-12));
#    echo "startidxi :startidx";

    # Extract numerical value after "B"
    bnumber=$(awk '{print substr($0,'$startidx',13)}' "temp.txt" );
#    echo "Build number and GVBLOAD string: $bnumber";
#    echo "bnumber: $bnumber";

# number4=$(expr substr "$bnumber" 1 5);

#    if [[ "$number4" == '([B][0-9][0-9][0-9][0-9])' ]]; then
#      echo "Matched pattern B000n.GVBLOAD: $bnumber";
#    else
#      echo "Pattern does not match: $bnumber";
#    fi

    number=$(expr substr "$bnumber" 2 4);
#    echo "Last build number: $number";

  fi

  # Add more processing logic as needed
done < "$FILE"

nextnumber=$(echo "$number" | awk '{ printf "%04.0f\n", $1+1 }');
# echo "Next build qualifier: B$nextnumber";

export BUILD_NBR=$nextnumber;

# echo "Finished processing file and BLD_Nbr exported: $BUILD_NBR"
