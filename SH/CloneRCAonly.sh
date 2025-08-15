#!/bin/sh
# CloneRCAonly.sh - Clone RCA repository ready to copy executables
########################################################

main() {

echo "$(date) ${BASH_SOURCE##*/} Start process of cloning RCA";
save_pwd=$(pwd);
# extract repository name
RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo "Repository names";
  echo $RCA_REPO ;
fi 
# Change into local directory where you want to clone to
cd $GERS_GIT_REPO_DIR ;
exitIfError;
# Clone RCA repo, or clean the Test Framework output dir
if [ "$GERS_CLONE_RCA" == "Y" ]; then
  rm -rf $RCA_REPO;
  exitIfError;
  git clone --progress $GERS_REMOTE_RUN ;
  exitIfError;
  echo "$(date) ${BASH_SOURCE##*/} RCA Repository cloned";
else
  echo "$(date) ${BASH_SOURCE##*/} RCA Repository not cloned: GERS_CLONE_RCA=$GERS_CLONE_RCA";
fi
cd $RCA_REPO;
git checkout $GERS_BRANCH_RCA ;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} RCA branch checked out";
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
