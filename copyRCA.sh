#!/usr/bin/env bash
# build.sh - Build GenevaERS 
########################################################
main() {
opt1="$1";
if [ "$opt1"  == "-v" ]; then
    echo "Verbose message level";
    export msgLevel=verbose;
fi
# Re-read the gers profile in case anything changed
source ~/.gers.profile ;
exitIfError;
# Get DevOps repo name from repo address
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
# Check if run from TSO - used by sendTSOMsg
if [ -z "$USER" ] ; then
    userTSO='Y'; 
else 
    userTSO='N'; 
    checkPWD;
    exitIfError;
fi 
# Change to shell script directory SH
cd $GERS_GIT_REPO_DIR/$DEV_REPO/SH ;
exitIfError;
sendTSOMsg 'Starting the RCA copy process...                    ';
# Create the log files
sendTSOMsg 'Creating the log files...                           ';
. ./CreateLogs.sh ;
# set env vars for build messages
# Release Number. (Example: 501001) -->
export GERS_PE_REL_NBR=$GERS_BUILD_VERSION$GERS_BUILD_MAJOR$GERS_BUILD_MINOR;
# Release number formatted with dots. (Example: 5.01.001) -->
export GERS_PE_REL_NBR_FORMATTED=$GERS_BUILD_VERSION.$GERS_BUILD_MAJOR.$GERS_BUILD_MINOR;
# Write environment vars to log
env | grep 'GERS_' | sort | tee -a $out_log;
# Create build number and set HLQ
# Clone the RCA repository, and checkout branches.
sendTSOMsg 'Cloning the RCA repository...                       ';             
. ./CloneRCAonly.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Copy built RCA to jar directory
sendTSOMsg 'Copying the RCA to the RCA jar directory';             
. ./CopyRCAppsOnly.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
echo "$(date) ${BASH_SOURCE##*/} RCA Copy process completed" | tee -a $out_log ;
}

sendTSOMsg() {

if [ "$userTSO" == "Y" ]; then 
    tsocmd "send '$(date '+%H.%M.%S') $1' user("$LOGNAME")" ;
    if [ $? != 0 ] ; then
        userTSO='N'; 
    fi  
fi   

}

checkPWD() {

if [  "$(pwd)" != "${GERS_GIT_REPO_DIR%/}/$DEV_REPO" ]; then
  echo "$(date) ${BASH_SOURCE##*/} Environment Variable GERS_GIT_REPO_DIR = '$GERS_GIT_REPO_DIR'" ;
  echo "$(date) ${BASH_SOURCE##*/} DevOps directory name ='$DEV_REPO'" ;
  echo "$(date) ${BASH_SOURCE##*/} They must match with the current directory '$(pwd)'" ;
  return 1;
 fi 

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"