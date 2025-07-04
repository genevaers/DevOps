#!/usr/bin/env bash
# JobWaiter.sh - check for job completion
########################################################

if [ "$msgLevel"  == "verbose" ]; then
  echo "Arg0: $0";
  echo "Arg1: $1"; # waiting time (seconds)
  echo "Arg2: $2"; # name of signal lock
fi 

timeout="$1";

if [[ "$timeout" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  echo "$(date) ${BASH_SOURCE##*/} Timeout (s): $timeout";
else
  if [[ "$timeout" = "" ]]; then
    echo "$(date) ${BASH_SOURCE##*/} Default Timeout (s): 300";
    timeout=300;
  else
    echo "$(date) ${BASH_SOURCE##*/} timeout value not numeric: $timeout" >&2;
    return 1; # It's not numeric (false)
  fi
fi

Filel="$2";
if [[ "$Filel" = "" ]]; then
  Filel="lockdone";
fi

current_time_ms=$(date +"%H:%M:%S");  
echo "$(date) ${BASH_SOURCE##*/} Job submitted at: $current_time_ms" ;                

elapsed_time=0;

echo "$(date) ${BASH_SOURCE##*/} Signal lock name: $Filel" ;

while [ ! ]; do
  # test for existence of done lock
  echo "$(date) ${BASH_SOURCE##*/} Checking signal lock: $File1" ;
  ls $Filel 2>&1;
  status=$?;
#  echo "status: $status";
  if [ $status -eq 0 ]; then
    current_time_ms=$(date +"%H:%M:%S");
    echo "$(date) ${BASH_SOURCE##*/} Job completed: $current_time_ms" ;
    export $(cat $Filel | xargs);
    echo "$(date) ${BASH_SOURCE##*/} Job status: $GERS_JOBSTATUS" ;
    echo "$(date) ${BASH_SOURCE##*/} Done signal lock identified and removed" ;
    rm $Filel;
  # break and not exit here - this script is dotted in
    break;
  fi

  # check for expiration of waiting period
  echo "$(date) ${BASH_SOURCE##*/} Elapsed time: $elapsed_time" ;
  elapsed_time=$((elapsed_time+5));
  if [ "$elapsed_time" -gt "$timeout" ]; then
    echo "$(date) ${BASH_SOURCE##*/} Timeout reached without determining job completion" >&2;
    echo "$(date) ${BASH_SOURCE##*/} Check Job output for $GERS_JOBID"  >&2
    return 1;
  fi
  sleep 5;
done
