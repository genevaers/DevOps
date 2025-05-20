#!/bin/bash
# JobWaiter.sh - check for job completion
########################################################


if [ "$msgLevel"  == "verbose" ]; then
  echo "Arg0: $0";
  echo "Arg1: $1"; # waiting time (seconds)
  echo "Arg2: $2"; # name of signal lock
fi 

timeout="$1";

if [[ "$timeout" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Timeout (s): $timeout";
else
  if [[ "$timeout" = "" ]]; then
    echo "Default Timeout (s): 300";
    timeout=300;
  else
    echo "timeout value not numeric: $input";
    exit 1; # It's not numeric (false)
  fi
fi
# echo "timeout: $timeout";

Filel="$2";
if [[ "$Filel" = "" ]]; then
  Filel="lockdone";
fi

current_time_ms=$(date +"%H:%M:%S");                  
echo "Job submitted at: $current_time_ms";

# timeout=$(input); # Timeout in seconds
elapsed_time=0;

# Filel="lockdone";
echo "Signal lock name: $Filel";

while [ ! ]; do
  # test for existence of done lock
  echo "Checking signal lock: $File1";
  ls $Filel;
  status=$?;
#  echo "status: $status";
  if [ $status -eq 0 ]; then
    current_time_ms=$(date +"%H:%M:%S");
    echo "Job completed: $current_time_ms";
    export $(cat $Filel | xargs);
    echo "Job status: " $GERS_JOBSTATUS;
    echo "Done signal lock identified and removed";
    rm $Filel;
  # break and not exit here - this script is dotted in
    break;
  fi

  # check for expiration of waiting period
  echo "elapsed_time: $elapsed_time";
  elapsed_time=$((elapsed_time+5));
  if [ "$elapsed_time" -gt "$timeout" ]; then
    echo "Timeout reached without determining job completion";
    echo "Check Job output for $GERS_JOBID"
    exit 1;
  fi
  sleep 5;
done

# echo "Dont come here!!!!";
