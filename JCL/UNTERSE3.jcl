//UNTERSE3 JOB (ACCT),'UNTERSE TRANSFER3',
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
 DELETE  &SYSUID..TRANSFER.SEQ     PURGE
  IF LASTCC > 0  THEN
      SET MAXCC = 0  
/*
//* *******************************************************************
//UNTERSE  EXEC PGM=TRSMAIN,PARM=UNPACK
//SYSPRINT DD   SYSOUT=*
//INFILE   DD DSN=&SYSUID..TRANSFER.TRS,                   
//         DISP=SHR
//OUTFILE  DD DSN=&SYSUID..TRANSFER.SEQ,
//         DSORG=PS,DSNTYPE=BASIC,
//         SPACE=(CYL,(&FILECYLS.,&FILECYLS.),RLSE),
//         DISP=(,CATLG,DELETE)
//*
//