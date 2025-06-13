#!/bin/bash
# Build.sh - Build GenevaERS 
########################################################
# set -x;
# set -e;
main() {
opt1="$1";
if [ "$opt1"  == "-v" ]; then
    echo "Verbose message level";
    export msgLevel=verbose;
fi
if [ -z "$USER" ] ; then
  userTSO='Y'; 
fi 
sendTSOMsg 'Starting the PE build process...                    ';
cd $GERS_GIT_REPO_DIR"/DevOps/SH";                                                                       
# Re-read the gers profile in case anything changed
source ~/.gers.profile ;
exitIfError;
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
# Do not pipe this output to tee (will break)
sendTSOMsg 'Creating the build number...                        ';             
. ./CreateBuildNum.sh ;
# Generate JCL to allocate data sets, then submit and wait for completion
sendTSOMsg 'Allocating data sets...                             ';             
. ./Allocate.sh  > >(tee -a $out_log);
# Clone the repositories if required, and checkout branches.
sendTSOMsg 'Cloning the repositories...                         ';             
. ./CloneRepos.sh  > >(tee -a $out_log);
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
sendTSOMsg 'Generating the ASM and LINK JCL...                  ';             
. ./GenBuild.sh  > >(tee -a $out_log);
# Submit the generated assemble and link jobs
sendTSOMsg 'Submitting the generated ASM and LINK jobs...       ';             
. ./SubBuild.sh  > >(tee -a $out_log);
# Generate and submit JCL to set aliases
sendTSOMsg 'Setting the aliases...                              ';             
. ./DataSetAlias.sh  > >(tee -a $out_log);
# Save job output from spool to data set
sendTSOMsg 'Saving the job output...                            ';             
. ./SaveJobInfo.sh > >(tee -a $out_log);
# Build RCA and Run regression suite 
sendTSOMsg 'Building the RCA and running the regression suite...';             
. ./BuildRCApps.sh  > >(tee -a $out_log);
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

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"