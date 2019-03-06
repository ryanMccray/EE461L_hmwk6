package guestbook;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;

 

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

//https://guestbook-231523.appspot.com/landing_page.jsp?guestbookName=default

public class OfySignGuestbookServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
       
        ///////////////////////////////////////
        ObjectifyService.register(Greeting.class);
        List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
        Collections.sort(greetings); 
        String guestbookName = req.getParameter("guestbookName");       
        String content = req.getParameter("content");
        String title = req.getParameter("title");
        Greeting greeting = new Greeting(user, content, guestbookName,title); //add title
        ofy().save().entity(greeting).now();

        resp.sendRedirect("/landing_page.jsp?guestbookName=" + guestbookName);
    }

}