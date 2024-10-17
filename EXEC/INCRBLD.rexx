/* REXX ****************************************************************
 
    PROGRAM NAME: INCRBLD
    PURPOSE:
        Increment the Build Number
 
------------------------------------------------------------------------
 
    (C) COPYRIGHT IBM CORPORATION 2003, 2010.
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
 
***********************************************************************/
 
signal on syntax   name 9990_FLAG_SYNTAX_ERROR

arg HLQ

say
say "INCRBLD - Increment Build Number"
say

call on error      name 9991_FLAG_TSO_ERROR

BLD_Nbr = "0000"

do forever
    DSN = HLQ || ".B" || BLD_Nbr || ".GVBLOAD"
    if SYSDSN("'"DSN"'") <> "OK"  then
        leave
    BLD_Nbr = right((BLD_Nbr+10001),4)
end


ENV_Rec.1      = "$BLDNBR  = '" || BLD_Nbr || "'"

"EXECIO 1 DISKW ENV (STEM ENV_REC. FINIS)"

say "New Build Number:" BLD_Nbr
say

return


9990_FLAG_SYNTAX_ERROR:

    say
    say "REXX error" RC "in line" Sigl || ":" "ERRORTEXT"(RC)

    Error_Line = "SOURCELINE"(Sigl)

    parse var Error_Line ,
        Error_First Error_Rest

    say Error_Line

    say "CONDITION"("Description")
    say

    call 9999_ABORT_PROCESSING

    return


9991_FLAG_TSO_ERROR:

    say
    say "Return Code" RC "in line" Sigl
    say "SOURCELINE"(Sigl)
    say "CONDITION"("Description")
    say

    call 9999_ABORT_PROCESSING

    return


9999_ABORT_PROCESSING:

    if sysvar("SYSENV") = "FORE"  then
        trace "?R"

    say
    say "Process aborted"
    say

    ZISPFRC = 12
    address "ISPEXEC"
    "VPUT (ZISPFRC) SHARED"

    exit 16


