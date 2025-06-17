package solwms.app.service;

import org.springframework.stereotype.Service;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import lombok.RequiredArgsConstructor;
import solwms.app.dao.NoticeDao;
import solwms.app.dto.NoticeDto;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeService {
    private final NoticeDao noticeDao;
    
    // 검색어가 있을 경우 해당 제목을 포함하는 공지사항만 반환
    public List<NoticeDto> getNoticesBySearch(int page, int pageSize, String search) {
        return noticeDao.getNoticesBySearch(search, (page - 1) * pageSize, pageSize);
    }
    // 검색된 공지사항 수 반환
    public int getSearchResultsCount(String search) {
        return noticeDao.getCountBySearch(search);
    }
    
    // ✅ 공지사항 추가
    public void addNotice(String title, String content) {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    	String employeeNumber = null;
    	
    	if (auth != null && auth.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) auth.getPrincipal();
            employeeNumber = userDetails.getUsername(); // ✅ 로그인한 사용자 ID
        }

        if (employeeNumber == null) {
            throw new IllegalStateException("로그인 정보 없음");
        }
    	
        NoticeDto notice = new NoticeDto();
        notice.setTitle(title);
        notice.setContent(content);
        notice.setEmployeeNumber(employeeNumber);
        
        //공지사항 저장
        noticeDao.insertNotice(notice);
    }

    // ✅ 모든 공지사항 가져오기 (postNumber 역순 정렬)
    public List<NoticeDto> getAllNotices() {
        List<NoticeDto> notices = noticeDao.getAllNotices();
        return notices;
    }
    

    // ✅ 최신 공지사항 1개 가져오기
    public List<NoticeDto> getLatestNotice() {
        return noticeDao.getAllNotices();
    }
    
    public NoticeDto getNoticeById(int postNumber) {
    	return noticeDao.getNoticeById(postNumber);
    }
    
    public List<NoticeDto> getNoticesByPage(int page, int pagesize){
    	List<NoticeDto> allNotices = getAllNotices();
    	int totalNotices = allNotices.size();
    	
    	int start = (page -1) * pagesize;
    	int end = Math.min(start + pagesize, totalNotices);
    	
    	return allNotices.subList(start, end);
    }
    
    public int getTotalNoticeCount() {
    	return getAllNotices().size();
    }
    
    
    //메인 공지사항 리스트 
    public List<NoticeDto> getTopNotice() {
    	return noticeDao.getTopNotice();
    }
    
    //공지사항 수정
    public void updateNotice(NoticeDto notice) {
    	noticeDao.updateNotice(notice);
    }
    
    //공지사항 삭제
    public void deleteNotice(int postNumber) {
    	noticeDao.deleteNotice(postNumber);
    }
 
 

}



