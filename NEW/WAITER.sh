#!/bin/bash

echo "Arg0: $0";
echo "Arg1: $1"; # wiating time (seconds)
echo "Arg2: $2"; # name of signal lock

timeout="$1";

if [[ "$timeout" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
  echo "numeric timeout: $timeout";
else
  if [[ "$timeout" = "" ]]; then
    echo "timeout value blank, so use default (300)";
    timeout=300;
  else
    echo "timeout value not numeric: $input";
    exit 1; # It's not numeric (false)
  fi
fi
echo "timeout: $timeout";

Filel="$2";
if [[ "$Filel" = "" ]]; then
  Filel="lockdone";
fi

current_time_ms=$(date +"%H:%M:%S");                  
echo "Job sibmitted at: $current_time_ms";

# timeout=$(input); # Timeout in seconds
elapsed_time=0;

# Filel="lockdone";
echo "Filel: $Filel";

while [ ! ]; do
  # test for existence of done lock
  ls $Filel;
  status=$?;
  echo "status: $status";
  if [ $status -eq 0 ]; then
    current_time_ms=$(date +"%H:%M:%S");
    echo "Job completed: $current_time_ms";
    echo "Done signal lock identified and removed";
    rm $Filel;
    exit 0;
  fi

  # check for expiration of waiting period
  echo "elapsed_time: $elapsed_time";
  elapsed_time=$((elapsed_time+5));
  if [ "$elapsed_time" -gt "$timeout" ]; then
    echo "Timeout reached without determining job completion";
    exit 1;
  fi
  sleep 5;
done

echo "Dont come here!!!!";
