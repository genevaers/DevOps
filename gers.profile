
# Environment variables for GenevaERS 
# -----------------------------------

#     GERS_BUILD_HLQ specifies the high-level qualifier(s) to be used 
#     for build output files, such as load libraries.  
#
#     The Performance Engine build process increments a four-digit Build 
#     Number, starting at 0000, for every build that is executed for 
#     a given combination of Build HLQ and Release Name.  
#
#     The build process forms the data set names for build output 
#     files as follows: 
#
#         <your-build-hlq>.<rel-name>.B<build-nbr>.<file-llq>
#
#     Examples:
#
#         GERS_BUILD_HLQ='GENEVA' yields: 
#             GENEVA.PM501001.B0000.GVBLOAD      (Production load library)
#
#         GERS_BUILD_HLQ='GENEVA.BOB' yields: 
#             GENEVA.BOB.PM501001.B0000.GVBLOAD  (Load library for Bob)
#
export GERS_BUILD_HLQ='<your-build-hlq>'

#     GERS_ENV_HLQ specifies the high-level qualifier(s) to be used for
#     build work files, such as JCL libraries, and aliases
#     for the build output files.
#
#     Examples:
#
#         GERS_ENV_HLQ='GENEVA.LATEST' yields: 
#             GENEVA.LATEST.JCL                  (Production JCL library)
#
#         GERS_ENV_HLQ='GENEVA.BOB' yields: 
#             GENEVA.BOB.JCL                     (JCL library for Bob)
#
export GERS_ENV_HLQ='<your-env-hlq>'

#     GERS_TEST_SPEC_LIST specifies a file containing list of 
#     regression tests to run.
#
export GERS_TEST_SPEC_LIST='JBasespeclist.yaml'

#     GERS_TEST_HLQ specifies the high-level qualifier of the regression
#     test output files.  
#
export GERS_TEST_HLQ='<your-test-hlq>'

#     GERS_JARS is the USS directory that contains your GERS .jar
#     files.  
#
export GERS_JARS='<your-gers-jars-dir>'

#     GERS_GIT_REPO_DIR is the USS directory that contains your Git
#     repositories.  
#
export GERS_GIT_REPO_DIR='<your-git-repo-dir>'

#     GERS_RCA_JAR_DIR is the USS directory that contains RCA .jar  
#     files.                                                       
#                                                                  
export GERS_RCA_JAR_DIR='<your-rca-jar-dir>'                            
                                                                   
#     GERS_CLONING_METHOD specifies the method that Git will use
#     to clone your repository from the remote server.  A value
#     'SSH' will cause the cloning process to use a password-protected
#     SSH key.  HTTPS (or any other value) will cause the cloning 
#     process to use the web URL instead.
#      
export GERS_CLONING_METHOD='HTTPS'

#     A value of 'Y' for GERS_INCLUDE_PEX will cause the R&D components 
#     of the Performance Engine to be included in the build.  Any 
#     other value will cause the R&D components to be skipped. 
#     Note:  You may override this value in the Performance Engine
#     build JCL.   
#
export GERS_INCLUDE_PEX='Y'

#     A value of 'Y' for GERS_RCA_DB2_INPUT will cause Db2 components
#     to be built into the Run-Control App, allowing it to 
#     receive input from a Db2 database.  Any other value will cause
#     the Db2 components to be skipped.  
#
export GERS_RCA_DB2_INPUT='N'

#     A value of 'Y' for GERS_MR95_DB2_INPUT will cause Db2 components
#     to be built into the View Extract Process (GVBMR95), allowing it 
#     to receive input from a Db2 database.  Any other value will cause
#     the Db2 components to be skipped.  
#
export GERS_MR95_DB2_INPUT='N'

#     GERS_ISPF_LOAD_LIB is the name of the ISPF load library.
#
export GERS_ISPF_LOAD_LIB='ISP.SISPLOAD'

#     GERS_ISPF_MSG_LIB is the name of the ISPF message library.
#
export GERS_ISPF_MSG_LIB='ISP.SISPMENU'

#     GERS_ISPF_PANEL_LIB is the name of the ISPF panel library.
#
export GERS_ISPF_PANEL_LIB='ISP.SISPPENU'

#     GERS_ISPF_SKEL_LIB is the name of the ISPF skeleton library.
#
export GERS_ISPF_SKEL_LIB='ISP.SISPSENU'

