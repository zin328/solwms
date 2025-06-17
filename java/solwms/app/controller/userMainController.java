package solwms.app.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import solwms.app.dto.NoticeDto;
import solwms.app.dto.ProductDto;
import solwms.app.dto.SuggDto;
import solwms.app.service.NoticeService;
import solwms.app.service.ProductService;
import solwms.app.service.SuggService;

@RestController
@RequestMapping("api")
public class userMainController {

    @Autowired
    private ProductService productservice;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private SuggService suggestionService;



    @GetMapping("/adminMain")
    public ResponseEntity<Map<String, Object>> getInventory() {
        Map<String, Object> response = new HashMap<>();

        List<ProductDto> inventoryList = productservice.getUserInventoryList();
        response.put("inventoryList", inventoryList); // 데이터 전달

        List<NoticeDto> topNotices = noticeService.getTopNotice();
        response.put("topNotices", topNotices);

        List<SuggDto> topSuggestion = suggestionService.getTopSuggestion();
        response.put("topSuggestion", topSuggestion);

        return ResponseEntity.ok(response);
    }

    //공지사항
    @GetMapping("/adminMain/Announcement")
    public ResponseEntity<Map<String, Object>> announPage() {
        Map<String, Object> response = new HashMap<>();
        List<NoticeDto> noticeList = noticeService.getAllNotices();
        response.put("noticeList", noticeList);
        return ResponseEntity.ok(response);
    }

    /* 건의사항 */
    @GetMapping("/adminMain/Suggestion")
    public ResponseEntity<Map<String, Object>> suggestionPage() {
        Map<String, Object> response = new HashMap<>();
        List<SuggDto> suggestionList = suggestionService.getAllSuggestions();
        response.put("suggestionList", suggestionList);
        return ResponseEntity.ok(response);
    }

}

