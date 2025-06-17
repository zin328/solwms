package solwms.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import solwms.app.dao.UserDao;
import solwms.app.dto.UserDto;

import java.util.List;

@Service
public class UserService{

    @Autowired
    private UserDao userDao;

    @Autowired
    private PasswordEncoder encoder;




    public void editPassword(UserDto user) {
        user.setUser_password(encoder.encode(user.getUser_password()));
        userDao.updateUser(user);
    }

    public int count() {return userDao.countUser();}

    public List<UserDto> selectUserAll(int start) {return userDao.selectUserAll(start);}

    public int countSearch(String search) {return userDao.countSearch(search);}

    public List<UserDto> searchUser(String search, int start) {
        return userDao.searchUser(search, start);
    }

    public void addUser(UserDto user) {
        user.setUser_password(encoder.encode(user.getUser_password()));
        userDao.insertUser(user);
    }

    public UserDto userInfo(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        return userDao.fingById(username);
    }

    public void deleteUser(String id) {
        userDao.deleteUser(id);
    }
}


