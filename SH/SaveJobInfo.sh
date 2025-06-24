#!/usr/bin/env bash
# CopySaveInfo.sh - Copy the job output from the spool to library members 
#######################################
main() {

echo "$(date) ${BASH_SOURCE##*/} Generate JCL to copy the job output from the spool to library members ";
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/SAVEJOB ../TABLE/tablesDevOps ../JCL/SAVEJOB.jcl 2>> $err_log; 
exitIfFTLError;

cat ../JCL/SAVEDONE.jcl >> ../JCL/SAVEJOB.jcl;

echo "$(date) ${BASH_SOURCE##*/} Submit JCL to copy job output";
. ./JobSubmitter.sh '../JCL/SAVEJOB.jcl' savedone &>> $err_log;
echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
. ./JobWaiter.sh 60 savedone &>> $err_log;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;

if  [ "$GERS_JOBSTATUS" == "LT8" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Copy job output completed RC 4 or better";
else
  echo "$(date) ${BASH_SOURCE##*/} Copy job output -- process terminated (see job output)";
  exit 1;
fi
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}

exitIfFTLError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error log $err_log";
    exit 1;
fi 

}

main "$@"