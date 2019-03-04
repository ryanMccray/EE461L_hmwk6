//https://tutorial5-231522.appspot.com/ofyguestbook.jsp
package guestbook;
 
import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.googlecode.objectify.*;


public class SubscribeServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	
    	ObjectifyService.register(Subscribe.class);

        String guestbookName = req.getParameter("guestbookName");
        String email = req.getParameter("content");
        
        Subscribe new_sub = new Subscribe(email);//, guestbookName);
        ofy().save().entities(new_sub).now();  // synchronous

        resp.sendRedirect("/cron_job.jsp");

    }
}
