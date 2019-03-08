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
   
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" id = "main"/>
   <!-- Ryan driving for this comment -->
 <!--   <link type="text/css" rel="stylesheet" href="/stylesheets/bearAttack.css" id="light" class="alternate"> --> 
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
<!-- Ryan driving for header, I think papyrus was the font of the Brother Bear movie? -->
<!-- Ryan driving also for this code on every other .jsp file -->
<h1 style=font-family:papyrus>
<a href="https://guestbook-231523.appspot.com/landing_page.jsp"><img src="/images/bearpaw.jpg" alt="" width="100" height="98.5"/></a>
BearBlog</h1>
<%
    // Ken driving for these links, copy/pasted to every page. Links available changed accordingly.
    String base_url = request.getScheme() + "://" +
            request.getServerName() + 
            ("http".equals(request.getScheme()) && request.getServerPort() == 80 || "https".equals(request.getScheme()) && request.getServerPort() == 443 ? "" : ":" + request.getServerPort() );	
	String landing_url = base_url + "/landing_page.jsp";
	String compose_url = base_url + "/post_message.jsp";
	String full_list_url = base_url + "/full_list_replies.jsp";
	String cron_url = base_url + "/cron_job.jsp";
%>
 
		<p><a href="<%= full_list_url %>" >All Posts</a> | <a href="<%= compose_url %>" >Compose Post</a> | <a href="<%= cron_url %>" >Subscribe Here!</a>
		<!-- Ryan driving for this line of code -->
		<button onclick="swap()" style="float: right;">Bear Attack (NSWF)</button></p>
		
<!-- Ryan driving here, <hr> very important stylistic choice. -->
<hr>

<h3>Recent Posts</h3>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p><br>
<%
    } else {
%>
<!-- Ryan driving here just like above, is same code -->
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
 
		<p><a href="<%= full_list_url %>" >All Posts</a> | <a href="<%= compose_url %>" >Compose Post</a> | <a href="<%= cron_url %>" >Subscribe Here!</a>
		<button onclick="swap()" style="float: right;">Bear Attack (NSWF)</button></p>
		<h3>Welcome to the Landing Page</h3>
<hr>

<h3>Recent Posts</h3>
<p>Hello! <!-- this is only different part, just like guestbook -->
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
		//Ken driving
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
//Ryan driving
function swap() {

    var oldlink = document.getElementsByTagName("link").item(0);

    if(oldlink.getAttribute("href") == "/stylesheets/bearAttack.css"){
    	var newlink = document.createElement("link");
        newlink.setAttribute("rel", "stylesheet");
        newlink.setAttribute("type", "text/css");
        newlink.setAttribute("href", "/stylesheets/main.css");
    	document.getElementsByTagName("head").item(0).replaceChild(newlink, oldlink);
    	
    }else{
    	var newlink = document.createElement("link");
        newlink.setAttribute("rel", "stylesheet");
        newlink.setAttribute("type", "text/css");
        newlink.setAttribute("href", "/stylesheets/bearAttack.css");
    	document.getElementsByTagName("head").item(0).replaceChild(newlink, oldlink);
    	
    }
}
</script>  
 
  </body>
</html>


