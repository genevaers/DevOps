#!/bin/bash

# Invoke as follows: SUBMITTER.sh '//GEBT.RTC22964.JCL(LISTDS)' lockdone
# Where submitter job includes last job step:
#
# //*********************************************************************
# //*   Signal completion to calling job
# //*********************************************************************
# //*
# //STEP99   EXEC PGM=BPXBATCH,
# //            COND=(4,LT)
# //*
# //STDOUT   DD SYSOUT=*
# //STDERR   DD SYSOUT=*
# //*
# //STDPARM  DD *,SYMBOLS=EXECSYS
# sh ;
# set -o xtrace;
# set -e;
# touch lockdone;
# status=$?;
# echo "Touchstatus: $status";
# /*
#
# Then invoke: WAITER.sh 60 lockdone

echo "Arg0: $0";
echo "Arg1: $1";
echo "Arg2: $2";

Cmd1="$1";
if [[ "$Cmd1" = "" ]]; then
  echo "No JCL supplied";
  exit 1;
else
  echo "Command to submit $Cmd1"; 
fi

Filel="$2";
if [[ "$Filel" = "" ]]; then
  echo "No lock file supplied";
  exit 1;
else
  echo "Lock signal file: $Filel";
fi

touch $Filel;
rm $Filel;

submit $Cmd1 # > out.txt;
job_rc=$?;
echo "job_rc: $job_rc";

