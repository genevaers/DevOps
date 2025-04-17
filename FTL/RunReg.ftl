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
<#include "SETVARS.ftl">  <#-- this set vars based on env vars -->
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
<#if env["BLDRCA"] == "Y">  
sh ;
set -e;
set -o xtrace;
echo;
cd ${env["GERS_JARS"]};
java -cp ./db2jcc4.jar com.ibm.db2.jcc.DB2Jcc -version;
echo;
cd ${env["GERS_GIT_REPO_DIR"]}/${RCA_REPO}/;
chmod +x prebuild/*.sh;
mvn clean;
<#if env["GERS_RCA_DB2_INPUT"] =="Y">
<#assign SDB2PARM = " -Pdb2">
</#if>
mvn -B install -DskipTests${SDB2PARM};

export rev=`grep "<<revision>>" pom.xml 
|| awk -F'<<revision>>||<</revision>>' '{print $2}'`;
echo RCA release number $rev;

cp RCApps/target/rcapps-$rev-jar-with-dependencies.jar ${env["GERS_RCA_JAR_DIR"]}/rcapps-$rev.jar;

cd ${env["GERS_RCA_JAR_DIR"]} ;

touch rcapps-latest.jar;
rm rcapps-latest.jar;
ln -s rcapps-$rev.jar rcapps-latest.jar;

touch rcapps-${MINOR_REL}.jar;
rm rcapps-${MINOR_REL}.jar;
ln -s rcapps-$rev.jar rcapps-${MINOR_REL}.jar;

cd ${env["GERS_GIT_REPO_DIR"]}/${RCA_REPO}/PETestFramework/;
./target/bin/gerstf;
</#if> 