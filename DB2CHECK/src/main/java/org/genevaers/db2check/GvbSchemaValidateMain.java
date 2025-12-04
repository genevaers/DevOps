package org.genevaers.db2check;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

import java.sql.*;

public class GvbSchemaValidateMain {
    @SuppressWarnings("resource")
    public static void main(String[] args)
    {
        HashMap<String, String> spmap = new HashMap<>(30); // stored procedures digest
        HashMap<String, String> tbmap = new HashMap<>(100); // table/column digest
        HashMap<String, String> ixmap = new HashMap<>(100); // index digest
        HashMap<String, String> fkmap = new HashMap<>(100); // foreign key digest

        Integer ii = 0;
        Integer finalI = 0;
        BufferedReader reader;
        String url = "";
        String user = "";
        String digestType = "SHA3-512";
        String password = "";
        String schema_mask = "";
        Boolean makeHash = false;
        Boolean makeDef = false;
        BufferedWriter fwriter; // general output
        BufferedWriter hwriter = null; // digest output
        BufferedWriter[] dwriter = new BufferedWriter[4]; // Definition files: stored procedures, table/columns, indexes and foreign keys
        dwriter[0] = null;
        dwriter[1] = null;
        dwriter[2] = null;
        dwriter[3] = null;
        
        Connection con;

        System.out.println ("**** Running GvbSchemaValidateMain: checking DB2 Schema");

        Integer nArgs =args.length;
        Integer n;

        // command line argument[s]
        for (n = 0; n < nArgs; n++) {
            if (args[n].substring(0,1).equals("-")) {
                switch( args[n].substring(1,2))
                 {
                    // generate hash map -- does NOT validate the schema
                    case "A":
                        makeHash = true;
                        break;
                    // generate DDL statement -- available in all cases
                    case "D":
                        makeDef = true;
                        break;
                    default:
                        break;
                }
            }
        }

        // ///////////////////////////////////////
        //  TEMPORARY ASSIGNMENTS
        makeHash = false;
        makeDef = true;
        // ///////////////////////////////////////

        if (makeHash) {
            System.out.println("Option to generate Schema digest from DB2 catalog: " + makeHash);
        }
        if (makeDef) {
            System.out.println("Option to generate Schema definitions from DB2 catalog: " + makeDef);
        }

        // read configurtion information from home directory
        try {
            ii = 0;
            reader = new BufferedReader(new FileReader(System.getenv("HOMEPATH")+"\\password.txt"));
			String line = reader.readLine();
			while (line != null) {
                if ( 0 == ii) {
                    user = line.substring(0);
                }
                else
                {
                    if ( 1 == ii ) {
                        password = line.substring(0);
                    }
                    else
                    {
                        if ( 2 == ii ) {
                            url = line.substring(0);
                        }
                        else
                        {
                            if ( 3 == ii ) {
                                schema_mask = line.substring(0);
                            }
                        }
                    }
                }
                // read next line
                ii = ii + 1;
			    line = reader.readLine();
			}
            finalI = ii;
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
            return;
		}
        // configuration information has been read
        System.out.println("User: " + user + " Url: " + url + " Schema mask: " + schema_mask + " Lines read: " + finalI);


        // read Digest information from home directory
        if (makeHash) {
            // Do nothing: as we are generating digest values and not validating them
        } else {
            try {
                Integer State = -1;

                ii = 0;
                reader = new BufferedReader(new FileReader(System.getenv("HOMEPATH")+"\\SchemaDigest.txt"));
		    	String line = reader.readLine();
			    while (line != null) {
                    if (line.contains("// Populate digest map of stored procedures")) { //// Populate digest map of stored procedures")) {
                        State = 1;
                    }
                    else {
                        if (line.contains("// Populate digest map of tables")) {
                            State = 2;
                        }
                        else {
                            if (line.contains("// Populate digest map of indexes")) {
                                State = 3;
                            }
                            else {
                                if (line.contains("// Populate digest map of foreign")) {
                                    State = 4;
                                }
                                else {
                                    //System.out.println("Regexing: " + line);
                                    String[] values = line.split(","); // Split by comma
                                    //System.out.println("Values: " + values[0] + values[1]);
                                    switch (State) {
                                        case -1:
                                            State = 0;
                                            break;
                                        case 1:
                                            spmap.put(values[0], values[1]);
                                            break;
                                        case 2:
                                            tbmap.put(values[0], values[1]);
                                            break;
                                        case 3:
                                            ixmap.put(values[0], values[1]);
                                            break;
                                        case 4:
                                            fkmap.put(values[0], values[1]);
                                            break;
                                        default:
                                            System.out.println("Invalid State:" + State + " Line: " + ii + " record: " + line);
                                            break;
                                    }
                                }
                            }
                        }
                    }
                    // read next line
                    ii = ii + 1;
			        line = reader.readLine();
			    }
                finalI = ii;
			    reader.close();
		    } catch (IOException e) {
			    e.printStackTrace();
                return;
		    }
        }

        // load db2 jdbc
        try {
            Class.forName("com.ibm.db2.jcc.DB2Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Error encountered loading DB2 SQLJ driver");
            //e.printStackTrace();
            return;
        }
        System.out.println("**** Loaded the JDBC driver");

        // Create the connection using the IBM Data Server Driver for JDBC and SQLJ and open output file[s]
        try {
            con = DriverManager.getConnection (url, user, password);
            con.setAutoCommit(false);
            System.out.println("**** Created a JDBC connection to the data source\n");

            String homepath = System.getenv("HOMEPATH");

            fwriter = new BufferedWriter(new FileWriter(homepath+"\\Schema_report.txt"));

            if (makeHash) {
                hwriter = new BufferedWriter(new FileWriter(homepath+"\\SchemaDigest.txt"));
            }

            if (makeDef) {
                dwriter[0] = new BufferedWriter(new FileWriter(homepath+"\\StoredProcedures.txt")); // stored procedures
                dwriter[1] = new BufferedWriter(new FileWriter(homepath+"\\Tabledata.txt")); // tables and columns
                dwriter[2] = new BufferedWriter(new FileWriter(homepath+"\\Indexdata.txt")); // indexes
                dwriter[3] = new BufferedWriter(new FileWriter(homepath+"\\Foreignkeydata.txt")); // foreign assets
            }

            // construct configuration object
            GvbSchemaConfig sc= new GvbSchemaConfig(digestType, con, schema_mask, makeHash, makeDef, fwriter, hwriter, dwriter, spmap, tbmap, ixmap, fkmap);

            // call stored procedure validation
            GvbSchemaValidateA mA = new GvbSchemaValidateA(sc);

            // call table column validation
            GvbSchemaValidateB mB = new GvbSchemaValidateB(sc);

            // call table column validation
            GvbSchemaValidateC mC = new GvbSchemaValidateC(sc);

            // call table column validation
            GvbSchemaValidateD mD = new GvbSchemaValidateD(sc);

            fwriter.close();

            if (makeHash) {
                hwriter.close();
            }

            if (makeDef) {
                dwriter[0].close();
                dwriter[1].close();
                dwriter[2].close();
                dwriter[3].close();
            }

            // Connection must be on a unit-of-work boundary to allow close
            con.commit();
            System.out.println ( "**** Transaction committed" );
      
            // Close the connection
            con.close();
            System.out.println("**** Disconnected from data source");

            System.out.println("**** JDBC completed - no DB2 errors");

        } catch (SQLException e) {
                System.out.println("SQLSTATE: " + e.getSQLState() + " creating database connection");
                //e.printStackTrace();
                return;

        } catch (IOException e) {
                System.out.println("IO exception encountered in GvbSchemaValidateMain");
                //e.printStackTrace();
                return;
        }
    }
}
