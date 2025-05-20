#!/bin/sh
# CloneRepos.sh - Clone required repositories ready for build
########################################################

main() {

echo "$(date) ${BASH_SOURCE##*/} Start process of cloning the repositories";
save_pwd=$(pwd);
# extract repository names
PE_REPO=$(basename $GERS_REMOTE_PEB .git);
PEX_REPO=$(basename $GERS_REMOTE_PEX .git);
RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo "Repository names";
  echo $PE_REPO ;
  echo $PEX_REPO ;
  echo $RCA_REPO ;
fi 
# Change into local directory where you want to clone to
cd $GERS_GIT_REPO_DIR ;
exitIfError;
# Clone Performance Engine repo, if required
if [ "$GERS_CLONE_PE" == "Y" ]; then
  rm -rf $PE_REPO;
  exitIfError;
  git clone --progress $GERS_REMOTE_PEB 2>&1;
  exitIfError;
fi
cd $PE_REPO;
git checkout $GERS_BRANCH_PE;
exitIfError;
cd ..
# Clone PE Extensions repo, if required
if [ "$GERS_CLONE_PEX" == "Y" ]; then
  rm -rf $PEX_REPO;
  exitIfError;
  git clone --progress $GERS_REMOTE_PEX 2>&1;
  exitIfError;
fi
cd $PEX_REPO;
git checkout $GERS_BRANCH_PEX;
exitIfError;
cd ..
# Clone RCA repo, or clean the Test Framework output dir
if [ "$GERS_CLONE_RCA" == "Y" ]; then
  rm -rf $RCA_REPO;
  exitIfError;
  git clone --progress $GERS_REMOTE_RUN 2>&1;
  exitIfError;
else
  rm -rf $RCA_REPO/PETestFramework/out;
  exitIfError;
fi
cd $RCA_REPO;
git checkout $GERS_BRANCH_RCA;
exitIfError;
cd ..
echo "$(date) ${BASH_SOURCE##*/} Repositories cloned and branches checked out";
cd $save_pwd ;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"
