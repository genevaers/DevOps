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
tsocmd "send '$(date '+%H.%M.%S') Starting the PE build process...                    ' user("$LOGNAME")"      
cd $GERS_GIT_REPO_DIR"/DevOps/SH";                                                                       
# Re-read the gers profile in case anything changed
source ~/.gers.profile ;
# Create the log files
tsocmd "send '$(date '+%H.%M.%S') Creating the log files...                           ' user("$LOGNAME")"             
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
tsocmd "send '$(date '+%H.%M.%S') Creating the build number...                        ' user("$LOGNAME")"             
. ./CreateBuildNum.sh ;
# Generate JCL to allocate data sets, then submit and wait for completion
tsocmd "send '$(date '+%H.%M.%S') Allocating data sets...                             ' user("$LOGNAME")"             
. ./Allocate.sh  > >(tee -a $out_log);
# Clone the repositories if required, and checkout branches.
tsocmd "send '$(date '+%H.%M.%S') Cloning the repositories...                         ' user("$LOGNAME")"             
. ./CloneRepos.sh  > >(tee -a $out_log);
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
tsocmd "send '$(date '+%H.%M.%S') Generating the ASM and LINK JCL...                  ' user("$LOGNAME")"             
. ./GenBuild.sh  > >(tee -a $out_log);
# Submit the generated assemble and link jobs
tsocmd "send '$(date '+%H.%M.%S') Submitting the generated ASM and LINK jobs...       ' user("$LOGNAME")"             
. ./SubBuild.sh  > >(tee -a $out_log);
# Generate and submit JCL to set aliases
tsocmd "send '$(date '+%H.%M.%S') Setting the aliases...                              ' user("$LOGNAME")"             
. ./DataSetAlias.sh  > >(tee -a $out_log);
# Save job output from spool to data set
tsocmd "send '$(date '+%H.%M.%S') Saving the job output...                            ' user("$LOGNAME")"             
. ./SaveJobInfo.sh > >(tee -a $out_log);
# Build RCA and Run regression suite 
tsocmd "send '$(date '+%H.%M.%S') Building the RCA and running the regression suite...' user("$LOGNAME")"             
. ./BuildRCApps.sh  > >(tee -a $out_log);
# Generate Tag scripts
tsocmd "send '$(date '+%H.%M.%S') Generating the tag scripts and JCL...               ' user("$LOGNAME")"             
. ./GenTag.sh  > >(tee -a $out_log);
echo "$(date) ${BASH_SOURCE##*/} Build process completed for PM$GERS_PE_REL_NBR_FORMATTED.B$BUILD_NBR" | tee $out_log ;
}
main "$@"