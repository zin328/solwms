package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import solwms.app.dto.InoutHistory;
import solwms.app.service.InoutHistoryService;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
public class InoutHistoryController {

    @Autowired
    private InoutHistoryService inoutHistoryService;

    @RequestMapping("/productHistory")
    public String productHistory(@RequestParam(name="p", defaultValue = "1") int page, Model m) {

        //글이 있는지 체크
        int count = inoutHistoryService.count();
        if(count > 0) {

            int perPage = 10; // 한 페이지에 보일 글의 갯수
            int startRow = (page - 1) * perPage;

            List<InoutHistory> inoutHistoryList = inoutHistoryService.selectInoutAll(startRow);

            m.addAttribute("inoutHistoryList", inoutHistoryList);

            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0); //전체 페이지 수

            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum -1;
            if(end > totalPages) {
                end = totalPages;
            }
            m.addAttribute("begin", begin);
            m.addAttribute("end", end);
            m.addAttribute("pageNum", pageNum);
            m.addAttribute("totalPages", totalPages);
            m.addAttribute("pa", page);
        }

        m.addAttribute("count", count);
        return "/inoutHistory/productHistory";
    }

    @RequestMapping("/searchProductHistory")
    public String searchProductHistory(
    		@RequestParam(name = "p", defaultValue = "1") int page,
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "date1", required = false) String date1,
            @RequestParam(name = "date2", required = false) String date2,
            @RequestParam(name = "searchKeyword", required = false) String searchKeyword,
            @RequestParam(name = "wareName", required = false) String wareName,
            @RequestParam(name = "state", required = false) String state,
            Model m) {


        // 빈 문자열을 null로 변환
        if (date1.isEmpty()) {
            date1 = null;
        }
        if (date2.isEmpty()) {
            date2 = null;
        }

        int count = inoutHistoryService.countSearchInoutHistory(category, date1, date2, searchKeyword, wareName, state);
        if(count > 0) {
            int perPage = 10;
            int start = (page - 1) * perPage;
            List<InoutHistory> inoutHistoryList = inoutHistoryService.searchInout(category, date1, date2, searchKeyword, wareName, state, start);
            m.addAttribute("inoutHistoryList", inoutHistoryList);


            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0);
            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum - 1;
            if(end > totalPages) {
                end = totalPages;
            }
            m.addAttribute("begin", begin);
            m.addAttribute("end", end);
            m.addAttribute("pageNum", pageNum);
            m.addAttribute("totalPages", totalPages);

        }
        m.addAttribute("count", count);
        m.addAttribute("category", category);
        m.addAttribute("date1", date1);
        m.addAttribute("date2", date2);
        m.addAttribute("searchKeyword", searchKeyword);
        m.addAttribute("wareName", wareName);
        m.addAttribute("state", state);
        m.addAttribute("pa", page);

        return "/inoutHistory/searchProductHistory";
    }
}


