#!/bin/bash
main() {

# Copy from USS directory to data sets
echo "Copy source from z/OS Unix directories to data sets";
save_pwd=$(pwd) ;
. ./COPY.sh ;
cd $save_pwd ;

echo "Submit the generated JCL to assemble and link the load modules";
. ./SUBMITTER.sh '../JCL/BUILDPE.jcl' asmdone  1>> out.log 2>> err.log;
echo "Job number: $jobno" ;
. ./WAITER.sh 120 asmdone;
exitIfError;
echo "Job complete: $jobno" ;
}

exitIfError() {
if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 
}
main "$@"
