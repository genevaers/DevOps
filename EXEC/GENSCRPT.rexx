/* REXX ****************************************************************
 
    PROGRAM NAME: GENSCRPT
    PURPOSE:
        Generate scripts by merging script definitions with
        ISPF file-tailoring skeletons
 
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
 
signal on syntax     name 9990_FLAG_SYNTAX_ERROR
 
arg ARG_Use_DEFLIB ARG_Use_VARLIB ARG_Site ,
    ARG_Env ARG_Env2 ARG_SG_Trace ARG_FT_Trace ARG_FT_Trace_Options
 
/* trace ARG_SG_Trace */
 
address "ISPEXEC"
 
0000_GENERATE_SCRIPTS:
 
    call 1000_INITIATE_PROCESSING
 
    do _I = 1 to Def.0
        call 2000_PROCESS_SCRIPT
    end
 
    call 9000_TERMINATE_PROCESSING
 
    return
 
 
1000_INITIATE_PROCESSING:
 
    say "GENSCRPT - Script Generator"
    say
 
    parse value date("Standard") with ,
        CCYY +4 MM +2 DD
 
    say "Executed:" CCYY || "/" || MM || "/" || DD time()
    say
 
    Error_Data = ""
    #SYSUID  = userid()
    #ENVOWNR = translate($ENVOWNR,xrange('a','z'),xrange('A','Z'))
    #GENDATE = translate(date())
    #B       = " "
 
    call on error      name 9991_FLAG_TSO_ERROR
    address "TSO" "EXECIO * DISKR DEFLIST  (STEM DEF.     FINIS)"
    call off error
 
    call 1010_PROCESS_DEFLIB_OPT
 
    call 1020_PROCESS_VARLIB_OPT
 
    call 1030_PROCESS_FTTRACE_OPT
 
    if ARG_Use_VARLIB = "Y"  then
        do
            if ARG_Site <> "N/A"  then
                call 1200_PROCESS_SITE_VARS
            if ARG_Env  <> "N/A"  then
                call 1300_PROCESS_ENV_VARS
            if ARG_Env2 <> "N/A"  then
                call 1400_PROCESS_ENV2_VARS
        end
 
    say
 
    return
 
 
1010_PROCESS_DEFLIB_OPT:
 
    if ARG_Use_DEFLIB = "" then
        ARG_Use_DEFLIB = "N"
 
    say "Use Script Definition Library:   " ARG_Use_DEFLIB
 
    if ARG_Use_DEFLIB <> "Y" & ,
       ARG_Use_DEFLIB <> "N" then
        do
            say "DEFLIB must be Y or N"
            call 9999_ABORT_PROCESSING
        end
 
    if ARG_Use_DEFLIB = "Y"  then
        do
            call 1011_OPEN_DEFLIB
            if Def.0 = 0  then                /* Input list is empty */
                call 1015_GET_ALL_DEF_NAMES
        end
 
    return
 
 
1011_OPEN_DEFLIB:
 
    "CONTROL ERRORS RETURN"
 
    "LMINIT  DATAID(DATAID) DDNAME(DEFLIB)"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMOPEN  DATAID(" DATAID ")"
 
    if RC = 8  then
        do
            say "DEFLIB data set could not be opened"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
1015_GET_ALL_DEF_NAMES:
 
    MEMBER = ""
 
    "LMMLIST DATAID(" DATAID ") MEMBER(MEMBER) OPTION(LIST)"
 
    if RC = 12  then
        do
            say "The DEFLIB data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    do while RC = 0
 
        Def.0  = Def.0 + 1
        _I     = Def.0
        Def._I = MEMBER
        "LMMLIST DATAID(" DATAID ") MEMBER(MEMBER) OPTION(LIST)"
    end
 
    return
 
 
1020_PROCESS_VARLIB_OPT:
 
    if ARG_Use_VARLIB = "" then
        ARG_Use_VARLIB = "N"
 
    say "Use Environment Variable Library:" ARG_Use_VARLIB
 
    if ARG_Use_VARLIB <> "Y" & ,
       ARG_Use_VARLIB <> "N" then
        do
            say "VARLIB must be Y or N"
            call 9999_ABORT_PROCESSING
        end
 
    if ARG_Use_VARLIB = "Y"  then
        call 1025_PROCESS_ENV_OPTS
 
    return
 
 
