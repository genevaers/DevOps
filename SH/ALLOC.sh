#!/bin/bash
# ALLOC.sh - Allocate data sets
########################################################

main() {

echo "$(date) ${BASH_SOURCE##*/} Generate JCL to allocate the build data sets";
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/ALLOC ../TABLE/tablesDevOps ../JCL/ALLOC.jcl 2>> err.log; 
exitIfError;

echo "$(date) ${BASH_SOURCE##*/} Submit JCL to allocate the build data sets";
. ./SUBMITTER.sh '../JCL/ALLOC.jcl' allocdone 1>> out.log 2>> err.log;
echo "$(date) ${BASH_SOURCE##*/} Job number: $jobno" ;
. ./WAITER.sh 60 allocdone 1>> out.log 2>> err.log;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Job complete: $jobno" ;
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"