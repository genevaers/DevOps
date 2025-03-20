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
//*  Link-edit module
//*********************************************************************
//*
//LNK${pgmSuffix} EXEC PGM=IEWL,
// PARM=(XREF,LET,LIST,MAP),
// COND=(4,LT)
//*
//SYSLIN   DD DSN=${env["GERS_TARGET_HLQ"]}.LINKPARM(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSLIB   DD DISP=SHR,DSN=${env["GERS_TARGET_HLQ"]}.OBJ
//         DD DISP=SHR,DSN=${env["GERS_LE_RUN_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_LE_CALL_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_LE_DLL_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_CSS_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_LINK_LIB"]}
//         DD DISP=SHR,DSN=${env["GERS_DB2_LOAD_LIB"]}
//*
//SYSLMOD  DD DSN=${env["GERS_TARGET_HLQ"]}.GVBLOAD(${pgmTable.PID}),
//            DISP=SHR
//*
//SYSPRINT DD DSN=${env["GERS_TARGET_HLQ"]}.LISTLINK(${pgmTable.PID}),
//            DISP=SHR
//*