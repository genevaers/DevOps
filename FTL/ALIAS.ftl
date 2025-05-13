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
<#include "SETVARS.ftl">
<#assign DEV_REPO = env["GERS_REMOTE_DEV"]?keep_after_last("/")?keep_before(".")>
//ALIAS    JOB (${env["GERS_JOB_ACCT_INFO"]}),
//          'Build GenevaERS PE  ',
//          NOTIFY=${env["USER"]},
//          CLASS=${env["GERS_JOB_CLASS"]},REGION=0M,
//          MSGLEVEL=${env["GERS_MSG_LEVEL"]},
//          MSGCLASS=${env["GERS_MSG_CLASS"]}
//*
//*********************************************************************
//*   Set aliases for the build data sets 
//*********************************************************************
//*
//SETALIAS EXEC PGM=IDCAMS,
//            COND=(4,LT)
//*
//SYSIN    DD *
<#list BLDDSET as row>
 DELETE ${MAJOR_HLQ}.${row["BDS"]} ALIAS
     IF LASTCC = 8 THEN               /* IF OPERATION FAILED,     */ -
         SET MAXCC = 0                /* PROCEED AS NORMAL ANYWAY */
 DELETE ${env["GERS_ENV_HLQ"]}.${row["BDS"]} ALIAS
     IF LASTCC = 8 THEN               /* IF OPERATION FAILED,     */ -
         SET MAXCC = 0                /* PROCEED AS NORMAL ANYWAY */
</#list> 
<#list BLDDSET as row>
 DEFINE ALIAS (NAME(${MAJOR_HLQ}.${row["BDS"]}) -     
     RELATE(${TARGET_HLQ}.${row["BDS"]}))       
 DEFINE ALIAS (NAME(${env["GERS_ENV_HLQ"]}.${row["BDS"]}) -     
     RELATE(${TARGET_HLQ}.${row["BDS"]}))       
</#list> 
//*
//SYSPRINT DD SYSOUT=*
//*
//*********************************************************************
//*   Signal completion to calling job
//*********************************************************************
//*