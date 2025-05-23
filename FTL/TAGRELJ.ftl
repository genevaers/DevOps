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
<#assign PE_REPO = env["GERS_REMOTE_PEB"]?keep_after_last("/")?keep_before(".")>
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#assign DEV_REPO = env["GERS_REMOTE_DEV"]?keep_after_last("/")?keep_before(".")>
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
<#include "SETVARS.ftl">
//TAGREL   JOB (${env["GERS_JOB_ACCT_INFO"]}),
//          'Tag release         ',
//          NOTIFY=${env["USER"]},
//          CLASS=${env["GERS_JOB_CLASS"]},REGION=0M,
//          MSGLEVEL=${env["GERS_MSG_LEVEL"]},
//          MSGCLASS=${env["GERS_MSG_CLASS"]}
//*
//*******************************************************************
//*   Tag release
//*******************************************************************
//*
//TAGREL   EXEC PGM=BPXBATCH,
//            COND=(4,LT)
//*
//STDPARM  DD *
sh ;
set -e;
set -o xtrace;
echo;
cd ${env["GERS_GIT_REPO_DIR"]}/${DEV_REPO} ;
git tag -a "PM_${RELFMT}" 
-m "Performance Engine release PM ${RELFMT}";
git push origin tag "PM_${RELFMT}"; 
cd ${env["GERS_GIT_REPO_DIR"]}/${PE_REPO} ;
git tag -a "PM_${RELFMT}" 
-m "Performance Engine release PM ${RELFMT}";
git push origin tag "PM_${RELFMT}"; 
cd ${env["GERS_GIT_REPO_DIR"]}/${PEX_REPO} ;
git tag -a "PM_${RELFMT}" 
-m "Performance Engine release PM ${RELFMT}";
git push origin tag "PM_${RELFMT}"; 
cd ${env["GERS_GIT_REPO_DIR"]}/${RCA_REPO} ;
git tag -a "PM_${RELFMT}" 
-m "Performance Engine release PM ${RELFMT}";
git push origin tag "PM_${RELFMT}"; 
//*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*