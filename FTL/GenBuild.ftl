<#-- Generate script to generate JCL for build -->

<#--
 get the repository names from the remote address string 
 -->
<#assign PE_REPO = env["GERS_REMOTE_PEB"]?keep_after_last("/")?keep_before(".")>
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
<#-- 
Create script build JCL
-->
<#-- Generate for PE -->
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar BUILDPE ../../${PE_REPO}/TABLE/tablesPE
<#-- Generate for PEX, if required -->
<#if  ${env[GERS_INCLUDE_PEX"]} == "Y">
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar HLASM ../../${PEX_REPO}/TABLE/tablesPEX
