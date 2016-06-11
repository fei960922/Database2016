package acmdb;

import java.sql.*;

public class Connector {
	public Connection con;
	public Statement stmt;
	public Connector() throws Exception {
		try{
		 	String userName = "fei960922";					//"acmdbuser";
	   		String password = "fei960922public";			//"acmdb16";
	        String url = "jdbc:mysql://192.168.1.3/eation";	//"jdbc:mysql://georgia.eng.utah.edu/acmdb";
		    Class.forName ("com.mysql.jdbc.Driver").newInstance ();
		    con = DriverManager.getConnection (url, userName, password);
			//DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
        	//stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			stmt = con.createStatement();
        } catch(Exception e) {
        	try {
        		String userName = "fei960922";					//"acmdbuser";
    	   		String password = "fei960922public";			//"acmdb16";
    	        String url = "jdbc:mysql://h.fei22.cn/eation";	//"jdbc:mysql://georgia.eng.utah.edu/acmdb";
    		    Class.forName ("com.mysql.jdbc.Driver").newInstance ();
    		    con = DriverManager.getConnection (url, userName, password);
    			//DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
            	//stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    			stmt = con.createStatement();
        	} catch(Exception ee) {
        		System.err.println("Unable to open mysql jdbc connection. The error is as follows,\n");
        		System.err.println(e.getMessage());
        		throw(ee);
        	}
		}
	}

	public void closeStatement() throws Exception{
		stmt.close();
	}
	public void closeConnection() throws Exception{
		con.close();
	}
}
