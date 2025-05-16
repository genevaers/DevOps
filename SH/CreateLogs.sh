#!/bin/bash
# ALIAS.sh - Create Aliases for data sets
########################################################

main() {


log_dir=../LOG ;
[ -d $log_dir ] || mkdir $log_dir ;
log_date=$(date '+%Y-%m-%d-%H%M%S');
export out_log="$log_dir/out-$log_date.log";
echo "$(date) ${BASH_SOURCE##*/} Create stdout log file  ${out_log##*/}" | tee $out_log ;
exitIfError;
export err_log="$log_dir/err-$log_date.log";
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