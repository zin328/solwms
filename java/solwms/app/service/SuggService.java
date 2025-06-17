package solwms.app.service;

import org.springframework.stereotype.Service;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import lombok.RequiredArgsConstructor;
import solwms.app.dao.SuggDao;
import solwms.app.dto.SuggDto;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SuggService {
    private final SuggDao suggestionDao;
    
    // 검색어가 있을 경우 해당 제목을 포함하는 공지사항만 반환
    public List<SuggDto> getSuggestionBySearch(int page, int pageSize, String search) {
        return suggestionDao.getSuggestionBySearch(search, (page - 1) * pageSize, pageSize);
    }
    // 검색된 공지사항 수 반환
    public int getSearchResultsCount(String search) {
        return suggestionDao.getCountBySearch(search);
    }

    // ✅ 건의사항 추가
    public void addSuggestion(String sugTitle, String sugContent) {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    	String employeeNumber = null;
    	
    	if (auth != null && auth.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) auth.getPrincipal();
            employeeNumber = userDetails.getUsername(); // ✅ 로그인한 사용자 ID
        }

        if (employeeNumber == null) {
            throw new IllegalStateException("로그인 정보 없음");
        }
    	
    	
    	SuggDto suggestion = new SuggDto();
        suggestion.setSugTitle(sugTitle);
        suggestion.setSugContent(sugContent);
        suggestion.setEmployeeNumber(employeeNumber);
        
        suggestionDao.insertSuggestion(suggestion);
    }

    // ✅ 모든 건의사항 가져오기 (sugNumber 역순 정렬)
    public List<SuggDto> getAllSuggestions() {
        List<SuggDto> suggestions = suggestionDao.getAllSuggestions();
        System.out.println(suggestions);
        return suggestions;
    }

    // ✅ 최신 건의사항 1개 가져오기
    public List<SuggDto> getLatestSuggestion() {
        return suggestionDao.getAllSuggestions();
    }
    
    public SuggDto getSuggestionById(int sugNumber) {
        return suggestionDao.getSuggestionById(sugNumber);
    }
    
    public List<SuggDto> getSuggestionsByPage(int page, int pagesize) {
        List<SuggDto> allSuggestions = getAllSuggestions();
        int totalSuggestions = allSuggestions.size();

        int start = (page - 1) * pagesize;
        if (totalSuggestions == 0 || start >= totalSuggestions) {
            return List.of(); // ❗ 데이터가 없으면 빈 리스트 반환 (예외 방지)
        }
        int end = Math.min(start + pagesize, totalSuggestions);
        return allSuggestions.subList(start, end);
    }

    public int getTotalSuggestionCount() {
        return getAllSuggestions().size();
    }
    
    public List<SuggDto> getTopSuggestion() {
    	return suggestionDao.getTopSuggestion();
    }
    
    //건의사항 수정
    public void updateSuggestion(SuggDto suggestion) {
    	suggestionDao.updateSuggestion(suggestion);
    }
    
    // 건의사항 삭제
    public void deleteSuggestion(int sugNumber) {
        suggestionDao.deleteSuggestion(sugNumber);
    }
 
}
