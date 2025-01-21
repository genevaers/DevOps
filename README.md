# DevOps
Utilities for Development and Operations for GenevaERS

## Building the GenevaERS Performance Engine

### Setting up the PE build process [First time only]
1. Establish a directory to house the .jar files that are required to build the Performance Engine.  (This is known as the "GERS JARS" directory.)  
   1. If you ARE NOT the GenevaERS system administrator for your site: 
      1. Obtain the name of the GERS JARS directory from your GenevaERS system adminstrator.   
   2. If you ARE the GenevaERS system administrator for your site: 
      1. Create a directory.  Example: 
            ```
            mkdir /u/GenevaERS/gersjars
            ```
      3. Copy IBM JZOS .jar files to the directory. 
      4. If the Performance Engine will be using IBM Db2, copy Db2 .jar files to the directory. 
      5. Inform other GenevaERS developers at your site of the name of the GERS JARS directory. 
2. Create a directory to house the .jar files for the Run-Control App.  Example:        
    ```
    mkdir /u/<your-tso-id>/RCA
    ```
3. In your USS home directory, create a subdirectory for storing the GenevaERS Git repositories.  Example:
    ```
    mkdir /u/<your-tso-id>/git/GenevaERS
    ```
4. Clone the DevOps repository to your Git directory.
5. Find the file gers.profile in the DevOps directory and open it in a text editor.  (We recommend using ISPF option 3.17 for this.)
6. Copy all the lines of this file to your clipboard.
7. Navigate to your USS home directory.
8.  Open the file named .profile in a text editor.  (If it doesn't exist, create it.)
9.  Paste the saved lines at the end of .profile.
10. Follow the instructions in these new lines and update your environment variables with the appropriate values.
11. Save and close .profile.

### Building the Performance Engine and executing the regression tests
1. Navigate to your DevOps repo directory on a USS command line.
2. Enter the following command to refresh the repo with the latest updates:
    ```
    git pull
    ```
12. In the JCL folder of the DevOps repo, open the BLDPE.jcl file.  (We recommend using ISPF option 3.17 for this.)
13. Edit the JCL according to the instructions specified in the job, then submit the job.  This will start a series of jobs which will build the Performance Engine and execute regression tests.  
