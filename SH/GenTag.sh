#!/bin/bash
# GenTag.sh - Generate script to Tag builds
########################################################

main() {
echo "$(date) ${BASH_SOURCE##*/} Start generation of tagging scripts";
#
# Create copy commands to copy source to data sets - this reads a table in each of the repositories
#
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGBUILD ../TABLE/tablesDevOps ./TAGBUILD.sh 2>> err.log ;
exitIfError;
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/TAGREL ../TABLE/tablesDevOps ./TAGREL.sh 2>> err.log ;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine copy script generated";
}
main "$@"