#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

USER="$1";
SERVER="$2";
FILENAME="$3";

if [ -z "$1" ] || [[ "$1" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No user ID and domain has been supplied";
  exit 1;
fi

if [ -z "$2" ] || [[ "$2" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No server has been supplied";
  exit 1;
fi

if [ -z "$3" ] || [[ "$3" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No filename has been supplied";
  exit 1;
fi

echo "$(date) ${BASH_SOURCE##*/} Logon to your site server ($SERVER) and retrieve desired file: $FILENAME. Afterwards 'quit' to continue.";

sftp -F ~/.ssh_config $USER@$SERVER;
exitIfError;

}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi

}

main "$@"