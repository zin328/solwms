package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import solwms.app.dto.UserDto;
import solwms.app.service.UserService;

@Controller
public class LoginController {

    @Autowired
    private UserService userservice;


    @GetMapping("/login")
    public String login(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("errorMessage", "로그인 실패! 다시 시도하세요.");
        }
        return "/adminLogin/login";
    }


    @GetMapping("/accessDenied")
    public String accessDenied() {
        return "/adminLogin/accessDenied";
    }

    @GetMapping("/admin/changePassword")
    public String changePassword(Model m){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        m.addAttribute("id", employeeNumber);
        return "/adminLogin/editPassword";
    }

    @PostMapping("/admin/changePassword")
    public String changedPassword(@RequestParam("newPassword") String newPassword){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        UserDto user = new UserDto();
        user.setEmployeeNumber(employeeNumber);
        user.setUser_password(newPassword);
        userservice.editPassword(user);
        return "redirect:/";
    }



}
