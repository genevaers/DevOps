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
source ~/.gers.profile ;
export INCLUDE_PEX=Y
export CLONE_PE=Y
export CLONE_PEX=Y
export CLONE_RCA=Y
export BRANCH_PE="AddBuildTable"
export BRANCH_PEX="AddBuildTable"
export BRANCH_RCA="main"
export BUILD_RCA=ZOS 
export BUILD_VERSION='5'
export BUILD_MAJOR='01'
export BUILD_MINOR='009'
# Create the log files
. ./CreateLogs.sh ;
# set env vars for build messages
# Release Number. (Example: 501001) -->
export GERS_PE_REL_NBR=$BUILD_VERSION$BUILD_MAJOR$BUILD_MINOR;
# Release number formatted with dots. (Example: 5.01.001) -->
export GERS_PE_REL_NBR_FORMATTED=$BUILD_VERSION.$BUILD_MAJOR.$BUILD_MINOR;
# Write environment vars to log
env | grep 'GERS_' | tee -a $out_log;
# Create build number and set HLQ
# Do not pipe this output to tee (will break)
. ./CreateBuildNum.sh ;
# Generate JCL to allocate data sets, then submit and wait for completion
. ./Allocate.sh | tee -a $out_log;
# Clone the repositories if required, and checkout branches.
. ./CloneRepos.sh  | tee -a $out_log;
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
. ./GenBuild.sh  | tee -a $out_log;
# Submit the generated assemble and link jobs
. ./SubBuild.sh  | tee -a $out_log;
# Generate and submit JCL to set aliases
. ./DataSetAlias.sh  | tee -a $out_log;
# Build RCA and Run regression suite 
. ./BuildRCApps.sh  | tee -a $out_log;
# Generate Tag scripts
. ./GenTag.sh  | tee -a $out_log;
}
main "$@"