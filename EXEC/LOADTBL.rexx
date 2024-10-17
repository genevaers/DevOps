/* REXX ****************************************************************
 
    PROGRAM NAME: LOADTBL
    PURPOSE:
        Load ISPF tables from CSV files
 
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
 
/*  trace ?r
*/
signal on syntax     name 9990_FLAG_SYNTAX_ERROR
 
0000_LOAD_GENEVA_TABLES:
 
    call 1000_INITIATE_PROCESSING
 
    address "ISPEXEC"
 
    do _I = 1 to Tbl.0 
        call 2000_PROCESS_MEMBER
    end
 
    call 9000_TERMINATE_PROCESSING
 
    return
 
 
1000_INITIATE_PROCESSING:
 
    /*%include GVB$RHDR*/
 
    say "LOADTBL - Load ISPF tables from CSV files"
    say
 
    parse value date("Standard") with ,
        CCYY +4 MM +2 DD
 
    say "Executed:" CCYY || "-" || MM || "-" || DD time()
    say
 
    call on error      name 9991_FLAG_TSO_ERROR
 
    "EXECIO * DISKR TBLLIST (STEM TBL.     FINIS)"
 
    address "ISPEXEC"
 
    "CONTROL ERRORS RETURN"
 
    "LMINIT  DATAID(DATAID) DDNAME(SRCTLIB)"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMOPEN  DATAID(" DATAID ")"
 
    if RC = 8  then
        do
            say "Data set could not be opened"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    call off error
 
    if Tbl.0 = 0  then                        /* Input list is empty */
        call 1100_GET_ALL_MBR_NAMES
 
    Table_Closed = 1
 
    return
 
 
1100_GET_ALL_MBR_NAMES:
 
    MEMBER = ""
 
    "LMMLIST DATAID(" DATAID ") MEMBER(MEMBER) OPTION(LIST)"
 
    if RC = 12  then
        do
            say "The data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    do until RC <> 0
        if (left(MEMBER,1) <> "$")  & ,
           (left(MEMBER,1) <> "#")  & ,
           (left(MEMBER,1) <> "@")  then
            do
                Tbl.0  = Tbl.0 + 1
                _I     = Tbl.0
                Tbl._I = MEMBER
            end
        "LMMLIST DATAID(" DATAID ") MEMBER(MEMBER) OPTION(LIST)"
    end
 
    return
 
 
2000_PROCESS_MEMBER:
 
    say "Loading" Tbl._I || "..."
 
    End_Of_Table = "N"
 
    "LMMFIND DATAID(" DataID ") MEMBER(" Tbl._I ") STATS(YES)"
 
    if RC = 8  then
        do
            say "Member not found"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say "Data set is not open or is not partitioned"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMGET DATAID(" DataID ") MODE(INVAR) DATALOC(LINE)" ,
        "DATALEN(DATALEN) MAXLEN(1000)"
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    if RC <> 0  then
        End_Of_Table = "Y"
 
    Record_Count = 1
 
    call 2100_CREATE_TABLE
 
    "LMGET DATAID(" DataID ") MODE(INVAR) DATALOC(LINE)" ,
        "DATALEN(DATALEN) MAXLEN(1000)"
 
    if RC > 8  then
        call 9992_FLAG_ISPF_ERROR
 
    if RC <> 0  then
        End_Of_Table = "Y"
 
    do while End_Of_Table <> "Y"
 
        Record_Count = Record_Count + 1
 
        do _J = 1 to Var_Name.0
 
            if left(Line,1) = '"'         then
                do
                    Line = substr(Line,2)
                    Value_Len = pos('"',Line) - 1
                    Var_Value._J = left(Line,Value_Len)
                    Line = substr(Line,Value_Len+3)
                end
            else
                parse var Line ,
                    Var_Value._J "," Line
 
            interpret Var_Name._J || ' = "' || Var_Value._J || '"'
        end
 
        "TBADD"  Tbl._I
        if RC = 8  then
            do
                say "A row with the same key already exists"
                call 9992_FLAG_ISPF_ERROR
            end
        if RC > 0  then
            call 9992_FLAG_ISPF_ERROR
 
        "LMGET DATAID(" DataID ") MODE(INVAR) DATALOC(LINE)" ,
            "DATALEN(DATALEN) MAXLEN(1000)"
        if RC > 8  then
            call 9992_FLAG_ISPF_ERROR
        if RC <> 0  then
            End_Of_Table = "Y"
 
    end
 
    "TBCLOSE" Tbl._I
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    say copies(" ",16) right(Record_Count,10) "record(s) written"
 
    return
 
 
