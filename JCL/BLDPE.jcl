//BLDPE    JOB (ACCT), 
//          'Build GenevaERS PE  ',
//          NOTIFY=&SYSUID.,
//          CLASS=A,
//          MSGLEVEL=(1,1),
//          MSGCLASS=H
//*
// EXPORT SYMLIST=*
//*
//*********************************************************************
//* (C) COPYRIGHT IBM CORPORATION 2003, 2023.
//*     Copyright Contributors to the GenevaERS Project.
//* SPDX-License-Identifier: Apache-2.0
//*
//* Licensed under the Apache License, Version 2.0 (the "License");
//* you may not use this file except in compliance with the License.
//* You may obtain a copy of the License at
//* 
//*     http://www.apache.org/licenses/LICENSE-2.0
//* 
//* Unless required by applicable law or agreed to in writing, software
//* distributed under the License is distributed on an "AS IS" BASIS,
//* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
//* or implied.
//* See the License for the specific language governing permissions
//* and limitations under the License.
//*
//*********************************************************************
//*
//*********************************************************************
//*
//*     BLDPE    - Build the libraries to be used for 
//*                utility functions and start the process to 
//*                build the GenevaERS Performance Engine 
//*
//* Before submitting this job, please do the following:   
//*
//* 1) Update the JOB statement above to be appropriate for your site.
//*
//* 2) Verify that the following files have your desired default 
//*    values for the current build: 
//*
//*        <your-uss-home-directory>/.profile
//*        <your-tso-id>.GERS.BLDPARM(DEFAULT)
//*
//* 3) If you prefer to override these values in this job, 
//*    uncomment the SET statements below and specify the new values.
//*
//*********************************************************************
//*
//PROCLIB  JCLLIB ORDER=(&SYSUID..GERS.BLDPARM)
//*
// INCLUDE MEMBER=DEFAULT
//*
//*     The following symbolic parameters define the release  
//*     of the Performance Engine:
//*         VER is the version (1 digit).
//*         MAJ is the major release number (2 digits).
//*         MIN is the minor release number (3 digits). 
//*
//*SET     VER='9'
//*SET     MAJ='99'
//*SET     MIN='999'
//*
//*     For each of the following symbolic parameters,
//*     a value of 'Y' will cause the associated repository to be 
//*     deleted (if it exists) and cloned.  Any other value will
//*     leave the repository source code untouched.
//*         CLONPEB - Performance-Engine (base)
//*         CLONPEX - Performance-Engine-Extensions
//*         CLONRUN - Run-Control-Apps
//*      
//*SET CLONPEB='N'
//*SET CLONPEX='N'
//*SET CLONRUN='N'
//*
//*     The following symbolic parameters specify the branches or tags
//*     to be checked out on the Git repositories to be used for the
//*     build:
//*         BRCHPEB - Performance-Engine (base)
//*         BRCHPEX - Performance-Engine-Extensions
//*         BRCHRUN - Run-Control-Apps
//*      
//*SET BRCHPEB='main'
//*SET BRCHPEX='main'
//*SET BRCHRUN='main'
//*
//*********************************************************************
//*
//*     Copy a USS directory to an MVS library 
//*
//*********************************************************************
//*
//COPYDIR  PROC LLQ=,SUBDIR=,RECFM=,LRECL=
//*
//*********************************************************************
//* Delete the file(s) created in the next step
//*********************************************************************
//*
//DELETE   EXEC PGM=IDCAMS,
//          COND=(0,NE)
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *,SYMBOLS=EXECSYS
 DELETE  &ENVHLQ..&LLQ. PURGE
 IF MAXCC LE 8 THEN         /* IF OPERATION FAILED,     */    -
     SET MAXCC = 0          /* PROCEED AS NORMAL ANYWAY */
