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
# Change to shell script directory
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
checkPWD;
exitIfError;
cd $GERS_GIT_REPO_DIR/$DEV_REPO/SH ;
# Check if run from TSO - used by sendTSOMsg
if [ -z "$USER" ] ; then
  userTSO='Y'; 
fi 
sendTSOMsg 'Starting the PE build process...                    ';
# Create the log files
sendTSOMsg 'Creating the log files...                           ';
. ./CreateLogs.sh ;
# Validate 'prefix' values do not exceed certain lengths
. ./gers_strlen.sh $GERS_BUILD_HLQ 18 GERS_BUILD_HLQ 2> >(tee -a $err_log) > >(tee -a $out_log);
exitIfError;
export GERS_BUILD_HLQ=$GERS_STRING_UPPER
. ./gers_strlen.sh $GERS_ENV_HLQ 35 GERS_ENV_HLQ 2> >(tee -a $err_log) > >(tee -a $out_log);
exitIfError;
export GERS_ENV_HLQ=$GERS_STRING_UPPER
. ./gers_strlen.sh $GERS_TEST_HLQ 10 GERS_TEST_HLQ 2> >(tee -a $err_log) > >(tee -a $out_log);
exitIfError;
export GERS_TEST_HLQ=$GERS_STRING_UPPER
# set env vars for build messages
# Release Number. (Example: 501001) -->
export GERS_PE_REL_NBR=$GERS_BUILD_VERSION$GERS_BUILD_MAJOR$GERS_BUILD_MINOR;
# Release number formatted with dots. (Example: 5.01.001) -->
export GERS_PE_REL_NBR_FORMATTED=$GERS_BUILD_VERSION.$GERS_BUILD_MAJOR.$GERS_BUILD_MINOR;
# Write environment vars to log
env | grep 'GERS_' | sort | tee -a $out_log;
# Create build number and set HLQ
# Do not pipe this output to tee (will break)
sendTSOMsg 'Creating the build number...                        ';             
. ./CreateBuildNum.sh ;
# Build FTL2JCL tool for templates
. ./BuildFTL2JCL.sh 2> >(tee -a $err_log) > >(tee -a $out_log);
# Generate JCL to allocate data sets, then submit and wait for completion
sendTSOMsg 'Allocating data sets...                             ';             
. ./Allocate.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Save Environment Variables in data set 
. ./SaveEnvVars.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Clone the repositories if required, and checkout branches.
sendTSOMsg 'Cloning the repositories...                         ';             
. ./CloneRepos.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
sendTSOMsg 'Generating the ASM and LINK JCL...                  ';             
. ./GenBuild.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Submit the generated assemble and link jobs
sendTSOMsg 'Submitting the generated ASM and LINK jobs...       ';             
. ./SubBuild.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Generate and submit JCL to set aliases
sendTSOMsg 'Setting the aliases...                              ';             
. ./DataSetAlias.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Save job output from spool to data set
sendTSOMsg 'Saving the job output...                            ';             
. ./SaveJobInfo.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Build RCA and Run regression suite 
sendTSOMsg 'Building the RCA and running the regression suite...';             
. ./BuildRCApps.sh  2> >(tee -a $err_log) > >(tee -a $out_log);
# Generate Tag scripts
sendTSOMsg 'Generating the tag scripts and JCL...               ';             
. ./GenTag.sh  > >(tee -a $out_log);
echo "$(date) ${BASH_SOURCE##*/} Build process completed for PM$GERS_PE_REL_NBR_FORMATTED.B$BUILD_NBR" | tee -a $out_log ;
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