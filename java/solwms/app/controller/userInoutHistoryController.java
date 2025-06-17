package solwms.app.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import solwms.app.dto.InoutHistory;
import solwms.app.dto.UserDto;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.UserService;
import solwms.app.service.WareHouseService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class userInoutHistoryController {


    @Autowired
    private InoutHistoryService inoutHistoryService;

    @Autowired
    private WareHouseService wareService;


    @GetMapping("/searchProductHistory")
    public ResponseEntity<Map<String, Object>> searchProductHistory(
            @RequestParam(name = "p", defaultValue = "1") int page,
            @RequestParam(name = "category", defaultValue = "", required = false) String category,
            @RequestParam(name = "date1", defaultValue = "", required = false) String date1,
            @RequestParam(name = "date2", defaultValue = "", required = false) String date2,
            @RequestParam(name = "searchKeyword", defaultValue = "", required = false) String searchKeyword,
            @RequestParam(name = "state", defaultValue = "", required = false) String state) {

        Map<String, Object> response = new HashMap<>();


        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        String wareName = wareService.findWareHouse(username);

        // 빈 문자열을 null로 변환
        if (date1.isEmpty()) {
            date1 = null;
        }
        if (date2.isEmpty()) {
            date2 = null;
        }

        int count = inoutHistoryService.countSearchInoutHistory(category, date1, date2, searchKeyword, wareName, state);
        System.out.println("count: " + count);
        if(count > 0) {
            int perPage = 10;
            int start = (page - 1) * perPage;
            List<InoutHistory> inoutHistoryList = inoutHistoryService.searchInout(category, date1, date2, searchKeyword, wareName, state, start);
            response.put("inoutHistoryList", inoutHistoryList);


            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0);
            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum - 1;
            if(end > totalPages) {
                end = totalPages;
            }
            response.put("begin", begin);
            response.put("end", end);
            response.put("pageNum", pageNum);
            response.put("totalPages", totalPages);
        }
        response.put("count", count);
        response.put("category", category);
        response.put("date1", date1);
        response.put("date2", date2);
        response.put("searchKeyword", searchKeyword);
        response.put("wareName", wareName);
        response.put("state", state);
        return ResponseEntity.ok(response);
    }
}
