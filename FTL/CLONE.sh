#!/bin/sh
# CLONE.sh - Clone required repositories ready for build
########################################################

main() {

save_pwd=$(pwd);
# extract repository names
PE_REPO=$(basename $GERS_REMOTE_PEB .git);
echo $PE_REPO ;
PEX_REPO=$(basename $GERS_REMOTE_PEX .git);
echo $PEX_REPO ;
RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
echo $RCA_REPO ;
# Change into local directory where you want to clone to
cd $GERS_GIT_REPO_DIR ;
exitIfError;
# Clone Performance Engine repo, if required
if [ "$CLONE_PE" == "Y" ]; then
  rm -rf $PE_REPO;
  exitIfError;
  git clone $GERS_REMOTE_PEB;
  exitIfError;
fi
cd $PE_REPO;
git checkout $BRANCH_PE;
exitIfError;
cd ..
# Clone PE Extensions repo, if required
if [ "$CLONE_PEX" == "Y" ]; then
  rm -rf $PEX_REPO;
  exitIfError;
  git clone $GERS_REMOTE_PEX;
  exitIfError;
fi
cd $PEX_REPO;
git checkout $BRANCH_PEX;
exitIfError;
cd ..
# Clone RCA repo, or clean the Test Framework output dir
if [ "$CLONE_RCA" == "Y" ]; then
  rm -rf $RCA_REPO;
  exitIfError;
  git clone $GERS_REMOTE_RUN;
  exitIfError;
else
  rm -rf $RCA_REPO/PETestFramework/out;
  exitIfError;
fi
cd $RCA_REPO;
git checkout $BRANCH_RCA;
exitIfError;
cd ..

cd $save_pwd ;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"
