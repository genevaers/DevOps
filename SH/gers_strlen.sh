#!/usr/bin/env bash

# Determine if length greater than maximum allowed
# Check for upper case characters
# Return #GERS_STRING_UPPER
# Return #GERS_STRING_LENGTH

if [ "$msgLevel"  == "verbose" ]; then
  echo "Arg0: $0";
  echo "Arg1: $1";
  echo "Arg2: $2";
fi

Str="${1^^}";
if [[ "$Str" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No string supplied" >&2 ;
  return 1;
else
  echo "$(date) ${BASH_SOURCE##*/} String being measured (in upper case): $Str" ;
fi

MaxLen="$2";
if [[ "$MaxLen" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No max length supplied" >&2;
  return 1;
else
  echo "$(date) ${BASH_SOURCE##*/} Max allowed string length: $MaxLen";
fi

GERS_STRING_UPPER=$Str;
GERS_STRING_LENGTH=${#Str};

echo "$(date) ${BASH_SOURCE##*/} Actual string length: $GERS_STRING_LENGTH";

if [[ $GERS_STRING_LENGTH -gt $MaxLen ]]; then
  echo "$(date) ${BASH_SOURCE##*/} String is too long: $GERS_STRING_UPPER";
fi
