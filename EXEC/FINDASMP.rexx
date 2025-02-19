/* REXX ****************************************************************
                                                                        
    PROGRAM NAME: FINDASMP                                              
    PURPOSE:                                                            
        Find ASMPARM members that exit (if any) or default #DEFAULT     
                                                                        
------------------------------------------------------------------------
                                                                        
    (C) COPYRIGHT IBM CORPORATION 2003, 2010.                           
        Copyright Contributors to the GenevaERS Project.                
    SPDX-License-Identifier: Apache-2.0                                 
                                                                        
    Licensed under the Apache License, Version 2.0 (the "License");     
    you may not use this file except in compliance with the License.    
    You may obtain a copy of the License at                             
                                                                        
        http://www.apache.org/licenses/LICENSE-2.0                      
                                                                        
    Unless required by applicable law or agreed to in writing, software 
    distributed under the License is distributed on an "AS IS" BASIS,   
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express        
    or implied.                                                         
    See the License for the specific language governing permissions     
    and limitations under the License.                                  
                                                                        
***********************************************************************/
                                                                        
trace ?r                                                                
                                                                        
signal on syntax     name 9990_FLAG_SYNTAX_ERROR                        
                                                                        
0000_LOAD_GENEVA_TABLES:                                                
                                                                        
    say "ASMPARM - Load table of ASMPARM member"                        
    say                                                                 
                                                                        
    parse value date("Standard") with ,                                 
        CCYY +4 MM +2 DD                                                
                                                                        
    say "Executed:" CCYY || "-" || MM || "-" || DD time()               
    say                                                                 
                                                                        
    address "ISPEXEC"                                                   
                                                                        
    call on error      name 9991_FLAG_TSO_ERROR                         
                                                                        
    /* ----------------------------------------------- */               
                                                                        
    "LMINIT  DATAID(DATAID) DDNAME(ASMPARM)"                            
                                                                        
    if RC > 0  then                                                     
        call 9992_FLAG_ISPF_ERROR                                       
                                                                        
    "LMOPEN  DATAID(" DATAID ")"                                        
                                                                
    if RC = 8  then                                             
        do                                                      
            say "Input data set could not be opened"            
            call 9992_FLAG_ISPF_ERROR                           
        end                                                     
                                                                
    A.1 = "APID"                                                 
 /* A.2 = MEMBER */                                             
                                                                
    call off error                                              
                                                                
    MEMBER = ""                                                 
    "LMMLIST DATAID(" DATAID ") MEMBER(MEMBER) OPTION(LIST)"    
                                                                
    if RC = 12  then                                            
        do                                                      
            say "The data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR                           
        end                                                     
                                                                
    I = 2                                                       
                                                                
    do until RC <> 0                                            
                                                                
        SAY "MEMBER: " MEMBER                                   
                                                                
        A.I = MEMBER                                            
        I   = I + 1                                             
                                                                
        "LMMLIST DATAID(" DATAID ") MEMBER(MEMBER) OPTION(LIST)"
        end                                                     
                                                                
                                                                
    if RC > 8  then                                             
        call 9992_FLAG_ISPF_ERROR                               
                                                                
    /* ----------------------------------------------- */       
                                                                
/*  OUTFILE = "GEBT.NEILE.OUTPUT" */                            
                                                                
    ADDRESS TSO                                                 
                                                                
/*  IF SYSDSN("'"OUTFILE"'") = 'OK' THEN               */       
/*      DO                                             */       
/*        "ALLOC F("DDOUT") DA('"OUTFILE"') SHR REUSE" */       
/*      END                                               */    
/*  ELSE                                                  */    
/*      DO                                                */    
/*        "ALLOC F("DDOUT") DA("||"'"||OUTFILE||"'", */         
/*        ||") NEW SPACE (1,1) TRACK LRECL(80) RECFM(F) ",*/    
/*        ||" BLKSIZE(0)"                              */       
/*      END                                            */       
                                                                
                                                                
    "EXECIO * DISKW DDOUT (FINIS STEM A."                       

 /* SAY "MEMBER: " MEMBER */                                       
                                                                   
 /* "EXECIO * DISKW DDOUT (FINIS STEM MEMBER." */                  
                                                                   
    "FREE F(DDOUT)"                                                
                                                                   
    /* ----------------------------------------------- */          
                                                                   
    address "ISPEXEC"                                              
                                                                   
    "LMCLOSE DATAID(" DATAID ")"                                   
                                                                   
    if RC > 0  then                                                
        call 9992_FLAG_ISPF_ERROR                                  
                                                                   
    "LMFREE  DATAID(" DATAID ")"                                   
                                                                   
    if RC > 0  then                                                
        call 9992_FLAG_ISPF_ERROR                                  
                                                                   
    /* ----------------------------------------------- */          
                                                                   
                                                                   
    say                                                            
    say right(Tbl.0,10) "ASMPARM table successfully loaded"        
    say                                                            
                                                                   
    "CONTROL ERRORS RETURN"                                        
                                                                   
    return                                                         
                                                                   
                                                                   
9990_FLAG_SYNTAX_ERROR:                                            
                                                                   
    if word(sourceline(Sigl),1) = "interpret"  then                
        do                                                         
            say                                                    
            say Assignment                                         
            say                                                    
            say "Error on record #" || Record_Count                
            say "REXX error" RC || ":" errortext(RC)               
            say                                                    
        end                                                        
    else                                                           
        do                                                         
            say                                                    
            say sourceline(Sigl)                                   
            say                                                    
            say "REXX error" RC "in line" Sigl || ":" errortext(RC)
            say                                                    
        end                                                        
                                                                   
    Error_Line = "SOURCELINE"(Sigl)                                
                                                                   
    say "CONDITION"("Description")                                 
    say                                                            

    call 9999_ABORT_PROCESSING                              
                                                            
    return                                                  
                                                            
                                                            
9991_FLAG_TSO_ERROR:                                        
                                                            
    say                                                     
    say "Return Code" RC "in line" Sigl                     
    say "SOURCELINE"(Sigl)                                  
    say "CONDITION"("Description")                          
    say                                                     
                                                            
    call 9999_ABORT_PROCESSING                              
                                                            
    return                                                  
                                                            
                                                            
9992_FLAG_ISPF_ERROR:                                       
                                                            
    Error_Function = strip(word(sourceline(Sigl),1),"B",'"')
                                                            
    say                                                     
    say "Error on record #" || Record_Count                 
    say                                                     
    say "Return Code" RC                                    
    say "CONDITION"("Description")                          
    say                                                     
                                                            
    if ZERRMSG <> "ZERRMSG"  then                           
        do                                                  
            say "ISPF Error:" ZERRMSG                       
            say ZERRLM                                      
        end                                                 
                                                            
    call 9999_ABORT_PROCESSING                              
                                                            
    return                                                  
                                                            
                                                            
9999_ABORT_PROCESSING:                                      
                                                            
    say                                                     
    say "Process aborted"                                   
    say                                                     
                                                            
    ZISPFRC = 12                                            
    address "ISPEXEC"                                       
    "VPUT (ZISPFRC) SHARED"                                 
                                                            
    exit                                                    
                                                            
                                                                                                                                