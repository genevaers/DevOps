#!/bin/bash
# GenTag.sh - Generate script to Tag builds
########################################################

main() {
echo "$(date) ${BASH_SOURCE##*/} Start generation of tagging scripts";
#
# Create copy commands to copy source to data sets - this reads a table in each of the repositories
#
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGBUILD ../TABLE/tablesDevOps ./TagBuild.sh 2>> $err_log ;
exitIfFTLError;
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGBUILDJ ../TABLE/tablesDevOps ../JCL/TAGBLD.jcl 2>> $err_log ;
exitIfFTLError;
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGREL ../TABLE/tablesDevOps ./TagRel.sh 2>> $err_log ;
exitIfFTLError;
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGRELJ ../TABLE/tablesDevOps ../JCL/TAGREL.jcl 2>> $err_log ;
exitIfFTLError;
chmod 755 TagBuild.sh ;
chmod 755 TagRel.sh ;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine tagging scripts generated";
#
# Copy to data set for use at a later date
#
cp ../JCL/TAGBLD.jcl "//'$GERS_TARGET_HLQ.JCL(TAGBLD)'"
exitIfError;
cp ../JCL/TAGREL.jcl "//'$GERS_TARGET_HLQ.JCL(TAGREL)'"
exitIfError;
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}

exitIfFTLError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error log $err_log";
    exit 1;
fi 

}

main "$@"