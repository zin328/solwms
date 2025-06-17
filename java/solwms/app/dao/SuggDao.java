package solwms.app.dao;

import org.apache.ibatis.annotations.*;
import java.util.List;

import solwms.app.dto.NoticeDto;
import solwms.app.dto.SuggDto;

@Mapper
public interface SuggDao {
    // ✅ 건의사항 추가
    @Insert("INSERT INTO Suggestion (sugTitle, sugContent, employeeNumber) VALUES (#{sugTitle}, #{sugContent}, #{employeeNumber})")
    @Options(useGeneratedKeys = true, keyProperty = "sugNumber")
    void insertSuggestion(SuggDto suggestion);

    // ✅ sugNumber 역순으로 건의사항 리스트 가져오기
    @Select("""
    	    SELECT n.sugNumber, n.sugTitle, n.sugContent, n.employeeNumber, u.user_name
    	    FROM Suggestion n
    	    JOIN User u ON n.employeeNumber = u.employeeNumber
    	    ORDER BY n.sugNumber DESC
    	""")
    List<SuggDto> getAllSuggestions();

    // ✅ 최신 건의사항 1개 가져오기
    @Select("SELECT sugNumber, sugTitle FROM Suggestion ORDER BY sugNumber DESC LIMIT 1")
    SuggDto getLatestSuggestion();
    
    // ✅ 특정 건의사항 가져오기
    @Select("SELECT sugNumber, sugTitle, sugContent FROM Suggestion WHERE sugNumber = #{sugNumber}")
    SuggDto getSuggestionById(@Param("sugNumber") int sugNumber);

    // ✅ 제목으로 공지사항 검색 (검색어와 페이지네이션)
    @Select("""
    	    SELECT n.sugNumber, n.sugTitle, n.sugContent, n.employeeNumber, u.user_name
    	    FROM Suggestion n
    	    JOIN User u ON n.employeeNumber = u.employeeNumber
    	    WHERE n.sugTitle LIKE CONCAT('%', #{search}, '%')
    	    ORDER BY n.sugNumber DESC
    	    LIMIT #{offset}, #{limit}
    	""")
    List<SuggDto> getSuggestionBySearch(@Param("search") String search, @Param("offset") int offset, @Param("limit") int limit);

    // ✅ 제목으로 공지사항 검색된 수
    @Select("SELECT COUNT(*) FROM Suggestion WHERE sugTitle LIKE CONCAT('%', #{search}, '%')")
    int getCountBySearch(String search);
    
    @Select("SELECT sugNumber, sugTitle FROM Suggestion ORDER BY sugNumber DESC LIMIT 5")
    List<SuggDto> getTopSuggestion();
    
    @Update("UPDATE Suggestion SET sugTitle = #{sugTitle}, sugContent = #{sugContent} WHERE sugNumber = #{sugNumber}")
    void updateSuggestion(SuggDto suggestion);
    
    // 건의사항 삭제
    @Delete("DELETE FROM Suggestion WHERE sugNumber = #{sugNumber}")
    void deleteSuggestion(int sugNumber);
}

