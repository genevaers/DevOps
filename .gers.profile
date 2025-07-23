# Environment variables for GenevaERS 
# -----------------------------------
# 
# Environment variable that may change for every build are here at the top
#
#     The following variables are used to identify the release of the Performance Engine:
#       GERS_BUILD_VERSION is the Version Number (1 digit).
#       GERS_BUILD_MAJOR is the Major Release Number (2 digits).
#       GERS_BUILD_MINOR is the Minor Release Number (3 digits). 
#
export GERS_BUILD_VERSION='5'
export GERS_BUILD_MAJOR='01'
export GERS_BUILD_MINOR='001'

#     For each of the following variables, a value of 'Y' will cause the associated repository to be 
#     deleted (if it exists) and cloned. Any other value will leave the repository source code untouched.
#       GERS_CLONE_PE  - Performance-Engine (base)
#       GERS_CLONE_PEX - Performance-Engine-Extensions
#       GERS_CLONE_RCA - Run-Control-Apps
#
export GERS_CLONE_PE='Y'
export GERS_CLONE_PEX='Y'
export GERS_CLONE_RCA='Y'

#     The following variables specify the branches or tags in the Git repositories to be used for the build:
#       GERS_BRANCH_PE - Performance-Engine (base)
#       GERS_BRANCH_PEX - Performance-Engine-Extensions
#       GERS_BRANCH_RCA - Run-Control-Apps
#
export GERS_BRANCH_PE="main"
export GERS_BRANCH_PEX="main"
export GERS_BRANCH_RCA="main"
export GERS_BUILD_RCA="ZOS" 

#     A value of 'Y' for GERS_INCLUDE_PEX will cause the R&D components 
#     of the Performance Engine to be included in the build.  Any 
#     other value will cause the R&D components to be skipped. 
#
export GERS_INCLUDE_PEX='Y'

#     GERS_BUILD_HLQ specifies the high-level qualifier(s) to be used 
#     for build output files, such as load libraries.  
#
#     Note: This HLQ must be upper case, and 18 characters or less, 
#     including periods ('.'), or the build will fail with JCL errors.
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
#     aliases for the build output files.
#     Note: This HLQ must be upper case, and 35 characters or less, 
#     including periods ('.'), or the build will fail with JCL errors.
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
#     Note: This HLQ must be upper case, and 10 characters or less, 
#     including periods ('.'), or the test framework will fail with
#     dynamic allocation errors, or the tests with JCL errors.
#
export GERS_TEST_HLQ='<your-test-hlq>'

#     If GERS_RUN_TESTS is set to 'Y' the regression tests specified by 
#     GERS_TEST_SPEC_LIST will be executed.
#      
export GERS_RUN_TESTS='Y'

#     GERS_PETEST_TIMEOUT is the maximum time in seconds that the PE  
#     test framework will wait for jobs to complete. If the regression
#     tests are failing with timeout errors, this can be increased.
#      
export GERS_PETEST_TIMEOUT=300

#     GERS_JARS is the USS directory that contains your GERS .jar
#     files.  
#     Note: This variable is needed only when GERS_BUILD_RCA is set to 
#     'ZOS'.  Otherwise, it can be left empty.
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
#     A value of 'Y' for GERS_DB2_JAVA will cause Db2 components to be 
#     included in any Java program (such as the Run-Control App) that needs 
#     to access Db2 data.  Any other value will cause the Db2 components 
#     to be skipped.  
#
export GERS_DB2_JAVA='N'

#     A value of 'Y' for GERS_DB2_ASM will cause Db2 components to be
#     included in any assembler program (such as the View Extract Process 
#     (GVBMR95)) that needs to access Db2 data.  Any other value will cause
#     the Db2 components to be skipped.  
#
export GERS_DB2_ASM='N'

#     The following variables specify the references to remote 
#     repositories to be used in "git clone" statements:
#         GERS_REMOTE_DEV - DevOps
#         GERS_REMOTE_PEB - Performance-Engine (base)
#         GERS_REMOTE_PEX - Performance-Engine-Extensions
#         GERS_REMOTE_RUN - Run-Control-Apps
#
export GERS_REMOTE_DEV='https://github.com/genevaers/DevOps.git'
export GERS_REMOTE_PEB='https://github.com/genevaers/Performance-Engine.git'
export GERS_REMOTE_PEX='https://github.com/genevaers/Performance-Engine-Extensions.git'
export GERS_REMOTE_RUN='https://github.com/genevaers/Run-Control-Apps.git'

#     GERS_JAVA_HOME is the directory where Java is installed.
#
export GERS_JAVA_HOME='/Java/J17.0_64'

#     GERS_JVM_PROC_LIB is the name of the Java Virtual Machine proc library.
#
export GERS_JVM_PROC_LIB='AJV.V11R0M0.PROCLIB'

#     GERS_JZOS_LOAD_LIB is the name of the JZOS load library.
#
export GERS_JZOS_LOAD_LIB='AJV.V11R0M0.SIEALNKE'
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
PATH=$PATH:/Java/J17.0_64/bin          
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
export JAVA_HOME=/Java/J17.0_64
export JAVA_OPTS=-Dfile.encoding=ISO8859-1 
export IBM_JAVA_OPTIONS=                   
