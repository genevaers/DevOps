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
//BLDPE    JOB (${env["GERS_JOB_ACCT_INFO"]}),
//          'Build GenevaERS PE  ',
//          NOTIFY=${env["USER"]},
//          CLASS=${env["GERS_JOB_CLASS"]},REGION=0M,
//          MSGLEVEL=${env["GERS_MSG_LEVEL"]},
//          MSGCLASS=${env["GERS_MSG_CLASS"]}
//*
<#-- Generate assembler JCL -->
<#list PGM as pgmTable>
<#include "HLASM.ftl">
</#list> 
<#-- Generate JCL for link -->
<#list PGM as pgmTable>
<#if  pgmTable.PMODTYPE == "LOADMOD">
<#include "LINKEDIT.ftl">
</#if>
</#list> 
<#-- Generate JCL for Db2 BIND -->
<#list PGM as pgmTable>
<#if  pgmTable.PSQL == "Y" && env["GERS_MR95_DB2_INPUT"] == "Y" >
<#include "BIND.ftl">
</#if>
</#list> 