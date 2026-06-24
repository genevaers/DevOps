//UNTERSE3 JOB (ACCT),'UNTERSE TRANSFER',
//            NOTIFY=&SYSUID.,             
//            CLASS=A,                     
//            MSGLEVEL=(1,1),
//            MSGCLASS=H
//*
//* Need to pass:
//* 1) USS file name being received
//* 2) Size of data ???
//* 3) DSNTYPE
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
//             DISP=SHR
//OUTFILE  DD DSN=&SYSUID..TRANSFER.SEQ,
//            DSORG=PS,DSNTYPE=BASIC,
// SPACE=(CYL,(500,500),RLSE),DISP=(,CATLG,DELETE)
//*
//