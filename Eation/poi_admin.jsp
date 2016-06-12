<%@ page language="java" import="acmdb.*" contentType="text/html;charset=utf-8" %>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="POI Selection --- Eation"/>
</jsp:include>
<script type="text/javascript">
	function check() {
		var ele = document.getElementsByClassName("to_be_check");
		for (var i=0;i<ele.length;i++) {var e = ele[i];
			if (e.value.length<2 || e.value.length>100 || e.value=="null") {
				alert("You cannot submit empty/'null'/too long value!");
				e.focus();return false;
			}}return true;}
</script>
<div class="container">

<%
	if (session.getAttribute("login_name") != null) {
%>
	
<%  
	
	if (session.getAttribute("admin")!=null) {
		if (request.getParameter("POIName")==null) {
%>
	<h2> POI Insertion <small> admin only</small> </h2>
    <div class="col-md-6 insert_POI" style="padding:25px">
    	<form action="poi_admin.jsp" method="post" accept-charset="utf-8">
              <div class="form-group">
                <label for = "name"> POI NAME </label>
                <input type="text" class="form-control" name="POIName" placeholder="POIname" aria-describedby="basic-addon1">
              </div>
              <div class="form-group">
                <label for = "price"> PRICE </label>
                <input type="text" class="form-control" name="POIPrice" placeholder="Price" aria-describedby="basic-addon2">
              </div>
              <div class="form-group">
                <label for = "addr"> ADDRESS </label>
                <input type="text" class="form-control" name="POIAddr" placeholder="Address" aria-describedby="basic-addon2">
              </div>
              <div class="form-group">
                <label for = "catagory"> CATAGORY </label>
                <input type="text" class="form-control" name="POICatagory" placeholder="Catagory" aria-describedby="basic-addon2">
              </div>
              <button class="btn btn-success" type="submit">Submit</button>
              <button class="btn btn-default" onclick="refresh">Clear</button>
     	</form>
     </div>
     
<%
		} else {
	
			String POI_price = request.getParameter("POIPrice");
			String POI_addr = request.getParameter("POIAddr");
			String POI_name = request.getParameter("POIName");
			String POI_catagory = request.getParameter("POICatagory");
			Order order = new Order();
			if (order.insertPOI(POI_price, POI_addr, POI_name, POI_catagory))
				out.println("<div class=\"alert alert-success\" role=\"alert\">POI inserted Successfully!</div>");
			else 
				out.println("<div class=\"alert alert-danger\" role=\"alert\"><strong>Opps!</strong>Something wrong! Insert failed!</div>");
		}
  } else {
%>
  <div class="alert alert-danger" role="alert">You are not the admin!</div>
<%
  }		
} %>






</div>
<%@ include file="include/footer.jsp" %>

