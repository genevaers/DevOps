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

if [ -z "$FILESEQN.$FILEMLLQ" ] || [[ "$FILESEQN.$FILEMLLQ" = "" ]]; then
  echo "No file name has been supplied";
  exit 1;
fi

if [ "$FILETYPE" = "PDS" ] || [ "$FILETYPE" = "PS" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Retrieving $FILETYPE file $FILESEQN.$FILEMLLQ from server $SERVERID for $SECUREID";
  if [ -z "$SECUREID" ] || [[ "$SECUREID" = "" ]]; then
    echo "Default file size 100 cylinders";
  else
    echo "Override file size of $FILECYLS cylinders provided";
  fi
  echo "Following temporary files will be used/overwritted for retrieving data:";
  echo "  &SYSUID..TRANSFER.TRS";
  echo "  &SYSUID..TRANSFER.PDS";
  echo "  &SYSUID..TRANSFER.SEQ";
else
  echo "FILETYPE of $FILETYPE given. Either PDS or PS must be specified";
  exit 1;
fi

# retrieve file: involves interactive ssh session
./SSHfile.sh $SECUREID $SERVERID

# Remove data preparation directory and create fresh
rm -Rf prep;
mkdir prep;

# tailor JCL
mycmdstr1='s/&$FILENM.'/${$FILESEQN.$FILEMLLQ}/'g';
# perform substitutions which unfortunately still converts to ACII with -W filecodeset=IBM-1047 
sed $mycmdstr1 ../JCL/UNTERSE1.jcl > prep/tmp1;

#convert output back to EBCDIC again
iconv -f ISO8859-1 -t IBM-1047 prep/tmp1 > prep/UNTERSE1.jcl;
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