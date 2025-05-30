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
      1. Obtain the name of the GERS JARS directory from your GenevaERS system adminstrator.   
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
8. Save and close .gers.profile.
9. Open the .profile file that is in your z/OS UNIX home directory (if it doesn't exit, create it), and add the following line:
```
. ~/.gers.profile
```
10. Navigate to the FTL2JCL directory under the DevOps directory.
11. Execute build.sh.  
This builds the utility used to create the JCL during the Performance Engine build. It will copy the .jar file to the RCA jar file directory created earlier and referenced by $GERS_RCA_JAR_DIR.

### Building the Performance Engine and executing the regression tests
1. Navigate to the SH directory under the DevOps directory. 
2. Execute Build.sh.  
This will start a series of scripts and jobs which will build the Performance Engine then execute regression tests.  

The build process generates tagging scripts and JCL.

### Tagging the build 

You can run the tagging script:
1. In the SH directory of DevOps execute the generated script TAGBUILD.sh.
or submit the tagging JCL:
2. In your build JCL library (<GERS_ENV_HLQ>.JCL), submit TAGBLD.

### Tagging the release 
You can run the tagging script:
1. In the SH directory of DevOps execute the generated script TAGREL.sh.
or submit the tagging JCL:
2. In your build JCL library (<GERS_ENV_HLQ>.JCL), submit TAGREL.
