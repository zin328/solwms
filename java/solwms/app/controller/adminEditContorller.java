package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import solwms.app.dto.Role;
import solwms.app.dto.UserDto;
import solwms.app.dto.WareHouse;
import solwms.app.service.UserService;
import solwms.app.service.WareHouseService;

import java.util.List;

@Controller
public class adminEditContorller {

    @Autowired
    private UserService userService;

    @Autowired
    private WareHouseService wareHouseService;

    @GetMapping("/admin/userEdit")
    public String userEdit(@RequestParam(name="p", defaultValue = "1") int page, Model m) {
        int count = userService.count();
        m.addAttribute("page", page-1);
        if(count>0){
            int perPage = 10;
            int startRow = (page - 1) * perPage;
            List<UserDto> userList = userService.selectUserAll(startRow);
            m.addAttribute("userList", userList);
            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0);
            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum - 1;
            if (end > totalPages) {
                end = totalPages;
            }
            m.addAttribute("begin", begin);
            m.addAttribute("end", end);
            m.addAttribute("pageNum", pageNum);
            m.addAttribute("totalPages", totalPages);
            m.addAttribute("pa",page);
        }

        m.addAttribute("count", count);
        return "/adminLogin/userEdit";
    }

    @RequestMapping("/admin/searchuserEdit")
    public String searchUser(@RequestParam(name="p", defaultValue = "1") int page,@RequestParam("search") String search ,Model m){
        int count = userService.countSearch(search);
        m.addAttribute("page", page-1);

        if(count>0){

            int perPage = 10;
            int startRow = (page - 1) * perPage;
            List<UserDto> userList = userService.searchUser(search,startRow);
            m.addAttribute("userList", userList);
            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0);
            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum - 1;
            if (end > totalPages) {
                end = totalPages;
            }
            m.addAttribute("begin", begin);
            m.addAttribute("end", end);
            m.addAttribute("pageNum", pageNum);
            m.addAttribute("totalPages", totalPages);
        }
        m.addAttribute("count", count);
        m.addAttribute("search", search);
        m.addAttribute("pa",page);
        return "/adminLogin/userEdit";
    }

    @PostMapping("/admin/userAdd")
    public String userAdd(@RequestParam("employeeNumber") String employeeNumber,
                          @RequestParam("user_name") String user_name,
                          @RequestParam("phone") String phone,
                          @RequestParam("role") Role role,
                          @RequestParam("address") String address,
                          @RequestParam(name="p", defaultValue = "1") int page,
                          Model m) {
        UserDto user = new UserDto();
        user.setEmployeeNumber(employeeNumber);
        user.setUser_name(user_name);
        user.setUser_password(employeeNumber);
        user.setPhone(phone);
        user.setRole(role);
        user.setAddress(address);
        userService.addUser(user);
        WareHouse ware = new WareHouse();
        ware.setWareName(user_name+"창고");
        ware.setAddress(address);
        ware.setEmployeeNumber(employeeNumber);
        wareHouseService.createWareHouse(ware);
        int count = userService.count();
        m.addAttribute("page", page-1);
        if(count>0){
            int perPage = 10;
            int startRow = (page - 1) * perPage;
            List<UserDto> userList = userService.selectUserAll(startRow);
            m.addAttribute("userList", userList);
            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0);
            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum - 1;
            if (end > totalPages) {
                end = totalPages;
            }
            m.addAttribute("begin", begin);
            m.addAttribute("end", end);
            m.addAttribute("pageNum", pageNum);
            m.addAttribute("totalPages", totalPages);
        }

        m.addAttribute("count", count);
        m.addAttribute("pa",page);
        return "/adminLogin/userEdit";
    }

    @PostMapping("/admin/userDelete")
    public String userDelete(@RequestParam("id") String id, RedirectAttributes redirectAttributes) {
        System.out.println("삭제 요청 ID: " + id); // 로그 추가
        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("message", "삭제 완료되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "삭제 실패: " + e.getMessage());
        }

        return "redirect:/admin/userEdit"; // 삭제 후 자동으로 userList 페이지로 이동
    }

    @PostMapping("/admin/resetPassword")
    public String resetPassword(@RequestParam("id") String id, RedirectAttributes redirectAttributes){
        try {
            UserDto user = new UserDto();
            user.setEmployeeNumber(id);
            user.setUser_password(id);
            userService.editPassword(user);
            redirectAttributes.addFlashAttribute("message", "초기화 성공.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "초기화 실패: " + e.getMessage());
        }
        return "redirect:/admin/userEdit"; // 삭제 후 자동으로 userList 페이지로 이동
    }

    @GetMapping("/adminInfo")
    public String adminInfo(Model m){
        m.addAttribute("user",userService.userInfo());
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userid = authentication.getName();
        m.addAttribute("wareName",wareHouseService.findWareHouse(userid));
        return "/adminLogin/adminInfo";
    }




}
