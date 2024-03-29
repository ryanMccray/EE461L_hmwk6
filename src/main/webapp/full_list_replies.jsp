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
 <h1 style=font-family:papyrus> 
  <a href="https://guestbook-231523.appspot.com/landing_page.jsp"><img src="/images/bearpaw.jpg" alt="" width="100" height="98.5"/></a>
BearBlog</h1>


	<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }

    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    //String full_url = request.getScheme() + "://" +
    //        request.getServerName() + 
    //        ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() ) +
    //        request.getRequestURI() +
    //       (request.getQueryString() != null ? "?" + request.getQueryString() : "");
    
    // CURRENT URL RETURNS THE CURRENT URL MINUS THE .JSP AT THE END
    String base_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );	
	String landing_url = base_url + "/landing_page.jsp";
	String compose_url = base_url + "/post_message.jsp";
	String full_list_url = base_url + "/full_list_replies.jsp";
	String cron_url = base_url + "/cron_job.jsp";
	%>	
		<p> <a href="<%= landing_url %>" >Landing Page</a> | <a href="<%= compose_url %>" >Compose Post</a> | <a href="<%= cron_url %>" >Subscribe Here!</a></p>
		<hr>
		<h3>Here is a list of all the messages posted on Bear Blog</h3>
		
	<%
//Ken driving, I am mostly copying this from home page of guestbook and translating to Bear Blog
	ObjectifyService.register(Greeting.class);
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 
    
    if (greetings.isEmpty()) {

    %>
        <p>Bear Blog has no messages.</p>
        <%

    } 
    else {

        %>
        <p>Posts in Bear Blog.</p>
        <%
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
			pageContext.setAttribute("greeting_date", greeting.getDate());
			pageContext.setAttribute("greeting_title", greeting.getTitle());
			if (greeting.getUser() == null) {
				%>
				<p>At ${fn:escapeXml(greeting_date)}, Anonymous User posted ${fn:escapeXml(greeting_title)}:</p>
				<%
			} 
			else {
				pageContext.setAttribute("greeting_user", greeting.getUser());
				%>
				<p>At ${fn:escapeXml(greeting_date)}, <b>${fn:escapeXml(greeting_user.nickname)}</b> posted ${fn:escapeXml(greeting_title)}:</p>
				<%
			}
            %>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote><br><br>
			<%

        }

    }

%>
 

  </body>

</html>