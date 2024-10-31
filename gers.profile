
# Environment variables for GenevaERS 
# -----------------------------------

#     The following environment variables are used to identify the 
#     release of the Performance Engine:
#         GERS_PE_VERSION_NBR is the Version Number (1 digit).
#         GERS_PE_MAJOR_REL_NBR is the Major Release Number (2 digits).
#         GERS_PE_MINOR_REL_NBR is the Minor Release Number (3 digits). 
#     Note:  You may override these values in the Performance Engine
#     build JCL.   
#
export GERS_PE_VERSION_NBR='5'
export GERS_PE_MAJOR_REL_NBR='01'
export GERS_PE_MINOR_REL_NBR='001'
#
#     The grouping of these three pieces is known as the 
#     Release Number.  (Example: 501001)
#
export GERS_PE_REL_NBR=$GERS_PE_VERSION_NBR$GERS_PE_MAJOR_REL_NBR$GERS_PE_MINOR_REL_NBR
#    
#     Sometimes the number is formatted with dots.  (Example 5.01.001)
#    
export GERS_PE_REL_NBR_FORMATTED=$GERS_PE_VERSION_NBR.$GERS_PE_MAJOR_REL_NBR.$GERS_PE_MINOR_REL_NBR
#    
#     The Component ID for this product is "PM" for "Performance Engine 
#     - MVS".
#
#     The Release Name is the Release Number prefixed by the 
#     Component ID.  (Example: PM501001)
#
#     The Major Release Name is the Component Id grouped with the 
#     Version Number and the Major Release Number.  (Example: PM501)

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
export GERS_TEST_SPEC_LIST='Basespeclist.yaml'

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

#     For each of the following environment variables,
#     a value of 'Y' will cause the associated repository to be 
#     deleted (if it exists) and cloned.  Any other value will
#     leave the repository source code untouched.
#         GERS_CLONE_PEB - Performance-Engine (base)
#         GERS_CLONE_PEX - Performance-Engine-Extensions
#         GERS_CLONE_RUN - Run-Control-Apps
#     Note:  You may override these values in the Performance Engine
#     build JCL.   
#      
export GERS_CLONE_PEB='Y'
export GERS_CLONE_PEX='Y'
export GERS_CLONE_RUN='Y'

#     The following symbolic parameters specify the branches or tags
#     to be checked out on the Git repositories to be used for the
#     build:
#         GERS_BRANCH_PEB - Performance-Engine (base)
#         GERS_BRANCH_PEX - Performance-Engine-Extensions
#         GERS_BRANCH_RUN - Run-Control-Apps
#     Note:  You may override these values in the Performance Engine
#     build JCL.   
#      
export GERS_BRANCH_PEB='main'
export GERS_BRANCH_PEX='main'
export GERS_BRANCH_RUN='main'

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

#     GERS_TEMP_UNIT_NAME is the name to be used in the UNIT parameter
#     of all DD statements for temporary data sets.  
#
#     Example: 
#
#         GERS_TEMP_UNIT_NAME='TEMPDISK' yields: 
#             UNIT=TEMPDISK
#
export GERS_TEMP_UNIT_NAME='SYSDA'

#     GERS_PERM_UNIT_NAME is the name to be used in the UNIT parameter
#     of all DD statements for permanent data sets.  A Retention Period
#     can optionally be appended to the end of the name.
#
#     Examples: 
#
#         GERS_PERM_UNIT_NAME='DISK' yields: 
#             UNIT=DISK                     (without retention period)
#
#         GERS_PERM_UNIT_NAME='DISK,RETPD=9999' yields: 
#             UNIT=DISK,RETPD=9999          (with retention period)
#
export GERS_PERM_UNIT_NAME='SYSDA'

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

#     GERS_JOB_ACCT_INFO is used in the job accounting information 
#     area of the JOB card in generated JCL.  
#
export GERS_JOB_ACCT_INFO='ACCT'

#     GERS_JOB_CLASS is the job class to be used in
#     the JOB card in generated JCL.  
#
export GERS_JOB_CLASS='A'

#     GERS_MSG_CLASS is the message class to be used in
#     the JOB card in generated JCL.  
#
export GERS_MSG_CLASS='H'

#     GERS_MSG_LEVEL is the message level to be used in
#     the JOB card in generated JCL.  
#
export GERS_MSG_LEVEL='(1,1)'

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
