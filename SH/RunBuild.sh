#!/bin/bash
# set -x;
# set -e;
echo;
source ./AddEnvVars ;
env | grep 'GERS_' ;
export INCLUDE_PEX=Y
export CLONE_PE=Y
export CLONE_PEX=Y
export CLONE_RCA=N
export BRANCH_PE="AddBuildTable"
export BRANCH_PEX="AddBuildTable"
export BRANCH_RCA="main"
export BUILD_RCA=ZOS 
export BUILD_VERSION='5'
export BUILD_MAJOR='01'
export BUILD_MINOR='009'
#
# Increment build number - this sets env var $BUILD_NBR
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