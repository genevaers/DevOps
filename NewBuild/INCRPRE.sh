#!/bin/bash

#### THIS SCRIPT MUST BE DOTTED IN TO EXECUTE INLINE WITH CALLING SCRIPT
####
#### IT PRODUCES AN MVS DATASET LIST USED BY INCRBLD
####
####  tsocmd "LISTDS 'GEBT.NEILB.PM501001.*.GVBLOAD'"

# Dataset name to start searching from

thishlq=$HLQ;
echo "thishlq: $thishlq";
dsname=$thishlq.B0000.GVBLOAD;
echo "dsname: $dsname";

cmd="LISTDS '$dsname';";
echo "cmd $cmd";
echo $cmd > lst.cmd;
