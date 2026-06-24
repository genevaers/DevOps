#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

USER="$1";
SERVER="$2";

if [ -z "$1" ] || [[ "$1" = "" ]]; then
  echo "No user ID and domain has been supplied";
  exit 1;
fi

if [ -z "$2" ] || [[ "$2" = "" ]]; then
  echo "No server has been supplied";
  # exit 1;
fi

echo "$(date) ${BASH_SOURCE##*/} Retrieving file from server $SERVER for $USER";

sftp -F ~/.ssh_config $USER@$SERVER;
exitIfError;

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