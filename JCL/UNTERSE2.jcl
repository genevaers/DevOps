//UNTERSE2 JOB (ACCT),'UNTERSE TRANSFER2',
//            NOTIFY=&SYSUID.,             
//            CLASS=A,                     
//            MSGLEVEL=(1,1),
//            MSGCLASS=H
//*
//   EXPORT SYMLIST=*
//   SET FILECYLS='&$FILECY.'
//* 
/* *******************************************************************
//DELDSN   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=EXECSYS                 
 DELETE  &SYSUID..TRANSFER.PDS     PURGE
  IF LASTCC > 0  THEN
      SET MAXCC = 0  
/*
//* *******************************************************************
//UNTERSE  EXEC PGM=TRSMAIN,PARM=UNPACK
//SYSPRINT DD  SYSOUT=*
//INFILE   DD  DSN=&SYSUID..TRANSFER.TRS,                   
//             DISP=SHR
//OUTFILE  DD  DSN=&SYSUID..TRANSFER.PDS,
//             DSORG=PO,DSNTYPE=LIBRARY,
//             SPACE=(CYL,(&FILECYLS.,&FILECYLS.),RLSE),
//             DISP=(,CATLG,DELETE)
//