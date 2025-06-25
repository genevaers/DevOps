#!/usr/bin/env bash
# BuildFTL2JCL.sh Build the Java tool for templates
#######################################
main() {

DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo $DEV_REPO ;
fi 
save_pwd=$(pwd) ;

# Are we building on zOS ?

if [ "$GERS_BUILD_RCA" == "ZOS" ]; then 
  echo "$(date) ${BASH_SOURCE##*/} Start FTL2JCL Build";
  cd $GERS_GIT_REPO_DIR/$DEV_REPO/FTL2JCL;
  exitIfError ;
  ./build.sh ;
  
elif [ "$GERS_BUILD_RCA" == "WIN" ]; then 
# already built on Windows and uploaded to zOS
  echo "$(date) ${BASH_SOURCE##*/} Copy and link Windows built FTL2JCL";
  cd $GERS_GIT_REPO_DIR/$DEV_REPO/FTL2JCL;
  exitIfError ;

  export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
  echo "FTL2JCL release number" $rev;

  chtag -b *.jar ;
  chmod 755 *.jar ;

  cp ./target/*-jar-with-dependencies.jar $GERS_RCA_JAR_DIR/ftl2jcl-$rev.jar;                                       
  cd $GERS_RCA_JAR_DIR;                                                    
                                                                         
  touch ftl2jcl-latest.jar;                                                 
  rm ftl2jcl-latest.jar;                                                    
  ln -s ftl2jcl-$rev.jar ftl2jcl-latest.jar;
  
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
