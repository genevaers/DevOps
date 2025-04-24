#!/bin/bash
set -x;
# set -e;
echo;
export CLONE_PE=Y
export CLONE_PEX=Y
export CLONE_RCA=Y
export BRANCH_PE="main"
export BRANCH_PEX="main"
export BRANCH_RCA="main"
export BLDRCA=N
export BLDVER='5'
export BLDMAJ='01'
export BLDMIN='001'
export UNITPRM=SYSDA
export UNITTMP=SYSDA

# Increment build number - this sets env var $BLDNBR
. ./IncrementBNum.sh
# generate JCL to allocate data sets, then submit and wait for completion
. ./ALLOC.sh
# Clone the repositories if required, and checkout branches.
. ./CLONE.sh
# Generate the script to copy source to data sets
# Generate the JCL for ASM and LINK
# These read tables in the PE and PEX repositories
. ./GenBuild.sh
# Generate JCL to set aliases
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ALIAS ../TABLE/tablesDevOps ;
# Generate   - Run regression suite (could  be just a script)
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar RunReg 
#
# copy all generated JCL to one big job and submit
#