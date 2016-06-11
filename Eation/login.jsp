<%@ page language="java" import="acmdb.*" contentType="text/html;charset=utf-8" %>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="Login in --- Eation"/>
</jsp:include>

	<div class="container_big">

<%  String login_name = request.getParameter("Username");
	if (request.getParameter("do")!=null) {
		if (request.getParameter("do").equals("register")) {
		// Register part
			if (login_name==null) {
%>
		<div class="col-md-6">
			<image src="images/eation_w.png" style="float:left;width:100%;"/>
		</div>
		<div class="col-md-6 login_section" style="padding:25px">
			<form action="login.jsp?do=register" method="post" accept-charset="utf-8">
              <div class="input-group">
                <span class="input-group-addon" id="basic-addon1">Username:</span>
                <input type="text" class="form-control" name="Username" placeholder="Username" aria-describedby="basic-addon1">
              </div>
              <div class="input-group">
                <span class="input-group-addon" id="basic-addon1">Password:</span>
                <input type="password" class="form-control" name="password" placeholder="******" aria-describedby="basic-addon2">
              </div>
              <div class="input-group">
                <span class="input-group-addon" id="basic-addon1">Repeat Password:</span>
                <input type="password" class="form-control" name="password" placeholder="******" aria-describedby="basic-addon2">
              </div>
              <button class="btn btn-default" type="submit">Register</button>
              <button class="btn btn-default" onclick="refresh">Clear</button>
            </form>
		</div>
<%
			} else {
				//register succ
				Order order = new Order();
				Boolean regi_sta = order.register(login_name, request.getParameter("password"));
				if (regi_sta) {
					out.println("<div class=\"alert alert-success\" role=\"alert\">Register Successfully!</div>");
					session.setAttribute("login_name", login_name);
				} else 
					out.println("<div class=\"alert alert-danger\" role=\"alert\"><strong>Opps!</strong>Username Exists!</div>");
			}
		} else if (request.getParameter("do").equals("logout")) {
			// Logout
			session.removeAttribute("login_name");
			session.removeAttribute("admin");
			out.println("<div class=\"alert alert-success\" role=\"alert\">Logout Successfully!</div>");
		} else if (request.getParameter("do").equals("login")) {
			// Login
			if (login_name==null || login_name.length()==0) {
				if (request.getParameter("warn")!=null)
					out.println("<div class=\"alert alert-danger\" role=\"alert\"><strong>Opps!</strong>Please Login first!</div>");
%>
			<div class="row">
				<div class="col-md-6">
				<image src="images/eation_w.png" style="float:left;width:100%;"/>
				</div>
				<div class="col-md-6 login_section" style="padding:25px">
	            <form action="login.jsp?do=login" method="post" accept-charset="utf-8">
	              <div class="input-group">
	                <span class="input-group-addon" id="basic-addon1">Username:</span>
	                <input type="text" class="form-control" name="Username" placeholder="Username" aria-describedby="basic-addon1">
	              </div>
	              <div class="input-group">
	                <span class="input-group-addon" id="basic-addon1">Password:</span>
	                <input type="text" class="form-control" name="password" placeholder="******" aria-describedby="basic-addon2">
	              </div>
	              <button class="btn btn-default" type="submit">Login</button>
	              <button class="btn btn-default" onclick="window.open('login.jsp?do=register')">Register</button>
	            </form>
				</div>
			</div>
<%
			} else {
				Order order = new Order();
				Boolean login_sta = order.check_login(login_name, request.getParameter("password"));
				if (login_sta) {
					out.println("<div class=\"alert alert-success\" role=\"alert\">Logged in Successfully!</div>");
					if (order.isadmin(login_name)) {
						session.setAttribute("admin", "T");
						System.out.println("Admin Logged!");
					}
					session.setAttribute("login_name", login_name);
				} else 
					out.println("<div class=\"alert alert-danger\" role=\"alert\"><strong>Opps!</strong>Log in failed!</div>");
			} 
		} else {}
	} else if (session.getAttribute("login_name")==null) { 
		if (request.getParameter("warn")!=null)
			out.println("<div class=\"alert alert-danger\" role=\"alert\"><strong>Opps!</strong>Please Login first!</div>");
 %>
			<div class="row">
				<div class="col-md-6">
				<image src="images/eation_w.png" style="float:left;width:100%;"/>
				</div>
				<div class="col-md-6 login_section" style="padding:25px">
	            <form action="login.jsp?do=login" method="post" accept-charset="utf-8">
	              <div class="input-group">
	                <span class="input-group-addon" id="basic-addon1">Username:</span>
	                <input type="text" class="form-control" name="Username" placeholder="Username" aria-describedby="basic-addon1">
	              </div>
	              <div class="input-group">
	                <span class="input-group-addon" id="basic-addon1">Password:</span>
	                <input type="password" class="form-control" name="password" placeholder="******" aria-describedby="basic-addon2">
	              </div>
	              <button class="btn btn-default" type="submit">Login</button>
	              <button class="btn btn-default" onclick="window.open('login.jsp?do=register')">Register</button>
	            </form>
				</div>
			</div>

<%	} else {
%>

				<div class="alert alert-danger" role="alert">
					<strong>Opps!</strong>
					Already Logged in! 
					<a href="login.jsp?do=logout" class="alert-link">Click here to Logout.</a>
				</div>
            
<% } %>
	</div>
	<%@ include file="include/footer.jsp" %>