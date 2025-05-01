//NDSNHPC JOB (ACCT),'DB2PRECOMPILER',
//            NOTIFY=&SYSUID.,
//            CLASS=A,
//            MSGLEVEL=(1,1),
//            TIME=(0,45),
//            MSGCLASS=X
//*
//*********************************************************************
//*   Call DSNHPC                                                      
//*********************************************************************
//*                                                                    
//STEP01   EXEC PGM=BPXBATCH,                                          
//            COND=(4,LT)                                              
//*                                                                    
//SYSOUT   DD SYSOUT=*                                                 
//SYSUDUMP DD SYSOUT=*                                                 
//STDOUT   DD SYSOUT=*                                                 
//STDERR   DD SYSOUT=*                                                 
//*                                                                    
//STDPARM  DD *,SYMBOLS=EXECSYS                                        
sh ;                                                                   
set -o xtrace;                                                         
set -e;                                                                
PATH="$PATH":/u/nbeesle/DllLib;                                        
export PATH="$PATH";                                                   
env;                                                                   
tso "EXEC EXEC.CLIST(MEM1)";                                           
/*
//
