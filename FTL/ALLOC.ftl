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
<#include "SETVARS.ftl">
//ALLOC    JOB (${env["GERS_JOB_ACCT_INFO"]}),
//          'Build GenevaERS PE  ',
//          NOTIFY=${env["USER"]},
//          CLASS=${env["GERS_JOB_CLASS"]},REGION=0M,
//          MSGLEVEL=${env["GERS_MSG_LEVEL"]},
//          MSGCLASS=${env["GERS_MSG_CLASS"]}
//*
//*********************************************************************
//*   Delete data sets from the prior build
//*********************************************************************
//*
//DELFILE  EXEC PGM=IDCAMS,
//            COND=(4,LT)
//*
//SYSIN    DD *
<#list BLDDSET as row>
 DELETE ${TARGET_HLQ}.${row["BDS"]} PURGE
     IF LASTCC = 8 THEN               /* IF OPERATION FAILED,     */ -
         SET MAXCC = 0                /* PROCEED AS NORMAL ANYWAY */
</#list> 
//*                    
//SYSPRINT DD SYSOUT=* 
//*
//*********************************************************************
//*   Create new build data sets
//*********************************************************************
//*
//ALLOC    EXEC PGM=IEFBR14,
//            COND=(4,LT)
//*
<#list BLDDSET as row>
<#if  row.BDSORG == "PO">
    <#assign SDSNTYPE = ",DSNTYPE=LIBRARY">
<#else>
    <#assign SDSNTYPE = "">
</#if>
<#if row.BBLKSIZE != "">
    <#assign SBLKSIZE = ",BLKSIZE=${row.BBLKSIZE}">
<#else>
    <#assign SBLKSIZE = "">
</#if>
//${row["BDS"]} DD DSN=${TARGET_HLQ}.${row.BDS},
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=${env["UNITPRM"]}${SDSNTYPE},
//            SPACE=(TRK,(${row.BTRKSPRI},${row.BTRKSSEC}),RLSE),
//            DSORG=${row.BDSORG},RECFM=${row.BRECFM},LRECL=${row.BLRECL}${SBLKSIZE}
//*
</#list> 