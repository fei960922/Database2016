<%@ page language="java" import="acmdb.*" contentType="text/html;charset=utf-8" %>

<jsp:include page="include/head.jsp" flush="true"> 
<jsp:param name="title" value="POI Selection --- Eation"/>
</jsp:include>
<div class="container">


<h1 id="project-a-eation点评系统">Project A — Eation点评系统帮助</h1>



<h2 id="网站地图">网站地图</h2>

<ul>
<li>index.jsp</li>
<li>login.jsp         (1) <br>
<ul><li>?do=register</li>
<li>?do=logout</li>
<li>?do=login</li></ul></li>
<li>login.java <br>
<ul><li>String check_login (String username, String password, Statement stmt) <br>
<ul><li>check if the login user has the correct username and the password</li></ul></li>
<li>String register(String username, String password, Statement stmt) <br>
<ul><li>regeister for new user. insert new username and password into database</li></ul></li>
<li>boolean isadmin(String username, Statement stmt) <br>
<ul><li>check if the login user is admin</li></ul></li></ul></li>
<li>poi_table.jsp     (9)(13) <br>
<ul><li>#order=()</li>
<li>#price_l=()</li>
<li>#price_h=() <br>
……</li></ul></li>
<li>poi_detail.jsp    (6)(7)(10) <br>
<ul><li>?id=()</li></ul></li>
<li>poi_detail.java <br>
<ul><li>ResultSet getPOI(String id) <br>
<ul><li>get the infomation of the specific poi from the database</li></ul></li>
<li>boolean insertPOIdetail(String name, String address, String url, String tele, String estyear, <br>
 String opHour, String price, String keyword, String category, Statement stmt) <br>
<ul><li>if the login user is admin, insert additional poi infomation into database</li></ul></li>
<li>ResultSet getVisit(String username, String pid) <br>
<ul><li>get the visit record of the login user visiting the specific poi from the database</li></ul></li>
<li>boolean insertVisit(String username, String pid, String date, String cost, String personnum) <br>
<ul><li>insert the new visit infomation into the database</li></ul></li>
<li>ResultSet getTopOpinion(String pid, String cnt) <br>
<ul><li>get the “cnt” most useful feedback of the specific pid by all users</li></ul></li>
<li>boolean insertOpinion(String text, String score, String pid) <br>
<ul><li>if the login user have not given his opinion of the specific poi, insert his opinion and rate into the database</li></ul></li>
<li>boolean rateOpinion(String value, String log_name, String pid) <br>
<ul><li>rate other’s opinion and insert into opinion_rate in the database</li></ul></li></ul></li>
<li>poi_admin.jsp     (2)(3)(4) <br>
<ul><li>#visit</li>
<li>#add</li></ul></li>
<li>poi_admin.java <br>
<ul><li>String newPOI(String POIPrice, String POIAddr, String POIName, String POICatagory, Statement stmt) <br>
<ul><li>if the login user is admin, insert new POI with the infomation of price, addr, name, category into database</li></ul></li></ul></li>
<li>user_table.jsp    (8)(14) <br>
<ul><li>?trust=(T/F)</li>
<li>?order=(trust/favourite)</li></ul></li>
<li><p>user_center.jsp   (5)(11)</p>

<ul><li>?username=(name)</li></ul></li>
<li><p>order.java <br>
String getOrders(String attrName, String attrValue, Statement stmt) <br>
    - test function <br>
boolean tag_trust(String username, String to_tag, int status, Statement stmt) <br>
    - if the user login “username” trust the other user “to_tag”, insert status 1 into database <br>
String getUser(int sort, String username, Statement stmt) <br>
    - return the top users who are most trusting or useful <br>
ResultSet getAllPOI(int status, String price_l, String price_h, String address,  <br>
                        String name, String keyword, String category, String sort, String username) <br>
    - return the information of all POI from database <br>
String getCategory() <br>
    - return category from database <br>
boolean isVisit(String username, String poi_id, Statement stmt) <br>
    - return the number of times the login user with “username” has visit the pid <br>
boolean isFavourite(String username, String poi_id, Statement stmt) <br>
    - check if the poi_id is the favourite of the user with username <br>
boolean changeFavourite(String username, String poi_id, String status, Statement stmt) <br>
    - change the favourite of the login user with username <br>
ResultSet getStatic_popular(String category, String m) <br>
    - return the most m popular pid in the specific category <br>
ResultSet getStatic_cost(String category, String m) <br>
    - return the most m expensive pid in the specific category <br>
ResultSet getStatic_score(String category, String m) <br>
    - return m pid with highest score in the specific category</p></li>
</ul>

<h2 id="各功能使用方法">各功能使用方法</h2>

