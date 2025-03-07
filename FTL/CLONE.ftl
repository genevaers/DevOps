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
<#--
 get the repository names from the remote address string 
 -->
<#assign PE_REPO = env["GERS_REMOTE_PEB"]?keep_after_last("/")?keep_before(".")>
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
<#-- 

Create script to check out the required repositories 

-->
cd ${env["GERS_GIT_REPO_DIR"]} ;
<#if env["CLONEPE"] = "Y">
<#-- option -o xtrace prints commands as they run -->
rm -rf ${PE_REPO};
git clone ${env["GERS_REMOTE_PEB"]};
</#if>
cd ${PE_REPO}
git checkout ${env["BRCHPEB"]};
<#if env["GERS_INCLUDE_PEX"] = "Y"> 
cd ${env["GERS_GIT_REPO_DIR"]};
    <#if env["CLONEPEX"] = "Y">
rm -rf ${PEX_REPO};
git clone ${env["GERS_REMOTE_PEX"]};
    </#if>
cd ${PEX_REPO}
git checkout ${env["BRCHPEX"]};
</#if>

cd ${env["GERS_GIT_REPO_DIR"]};
<#if env["CLONERUN"] = "Y">
rm -rf ${RCA_REPO};
git clone ${env["GERS_REMOTE_RUN"]};
</#if>
cd ${RCA_REPO}
git checkout ${env["BRCHRUN"]};
