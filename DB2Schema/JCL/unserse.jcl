//UNTERSE JOB (ACCT),'UNTERSE TRANSFER FILE',                          
//          NOTIFY=&SYSUID.,                                           
//          CLASS=A,                                                   
//          MSGLEVEL=(1,1),                                            
//          MSGCLASS=H                                                 
//********************************************************************
//*
//* (C) COPYRIGHT IBM CORPORATION 2025.
//*    Copyright Contributors to the GenevaERS Project.
//*SPDX-License-Identifier: Apache-2.0
//*
//********************************************************************
//*
//*  Licensed under the Apache License, Version 2.0 (the "License");
//*  you may not use this file except in compliance with the License.
//*  You may obtain a copy of the License at
//*
//*     http://www.apache.org/licenses/LICENSE-2.0
//*
//*  Unless required by applicable law or agreed to in writing, software
//*  distributed under the License is distributed on an "AS IS" BASIS,
//*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
//*  or implied.
//*  See the License for the specific language governing permissions
//*  and limitations under the License.
//*
//******************************************************************
//* UNTERSE TRANSMISSION FILE
//* USED AFTER TRANSFERRING TERSED DATABASE UNLOAD CONTAINED IN A PDSE
//******************************************************************
//*
//*
//*   The following variables will need to be set to match the Db2
//*   subsystem the packages are to reside.
//*
//*   .   ensure variables are exportable
//*
//         EXPORT SYMLIST=*
//*
//   SET HLQ='GEBT'
//   SET MLQ='GENERS.D240708U'

//*
//*******************************************************************                                                                    
//*   DELETE DATA SET                                                  
//*********************************************************************
//*                                                                    
//DELDS    EXEC PGM=IDCAMS                                             
//*                                                                    
//SYSPRINT DD SYSOUT=*,DCB=(LRECL=133,BLKSIZE=12901,RECFM=FBA)         
//*                                                                    
//SYSIN    DD *,SYMBOLS=EXECSYS                                                        
 DELETE &HLQ.&MLQ.PDS PURGE                                      
    IF LASTCC > 0 THEN SET MAXCC = 0                                   
//*                                                                    
//*********************************************************************
//*   UNPACK DATA SET                                                  
//*********************************************************************
//*                                                                    
//UNPACK   EXEC PGM=TRSMAIN,PARM='UNPACK'                              
//*                                                                    
//SYSPRINT DD SYSOUT=*,DCB=(LRECL=133,BLKSIZE=12901,RECFM=FBA)         
//*                                                                    
//INFILE   DD DISP=OLD,DSN=&HLQ.&MLQ.PDS.TRS                     
//*                                                                    
//OUTFILE  DD DSN=&HLQ.&MLQ.PDS,                          
//            DISP=(NEW,CATLG,DELETE),                                 
//             UNIT=SYSDA,DSNTYPE=LIBRARY,DSORG=PO,                    
//             SPACE=(CYL,(4000,1000),RLSE)                            
//