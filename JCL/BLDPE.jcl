//BLDPE    JOB (ACCT),'Set up build parms  ', 
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
//*     BLDPE    - Set up parameters and start the process to 
//*                build the GenevaERS Performance Engine 
//*
//* Before submitting this job, please do the following:   
//*
//* 1) Update the JOB statement above to be appropriate for your site.
//*
//* 2) Enter your desired values on the following SET statements.  
//*
//*     The following symbolic parameters specify the branches or tags
//*     to be checked out on the Git repositories to be used for the
//*     build:
//*         BRCHPEB - Performance-Engine (base)
//*         BRCHPEX - Performance-Engine-Extensions
//*         BRCHRUN - Run-Control-Apps
//*      
//             SET BRCHPEB='main'
//             SET BRCHPEX='main'
//             SET BRCHRUN='main'
//*      
//*     For each of the following symbolic parameters,
//*     a value of 'Y' will cause the associated repository to be 
//*     deleted (if it exists) and cloned.  Any other value will
//*     leave the repository source code untouched.
//*         CLONPEB - Performance-Engine (base)
//*         CLONPEX - Performance-Engine-Extensions
//*         CLONRUN - Run-Control-Apps
//*      
//             SET CLONPEB='Y'
//             SET CLONPEX='Y'
//             SET CLONRUN='Y'
//*
//*     If set to 'Y', the BLDJAVA symbolic parameter will cause
//*     the Java programs in the Performance Engine to be built.  
//*     Any other value will cause them to be skipped.  
//*      
//             SET BLDJAVA='Y'
//*
//*     If set to 'Y', the TESTPE symbolic parameter will cause
//*     the following steps to be executed in the build process:
//*         - Execute the Test Framework
//*         - Archive the JES output of the build jobs
//*     Any other value will cause these steps to be skipped.  
//*      
//             SET TESTPE='Y'
//*
//*     The following symbolic parameters are used to identify the 
//*     release of the Performance Engine:
//*         BLDVER is the Version Number (1 digit).
//*         BLDMAJ is the Major Release Number (2 digits).
//*         BLDMIN is the Minor Release Number (3 digits). 
//*
//             SET BLDVER='5'
//             SET BLDMAJ='01'
//             SET BLDMIN='001'
//*
//*     JACTINF is used in the job accounting information 
//*     area of the JOB card in generated JCL.  
//*
//             SET JACTINF='ACCT'
//*
//*     JJOBCLS is the job class to be used in
//*     the JOB card in generated JCL.  
//*
//             SET JJOBCLS='A'
//*
//*     JMSGCLS is the message class to be used in
//*     the JOB card in generated JCL.  
//* 
//             SET JMSGCLS='H'
//*
//*     JMSGLVL is the message level to be used in
//*     the JOB card in generated JCL.  
//*
//             SET JMSGLVL='(1,1)'
//*
//*     UNITTMP is the name to be used in the UNIT parameter
//*     of all DD statements for temporary data sets.  
//*
//*         Example: 
//*
//*             UNITTMP='TEMPDISK' yields: 
//*                 UNIT=TEMPDISK
//*
//             SET UNITTMP='SYSDA'
//*
//*     UNITPRM is the name to be used in the UNIT parameter
//*     of all DD statements for permanent data sets.  A Retention 
//*     Period can optionally be appended to the end of the name.
//*
//*         Examples: 
//*
//*             UNITPRM='DISK' yields: 
//*                 UNIT=DISK            (without retention period)
//*
//*             UNITPRM='DISK,RETPD=9999' yields: 
//*                 UNIT=DISK,RETPD=9999    (with retention period)
//*
//             SET UNITPRM='SYSDA'
//*
//*********************************************************************
//* Delete the Build Parameter library 
//*********************************************************************
//*
//DELETE   EXEC PGM=IDCAMS,
//          COND=(4,LT)
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *,SYMBOLS=EXECSYS
 DELETE  &SYSUID..GERS.BLDPARM PURGE
 IF MAXCC LE 8 THEN         /* IF OPERATION FAILED,     */    -
     SET MAXCC = 0          /* PROCEED AS NORMAL ANYWAY */
