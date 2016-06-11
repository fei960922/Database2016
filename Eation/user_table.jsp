<%@ page language="java" import="acmdb.*,java.sql.ResultSet" contentType="text/html;charset=utf-8" %>



<% if (session.getAttribute("login_name")==null) {
	response.sendRedirect("login.jsp?warn=1");
	} else {
%>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="User Table --- Eation"/>
</jsp:include>
<div class="container">
	<h1>User Tables</h1>
	<div class="panel panel-default">
	    <div class="panel-body">
	    	<div class="btn-group" role="group" aria-label="...">
			  <a href="./user_table.jsp" type="button" class="btn btn-default">All User</a>
			  <a href="./user_table.jsp?do=trust" type="button" class="btn btn-default">Sort by TRUSTED</a>
			  <a href="./user_table.jsp?do=useful" type="button" class="btn btn-default">Sort by USEFUL</a>
			</div>
        </div>
        <table class="table">
        	<thead><tr><th>Username</th><th>Full Name</th><th>Address</th><th>Telephone</th><th>Favourite POI</th><th>Trusted</th></tr></thead>
        	<tbody>
<%
	Order order = new Order();
	String username = session.getAttribute("login_name").toString();
	if (request.getParameter("trust")!=null) {
		int tru = 0;
		if (request.getParameter("trust").equals("1")) tru=1;
		if (request.getParameter("trust").equals("-1")) tru=-1;
		order.tag_trust(username, request.getParameter("name"), tru);
	}
	if (request.getParameter("do")!=null) {
		if (request.getParameter("do").equals("trust")) 
			out.println(order.getAllUser(1, username)); 
		if (request.getParameter("do").equals("useful"))
			out.println(order.getAllUser(2, username));
	} else
		out.println(order.getAllUser(0, username));
	
%>	
			</tbody>
		</table>
	</div>
	<h1>Two degrees of separation</h1>
	<div class="panel panel-default">
	    <div class="panel-body"><div class="row">
		    <form action="user_table.jsp" method="post" accept-charset="utf-8">
		    	<div class="col-md-4">
			    	<div class="input-group">
	                	<span class="input-group-addon" id="basic-addon1">Username1</span>
	                	<input type="text" class="form-control" name="Username1" placeholder="Username" aria-describedby="basic-addon1">
	              	</div>
		    	</div>
              	<div class="col-md-4">
	              <div class="input-group">
	                <span class="input-group-addon" id="basic-addon1">Username2</span>
	                <input type="text" class="form-control" name="Username2" placeholder="Username" aria-describedby="basic-addon2">
	              </div>
	            </div>
	            <div class="col-md-4">
              		<button class="btn btn-default" type="submit">Find their degree!</button>
              	</div>
            </form></div>
            <div class="row">
<%
	if (request.getParameter("Username1")!=null) {
		int degree = order.getDegree(request.getParameter("Username1"),request.getParameter("Username2"));
		if (degree == 2) {
%>
			<div class="col-sm-2 paddingadd"><h1>2</h1></div>
			<div class="col-sm-10 paddingadd">
				<br /><p>they are 2-degrees away if there exists an user 'C' who is 1-degree away (they have both favorited at least one common POI) from each of 'A' and 'B', AND 'A' and 'B' are not 1-degree away at the same time.</p>
			</div>
<%
		} else if (degree == 1) {
%>
			<div class="col-sm-2 paddingadd"><h1>1</h1></div>
			<div class="col-sm-10 paddingadd">
				<br /><p>Two users 'A' and 'B' are 1-degree away if they have both favorited at least one common POI.</p>
			</div>
<%
		} else if (degree == 0) {
%>
			<div class="col-sm-2 paddingadd"><h1>∞</h1></div>
			<div class="col-sm-10 paddingadd">
				<br /><p>The two users has no degree of 1 or 2, or the username is not existed.</p>
			</div>
<%			
		}
	}
%>
			</div>
        </div>
	</div>
</div>
<%@ include file="include/footer.jsp" %>

<% } %>
