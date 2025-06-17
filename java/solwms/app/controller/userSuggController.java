package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import solwms.app.service.BoardCommentService;
import solwms.app.service.SuggService;
import solwms.app.dto.BoardCommentDto;
import solwms.app.dto.NoticeDto;
import solwms.app.dto.SuggDto;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("api")
public class userSuggController {


    @Autowired
    private SuggService suggestionService;
    
    @Autowired
    private BoardCommentService boardCommentService;

    // ✅ 공지사항 리스트를 JSON으로 반환하는 엔드포인트
    @GetMapping("/suggestion/json")
    public List<SuggDto> getAllSuggestionsJson() {
        return suggestionService.getAllSuggestions();
    }

    // ✅ 기존의 공지사항 리스트를 HTML 페이지로 반환하는 엔드포인트
    @GetMapping("/suggestion")
    public ResponseEntity<Map<String, Object>> showSuggestionPage(@RequestParam(value = "page", defaultValue = "1") int page,
                                       @RequestParam(value ="search", required = false) String search) {
        Map<String, Object> response = new HashMap<>();
        int pageSize = 15;

        // 검색어가 있을 경우 검색 기능을 호출하고, 없을 경우 기존의 getNoticesByPage 호출
        List<SuggDto> suggestionList;
        if (search != null && !search.isEmpty()) {
        	suggestionList = suggestionService.getSuggestionBySearch(page, pageSize, search);
        } else {
        	suggestionList = suggestionService.getSuggestionsByPage(page, pageSize);
        }

        // 검색된 공지사항 수 (혹은 전체 공지사항 수)
        int totalSuggestions = (search != null && !search.isEmpty()) ?
        		suggestionService.getSearchResultsCount(search) :
        			suggestionService.getTotalSuggestionCount();

        int totalPages = (int) Math.ceil((double) totalSuggestions / pageSize);

        response.put("suggestionList", suggestionList);
        response.put("currentPage", page);
        response.put("totalPages", totalPages);
        response.put("search", search);

        return ResponseEntity.ok(response);
    }

    // ✅ 공지사항 추가 API
    @PostMapping("/adminMain/addSuggestion")
    public ResponseEntity<Map<String, Object>> addNotice(@RequestBody Map<String, String> suggestionData) {
        String sugTitle = suggestionData.get("suggestionTitle"); // key는 클라이언트에서 보낸 JSON의 키
        String sugContent = suggestionData.get("suggestionContent");

        Map<String, Object> response = new HashMap<>();
        suggestionService.addSuggestion(sugTitle, sugContent);
        List<SuggDto> suggestionList = suggestionService.getAllSuggestions();
        response.put("suggestionList", suggestionList);
        
        return ResponseEntity.ok(response);
    }
    
    // ✅ 공지사항 상세 조회 (postNumber에 해당하는 공지사항 데이터 가져오기)
    @GetMapping("/adminMain/suggContent")
    public ResponseEntity<Map<String, Object>> getSuggestionDetail(@RequestParam("sugNumber") int sugNumber) {
        Map<String, Object> response = new HashMap<>();
        SuggDto suggestion = suggestionService.getSuggestionById(sugNumber);
        List<BoardCommentDto> comments = boardCommentService.getCommentsBySugNumber(sugNumber);
        response.put("suggestion", suggestion);
        response.put("comments", comments);  // 댓글 목록 추가
        
        return ResponseEntity.ok(response);
    }
    // 수정된 공지사항 저장
    @PostMapping("/adminMain/updateSuggestion")
    public ResponseEntity<Map<String, Object>> updateSuggestion(@RequestBody Map<String, String> suggestionData) {
        // 요청 본문에서 데이터를 받아옵니다.
        int sugNumber = Integer.parseInt(suggestionData.get("sugNumber"));
        String sugTitle = suggestionData.get("suggestionTitle");
        String sugContent = suggestionData.get("suggestionContent");

        // 공지사항 수정
        SuggDto suggestion = suggestionService.getSuggestionById(sugNumber);
        if (suggestion != null) {
            suggestion.setSugTitle(sugTitle);
            suggestion.setSugContent(sugContent);
            suggestionService.updateSuggestion(suggestion);
            
            // 성공적으로 수정된 경우
            Map<String, Object> response = new HashMap<>();
            response.put("message", "공지사항이 성공적으로 수정되었습니다.");
            return ResponseEntity.ok(response);
        } else {
            // 공지사항이 없을 경우
            Map<String, Object> response = new HashMap<>();
            response.put("message", "해당 공지사항을 찾을 수 없습니다.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

    /// 건의사항 삭제
    @PostMapping("/adminMain/deleteSuggestion")
    public ResponseEntity<String> deleteSuggestion(@RequestBody Map<String, Integer> payload) {
        Integer sugNumber = payload.get("sugNumber");
        if (sugNumber != null) {
            suggestionService.deleteSuggestion(sugNumber);
            return ResponseEntity.ok("삭제되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("잘못된 요청입니다.");
        }
    }
    
    
    @PostMapping("/adminMain/addComment")
    public ResponseEntity<Map<String, Object>> addComment(@RequestBody Map<String, String> payload) {
        int sugNumber = Integer.parseInt(payload.get("sugNumber"));
        String commentContent = payload.get("commentContent");

        if (commentContent != null && !commentContent.isEmpty()) {
            boardCommentService.addComment(sugNumber, commentContent);

            // 댓글 추가 후 성공 메시지와 최신 댓글 목록 반환
            Map<String, Object> response = new HashMap<>();
            response.put("message", "댓글이 성공적으로 추가되었습니다.");
            response.put("sugNumber", sugNumber);
            response.put("comments", boardCommentService.getCommentsBySugNumber(sugNumber));

            return ResponseEntity.ok(response);
        } else {
            // 댓글 내용이 비어있을 경우 에러 메시지
            Map<String, Object> response = new HashMap<>();
            response.put("message", "댓글 내용을 입력해 주세요.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    // 댓글 삭제 API
    @PostMapping("/adminMain/deleteComment")
    public ResponseEntity<Map<String, Object>> deleteComment(@RequestBody Map<String, Integer> payload) {
        int commentNumber = payload.get("commentNumber");
        int sugNumber = payload.get("sugNumber");

        if (commentNumber > 0) {
            boardCommentService.deleteComment(commentNumber);

            // 댓글 삭제 후 성공 메시지와 최신 댓글 목록 반환
            Map<String, Object> response = new HashMap<>();
            response.put("message", "댓글이 성공적으로 삭제되었습니다.");
            response.put("sugNumber", sugNumber);
            response.put("comments", boardCommentService.getCommentsBySugNumber(sugNumber));

            return ResponseEntity.ok(response);
        } else {
            // 잘못된 댓글 번호일 경우 에러 메시지
            Map<String, Object> response = new HashMap<>();
            response.put("message", "잘못된 댓글 번호입니다.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }
    
    





}

