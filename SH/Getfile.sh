#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

source ~/.gers.profile ;

echo "$(date) ${BASH_SOURCE##*/} Copying files from server to ZOS";

# Re-read .gers.DB2Schema.profile in case anything changed
source ~/.gers.profile ;
exitIfError;

# Create the log files
. ./CreateLogs.sh ;

if [ -z "$GERS_SECUREID" ] || [[ "$GERS_SECUREID" = "" ]]; then
  echo "No secure user ID has been supplied";
  exit 1;
fi

if [ -z "$GERS_SERVERID" ] || [[ "$GERS_SERVERID" = "" ]]; then
  echo "No server has been supplied";
  exit 1;
fi

if [ -z "$GERS_FILESEQN.$GERS_FILEMLLQ" ] || [[ "$GERS_FILESEQN.$GERS_FILEMLLQ" = "" ]]; then
  echo "No file name has been supplied";
  exit 1;
fi

if [ "$GERS_FILETYPE" = "PDS" ] || [ "$GERS_FILETYPE" = "PS" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Retrieving $GERS_FILETYPE file $GERS_FILESEQN.$GERS_FILEMLLQ from server $GERS_SERVERID for $GERS_SECUREID";
  if [ -z "$GERS_SECUREID" ] || [[ "$GERS_SECUREID" = "" ]]; then
    echo "Default file size 100 cylinders";
  else
    echo "Override file size of $GERS_FILECYLS cylinders provided";
  fi
  echo "Following temporary files will be used/overwritted for retrieving data:";
  echo "  &SYSUID..TRANSFER.TRS";
  echo "  &SYSUID..TRANSFER.PDS";
  echo "  &SYSUID..TRANSFER.SEQ";
else
  echo "FILETYPE of $GERS_FILETYPE given. Either PDS or PS must be specified";
  exit 1;
fi

# retrieve file: involves interactive ssh session
./SSHfile.sh $GERS_SECUREID $GERS_SERVERID

# Remove data preparation directory and create fresh
rm -Rf prep;
mkdir prep;

# tailor JCL
FILENAME=$GERS_FILESEQN.$GERS_FILEMLLQ;
mycmdstr1='s/&$FILENM.'/${GERS_FILENAME}/'g';
mycmdstr2='s/&$FILECY.'/${GERS_FILECYLS}/'g';
mycmdstr3='s/&$RUNPTH.'/${GERS_RUNPATH}/'g';

echo "cmd: $mycmdstr3";

# perform substitutions which unfortunately still converts to ACII with -W filecodeset=IBM-1047 
sed $mycmdstr1 ../JCL/UNTERSE1.jcl > prep/tmp1;
sed $mycmdstr2 prep/tmp1 > prep/tmp2;
sed $mycmdstr3 prep/tmp2 > prep/tmp3;

#convert output back to EBCDIC again
iconv -f ISO8859-1 -t IBM-1047 prep/tmp3 > prep/UNTERSE1.jcl;
chtag -r prep/UNTERSE1.jcl;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi

}

main "$@"