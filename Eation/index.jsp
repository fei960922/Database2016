<%@ page language="java" import="acmdb.*" contentType="text/html;charset=utf-8" %>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="Eation --- Jerry Xu"/>
<jsp:param name="index" value="1" />
</jsp:include>

    <div class="index_1 fullh" id="index_1" style="background:url(images/1.jpg) 50% 0 no-repeat;backgroundSize:cover;">
    </div>
    <div class="index_2">
      <h1>Greeting from the Eation team</h1>
    </div>
    <div class="index_3 container">
      <img src = "./images/ACM.png" />
      <div>
      	<h3>Hi, welcome to Eation!</h3>    		
      	<h3>Eation is a class project for the Database 2016 Spring instructed by Prof. Feifei Li. Its point of interest includes attractions in Disney Resort Shanghai and prestigous universities around the world. </h3>
      	<h3>You can enjoy our system by register on the right corner above, wish you have fun with Eation:)</h3>
      	<h3> Best regards!</h3>
      </div>
    </div>
	<div class="index_4">
      <h1>Author</h1>
    </div>
    <div class="container">
      <div class="col-md-6 author">
        <img src = "./images/Jerry.jpg" />
        <br>
          <h1>Jerry Xu</h1>
          <p>ACM2013</p>
      </div>
      <div class="col-md-6 author">
        <img src = "./images/piggy.jpg" />
        <br>
        <h1>Yiyi Zhang</h1>
        <p>ACM2013</p>
      </div>
    </div>
    
	
<%@ include file="include/footer.jsp" %>

