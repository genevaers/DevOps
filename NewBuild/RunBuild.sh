set -x;
set -e;
echo;
echo hello
export CLONE_PE=Y
export CLONE_PEX=Y
export CLONE_RCA=Y
export BRANCH_PE="main"
export BRANCH_PEX="main"
export BRANCH_RCA="main"
# increment build number
# create data set HLQ
# $TGTHLQ  = $BLDHLQ || "." || $MINREL || ".B" || $BLDNBR
# Create script to Clone and checkout branches - PE/PEX/RCA
cd ../FTL
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar CLONE tablesDevOps
cp CLONE.jcl CLONE.sh
# Clone Repositories (run generated script)
./CLONE.sh
# Create script to copy ASM/MAC in USS to data sets - use TABLE in clones repo
# Copy to data sets (run generated script)
./COPYSOURCE.sh 
# Generate JCL for build (ASMA,LINK,Bind etc)
cd FTL
# Generate for PE
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar BUILDPE ../../Performance-Engine/TABLE/tablesPE
# Generate for PEX
If PEX required
java -jar ~/FTL2JCL_jar/ftl2jcl-latest.jar HLASM ../../Performance-Engine-Extensions/TABLE/tablesPEX
# Run built JCL - two seperate jobs, or concantinate
./BUILD.sh 
# Set aliases
# Run regression suite