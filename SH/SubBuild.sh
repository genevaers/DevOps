#!/bin/bash
main() {

# Copy from USS directory to data sets
echo "$(date) ${BASH_SOURCE##*/} Copy source from z/OS Unix directories to data sets";
save_pwd=$(pwd) ;
. ./COPY.sh ;
cd $save_pwd ;

echo "$(date) ${BASH_SOURCE##*/} Submit the generated JCL to assemble and link the load modules";
. ./SUBMITTER.sh '../JCL/BUILDPE.jcl' asmdone  1>> out.log 2>> err.log;
echo "$(date) ${BASH_SOURCE##*/} JobID: $GERS_JOBID" ;
. ./WAITER.sh 120 asmdone  1>> out.log 2>> err.log ;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $GERS_JOBID" ;
echo "$(date) ${BASH_SOURCE##*/} Job statusRC: $GERS_JOBSTATUS" ;
}

exitIfError() {
if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 
}
main "$@"
