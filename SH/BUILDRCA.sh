#!/bin/bash
# RunReg.sh Run the regression suite
#######################################
main() {

RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo $RCA_REPO ;
fi 
save_pwd=$(pwd) ;
# Are we building on zOS ?
if [ "$BUILD_RCA" == "ZOS" ]; then 
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

  touch rcapps-latest.jar;
  rm rcapps-latest.jar;
  ln -s rcapps-$rev.jar rcapps-latest.jar;

  MINOR_REL="PM"$BLDVER$BLDMAJ$BUILD_MINOR;

  touch rcapps-$MINOR_REL.jar;
  rm rcapps-$MINOR_REL.jar;
  ln -s rcapps-$rev.jar rcapps-$MINOR_REL.jar;

  echo "$(date) ${BASH_SOURCE##*/} Run regression tests";
  cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
  exitIfError;
  ./target/bin/gerstf;

elif [ "$BUILD_RCA" == "WIN" ]; then 
# already built on Windows and uploaded to zOS
  echo "$(date) ${BASH_SOURCE##*/} Copy and link Windows built RCA";
  cd $GERS_GIT_REPO_DIR/$RCA_REPO;
  exitIfError ;

  export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
  echo "$(date) ${BASH_SOURCE##*/} RCA release number $rev";

  cd RCApps/target ;
  chtag -b *.jar ;
  chmod 755 *.jar ;

  cp rcapps-$rev-jar-with-dependencies.jar $GERS_RCA_JAR_DIR/rcapps-$rev.jar;
  cd $GERS_RCA_JAR_DIR;

  touch rcapps-latest.jar;
  rm rcapps-latest.jar;
  ln -s rcapps-$rev.jar rcapps-latest.jar;

  touch rcapps-$MINOR_REL.jar;
  rm rcapps-$MINOR_REL.jar;
  ln -s rcapps-$rev.jar rcapps-$MINOR_REL.jar;

  echo "$(date) ${BASH_SOURCE##*/} Run regression tests";
  cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
  exitIfError ;
  ./target/bin/gerstf;

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
