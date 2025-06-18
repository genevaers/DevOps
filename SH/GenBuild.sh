#!/bin/bash
# GenBuild.sh - Generate build script and JCL
########################################################

main() {
echo "$(date) ${BASH_SOURCE##*/} Start generation of scripts and JCL";
# extract repository names
PE_REPO=$(basename $GERS_REMOTE_PEB .git);
PEX_REPO=$(basename $GERS_REMOTE_PEX .git);
RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo $PE_REPO ;
  echo $PEX_REPO ;
  echo $RCA_REPO ;
  echo $DEV_REPO ;
fi 
# Make ascii copies of the tables
ascii_dir=$GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A ;
[ -d $ascii_dir ] || mkdir $ascii_dir ;
exitIfError;
iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE.csv  > $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE.csv;
exitIfError;
iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/MAC.csv  > $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/MAC.csv;
exitIfError;
iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/PGM.csv  > $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/PGM.csv;
exitIfError;
#
# Create copy commands to copy source to data sets - this reads a table in each of the repositories
#
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/COPYPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE ./CopyPE.sh  2>> $err_log;
exitIfFTLError;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine copy script generated";
# Performance Engine extensions required?
if  [ "$GERS_INCLUDE_PEX" == "Y" ]; then 
# Make ascii copies of the tables
  ascii_dir=$GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A ;
  [ -d $ascii_dir ] || mkdir $ascii_dir ;
  exitIfError;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX.csv;
  exitIfError;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MACEXT.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/MACEXT.csv;
  exitIfError;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGMEXT.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/PGMEXT.csv;
  exitIfError;

  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/COPYPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX ./CopyPEX.sh  2>> $err_log;
  exitIfFTLError;
  echo "$(date) ${BASH_SOURCE##*/} Performance Engine Extensions copy script generated";
  cat CopyPE.sh CopyPEX.sh > Copy.sh ;
  exitIfError;
else  
  cat CopyPE.sh > Copy.sh ;
  exitIfError;
fi 
chmod 755 Copy.sh ;
exitIfError;
#
# The LINKPARMs need to copied from the PE and PEX repositories before building the JCL
#
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/COPYLINKPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE ./CopyLinkPE.sh  2>> $err_log;
exitIfFTLError;
save_pwd=$(pwd) ;
. ./CopyLinkPE.sh ;
cd $save_pwd ;
#
echo "$(date) ${BASH_SOURCE##*/} Performance Engine LINKPARMs copied";
#
if  [ "$GERS_INCLUDE_PEX" == "Y" ]; then 
  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/COPYLINKPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX ./CopyLinkPEX.sh  2>> $err_log;
  exitIfFTLError;
  save_pwd=$(pwd) ;
  . ./CopyLinkPEX.sh ;
  cd $save_pwd ;
  echo "$(date) ${BASH_SOURCE##*/} Performance Engine Extensions LINKPARMs copied";
fi 
#
# Create build JCL from templates
#
#  -- Generate for PE 
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/BUILDPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE ../JCL/BUILDPE.jcl  2>> $err_log;
exitIfFTLError;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine build JCL generated";
#  -- Generate BIND JCL
if [ "$GERS_DB2_ASM" == "Y" ]; then 
  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/BINDPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE ../JCL/BINDPE.jcl  2>> $err_log;
  exitIfFTLError;
#     Copy to data set for use at a later date
  cp ../JCL/BINDPE.jcl "//'$GERS_TARGET_HLQ.JCL(BINDPE)'"
  exitIfError;
  echo "$(date) ${BASH_SOURCE##*/} Performance Engine Db2 BIND JCL generated";
fi
#  -- Generate for PEX, if required
if  [ "$GERS_INCLUDE_PEX" == "Y" ]; then 
  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/BUILDPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX ../JCL/BUILDPEX.jcl 2>> $err_log;
  exitIfFTLError;
  echo "$(date) ${BASH_SOURCE##*/} Performance Engine Extensions build JCL generated";
  if [ "$GERS_DB2_ASM" == "Y" ]; then 
#  -- Generate BIND JCL
    java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/BINDPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX ../JCL/BINDPEX.jcl  2>> $err_log;
    exitIfFTLError;
#     Copy to data set for use at a later date
    cp ../JCL/BINDPEX.jcl "//'$GERS_TARGET_HLQ.JCL(BINDPEX)'"
    exitIfError;
    echo "$(date) ${BASH_SOURCE##*/} Performance Engine Extensions Db2 BIND JCL generated";
  fi
# Concatenate build JCL into one module  
  cd ../JCL;
  cat BUILDPEX.jcl ASMDONE.jcl >> BUILDPE.jcl ;
  exitIfError;
  cd ../SH;
else
  cd ../JCL;
  cat ASMDONE.jcl >> BUILDPE.jcl ;
  exitIfError;
  cd ../SH;
fi 

}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}

exitIfFTLError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error log $err_log";
    exit 1;
fi 

}


main "$@"
