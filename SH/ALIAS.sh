#!/bin/bash
# ALIAS.sh - Create Aliases for data sets
########################################################

main() {

echo "$(date) ${BASH_SOURCE##*/} Generate JCL to set aliases for the build data sets";
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/ALIAS ../TABLE/tablesDevOps ../JCL/ALIAS.jcl 2>> $err_log;
exitIfError;

cat ../JCL/ALIASDONE.jcl >> ../JCL/ALIAS.jcl;

echo "$(date) ${BASH_SOURCE##*/} Submit JCL to set aliases for the build data sets";
. ./SUBMITTER.sh '../JCL/ALIAS.jcl' aliasdone  &>> $err_log;
echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
. ./WAITER.sh 60 aliasdone &>> $err_log;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;

if  [ "$GERS_JOBSTATUS" == "LT8" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Aliasing completed RC 4 or better";
else
  echo "$(date) ${BASH_SOURCE##*/} Aliasing failed -- process terminated (see job output)";
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

main "$@"