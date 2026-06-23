//UNTERSE1 JOB (ACCT),'UNTERSE TRANSFER',
//            NOTIFY=&SYSUID.,             
//            CLASS=A,                     
//            MSGLEVEL=(1,1),
//            MSGCLASS=H
//*
//DELDSN   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=EXECSYS                 
 DELETE  &SYSUID..TRANSFER.TRS        PURGE
/*
//* 
//ALLOCDSN EXEC PGM=IEFBR14                    
//DD1      DD DSN=&SYSUID..TRANSFER.TRS,     
//            DCB=(RECFM=FB,LRECL=1024,BLKSIZE=4096,DSORG=PS),
//            DISP=(,CATLG,DELETE),            
//            SPACE=(CYL,(100,100),RLSE),    
//            UNIT=SYSDA
//            