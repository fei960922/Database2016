<%@ page language="java" import="acmdb.*,java.sql.*" contentType="text/html;charset=utf-8" %>



<% if (session.getAttribute("login_name")==null) {
	response.sendRedirect("login.jsp?warn=1");
	} else {
		Order order = new Order();
		String username = session.getAttribute("login_name").toString();
		if (request.getParameter("fav")!=null)
			order.changeFavourite(username, request.getParameter("poi"), request.getParameter("fav"));
%>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="POI Selection --- Eation"/>
</jsp:include>
<div class="container">

<div class="panel panel-default">
	    <div class="panel-body">
	    <div class="row">
		    <form action="poi_table.jsp" method = 'post' accept-charset="utf-8">
				<div class="form-group col-sm-4">
				    <label for="name">POI Name</label>
				    <input type="text" class="form-control" name="name" placeholder="Name">
				</div>
				<div class="form-group col-sm-4">
				    <label for="name">Address</label>
				    <input type="text" class="form-control" name="address" placeholder="Address">
				</div>
				<div class="form-group col-sm-4">
				    <label for="name">Keyword</label>
				    <input type="text" class="form-control" name="keyword" placeholder="Keyword">
				</div>
				<div class = "form-group col-sm-4">
				<p><label for = "price"> Price/Person </label></p>
					<input type="text" class="form-control" name="price_l" placeholder="price_l" style="width:35%;display:inline;">
					&nbsp;&nbsp;~&nbsp;&nbsp;
					<input type="text" class="form-control" name="price_h" placeholder="price_h" style="width:35%;display:inline;">					
				</div>
				<div class = "form-group col-sm-4">
				<p><label for = "category"> Category </label></p>
				<select class = "form-control" name="category">
					<option>Any</option>
					<%=order.getCategory() %>
				</select>
				</div>
				<div class = "form-group col-sm-4">
					<p>&nbsp;</p>
					<button class="btn btn-success" type="submit" align = "center" style="width:35%;margin:2%">Search</button>
			        <button class="btn btn-default" onclick="refresh" align = "center" style="width:35%;margin:2%">Clear</button>
			    </div>
				<div class="col-sm-12">
					<br />
			    	Sorted by:&nbsp;&nbsp; 
			    	<div class="btn-group" role="group" aria-label="...">
					  <a href="./poi_table.jsp" type="button" class="btn btn-default">None</a>
					  <a href="./poi_table.jsp?sort=1" type="button" class="btn btn-default">Price</a>
					  <a href="./poi_table.jsp?sort=2" type="button" class="btn btn-default">Average Score</a>
					  <a href="./poi_table.jsp?sort=3" type="button" class="btn btn-default">Score by Trust User</a>
					</div>
		        </div>

			</form>
		
	    </div>

	    </div>
        <ul class="list-group">
<%

	String address="", name="", keyword="", category="", price_l = "", price_h = "", sort="";
	boolean empty = true;
	int status = 0;
	if (request.getParameter("name")!=null) name = request.getParameter("name");
	if (request.getParameter("address")!=null) address = request.getParameter("address");
	if (request.getParameter("keyword")!=null) keyword = request.getParameter("keyword");
	if (request.getParameter("category")!=null) category = request.getParameter("category");
	if (request.getParameter("price_l")!=null) price_l = request.getParameter("price_l");
	if (request.getParameter("price_h")!=null) price_h = request.getParameter("price_h");
	if (request.getParameter("sort")!=null) sort = request.getParameter("sort");

	ResultSet results = order.getAllPOI(status ,price_l, price_h, address, name, keyword, category, sort, username);
	
	while (results!=null && results.next()) {
%>
	<li class="list-group-item poi_panel">
		<div class="row">
			<div class="col-sm-3">
				<a href="poi_detail.jsp?id=<%=results.getString("poi_id")%>">
				<% if (results.getString("pic_url")==null)
					out.print("<img src=\"http://fei960922.github.io/image/head.jpg\" />");
				else
					out.print("<img src=\""+results.getString("pic_url")+"\" />");
				%>
				</a>
			</div>
			<div class="col-sm-9">
					<div class="col-sm-1 panel_favourite">
				<% 
				String id = results.getString("poi_id");
				if (order.isFavourite(username, id)) 
					out.println("<a href=\"./poi_table.jsp?fav=no&poi="+id+"\">★</a>");
				else
					out.println("<a href=\"./poi_table.jsp?fav=fav&poi="+id+"\">☆</a>");
				if (order.isVisit(username, id)) 
					out.println("<p></p><img src=\"images/visit.png\" />Visited");
				%>
					</div>
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
				%>
			</div>
		</div>

	</li>
<%	
		empty = false;
	}	
	if (empty) {
%>	
	<li class="list-group-item poi_panel">
		<h1>Opps, There is no POI suits your requirements!</h1>
	</li>
	
<% } %>
		</ul>
	</div>

	

</div>
<%@ include file="include/footer.jsp" %>

<% } %>
