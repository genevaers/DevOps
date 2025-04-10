#!/bin/bash

# echo "Arg0: $0";
# echo "Arg1: $1";
# echo "Arg2: $2";

input="$1"; 
 
if [[ "$input" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
    echo "input numeric";
    exit 0; # It's numeric (true)
  else
    if [[ "$input" = "" ]]; then
      echo "input blank";
      exit 1; 
    else 
      echo "input not numeric";
      exit 1; # It's not numeric (false)
    fi
fi
