#!/usr/bin/env bash
# BuildRCApps.sh Build RCA then run the regression suite
#######################################
main() {

RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo $RCA_REPO ;
fi 
save_pwd=$(pwd) ;
MINOR_REL="PM"$GERS_BUILD_VERSION$GERS_BUILD_MAJOR$GERS_BUILD_MINOR;
# Are we building on zOS ?
if [ "$GERS_BUILD_RCA" == "ZOS" ]; then 
  echo "$(date) ${BASH_SOURCE##*/} Start RCA Build";
  cd $GERS_JARS;
  exitIfError ;
  java -cp ./db2jcc4.jar com.ibm.db2.jcc.DB2Jcc -version;
  echo;
  cd $GERS_GIT_REPO_DIR/$RCA_REPO;
  exitIfError ;
  chmod +x prebuild/*.sh;
  mvn clean;
  exitIfError ;
# Build RCA, checking for Db2 requirement
  if [ "$GERS_DB2_JAVA" == "Y" ]; then
    mvn -B install -DskipTests -Pdb2;
  else
    mvn -B install -DskipTests;
  fi 
  exitIfError ;
  export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
  echo "$(date) ${BASH_SOURCE##*/} RCA release number $rev";

  cp RCApps/target/rcapps-$rev-jar-with-dependencies.jar $GERS_RCA_JAR_DIR/rcapps-$rev.jar;
  cd $GERS_RCA_JAR_DIR ;
  exitIfError ;

  touch rcapps-latest.jar;
  rm rcapps-latest.jar;
  ln -s rcapps-$rev.jar rcapps-latest.jar;

  touch rcapps-$MINOR_REL.jar;
  rm rcapps-$MINOR_REL.jar;
  ln -s rcapps-$rev.jar rcapps-$MINOR_REL.jar;

  if [ "$GERS_RUN_TESTS" == "Y" ]; then 
    echo "$(date) ${BASH_SOURCE##*/} Run regression tests";
    cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
    exitIfError;
    ./target/bin/gerstf 2>&1;
    exitIfError ;
    cd out;
    chtag  -R -c 819 *;
    chtag  -R -t *;
    cat fmoverview.txt ;
  fi 

elif [ "$GERS_BUILD_RCA" == "WIN" ]; then 
# already built on Windows and uploaded to zOS
  echo "$(date) ${BASH_SOURCE##*/} Copy and link Windows built RCA";
  cd $GERS_GIT_REPO_DIR/$RCA_REPO;
  exitIfError ;

  export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
  echo "$(date) ${BASH_SOURCE##*/} RCA release number $rev";

  cd RCApps/target ;
  exitIfError ;
  chtag -b *.jar ;
  chmod 755 *.jar ;
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
  chmod 755 *.jar;
  exitIfError ;  
  cd bin;
# To run on z/OS Unix the script gerstf must be in EBCDIC
  mv gerstf gerstf.old;
  iconv -f"ISO8859-1" -t"IBM-1047" gerstf.old > gerstf;
  rm gerstf.old;
  chtag -t -c"IBM-1047" gerstf;
  chmod 755 gerstf;
  exitIfError ;  

  if [ "$GERS_RUN_TESTS" == "Y" ]; then 
    echo "$(date) ${BASH_SOURCE##*/} Run regression tests";
    cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
    exitIfError ;
    ./target/bin/gerstf 2>&1;
    exitIfError ;
    cd out;
    chtag  -R -c 819 *;
    chtag  -R -t *;
    cat fmoverview.txt ;  
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
