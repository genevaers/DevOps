#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

USER="$1";
SERVER="$2";

if [ -z "$1" ] || [[ "$1" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No user ID and domain has been supplied";
  exit 1;
fi

if [ -z "$2" ] || [[ "$2" = "" ]]; then
  echo "$(date) ${BASH_SOURCE##*/} No server has been supplied";
  # exit 1;
fi

sftp -F ~/.ssh_config $USER@$SERVER;
exitIfError;

echo "$(date) ${BASH_SOURCE##*/} Successfully retrieved file from server $SERVER for $USER";
ls
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi

}

main "$@"