<%@ page language="java" import="acmdb.*,java.sql.*" contentType="text/html;charset=utf-8" %>



<% if (session.getAttribute("login_name")==null) {
	response.sendRedirect("login.jsp?warn=1");
	} else {
		Order order = new Order();
		String username = session.getAttribute("login_name").toString();
		ResultSet results = order.getUser(username);
		results.next();
		Boolean edit = (request.getParameter("do")!=null && request.getParameter("do").equals("edit"));
		String full_name = results.getString("full_name");
		String address = results.getString("address");
		String phone = results.getString("phone");
		String pic_url = results.getString("pic_url");
		if (request.getParameter("full_name")!=null) {
			full_name = request.getParameter("full_name").toString();
			address = request.getParameter("address").toString();
			phone = request.getParameter("phone").toString();
			pic_url = request.getParameter("pic_url").toString();
			String password = request.getParameter("password").toString();
			if (order.updateUser(username, full_name, address, phone, password, pic_url))
					out.println("<div class=\"alert alert-success\" role=\"alert\">User profile changed successfully!</div>");
			else 
					out.println("<div class=\"alert alert-danger\" role=\"alert\"><strong>Opps!</strong>Something wrong, try again!</div>");
		}

%>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="User Center --- Eation"/>
</jsp:include>
<div class="container">
	<h1>User Information</h1>
	<div class="panel panel-default">
	    <div class="panel-body poi_panel">
		    <form action="user_center.jsp" method="post" accept-charset="utf-8">
			    <div class="col-sm-4">
					<% if (results.getString("pic_url")==null || results.getString("pic_url").length()<1)
						out.print("<img src=\"http://fei960922.github.io/image/head.jpg\" />");
					else
						out.print("<img src=\""+results.getString("pic_url")+"\" />");
					%>
				</div>
				<div class="col-sm-8"><div class="row">
					<% if (edit) { %>
					<div class="col-sm-6">
						<input type = "text" class = "form-control" name = "full_name" value = <%=full_name %>>
					</div>
					<div class="col-sm-6">
						<input type = "password" class = "form-control" name = "password" value = <%=results.getString("password") %>>
					</div>
					<div class = "form-group col-sm-6">
				    	<label for = "phone"> address </label>
				    	<input type = "text" class = "form-control" name = "address" value = <%=address %>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "phone"> Phone </label>
				    	<input type = "text" class = "form-control" name = "phone" value = <%=phone %>>
				    </div>
				    <div class = "form-group col-sm-6">
				    	<label for = "phone"> pic_url </label>
				    	<input type = "text" class = "form-control" name = "pic_url" value = <%=pic_url %>>
				    </div>
				    <div class = "form-group col-sm-6">
						<p>&nbsp;</p>
						<button class="btn btn-success" type="submit" align = "center" style="width:35%;margin:2%">Submit</button>
				        <button class="btn btn-default" onclick="refresh" align = "center" style="width:35%;margin:2%">Clear</button>
	              	</div>   
					<% } else { %>
					<div class = "form-group col-sm-11">
						<h2><%=full_name %></h2>
						<div class = "form-group col-sm-6">
					    	<label for = "phone"> address </label>
					    	<p><%=address %></p>
					    </div>
					    <div class = "form-group col-sm-6">
					    	<label for = "phone"> Phone </label>
					    	<p><%=phone %></p>
					    </div>
					</div>
					<div class = "form-group col-sm-1">
						<a href="user_center.jsp?do=edit">Edit</a>
					</div>
					<% } %>
			    	</div>
	            </div>
        	</form>
        </div>
	</div>
	<h1>Visiting Suggestions</h1>
	<div class="panel panel-default">
		 <div class="panel-body">
		 <p>The visiting suggestion is based on your visits. If you have visited 'a', POI 'B' is suggested, if there exist a user 'X' that visited both 'A' and 'B'. The suggested POIs is sorted on decreasing total visit count (i.e., most popular first); count only visits by users like 'X' (Displayed on the right).</p>
		 </div>
	<ul class="list-group">
<%
	results = order.suggestPOI(username);
	boolean empty = true;
	while (results!=null && results.next()) {
		empty = false;
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
						<div class="col-sm-1 panel_favourite big_number">
							<%=results.getString("cnt") %>
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
	}
	if (empty) {
%>
	<li class="list-group-item poi_panel">
		<div class="alert alert-warning" role="alert" >
			Opps, There is no POI suits your requirements! Change the category please.
		</div>
	</li>
<%
	}
%>

	</ul>
	</div>

</div>
<%@ include file="include/footer.jsp" %>

<% } %>
