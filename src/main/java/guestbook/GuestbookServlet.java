package guestbook;
import java.io.IOException;

import static com.googlecode.objectify.ObjectifyService.ofy;

import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class GuestbookServlet extends HttpServlet{
	
	static {

        ObjectifyService.register(Greeting.class);

    }
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		if(user != null) {
			resp.setContentType("text/plain");
			resp.getWriter().println("Hello," + user.getNickname());
		}else {
			resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
		}
		


		
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
		
	}
}
