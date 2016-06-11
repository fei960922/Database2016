# Database2016
SJTU 2015-2016 Spring Database

# Project A --- Eation点评系统

## 网站地图

- index.jsp
- login.jsp 		(1)
	- ?do=register
	- ?do=logout
	- ?do=login
- login.java
	- String check_login (String username, String password, Statement stmt)
		- check if the login user has the correct username and the password
	- String register(String username, String password, Statement stmt)
		- regeister for new user. insert new username and password into database
	- boolean isadmin(String username, Statement stmt)
		- check if the login user is admin
- poi_table.jsp 	(9)(13)
	- #order=()
	- #price_l=()
	- #price_h=()
	......
- poi_detail.jsp 	(6)(7)(10)
	- ?id=()
- poi_detail.java
	- ResultSet getPOI(String id)
		- get the infomation of the specific poi from the database
	- boolean insertPOIdetail(String name, String address, String url, String tele, String estyear,
		 String opHour, String price, String keyword, String category, Statement stmt)
		- if the login user is admin, insert additional poi infomation into database
	- ResultSet getVisit(String username, String pid)
		- get the visit record of the login user visiting the specific poi from the database
	- boolean insertVisit(String username, String pid, String date, String cost, String personnum)
		- insert the new visit infomation into the database
	- ResultSet getTopOpinion(String pid, String cnt)
		- get the "cnt" most useful feedback of the specific pid by all users
	- boolean insertOpinion(String text, String score, String pid)
		- if the login user have not given his opinion of the specific poi, insert his opinion and rate into the database
	- boolean rateOpinion(String value, String log_name, String pid)
		- rate other's opinion and insert into opinion_rate in the database
- poi_admin.jsp 	(2)(3)(4)
	- #visit
	- #add
- poi_admin.java
	- String newPOI(String POIPrice, String POIAddr, String POIName, String POICatagory, Statement stmt)
		- if the login user is admin, insert new POI with the infomation of price, addr, name, category into database
- user_table.jsp 	(8)(14)
	- ?trust=(T/F)
	- ?order=(trust/favourite)
- user_center.jsp 	(5)(11)
	- ?username=(name)

- order.java
	String getOrders(String attrName, String attrValue, Statement stmt)
		- test function
	boolean tag_trust(String username, String to_tag, int status, Statement stmt)
		- if the user login "username" trust the other user "to_tag", insert status 1 into database
	String getUser(int sort, String username, Statement stmt)
		- return the top users who are most trusting or useful
	ResultSet getAllPOI(int status, String price_l, String price_h, String address, 
							String name, String keyword, String category, String sort, String username)
		- return the information of all POI from database
	String getCategory()
		- return category from database
	boolean isVisit(String username, String poi_id, Statement stmt)
		- return the number of times the login user with "username" has visit the pid
	boolean isFavourite(String username, String poi_id, Statement stmt)
		- check if the poi_id is the favourite of the user with username
	boolean changeFavourite(String username, String poi_id, String status, Statement stmt)
		- change the favourite of the login user with username
	ResultSet getStatic_popular(String category, String m)
		- return the most m popular pid in the specific category
	ResultSet getStatic_cost(String category, String m)
		- return the most m expensive pid in the specific category
	ResultSet getStatic_score(String category, String m)
		- return m pid with highest score in the specific category

## 各功能使用方法

**1) [5pts] Registration:** 
Registration: a new user has to provide the appropriate information; he/she can pick a login-name and a password. The login name should be checked for uniqueness.

*方法*：通过任何页面的右上角登录，或通过login.jsp登录或注册

**2) [5pts] Visit:** 
After registration, a user can record a visit to any POI (the same user may visit the same POI multiple times). Each user session (meaning each time after a user has logged into the system) may add one or more visits, and all visits added by a user in a user session are reported to him/her for the final review and confirmation, before they are added into the database.

*方法*：通过poi_admin.jsp的第一个标签页添加

**3) [5pts] New POI:** 
The admin user records the details of a new POI.

*方法*：通过poi_admin.jsp manage 标签页添加

**4) [5pts] Update POI:** 
The admin user may update the information regarding an existing POI.

*方法*：通过poi_detail.jsp 修改后submit

**5) [5pts] Favorite recordings:** 
Users can declare a POI as his/her favoriate place to visit.

*方法*：通过user_center.jsp 中展示

**6) [5pts] Feedback recordings:** 
Users can record their feedback for a POI. We should record the date, the
numerical score (0= terrible, 10= excellent), and an optional short text. No changes are allowed; only one feedback per user per POI is allowed.

*方法*：通过poi_detail.jsp 中填写opinion后submit

**7) [5pts] Usefulness ratings:** 
Users can assess a feedback record, giving it a numerical score 0, 1, or 2 ('useless','useful', 'very useful' respectively). A user should not be allowed to provide a usefulness-rating for his/her own feedbacks.

