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
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/COPYPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE ./COPYPE.sh  2>> err.log;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine copy script generated";
# Performance Engine extensions required?
if  [ "$INCLUDE_PEX" == "Y" ]; then 
# Make ascii copies of the tables
  ascii_dir=$GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A ;
  [ -d $ascii_dir ] || mkdir $ascii_dir ;
  exitIfError;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX.csv;
  exitIfError;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MACRND.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/MACRND.csv;
  exitIfError;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGMRND.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/PGMRND.csv;
  exitIfError;

  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/COPYPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX ./COPYPEX.sh  2>> err.log;
  exitIfError;
  echo "$(date) ${BASH_SOURCE##*/} Performance Engine Extensions copy script generated";
  cat COPYPE.sh COPYPEX.sh > COPY.sh ;
  exitIfError;
else  
  cat COPYPE.sh > COPY.sh ;
  exitIfError;
fi 
chmod 755 COPY.sh ;
exitIfError;
#
# Create build JCL from templates
#  -- Generate for PE 
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/BUILDPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE_A/tablesPE ../JCL/BUILDPE.jcl  2>> err.log;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} Performance Engine build JCL generated";
#  -- Generate for PEX, if required
if  [ "$INCLUDE_PEX" == "Y" ]; then 
  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar ../FTL/BUILDPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE_A/tablesPEX ../JCL/BUILDPEX.jcl 2>> err.log;
  exitIfError;
  echo "$(date) ${BASH_SOURCE##*/} Performance Engine Extensions build JCL generated";
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

main "$@"
