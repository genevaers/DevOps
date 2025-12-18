# Helpful JCL for packaging DB2 schema unload files for transmission and performing the reverse operations

These instructions provide a procedure used to package the schema unload files into a single compressed dataset. Six of the datasets are PDSE files from unloading LOB data. The remainder are DATA and PNCH files pertaining to each DB2 table. The resulting dataset is a TSO XMIT file of a final combined PDSE containing all the data.
The final output file can be PACKED (TRSMAIN) for compression, although this step is not included.

## Package unload data

RECURMIT.JCL  involves performing recursive TSO XMIT steps to obtain a single PDS dataset containing all DB2 unload files for the schema.

## Unpackage unload data

EXPAXMIT.JCL  involves performing TSO RECEIVE operations starting with an XMIT file of the single PDS dataset to obtain the original unload datasets.


E2PAXMIT.JCL  involves performing TSO RECEIVE operations starting with a single PDS dataset to obtain the original unload datasets. Use this JCL when the schema unload transfer file has been untersed to restore the original combined PDS.

## Unterse transmission file
This job may be needed where TRSMAIN is used as part of the transmission process between mainframes.

UNTERSE.JCL  TRSMAIN UNPACK operation which restores the original combined transmission PDS file.

