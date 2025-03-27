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
<#--
 get the repository names from the remote address string 
 -->
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#--
 change to repository directory
 -->
cd ${env["GERS_GIT_REPO_DIR"]}/${PEX_REPO} ;
<#-- create copy commands for all source elements -->
<#list PGMRND as programTable>
cp ASM/${programTable.PID} "//'${env["GERS_TARGET_HLQ"]}.ASM(${programTable.PID})'"
</#list> 
<#list MACRND as macroTable>
cp MAC/${macroTable.CID} "//'${env["GERS_TARGET_HLQ"]}.MAC(${macroTable.CID})'"
</#list> 