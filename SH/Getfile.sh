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
  echo "$(date) ${BASH_SOURCE##*/} No secure user ID has been supplied";
  exit 1;
fi

if [ -z "$GERS_SERVERID" ] || [[ "$GERS_SERVERID" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No server has been supplied";
  exit 1;
fi

if [ -z "$GERS_FILESEQN.$GERS_FILEMLLQ" ] || [[ "$GERS_FILESEQN.$GERS_FILEMLLQ" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No file name has been supplied";
  exit 1;
fi

if [ "$GERS_FILETYPE" = "PDS" ] || [ "$GERS_FILETYPE" = "PS" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Retrieving $GERS_FILETYPE file $GERS_FILESEQN.$GERS_FILEMLLQ from server $GERS_SERVERID for $GERS_SECUREID";
  if [ -z "$GERS_SECUREID" ] || [[ "$GERS_SECUREID" = "" ]]; then
    echo "$(date) ${BASH_SOURCE##*/} Default file size 100 cylinders";
  else
    echo "$(date) ${BASH_SOURCE##*/} Override file size of $GERS_FILECYLS cylinders provided";
  fi
  echo "$(date) ${BASH_SOURCE##*/} Following temporary files will be used/overwritted when retrieving data (exit if needed):";
  echo "$(date) ${BASH_SOURCE##*/}   &SYSUID..TRANSFER.TRS";
  echo "$(date) ${BASH_SOURCE##*/}   &SYSUID..TRANSFER.PDS";
  echo "$(date) ${BASH_SOURCE##*/}   &SYSUID..TRANSFER.SEQ";
else
  echo "$(date) ${BASH_SOURCE##*/} FILETYPE of ' $GERS_FILETYPE ' given. Either PDS or PS must be specified";
  exit 1;
fi

# retrieve file: involves interactive ssh session
./SSHfile.sh $GERS_SECUREID $GERS_SERVERID

# Remove data preparation directory and create fresh
rm -Rf prep;
mkdir prep;

# tailor JCL
FILENAME=$GERS_FILESEQN.$GERS_FILEMLLQ;
# 7 times as much space for unpacked file
EXPCYL=$(( GERS_FILECYLS * 7 ))

mycmdstr1='s/&$FILENM.'/${FILENAME}/'g';
mycmdstr2='s/&$FILECY.'/${GERS_FILECYLS}/'g';
mycmdstr3='s/&$RUNPTH.'/${GERS_RUNPATH}/'g';
mycmdstr4='s/&$FILECY.'/${EXPCYL}/'g';

echo "cmd1: $mycmdstr1";
echo "cmd2: $mycmdstr2";
echo "cmd3: $mycmdstr3";
echo "cmd4: $mycmdstr4";

# perform substitutions which unfortunately still converts to ACII with -W filecodeset=IBM-1047 
sed $mycmdstr1 ../JCL/UNTERSE1.jcl > prep/tmp1;
sed $mycmdstr2 prep/tmp1 > prep/tmp2;
sed $mycmdstr3 prep/tmp2 > prep/tmp3;

sed $mycmdstr4 ../JCL/UNTERSE2.jcl > prep/tmp4;

sed $mycmdstr4 ../JCL/UNTERSE3.jcl > prep/tmp5;

#convert output back to EBCDIC again
iconv -f ISO8859-1 -t IBM-1047 prep/tmp3 > prep/UNTERS1.jcl;
chtag -r prep/UNTERS1.jcl;

iconv -f ISO8859-1 -t IBM-1047 prep/tmp4 > prep/UNTERS2.jcl;
chtag -r prep/UNTERS2.jcl;

iconv -f ISO8859-1 -t IBM-1047 prep/tmp5 > prep/UNTERS3.jcl;
chtag -r prep/UNTERS2.jcl;

# append completion status job step
cat prep/UNTERS1.jcl ../JCL/UNTERSEDONE > prep/UNTERSE1.jcl
cat prep/UNTERS2.jcl ../JCL/UNTERSEDONE > prep/UNTERSE2.jcl
cat prep/UNTERS3.jcl ../JCL/UNTERSEDONE > prep/UNTERSE3.jcl

# run UNTERSE1 to copy USS file to MVS dataset
echo "$(date) ${BASH_SOURCE##*/} Submit generated JCL to copy USS file to MVS dataset";
. ./JobSubmitter.sh 'prep/UNTERSE1.jcl' untersedone  1>> $err_log;
echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
. ./JobWaiter.sh 120 untersedone  1>> $err_log ;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;

# run UNTERSE2 to perform TRSMAIN to UNPACK PDS dataset
if [ "$GERS_FILETYPE" = "PDS" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Submit generated JCL to UNTERSE MVS partitioned dataset";
  . ./JobSubmitter.sh 'prep/UNTERSE2.jcl' untersedone  1>> $err_log;
  echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
  . ./JobWaiter.sh 120 untersedone  1>> $err_log ;
  exitIfError;
  echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
  echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;
else
# run UNTERSE3 to perform TRSMAIN to UNPACK PS dataset
  echo "$(date) ${BASH_SOURCE##*/} Submit generated JCL to UNTERSE MVS sequential dataset";
  . ./JobSubmitter.sh 'prep/UNTERSE3.jcl' untersedone  1>> $err_log;
  echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
  . ./JobWaiter.sh 120 untersedone  1>> $err_log ;
  exitIfError;
  echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
  echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;
fi

}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi

}

main "$@"