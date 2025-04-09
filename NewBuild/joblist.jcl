//NLISTJES JOB (ACCT),'Store JES output',                        
//          NOTIFY=&SYSUID.,                                         
//          CLASS=A,                                                 
//          MSGLEVEL=(1,1),                                          
//          MSGCLASS=H                                               
//*                                                                  
//*                                                                  
//*******************************************************************
//*   Signal completion to calling job                               
//*******************************************************************
//*                                                                  
//STEP99   EXEC PGM=BPXBATCH,                                        
//            COND=(4,LT)                                            
//*                                                                  
//STDOUT   DD SYSOUT=*                                               
//STDERR   DD SYSOUT=*                                               
//*                                                                  
//STDPARM  DD *,SYMBOLS=EXECSYS                                      
sh ;                                                                 
set -o xtrace;                                                       
set -e;                                                              
joblist.sh NLISTDS GEBT.RTC22964.LISTJOB;                            
cat isfin.txt;                                                       
iconv -f ISO8859-1 -t IBM-1047 isfin.txt > isfin.ebcdic;             
/*                                                                   
//*                                                                  
//*******************************************************************
//*   GET SOURCE CODE FROM USS                                       
//*******************************************************************
//*                                                                  
//GETSRC   EXEC PGM=IKJEFT1A                                         
//*                                                                  
//SYSEXEC  DD DISP=SHR,DSN=SYS1.SBPXEXEC                             
//*                                                                  
//ISPWRK1  DD DISP=(NEW,DELETE,DELETE),                              
//            UNIT=VIO,                                              
//            SPACE=(TRK,(10000,10000)),                             
//            DCB=(LRECL=256,BLKSIZE=2560,RECFM=FB)                  
//*                                                                  
//ISPLOG   DD DUMMY                              ISPF LOG FILE       
//*                                                                  
//ISPPROF  DD DISP=(NEW,DELETE,DELETE),          ISPF PROFILE        
//            UNIT=SYSDA,                                            
//            DCB=(DSORG=PO,RECFM=FB,LRECL=80),                      
//            SPACE=(TRK,(5,5,5))                                    
//*                                                                  
//ISPPLIB  DD DSN=ISP.SISPPENU,                                      
//            DISP=SHR                           ISPF PANELS         
//*                                                                  
//ISPMLIB  DD DSN=ISP.SISPMENU,                                      
//            DISP=SHR                           ISPF MENUS          
//         DD DSN=SYS1.SBPXMENU,                                     
//            DISP=SHR                           ISPF MENUS          
//*                                                                  
//ISPTLIB  DD DISP=(NEW,DELETE,DELETE),          ISPF TABLES (INPUT) 
//            UNIT=SYSDA,                                            
//            SPACE=(TRK,(5,5,5)),                                     
//            DCB=(DSORG=PO,RECFM=FB,LRECL=80)                         
//         DD DSN=ISP.SISPTENU,                                        
//            DISP=SHR                                                 
//*                                                                    
//ISPSLIB  DD DSN=ISP.SISPSLIB,                                        
//            DISP=SHR                           JCL SKELETONS         
//*                                                                    
//ISPLLIB  DD DISP=SHR,DSN=SYS1.LINKLIB                                
//         DD DISP=SHR,DSN=ISP.SISPLOAD                                
//*                                                                    
//SYSTSPRT DD SYSOUT=*                                                 
//*                                                                    
//ISPTABL  DD DUMMY                              ISPF TABLES (OUTPUT)  
//*                                                                    
//ISPFTTRC DD SYSOUT=*,RECFM=VB,LRECL=259        TSO OUTPUT            
//*                                                                    
//SYSTSIN  DD *                                                        
 OGET '/u/nbeesle/isfin.ebcdic' -                                      
  'GEBT.RTC22964.SYSTSIN(ISFIN1)'                                      
//*                                                                    
//*                                                                    
//*                                                                    
//*********************************************************************
//* STORE JOB OUTPUT IN DATASET
//*********************************************************************
//*                                                                    
//COPYOUT  EXEC PGM=ISFAFD,                                            
//          PARM='++41,1000',                                          
//          COND=(4,LT)                                                
//*                                                                    
//ISFOUT   DD SYSOUT=*                                                 
//*                                                                    
//*SFIN    DD *,SYMBOLS=EXECSYS                                        
//ISFIN     DD DISP=SHR,DSN=GEBT.RTC22964.SYSTSIN(ISFIN1)              
//                                                                     
