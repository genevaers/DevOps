# DevOps
Utilities for Development and Operations for GenevaERS

## Building the GenevaERS Performance Engine

### Setting up the PE build process [First time only]
1. Enter the z/OS UNIX environment (also known as UNIX System Services, or USS).  Do this by entering the following on the Git Bash command line:  
    ```
    ssh <your-tso-id>@<server-name>
    ```
    Example:
    ```
    ssh jsmith@test.ibm.com
    ```
2. Establish a directory to house the .jar files that are required to build the Performance Engine.  (This is known as the "GERS JARS" directory.)  
   1. If you ARE NOT the GenevaERS system administrator for your site: 
      1. Obtain the name of the GERS JARS directory from your GenevaERS system administrator.   
   2. If you ARE the GenevaERS system administrator for your site: 
      1. Create a directory.  Example: 
            ```
            mkdir /u/GenevaERS/gersjars
            ```
      2. Copy IBM JZOS .jar files to the directory. 
      3. If the Performance Engine will be using IBM Db2, copy Db2 .jar files to the directory. 
      4. Inform other GenevaERS developers at your site of the name of the GERS JARS directory. 
3. Create a directory to house the .jar files for the Run-Control App.  Example:        
    ```
    mkdir /u/<your-tso-id>/RCA
    ```
4. In your z/OS UNIX home directory, create a subdirectory for storing the GenevaERS Git repositories.  Example:
    ```
    mkdir /u/<your-tso-id>/git/GenevaERS
    ```
5. Clone the DevOps repository to your Git directory.
6. Find the file .gers.profile in the DevOps directory and copy it to your z/OS UNIX home directory. Open this copy in a text editor.  (We recommend using ISPF option 3.17 for this.)
7. Follow the instructions in .gers.profile and update your environment variables with the appropriate values.  
Note: GERS_GIT_REPO_DIR should match the directory created in step 4.  
8. Save and close .gers.profile.
9. Open the .profile file that is in your z/OS UNIX home directory (if it doesn't exist, create it), and add the following line:
    ```
    . ~/.gers.profile
    ```
### Building the Performance Engine and running the regression tests
1. Get the latest copy of the DevOps directory.  
   1. Change to the GenevaERS directory.
   2. Remove the existing DevOps directory:
    ```
    rm -rf DevOps
    ```
    3. Clone the DevOps repository, For example, using SSH:
    ```
    git clone git@github.com:genevaers/DevOps.git
    ```
    4. Change to the DevOps directory:
    ```
    cd DevOps
    ```
2. Check out the branch you require, for example:
    ```
    git checkout V4
    ```
3. Edit and save the appropriate environment variables in ~/.gers.profile to:  
   - set the build version number  
   - point to the required repository branches  
  For example:
    ```
    export GERS_BUILD_VERSION='4'
    export GERS_BUILD_MAJOR='18'
    export GERS_BUILD_MINOR='099'

    export GERS_BRANCH_PE="PM_4.18.099.B0123_branch"
    export GERS_BRANCH_PEX="PM_4.18.099.B0123_branch"
    export GERS_BRANCH_RCA="PM_4.18.099.B0123_branch"
    ```
   - Review the environment variables that determine where the build output will be. For example: 
    ```
    export GERS_BUILD_HLQ="GENEVA.$LOGNAME"
    export GERS_ENV_HLQ="GENEVA.$LOGNAME"
    export GERS_RCA_JAR_DIR="$HOME/RCA"
    ```
Note that $LOGNAME will resolve to the user ID of the person running the build script, and $HOME to their home directory.
See [Results of the Build](#results-of-the-build) for more information.

1. To run the build enter the following:
    ```
    ./build.sh
    ```
This will start a series of scripts and jobs which will build the Performance Engine then run the regression tests.  

The build process generates tagging scripts and JCL.

### Results of the Build

#### Assembler modules

The build will create data sets based on the environment variables specified in .gers.profile .
For example:
```
export GERS_BUILD_VERSION='4'
export GERS_BUILD_MAJOR='18'
export GERS_BUILD_MINOR='099'
```
In conjunction with the build HLQ:
```
export GERS_BUILD_HLQ='GENEVA.USERID'
```
Will produce: 
```
GENEVA.USERID.PM418099.B0001.ADATA   
GENEVA.USERID.PM418099.B0001.ASM     
GENEVA.USERID.PM418099.B0001.ASMLANGX
GENEVA.USERID.PM418099.B0001.ENV     
GENEVA.USERID.PM418099.B0001.GVBDBRM 
GENEVA.USERID.PM418099.B0001.GVBLOAD <-- load library
GENEVA.USERID.PM418099.B0001.JCL     
GENEVA.USERID.PM418099.B0001.LINKPARM 
GENEVA.USERID.PM418099.B0001.LISTASM  
GENEVA.USERID.PM418099.B0001.LISTDB2  
GENEVA.USERID.PM418099.B0001.LISTJOB  
GENEVA.USERID.PM418099.B0001.LISTLINK 
GENEVA.USERID.PM418099.B0001.MAC      
GENEVA.USERID.PM418099.B0001.OBJ      
```

The “B” number increments for every time you run the build with the same HLQ and version/major/minor numbers.

The following aliases will be set for all the data sets:

One set is based on the major build number. For example
```
GENEVA.USERID.PM418.*
```
Another set of aliases uses the 'environment HLQ' set in .gers.profile, for example:

export GERS_ENV_HLQ=GENEVA.LATEST

will produce a set of aliases 
```
GENEVA.LATEST.*
```
#### RCApps

The RCApps jar file location is determined in .gers.profile by the environment variable GERS_RCA_JAR_DIR.

For example:

export GERS_RCA_JAR_DIR='/u/USERID/RCA'

Will copy the RCApps jar to this directory, and create symbolic links (aliases), as shown below.
```
/u/USERID/RCA> ls -la
<snip>
-rwxr-xr-x    1 USERID   GENEVA   24062073 Aug  5 18:21 rcapps-1.1.0_RC18.jar
lrwxrwxrwx    1 USERID   GENEVA        21 Aug  5 18:21 rcapps-PM418018.jar -> rcapps-1.1.0_RC18.jar
lrwxrwxrwx    1 USERID   GENEVA        21 Aug  5 18:21 rcapps-latest.jar -> rcapps-1.1.0_RC18.jar
```

### Tagging the build 

You can run the tagging script:  
1. In the SH directory of DevOps run the generated script TagBuild.sh.
    ```
    ./TagBuild.sh
    ```
or submit the tagging JCL:  

2. In your build JCL library <GERS_ENV_HLQ>.JCL, submit TAGBLD.

### Tagging the release 
You can run the tagging script:
1. In the SH directory of DevOps run the generated script TagRel.sh.
    ```
    ./TagRel.sh
    ```
or submit the tagging JCL:  

2. In your build JCL library <GERS_ENV_HLQ>.JCL, submit TAGREL.

### Db2 BIND jobs

If the Db2 components for the assembler programs are requested, Db2 BIND JCL will be generated.  
In your build JCL library <GERS_ENV_HLQ>.JCL, edit BINDPE and BINDPEX for your environment, and submit.
