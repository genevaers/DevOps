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
 Set all the different variables needed
 -->
<#-- BLDVER is the Version Number (1 digit).
     BLDMAJ is the Major Release Number (2 digits).
     BLDMIN is the Minor Release Number (3 digits). -->
<#-- The grouping of these three pieces is known as the 
 Release Number.  
 (Example: 501001) -->
<#assign RELEASE = env["BLDVER"] + env["BLDMAJ"] + env["BLDMIN"]>
<#-- Sometimes the number is formatted with dots. 
 (Example: 5.01.001) -->
<#assign RELFMT = env["BLDVER"] + "." + env["BLDMAJ"] + "." + env["BLDMIN"]>
 
<#-- The Component ID for this product is "PM" for "Performance 
 Engine - MVS". 
 The Major Release Name is the Component ID grouped with the 
 Version Number and the Major Release Number.  
 (Example: PM501) -->
<#assign MAJOR_REL = "PM" + env["BLDVER"] + env["BLDMAJ"]>
<#-- The Minor Release Name is the Release Number prefixed by the 
 Component ID.  
 (Example: PM501001) -->
<#assign MINOR_REL = "PM" + env["BLDVER"] + env["BLDMAJ"] + env["BLDMIN"]>

<#-- The Major HLQ is used for setting the ALIASes 
 ( Example: GEBT.BOB.PM512 ) -->
<#assign MAJOR_HLQ  = env["GERS_BUILD_HLQ"] + "." + MAJOR_REL>

<#-- The Minor HLQ is use for creating the XMIT file
(Example: GEBT.BOB.PM512123) -->
<#assign MINOR_HLQ  = env["GERS_BUILD_HLQ"] + "." + MINOR_REL>

<#assign TARGET_HLQ  = env["GERS_BUILD_HLQ"] + "." + MINOR_REL + ".B" + env["BLDNBR"]>

<#-- Release ${RELEASE}
RELFMT ${RELFMT}
Major rel ${MAJOR_REL}
Minor rel ${MINOR_REL}
Major HLQ ${MAJOR_HLQ}
Minor HLQ ${MINOR_HLQ}
Target HLQ ${TARGET_HLQ} -->

<#-- extract repository names from the repo remote addresses 
<#assign PE_REPO = env["GERS_REMOTE_PEB"]?keep_after_last("/")?keep_before(".")>
<#assign PEX_REPO = env["GERS_REMOTE_PEX"]?keep_after_last("/")?keep_before(".")>
<#assign RCA_REPO = env["GERS_REMOTE_RUN"]?keep_after_last("/")?keep_before(".")>
-->