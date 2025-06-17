package solwms.app.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import solwms.app.dto.UserDto;
import solwms.app.service.UserService;
import solwms.app.service.WareHouseService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class userLoginController {

    @Autowired
    private UserService userService;

    @Autowired
    private WareHouseService wareHouseService;

    @PostMapping("/changePassword")
    public void changedPassword(@RequestParam("newPassword") String newPassword){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        UserDto user = new UserDto();
        user.setEmployeeNumber(employeeNumber);
        user.setUser_password(newPassword);
        userService.editPassword(user);
    }

    @GetMapping("/userinfo")
    public ResponseEntity<Map<String, Object>> userInfoP(){
        Map<String, Object> response = new HashMap<>();
        response.put("userInfo",userService.userInfo());
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userid = authentication.getName();
        response.put("wareName",wareHouseService.findWareHouse(userid));
        return ResponseEntity.ok(response);
    }
}
