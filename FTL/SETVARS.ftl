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
<#-- BUILD_VERSION is the Version Number (1 digit).
     BUILD_MAJOR is the Major Release Number (2 digits).
     BUILD_MINOR is the Minor Release Number (3 digits). -->
<#-- The grouping of these three pieces is known as the 
 Release Number.  
 (Example: 501001) -->
<#assign RELEASE = env["BUILD_VERSION"] + env["BUILD_MAJOR"] + env["BUILD_MINOR"]>
<#-- Sometimes the number is formatted with dots. 
 (Example: 5.01.001) -->
<#assign RELFMT = env["BUILD_VERSION"] + "." + env["BUILD_MAJOR"] + "." + env["BUILD_MINOR"]>
<#-- The Component ID for this product is "PM" for "Performance 
 Engine - MVS". 
 The Major Release Name is the Component ID grouped with the 
 Version Number and the Major Release Number.  
 (Example: PM501) -->
<#assign MAJOR_REL = "PM" + env["BUILD_VERSION"] + env["BUILD_MAJOR"]>
<#-- The Minor Release Name is the Release Number prefixed by the 
 Component ID.  
 (Example: PM501001) -->
<#assign MINOR_REL = "PM" + env["BUILD_VERSION"] + env["BUILD_MAJOR"] + env["BUILD_MINOR"]>
<#-- The Major HLQ is used for setting the ALIASes 
 ( Example: GEBT.BOB.PM512 ) -->
<#assign MAJOR_HLQ  = env["GERS_BUILD_HLQ"] + "." + MAJOR_REL>
<#-- The Minor HLQ is use for creating the XMIT file
(Example: GEBT.BOB.PM512123) -->
<#assign MINOR_HLQ  = env["GERS_BUILD_HLQ"] + "." + MINOR_REL>
<#assign TARGET_HLQ  = env["GERS_BUILD_HLQ"] + "." + MINOR_REL + ".B" + env["BUILD_NBR"]>