#!/usr/bin/env bash
# SubBuild.sh - Submit generated JCL 
########################################################

main() {

# Copy from USS directory to data sets
echo "$(date) ${BASH_SOURCE##*/} Copy source from z/OS Unix directories to data sets";
save_pwd=$(pwd) ;
. ./Copy.sh ;
cd $save_pwd ;

echo "$(date) ${BASH_SOURCE##*/} Submit the generated JCL to assemble and link the load modules";
. ./JobSubmitter.sh '../JCL/BUILDPE.jcl' asmdone  &>> $err_log;
echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
. ./JobWaiter.sh 120 asmdone  &>> $err_log ;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;

if  [ "$GERS_JOBSTATUS" == "LT8" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Assemble and Link completed RC 4 or better";
else
  echo "$(date) ${BASH_SOURCE##*/} Assemble and Link failed -- process terminated (see job output)";
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
