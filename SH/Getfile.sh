#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

echo "$(date) ${BASH_SOURCE##*/} Copying files from server to ZOS";

# Re-read .gers.DB2Schema.profile in case anything changed
source ~/.gers.profile ;
exitIfError;

# Create the log files
. ./CreateLogs.sh ;

if [ -z "$SECUREID" ] || [[ "$SECUREID" = "" ]]; then
  echo "No secure user ID has been supplied";
  exit 1;
fi

if [ -z "$SERVERID" ] || [[ "$SERVERID" = "" ]]; then
  echo "No server has been supplied";
  exit 1;
fi

if [ "$FILETYPE != "PDS" ] && ["$FILETYPE != "SEQ"]; then
  echo "FILETYPE of either PDS or PS must be specified";
  exit 1;
fi

if [ -z "$FILESEQN.$FILEMLLQ" ] || [[ "$FILESEQN.$FILEMLLQ" = "" ]]; then
  echo "No file name has been supplied";
  exit 1;
fi

echo "$(date) ${BASH_SOURCE##*/} Retrieving file $FILESEQN.$FILEMLLQ from server $SERVERID for $SECUREID";

}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi

}

main "$@"