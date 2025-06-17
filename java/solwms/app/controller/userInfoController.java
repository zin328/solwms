package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import solwms.app.dto.UserDto;
import solwms.app.service.UserService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class userInfoController {
    @Autowired
    private UserService userService;

    @GetMapping("/user")
    public ResponseEntity<Map<String, Object>> userInfo(){
        Map<String, Object> response = new HashMap<>();
        UserDto userinfo = new UserDto();
        userinfo = userService.userInfo();
        response.put("id", userinfo.getEmployeeNumber());
        response.put("name",userinfo.getUser_name());
        return ResponseEntity.ok(response);
    }
}