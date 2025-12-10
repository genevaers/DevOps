// https://www.ibm.com/docs/en/db2-for-zos/12.0.0?topic=samples-example-simple-jdbc-application

// VALIDATE STORED PROCEDURES

package org.genevaers.db2check;

import java.io.BufferedWriter;
import java.io.IOException;
import java.util.HashMap;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import java.sql.*;

public class GvbSchemaValidateA {

    private Integer rc;

    public GvbSchemaValidateA(GvbSchemaConfig sc)
    {
        Boolean match = true;

        BufferedWriter hwriter = sc.getHwriter(); // For writing digest values of hashmaps
        BufferedWriter[] dwriter = new BufferedWriter[4]; // For writing Schema definitions
        dwriter = sc.getDwriter();
        String digestType = sc.getDigestType();
        Connection con = sc.getCon();
        String schema_mask = sc.getSchemaMask();
        Boolean makeHash = sc.getMakeHash();
        Boolean makeDef = sc.getMakeDef();
        HashMap<String, String> spmap = sc.getSpmap();

        String schema;
        String nname;
        String vversion;
        String ttext;
        Statement stmt;
        ResultSet rs;

        System.out.println ("**** GvbSchemaValidateA: checking stored procedures for schema: " + schema_mask);

        String SQLstmt = "SELECT SCHEMA, NAME, VERSION, TEXT FROM SYSIBM.SYSROUTINES WHERE SCHEMA LIKE '"+schema_mask+"' ORDER BY SCHEMA, NAME";

        try {
            // Print generated digest value to separate file if requested -A
            if ( makeHash ) {
                hwriter.write("        // HashMap<String, String> spmap = new HashMap<>(30);\n");
                hwriter.write("        // Populate digest map of stored procedures using " + digestType +"\n");
            } 

            // Create the SQL statement
            stmt = con.createStatement();
            System.out.println("**** Created JDBC Statement object");

            // Execute a query and generate a ResultSet instance
            rs = stmt.executeQuery(SQLstmt);
            System.out.println("**** Created JDBC ResultSet object");

            MessageDigest md = MessageDigest.getInstance(digestType);
            while (rs.next()) {
                schema = rs.getString(1);
                nname = rs.getString(2);
                vversion = rs.getString(3);
                ttext = rs.getString(4);
                
                byte[] hashedBytes = md.digest(ttext.getBytes());
                String encodedHash = Base64.getEncoder().encodeToString(hashedBytes);

                if (makeHash) {
                    hwriter.write(nname+ "," + encodedHash);  //populate digest hash map
                    hwriter.write("\n");
                }
                else
                {
                    // report on schema correctness
                    System.out.println(schema + " " + nname + " " + vversion ); // + "\n " + ttext);
                    System.out.println(digestType + ": " + encodedHash);
                }

                // Print all of the definition data to separate file dwriter if requested -D
                if (makeDef) {
                    dwriter[0].write(schema+":"+nname+"============================================\n");
                    dwriter[0].write(ttext);
                    dwriter[0].write("\n");
                }

                if (makeHash) {
                    // Do nothing
                }
                else {
                    // Report on correctness of schema definitions
                    String hashvalue = spmap.get(nname);
                    if ( hashvalue == null) {
                        System.out.println("HASH value mismatch for stored procedure: " + nname);
                        System.out.println("No stored hash value");
                        System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                        match = false;
                    }
                    else
                    {
                        if ( hashvalue.equals(encodedHash)) {
                            System.out.println("HASH value matches for stored procedure: " + nname);
                        }
                        else
                        {
                            System.out.println("HASH value mismatch for stored procedure: " + nname);
                            System.out.println("Stored hash value: " + hashvalue);
                            System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                            match = false;
                        }
                    }
                }
            }
            System.out.println("**** Fetched all rows from JDBC ResultSet");

            // Close the ResultSet
            rs.close();
            System.out.println("**** Closed JDBC ResultSet");
      
            // Close the Statement
            stmt.close();
            System.out.println("**** Closed JDBC Statement");

        } catch (SQLException e) {
            System.out.println("SQLSTATE: " + e.getSQLState() + " executing: " + SQLstmt);
            //e.printStackTrace();
            rc = 4;
            return;
        } catch (IOException e) {
            System.out.println("IO exception encountered in GvbSchemaValidateA");
            //e.printStackTrace();
            rc = 8;
            return;
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Digest algorithm: " + digestType + " not available");
            //e.printStackTrace();
            rc = 12;
            return;
        }

        if (makeHash) {
            System.out.println("\nStored procedure digest hashmap created\n");
            rc = 2;
            return;
        } else {
            if ( match )
            {
                System.out.println("\nAll stored procedure definitions match.\n");
                rc = 0;
                return;
            }
            else
            {
                System.out.println("\nOne or more stored procedures do not match expected definitions !!!\n");
                rc = 1;
                return;
            }
        }
    }

    public Integer getRc() {return rc;}

}