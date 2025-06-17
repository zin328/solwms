package solwms.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import solwms.app.config.SecurityUser;
import solwms.app.dao.UserDao;
import solwms.app.dto.UserDto;

@Service
public class WmsUserDetailsService implements UserDetailsService {

    @Autowired
    private UserDao userDao;

    @Override
    public UserDetails loadUserByUsername(String employeeNumber) throws UsernameNotFoundException {
        UserDto user = userDao.fingById(employeeNumber);
        if (user == null) {
            throw new UsernameNotFoundException(employeeNumber + " 사용자 없음");
        } else {
            return new SecurityUser(user);
        }
    }
}
