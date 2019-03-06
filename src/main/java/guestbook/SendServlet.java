//https://tutorial5-231522.appspot.com/landing_page.jsp
package guestbook;
 
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.googlecode.objectify.*;
import javax.servlet.http.*;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


public class SendServlet extends HttpServlet {
	
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	
    	Properties props = new Properties();
    	Session session = Session.getDefaultInstance(props, null);

    	ObjectifyService.register(Subscribe.class);
    	List<Subscribe> subscribers = ObjectifyService.ofy().load().type(Subscribe.class).list();   

    	try {
    		Message msg = new MimeMessage(session);
    		msg.setFrom(new InternetAddress("rmccray890@gmail.com", "BearBlog Admin"));
    		for(Subscribe subscriber: subscribers){
    			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(subscriber.getEmailAddress(), "Bear Blog User"));
    		}
    		msg.setSubject("Bear Blog Reminder");
    		msg.setText("Don't forget to check out Bear Blog!");
    		Transport.send(msg);
    	} catch (AddressException e) {
    		// ...
    	} catch (MessagingException e) {
    		// ...
    	} catch (UnsupportedEncodingException e) {
    		// ...
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