package acmdb;

import acmdb.Connector;
import java.sql.*;
import java.text.*;
import java.util.Date;
//import javax.servlet.http.*;

public class Order{
	private Statement stmt; 
	private Statement stmt2;
	public Order() throws Exception {
		Connector c = new Connector();
		Connector c2 = new Connector();
		stmt = c.stmt;
		stmt2 = c2.stmt;
	}
	// Function 0 Inherit from example
	public String getOrders(String attrName, String attrValue) throws Exception{
		String query;
		String resultstr="";
		ResultSet results; 
		query="Select * from orders where "+attrName+"='"+attrValue+"'";
		try{
			results = stmt.executeQuery(query);
        } catch(Exception e) {
			System.err.println("Unable to execute query:"+query+"\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		System.out.println("Order:getOrders query="+query+"\n");
		while (results.next()){
			resultstr += "<b>"+results.getString("login")+"</b> purchased "+results.getInt("quantity") +
							" copies of &nbsp'<i>"+results.getString("title")+"'</i><BR>\n";	
		}
		return resultstr;
	}
	// Function 1 Registration
	public boolean check_login(String username, String password) throws Exception{
		ResultSet results = stmt.executeQuery("Select count(*) AS cnt from person where log_name='"+username+"' AND password='"+password+"'");
		results.next();
		return (results.getInt("cnt")==1);
	}
	public boolean register(String username, String password) throws Exception{
		try{
			stmt.executeUpdate("insert into person (log_name, password) values ('"+username+"', '"+password+"')");
			return true;
        } catch(Exception e) {return false;}
	}
	public boolean isadmin(String username) throws Exception {
		ResultSet results = stmt.executeQuery("Select isadmin from person WHERE log_name='"+username+"'");
		results.next();
		return (results.getInt("isadmin")==1);
	}
	public boolean updateUser(String username, String full_name, String address, String phone, String password, String pic_url) throws Exception {
		if (pic_url.equals("null")) pic_url = "";
		String query = "update person set full_name = '" + full_name + "', address = '" + address + "', phone = " + phone;
		query += ", password = '" + password + "', pic_url = '" + pic_url + "' WHERE log_name = '" + username + "'";
		try{
			System.out.println(query);
			stmt2.executeUpdate(query);
			return true;
		} catch(Exception e) {
			System.out.println(query);
			System.out.println(e);
			return false;
		}
	}
	// Function 2 Visit
	public ResultSet getVisit(String username, String pid) throws Exception {
		String query = "";
		ResultSet result;
		query = "select * from visited where log_name = '"+username+"' and  poi_id = '"+pid+"'";
		try{
			result = stmt.executeQuery(query);
			System.out.println(query);
			return result;
		} catch(Exception e) {
			System.out.println(query);
			System.out.println("getVisit Fail");
			System.out.println(e);
			return null;
		}
	}
	public boolean insertVisit(String username, String pid, String date, String cost, String personnum) throws Exception {
		String query = "";
		try{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date VIS_date = formatter.parse(date);
			query = "insert into visited values ('"+personnum+"', '"+cost+"', '"+date+"', '"+username+"', '"+pid+"')";
			System.out.println(query);
			stmt.executeUpdate(query);
			System.out.println("insert succ");
		} catch (Exception e) {
			System.out.println(query);
			System.out.println("updateVisit fail");
			System.out.println(e);
			return false;
		}
		return true;
	} 
	public boolean isVisit(String username, String poi_id) throws Exception {
		ResultSet results = stmt2.executeQuery("Select count(*) as cnt from visited WHERE log_name='"+username+"' and poi_id="+poi_id);
		results.next();
		int cnt = results.getInt("cnt");
		return (cnt>0);
	}
	// Function 3 New POI
	public boolean insertPOI(String POIPrice, String POIAddr, String POIName, String POICatagory) throws Exception{
		ResultSet results = stmt.executeQuery("Select max(poi_id) as cnt from poi");
		results.next(); 
		String pid = Integer.toString(results.getInt("cnt")+1);
		String query = "insert into poi (poi_id, price, address, name, category) values ('"+pid+"','"+POIPrice+"', '"+POIAddr+"', '"+POIName+"', '"+POICatagory+"')";
		System.out.println(query);	
		try{
			stmt.executeUpdate(query);
			return true;
        } catch(Exception e) {
        	System.out.println(e);
			return false;
		}
	}
	// Function 4 Update POI
	public boolean updatePOI(String pid, String name, String address, String url, 
							String tele, String estyear, String opHour, String price, 
							String keyword, String category) throws Exception {
		String query1 = "", query2 = "", query = "";
		query = "update poi set name =  '"+name+"', address = '"+address+"', url = '"+url+"', phone = "+tele+", year_estab = "+estyear+",hours_op = "+opHour+", price = "+price+", keywords = '"+keyword+"', category = '"+category+"' where poi_id = '"+pid+"' ";
		try{
			System.out.println(query);
			stmt.executeUpdate(query);
        } catch(Exception e) {
        	System.out.println(query);
			System.out.println(e);
			return false;
		}
		return true;
	}
	// Function 5 Favorite Recording
	public boolean isFavourite(String username, String poi_id) throws Exception {
		ResultSet results = stmt2.executeQuery("Select count(*) as cnt from favourite WHERE log_name='"+username+"' and poi_id="+poi_id);
		results.next();
		int cnt = results.getInt("cnt");
		return (cnt>0);
	}
	public boolean changeFavourite(String username, String poi_id, String status) throws Exception {
		String query = "";
		if (status.equals("fav")) 
			query = "insert into favourite values ('"+username+"', "+poi_id+")";
		else 
			query = "delete from favourite where log_name='"+username+"' AND poi_id="+poi_id;
		try{
			stmt.executeUpdate(query);
			return true;
        } catch(Exception e) {
        	System.out.println(e);
			return false;
		}
	}
	// Function 6 Feedbacks Recording
	public boolean insertOpinion(String pid, String username, String date, String score, String text) throws Exception {
		try{
			ResultSet results = stmt2.executeQuery("Select max(op_id) as cnt from opinion");
			results.next(); 
			String id = Integer.toString(results.getInt("cnt")+1);
			String query = "insert into opinion values ('"+id+"','"+text+"', '"+score+"', '"+username+"', '"+pid+"', '"+date+"')";
			System.out.println(query);	
			stmt.executeUpdate("insert into opinion_rate values (1, 'sssss_admin', "+id+")");
			stmt.executeUpdate(query);
			return true;
        } catch(Exception e) {
        	System.out.println(e);
			return false;
		}
	}
	// Function 7 Rating feedbacks
	public boolean rateOpinion(String op_id, String username, String score) throws Exception {
		try{
			stmt2.executeUpdate("delete from opinion_rate where log_name='"+username+"' AND op_id='"+op_id+"'");
			if (!score.equals("-1"))
				stmt2.executeUpdate("insert into opinion_rate values ("+score+", '"+username+"', '"+op_id+"')");
			return true;
        } catch(Exception e) {
        	System.out.println(e);
			return false;
		}
	}
	public String getRate(String op_id, String username) throws Exception {
		ResultSet res = stmt2.executeQuery("Select value from opinion_rate where log_name='" + username + "' and op_id=" + op_id);
		if (res.next()) return res.getString("value");
		else return "-1";
	}
	// Function 8 Trust recordings
	public boolean tag_trust(String username, String to_tag, int status) throws Exception {
		try{
			stmt.executeUpdate("delete from trust where log_name='"+username+"' AND log_2='"+to_tag+"'");
			if (status==1)
				stmt.executeUpdate("insert into trust values ('1', '"+username+"', '"+to_tag+"')");
			else if (status==-1)
				stmt.executeUpdate("insert into trust values ('-1', '"+username+"', '"+to_tag+"')");
			return true;
        } catch(Exception e) {
        	System.out.println(e);
			return false;
		}
	}
	// Function 9 POI Browsing
	public ResultSet getPOI(String id) throws Exception {
		try {
			return (stmt.executeQuery("Select * from poi where poi_id='" + id + "'"));
		} catch(Exception e) {
			return null;
		}
	}
	public ResultSet getAllPOI(int status, String price_l, String price_h, String address, 
		String name, String keyword, String category, String sort, String username) throws Exception {
		// sort == 1 (a) by price
		// sort == 2 (b) by the average numerical score of the feedbacks
		// sort == 3 (c) by the average numerical score of the trusted user feedbacks.
		
		ResultSet results;
		String query = "Select * from poi where poi_id>-1";
		if (sort.equals("2")) 
			query = "Select * from poi P, (SELECT poi_id, avg(score) as scc FROM opinion GROUP BY poi_id) T where P.poi_id=T.poi_id";
		if (sort.equals("3")) 
			query = "Select * from poi P, (SELECT poi_id, avg(score) as scc FROM opinion O, trust R WHERE (O.log_name=R.log_2 OR O.log_name='" +username+ "') AND R.log_name='" +username+ "' AND R.value=1 GROUP BY poi_id) T where P.poi_id=T.poi_id";
		if (address.length()>0)
			query += " and address like '%" + address + "%'";
		if (keyword.length()>0)
			query += " and keywords like '%" + keyword + "%'";
		if (name.length()>0)			
			query += " and name like '%" + name + "%'";
		if (category.length()>0 && !category.equals("Any"))
			query += " and category= '" + category + "'";
		if (price_h.length() > 0)
			query += " and price<" + price_h;
		if (price_l.length() > 0)
			query += " and price> " + price_l;
		if (sort.equals("1"))
			query += " order by price DESC";	
		else if (sort.equals("2") || sort.equals("3"))
			query += " order by scc DESC";	
		try {
			System.out.println(query);
			results = stmt.executeQuery(query);
			return results;
		} catch(Exception e) {
			System.out.println(query);
			System.out.println(e);
			return null;
		}
	}
	public String getCategory() throws Exception {
		ResultSet results = stmt.executeQuery("Select distinct category from poi");
		String result = "";
		while (results.next())
			result += "<option>" + results.getString("category") + "</option>";
		return result;
	}
	// Function 10 Feedbacks
	public ResultSet getOpinion(String pid) throws Exception {
		String query;
		ResultSet result;
		query = "SELECT O.*, avg(R.value) as cnt FROM opinion O LEFT JOIN opinion_rate R ON R.op_id=O.op_id WHERE poi_id="+pid+" GROUP BY O.op_id ORDER BY cnt DESC";
		try{
			result = stmt.executeQuery(query);
			System.out.println(query);
			return result;
		} catch(Exception e){
			System.out.println(query);
			System.out.println("getOpinion fail");
			System.out.println(e);
			return null;
		}
	}
	// Function 11 POI Suggestion 
	public ResultSet suggestPOI(String username) throws Exception {
		return stmt.executeQuery("SELECT P.*, count(*) as cnt FROM poi P, visited V WHERE P.poi_id=V.poi_id AND V.log_name!='"+username+"' AND V.log_name IN (SELECT log_name FROM visited WHERE poi_id IN (SELECT poi_id FROM visited WHERE log_name='"+username+"')) GROUP BY V.poi_id ORDER BY cnt DESC");
	}
	// Function 12 Degree
	public int getDegree(String username1, String username2) throws Exception {
		try {
			ResultSet results = stmt.executeQuery("SELECT count(*) as cnt FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='"+username1+"' AND B.log_name='"+username2+"'");
			results.next();
			if (results.getInt("cnt")>0) return 1;
			results = stmt.executeQuery("SELECT count(*) as cnt FROM (SELECT distinct B.log_name FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='"+username2+"') C, (SELECT distinct B.log_name FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='"+username2+"') D WHERE C.log_name=D.log_name");
			results.next();
			if (results.getInt("cnt")>0) return 2;
		} catch(Exception e) {}
		return 0;
	}
	// Function 13 POI Statistics
	public ResultSet getStatic_popular(String category, String m) throws Exception {
		ResultSet results;
		if (m.length()==0) m = "5";
		if (category.equals("Any")) category = "";
		else category =  " and category='"+category+"'";
		String query = "Select P.*, count(*) as cnt from poi P, visited V where P.poi_id=V.poi_id"+category+" group by P.poi_id order by cnt DESC limit 0,"+m;
		try {
			System.out.println(query);
			results = stmt.executeQuery(query);
			return results;
		} catch(Exception e) {
			System.out.println(query);
			System.out.println(e);
			return null;
		}
	}
	public ResultSet getStatic_cost(String category, String m) throws Exception {
		ResultSet results;
		if (m.length()==0) m = "5"; // not ready
		if (category.equals("Any")) category = "";
		else category =  " and category='"+category+"'";
		String query = "Select P.*, avg(O.cost) as cnt from poi P, visited O where P.poi_id=O.poi_id"+category+" group by O.poi_id order by cnt DESC limit 0,"+m;
		try {
			System.out.println(query);
			results = stmt.executeQuery(query);
			return results;
		} catch(Exception e) {
			System.out.println(query);
			System.out.println(e);
			return null;
		}
	}
	public ResultSet getStatic_score(String category, String m) throws Exception {
		ResultSet results;
		if (m.length()==0) m = "5";
		if (category.equals("Any")) category = "";
		else category =  " and category='"+category+"'";
		String query = "Select P.*, avg(O.score) as cnt from poi P, opinion O where P.poi_id=O.poi_id"+category+" group by O.poi_id order by cnt DESC limit 0,"+m;
		try {
			System.out.println(query);
			results = stmt.executeQuery(query);
			return results;
		} catch(Exception e) {
			System.out.println(query);
			System.out.println(e);
			return null;
		}
	}
	// Function 14 User Awards
	public ResultSet getUser(String username) throws Exception {
		return stmt.executeQuery("Select * from person where log_name='" + username + "'");
	}
	public String getAllUser(int sort, String username) throws Exception {
		String query = "";
		String result="";
		ResultSet results; 
		if (sort==0)
			query = "Select * from person";
		else if (sort==1)
			query = "select * from (select log_2, sum(value) as cnt from trust group by log_2) T, person P where T.log_2=P.log_name order by cnt DESC";
		else if (sort==2)
			query = "select * from (select log_name, avg(value) as cnt from opinion_rate group by log_name) T, person P where T.log_name=P.log_name order by cnt DESC";
		try{
			results = stmt.executeQuery(query);
        } catch(Exception e) {
			System.err.println("Unable to execute query:"+query+"\n");
	                System.err.println(e.getMessage());
			throw(e);
		}
		System.out.println("getUser query="+query+"\n");
		while (results.next()){
			result += "<tr><td>";
			if (results.getInt("isadmin")==1)
				result += "��";
			result += 			 results.getString("log_name")
					+"</td><td>"+results.getString("full_name")
					+"</td><td>"+results.getString("address")
					+"</td><td>"+results.getBigDecimal("phone")
					+"</td>";
			String to_tag = results.getString("log_name");
			if (sort==1) {
				result += "<td>"+results.getInt("cnt")+"</td></tr>";
				continue;
			} else if (sort==2) {
				result += "<td>"+results.getDouble("cnt")+"</td></tr>";
				continue;
			}
			if (username.equals(to_tag)) {
				result += "<td>Myself</td></tr>";
				continue;
			}
			ResultSet result_trust = stmt2.executeQuery(
			"select value from trust where log_name='"+username+"' AND log_2='"+to_tag+"'");
			result +="<td><div class=\"btn-group\" role=\"group\">";
			if (result_trust.next()) 
				if (result_trust.getInt("value")==1)
					result += "<button class=\"btn btn-success dropdown-toggle\" data-toggle=\"dropdown\">Trusted</button>";
				else
					result += "<button class=\"btn btn-danger dropdown-toggle\" data-toggle=\"dropdown\">Untrusted</button>";
			else
				result += "<button class=\"btn btn-default dropdown-toggle\" data-toggle=\"dropdown\">Untagged</button>";
			result += "<ul class=\"dropdown-menu\">";
			result += "<li><a href=\"user_table.jsp?trust=1&name="+to_tag+"\">Trust him</a></li><li><a href=\"user_table.jsp?trust=-1&name="+to_tag+"\">Untrust him</a></li><li><a href=\"user_table.jsp?trust=0&name="+to_tag+"\">Untagged</a></li></ul>";
			result += "</div></td></tr>";
		}
		return result;
	}	
}