*方法*： 通过poi_detail.jsp中rate

**8) [5pts] Trust recordings:** 
A user may declare zero or more other users as 'trusted' or 'not-trusted'.

*方法*： 通过user_table.jsp 中trusted点击五角星

**9) [20pts] POI Browsing:** 
Users may search for POIs, by asking conjunctive queries on the price (a range), and/or address (at CITY or State level), and/or name by keywords, and/or category. Your ystem should allow the user to specify that the results are to be sorted (a) by price, or (b) by the average numerical score of the feedbacks, or (c) by the average numerical score of the trusted user feedbacks.

*方法*： 在poi_table.jsp 中输入price, addr, name by keywords or category, 在sort by中选择并点击search

**10) [5pts] Useful feedbacks:** 
For a given POI, a user could ask for the top n most 'useful' feedbacks. The
value of n is user-specifed (say, 5, or 10). The 'usefulness' of a feedback is its average 'usefulness' score.

*方法*：在poi_detail.jsp的feedback中输入n，点击search

*SQL语句：*

	SELECT O.*, avg(R.value) as cnt FROM opinion O LEFT JOIN opinion_rate R 
	ON R.op_id=O.op_id WHERE poi_id=1 GROUP BY O.op_id ORDER BY cnt DESC

**11) [10pts] Visiting suggestions:** 
Like most e-commerce websites, when a user records his/her visit to a POI 'A', your system should give a list of other suggested POIs. POI 'B' is suggested, if there exist a user 'X' that visited both 'A' and 'B'. The suggested POIs should be sorted on decreasing total visit count (i.e., most popular first); count only visits by users like 'X'.

*方法*：user_center.jsp的visiting suggestion中显示

*SQL语句：*

	SELECT P.*, count(*) as cnt FROM poi P, visited V  
	WHERE P.poi_id=V.poi_id AND V.log_name!='test' AND V.log_name IN 
	(SELECT log_name FROM visited WHERE poi_id IN 
	(SELECT poi_id FROM visited WHERE log_name='test')) GROUP BY V.poi_id ORDER BY cnt DESC

**12) [10pts] 'Two degrees of separation':** 
Given two user names (logins), determine their 'degree of separation', defined as follows: Two users 'A' and 'B' are 1-degree away if they have both favorited at least one common POI; they are 2-degrees away if there exists an user 'C' who is 1-degree away from each of 'A' and 'B', AND 'A' and 'B' are not 1-degree away at the same time.

*方法*：在user_table.jsp的two degrees of separation中输入两个username，点击find their degree

*SQL语句：*

	SELECT count(*) FROM favourite A, favourite B 
	WHERE A.poi_id=B.poi_id AND A.log_name='test' AND B.log_name='test2'
	SELECT count(*) FROM 
	(SELECT distinct B.log_name FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='username1') C,
	(SELECT distinct B.log_name FROM favourite A, favourite B WHERE A.poi_id=B.poi_id AND A.log_name='username2') D
	WHERE C.log_name=D.log_name


**13) [10pts] Statistics:** 
At any point, a user may want to show the list of the m (say m = 5) most popular POIs (in terms of total visits) for each category, the list of m most expensive POIs (defined by the average cost per head of all visits to a POI) for each category the list of m highly rated POIs (defined by the average scores from all feedbacks a POI has received) for each category

*方法*： 在poi_statistics.jsp中选择category和solution，点击submit

*SQL语句：*

	Select P.*, count(*) as cnt from poi P, Visited V where P.poi_id=V.poi_id and category='category' group by P.poi_id order by cnt DESC limit 0,100

	Select P.*, avg(O.cost) as cnt from poi P, visited O where P.poi_id=O.poi_id and category='category' group by O.poi_id order by cnt DESC limit 0,100

	Select P.*, avg(O.score) as cnt from poi P, opinion O where P.poi_id=O.poi_id and category='category' group by O.poi_id order by cnt DESC limit 0,100

**14) [5pts] User awards:** 
At random points of time, the admin user wants to give awards to the 'best' users;
thus, the admin user needs to know: the top m most 'trusted' users (the trust score of a user is the count of users 'trusting' him/her, minus the count of users 'not-trusting' him/her) the top m most 'useful' users (the usefulness score of a user is the average 'usefulness' of all of his/her feedbacks combined)

*方法*：在user_table中点击sort by all users 或者 trusted 或者 useful

*SQL语句：*

	Select * from person
	
	select * from (select log_2, sum(value) as cnt from trust group by log_2) T, person P where T.log_2=P.log_name order by cnt DESC
	
	select * from (select log_name, avg(value) as cnt from opinion_rate group by log_name) T, person P where T.log_name=P.log_name order by cnt DESC

##数据库结构

	CREATE TABLE person (
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