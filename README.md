# DevOps
Utilities for Development and Operations for GenevaERS

## Building the GenevaERS Performance Engine

### Setting up the PE build process [First time only]
1. In your USS home directory, create a subdirectory for storing the GenevaERS Git repositories.  Example:
   - `/u/<your-tso-id>/git/GenevaERS`
2. Clone the DevOps repository to your Git directory.
3. Find the file gers.profile in the DevOps directory and open it in a text editor.  (We recommend using ISPF option 3.17 for this.)
4. Copy all the lines of this file to your clipboard.
5. Navigate to your USS home directory.
6. Open the file named .profile in a text editor.
7. Paste the saved lines at the end of .profile.
8. Follow the instructions in these new lines and update your environment variables with the appropriate values.
9. Save and close .profile.
10. In the JCL folder of the DevOps repo, open the SETUPBLD.jcl file.  (We recommend using ISPF option 3.17 for this.)
11. Edit the JCL according to the instructions specified in the job.  This job will delete and recreate a library named:
    - `<your-tso-id>.GERS.BLDPARM`  
(This will be known as your Build Parameters library.)
1.  The job will then copy environment variable values from your .profile to symbolic parameters that will be used in subsequent jobs. You may override key environment variable when you submit the Performance Engine build job.  
2.  At the USS command line, create a symbolic link from our web server's data directory to your Test Framework output directory.  For example:   
    - `ln -fs /u/rhness/git/GenevaERS/Run-Control-Apps/PETestFramework/out /u/safrbld/websrv1/htdocs/rhnresults`

### Building the Performance Engine and executing the regression tests
1. Navigate to your DevOps repo directory on a USS command line.
2. Enter the following command to refresh the repo with the latest updates:

```
    git pull
```
3. If you've made any recent changes to GERS_ environment variables, open the SETUPBLD.jcl file in the JCL folder of the DevOps repo and submit it.  (We recommend using ISPF option 3.17 for this.)
12. In the JCL folder of the DevOps repo, open the BLDPE.jcl file.  (We recommend using ISPF option 3.17 for this.)
13. Edit the job card to be appropriate for your site.
14. Edit the JCL according to the instructions specified in the job.
15. Submit the job to build the Performance Engine and execute the regression tests.
