//*********************************************************************
//*   Signal completion to calling script
//*********************************************************************
//*
//CONDAB  IF ABEND THEN
//STEP99   EXEC PGM=BPXBATCH
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDPARM  DD   *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
echo $DEV_REPO ;
cd $GERS_GIT_REPO_DIR/$DEV_REPO/SH ;
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
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
echo $DEV_REPO ;
cd $GERS_GIT_REPO_DIR/$DEV_REPO/SH ;
echo "GERS_JOBSTATUS=LE4" > unterse1done;
cat unterse1done;
/*
//CONDGE8 ELSE
//STEP9N   EXEC PGM=BPXBATCH
//STDOUT   DD   SYSOUT=*
//STDERR   DD   SYSOUT=*
//STDPARM  DD   *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
echo $DEV_REPO ;
cd $GERS_GIT_REPO_DIR/$DEV_REPO/SH ;
echo "GERS_JOBSTATUS=GE8" > unterse1done;
cat unterse1done;
/*
//        ENDIF
//        ENDIF
//