//*
//*********************************************************************
//*   Allocate an MVS library 
//*********************************************************************
//*
//ALLOC    EXEC PGM=IEFBR14,
//          COND=(0,NE)
//*
//NEWLIB   DD DSN=&ENVHLQ..&LLQ.,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(100,100)),
//            DSORG=PO,RECFM=&RECFM.,LRECL=&LRECL.
//*
//*********************************************************************
//* Copy a USS directory to an MVS library 
//*********************************************************************
//*
//COPY     EXEC PGM=IKJEFT1A,
//          COND=(0,NE)
//*
//SYSEXEC  DD DISP=SHR,DSN=&USSEXEC.
//*
//ISPWRK1  DD DISP=(NEW,DELETE,DELETE),
//            UNIT=VIO,
//            SPACE=(TRK,(10000,10000)),
//            LRECL=256,BLKSIZE=2560,RECFM=FB
//*
//ISPLOG   DD DUMMY                              ISPF log file 
//*
//ISPPROF  DD DISP=(NEW,DELETE,DELETE),          ISPF profile
//            UNIT=SYSDA,
//            DSORG=PO,RECFM=FB,LRECL=80,
//            SPACE=(TRK,(5,5,5))
//*
//ISPPLIB  DD DSN=&ISPPLIB.,
//            DISP=SHR                           ISPF panels
//*
//ISPMLIB  DD DSN=&ISPMLIB.,
//            DISP=SHR                           ISPF messages
//         DD DSN=&USSMLIB.,
//            DISP=SHR                           USS messages
//*
//ISPTLIB  DD DISP=(NEW,DELETE,DELETE),          ISPF tables (input)
//            UNIT=SYSDA,
//            SPACE=(TRK,(5,5,5)),
//            DSORG=PO,RECFM=FB,LRECL=80
//         DD DSN=&ISPTLIB.,
//            DISP=SHR
//*
//ISPSLIB  DD DSN=&ISPSLIB.,
//            DISP=SHR                           ISPF skeletons 
//*
//ISPLLIB  DD DISP=SHR,DSN=SYS1.LINKLIB
//         DD DISP=SHR,DSN=&ISPLLIB.
//*
//SYSTSPRT DD SYSOUT=*
//*
//ISPTABL  DD DUMMY                              ISPF tables (output)
//*
//ISPFTTRC DD SYSOUT=*,RECFM=VB,LRECL=259        TSO output
//*
//SYSTSIN  DD *,SYMBOLS=EXECSYS
OGETX '+
 &REPODIR.+
 /DevOps/&SUBDIR.' +
 '&ENVHLQ..&LLQ.' SUFFIX(&SUFFIX.) LC
//*
//         PEND
//*
//         EXEC COPYDIR,
// SUBDIR='EXEC',SUFFIX='rexx',LLQ=EXEC,RECFM=FB,LRECL=80
//*
//         EXEC COPYDIR,
// SUBDIR='SKEL',SUFFIX='skel',LLQ=SKEL,RECFM=VB,LRECL=259
//*
//         EXEC COPYDIR,
// SUBDIR='TABLE',SUFFIX='csv',LLQ=TABLE,RECFM=VB,LRECL=1004
//*
//*******************************************************************
//* Submit the next job
//*******************************************************************
//*
//SUBJOB   EXEC PGM=IEBGENER,
//            COND=(4,LT)
//*
//SYSIN    DD DUMMY
//*
//SYSPRINT DD DUMMY
//*
//SYSUT2   DD SYSOUT=(*,INTRDR)
//*
//SYSUT1   DD DATA,SYMBOLS=EXECSYS  
//BLDPE2   JOB (&JACTINF.),
//          'Build GenevaERS PE  ',
//          NOTIFY=&SYSUID.,
//          CLASS=&JJOBCLS.,
//          MSGLEVEL=&JMSGLVL.,
//          MSGCLASS=&JMSGCLS.
//*
//*********************************************************************
//*
//*     BLDPE2   - Generate and submit JCL in 
//*                &ENVHLQ..JCL(BLDPE3) to 
//*                build the GenevaERS Performance Engine
//*
//*********************************************************************
//*
//**********************************************************************
//*   Delete the files created in the next steps 
//**********************************************************************
//*
//DELISPT  EXEC PGM=IDCAMS,
//            COND=(4,LT)
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *,SYMBOLS=EXECSYS
 DELETE  &ENVHLQ..VAR  PURGE
 IF LASTCC > 0  THEN        /* IF OPERATION FAILED,     */    -
     SET MAXCC = 0          /* PROCEED AS NORMAL ANYWAY */
 DELETE  &ENVHLQ..ISPTLIB  PURGE
 IF LASTCC > 0  THEN        /* IF OPERATION FAILED,     */    -
     SET MAXCC = 0          /* PROCEED AS NORMAL ANYWAY */
 DELETE  &ENVHLQ..JCL  PURGE
 IF LASTCC > 0  THEN        /* IF OPERATION FAILED,     */    -
     SET MAXCC = 0          /* PROCEED AS NORMAL ANYWAY */
