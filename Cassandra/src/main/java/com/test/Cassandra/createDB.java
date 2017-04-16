package com.test.Cassandra;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Scanner;
import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.ConsistencyLevel;
import com.datastax.driver.core.QueryOptions;
import com.datastax.driver.core.Session;
import com.datastax.driver.core.policies.DCAwareRoundRobinPolicy;
import com.datastax.driver.core.policies.RoundRobinPolicy;

public class createDB extends TextGenerator {

	private static String username;
	private static String email;
	private static String fullname;
	private static String password;
	private static String accountNumber;
	
	public createDB() {
		
		super();
		
	}

	//Creates a table in the specified keyspace
	public static String createTable(String keyspaceName, String tableName) {
		
		return "CREATE TABLE " + keyspaceName + "." + tableName + " ("
				+ "username text PRIMARY KEY," 
				+ " email text," 
				+ " fullname text," 
				+ " password text," 
				+ " accountNumber text);";
		
	}
	
	//Helper method to make the insert operation easier to handle
	public static String insertInto(String keyspaceName, String tableName) {
		
		return "INSERT INTO " + keyspaceName + "." + tableName + "(username, email, fullname, password, accountNumber)"
				+ " VALUES ";
		
	}

	public static void main(String[] args) {

		Cluster cluster = null;
		Scanner in = new Scanner(System.in);
				
		try { 
			
			//Change the value in createFile to whichever value
			//the teseter needs to test.
			TextGenerator.createFile(3);
			
			//Builds Cassandra cluster and adds the home IP address 
			//to it's destination.
			cluster = Cluster.builder().addContactPoints("34.210.6.214", "34.209.186.150", "54.84.11.178", "34.207.223.229").withPort(9042).withQueryOptions(new QueryOptions() 
					.setConsistencyLevel(ConsistencyLevel.LOCAL_QUORUM)).build();
			
			//Begins new session and connects cluster to the demo 
			//keyspace, and then uses it.
			Session session = cluster.connect("cassandrabankapp");
			session.execute("USE cassandrabankapp");
			
			//Executes the createTable method to create the sample 
			//table.
			session.execute(createTable("cassandrabankapp", "member"));

			//Creates file and reader to read in users.txt context
			File file = new File("users.txt");
			BufferedReader reader = new BufferedReader(new FileReader(file));
			
			//Represents one line of input read from file.
			String line;
			
			//Loops to insert each line of users.txt into users table, and times
			//the execution in milliseconds (for testing purposes).
			final long startInsertTime = System.currentTimeMillis();
			
			while((line = reader.readLine()) != null) {
				
				String[]parts = line.split(",", 5);
				
				if (parts.length == 5) {
					
					username = parts[0];						
					email = parts[1];						
					fullname = parts[2];						
					password = parts[3];					
					accountNumber = parts[4];
					
					session.execute(insertInto("cassandrabankapp", "member") +
							"('"+username+"','"+email+"','"+fullname+"','"+password+"','"+accountNumber+"');");
					
				} else {
					
					System.out.println("Ignoring line " + line);
					
				}
					
			}
			
			final long endInsertTime = System.currentTimeMillis();

			reader.close();
		
			//Displays the time taken by the database insert
			System.out.println("\nExecution time for database insert (in milliseconds): "
					+ (endInsertTime - startInsertTime));
			
				session.close();
				
		}

		catch(Exception e) {
			
			System.out.println("Something went wrong.");
			e.printStackTrace(System.out);
			
		} 
		
		finally {
			
			if(cluster != null) {
				
				cluster.close();
				in.close();
				
			}
			
		}
		
	}
	
}
