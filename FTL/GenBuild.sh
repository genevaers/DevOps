#!/bin/bash
# GenBuild.sh - Generate build script and JCL
########################################################

main() {

# extract repository names
PE_REPO=$(basename $GERS_REMOTE_PEB .git);
echo $PE_REPO
PEX_REPO=$(basename $GERS_REMOTE_PEX .git);
echo $PEX_REPO
RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
echo $RCA_REPO
# Make ascii copies of the tables
cp $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/MAC.csv $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/MAC_e.csv;
cp $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/PGM.csv $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/PGM_e.csv;
cp $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE.csv $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE_e.csv;
#
rm $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/MAC.csv;
rm $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/PGM.csv;
rm $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE.csv;
#
iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE_e.csv  > $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE.csv;
iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/MAC_e.csv  > $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/MAC.csv;
iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/PGM_e.csv  > $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/PGM.csv;
#
# Create copy commands to copy source to data sets - this reads a table in each of the repositories
#
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar COPYPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE;
exitIfError;
# Performance Engine extensions required?
if  [ "$GERS_INCLUDE_PEX" == "Y" ]; then 
# Make ascii copies of the tables
  cp $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MACRND.csv $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MAC_e.csv;
  cp $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGMRND.csv $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGM_e.csv;
  cp $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX.csv $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX_e.csv;
#
  rm $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MACRND.csv;
  rm $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGMRND.csv;
  rm $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX.csv;
#
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX_e.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX.csv;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MAC_e.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/MACRND.csv;
  iconv -f IBM-1047 -t ISO8859-1 $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGM_e.csv  > $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/PGMRND.csv;

  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar COPYPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX ;
  exitIfError;
fi 
#
# Create build JCL from templates
#  -- Generate for PE 
java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar BUILDPE $GERS_GIT_REPO_DIR/$PE_REPO/TABLE/tablesPE;
exitIfError;
#  -- Generate for PEX, if required
if  [ "$GERS_INCLUDE_PEX" == "Y" ]; then 
  java -jar $GERS_RCA_JAR_DIR/ftl2jcl-latest.jar BUILDPEX $GERS_GIT_REPO_DIR/$PEX_REPO/TABLE/tablesPEX;
  exitIfError;
  ConcatJCL BIG.JCL BUILDPE.jcl BUILDPEX.jcl;
fi 

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above"
    exit 1
fi 

}

main "$@"
