//https://tutorial5-231522.appspot.com/landing_page.jsp
package guestbook;
 
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.*;


public class SubscribeServlet extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		ObjectifyService.register(Subscribe.class);

		String guestbookName = req.getParameter("guestbookName");
		//String email = req.getParameter("content"); 
		boolean deleted = false;
		
	    if (guestbookName == null) {
	        guestbookName = "default";
	    }
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    String email = user.toString();


		List<Subscribe> subscribers = ObjectifyService.ofy().load().type(Subscribe.class).list();   
		for(Subscribe subscriber : subscribers) {
			if(subscriber.getEmailAddress().equals(email)) {
				ofy().delete().entities(subscriber).now();
				deleted = true;
			}
		}
		if(!deleted) {
			Subscribe sub = new Subscribe(email);
			ofy().save().entities(sub).now();  // synchronous
		}

		resp.sendRedirect("/cron_job.jsp");

	}
}
