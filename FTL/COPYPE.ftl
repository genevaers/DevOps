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
#!/usr/bin/env bash
<#--
 get the repository names from the remote address string 
 -->
<#assign PE_REPO = env["GERS_REMOTE_PEB"]?keep_after_last("/")?keep_before(".")>
<#include "SETVARS.ftl">  <#-- this set vars based on env vars -->
<#--
 change to repository directory
 -->
cd ${env["GERS_GIT_REPO_DIR"]}/${PE_REPO} ;
exitIfError;
<#-- create copy commands for all source elements -->
<#list PGM as programTable>
cp ASM/${programTable.PID}.asm "//'${TARGET_HLQ}.ASM(${programTable.PID})'"
exitIfError;
</#list> 
<#list MAC as macroTable>
cp MAC/${macroTable.CID}.mac "//'${TARGET_HLQ}.MAC(${macroTable.CID})'"
exitIfError;
</#list> 
