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
<h1>
<img src="file:///C|/Users/rmccr/eclipse-workspace/Guestbook/src/main/webapp/images/bearpaw.jpg" alt="" width="100" height="98.5"/>
BearBlog</h1>

<hr>

<h3>Recent Posts</h3>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
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
        <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
        <%
    } else {
        %>
        <p>Posts in BearBlog '${fn:escapeXml(guestbookName)}'.</p>
        <%
        for (Greeting greeting : greetings) {
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
                <p>At ${fn:escapeXml(greeting_date)}, <b>${fn:escapeXml(greeting_user.nickname)}</b> posted ${fn:escapeXml(greeting_title)}:</p>
                <%
            }
            %>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            <%
        }
    }
%>

    <form action="/ofysign" method="post"> <!-- ofysign? -->
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Greeting" /></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
    

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


