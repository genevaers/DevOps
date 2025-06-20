#!/bin/bash
# SaveEnvVars.sh - Save Environment Variables for this build to build data set
########################################################

main() {
echo "$(date) ${BASH_SOURCE##*/} Copy environment variables to data set";
touch envFile ;
rm envFile ;
env | grep 'GERS_' | sort > envFile;
# Convert to EBCDIC
mv envFile envFile.old;
iconv -f"ISO8859-1" -t"IBM-1047" envFile.old > envFile;
exitIfError;
rm envFile.old;
chtag -t -c"IBM-1047" envFile;;
#
# Copy to data set for use at a later date
#
cp envFile "//'$GERS_TARGET_HLQ.ENV(ENVFILE)'"
exitIfError;
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"