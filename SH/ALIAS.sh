#!/bin/bash
# ALIAS.sh - Create Aliases for data sets
########################################################

main() {
save_pwd=$(pwd);
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/ALIAS ../TABLE/tablesDevOps ../JCL/ALIAS.jcl ;
exitIfError;

./SUBMITTER.sh './ALIAS.jcl' aliasdone;
./WAITER.sh 60 aliasdone;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"