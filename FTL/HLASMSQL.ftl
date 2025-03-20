<#--
* *******************************************************************
* (C) COPYRIGHT IBM CORPORATION 2003, 2023.
*     Copyright Contributors to the GenevaERS Project.
* SPDX-License-Identifier: Apache-2.0
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
*     http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
* or implied.
* See the License for the specific language governing permissions
* and limitations under the License.
* 
* ******************************************************************
* 
-->
//**********************************************************************
//*   Pre-compile SQL statements
//**********************************************************************
//*
//DB2${pgmSuffix} EXEC PGM=DSNHPC,
//            COND=(4,LT),
//            REGION=32M,
//            PARM='HOST(ASM),STDSQL(NO),VERSION(PM&$RELEASE.)'    
//*
//STEPLIB  DD DISP=SHR,DSN=${env["GERS_DB2_EXIT_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_DB2_LOAD_LIB"]}
//*
//SYSIN    DD DISP=SHR,DSN=${env["GERS_TARGET_HLQ"]}.ASM(${pgmTable.PID})
//*
//SYSLIB   DD DISP=SHR,DSN=${env["GERS_TARGET_HLQ"]}.MAC
//*
//SYSCIN   DD DSN=&&DB2PS,
//            DISP=(NEW,PASS),
//            UNIT=SYSDA,
//            SPACE=(TRK,(5,5))
//*
//DBRMLIB  DD DSN=${env["GERS_TARGET_HLQ"]}.GVBDBRM(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSUT1   DD SPACE=(800,(500,500)),UNIT=SYSDA
//SYSUT2   DD SPACE=(800,(500,500)),UNIT=SYSDA
//*
//SYSPRINT DD DSN=${env["GERS_TARGET_HLQ"]}.LISTDB2(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSTERM  DD SYSOUT=*
//*