//NINCRBLD JOB (ACCT),'INCREMENT BUILD NUM',
//            NOTIFY=&SYSUID.,
//            CLASS=A,
//            MSGLEVEL=(1,1),
//            TIME=(0,45),
//            MSGCLASS=X
//*
//*********************************************************************
//*   Delete previous work files
//*********************************************************************
//*
//STEP01   EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//STDPARM  DD *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
echo;
touch temp.txt;
touch lst.txt;
rm temp.txt;
rm lst.txt;
/*
//*
//*********************************************************************
//*   Produce the list of datasets
//*********************************************************************
//*
//STEP02   EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//STDPARM  DD *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
echo;
. .profile;
export HLQ=GEBT.NEILB.PM501001;
tsocmd "LISTDS '$HLQ.*.GVBLOAD';" > lst.txt;
cat lst.txt;
/*
//*********************************************************************
//*   Process list of GVBLOAD datasets to get next build number
//*********************************************************************
//*
//STEP03   EXEC PGM=BPXBATCH
//*           COND=(4,LT)
//*
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//STDPARM  DD *
sh ;
set -o xtrace;
set -e;
echo;
bash;
INCRBLD.sh;
echo "Next number: $nextnumber";
env;
/*
//