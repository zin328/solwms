package solwms.app.dao;

import org.apache.ibatis.annotations.*;
import java.util.List;
import solwms.app.dto.NoticeDto;

@Mapper
public interface NoticeDao {
    // ✅ 공지사항 추가
    @Insert("INSERT INTO NoticeBoard (title, content, employeeNumber) VALUES (#{title}, #{content}, #{employeeNumber})")
    @Options(useGeneratedKeys = true, keyProperty = "postNumber")
    void insertNotice(NoticeDto notice);

    // ✅ postNumber 역순으로 공지사항 리스트 가져오기
    @Select("""
    	    SELECT n.postNumber, n.title, n.content, n.employeeNumber, u.user_name
    	    FROM NoticeBoard n
    	    JOIN User u ON n.employeeNumber = u.employeeNumber
    	    ORDER BY n.postNumber DESC
    	""")
    	List<NoticeDto> getAllNotices();

    // ✅ 최신 공지사항 1개 가져오기
    @Select("SELECT postNumber, title FROM NoticeBoard ORDER BY postNumber DESC LIMIT 1")
    NoticeDto getLatestNotice();
    
    // ✅ 특정 공지사항 가져오기
    @Select("SELECT postNumber, title, content FROM NoticeBoard WHERE postNumber = #{postNumber}")
    NoticeDto getNoticeById(@Param("postNumber") int postNumber);
    
    // ✅ 제목으로 공지사항 검색 (검색어와 페이지네이션)
    @Select("""
    	    SELECT n.postNumber, n.title, n.content, n.employeeNumber, u.user_name
    	    FROM NoticeBoard n
    	    JOIN User u ON n.employeeNumber = u.employeeNumber
    	    WHERE n.title LIKE CONCAT('%', #{search}, '%')
    	    ORDER BY n.postNumber DESC
    	    LIMIT #{offset}, #{limit}
    	""")
    List<NoticeDto> getNoticesBySearch(@Param("search") String search, @Param("offset") int offset, @Param("limit") int limit);

    // ✅ 제목으로 공지사항 검색된 수
    @Select("SELECT COUNT(*) FROM NoticeBoard WHERE title LIKE CONCAT('%', #{search}, '%')")
    int getCountBySearch(String search);
    
    //메인 공지사항 리스트
    @Select("SELECT postNumber, title FROM NoticeBoard ORDER BY postNumber DESC LIMIT 5")
    List<NoticeDto> getTopNotice();
    
    //공지사항 업데이트
    @Update("UPDATE NoticeBoard SET title = #{title}, content = #{content} WHERE postNumber = #{postNumber}")
    void updateNotice(NoticeDto notice);
    
    //공지사항 삭제
    @Delete("DELETE FROM NoticeBoard WHERE postNumber = #{postNumber}")
    void deleteNotice(int postNumber);
    
}






