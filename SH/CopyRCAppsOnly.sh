#!/usr/bin/env bash
# CopyRCAppsOnly.sh Copy RCA to RCA jar directory
#######################################
main() {

RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo $RCA_REPO ;
fi 
save_pwd=$(pwd) ;
MINOR_REL="PM"$GERS_BUILD_VERSION$GERS_BUILD_MAJOR$GERS_BUILD_MINOR;

# Check if we already have this version of the rcapps jar in $GERS_RCA_JAR_DIR
cd $GERS_GIT_REPO_DIR/$RCA_REPO;
exitIfError ;
export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;

if [[ -f "$GERS_RCA_JAR_DIR/rcapps-$rev.jar" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} RCApps $GERS_RCA_JAR_DIR/rcapps-$rev.jar already exists."
  echo "$(date) ${BASH_SOURCE##*/} Remove $GERS_RCA_JAR_DIR/rcapps-$rev.jar and rerun build if required."
else
  # Are we building on zOS ?
  if [ "$GERS_BUILD_RCA" == "WIN" ]; then 
  # already built on Windows and uploaded to zOS
    echo "$(date) ${BASH_SOURCE##*/} Copy and link Windows built RCA";
    cd $GERS_GIT_REPO_DIR/$RCA_REPO;
    exitIfError ;

    # export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
    echo "$(date) ${BASH_SOURCE##*/} RCA release number $rev";

    cd RCApps/target ;
    exitIfError ;
    chtag -b *.jar ;
    chmod 775 *.jar ;
    exitIfError ;  
    cp rcapps-$rev-jar-with-dependencies.jar $GERS_RCA_JAR_DIR/rcapps-$rev.jar;
    exitIfError ;  
    cd $GERS_RCA_JAR_DIR;

    touch rcapps-latest.jar;
    rm rcapps-latest.jar;
    ln -s rcapps-$rev.jar rcapps-latest.jar;
    exitIfError ;  

    touch rcapps-$MINOR_REL.jar;
    rm rcapps-$MINOR_REL.jar;
    ln -s rcapps-$rev.jar rcapps-$MINOR_REL.jar;
    exitIfError ;  

    cd $GERS_GIT_REPO_DIR/$RCA_REPO;
    cd PETestFramework/target;
    exitIfError ;
    chtag -b  *.jar;
    chmod 775 *.jar;
    exitIfError ;  
    cd bin;
    chmod 775 gerstf;
    exitIfError ;  

    if [ "$GERS_RUN_TESTS" == "Y" ]; then 
    # regression tests will be run against 'GERS_ENV_HLQ'.GVBLOAD data set (often set as LATEST)
    # and the newly copied and linked 'rcapps-latest.jar'
      echo "$(date) ${BASH_SOURCE##*/} Run regression tests";
      cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
      exitIfError ;
      ./target/bin/gerstf ;
      exitIfError ;
      cd out;
      chtag  -R -c 819 *;
      chtag  -R -t *;
      cat fmoverview.txt ;  
    fi 
  else

    echo "$(date) ${BASH_SOURCE##*/} GERS_BUILD_RCA not set to WIN";

  fi 
fi

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
