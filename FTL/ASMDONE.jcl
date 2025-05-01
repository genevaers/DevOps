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
cd $GERS_GIT_REPO_DIR/$DEV_REPO/FTL ;
touch asmdone;
status=$?;
echo "Touchstatus: $status";
/*