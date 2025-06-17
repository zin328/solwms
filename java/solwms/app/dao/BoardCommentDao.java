package solwms.app.dao;

import org.apache.ibatis.annotations.*;
import solwms.app.dto.BoardCommentDto;

import java.util.List;

@Mapper
public interface BoardCommentDao {

    // 특정 건의사항에 대한 댓글 목록 가져오기
    @Select("SELECT commentNumber, sugNumber, commentContent FROM BoardComment WHERE sugNumber = #{sugNumber}")
    List<BoardCommentDto> getCommentsBySugNumber(int sugNumber);

    // 댓글 추가
    @Insert("INSERT INTO BoardComment (sugNumber, commentContent) VALUES (#{sugNumber}, #{commentContent})")
    @Options(useGeneratedKeys = true, keyProperty = "commentNumber")
    void insertComment(BoardCommentDto comment);
    
    // 댓글 삭제 쿼리
    @Delete("DELETE FROM BoardComment WHERE commentNumber = #{commentNumber}")
    void deleteComment(int commentNumber);
}

