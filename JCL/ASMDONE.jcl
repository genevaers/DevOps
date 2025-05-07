//*********************************************************************
//*   Signal completion to calling job
//*********************************************************************
//*
//STEP99   EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//STDPARM  DD *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
DEV_REPO=$(basename $GERS_REMOTE_DEV .git);
echo $DEV_REPO ;
cd $GERS_GIT_REPO_DIR/$DEV_REPO/SH ;
touch asmdone;
status=$?;
echo "Touchstatus: $status";
/*