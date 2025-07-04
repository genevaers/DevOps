# DevOps
Utilities for Development and Operations for GenevaERS

## Building the GenevaERS Performance Engine

### Setting up the PE build process [First time only]
1. Enter the z/OS UNIX environment (also known as UNIX System Services, or USS).  One way to do this is to enter the following command on the ISPF command line: 
    ```
    TSO OMVS
    ```
    Another way is to enter the following on the Git Bash command line: 
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
1. Navigate to the DevOps directory, and pull the latest copy:
    ```
    git pull
    ```
2. Check out the branch you require, for example:
    ```
    git checkout V4
    ```
3. To run the build enter the following:
    ```
    ./build.sh
    ```
This will start a series of scripts and jobs which will build the Performance Engine then run the regression tests.  

The build process generates tagging scripts and JCL.

### Tagging the build 

You can run the tagging script:  
1. In the SH directory of DevOps run the generated script TAGBUILD.sh.
    ```
    ./TAGBUILD.sh
    ```
or submit the tagging JCL:  

2. In your build JCL library <GERS_ENV_HLQ>.JCL, submit TAGBLD.

### Tagging the release 
You can run the tagging script:
1. In the SH directory of DevOps run the generated script TAGREL.sh.
    ```
    ./TAGBUILD.sh
    ```
or submit the tagging JCL:  

2. In your build JCL library <GERS_ENV_HLQ>.JCL, submit TAGREL.

### Db2 BIND jobs

If the Db2 components for the assembler programs are requested, Db2 BIND JCL will be generated.  
In your build JCL library <GERS_ENV_HLQ>.JCL, edit BINDPE and BINDPEX for your environment, and submit.
