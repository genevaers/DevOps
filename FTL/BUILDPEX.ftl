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
<#include "SETVARS.ftl">  <#-- this set vars based on env vars -->
<#-------- BUILD WITH DB2 -->
<#if env["GERS_DB2_ASM"] == "Y">
<#list PGMEXT as pgmTable>
<#include "HLASM.ftl">
</#list> 
<#-- Generate JCL for link -->
<#list PGMEXT as pgmTable>
<#if  pgmTable.PMODTYPE == "LOADMOD">
<#assign FTL_dir = "PEX">
<#include "LINKEDIT.ftl">
</#if>
</#list> 
<#-- Generate JCL for Db2 BIND -->
<#list PGMEXT as pgmTable>
<#if  pgmTable.PDB2PRE == "Y">
<#include "BIND.ftl">
</#if>
</#list>
<#else>
<#-------- BUILD WITHOUT DB2 -->
<#list PGMEXT as pgmTable>
<#if pgmTable.PDB2PRE != "Y">
<#include "HLASM.ftl">
</#if>
</#list>
<#-- Generate JCL for link -->
<#list PGMEXT as pgmTable>
<#if  pgmTable.PMODTYPE == "LOADMOD" && pgmTable.PDB2PRE != "Y">
<#assign FTL_dir = "PEX">
<#include "LINKEDIT.ftl">
</#if>
</#list> 
</#if> 