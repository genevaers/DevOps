//*********************************************************************
//*   Signal completion to calling job
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
echo "GERS_JOBSTATUS=ABD" > allocdone;
cat allocdone;
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
echo "GERS_JOBSTATUS=LT8" > allocdone;    
cat allocdone;                    
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
echo "GERS_JOBSTATUS=GT8" > allocdone;
cat allocdone;
/*
//        ENDIF
//        ENDIF