1025_PROCESS_ENV_OPTS:
 
    if ARG_Site = ""  then
        ARG_Site = "N/A"
 
    if ARG_Env = ""  then
        ARG_Env = "N/A"
 
    if ARG_Env2 = ""  then
        ARG_Env2 = "N/A"
 
    say "Site Environment:                " ARG_Site
    say "Primary Data Environment:        " ARG_Env
    say "Secondary Data Environment:      " ARG_Env2
 
    return
 
 
1030_PROCESS_FTTRACE_OPT:
 
    if ARG_FT_Trace = "" then
        ARG_FT_Trace = "N"
 
    say "Use File Tailoring Trace:        " ARG_FT_Trace
 
    if ARG_FT_Trace <> "Y" & ,
       ARG_FT_Trace <> "N"   then
        do
            say "FTTRACE must be Y or N"
            call 9999_ABORT_PROCESSING
        end
 
    say "File Tailoring Trace Options:    " ARG_FT_Trace_Options
    say
 
    return
 
 
1200_PROCESS_SITE_VARS:
 
    call 1210_GET_SITE_VAR_MEMBER
 
    say
 
    say "Site Environment (" || ARG_Site || "):"
 
    say
 
    _J = 0
    RC = 0
 
    do while RC <> 8                   /* Load environment variables */
 
        "LMGET DATAID(" VARLIBID ") MODE(INVAR) DATALOC(LINE)" ,
            "DATALEN(DATALEN) MAXLEN(80)"
        if RC > 8  then
            call 9992_FLAG_ISPF_ERROR
        if RC = 8  then
            leave
 
/*      Line = left(Line,72)          /* Remove line numbers (if any)*/
*/
        if left(Line,2) = "/*"  then               /* Comment line   */
            do
                say Line
                iterate
            end
 
        if Line = " "  then                        /* Blank line     */
            do
                say Line
                iterate
            end
 
/*      call 8000_VALIDATE_ASSIGNMENT
*/
        say Line
/*      interpret Asmt_Var._J "=" Asmt_Value
*/      interpret Line
 
    end
 
    call 1220_RELEASE_SITE_VAR_MEMBER
 
    return
 
 
1210_GET_SITE_VAR_MEMBER:
 
    "LMINIT  DATAID(VARLIBID) DDNAME(VARLIB)"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMOPEN  DATAID(" VARLIBID ")"
 
    if RC = 8  then
        do
            say "VARLIB data set could not be opened"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMMFIND DATAID(" VARLIBID ") MEMBER(" ARG_Site ") STATS(YES)"
 
    if RC = 8  then
        do
            say ARG_Site "member not found in VARLIB"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say "VARLIB data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
