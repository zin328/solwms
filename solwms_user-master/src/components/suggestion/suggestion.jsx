import { useEffect, useState } from "react";
import { fetchSuggestion, addSuggestion } from "./suggestionApi.js";
import "../suggestion/suggestion.css";

function Suggestion() {
    const [suggestionList, setsuggestionList] = useState([]);
    const [search, setSearch] = useState("");
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [newSuggestion, setNewSuggestion] = useState({ sugTitle: '', sugContent: '' });
    const [isModalOpen, setIsModalOpen] = useState(false); // 모달 열기/닫기 상태


    // useEffect: currentPage 또는 search가 변경될 때마다 API를 호출하여 공지사항 데이터를 가져옵니다.
    useEffect(() => {
        fetchSuggestion(currentPage, search).then(data => {
            setsuggestionList(data.suggestionList || []);
            setTotalPages(data.totalPages || 1);
        });
    }, [currentPage]); // currentPage가 변경될 때마다 호출되도록


    const handleSearch = (e) => {
        e.preventDefault();
        setCurrentPage(1); // 검색 시 첫 페이지로 이동
        fetchSuggestion(1, search).then(data => { // 검색 후 첫 페이지부터 표시
            setsuggestionList(data.suggestionList || []);
            setTotalPages(data.totalPages || 1);
        });
    };

    const handleAddSuggestion = async () => {
        if (!newSuggestion.sugTitle || !newSuggestion.sugContent) {
            alert("제목과 내용을 입력해 주세요.");
            return;
        }

        const response = await addSuggestion(newSuggestion.sugTitle, newSuggestion.sugContent);
        if (response) {
            alert("건의사항이 성공적으로 추가되었습니다!");
            setNewSuggestion({ sugTitle: '', sugContent: '' }); // 입력값 초기화
            setIsModalOpen(false); // 모달 닫기

            // ✅ 목록 갱신 (추가 후 최신 데이터를 다시 가져오기)
            const updatedData = await fetchSuggestion(1, search);
            setsuggestionList(updatedData.suggestionList || []);
            setTotalPages(updatedData.totalPages || 1);
        } else {
            alert("건의사항 추가에 실패했습니다.");
        }
    };

    const openModal = () => {
        setIsModalOpen(true); // 모달 열기
    };

    const closeModal = () => {
        setIsModalOpen(false); // 모달 닫기
    };


    return (




        <div className="suggestion-container">
            <h1>건의사항</h1>

            {/* 검색창 */}
            <div className="search-container">
                <div onSubmit={handleSearch} className="search-btn">
                    <input
                        type="text"
                        placeholder="검색어 입력"
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                    />
                    <button type="submit" >검색</button>
                    {/* + 버튼을 클릭하면 모달 열기 */}
                    <button onClick={openModal} className="add-sugg-btn">+</button>
                </div>
            </div>

            {/* 건의의사항 목록 */}
            <table className="suggestion-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                    </tr>
                </thead>
                <tbody>
                    {suggestionList.length === 0 ? (
                        <tr>
                            <td colSpan="3">공지사항이 없습니다.</td>
                        </tr>
                    ) : (
                        suggestionList
                            .filter((s) => s !== undefined && s !== null)
                            .map((suggestion) => (
                                <tr key={String(suggestion.sugNumber)}>
                                    <td>{suggestion.sugNumber}</td>
                                    <td>
                                        <a href={`/adminMain/suggContent?sugNumber=${suggestion.sugNumber}`} className="suggestion-title">
                                            {suggestion.sugTitle}
                                        </a>
                                    </td>
                                    <td>{suggestion.user_name}</td>
                                </tr>
                            ))
                    )}
                </tbody>
            </table>

            {/* 페이지네이션 */}
            <div className="pagination">
                {currentPage > 1 && (
                    <button onClick={() => setCurrentPage(currentPage - 1)}>« 이전</button>
                )}

                {/* 숫자 버튼 생성 */}
                {Array.from({ length: totalPages }, (_, index) => index + 1).map(page => (
                    <button
                        key={page}
                        onClick={() => setCurrentPage(page)}
                        className={currentPage === page ? "active" : ""}
                    >
                        {page}
                    </button>
                ))}
                {/* 다음 >> 버튼 */}
                {currentPage < totalPages && (
                    <button onClick={() => setCurrentPage(currentPage + 1)}>다음 »</button>
                )}


            </div>



            {/* 모달 창 */}
            {isModalOpen && (
                <div className="modal-overlay">
                    <div className="modal">
                        <h2>건의사항 추가</h2>
                        <input
                            type="text"
                            placeholder="제목"
                            value={newSuggestion.sugTitle}
                            onChange={(e) => setNewSuggestion({ ...newSuggestion, sugTitle: e.target.value })}
                        />
                        <textarea
                            placeholder="내용"
                            value={newSuggestion.sugContent}
                            onChange={(e) => setNewSuggestion({ ...newSuggestion, sugContent: e.target.value })}
                        />
                        <div className="button-container2">
                            <button onClick={handleAddSuggestion}>추가</button>
                            <button onClick={closeModal}>취소</button>
                        </div>
                    </div>
                </div>
            )}
        </div>

    );
}
export default Suggestion;