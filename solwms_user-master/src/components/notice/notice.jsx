import { useEffect, useState } from "react";
import { fetchNotices } from "./noticeApi.js";
import "../notice/notice.css";


function Notice() {
    const [noticeList, setNoticeList] = useState([]);
    const [search, setSearch] = useState("");
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);

    // useEffect: currentPage 또는 search가 변경될 때마다 API를 호출하여 공지사항 데이터를 가져옵니다.
    useEffect(() => {
        fetchNotices(currentPage, search).then(data => {
            setNoticeList(data.noticeList || []);
            setTotalPages(data.totalPages || 1);

        });
    }, [currentPage]); // currentPage가 변경될 때마다 호출되도록


    const handleSearch = (e) => {
        e.preventDefault();
        setCurrentPage(1); // 검색 시 첫 페이지로 이동
        fetchNotices(1, search).then(data => { // 검색 후 첫 페이지부터 표시
            setNoticeList(data.noticeList || []);
            setTotalPages(data.totalPages || 1);
        });
    };

    return (

        <div className="notice-container2">
            <h1>공지사항</h1>

            {/* 검색창 */}
            <div className="search-container">
                <div onSubmit={handleSearch} className="search-btn">
                    <input
                        type="text"
                        placeholder="검색어 입력"
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                    />
                    <button type="submit">검색</button>
                </div>
            </div>

            {/* 공지사항 목록 */}
            <table className="notice-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                    </tr>
                </thead>
                <tbody>
                    {noticeList.length === 0 ? (
                        <tr>
                            <td colSpan="3">공지사항이 없습니다.</td>
                        </tr>
                    ) : (
                        noticeList.map((notice) => (
                            <tr key={notice.postNumber}>
                                <td>{notice.postNumber}</td>
                                <td>
                                    <a href={`/adminMain/announceContent?postNumber=${notice.postNumber}`} className="notice-title">
                                        {notice.title}
                                    </a>
                                </td>
                                <td>{notice.user_name}</td>
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
        </div>

    );
}

export default Notice;