//*
//*********************************************************************
//* Allocate the Build Parameter library 
//*********************************************************************
//*
//ALLOC    EXEC PGM=IEFBR14,
//          COND=(4,LT)
//*
//NEWLIB   DD DSN=&SYSUID..GERS.BLDPARM,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=&UNITPRM.,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(10,10)),
//            DSORG=PO,RECFM=FM,LRECL=80
//*
//*********************************************************************
//*   Copy USS environment variables to the Build Parameter library
//*********************************************************************
//*
//COPYPARM EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//*
//STDPARM DD *,SYMBOLS=EXECSYS
sh ;
set -o xtrace;
set -e;
echo "// SET BLDHLQ='$GERS_BUILD_HLQ'";
echo "// SET ENVHLQ='$GERS_ENV_HLQ'";
echo "// SET ISPLLIB='$GERS_ISPF_LOAD_LIB'";
echo "// SET ISPMLIB='$GERS_ISPF_MSG_LIB'";
echo "// SET ISPPLIB='$GERS_ISPF_PANEL_LIB'";
echo "// SET ISPSLIB='$GERS_ISPF_SKEL_LIB'";
echo "// SET ISPTLIB='$GERS_ISPF_TABLE_LIB'";
echo "// SET REPODIR='$GERS_GIT_REPO_DIR'";
echo "// SET USSEXEC='$GERS_USS_EXEC_LIB'";
echo "// SET USSMLIB='$GERS_USS_MSG_LIB'";
X=$GERS_REMOTE_DEV;
Y=$(echo $X | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}');
echo "// SET REPODEV='$Y'"; 
//*
//STDOUT   DD DSN=&SYSUID..GERS.BLDPARM(DEFAULT),
//            DISP=SHR
//*
//STDERR   DD SYSOUT=*
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
//SYSUT1   DD DATA,SYMBOLS=EXECSYS,DLM=$$
//BLDPE2   JOB (&JACTINF.), 
//          'Build GenevaERS PE  ',
//          NOTIFY=&SYSUID.,
//          CLASS=&JJOBCLS.,
//          MSGLEVEL=&JMSGLVL.,
//          MSGCLASS=&JMSGCLS.
//*
// EXPORT SYMLIST=*
//*
//*********************************************************************
//*
//*     BLDPE2   - Generate and submit JCL in 
//*                &ENVHLQ..JCL(BLDPE3) to 
//*                build the GenevaERS Performance Engine
//*
//*********************************************************************
//*
//PROCLIB  JCLLIB ORDER=(&SYSUID..GERS.BLDPARM)
//*
// INCLUDE MEMBER=DEFAULT
//*
//*     BLDVER is the Version Number (1 digit).
//*     BLDMAJ is the Major Release Number (2 digits).
//*     BLDMIN is the Minor Release Number (3 digits). 
//*
//*     The grouping of these three pieces is known as the 
//*     Release Number.  (Example: 501001)
//*
//             SET RELEASE='&BLDVER.&BLDMAJ.&BLDMIN.'
//*             
//*     Sometimes the number is formatted with dots. 
//*     (Example: 5.01.001)
//* 
//             SET RELFMT='&BLDVER..&BLDMAJ..&BLDMIN.'
//* 
//*     The Component ID for this product is "PM" for "Performance 
//*     Engine - MVS".
//*
//*     The Major Release Name is the Component Id grouped with the 
//*     Version Number and the Major Release Number.  (Example: PM501)
//*
//             SET MAJREL='PM&BLDVER.&BLDMAJ.'
//*
//*     The Minor Release Name is the Release Number prefixed by the 
//*     Component ID.  (Example: PM501001)
//*
//             SET MINREL='PM&BLDVER.&BLDMAJ.&BLDMIN.'
//*
//COPYDIR  PROC LLQ=,SUBDIR=,RECFM=,LRECL=
//*
//*********************************************************************
//*
//*     Copy a USS directory to an MVS library 
//*
//*********************************************************************
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
//            UNIT=&UNITPRM.,DSNTYPE=LIBRARY,
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
//            UNIT=&UNITTMP.,
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
//            UNIT=&UNITTMP.,
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
 /&REPODEV./&SUBDIR.' +
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
// SUBDIR='SH',SUFFIX='sh',LLQ=SH,RECFM=VB,LRECL=259
//*
//         EXEC COPYDIR,
// SUBDIR='TABLE',SUFFIX='csv',LLQ=TABLE,RECFM=VB,LRECL=1004
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
 DELETE  &ENVHLQ..STDPARM  PURGE
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
//            UNIT=&UNITPRM.,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(1,1)),
//            DSORG=PO,RECFM=VB,LRECL=259
//*
//ISPTLIB  DD DSN=&ENVHLQ..ISPTLIB,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=&UNITPRM.,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(100,100)),
//            DSORG=PO,RECFM=FB,LRECL=80
//*
//JCL      DD DSN=&ENVHLQ..JCL,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=&UNITPRM.,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(100,100)),
//            DSORG=PO,RECFM=FB,LRECL=80
//*
//STDPARM  DD DSN=&ENVHLQ..STDPARM,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=&UNITPRM.,DSNTYPE=LIBRARY,
//            SPACE=(TRK,(1,1)),
//            DSORG=PO,RECFM=VB,LRECL=259
//*
//*********************************************************************
//*   Increment the Build Number
//*********************************************************************
//*
//INCRBLD EXEC PGM=IKJEFT1A,
// PARM='%INCRBLD &BLDHLQ..&MINREL.',       
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
//*   Copy USS environment variables to the variable library
//*********************************************************************
//*
//COPYUSS  EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//*
//STDPARM  DD DISP=SHR,DSN=&ENVHLQ..SH(COPYUSS)
//*
//STDOUT   DD DISP=SHR,DSN=&ENVHLQ..VAR(USSVAR)
//*
//STDERR   DD SYSOUT=*
//*
//*********************************************************************
//*   Copy all JCL symbols to a single member 
//*********************************************************************
//*
//COPYMVS  EXEC PGM=IDCAMS,
//            COND=(4,LT)
//*
//JCLSYM   DD *,SYMBOLS=EXECSYS
$BLDMAJ  = '&BLDMAJ.'    
$BLDMIN  = '&BLDMIN.'    
$BLDJAVA = '&BLDJAVA.'    
$BLDVER  = '&BLDVER.'    
$BRCHPEB = '&BRCHPEB.' 
$BRCHPEX = '&BRCHPEX.'
$BRCHRUN = '&BRCHRUN.'
$CLONPEB = '&CLONPEB.' 
$CLONPEX = '&CLONPEX.'
$CLONRUN = '&CLONRUN.'
$JACTINF = '&JACTINF.'
$JJOBCLS = '&JJOBCLS.'
$JMSGCLS = '&JMSGCLS.'
$JMSGLVL = '&JMSGLVL.'
$MAJREL  = '&MAJREL.'
$MINREL  = '&MINREL.'
$RELEASE = '&RELEASE.'
$RELFMT  = '&RELFMT.'
$TESTPE  = '&TESTPE.'
$MAJHLQ  = $BLDHLQ || "." || $MAJREL
$MINHLQ  = $BLDHLQ || "." || $MINREL
$TGTHLQ  = $BLDHLQ || "." || $MINREL || ".B" || $BLDNBR
//*
//MVSVAR   DD DISP=SHR,DSN=&ENVHLQ..VAR(MVSVAR)
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *
 REPRO INFILE(JCLSYM) OUTFILE(MVSVAR)
