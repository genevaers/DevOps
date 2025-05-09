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
echo "Status:ABD" > asmdone;
cat asmdone;
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
echo "Status:LT8" > asmdone;    
cat asmdone;                    
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
echo "Status:GT8" > asmdone;
cat asmdone;
/*
//        ENDIF
//        ENDIF