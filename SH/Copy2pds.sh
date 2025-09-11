#!/bin/bash
# Script to directory contents to MVS pds(e)

# Check if a directory and pattern are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: $0 <directory> <suffix> <pds>"
  echo "Example: $0 /u/usr1/sample  jcl  //'SMPL.JCL'"
  exit 1
fi

FROM_DIR="$1"
FROM_SUF="$2"
TO_PDS="$3"

echo "Copying files from directory '$FROM_DIR' with suffix '$FROM_SUF' to MVS '$TO_PDS'"

# Determine directory contents

echo "$FROM_DIR"/*."$FROM_SUF"

ls "$FROM_DIR"/*."$FROM_SUF" > "$FROM_DIR"/list.tmp

FILE="$FROM_DIR/list.tmp"; # File to parse to get directory contents
if [ ! -f "$FILE" ]; then
  echo "Error: Temporary file '$FILE' not found.";
  exit 1;
fi

while IFS= read -r line; do
  # Process each line (record) here
  # echo "Record: $line";

  # Find last index of test we're searching for
  echo $line > "$FROM_DIR"/text.tmp;
  endidx=$(awk -F"/" '{print length($0) - length($NF)}' "$FROM_DIR"/"text.tmp" );
  echo "Endidx: $endidx";

  if [ $endidx -gt 0 ]; then

    # Calculate starting index
    startidx=$((endidx-12));
#    echo "startidxi :startidx";

    # Extract numerical value after "B"
    bnumber=$(awk '{print substr($0,'$startidx',13)}' "$FROM_DIR"/"text.tmp" );
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
