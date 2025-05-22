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
//SAVEJOB   JOB (${env["GERS_JOB_ACCT_INFO"]}),
//          'Save GenevaERS build job ',
//          NOTIFY=${env["USER"]},
//          CLASS=${env["GERS_JOB_CLASS"]},REGION=0M,
//          MSGLEVEL=${env["GERS_MSG_LEVEL"]},
//          MSGCLASS=${env["GERS_MSG_CLASS"]}
//*
//*********************************************************************
//*   Copy the job output from the spool to library members  
//*********************************************************************
//*
//COPYOUT  EXEC PGM=ISFAFD,
//          PARM='++41,1000',
//          COND=(4,LT)
//*
//ISFOUT   DD SYSOUT=*
//*       
//ISFIN    DD *,SYMBOLS=EXECSYS
<#list BLDJOB as row>
<#if  row.JCOPYOUT == "Y">
SET DISPLAY
PREFIX ${row["JJOBNAME"]}
OWNER ${env["USER"]}
H ALL
++ALL
SORT END-DATE D END-TIME D
H ALL
++XDC
++<<='''${TARGET_HLQ}.LISTJOB(${row["JJOBNAME"]})'''>>, 
<<=' '>>,
<<='OLD'>>
++AFD END
</#if>
</#list>
