#!/bin/bash
# ALIAS.sh - Create Aliases for data sets
########################################################

main() {

echo "Generate JCL to set aliases for the build data sets";
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/ALIAS ../TABLE/tablesDevOps ../JCL/ALIAS.jcl 2>> err.log;
exitIfError;

echo "Submit JCL to set aliases for the build data sets";
. ./SUBMITTER.sh '../JCL/ALIAS.jcl' aliasdone  1>> out.log 2>> err.log;
echo "Job number: $jobno" ;
. ./WAITER.sh 60 aliasdone 1>> out.log 2>> err.log;
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