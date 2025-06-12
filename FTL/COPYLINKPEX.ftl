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
#!/bin/bash
<#-- get the repository names from the remote address string  -->
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#assign DEV_REPO = env["GERS_REMOTE_DEV"]?keep_after_last("/")?keep_before(".")>
<#include "SETVARS.ftl">
<#-- check we have dir to copy to -->
FTL_dir=../FTL/PEX ;
[ -d $FTL_dir ] || mkdir $FTL_dir ;
<#-- change to repository directory -->
cd ${env["GERS_GIT_REPO_DIR"]}/${PEX_REPO} ;
exitIfError;
<#-- create copy commands for all source elements -->
<#list PGMEXT as programTable>
<#if  programTable.PMODTYPE == "LOADMOD">
cp LINKPARM/${programTable.PID}.ftl "${env["GERS_GIT_REPO_DIR"]}/${DEV_REPO}/FTL/PEX/${programTable.PID}.ftl"
exitIfError;
</#if>
</#list> 
