#!/bin/bash
main() {
save_pwd=$(pwd) ;
# Copy from USS directory to data sets
. ./COPY.sh ;
cd $save_pwd ;
# Submit the JCL
./SUBMITTER.sh '../JCL/BUILDPE.JCL' asmdone;
./WAITER.sh 120 asmdone;

}

exitIfError() {
if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 
}
main "$@"