1220_RELEASE_SITE_VAR_MEMBER:
 
    "LMCLOSE DATAID(" VARLIBID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMFREE  DATAID(" VARLIBID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
1300_PROCESS_ENV_VARS:
 
    call 1310_GET_ENV_VAR_MEMBER
 
    say
 
    say "Primary Data Environment (" || ARG_Env || "):"
 
    say
 
    _J = 0
    RC = 0
 
    do while RC <> 8                   /* Load environment variables */
 
        "LMGET DATAID(" VARLIBID ") MODE(INVAR) DATALOC(LINE)" ,
            "DATALEN(DATALEN) MAXLEN(255)"
        if RC > 8  then
            call 9992_FLAG_ISPF_ERROR
        if RC = 8  then
            leave
 
/*      Line = left(Line,72)          /* Remove line numbers (if any)*/
*/
        if left(Line,2) = "/*"  then               /* Comment line   */
            do
                say Line
                iterate
            end
 
        if Line = " "  then                        /* Blank line     */
            do
                say Line
                iterate
            end
 
/*      call 8000_VALIDATE_ASSIGNMENT
 
        say Line
        interpret Asmt_Var._J "=" Asmt_Value
*/      interpret Line
 
    end
 
    call 1320_RELEASE_ENV_VAR_MEMBER
 
    return
 
 
1310_GET_ENV_VAR_MEMBER:
 
    "LMINIT  DATAID(VARLIBID) DDNAME(VARLIB)"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMOPEN  DATAID(" VARLIBID ")"
 
    if RC = 8  then
        do
            say "VARLIB data set could not be opened"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMMFIND DATAID(" VARLIBID ") MEMBER(" ARG_Env ") STATS(YES)"
 
    if RC = 8  then
        do
            say ARG_Env "member not found in VARLIB"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say "VARLIB data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
1320_RELEASE_ENV_VAR_MEMBER:
 
    "LMCLOSE DATAID(" VARLIBID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMFREE  DATAID(" VARLIBID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
1400_PROCESS_ENV2_VARS:
 
    call 1410_GET_ENV2_VAR_MEMBER
 
    say
    say "Secondary Data Environment (" || ARG_Env2 || "):"
    say
 
    _J = 0
    RC = 0
 
    do while RC <> 8         /* Load secondary environment variables */
 
        "LMGET DATAID(" VARLIBID ") MODE(INVAR) DATALOC(LINE)" ,
            "DATALEN(DATALEN) MAXLEN(255)"
        if RC > 8  then
            call 9992_FLAG_ISPF_ERROR
        if RC = 8  then
            leave
 
/*      Line = left(Line,72)          /* Remove line numbers (if any)*/
*/
        if left(Line,2) = "/*"  then               /* Comment line   */
            do
                say Line
                iterate
            end
 
        if Line = " "  then                        /* Blank line     */
            do
                say Line
                iterate
            end
 
/*      call 8000_VALIDATE_ASSIGNMENT
 
        say "#" || substr(Line,2)
        Asmt_Var._J = "#" || substr(Asmt_Var._J,2)
        interpret Asmt_Var._J "=" Asmt_Value
*/
    interpret Line
 
    end
 
    call 1420_RELEASE_ENV2_VAR_MEMBER
 
    return
 
 
1410_GET_ENV2_VAR_MEMBER:
 
    "LMINIT  DATAID(VARLIBID) DDNAME(VARLIB)"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMOPEN  DATAID(" VARLIBID ")"
 
    if RC = 8  then
        do
            say "VARLIB data set could not be opened"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMMFIND DATAID(" VARLIBID ") MEMBER(" ARG_Env2 ") STATS(YES)"
 
    if RC = 8  then
        do
            say ARG_Env2 "member not found in VARLIB"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say "VARLIB data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
1420_RELEASE_ENV2_VAR_MEMBER:
 
    "LMCLOSE DATAID(" VARLIBID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMFREE  DATAID(" VARLIBID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
2000_PROCESS_SCRIPT:
 
/*  Def._I   = strip(left(Def._I,72))  /* Remove line numbers (if any)*/
*/
    say "Creating script - Definition:" Def._I
 
    if ARG_Use_DEFLIB = "Y"  then
        call 2100_PROCESS_SCRIPT_DEFINITION
    else
        do
            MMBRNAME = Def._I
            MSKEL    = Def._I
            say "DEFLIB not used - defaulting values:"
            say "MMBRNAME =" MMBRNAME
            say "MSKEL    =" MSKEL
        end
 
    say "                  Skeleton:  " MSKEL
 
    if ARG_FT_Trace = "Y" then
        "SELECT CMD(ISPFTTRC" ARG_FT_Trace_Options ")"
 
    "FTOPEN"
 
    if RC = 8  then
        do
            "FTCLOSE"
            RC = 0
        end
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "FTINCL" MSKEL "EXT"
 
    if RC = 8  then
        do
            say MSKEL "skeleton does not exist in ISPSLIB"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say MSKEL "skeleton in use; ENQ failed"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    "FTCLOSE NAME(" MMBRNAME ")"
 
    if RC = 12  then
        do
            say "ISPFILE output file in use. ENQ failed"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    if ARG_FT_Trace = "Y" then
        "SELECT CMD(ISPFTTRC)"
 
    say "                  Script:    " MMBRNAME
    say
 
    if ARG_Use_DEFLIB = "Y"  then
        do _K = 1 to Def_Line_Count  /* Reset script def variables */
            interpret Asmt_Var._K "= '' "
        end
 
    return
 
 
2100_PROCESS_SCRIPT_DEFINITION:
 
    "LMMFIND DATAID(" DataID ") MEMBER(" Def._I ") STATS(YES)"
 
    if RC = 8  then
        do
            say Def._I "member not found in DEFLIB"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say "DEFLIB data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    _J = 0
    RC = 0
 
    do while RC <> 8
 
        "LMGET DATAID(" DATAID ") MODE(INVAR) DATALOC(LINE)" ,
            "DATALEN(DATALEN) MAXLEN(255)"
        if RC > 8  then
            call 9992_FLAG_ISPF_ERROR
        if RC = 8  then
            leave
 
/*      Line = left(Line,72)       /* Remove line numbers (if any)*/
*/
        say line
 
        if left(Line,2) = "/*"  then               /* Comment line   */
            iterate
 
        if Line = " "  then                        /* Blank line     */
            iterate
 
/*      call 8000_VALIDATE_ASSIGNMENT
*/
        interpret Asmt_Var._J "=" Asmt_Value
 
    end
 
    Def_Line_Count = _J
 
    return
 
 
8000_VALIDATE_ASSIGNMENT:
 
    Comment_Pos = pos("/*",Line)
 
    if Comment_Pos > 0  then
        do
            Assignment = left(Line,Comment_Pos-1)
            Comment    = substr(Line,Comment_Pos)
        end
    else
        Assignment = Line
 
    Equal_Sign_Pos = pos("=",Assignment)
 
    if Equal_Sign_Pos = 0  then
        do
            say "'=' sign is missing"
            call 9999_ABORT_PROCESSING
        end
 
    _J         = _J + 1
    Asmt_Var._J = strip(left(Assignment,Equal_Sign_Pos-1))
    Asmt_Value  = strip(substr(Assignment,Equal_Sign_Pos+1))
 
    Asmt_Var_Len = length(Asmt_Var._J)
    if Asmt_Var_len = 0  | ,
       Asmt_Var_len > 8  then
        do
            say "Variable names must be from 1 to 8 characters"
            call 9999_ABORT_PROCESSING
        end
 
    if verify(Asmt_Var._J,"@#$ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") ,
        > 0  then
        do
            say "Variable names must consist of capital letters, " ,
                "numbers, '@', '#', or '$'"
            call 9999_ABORT_PROCESSING
        end
 
    if verify(left(Asmt_Var._J,1),"0123456789") = 0 then
        do
            say "Variable names must not start with a number"
            call 9999_ABORT_PROCESSING
        end
 
    signal on syntax     name 9995_FLAG_VALUE_SYNTAX_ERROR
    Value_Test = value("Asmt_Value")
    signal on syntax     name 9990_FLAG_SYNTAX_ERROR
 
    return
 
 
9000_TERMINATE_PROCESSING:
 
    if ARG_Use_DEFLIB = "Y"  then
        call 9100_CLOSE_DEFLIB
 
    say
    say Def.0 || " script(s) successfully generated"
    say
 
    return
 
 
9100_CLOSE_DEFLIB:
 
    "LMCLOSE DATAID(" DATAID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMFREE  DATAID(" DATAID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
9990_FLAG_SYNTAX_ERROR:
 
    if word(sourceline(Sigl),1) = "interpret"  then
        do
            say
            say "REXX error" RC || ":" errortext(RC)
            say
        end
    else
        do
            say
            say sourceline(Sigl)
            say
            say "REXX error" RC "in line" Sigl || ":" errortext(RC)
            say
        end
 
    say
 
    ZISPFRC = 12
    address "ISPEXEC"
    "VPUT (ZISPFRC) SHARED"
 
    exit
 
 
9991_FLAG_TSO_ERROR:
 
    say
    say "Return Code" RC "in line" Sigl
    say "SOURCELINE"(Sigl)
    say "CONDITION"("Description")
    say
 
    call 9999_ABORT_PROCESSING
 
    return
 
 
9992_FLAG_ISPF_ERROR:
 
    Error_Function = strip(word(sourceline(Sigl),1),"B",'"')
 
    if ZERRMSG <> "ZERRMSG"  then
        do
            say "ISPF Error:" ZERRMSG
            say ZERRLM
        end
 
    if "Error_Data" <> ""  then
        say Error_Data
 
    say
    say "Return Code" RC
    say "CONDITION"("Description")
    say
 
    call 9999_ABORT_PROCESSING
 
    return
 
 
9995_FLAG_VALUE_SYNTAX_ERROR:
 
    say "The value has invalid REXX syntax"
 
    call 9999_ABORT_PROCESSING
 
    return
 
 
9999_ABORT_PROCESSING:
 
    say
    say "Process aborted"
    say
 
    ZISPFRC = 12
    address "ISPEXEC"
    "VPUT (ZISPFRC) SHARED"
 
    exit 16
 
 
