# Helpful JCL for packaging DB2 schema unload files for transmission and performing the reverse operations

These instructions provide a procedure used to package the schema unload files into a single compressed dataset. Six of the datasets are PDSE files from unloading LOB data. The remainder are DATA and PNCH files pertaining to each DB2 table. The resulting dataset is a TSO XMIT file of a final combined PDSE containing all the data.

### Note:

The final output file can be PACKED (TRSMAIN) for compression, depending on your site's file transfer configuration. This step is not part of the packaging process of the database unload datasets (RECURMIT).

## Package unload data

**RECURMIT.JCL**  involves performing recursive TSO XMIT steps to obtain a single combined PDS dataset containing all DB2 unload files for the schema. The resulting dataset is in TSO XMIT format.

## Unpackage unload data in XMIT format

**EXPAXMIT.JCL**  This job is used where the transfer dataset is in XMIT format. It involves performing TSO RECEIVE operations starting with an XMIT file of the single combined PDS dataset to obtain the original database unload datasets.

## Unpackage unload data in TRSMAIN format

**E2PAXMIT.JCL**  This job is used where the transfer dataset is in TRS format. It involves first performing TRSMAIN UNPACK and subsequent TSO RECEIVE operations on the resulting single combined PDS dataset to obtain the original database unload datasets.