2100_CREATE_TABLE:
 
    call 6000_BUILD_FIELD_LIST     Line
 
    Var_Name.0 = _J
 
    "TBSTATS" Table_ID "STATUS2(STATUS2)"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    if STATUS2 <> Table_Closed then
        "TBEND" Table_ID
 
    "TBCREATE" Tbl._I "WRITE REPLACE " ,
        "KEYS(" Key ")" ,
        "NAMES(" Field_List ")"
 
    if RC = 8  then
        do
            say "Table in in share mode"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC = 12  then
        do
            say "Table in use; ENQ failed"
            call 9992_FLAG_ISPF_ERROR
        end
 
    if RC > 12  then
        call 9992_FLAG_ISPF_ERROR
 
    return
 
 
6000_BUILD_FIELD_LIST:
 
    arg Header_Line
 
    Header_Line = strip(Header_Line)
 
    _J = 0
 
    call 7000_GET_VARIABLE_NAME
 
    Key        = Var_Name._J
    Field_List = ""
 
/*  do until Header_Line = ""
*/  do while Header_Line <> ""
        call 7000_GET_VARIABLE_NAME
        Field_List = Field_List Var_Name._J
    end
 
    return
 
 
7000_GET_VARIABLE_NAME:
 
    _J = _J + 1
 
    if left(Header_Line,1) = '"'  then
        do
            Header_Line = substr(Header_Line,2)
            Header_Len = pos('"',Header_Line) - 1
            Var_Name._J = word(substr(Header_Line,1,Header_Len),1)
            Header_Line = substr(Header_Line,Header_Len+1)
        end
    else
        parse var Header_Line ,              /* Extract key field */
            Var_Name._J . "," Header_Line
 
    call 8000_VALIDATE_VARIABLE_NAME
 
    return
 
 
8000_VALIDATE_VARIABLE_NAME:
 
    Var_Name_Len = length(Var_Name._J)
    if Var_Name_Len = 0  | ,
       Var_Name_Len > 8  then
        do
            say
            say Var_Name._J
            say
            say "Error on record #" || Record_Count
            say "Variable names must be from 1 to 8 characters"
            call 9999_ABORT_PROCESSING
        end
 
    if verify(Var_Name._J, ,
        "@#$ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") > 0  then
        do
            say
            say Var_Name._J
            say
            say "Error on record #" || Record_Count
            say "Variable names must consist of capital letters, " ,
                "numbers, '@', '#', or '$'"
            call 9999_ABORT_PROCESSING
        end
 
    if verify(left(Var_Name._J,1),"0123456789") = 0 then
        do
            say
            say Var_Name._J
            say
            say "Error on record #" || Record_Count
            say "Variable names must not start with a number"
            call 9999_ABORT_PROCESSING
        end
 
    return
 
 
9000_TERMINATE_PROCESSING:
 
    "LMCLOSE DATAID(" DATAID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    "LMFREE  DATAID(" DATAID ")"
 
    if RC > 0  then
        call 9992_FLAG_ISPF_ERROR
 
    say
    say right(Tbl.0,10) "table(s) successfully loaded"
    say
 
    return
 
 
9990_FLAG_SYNTAX_ERROR:
 
    if word(sourceline(Sigl),1) = "interpret"  then
        do
            say
            say Assignment
            say
            say "Error on record #" || Record_Count
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
 
    Error_Line = "SOURCELINE"(Sigl)
 
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
 
 
9992_FLAG_ISPF_ERROR:
 
    Error_Function = strip(word(sourceline(Sigl),1),"B",'"')
 
    say
    say "Error on record #" || Record_Count
    say
    say "Return Code" RC
    say "CONDITION"("Description")
    say
 
    if ZERRMSG <> "ZERRMSG"  then
        do
            say "ISPF Error:" ZERRMSG
            say ZERRLM
        end
 
    call 9999_ABORT_PROCESSING
 
    return
 
 
9999_ABORT_PROCESSING:
 
    say
    say "Process aborted"
    say
 
    ZISPFRC = 12
    address "ISPEXEC"
    "VPUT (ZISPFRC) SHARED"
 
    exit
 
 
