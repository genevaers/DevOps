#!/bin/bash
# set -x;
# set -e;
echo;
export CLONE_PE=Y
export CLONE_PEX=Y
export CLONE_RCA=N
export BRANCH_PE="AddBuildTable"
export BRANCH_PEX="AddBuildTable"
export BRANCH_RCA="main"
export BLDRCA=N
export BLDVER='5'
export BLDMAJ='01'
export BLDMIN='009'
export UNITPRM=SYSDA
export UNITTMP=SYSDA

# Increment build number - this sets env var $BLDNBR
. ./IncrementBNum.sh ;
# generate JCL to allocate data sets, then submit and wait for completion
. ./ALLOC.sh ;
# Clone the repositories if required, and checkout branches.
. ./CLONE.sh ;
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
. ./GenBuild.sh ;
. ./SubBuild.sh ;
# Generate and submit JCL to set aliases
. ./ALIAS.sh ;
# Build RCA and Run regression suite 
. ./BUILDRCA.sh ;
#