//*
//*********************************************************************
//* Allocate MVS libraries
//*********************************************************************
//*
//ALLOC    EXEC PGM=IEFBR14,
//          COND=(0,NE)
//*
//VAR      DD DSN=&ENVHLQ..VAR,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(1,1)),
//            DSORG=PO,RECFM=FB,LRECL=80
//*
//ISPTLIB  DD DSN=&ENVHLQ..ISPTLIB,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(100,100)),
//            DSORG=PO,RECFM=FB,LRECL=80
//*
//JCL      DD DSN=&ENVHLQ..JCL,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(100,100)),
//            DSORG=PO,RECFM=FB,LRECL=80
//*
//*********************************************************************
//*   Increment the Build Number
//*********************************************************************
//*
//INCRBLD EXEC PGM=IKJEFT1A,
// PARM='%INCRBLD &BLDHLQ..PM&VER.&MAJ.&MIN.',
// COND=(4,LT)
//*
//SYSEXEC  DD DSN=&ENVHLQ..EXEC,     REXX program library
//            DISP=SHR
//*
//SYSTSPRT DD SYSOUT=*
//*
//SYSTSIN  DD DUMMY                              TSO input
//*
//ENV      DD DSN=&ENVHLQ..VAR(BLDNBR),
//            DISP=SHR
//*
//*********************************************************************
//*   Copy all environment variables to a single member 
//*********************************************************************
//*
//COPYCNTL EXEC PGM=IDCAMS,
//            COND=(4,LT)
//*
//$ENVIRON DD DSN=&ENVHLQ..VAR(BLDNBR),
//            DISP=SHR
//         DD *,SYMBOLS=EXECSYS
$ASMMAC2 = '&ASMMAC2.'
$ASMMOD2 = '&ASMMOD2.'
$BLDHLQ  = '&BLDHLQ.' 
$BRCHRUN = '&BRCHRUN.'
$BRCHPEB = '&BRCHPEB.' 
$BRCHPEX = '&BRCHPEX.'
$CEELIB  = '&CEELIB.' 
$CEELKED = '&CEELKED.'
$CEEMAC  = '&CEEMAC.' 
$CEERUN  = '&CEERUN.' 
$CLONPEB = '&CLONPEB.' 
$CLONPEX = '&CLONPEX.'
$CLONRUN = '&CLONRUN.'
$CMETHOD = '&CMETHOD.'
$CSSLIB  = '&CSSLIB.' 
$DB2EXIT = '&DB2EXIT.'
$DB2LOAD = '&DB2LOAD.'
$DB2QUAL = '&DB2QUAL' 
$DB2RUN  = '&DB2RUN.' 
$DB2SFX  = '&DB2SFX.' 
$DB2SYS  = '&DB2SYS.' 
$DB2UTIL = '&DB2UTIL' 
$ENVHLQ  = '&ENVHLQ.' 
$INCLPEX = '&INCLPEX.'
$ISPLLIB = '&ISPLLIB.'
$ISPMLIB = '&ISPMLIB.'
$ISPPLIB = '&ISPPLIB.'
$ISPSLIB = '&ISPSLIB.'
$ISPTLIB = '&ISPTLIB.'
$JACTINF = '&JACTINF.'
$JARSDIR = '&JARSDIR.'
$JJOBCLS = '&JJOBCLS.'
$JMSGCLS = '&JMSGCLS.'
$JMSGLVL = '&JMSGLVL.'
$LINKLIB = '&LINKLIB.'
$MAJ     = '&MAJ.'    
$MIN     = '&MIN.'    
$RCADB2  = '&RCADB2.'
$RCAJDIR = '&RCAJDIR.'
$RELEASE = '&RELEASE.'
$RELFMT  = '&RELFMT.'
$REPODIR = '&REPODIR.'
$USSEXEC = '&USSEXEC.'
$USSMLIB = '&USSMLIB.'
$VER     = '&VER.'    
$WBDBTYP = '&WBDBTYP.'    
$TGTHLQ  = $BLDHLQ || ".PM" || $RELEASE || ".B" || $BLDNBR
$MAJHLQ  = $BLDHLQ || ".PM" || $VER || $MAJ
$MINHLQ  = $BLDHLQ || ".PM" || $VER || $MAJ || $MIN
//*
//$ENVIRO2 DD DISP=SHR,DSN=&ENVHLQ..VAR($ENVIRON)
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *
 REPRO INFILE($ENVIRON) OUTFILE($ENVIRO2)
