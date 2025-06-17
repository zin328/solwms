package solwms.app.config;

import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.User;
import solwms.app.dto.UserDto;


public class SecurityUser extends User {
    private static final long serialVersionUID = 1L;
    private UserDto users;

    public SecurityUser(UserDto users) {
        super(String.valueOf(users.getEmployeeNumber()), users.getUser_password(),
                AuthorityUtils.createAuthorityList(users.getRole().toString()));
        this.users = users;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public UserDto getUsers() {
        return users;
    }
}
