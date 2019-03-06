<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.*" %>
<%@ page import="guestbook.Greeting" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 
<html>

 <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>
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
      pageContext.setAttribute("user", user);}
%>
	
	<%
    // CURRENT URL RETURNS THE CURRENT URL MINUS THE .JSP AT THE END
    String base_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );	
	String landing_url = base_url + "/landing_page.jsp";
	String compose_url = base_url + "/post_message.jsp";
	String full_list_url = base_url + "/full_list_replies.jsp";
	String cron_url = base_url + "/crob_job.jsp";
%>
 
		<p><a href="<%= landing_url %>" >Landing Page</a> or <a href="<%= full_list_url %>" >All Posts</a> or <a href="<%= cron_url %>" >Subscribe Here!</a></p>
		<h3>Compose your blog post below</h3>
		
		<form action="/ofysign" method="post">
		<div>Title: <textarea name="title" rows="1" cols="60"></textarea></div>
        <div><textarea name="content" rows="10" cols="100"></textarea></div>
      <%if(user == null){ %> <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> <%}
      else{ %>
      <div><input type="submit" value="Post Greeting" /></div>
      <%} %>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
        </form>
        
        
 </body>

</html>