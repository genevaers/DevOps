set -x;
set -e;
echo;
export CLONE_PE=Y
export CLONE_PEX=Y
export CLONE_RCA=Y
export BRANCH_PE="main"
export BRANCH_PEX="main"
export BRANCH_RCA="main"
export BLDRCA=N
export BLDVER='5'
export BLDMAJ='01'
export BLDMIN='001'
export UNITPRM=SYSDA
export UNITTMP=SYSDA

# increment build number
# create data set HLQ
# $TGTHLQ  = $BLDHLQ || "." || $MINREL || ".B" || $BLDNBR
# generates JCL to allocate data sets
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar ALLOC ../TABLE/tablesDevOps ;
# Submit this JCL - hmm could be timing issues - how do we wait for completion? ps command?
submit ALLOC.jcl
wait ???
#
# Create script to Clone and checkout branches - PE/PEX/RCA
#
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar CLONE ;
#  Run the Clone Repositories generated script
chmod +x CLONE.jcl;
. CLONE.sh  
#
# Next stuff uses TABLES in the PE and PEX repos
#
# Generate script to call java to generate script and JCL 
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar GenBuild ;
#
### there are some issues here with how the tables in PE and PEX are pointed to. 
### We need to ability to point to different tables
./GenBuild.sh
# Set aliases
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar ALIAS ../TABLE/tablesDevOps ;
submit ALIAS.jcl
wait ??
# Run regression suite
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar RunReg 
./RunReg 