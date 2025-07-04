#!/usr/bin/env bash

# Invoke as follows: JobSubmitter.sh '//GEBT.RTC22964.JCL(LISTDS)' lockdone
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
# Then invoke: JobWaiter.sh 60 lockdone

if [ "$msgLevel"  == "verbose" ]; then
  echo "Arg0: $0";
  echo "Arg1: $1";
  echo "Arg2: $2";
fi 

Cmd1="$1";
if [[ "$Cmd1" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No JCL supplied" >&2 ;             
  return 1;
else
  echo "$(date) ${BASH_SOURCE##*/} Command to submit $Cmd1" ;  
fi

Filel="$2";
if [[ "$Filel" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No lock file supplied" >&2;
  return 1;
else
  echo "$(date) ${BASH_SOURCE##*/} Lock signal file: $Filel";
fi

touch $Filel;
rm $Filel;

submit $Cmd1  > out.txt;
job_rc=$?;
export GERS_JOBID=$(awk '/JOB/ {print $2}' out.txt);
echo "$(date) ${BASH_SOURCE##*/} Job number $GERS_JOBID" >&2;
echo "$(date) ${BASH_SOURCE##*/} RC from submit: $job_rc" >&2;
