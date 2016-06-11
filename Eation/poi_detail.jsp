<%@ page language="java" import="acmdb.*, java.sql.*" 
contentType="text/html;charset=utf-8" %>

<% if (session.getAttribute("login_name")==null) {
	response.sendRedirect("login.jsp?warn=1");
	} else {
%>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="POI Selection --- Eation"/>
</jsp:include>
<div class="container">
	<div class = "col-md-10"> 
		<h1>POI Detail</h1>
<%
	Order order = new Order();
	ResultSet results;
	if(request.getParameter("id") == null)
		out.println("no POI detail");
	else {
		String pid = request.getParameter("id").toString();
		String username = session.getAttribute("login_name").toString();
		Boolean edit = (request.getParameter("do")!=null && request.getParameter("do").equals("edit"));
		results = order.getPOI(pid);
		if(results == null)
			out.println("no such POI");
		else {
			results.next();
%>
		<div class="panel panel-default">
		    <div class="panel-body poi_panel">
		    	<div class="col-sm-4">
<% 
			if (results.getString("pic_url")==null || results.getString("pic_url").length()<1)
				out.print("<img src=\"http://fei960922.github.io/image/head.jpg\" />");
			else
				out.print("<img src=\""+results.getString("pic_url")+"\" />");
%>
				</div>
				<div class="col-sm-8"><div class="row">

<% 
			if (edit && session.getAttribute("admin")!=null){
%>
			    	<form action="poi_detail.jsp?id=<%=pid %>" method="post" accept-charset="utf-8">
				    <h2><%=results.getString("name") %></h2>
				    <div class = "form-group col-sm-6">
				    	<label for = "address"> Address </label>
				    	<input type = "text" class = "form-control" name = "address" value = <%=results.getString("address") %>>
				    </div>
					<div class = "form-group col-sm-6">
				    	<label for = "phone"> Phone </label>
				    	<input type = "text" class = "form-control" name = "phone" value = <%=results.getString("phone") %>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "url"> URL </label>
				    	<input type = "text" class = "form-control" name = "url" value = <%=results.getString("url")%>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "year_estab"> Establish Year </label>
				    	<input type = "text" class = "form-control" name = "year_estab" value = <%=results.getString("year_estab") %> >
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "hours_op"> Operation Hour </label>
				    	<input type = "text" class = "form-control" name = "hours_op" value = <%=results.getString("hours_op") %>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "price"> Price </label>
				    	<input type = "text" class = "form-control" name = "price" value = <%=results.getString("price") %>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "keywords"> Keywords </label>
				    	<input type = "text" class = "form-control" name = "keywords" value = <%=results.getString("keywords") %>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "category"> Category </label>
				    	<input type = "text" class = "form-control" name = "category" value = <%=results.getString("category") %>>
				    </div>
				    <div class = "form-group col-sm-9">
						<p>&nbsp;</p>
						<button class="btn btn-success" type="submit" align = "center" style="width:35%;margin:2%">Submit</button>
				        <button class="btn btn-default" onclick="refresh" align = "center" style="width:35%;margin:2%">Clear</button>
	              	</div>   
		        	</form>
<%		
			} else {
%>
				    <h2><%=results.getString("name") %></h2>
				    <div class = "col-sm-6">
				    	<label for = "address"> Address </label>
				    	<%=results.getString("address") %>
				    </div>
					<div class = "col-sm-6">
				    	<label for = "phone"> Phone </label>
				    	<%=results.getString("phone") %>
				    </div>
				    <div class = "col-sm-6">
				    	<label for = "url"> URL </label>
				    	<%=results.getString("url")%>
				    </div>
				    <div class = "col-sm-6">
				    	<label for = "year_estab"> Establish Year </label>
				    	<%=results.getString("year_estab") %>
				    </div>
				    <div class = "col-sm-6">
				    	<label for = "hours_op"> Operation Hour </label>
				    	<%=results.getString("hours_op") %>
				    </div>
				    <div class = "col-sm-6">
				    	<label for = "price"> Price </label>
				    	<%=results.getString("price") %>
				    </div>
				    <div class = "col-sm-6">
				    	<label for = "keywords"> Keywords </label>
				    	<%=results.getString("keywords") %>
				    </div>
				    <div class = "col-sm-6">
				    	<label for = "category"> Category </label>
				    	<%=results.getString("category") %>
				    </div>

<%
				if (session.getAttribute("admin")!=null) {
					out.println("<div class = \"col-sm-4\"><a href=\"poi_detail.jsp?id="+pid+"&do=edit\">Edit</a></div>");
					String POI_name = results.getString("name"); 
					System.out.println(pid);
					System.out.println(POI_name);
					if(request.getParameter("url")!= null){
						System.out.println("ahahahaha");
						String POI_addr = request.getParameter("address");
						String POI_url = request.getParameter("url");
						String POI_tele = request.getParameter("phone");
						String POI_estyear = request.getParameter("year_estab");
						String POI_ophour = request.getParameter("hours_op");
						String POI_price = request.getParameter("price");
						String POI_keyword = request.getParameter("keywords");
						String POI_category = request.getParameter("category");
						if (order.updatePOI(pid, POI_name, POI_addr, POI_url, POI_tele, POI_estyear, POI_ophour, POI_price, POI_keyword, POI_category)) 
							out.println("<div class=\"alert alert-success col-sm-8\" role=\"alert\" style=\"margin:0px;padding:5px;\">Update successfully!</div>");
						else 
							out.println("<div class=\"alert alert-danger col-sm-8\" role=\"alert\" style=\"margin:0px;padding:5px;\"><strong>Opps!</strong>Something wrong, try again!</div>");
		
					}
				}
			}
%> 
		        </div></div>
	        </div>
		</div>		
		<h1>My Visit</h1>
		<div class="panel panel-default">
			<table class = "table table-striped">
			<thead><tr>	
					<th> Date </th><th> Cost </th><th> Number Of Person </th>
			</tr></thead>
			<tbody>
<% 
			if(request.getParameter("no_person")!= null){
				if (order.insertVisit(username, pid, request.getParameter("dates"), request.getParameter("price"), request.getParameter("no_person")))
					out.println("<div class=\"alert alert-success\" role=\"alert\">Insert successfully! Refresh to see!</div>");
				else 
					out.println("<div class=\"alert alert-danger\" role=\"alert\" ><strong>Opps!</strong>Something wrong, try again!</div>");
			}
			results = order.getVisit(username, pid);
			boolean exist = false;
			while (results != null && results.next()) { 
				exist = true;
				out.println("<tr>"+"<td>"+results.getDate("dates")+"</td>"
		                      	+"<td>"+results.getString("cost")+"</td>"
		                      	+"<td>"+results.getString("no_person")+"</td></tr>");
			}
			if (!exist) out.println("<div class=\"alert alert-warning\" role=\"alert\" >No Feedbacks exists! Write the first one!</div>");
%>
			<form action="poi_detail.jsp?id=<%=pid %>" method="post" accept-charset="utf-8">
			<tr>
				<td><input type = "text" class = "form-control" name = "dates" placeholder = "yyyy-MM-dd"></td>
			    <td><input type = "text" class = "form-control" name = "price" placeholder = "price"></td>
			    <td><input type = "text" class = "form-control" name = "no_person" placeholder = "num of person"></td>
		    </tr>
		    <tr>
		    	<td></td><td></td>
				<td><button class="btn btn-success" type="submit" align = "center" style="width:35%;margin:2%">Submit</button></td>
			</tr>
			</form>
			</tbody>
			</table>
		</div>
	
		<h1>Feedbacks <small> ( Sorted by Usefulness )</small></h1>
		<div class="panel panel-default">
			<table class = "table table-striped">
			<thead><tr>	
					<th> Username </th><th> Date </th><th> Feedback </th><th> Score </th><th> My rate </th>
			</tr></thead>
			<tbody>
<% 
			
			if(request.getParameter("rate")!= null)
				order.rateOpinion(request.getParameter("op_id"), username, request.getParameter("rate"));
			if(request.getParameter("text")!= null){
				System.out.println("hahaha");
				if (order.insertOpinion(pid, username, request.getParameter("dates"), request.getParameter("score"), request.getParameter("text")))
					out.println("<div class=\"alert alert-success\" role=\"alert\">Insert successfully! Refresh to see!</div>");
				else 
					out.println("<div class=\"alert alert-danger\" role=\"alert\" ><strong>Opps!</strong>Something wrong, try again!</div>");
			}
			results = order.getOpinion(pid);
			exist = false;
			boolean my_opinion = false;
			while (results != null && results.next()) { 
				exist = true;
				String op_id = results.getString("op_id");
		        String rate = order.getRate(op_id, username);
		        String words="", classes="";
		        if (rate.equals("-1")) {classes = "btn-default"; words = "Untagged";}
		        else if (rate.equals("0")) {classes = "btn-danger"; words = "Useless";}
		        else if (rate.equals("1")) {classes = "btn-warning"; words = "Useful";}
		        else if (rate.equals("2")) {classes = "btn-success"; words = "Very Useful";}
%>
			<tr>
				<td><%=results.getString("log_name") %></td>
				<td><%=results.getString("date") %></td>
				<td><%=results.getString("Texts") %></td>
				<td><%=results.getString("score") %></td>
				<td>
<%
				if (!username.equals(results.getString("log_name"))) {
%>

				<div class="btn-group" role="group">
					<button class="btn <%=classes %> dropdown-toggle" data-toggle="dropdown"><%=words %></button>
					<ul class="dropdown-menu">
						<li><a href="poi_detail.jsp?id=<%=pid %>&rate=2&op_id=<%=op_id %>">Very Useful</a>
						<li><a href="poi_detail.jsp?id=<%=pid %>&rate=1&op_id=<%=op_id %>">Useful</a></li>
						<li><a href="poi_detail.jsp?id=<%=pid %>&rate=0&op_id=<%=op_id %>">Useless</a></li>
						<li><a href="poi_detail.jsp?id=<%=pid %>&rate=-1&op_id=<%=op_id %>">Untagged</a></li>
					</ul>
				</div>
				</td>
<%				} else my_opinion = true;
%>				
			</tr>
<%
			}
			if (!exist) out.println("<div class=\"alert alert-warning\" role=\"alert\" >No Feedbacks exists! Write the first one!</div>");
			if (!my_opinion) {
%>
			<form action="poi_detail.jsp?id=<%=pid %>" method="post" accept-charset="utf-8">
			<tr>
				<td>Provide Feedback:</td>
				<td><input type = "text" class = "form-control" name = "dates" placeholder = "yyyy-MM-dd"></td>
			    <td><input type = "text" class = "form-control" name = "text" placeholder = "Write down some words~"></td>
			    <td><input type = "text" class = "form-control" name = "score" placeholder = "0-10"></td>
			    <td><button class="btn btn-success" type="submit" align = "center">Submit</button></td>
		    </tr>
			</form>
	<%
			}
	%>
			</tbody>
			</table>
		</div>
		<br /><br /><br />
	</div>
	<div class = "col-md-2">
		<br /><br /><br />
		<h2>All POIs</h2>
<%
		} 
	} 
	results = order.getAllPOI(0, "", "", "", "", "", "", "", "");
	while (results!=null && results.next()) {
		out.println("<a href=\"poi_detail.jsp?id=" + results.getString("poi_id") + "\"><h4>"+ results.getString("name") +"</h4></a>");
	}
%>
	</div>

</div>
<% } %>
<%@ include file="include/footer.jsp" %>
