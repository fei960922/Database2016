<%@ page language="java" import="acmdb.*,java.sql.*" contentType="text/html;charset=utf-8" %>



<% if (session.getAttribute("login_name")==null) {
	response.sendRedirect("login.jsp?warn=1");
	} else {
		Order order = new Order();
		ResultSet results = null;
		String category = "Any";
		String mm = "10";
%>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="POI Selection --- Eation"/>
</jsp:include>
<div class="container">
		<h1>Statistics by Category</h1>
		<div class="panel panel-default">
		    <div class="panel-body">
			    <form action="poi_statistics.jsp" method="post" accept-charset="utf-8">
			    	<div class = "form-group col-sm-4">
					<p><label for = "category"> Category </label></p>
					<select class = "form-control" name="category">
						<option>Any</option>
						<%=order.getCategory() %>
					</select>
					</div>
					<div class="form-group col-sm-4">
					    <p><label for="name">Numbers of Solution</label></p>
					    <input type="text" class="form-control" name="mm" value="10">
					</div>
		            <div class="col-sm-4">
		            	<p>&nbsp;</p>
	              		<button class="btn btn-success" type="submit">Submit</button>
	              	</div>
	              </form>
	        </div>
		</div>
		<h1>Most Popular POIs</h1>
		<div class="panel panel-default">
		    <div class="panel-body">
			    List the top m most popular POIs (in terms of total visits) for each category
	        </div>
	        <ul class="list-group">

<%
	if (request.getParameter("category")!=null) {
		category = request.getParameter("category").toString();
		mm = request.getParameter("mm").toString();
	}
		results = order.getStatic_popular(category, mm);
	boolean empty = true;
	while (results!=null && results.next()) {
%>

	        <li class="list-group-item poi_panel">
				<div class="row">
					<div class="col-sm-3">
						<a href="poi_detail.jsp?id=<%=results.getString("poi_id")  %>">
						<% if (results.getString("pic_url")==null)
							out.print("<img src=\"http://fei960922.github.io/image/head.jpg\" />");
						else
							out.print("<img src=\""+results.getString("pic_url")+"\" />");
						%>
						</a>
					</div>
					<div class="col-sm-7">
						<h2><%=results.getString("name") %></h2>
						<h5><%=results.getString("address") %></h5>
						<h5><%=results.getString("phone") %> </h5>
						<%
							if (results.getString("keywords")!=null) {
								out.println("<p>Keywords:");
								String[] keywords = results.getString("keywords").split(",");
								for (String k : keywords) {
									out.println("<span class=\"label label-default\">"+k+"</span>");
								}
								out.println("</p>");
							}
							String[] temp = results.getString("cnt").split("\\.");
							String cnt = temp[0];
						%>
					</div>
					<div class="col-sm-2 big_number"><%=cnt %></div>
				</div>

			</li>
<%
	empty = false;
	}	
	if (empty) {
%>	
	<li class="list-group-item poi_panel">
		<div class="alert alert-warning" role="alert" >
			Opps, There is no POI suits your requirements! Change the category please.
		</div>
	</li>
	
<% } %>			
			</ul>
		</div>
		<h1>Most Expensive POIs</h1>
		<div class="panel panel-default">
		    <div class="panel-body">
			    the list of m most expensive POIs (by the average cost per head of all visits to a POI) for each
category
	        </div>
	        <ul class="list-group">

<%
	results = order.getStatic_cost(category, mm);
	empty = true;
	while (results!=null && results.next()) {
%>

	        <li class="list-group-item poi_panel">
				<div class="row">
					<div class="col-sm-3">
						<a href="poi_detail.jsp?id=<%=results.getString("poi_id")  %>">
						<% if (results.getString("pic_url")==null)
							out.print("<img src=\"http://fei960922.github.io/image/head.jpg\" />");
						else
							out.print("<img src=\""+results.getString("pic_url")+"\" />");
						%>
						</a>
					</div>
					<div class="col-sm-7">
						<h2><%=results.getString("name") %></h2>
						<h5><%=results.getString("address") %></h5>
						<h5><%=results.getString("phone") %> </h5>
						<%
							if (results.getString("keywords")!=null) {
								out.println("<p>Keywords:");
								String[] keywords = results.getString("keywords").split(",");
								for (String k : keywords) {
									out.println("<span class=\"label label-default\">"+k+"</span>");
								}
								out.println("</p>");
							}
							String[] temp = results.getString("cnt").split("\\.");
							String cnt = temp[0];
						%>
					</div>
					<div class="col-sm-2 big_number"><%=cnt %></div>
				</div>
			
			</li>
<%
	empty = false;
	}	
	if (empty) {
%>	
	<li class="list-group-item poi_panel">
		<div class="alert alert-warning" role="alert" >
			Opps, There is no POI suits your requirements! Change the category please.
		</div>
	</li>
	
<% } %>			
			</ul>
		</div>
		<h1>Highly Rated POIs</h1>
		<div class="panel panel-default">
		    <div class="panel-body">
			    List of m highly rated POIs (by the average scores from all feedbacks a POI has received)
	        </div>
	        <ul class="list-group">

<%
	results = order.getStatic_score(category, mm);
	empty = true;
	while (results!=null && results.next()) {
%>

	        <li class="list-group-item poi_panel">
				<div class="row">
					<div class="col-sm-3">
						<a href="poi_detail.jsp?id=<%=results.getString("poi_id")  %>">
						<% if (results.getString("pic_url")==null)
							out.print("<img src=\"http://fei960922.github.io/image/head.jpg\" />");
						else
							out.print("<img src=\""+results.getString("pic_url")+"\" />");
						%>
						</a>
					</div>
					<div class="col-sm-7">
						<h2><%=results.getString("name") %></h2>
						<h5><%=results.getString("address") %></h5>
						<h5><%=results.getString("phone") %> </h5>
						<%
							if (results.getString("keywords")!=null) {
								out.println("<p>Keywords:");
								String[] keywords = results.getString("keywords").split(",");
								for (String k : keywords) {
									out.println("<span class=\"label label-default\">"+k+"</span>");
								}
								out.println("</p>");
							}
							String[] temp = results.getString("cnt").split("\\.");
							String cnt = temp[0];
						%>
					</div>
					<div class="col-sm-2 big_number"><%=cnt %></div>
				</div>

			</li>
<%
	empty = false;
	}	
	if (empty) {
%>	
	<li class="list-group-item poi_panel">
		<div class="alert alert-warning" role="alert" >
			Opps, There is no POI suits your requirements! Change the category please.
		</div>
	</li>
	
<% } %>			
			</ul>
		</div>
</div>
<%@ include file="include/footer.jsp" %>

<% } %>
