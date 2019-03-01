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
    //String full_url = request.getScheme() + "://" +
    //        request.getServerName() + 
    //        ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() ) +
    //        request.getRequestURI() +
    //       (request.getQueryString() != null ? "?" + request.getQueryString() : "");
    
    // CURRENT URL RETURNS THE CURRENT URL MINUS THE .JSP AT THE END
    String current_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );
 	// CHANGE TO THE ADDRESS OF THE ACTUAL LANDING PAGE
    current_url = current_url + "/ofyguestbook.jsp"; 
	%>	
		<p><a href="<%= current_url %>" >Return to Landing Page</a>.</p>
		<p>Here is a list of all the messages posted on Bear Blog</p>
		
	<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	Query query = new Query("Greeting", guestbookKey).addSort("user", 
	Query.SortDirection.DESCENDING).addSort("date", 
	Query.SortDirection.DESCENDING);
    
    //List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	ObjectifyService.register(Greeting.class);
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 
    
    if (greetings.isEmpty()) {

    %>
        <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
        <%

    } 
    else {

        %>
        <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
        <%
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.getContent());
            if (greeting.getUser() == null) {
        %>
                <p>An anonymous person wrote:</p>
            <%
            } 
            else {
                pageContext.setAttribute("greeting_user", greeting.getUser());
            %>
                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
            <%
            }

            %>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
<%

        }

    }

%>
 

  </body>

</html>