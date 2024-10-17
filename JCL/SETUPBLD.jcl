//SETUPBLD  JOB (ACCT),'Set up build parms  ', 
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
//*     SETUPBLD - Set up parameters required by the 
//*                Performance Engine build process 
//*
//* This job will delete and recreate a library named:
//*
//*     <your-tso-id>.GERS.BLDPARM
//*
//* (This will be referred to as your Build Parameters library.)
//* The job will then copy environment variable values from your 
//* .profile to symbolic parameters that will be used in subsequent 
//* jobs. 
//*  
//* Before submitting this job, please update the JOB statement above
//* to be appropriate for your site.
//*
//*********************************************************************
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
//            UNIT=SYSDA,DSNTYPE=LIBRARY,
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
echo "// SET ASMMAC2='$GERS_HLASM_TK_MAC_LIB'";
echo "// SET ASMMOD2='$GERS_HLASM_TK_MOD_LIB'";
echo "// SET BLDHLQ='$GERS_BUILD_HLQ'";
echo "// SET BRCHPEB='$GERS_BRANCH_PEB'";
echo "// SET BRCHPEX='$GERS_BRANCH_PEX'";
echo "// SET BRCHRUN='$GERS_BRANCH_RUN'";
echo "// SET CEELIB='$GERS_LE_DLL_LIB'";
echo "// SET CEELKED='$GERS_LE_CALL_LIB'";
echo "// SET CEEMAC='$GERS_LE_MAC_LIB'";
echo "// SET CEERUN='$GERS_LE_RUN_LIB'";
echo "// SET CLONPEB='$GERS_CLONE_PEB'";
echo "// SET CLONPEX='$GERS_CLONE_PEX'";
echo "// SET CLONRUN='$GERS_CLONE_RUN'";
echo "// SET CMETHOD='$GERS_CLONING_METHOD'";
echo "// SET CSSLIB='$GERS_CSS_LIB'";
echo "// SET DB2EXIT='$GERS_DB2_EXIT_LIB'";
echo "// SET DB2LOAD='$GERS_DB2_LOAD_LIB'";
echo "// SET DB2QUAL='$GERS_DB2_QUALIFIER'";
echo "// SET DB2RUN='$GERS_DB2_RUN_LIB'";
echo "// SET DB2SFX='$GERS_DB2_PLAN_SUFFIX'";
echo "// SET DB2SYS='$GERS_DB2_SUBSYSTEM'";
echo "// SET DB2UTIL='$GERS_DB2_UTILITY'";
echo "// SET ENVHLQ='$GERS_ENV_HLQ'";
echo "// SET INCLPEX='$GERS_INCLUDE_PEX'";
echo "// SET ISPLLIB='$GERS_ISPF_LOAD_LIB'";
echo "// SET ISPMLIB='$GERS_ISPF_MSG_LIB'";
echo "// SET ISPPLIB='$GERS_ISPF_PANEL_LIB'";
echo "// SET ISPSLIB='$GERS_ISPF_SKEL_LIB'";
echo "// SET ISPTLIB='$GERS_ISPF_TABLE_LIB'";
echo "// SET JACTINF='$GERS_JOB_ACCT_INFO'";
echo "// SET JARSDIR='$GERS_JARS'";
echo "// SET JJOBCLS='$GERS_JOB_CLASS'";
echo "// SET JMSGCLS='$GERS_MSG_CLASS'";
echo "// SET JMSGLVL='$GERS_MSG_LEVEL'";
echo "// SET LINKLIB='$GERS_LINK_LIB'";
echo "// SET MAJ='$GERS_PE_MAJOR_REL_NBR'";
echo "// SET MIN='$GERS_PE_MINOR_REL_NBR'";
echo "// SET RCADB2='$GERS_RCA_DB2_INPUT'";
echo "// SET RCAJDIR='$GERS_RCA_JAR_DIR'";
echo "// SET RELEASE='$GERS_PE_REL_NBR'";
echo "// SET RELFMT='$GERS_PE_REL_NBR_FORMATTED'";
echo "// SET REPODIR='$GERS_GIT_REPO_DIR'";
echo "// SET TFHLQ='$GERS_TEST_HLQ'";
echo "// SET TFLIST='$GERS_TEST_SPEC_FILE_LIST'";
echo "// SET USSEXEC='$GERS_USS_EXEC_LIB'";
echo "// SET USSMLIB='$GERS_USS_MSG_LIB'";
echo "// SET VER='$GERS_PE_VERSION_NBR'";
echo "// SET WBDBTYP='$GERS_WB_DB_TYPE'";
//*
//STDOUT   DD DSN=&SYSUID..GERS.BLDPARM(DEFAULT),
//            DISP=SHR
//*
//STDERR   DD SYSOUT=*
//*