//*
//*********************************************************************
//*   Copy all environment variables to a single member 
//*********************************************************************
//*
//COPYCNTL EXEC PGM=IDCAMS,
//            COND=(4,LT)
//*
//$ENVIN   DD DISP=SHR,DSN=&ENVHLQ..VAR(BLDNBR)
//         DD DISP=SHR,DSN=&ENVHLQ..VAR(USSVAR)
//         DD DISP=SHR,DSN=&ENVHLQ..VAR(MVSVAR)
//*
//$ENVIRON DD DISP=SHR,DSN=&ENVHLQ..VAR($ENVIRON)
//*
//SYSPRINT DD SYSOUT=*
//*
//SYSIN    DD *
 REPRO INFILE($ENVIN) OUTFILE($ENVIRON)
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
// SET SGTRCOPT='O'         SCRIPT GENERATOR TRACE OPTION
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
//            UNIT=&UNITTMP.,
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
//            UNIT=&UNITTMP.,
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
//*********************************************************************
//*   Generate shell scripts for the GenevaERS Performance Engine 
//*********************************************************************
//*
// SET USEDEFLB='N'         USE SCRIPT DEFINITION LIBRARY (Y/N)?
// SET USEVARLB='Y'         USE ENVIRONMENT VARIABLE LIBRARY (Y/N)?
// SET SITE='N/A'           SITE (MACHINE) ENVIRONMENT
// SET ENV='$ENVIRON'       PRIMARY DATA ENVIRONMENT
// SET ENV2='N/A'           SECONDARY DATA ENVIRONMENT
// SET SGTRCOPT='O'         SCRIPT GENERATOR TRACE OPTION
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
//            UNIT=&UNITTMP.,
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
//            UNIT=&UNITTMP.,
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
//ISPFILE  DD DSN=&ENVHLQ..STDPARM,
//            DISP=SHR
//*
//ISPTABL  DD DUMMY                              ISPF tables (output)
//*
//ISPFTTRC DD SYSOUT=*,RECFM=VB,LRECL=259        TSO output
//*
//DEFLIST  DD *
CLONPEB
CLONPEX
CLONRUN
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
$$