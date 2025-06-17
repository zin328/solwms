package solwms.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import solwms.app.dao.BoardCommentDao;
import solwms.app.dto.BoardCommentDto;

import java.util.List;

@Service
public class BoardCommentService {

    @Autowired
    private BoardCommentDao boardCommentDao;

    // 특정 건의사항에 대한 댓글 목록 가져오기
    public List<BoardCommentDto> getCommentsBySugNumber(int sugNumber) {
        return boardCommentDao.getCommentsBySugNumber(sugNumber);
    }

    // 댓글 추가
    public void addComment(int sugNumber, String commentContent) {
        BoardCommentDto comment = new BoardCommentDto();
        comment.setSugNumber(sugNumber);
        comment.setCommentContent(commentContent);
        boardCommentDao.insertComment(comment);
    }
    
    // 댓글 삭제 메서드
    public void deleteComment(int commentNumber) {
        boardCommentDao.deleteComment(commentNumber);
    }
}