<p><strong>1) [5pts] Registration:</strong>  <br>
Registration: a new user has to provide the appropriate information; he/she can pick a login-name and a password. The login name should be checked for uniqueness.</p>

<p><em>方法</em>：通过任何页面的右上角登录，或通过login.jsp登录或注册</p>

<p><strong>2) [5pts] Visit:</strong>  <br>
After registration, a user can record a visit to any POI (the same user may visit the same POI multiple times). Each user session (meaning each time after a user has logged into the system) may add one or more visits, and all visits added by a user in a user session are reported to him/her for the final review and confirmation, before they are added into the database.</p>

<p><em>方法</em>：通过poi_admin.jsp的第一个标签页添加</p>

<p><strong>3) [5pts] New POI:</strong>  <br>
The admin user records the details of a new POI.</p>

<p><em>方法</em>：通过poi_admin.jsp manage 标签页添加</p>

<p><strong>4) [5pts] Update POI:</strong>  <br>
The admin user may update the information regarding an existing POI.</p>

<p><em>方法</em>：通过poi_detail.jsp 修改后submit</p>

<p><strong>5) [5pts] Favorite recordings:</strong>  <br>
Users can declare a POI as his/her favoriate place to visit.</p>

<p><em>方法</em>：通过user_center.jsp 中展示</p>

<p><strong>6) [5pts] Feedback recordings:</strong>  <br>
Users can record their feedback for a POI. We should record the date, the <br>
numerical score (0= terrible, 10= excellent), and an optional short text. No changes are allowed; only one feedback per user per POI is allowed.</p>

<p><em>方法</em>：通过poi_detail.jsp 中填写opinion后submit</p>

<p><strong>7) [5pts] Usefulness ratings:</strong>  <br>
Users can assess a feedback record, giving it a numerical score 0, 1, or 2 (‘useless’,’useful’, ‘very useful’ respectively). A user should not be allowed to provide a usefulness-rating for his/her own feedbacks.</p>

<p><em>方法</em>： 通过poi_detail.jsp中rate</p>

<p><strong>8) [5pts] Trust recordings:</strong>  <br>
A user may declare zero or more other users as ‘trusted’ or ‘not-trusted’.</p>

<p><em>方法</em>： 通过user_table.jsp 中trusted点击五角星</p>

<p><strong>9) [20pts] POI Browsing:</strong>  <br>
Users may search for POIs, by asking conjunctive queries on the price (a range), and/or address (at CITY or State level), and/or name by keywords, and/or category. Your ystem should allow the user to specify that the results are to be sorted (a) by price, or (b) by the average numerical score of the feedbacks, or (c) by the average numerical score of the trusted user feedbacks.</p>

<p><em>方法</em>： 在poi_table.jsp 中输入price, addr, name by keywords or category, 在sort by中选择并点击search</p>

<p><strong>10) [5pts] Useful feedbacks:</strong>  <br>
For a given POI, a user could ask for the top n most ‘useful’ feedbacks. The <br>
value of n is user-specifed (say, 5, or 10). The ‘usefulness’ of a feedback is its average ‘usefulness’ score.</p>

<p><em>方法</em>：在poi_detail.jsp的feedback中输入n，点击search</p>

<p><em>SQL语句：</em></p>

<pre><code>SELECT O.*, avg(R.value) as cnt FROM opinion O LEFT JOIN opinion_rate R 
ON R.op_id=O.op_id WHERE poi_id=1 GROUP BY O.op_id ORDER BY cnt DESC
</code></pre>

<p><strong>11) [10pts] Visiting suggestions:</strong>  <br>
Like most e-commerce websites, when a user records his/her visit to a POI ‘A’, your system should give a list of other suggested POIs. POI ‘B’ is suggested, if there exist a user ‘X’ that visited both ‘A’ and ‘B’. The suggested POIs should be sorted on decreasing total visit count (i.e., most popular first); count only visits by users like ‘X’.</p>

<p><em>方法</em>：user_center.jsp的visiting suggestion中显示</p>

<p><em>SQL语句：</em></p>

<pre><code>SELECT P.*, count(*) as cnt FROM poi P, visited V  
WHERE P.poi_id=V.poi_id AND V.log_name!='test' AND V.log_name IN 
(SELECT log_name FROM visited WHERE poi_id IN 
(SELECT poi_id FROM visited WHERE log_name='test')) GROUP BY V.poi_id ORDER BY cnt DESC
</code></pre>

<p><strong>12) [10pts] ‘Two degrees of separation’:</strong>  <br>
Given two user names (logins), determine their ‘degree of separation’, defined as follows: Two users ‘A’ and ‘B’ are 1-degree away if they have both favorited at least one common POI; they are 2-degrees away if there exists an user ‘C’ who is 1-degree away from each of ‘A’ and ‘B’, AND ‘A’ and ‘B’ are not 1-degree away at the same time.</p>

