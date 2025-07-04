#!/usr/bin/env bash
# Allocate.sh - Allocate data sets
########################################################

main() {

echo "$(date) ${BASH_SOURCE##*/} Generate JCL to allocate the build data sets";
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/ALLOC ../TABLE/tablesDevOps ../JCL/ALLOC.jcl 2>> $err_log; 
exitIfFTLError;

cat ../JCL/ALLOCDONE.jcl >> ../JCL/ALLOC.jcl;

echo "$(date) ${BASH_SOURCE##*/} Submit JCL to allocate the build data sets";
. ./JobSubmitter.sh '../JCL/ALLOC.jcl' allocdone 1>> $err_log;
echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
. ./JobWaiter.sh 60 allocdone 1>> $err_log;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;

if  [ "$GERS_JOBSTATUS" == "LT8" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Allocate MVS datasets completed RC 4 or better";
else
  echo "$(date) ${BASH_SOURCE##*/} Allocate MVS datasets failed -- process terminated (see job output)";
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