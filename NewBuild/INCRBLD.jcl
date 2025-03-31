//NCBMR95 JOB (ACCT),'BUILD MR95 JAVA BITS',                           
//            NOTIFY=&SYSUID.,                                         
//            CLASS=A,                                                 
//            MSGLEVEL=(1,1),                                          
//            TIME=(0,45),                                             
//            MSGCLASS=X                                               
//*                                                                    
//*                                                                    
//*********************************************************************
//*   Delete previous files                                            
//*********************************************************************
//*                                                                    
//STEP05   EXEC PGM=BPXBATCH,                                          
//            COND=(4,LT)                                              
//*                                                                    
//STDOUT   DD SYSOUT=*                                                 
//STDERR   DD SYSOUT=*                                                 
//*                                                                    
//STDPARM  DD *,SYMBOLS=EXECSYS                                        
sh ;                                                                   
set -o xtrace;                                                         
echo;                                                                  
touch /u/nbeesle/lst.txt;                                                 
touch /u/nbeesle/lst.cmd;                                                 
rm /u/nbeesle/lst.txt;                                                 
rm /u/nbeesle/lst.cmd;                                                 
/*                                                                     
//*                                                                    
//*set -e;                                                             
//*                                                                    
//*********************************************************************
//*   Produce command to get the list of datasets                      
//*********************************************************************
//*                                                                    
//STEP06   EXEC PGM=BPXBATCH,                                    ,EVEN)
//            COND=(4,LT)                                              
//*                                                                    
//STDOUT   DD SYSOUT=*                                                 
//STDERR   DD SYSOUT=*                                                 
//*                                                                    
//STDPARM  DD *,SYMBOLS=EXECSYS                                        
sh ;                                                                   
set -o xtrace;                                                         
set -e;                                                                
echo;                                                                  
. .profile;                                                            
export HLQ=GEBT.NEILB.PM501001;                                        
. INCRPRE.sh;                                                          
/*                                                                     
//*                                                                    
//*                                                                    
//*********************************************************************
//*   Produce list of GVBLOAD datasets starting .B0000.GVBLOAD         
//*********************************************************************
//*                                                                    
//STEP10  EXEC PGM=IKJEFT1A                                            
//SYSPROC   DD DSN=SYS1.SAMPLIB,DISP=SHR                               
//SYSTSPRT  DD PATH='/u/nbeesle/lst.txt',PATHDISP=(KEEP,KEEP),
//          PATHOPTS=(OWRONLY,OCREAT,OEXCL),PATHMODE=(SIRWXU,SIRGRP)   
//*
//SYSTSIN   DD PATH='/u/nbeesle/lst.cmd',PATHDISP=(KEEP,KEEP),         
//          PATHOPTS=(ORDONLY),PATHMODE=(SIRWXU,SIRGRP)                
/*                                                                     
//*********************************************************************
//*   Process list of GVBLOAD datasets to get next build number        
//*********************************************************************
//*                                                                    
//STEP15   EXEC PGM=BPXBATCH                                           
//*           COND=(4,LT)                                              
//*                                                                    
//SYSTSPRT DD SYSOUT=*                                                 
//SYSOUT   DD SYSOUT=*                                                 
//STDOUT   DD SYSOUT=*                                                 
//STDERR   DD SYSOUT=*                                                 
//*                                                                    
//STDPARM  DD *                                                        
sh ;                                                                   
bash;                                                                  
set -o xtrace;                                                         
set -e;                                                                
echo;                                                                  
echo "HELLO!";                                                         
pwd;                                                                   
. INCRBLD.sh;                                                          
echo "Next number: $nextnumber";                                       
env;                                                                   
/*                                                                     