//*
//*********************************************************************
//*   Generate installation JCL for the GenevaERS Performance Engine 
//*********************************************************************
//*
// SET USEDEFLB='N'         USE SCRIPT DEFINITION LIBRARY (Y/N)?
// SET USEVARLB='Y'         USE ENVIRONMENT VARIABLE LIBRARY (Y/N)?
// SET SITE='N/A'           SITE (MACHINE) ENVIRONMENT
// SET ENV='$ENVIRON'       PRIMARY DATA ENVIRONMENT
// SET ENV2='N/A'           SECONDARY DATA ENVIRONMENT
// SET SGTRCOPT='R'         SCRIPT GENERATOR TRACE OPTION
// SET USEFTTRC='N'         USE FILE TAILORING TRACE (Y/N)?
// SET FTTRCOPT=''          FILE TAILORING TRACE OPTIONS
//*
//GENJCL   EXEC PGM=IKJEFT1A,                    Batch TSO program
// COND=(4,LT),
// REGION=32M,
// PARM='ISPSTART CMD(GENSCRPT &USEDEFLB. &USEVARLB. &SITE. &ENV.      X
//             &ENV2. &SGTRCOPT. &USEFTTRC. &FTTRCOPT.)'
//*
//         SET SYM=''                            Dummy symbolic
//*
//SYSEXEC  DD DSN=&ENVHLQ..EXEC,
//            DISP=SHR                           REXX program library
//*
//ISPWRK1  DD DISP=(NEW,DELETE,DELETE),
//            UNIT=VIO,
//            SPACE=(TRK,(10000,10000)),
//            LRECL=256,BLKSIZE=2560,RECFM=FB
//*
//ISPLOG   DD DUMMY                              ISPF log file
//*
//ISPPROF  DD DISP=(NEW,DELETE,DELETE),          ISPF profile
//            UNIT=SYSDA,
//            SPACE=(TRK,(5,5,5)),
//            DSORG=PO,RECFM=FB,LRECL=80
//*
//ISPPLIB  DD DSN=&ISPPLIB.,
//            DISP=SHR                           ISPF panels
//*
//ISPMLIB  DD DSN=&ISPMLIB.,
//            DISP=SHR                           ISPF menus
//*
//ISPTLIB  DD DISP=(NEW,DELETE,DELETE),          ISPF tables (input)
//            UNIT=SYSDA,
//            SPACE=(TRK,(5,5,5)),
//            DSORG=PO,RECFM=FB,LRECL=80
//         DD DSN=&ENVHLQ..ISPTLIB,
//            DISP=SHR
//         DD DSN=&ISPTLIB.,
//            DISP=SHR
//*
//ISPSLIB  DD DSN=&ENVHLQ..SKEL,
//            DISP=SHR                           JCL skeletons
//*
//VARLIB   DD DSN=&ENVHLQ..VAR,
//            DISP=SHR                           Global variables
//*
//SYSTSPRT DD SYSOUT=*
//*
//SYSTSIN  DD DUMMY
//*
//ISPFILE  DD DSN=&ENVHLQ..JCL,
//            DISP=SHR
//*
//ISPTABL  DD DUMMY                              ISPF tables (output)
//*
//ISPFTTRC DD SYSOUT=*,RECFM=VB,LRECL=259        TSO output
//*
//DEFLIST  DD *
BLDPE3
//*
//*******************************************************************
//* Submit the next job 
//*******************************************************************
//*
//SUBJOB   EXEC PGM=IEBGENER,
//            COND=(4,LT)
//*
//SYSIN    DD DUMMY
//*
//SYSUT1   DD DSN=&ENVHLQ..JCL(BLDPE3),
//            DISP=SHR
//*
//SYSUT2   DD SYSOUT=(*,INTRDR)
//*
//SYSPRINT DD DUMMY
//* 
