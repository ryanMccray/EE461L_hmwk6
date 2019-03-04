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
<%@ page import="guestbook.Subscribe" %>
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
    
    // CURRENT URL RETURNS THE CURRENT URL MINUS THE .JSP AT THE END
    String current_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );
 	// CHANGE TO THE ADDRESS OF THE ACTUAL LANDING PAGE
    current_url = current_url + "/ofyguestbook.jsp"; 
	%>	
		<p><a href="<%= current_url %>" >Return to Landing Page</a></p>
		<h3>Sign up for a Scheduled Email, notifying you about recent posts</h3>
		<br>
		<p> Please Enter the email address you would like alerts sent to.</p>
		<p> Alerts will be sent every day at 5 pm.</p>
		
		<form action="/subscribe" method="post">
        <div> <textarea name="content" cols="45" > </textarea> </div>
      	<div> <input type="submit" value="Subscribe" /> </div>
      	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
      	</form>
		
	<% 
	ObjectifyService.register(Subscribe.class);
	List<Subscribe> subscribers = ObjectifyService.ofy().load().type(Subscribe.class).list();   
	
    //if (subscribers.isEmpty()) {
    %> 
    	<p>There are no subscribers in '${fn:escapeXml(guestbookName)}'.</p> 
   	<%
    //} 
    //else {
    %> 
    	<p>Current Subscribers in '${fn:escapeXml(guestbookName)}'.</p>
    <%
    //    for(Subscribe subscriber: subscribers){
    //        pageContext.setAttribute("sub_email", subscriber.getEmailAddress());
    %> 		<blockquote>${fn:escapeXml(sub_email)}</blockquote> 
    <%
    //	}
    //}
	%>


  </body>
</html>