package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import solwms.app.service.NoticeService;
import solwms.app.dto.NoticeDto;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("api")
public class userNoticeController {


    @Autowired
    private NoticeService noticeService;

    // ✅ 공지사항 리스트를 JSON으로 반환하는 엔드포인트
    @GetMapping("/notices/json")
    public List<NoticeDto> getAllNoticesJson() {
        return noticeService.getAllNotices();
    }

    // ✅ 기존의 공지사항 리스트를 HTML 페이지로 반환하는 엔드포인트
    @GetMapping("/notices")
    public ResponseEntity<Map<String, Object>> showAnnouncementPage(@RequestParam(value = "page", defaultValue = "1") int page,
                                       @RequestParam(value ="search", required = false) String search) {
        Map<String, Object> response = new HashMap<>();
        int pageSize = 15;

        // 검색어가 있을 경우 검색 기능을 호출하고, 없을 경우 기존의 getNoticesByPage 호출
        List<NoticeDto> noticeList;
        if (search != null && !search.isEmpty()) {
            noticeList = noticeService.getNoticesBySearch(page, pageSize, search);
        } else {
            noticeList = noticeService.getNoticesByPage(page, pageSize);
        }

        // 검색된 공지사항 수 (혹은 전체 공지사항 수)
        int totalNotices = (search != null && !search.isEmpty()) ?
                noticeService.getSearchResultsCount(search) :
                noticeService.getTotalNoticeCount();

        int totalPages = (int) Math.ceil((double) totalNotices / pageSize);

        response.put("noticeList", noticeList);
        response.put("currentPage", page);
        response.put("totalPages", totalPages);
        response.put("search", search);

        return ResponseEntity.ok(response);
    }

	/*
	 * // ✅ 공지사항 추가 API
	 * 
	 * @PostMapping("/adminMain/addNotice") public ResponseEntity<Map<String,
	 * Object>> addNotice(@RequestParam("notice-title") String
	 * title, @RequestParam("notice-content") String content) { Map<String, Object>
	 * response = new HashMap<>(); noticeService.addNotice(title, content);
	 * List<NoticeDto> noticeList = noticeService.getAllNotices();
	 * response.put("noticeList", noticeList); return ResponseEntity.ok(response); }
	 */

    // ✅ 공지사항 상세 조회 (postNumber에 해당하는 공지사항 데이터 가져오기)
    @GetMapping("/adminMain/announceContent")
    public ResponseEntity<Map<String, Object>> getNoticeDetail(@RequestParam("postNumber") int postNumber) {
        Map<String, Object> response = new HashMap<>();
        NoticeDto notice = noticeService.getNoticeById(postNumber);
        response.put("notice", notice);
        return ResponseEntity.ok(response);
    }
	/*
	 * // 수정된 공지사항 저장
	 * 
	 * @PostMapping("/adminMain/updateNotice") public void
	 * updateNotice(@RequestParam("postNumber") int postNumber,
	 * 
	 * @RequestParam("notice-title") String title,
	 * 
	 * @RequestParam("notice-content") String content) {
	 * 
	 * // 공지사항 수정 NoticeDto notice = noticeService.getNoticeById(postNumber); if
	 * (notice != null) { notice.setTitle(title); notice.setContent(content);
	 * noticeService.updateNotice(notice); }
	 * 
	 * }
	 * 
	 * //공지사항 삭제
	 * 
	 * @PostMapping("adminMain/deleteNotice") public void
	 * deleteNotice(@RequestParam("postNumber") int postNumber) {
	 * noticeService.deleteNotice(postNumber); }
	 */



}
