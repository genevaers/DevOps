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
<#assign SDB2PARM = "-Pdb2">
</#if>
mvn -B install -DskipTests${SDB2PARM};

export rev=`grep "<<revision>>" pom.xml 
|| awk -F'<<revision>>||<</revision>>' '{print $2}'`;
echo RCA release number $rev;

cp RCApps/target/rcapps-$rev-jar-with-dependencies.jar 
${env["GERS_RCA_JAR_DIR"]}/rcapps-$rev.jar;

cd ${env["GERS_RCA_JAR_DIR"]} ;

touch rcapps-latest.jar;
rm rcapps-latest.jar;
ln -s rcapps-$rev.jar rcapps-latest.jar;

touch rcapps-${MINREL}.jar;
rm rcapps-${MINREL}.jar;
ln -s rcapps-$rev.jar rcapps-${MINREL}.jar;

cd ${env["GERS_GIT_REPO_DIR"]}/${RCA_REPO}/PETestFramework/;
./target/bin/gerstf;
//*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
<#--
//*
//**********************************************************************
//*   Tag the Test Framework output files as ASCII
//**********************************************************************
//*
//SETASCII   EXEC PGM=BPXBATCH,
//          COND=(4,LT)
//*
//STDPARM  DD *
sh ;
set -e;
set -o xtrace;
cd ${env["GERS_GIT_REPO_DIR"]}/${RCA_REPO}/;
cd PETestFramework/out;
chtag  -R -c 819 *;
chtag  -R -t *;
//*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//*
//**********************************************************************
//*   Print the results of the regression tests
//**********************************************************************
//*
//PRTRESLT EXEC PGM=IKJEFT1A,DYNAMNBR=25,REGION=1024K,
//          COND=(4,LT)
//*                                                     
//INFILE   DD PATHOPTS=(ORDONLY),

* The following REXX code deals with the fact that a single-quoted 
* parameter in JCL (such as PATH) must either be contained within
* the first 71 characters of the JCL or be continued starting at 
* position 16 of the next line.  Depending on the length of the name
* user's Git repository, the quoted parameter containing the 
* location of the results file for the PE Test Framework may or
* may not fit on one line.  The REXX code tests for this and splits
* the value into two JCL lines if necessary.  

)REXX $REPODIR $REPORUN SRESFL1 SRESFL2 
Results_File = "'" || $REPODIR || "/" || $REPORUN || , 
    "/PETestFramework/out/fmoverview.txt'"
SRESFL1 = strip(substr(Results_File,1,63))
SRESFL2 = substr(Results_File,64)
)ENDREXX

)IF &SRESFL2. EQ &Z.  THEN 
// PATH=&SRESFL1.
)ELSE )DO
// PATH=&SRESFL1.
//             &SRESFL2.
)ENDDO

//*                                                     
//SYSTSPRT DD SYSOUT=*                                  
//*                                                     
//RESULTS  DD SYSOUT=*,RECFM=VB,LRECL=164               
//*                                                     
//SYSTSIN  DD *                                         
 OCOPY INDD(INFILE) OUTDD(RESULTS) TEXT -              
  CONVERT((BPXFX311)) TO1047                            
//*                                                     
//*******************************************************************
//* Submit the next job 
//*******************************************************************
//*
//SUBJOB   EXEC PGM=IEBGENER,
//          COND=(4,LT)
//*
//SYSIN    DD DUMMY
//*
//SYSUT1   DD DSN=&$ENVHLQ..JCL(BLDPE6),
//            DISP=SHR
//*
//SYSUT2   DD SYSOUT=(*,INTRDR)
//*
//SYSPRINT DD DUMMY
//*
-->
</#if> 