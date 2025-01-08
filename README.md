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

### Building the Performance Engine and executing the regression tests
1. Navigate to your DevOps repo directory on a USS command line.
2. Enter the following command to refresh the repo with the latest updates:

```
    git pull
```
12. In the JCL folder of the DevOps repo, open the BLDPE.jcl file.  (We recommend using ISPF option 3.17 for this.)
13. Edit the JCL according to the instructions specified in the job, then submit the job.  This will start a series of jobs which will build the Performance Engine and execute regression tests.  
