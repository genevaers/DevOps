//UNTERSE1 JOB (ACCT),'UNTERSE TRANSFER1',
//            NOTIFY=&SYSUID.,             
//            CLASS=A,                     
//            MSGLEVEL=(1,1),
//            MSGCLASS=H
//*
//   EXPORT SYMLIST=*
//   SET FILENAME=&$FILENM.
//*
//* 1) USS file name being received
//* 2) Size of data ???
//* 3) DSNTYPE
//* 
/* *******************************************************************
//DELDSN   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=EXECSYS                 
 DELETE  &SYSUID..TRANSFER.TRS     PURGE
  IF LASTCC > 0  THEN
      SET MAXCC = 0  
/*
//* *******************************************************************
//ALLOCDSN EXEC PGM=IEFBR14                    
//DD1      DD DSN=&SYSUID..TRANSFER.TRS,     
//            DCB=(RECFM=FB,LRECL=1024,BLKSIZE=4096,DSORG=PS),
//            DISP=(,CATLG,DELETE),            
//            SPACE=(CYL,(100,100),RLSE),    
//            UNIT=SYSDA
//* *******************************************************************
//DSNCOPY  EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//SYSPRINT DD *
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *,SYMBOLS=EXECSYS
sh ;
set -e;
set -o xtrace;
echo;
cd ~/git/public/DevOps/SH;
cp &FILENAME "//'&SYSUID..TRANSFER.TRS'";
echo $?
/*
//
//* cp 99914.122.000.JCL.TRS "//'&SYSUID..TRANSFER.TRS'";