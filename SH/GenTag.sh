#!/bin/bash
# GenTag.sh - Generate script to Tag builds
########################################################

main() {
echo "$(date) ${BASH_SOURCE##*/} Start generation of tagging scripts";
#
# Create copy commands to copy source to data sets - this reads a table in each of the repositories
#
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGBUILD ../TABLE/tablesDevOps ./TagBuild.sh 2>> $err_log ;
exitIfError;
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGREL ../TABLE/tablesDevOps ./TagRel.sh 2>> $err_log ;
exitIfError;
chmod 755 TagBuild.sh ;
chmod 755 TagRel.sh ;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine tagging scripts generated";
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}
main "$@"