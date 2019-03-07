<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import= "com.googlecode.objectify.*" %>
<%@page import= "guestbook.Greeting" %>
<%@ page import="java.util.List" %>
<%@ page import= "java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>

   <head>
   
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>

 <!--<body background="/images/4bears.jpg">  --> 
 <body>
 
<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<h1 style=font-family:papyrus>
<a href="https://guestbook-231523.appspot.com/landing_page.jsp"><img src="/images/bearpaw.jpg" alt="" width="100" height="98.5"/></a>
BearBlog</h1>
<%
    // CURRENT URL RETURNS THE CURRENT URL MINUS THE .JSP AT THE END
    String base_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );	
	String landing_url = base_url + "/landing_page.jsp";
	String compose_url = base_url + "/post_message.jsp";
	String full_list_url = base_url + "/full_list_replies.jsp";
	String cron_url = base_url + "/cron_job.jsp";
%>
 
		<p><a href="<%= full_list_url %>" >All Posts</a> | <a href="<%= compose_url %>" >Compose Post</a> | <a href="<%= cron_url %>" >Subscribe Here!</a></p>
		

<hr>

<h3>Recent Posts</h3>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p><br>
<%
    } else {
%>
<h1 style=font-family:papyrus>

<a href="https://guestbook-231523.appspot.com/landing_page.jsp"><img src="/images/bearpaw.jpg" alt="" width="100" height="98.5"/></a>
BearBlog</h1>
<%
    // CURRENT URL RETURNS THE CURRENT URL MINUS THE .JSP AT THE END
    String base_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );	
	String landing_url = base_url + "/landing_page.jsp";
	String compose_url = base_url + "/post_message.jsp";
	String full_list_url = base_url + "/full_list_replies.jsp";
	String cron_url = base_url + "/cron_job.jsp";
%>
 
		<p><a href="<%= full_list_url %>" >All Posts</a> | <a href="<%= compose_url %>" >Compose Post</a> | <a href="<%= cron_url %>" >Subscribe Here!</a></p>
		<h3>Welcome to the Landing Page</h3>
<hr>

<h3>Recent Posts</h3>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>
 
<%
    ObjectifyService.register(Greeting.class);
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 
    if (greetings.isEmpty()) {
        %>
        <p>BearBlog has no posts yet, go to Compose Post above to be the first!</p>
        <%
    } 
    else {

        %>
        <%

        int count = 3;
        for (int i = greetings.size()-1; i >= 0; i--) {
        	Greeting greeting = greetings.get(i);
            pageContext.setAttribute("greeting_content",
                                     greeting.getContent());
            pageContext.setAttribute("greeting_date",
                    greeting.getDate());
            pageContext.setAttribute("greeting_title",
                    greeting.getTitle());
            if (greeting.getUser() == null) {
                %>
                <p>At ${fn:escapeXml(greeting_date)}, Anonymous User posted ${fn:escapeXml(greeting_title)}:</p>
                <%
            } else {
                pageContext.setAttribute("greeting_user",
                                         greeting.getUser());
                %>
                <p> At ${fn:escapeXml(greeting_date)}, <b>${fn:escapeXml(greeting_user.nickname)}</b> posted:</p>
                <h4 style=font-family:helvetica>${fn:escapeXml(greeting_title)} </h4>
                <%
            }
            %>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            <br><br>
            <%
            count--;
            if(count == 0){
                break;
            }
        }
    }
%>  

<script>
var dt = new Date();
document.getElementById("datetime").innerHTML = dt.toLocaleString();
</script>   
<script>
var dt = new Date();
document.getElementById("datetime2").innerHTML = dt.toLocaleString();
</script>  
 
  </body>
</html>


