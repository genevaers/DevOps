#!/bin/bash

echo "Arg0: $0";  # script name
echo "Arg1: $1";  # jcl to be submitted
echo "Arg2: $2";  # lock signal filename

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

submit $Cmd1 > out.txt;
job_rc=$?;
echo "job_rc: $job_rc";