<p><em>方法</em>：在user_table.jsp的two degrees of separation中输入两个username，点击find their degree</p>

<p><em>SQL语句：</em></p>

<pre><code>SELECT count(*) FROM favourite A, favourite B 
WHERE A.poi_id=B.poi_id AND A.log_name='test' AND B.log_name='test2'
SELECT count(*) FROM 
(SELECT distinct B.log_name FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='username1') C,
(SELECT distinct B.log_name FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='username2') D
WHERE C.log_name=D.log_name
</code></pre>

<p><strong>13) [10pts] Statistics:</strong>  <br>
At any point, a user may want to show the list of the m (say m = 5) most popular POIs (in terms of total visits) for each category, the list of m most expensive POIs (defined by the average cost per head of all visits to a POI) for each category the list of m highly rated POIs (defined by the average scores from all feedbacks a POI has received) for each category</p>

<p><em>方法</em>： 在poi_statistics.jsp中选择category和solution，点击submit</p>

<p><em>SQL语句：</em></p>

<pre><code>Select P.*, count(*) as cnt from poi P, Visited V where P.poi_id=V.poi_id and category='category' group by P.poi_id order by cnt DESC limit 0,100

Select P.*, avg(O.cost) as cnt from poi P, visited O where P.poi_id=O.poi_id and category='category' group by O.poi_id order by cnt DESC limit 0,100

Select P.*, avg(O.score) as cnt from poi P, opinion O where P.poi_id=O.poi_id and category='category' group by O.poi_id order by cnt DESC limit 0,100
</code></pre>

<p><strong>14) [5pts] User awards:</strong>  <br>
At random points of time, the admin user wants to give awards to the ‘best’ users; <br>
thus, the admin user needs to know: the top m most ‘trusted’ users (the trust score of a user is the count of users ‘trusting’ him/her, minus the count of users ‘not-trusting’ him/her) the top m most ‘useful’ users (the usefulness score of a user is the average ‘usefulness’ of all of his/her feedbacks combined)</p>

<p><em>方法</em>：在user_table中点击sort by all users 或者 trusted 或者 useful</p>

<p><em>SQL语句：</em></p>

<pre><code>Select * from person

select * from (select log_2, sum(value) as cnt from trust group by log_2) T, person P where T.log_2=P.log_name order by cnt DESC

select * from (select log_name, avg(value) as cnt from opinion_rate group by log_name) T, person P where T.log_name=P.log_name order by cnt DESC
</code></pre>

<h2 id="数据库结构">数据库结构</h2>

<pre><code>CREATE TABLE person (
    log_name  VARCHAR(256),
    full_name  VARCHAR(256),
    address  VARCHAR(256),
    phone  INT,
    password_o VARCHAR(256),
    password VARCHAR(256),
    fav_poi  INT,
    PRIMARY KEY log_name,
    CONSTRAINT FOREIGN KEY (fav_poi) REFERENCES poi
)
CREATE TABLE poi (
    poi_id  INT,
    Name   VARCHAR(256),
    address  VARCHAR(256),
    url   VARCHAR(256),
    phone  INT,
    year_estab INT,
    hours_op  INT,
    price  INT,
    keywords VARCHAR(256),
    category  VARCHAR(256),
    pic_url  VARCHAR(256),
    PRIMARY KEY poi_id,
)
CREATE TABLE opinion (
    op_id  INT,
    Texts   VARCHAR(256),
    score  INT,
    log_name  VARCHAR(256),
    poi_id  INT,
    PRIMARY KEY op_id,
    FOREIGN KEY log_name REFERENCES person,
    FOREIGN KEY poi_id REFERENCES poi
)
CREATE TABLE visited (
    visit_id INT,
    no_person INT,
    cost  INT,
    dates   DATE,
    log_name  VARCHAR(256),
    poi_id  INT,
    PRIMARY KEY visit_id,
    FOREIGN KEY log_name REFERENCES person,
    FOREIGN KEY poi_id REFERENCES poi
)
CREATE TABLE trust (
    value  INT,
    log_name  VARCHAR(256),
    log_2  VARCHAR(256),
    PRIMARY KEY (log_name, log_2),
    FOREIGN KEY log_name REFERENCES person
    FOREIGN KEY log_2 REFERENCES person(log_name)
)
CREATE TABLE opinion_rate (
    value  INT,
    log_name  VARCHAR(256),
    op_id  INT,
    PRIMARY KEY (log_name, op_id),
    FOREIGN KEY log_name REFERENCES person,
    FOREIGN KEY op_id REFERENCES opinion
)
</code></pre>
</div>
<%@ include file="include/footer.jsp" %>

