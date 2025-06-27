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
<#assign DEV_REPO = env["GERS_REMOTE_DEV"]?keep_after_last("/")?keep_before(".")>
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
<#include "SETVARS.ftl">  <#-- this set vars based on env vars -->
#!/usr/bin/env bash
main() {
echo "$(date) ${r"${BASH_SOURCE##*/}"} Start tagging of release PM_${RELFMT}";
<#--
 change to repository directory
 -->
cd ${env["GERS_GIT_REPO_DIR"]}/${DEV_REPO} ;
exitIfError;
git tag -a "PM_${RELFMT}" -m "Performance Engine release PM ${RELFMT}";
exitIfError;
#
cd ${env["GERS_GIT_REPO_DIR"]}/${PE_REPO} ;
exitIfError;
git tag -a "PM_${RELFMT}" -m "Performance Engine release PM ${RELFMT}";
exitIfError ;
#
cd ${env["GERS_GIT_REPO_DIR"]}/${PEX_REPO} ;
exitIfError;
git tag -a "PM_${RELFMT}" -m "Performance Engine release PM ${RELFMT}";
exitIfError;
#
cd ${env["GERS_GIT_REPO_DIR"]}/${RCA_REPO} ;
exitIfError;
git tag -a "PM_${RELFMT}" -m "Performance Engine release PM ${RELFMT}";
exitIfError;
#
echo "$(date) ${r"${BASH_SOURCE##*/}"} Tagging of release PM_${RELFMT} complete";
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${r"${BASH_SOURCE##*/}"} *** Process terminated: see error message above";
    exit 1;
fi 
}
main "$@"