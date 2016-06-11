
<div class="inners" >
  <nav class="navbar" role="navigation">
    <div class="navbar-header">
      <a href = "index.jsp"><img src = "images/eation_w.png" style = "float:left;width:45px;height:45px;"></a>
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        Toggle<span class="sr-only">Toggle navigation</span>
      </button>
    </div>
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav navbar-right">
        <li><a href = "index.jsp">Index</a></li>
        <li class="dropdown">
          <a href = "poi_table.jsp">POI</a>
          <ul class="dropdown-menu make_it_left" role="menu">
          	<li><a href = "poi_statistics.jsp">Statistics</a></li>
<% 
			if (session.getAttribute("admin")!=null) 
				out.println("<li><a href = \"poi_admin.jsp\">Manage</a></li>");
%>
          </ul>
        </li>
        <li class="dropdown">
          <a href = "user_table.jsp">Users</a>
        </li>
        <li class="dropdown">
          <a href = "help.jsp">Help</a>
        </li>
        <li class="dropdown">
        <% if (session.getAttribute("login_name")==null) { %>
          <a href = "login.jsp">Guest</a>
          <ul class="dropdown-menu login_section" role="menu">
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
          </ul>
        <% } else { %>
        <a href = "user_center.jsp"><%=session.getAttribute("login_name") %></a>
          <div class="dropdown-menu login_section">
            <p>Welcome</p>
            <h2><%=session.getAttribute("login_name") %></h2>
            <button class="btn btn-default" onclick="window.open('user_center.jsp')">User Center</button>
            <button class="btn btn-default" onclick="window.open('login.jsp?do=logout')">Logout</button>
          </div>
          
        <% } %>

        </li>
      </ul>
    </div>
  </nav>
</div>