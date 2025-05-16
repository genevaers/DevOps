#!/bin/bash
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
env | grep 'GERS_' ;
# Create the log files
. ./CreateLogs.sh ;
# Increment build number and set HLQ
# Do not pipe this output to tee (will break)
. ./IncrementBNum.sh ;
# Generate JCL to allocate data sets, then submit and wait for completion
. ./ALLOC.sh | tee -a $out_log;
# Clone the repositories if required, and checkout branches.
. ./CLONE.sh  | tee -a $out_log;
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
. ./GenBuild.sh  | tee -a $out_log;
# Submit the generated assemble and link jobs
. ./SubBuild.sh  | tee -a $out_log;
# Generate and submit JCL to set aliases
. ./ALIAS.sh  | tee -a $out_log;
# Build RCA and Run regression suite 
. ./BUILDRCA.sh  | tee -a $out_log;
# Generate Tag scripts
. ./GenTag.sh  | tee -a $out_log;
}
main "$@"