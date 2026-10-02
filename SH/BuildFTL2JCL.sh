#!/usr/bin/env bash
# BuildFTL2JCL.sh Build the Java tool for templates
#######################################
main() {

DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
if [ "$msgLevel"  == "verbose" ]; then
  echo $DEV_REPO ;
fi 
save_pwd=$(pwd) ;

# Check if we already have this version of the ftl2jcl jar
cd $GERS_GIT_REPO_DIR/$DEV_REPO/FTL2JCL;
exitIfError ;
export rev=`grep "<revision>" pom.xml | awk -F'<revision>||</revision>' '{print $2}'`;

if [[ -f "$GERS_RCA_JAR_DIR/ftl2jcl-$rev.jar" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} FTL2JCL $GERS_RCA_JAR_DIR/ftl2jcl-$rev.jar already exists."

# Are we building on zOS ?

  if [ "$GERS_BUILD_RCA" == "ZOS" ]; then 
    echo "$(date) ${BASH_SOURCE##*/} Start FTL2JCL Build";
#  cd $GERS_GIT_REPO_DIR/$DEV_REPO/FTL2JCL;
    exitIfError ;
    ./build.sh ;
    exitIfError ;
    
  elif [ "$GERS_BUILD_RCA" == "WIN" ]; then 
# already built on Windows and uploaded to zOS
    echo "$(date) ${BASH_SOURCE##*/} Copy and link Windows built FTL2JCL";
#  cd $GERS_GIT_REPO_DIR/$DEV_REPO/FTL2JCL;
    exitIfError ;

#    export rev=`grep "<revision>" pom.xml | awk -F'<revision>|</revision>' '{print $2}'`;
#    echo "FTL2JCL release number" $rev;

    cd target ;
    chtag -b *.jar ;
    chmod 775 *.jar ;
    exitIfError ;  

    cp ./*-jar-with-dependencies.jar $GERS_RCA_JAR_DIR/ftl2jcl-$rev.jar;       
    exitIfError ;                                  

    cd $GERS_RCA_JAR_DIR;                                                    
                                                                          
    touch ftl2jcl-latest.jar;                                                 
    rm ftl2jcl-latest.jar;                                                    
    ln -s ftl2jcl-$rev.jar ftl2jcl-latest.jar;
    exitIfError ;
    
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
