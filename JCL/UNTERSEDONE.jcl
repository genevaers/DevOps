//*********************************************************************
//*   Signal completion to calling script
//*********************************************************************
//*
//* DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
//* echo $DEV_REPO ;
//* 
//CONDAB  IF ABEND THEN
//STEP99   EXEC PGM=BPXBATCH
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDPARM  DD   *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
cd $GERS_GIT_REPO_DIR/DevOps/SH ;
pwd ;
echo "GERS_JOBSTATUS=ABD" > unterse1done;
cat unterse1done;
/*
//CONDABX ELSE
//COND01  IF RC < 8 THEN
//STEP90   EXEC PGM=BPXBATCH
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDPARM  DD   *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
cd $GERS_GIT_REPO_DIR/DevOps/SH ;
pwd ;
echo "GERS_JOBSTATUS=LE4" > untersedone;
cat untersedone;
/*
//CONDGE8 ELSE
//STEP9N   EXEC PGM=BPXBATCH
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDPARM  DD   *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
cd $GERS_GIT_REPO_DIR/DevOps/SH ;
pwd ;
echo "GERS_JOBSTATUS=GE8" > untersedone;
cat untersedone;
/*
//        ENDIF
//        ENDIF
//
