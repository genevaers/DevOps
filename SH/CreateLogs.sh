#!/usr/bin/env bash
# CreateLogs.sh - Create timestamped log files
########################################################

main() {

if [ -z "$1" ] || [[ "$1" = "" ]]; then
  TITLE="Build";
else
  TITLE="$1";
fi

log_dir=../LOG ;
[ -d $log_dir ] || mkdir $log_dir ;
log_date=$(date '+%Y-%m-%d-%H%M%S');
export out_log="$log_dir/out-$log_date.log";
touch $out_log;
chtag -c"iSO8859-1" -t $out_log;
echo "$(date) ${BASH_SOURCE##*/} Create stdout log file  ${out_log##*/}" | tee $out_log ;
exitIfError;
echo "$(date) ${BASH_SOURCE##*/} $TITLE run by $LOGNAME" | tee $out_log ;
export err_log="$log_dir/err-$log_date.log";
touch $err_log;
chtag -c"iSO8859-1" -t $err_log;
echo "$(date) ${BASH_SOURCE##*/} Create stderr log file  ${err_log##*/}" | tee $err_log ;
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