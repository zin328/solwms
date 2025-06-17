package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import solwms.app.service.BoardCommentService;
import solwms.app.service.SuggService;
import solwms.app.dto.BoardCommentDto;
import solwms.app.dto.NoticeDto;
import solwms.app.dto.SuggDto;
import java.util.List;

@Controller
public class SuggController {

    @Autowired
    private SuggService suggestionService;
    
    @Autowired
    private BoardCommentService boardCommentService;

    // ✅ 건의사항 리스트를 JSON으로 반환하는 엔드포인트
    @GetMapping("/suggestion/json")
    public List<SuggDto> getAllSuggestionsJson() {
        return suggestionService.getAllSuggestions();
    }

    // ✅ 기존의 건의사항 리스트를 HTML 페이지로 반환하는 엔드포인트
    @GetMapping("/suggestion")
    public String showSuggestionPage(@RequestParam(value = "page", defaultValue = "1") int page,
    								  @RequestParam(value = "search", required=false) String search,
    								  Model model) {
        int pageSize = 15;
        
        
        List<SuggDto> suggestionList;
        if (search != null && !search.isEmpty()) {
        	suggestionList = suggestionService.getSuggestionBySearch(page, pageSize, search);
        }else {
        	suggestionList =suggestionService.getSuggestionsByPage(page, pageSize);
        }
        
        
        int totalSuggestions = (search != null && !search.isEmpty()) ?
        		suggestionService.getSearchResultsCount(search) :
        		suggestionService.getTotalSuggestionCount();
        
        
        int totalPages = (int) Math.ceil((double) totalSuggestions / pageSize);

        model.addAttribute("suggestionList", suggestionList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("search", search);

        return "adminMain/Suggestion";
    }

    // ✅ 건의사항 추가 API
    @PostMapping("/adminMain/addSuggestion")
    public String addSuggestion(@RequestParam("suggestion-title") String sugTitle, 
                                @RequestParam("suggestion-content") String sugContent, 
                                Model model) {

        suggestionService.addSuggestion(sugTitle, sugContent);
        List<SuggDto> suggestionList = suggestionService.getAllSuggestions();
        model.addAttribute("suggestionList", suggestionList);
        return "adminMain/Suggestion"; // 추가된 최신 건의사항 반환
    }

    // ✅ 건의사항 상세 조회 (sugNumber에 해당하는 건의사항 데이터 가져오기)
    @GetMapping("/adminMain/suggContent")
    public String getSuggestionDetail(@RequestParam("sugNumber") int sugNumber, Model model) {
    	
    	SuggDto suggestion = suggestionService.getSuggestionById(sugNumber);
        model.addAttribute("suggestion", suggestion);
        
        //해당 건의사항에 댓글 목록 가져오기
        List<BoardCommentDto> comments = boardCommentService.getCommentsBySugNumber(sugNumber);
        model.addAttribute("comments", comments);
        
        return "adminMain/suggContent";  // ✅ JSP 파일 경로 수정
    }
    
    // 댓글 추가 api 
    @PostMapping("/adminMain/addComment")
    public String addComment(@RequestParam("sugNumber") int sugNumber,
    						@RequestParam("comment-content") String commentContent,
    						Model model) {
    	
    	boardCommentService.addComment(sugNumber, commentContent);
    	
    	return "redirect:/adminMain/suggContent?sugNumber=" + sugNumber; 
    }
    
    // 댓글 삭제 
    @PostMapping("/adminMain/deleteComment")
    public String deleteComment(@RequestParam("commentNumber") int commentNumber, 
                                @RequestParam("sugNumber") int sugNumber) {
        
        // 댓글 삭제
        boardCommentService.deleteComment(commentNumber);

        // 해당 건의사항 상세 페이지로 리다이렉트
        return "redirect:/adminMain/suggContent?sugNumber=" + sugNumber;
    }
    
    
    // 수정된 건의사항 저장
    @PostMapping("/adminMain/updateSuggestion")
    public String updateSuggestion(@RequestParam("sugNumber") int sugNumber,
                               @RequestParam("suggestion-title") String sugTitle,
                               @RequestParam("suggestion-content") String sugContent) {
        
        // 건의사항 수정
        SuggDto suggestion = suggestionService.getSuggestionById(sugNumber);
        if (suggestion != null) {
        	suggestion.setSugTitle(sugTitle);
        	suggestion.setSugContent(sugContent);
        	suggestionService.updateSuggestion(suggestion);
        }

        // 수정 후 건의사항 상세 페이지로 리다이렉트
        return "redirect:/adminMain/suggContent?sugNumber=" + sugNumber;
    }
    
    // 건의사항 삭제
    @PostMapping("/adminMain/deleteSuggestion")
    public String deleteSuggestion(@RequestParam("sugNumber") int sugNumber) {
        suggestionService.deleteSuggestion(sugNumber);
        // 삭제 후 건의사항 목록 페이지로 리다이렉트
        return "redirect:/suggestion";
    }
    
}
