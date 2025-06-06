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
* -->
<#assign pgmSuffix = pgmTable.PID[3..]>
<#if  pgmTable.PSQL == "Y" && env["GERS_DB2_ASM"] == "Y">
    <#include "HLASMSQL.ftl">
</#if>
//*********************************************************************
//*  Assemble module
//*********************************************************************
//*
//ASM${pgmSuffix} EXEC PGM=ASMA90,
// COND=(4,LT)
//*
//ASMAOPT  DD *
ADATA
ALIGN
NODECK 
FLAG(NOALIGN)                     
GOFF
LIST(133)
OBJECT
OPTABLE(ZS7)
PC(GEN)
SECTALGN(256)
SYSPARM(${RELFMT})
//*
<#if  pgmTable.PSQL == "Y" && env["GERS_DB2_ASM"] = "Y">
    <#assign SDB2PRE = "Y">
<#else>
    <#assign SDB2PRE = "N">
</#if>
<#if SDB2PRE == "Y">
//SYSIN    DD DSN=&&DB2PS,    from pre-compile 
//            DISP=(OLD,DELETE)
<#else>
//SYSIN    DD DISP=SHR,DSN=${TARGET_HLQ}.ASM(${pgmTable.PID})
</#if>
//SYSLIB   DD DISP=SHR,DSN=${TARGET_HLQ}.MAC
//         DD DISP=SHR,DSN=${env["GERS_HLASM_TK_MAC_LIB"]}
//         DD DISP=SHR,DSN=SYS1.MACLIB
//         DD DISP=SHR,DSN=SYS1.MODGEN
//         DD DISP=SHR,DSN=${env["GERS_LE_MAC_LIB"]}
//*
//SYSUT1   DD DSN=&&SYSUT1,
//            UNIT=SYSDA,
//            SPACE=(1024,(300,300),,,ROUND),
//            BUFNO=1
//*
//SYSLIN   DD DSN=${TARGET_HLQ}.OBJ(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSPRINT DD DSN=${TARGET_HLQ}.LISTASM(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSADATA DD DSN=${TARGET_HLQ}.ADATA(${pgmTable.PID}),
//            DISP=SHR
//*
//*********************************************************************
//*   Prepare Assembler Extract file 
//*********************************************************************
//*
//LGX${pgmSuffix} EXEC PGM=IKJEFT1A,DYNAMNBR=25,REGION=4096K,
// PARM='ASMLANGX ${pgmTable.PID} (ASM LOUD ERROR',
// COND=(4,LT)
//*
//STEPLIB  DD DISP=SHR,DSN=${env["GERS_HLASM_TK_MOD_LIB"]}
//*
//SYSTSIN  DD *
//*
//SYSADATA DD DSN=${TARGET_HLQ}.ADATA(${pgmTable.PID}),
//            DISP=SHR
//*
//ASMLANGX DD DSN=${TARGET_HLQ}.ASMLANGX(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSTSPRT DD SYSOUT=*
