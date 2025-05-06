#!/bin/bash
# RunReg.sh Run the regression suite
#######################################
main() {

RCA_REPO=$(basename $GERS_REMOTE_RUN .git);
echo $RCA_REPO ;

# Are we building on zOS ?
if [ "$BLDRCA" == "ZOS" ]; then 

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
  if [ "$GERS_RCA_DB2_INPUT" == "Y" ]; then
    mvn -B install -DskipTests -Pdb2;
  else
    mvn -B install -DskipTests;
  fi 
  exitIfError ;
  export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
  echo RCA release number $rev;

  cp RCApps/target/rcapps-$rev-jar-with-dependencies.jar $GERS_RCA_JAR_DIR/rcapps-$rev.jar;
  cd $GERS_RCA_JAR_DIR ;

  touch rcapps-latest.jar;
  rm rcapps-latest.jar;
  ln -s rcapps-$rev.jar rcapps-latest.jar;

  MINOR_REL="PM"$BLDVER$BLDMAJ$BLDMIN;

  touch rcapps-$MINOR_REL.jar;
  rm rcapps-$MINOR_REL.jar;
  ln -s rcapps-$rev.jar rcapps-$MINOR_REL.jar;

  cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
  ./target/bin/gerstf;

elif [ "$BLDRCA" == "WIN" ]; then 
# already built on Windows and uploaded to zOS
  cd $GERS_GIT_REPO_DIR/$RCA_REPO;
  exitIfError ;

  export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
  echo RCA release number $rev;

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

  cd $GERS_GIT_REPO_DIR/$RCA_REPO/PETestFramework/;
  ./target/bin/gerstf;

fi 

}

exitIfError() {

if [ $? != 0 ]
then
    echo "*** Process terminated: see error message above";
    exit 1;
fi 

}

main "$@"
