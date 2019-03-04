package guestbook;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class Subscribe {
    //@Parent Key<Guestbook> guestbookName;
    @Id Long id;
    @Index User user;
    String email_address;

    public Subscribe(String email_address) {//, String guestbookName) {
        this.email_address = email_address;
        //this.guestbookName = Key.create(Guestbook.class, guestbookName);

    }
    
    public String getEmailAddress() {
        return email_address;
    }
    
}