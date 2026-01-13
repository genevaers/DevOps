<#-- *******************************************************************
 (C) COPYRIGHT IBM CORPORATION 2003, 2023.
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
 
 ******************************************************************
 -->
<#assign pgmSuffix = pgmTable.PID[3..]>
//*********************************************************************
//*   Free plan
//*********************************************************************
//*
//FRE${pgmSuffix} EXEC PGM=IKJEFT01,
// COND=(4,LT)
//*
//STEPLIB  DD DISP=SHR,DSN=${env["GERS_DB2_LOAD_LIB"]}
//*
//SYSTSPRT DD SYSOUT=*
//*
//SYSTSIN  DD *
 DSN SYSTEM(${env["GERS_DB2_SUBSYSTEM"]})
  FREE PLAN(${pgmTable.PID}${env["GERS_DB2_PLAN_SUFFIX"]})
  END 
 CALL 'SYS1.LINKLIB(IEFBR14)'       /* ZERO OUT RETURN CODE */
//*
//*********************************************************************
//*   Bind plan
//*********************************************************************
//*
//BND${pgmSuffix} EXEC PGM=IKJEFT1A,
// COND=(4,LT)
//*
//STEPLIB  DD DISP=SHR,DSN=${env["GERS_DB2_LOAD_LIB"]}
//*
//DBRMLIB  DD DSN=${TARGET_HLQ}.GVBDBRM,
//            DISP=SHR
//*
//SYSTSPRT DD SYSOUT=*
//*
//SYSTSIN  DD *
 DSN SYSTEM(${env["GERS_DB2_SUBSYSTEM"]})
  BIND PLAN(${pgmTable.PID}${env["GERS_DB2_PLAN_SUFFIX"]}) MEM(${pgmTable.PID}) ACT(REP) ISOLATION(CS) -
  LIB('${TARGET_HLQ}.GVBDBRM') QUALIFIER(${env["GERS_DB2_QUALIFIER"]}) -
  OWNER(${env["GERS_DB2_QUALIFIER"]})
//*
//*********************************************************************
//*   Grant execute authority to plan
//*********************************************************************
//*
//GRT${pgmSuffix} EXEC PGM=IKJEFT1A,DYNAMNBR=20,
// COND=(4,LT)
//*
//STEPLIB  DD DISP=SHR,DSN=${env["GERS_DB2_LOAD_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_DB2_EXIT_LIB"]}
//*
//SYSTSPRT DD SYSOUT=*                                                 
//SYSPRINT DD SYSOUT=*                                                 
//*
//SYSTSIN  DD *                                
  DSN SYSTEM(${env["GERS_DB2_SUBSYSTEM"]}) RETRY(0) TEST(0) 
  RUN PROGRAM(DSNTIAD) PLAN(${env["GERS_DB2_UTILITY"]}) - 
  LIB('${env["GERS_DB2_RUN_LIB"]}') 
//SYSIN    DD  *                               
 SET CURRENT SQLID='${env["GERS_DB2_QUALIFIER"]}';
 GRANT EXECUTE ON PLAN ${pgmTable.PID}${env["GERS_DB2_PLAN_SUFFIX"]} TO PUBLIC;
//*