#     GERS_ISPF_TABLE_LIB is the name of the ISPF table library.
#
export GERS_ISPF_TABLE_LIB='ISP.SISPTENU'

#     GERS_HLASM_TK_MAC_LIB is the name of the High-Level Assembler 
#     Toolkit macro library.   
#
export GERS_HLASM_TK_MAC_LIB='ASM.SASMMAC2'

#     GERS_HLASM_TK_MOD_LIB is the name of the High-Level Assembler 
#     Toolkit load library.   
#
export GERS_HLASM_TK_MOD_LIB='ASM.SASMMOD2'

#     GERS_LE_MAC_LIB is the name of the Language Environment 
#     macro library.   
#
export GERS_LE_MAC_LIB='CEE.SCEEMAC'

#     GERS_LE_DLL_LIB is the name of the Language Environment 
#     library containing side-decks for DLLs.  
#
export GERS_LE_DLL_LIB='CEE.SCEELIB'

#     GERS_LE_CALL_LIB is the name of the Language Environment 
#     library containing callable services.   
#
export GERS_LE_CALL_LIB='CEE.SCEELKED'

#     GERS_LE_RUN_LIB is the name of the Language Environment 
#     runtime library.
#
export GERS_LE_RUN_LIB='CEE.SCEERUN'

#     GERS_CSS_LIB is the name of the Callable System Services
#     library.
#
export GERS_CSS_LIB='SYS1.CSSLIB'  

#     GERS_LINK_LIB is the name of the system link library. 
#
export GERS_LINK_LIB='SYS1.LINKLIB'  

#     GERS_USS_EXEC_LIB is the name of the USS EXEC library.   
#
export GERS_USS_EXEC_LIB='SYS1.SBPXEXEC'

#     GERS_USS_MSG_LIB is the name of the USS message library.   
#
export GERS_USS_MSG_LIB='SYS1.SBPXMENU'

#     GERS_DB2_LOAD_LIB is the name of the Db2 load library.
#
export GERS_DB2_LOAD_LIB='DSN.V13R1M0.SDSNLOAD'

#     GERS_DB2_EXIT_LIB is the name of the Db2 exit library.
#
export GERS_DB2_EXIT_LIB='DSN.V13R1M0.SDSNEXIT'   

#     GERS_DB2_RUN_LIB is the name of the Db2 runtime library.
#
export GERS_DB2_RUN_LIB='DSN131.RUNLIB.LOAD'

#     GERS_DB2_SUBSYSTEM is the name of the Db2 subsystem.   
#
export GERS_DB2_SUBSYSTEM='DM13'

#     GERS_DB2_PLAN_SUFFIX is the suffix to be applied to the 
#     end of the Db2 plan names.  
#
export GERS_DB2_PLAN_SUFFIX=''

#     GERS_DB2_QUALIFIER is the Db2 qualifier.   
#
export GERS_DB2_QUALIFIER='SDATRT01'

#     GERS_DB2_UTILITY is the Db2 SQL utility program.  
#
export GERS_DB2_UTILITY='DSNTIA13'

#     The following environment variables set values that are needed
#     to run UNIX System Services process from MVS batch JCL.  
#
export _BPXK_AUTOCVT=ON         
export _BPX_SHAREAS='YES'       
export _BPX_SPAWN_SCRIPT='YES'
export _MAKE_BI='NO'  

#     Your PATH must point to the bin directories for Maven and Java 
#     (must be Java 11 or greater).  
#
TEMP=$PATH                             
PATH=''                                
PATH=$PATH:/safr/apache-maven-3.8.4/bin
PATH=$PATH:/Java/J11.0_64/bin          
PATH=$PATH:$TEMP                       
export PATH;                           

#     Your LIBPATH must point to appropriate Java library 
#     directory. 
#
TEMP=$LIBPATH                             
LIBPATH=''                                
LIBPATH=$LIBPATH:/usr/lib/java_runtime64  
LIBPATH=$LIBPATH:$TEMP                    
export LIBPATH;                           

#     Your Maven and Java options must be set to these values. 
#
export MAVEN_OPTS=-Dfile.encoding=IBM-1047 
export JAVA_HOME=/Java/J11.0_64            
export JAVA_OPTS=-Dfile.encoding=ISO8859-1 
export IBM_JAVA_OPTIONS=                   
