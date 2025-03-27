<#-- Generate script with calls to FTL2JCL to generate 
1) Script to copy source to data sets
2) JCL for build -->
<#--
 get the repository names from the remote address string 
 -->
 #!/bin/bash
<#assign PE_REPO = env["GERS_REMOTE_PEB"]?keep_after_last("/")?keep_before(".")>
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
<#-- 
Create commands to create scripts to copy ASM/MAC in z/OS UNIX to data sets
Use TABLE in cloned repositories
-->
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar COPYPE ../../${PE_REPO}/TABLE/tablesPE
<#-- run the script -->
. COPYPE.sh
<#if  env["GERS_INCLUDE_PEX"] == "Y">
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar COPYPEX ../../${PEX_REPO}/TABLE/tablesPEX
<#-- run the script -->
. COPYPEX.sh 
</#if>
<#-- 
Create commands to create build JCL from templates
-->
<#-- Generate for PE -->
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar BUILDPE ../../${PE_REPO}/TABLE/tablesPE
submit BUILDPE.jcl 
<#-- Generate for PEX, if required -->
<#if  env["GERS_INCLUDE_PEX"] == "Y">
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar BUILDPEX ../../${PEX_REPO}/TABLE/tablesPEX
submit BUILDPEX.jcl 
</#if>