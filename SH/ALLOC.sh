#!/bin/bash
# ALLOC.sh - Allocate data sets
########################################################

main() {
save_pwd=$(pwd);
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/ALLOC ../TABLE/tablesDevOps ../JCL/ALLOC.jcl ; 
exitIfError;

./SUBMITTER.sh '../JCL/ALLOC.jcl' allocdone;
./WAITER.sh 60 allocdone;
exitIfError;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"