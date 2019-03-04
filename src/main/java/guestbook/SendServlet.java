//https://tutorial5-231522.appspot.com/ofyguestbook.jsp
package guestbook;
 
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.googlecode.objectify.*;
import javax.servlet.http.*;


public class SendServlet extends HttpServlet {
	
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	
    	ObjectifyService.register(Subscribe.class);
    	List<Subscribe> subscribers = ObjectifyService.ofy().load().type(Subscribe.class).list();   
    	
    	for(Subscribe subscriber: subscribers){
    		String message = "Don't forget to check up on Bear Blog";
    		//send message here
    		subscriber.getEmailAddress();
        }
    
    }


    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	
//    	ObjectifyService.register(Subscribe.class);
//    	
//        String guestbookName = req.getParameter("guestbookName");
//        String email = req.getParameter("content");
//        
//        Subscribe new_sub = new Subscribe(email);//, guestbookName);
//        ofy().save().entities(new_sub).now();  // synchronous
//
//        resp.sendRedirect("/cron_job.jsp");

    }
}