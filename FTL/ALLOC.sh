#!/bin/bash
# ALLOC.sh - Allocate data sets
########################################################

main() {

java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ALLOC ../TABLE/tablesDevOps ;    
exitIfError;

../NEW/SUBMITTER.sh './ALLOC.jcl' allocdone;
../NEW/WAITER.sh 60 allocdone;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above"
    exit 1
fi 

}

main "$@"