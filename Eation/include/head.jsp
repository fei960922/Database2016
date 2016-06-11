<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <title><%=request.getParameter("title") %></title>
	    <meta name="viewport" content="width=device-width">
	    <meta name="description" content="{{ site.description }}">
		<link rel="stylesheet" href="include/bootstrap.min.css" type="text/css" />
		<link rel="stylesheet" href="include/main.css" type="text/css" />
	</head>
		<% if (request.getParameter("index")==null) { %>
	<body class = "Microsoft_YaHei" style= "padding-top:50px;" >
		<div id = "headingDefault">
		<% } else { %>
	<body class = "Microsoft_YaHei">
		<div id = "headingForIndex">
		<% } %>
		<%@ include file="navi.jsp" %>
		</div>
		
		