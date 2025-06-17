import { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { fetchSuggestionDetail, updateSuggestion, deleteSuggestion, addComment, deleteComment } from "./suggestionApi.js";
import "../suggestion/suggestion.css";


const SuggestionDetail = () => {
    const [suggestionDetail, setsuggestionDetail] = useState(null);
    const [loading, setLoading] = useState(true);
    const [isEditMode, setIsEditMode] = useState(false);
    const [newTitle, setNewTitle] = useState("");
    const [newContent, setNewContend] = useState("");
    const [newComment, setNewComment] = useState("");
    const location = useLocation();
    const navigate = useNavigate();

    useEffect(() => {
        const queryParams = new URLSearchParams(location.search);
        const sugNumber = queryParams.get("sugNumber");

        console.log(sugNumber);  // 확인을 위한 로그 출력

        if (sugNumber) {
            fetchSuggestionDetail(sugNumber).then((data) => {
                if (data && data.suggestion) {
                    setsuggestionDetail({ ...data.suggestion, comments: data.comments });
                    setNewTitle(data.suggestion.sugTitle);
                    setNewContend(data.suggestion.sugContent);
                } else {
                    console.error('해당 공지사항을 찾을 수 없습니다.');
                }
                setLoading(false);
            });
        } else {
            setLoading(false);
        }
    }, [location]);



    const handleUpdate = async () => {
        const sugNumber = suggestionDetail.sugNumber;
        const updated = await updateSuggestion(sugNumber, newTitle, newContent);
        if (updated) {
            setsuggestionDetail({ ...suggestionDetail, sugTitle: newTitle, sugContent: newContent });
            alert("건의사항을 수정했습니다.")
            setIsEditMode(false); // 수정 모드 종료
        } else {
            alert("건의사항 수정에 실패했습니다.");
        }
    };

    // 삭제 버튼 클릭 처리
    const handleDelete = async () => {
        const sugNumber = suggestionDetail.sugNumber;
        try {
            const response = await deleteSuggestion(sugNumber); // 삭제 요청
            // 서버에서 응답한 데이터를 확인
            if (response && response === "삭제되었습니다.") {
                alert("건의사항이 삭제되었습니다.");
                navigate("/suggestion"); // 삭제 후 목록으로 돌아가기
            } else {
                alert("삭제에 실패했습니다."); // 실패했을 경우의 처리
            }
        } catch (error) {
            console.error("삭제 요청 중 오류 발생:", error);
            alert("삭제에 실패했습니다."); // 예외 발생 시
        }
    };

    // 댓글 추가
    const handleAddComment = async () => {
        const sugNumber = suggestionDetail.sugNumber;
        if (newComment.trim() === "") {
            alert("댓글을 입력해 주세요.");
            return;
        }

        const response = await addComment(sugNumber, newComment);
        if (response && response.message === "댓글이 성공적으로 추가되었습니다.") {
            alert("댓글이 추가되었습니다.");
            setNewComment(""); // 댓글 입력창 초기화
            // response.comments를 이용해 상태 업데이트
            setsuggestionDetail(prev => ({
                ...prev,
                comments: response.comments
            }));
        } else {
            alert("댓글 추가에 실패했습니다.");
        }
    };




    // 댓글 삭제
    const handleDeleteComment = async (commentNumber) => {
        const confirmed = window.confirm("정말로 이 댓글을 삭제하시겠습니까?");
        if (confirmed) {
            // 현재 페이지의 sugNumber를 함께 전달합니다.
            const response = await deleteComment(commentNumber, suggestionDetail.sugNumber);
            if (response && response.message === "댓글이 성공적으로 삭제되었습니다.") {
                alert("댓글이 삭제되었습니다.");
                // 응답에서 최신 댓글 목록을 받아서 상태 업데이트
                setsuggestionDetail(prev => ({
                    ...prev,
                    comments: response.comments
                }));
            } else {
                alert("댓글 삭제에 실패했습니다.");
            }
        }
    };




    if (loading) {
        return <p>로딩 중...</p>;
    }

    if (!suggestionDetail) {
        return <p>해당 공지사항을 찾을 수 없습니다.</p>;
    }


    return (

        <div className="suggestion-detail-container">
            <div className="content-header">건의사항 상세</div>

            <div className="suggestion-detail-content">
                {isEditMode ? (
                    <>
                        <input
                            type="text"
                            value={newTitle}
                            onChange={(e) => setNewTitle(e.target.value)}
                            className="edit-title"
                        />
                        <textarea
                            value={newContent}
                            onChange={(e) => setNewContend(e.target.value)}
                            className="edit-content"
                        />
                    </>
                ) : (
                    <>
                        <p>제목 : {suggestionDetail.sugTitle}</p>
                        <p>{suggestionDetail.sugContent}</p>
                    </>
                )}

            </div>

            <div className="button-container">
                <button onClick={() => navigate('/suggestion')} className="back-btn">뒤로가기</button>
                {!isEditMode ? (
                    <>
                        <button onClick={() => setIsEditMode(true)}>수정</button>
                        <button onClick={handleDelete}>삭제</button>
                    </>
                ) : (
                    <>
                        <button onClick={handleUpdate}>저장</button>
                        <button onClick={() => setIsEditMode(false)}>취소</button>
                    </>
                )}
            </div>
            <div className="comment-continer">
                {/* 댓글 목록 */}
                <h6>댓글 목록</h6>
                <div className="comment-list">
                    {suggestionDetail.comments && suggestionDetail.comments.length > 0 ? (
                        suggestionDetail.comments.map((comment, index) => (
                            <div key={comment.commentNumber} className="comment-item">
                                <p>{index + 1}. {comment.commentContent}</p>
                                <button onClick={() => handleDeleteComment(comment.commentNumber)}>삭제</button>
                            </div>
                        ))
                    ) : (
                        <p>댓글이 없습니다.</p>
                    )}
                </div>

                {/* 댓글 추가 */}
                <div className="comment-section">
                    <textarea
                        placeholder="댓글을 입력하세요"
                        value={newComment}
                        onChange={(e) => setNewComment(e.target.value)}
                    />
                    <button onClick={handleAddComment}>댓글 추가</button>
                </div>



            </div>
        </div>
    );
};

export default SuggestionDetail;