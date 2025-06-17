import { useEffect, useState } from "react";
import { fetchMain } from "./mainApi.js";
import { useNavigate } from "react-router-dom";
import "../main/main.css";


function Main() {
    const [topSuggestion, setTopSuggestion] = useState([]);
    const [topNotices, setTopNotices] = useState([]);
    const [inventoryList, setInventoryList] = useState([]);
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        setLoading(true);
        fetchMain().then(data => {
            setTopSuggestion(data.topSuggestion);
            setTopNotices(data.topNotices);
            setInventoryList(data.inventoryList);
            setLoading(false);
        }
        )

    }, []);
    // 공지사항 제목 클릭 시 /notices로 이동하는 함수
    const handleNoticeTitleClick = () => {
        window.location.href = "/notices"; // "/notices" 페이지로 이동
    };
    // 공지사항 제목 클릭 시 /suggestion로 이동하는 함수
    const handleSuggestionTitleClick = () => {
        window.location.href = "/suggestion"; // "/notices" 페이지로 이동
    };



    // 공지사항 제목 클릭 시 상세 페이지로 이동 (postNumber를 쿼리 파라미터로 전달)
    const handleNoticeDetail = (postNumber) => {
        navigate(`/adminMain/announceContent?postNumber=${postNumber}`);
    };

    // 건의사항 제목 클릭 시 상세 페이지로 이동 (sugNumber를 쿼리 파라미터로 전달)
    const handleSuggestionDetail = (sugNumber) => {
        navigate(`/adminMain/suggContent?sugNumber=${sugNumber}`);
    };

    console.log(topSuggestion);

    return (
        <div className="main-container">
            <div className="notice-container">
                {/*공지사항 */}
                <section className="notice">
                    <h2 onClick={handleNoticeTitleClick} style={{ cursor: 'pointer' }}>공지사항</h2>
                    <ul>
                        {topNotices.length > 0 ? (
                            topNotices.map((notice, index) => (
                                <li
                                    key={index}
                                    onClick={() => handleNoticeDetail(notice.postNumber)}
                                    style={{ cursor: 'pointer' }}
                                >
                                    {notice.title}
                                </li>
                            ))
                        ) : (
                            <li>공지사항 없음</li>
                        )}
                    </ul>
                </section>

                {/*건의사항 */}
                <section className="notice2">
                    <h2 onClick={handleSuggestionTitleClick} style={{ cursor: 'pointer' }}>건의사항</h2>
                    <ul>
                        {topSuggestion.length > 0 ? (
                            topSuggestion.map((suggestion, index) => (
                                <li
                                    key={index}
                                    onClick={() => handleSuggestionDetail(suggestion.sugNumber)}
                                    style={{ cursor: 'pointer' }}
                                >
                                    {suggestion.sugTitle}
                                </li>
                            ))
                        ) : (
                            <li>건의사항 없음</li>
                        )}
                    </ul>
                </section>
            </div>

            {/*재고현황 */}
            <section className="inventory">
                <h2>재고현황</h2>

                <div className="progress-bar2">
                    {inventoryList.length === 0 ? (
                        <p>20 이하의 재고가 없습니다.</p>
                    ) : (
                        inventoryList.map((item) => {
                            if (item.quantity <= 20) {
                                let width = Math.max((item.quantity / 20) * 300, 20);
                                return (
                                    <div className="progress-item" key={item.productId}>
                                        <a href={`/detail/${item.productId}`} className="progress-name"
                                            style={{ textDecoration: "none", color: "inherit" }}>
                                            {item.productName}
                                        </a>
                                        <div
                                            className="bar2"
                                            style={{
                                                width: `${width}px`,
                                                backgroundColor: item.quantity >= 10 ? "#FFA500" : "red",
                                            }}
                                        >
                                            {item.quantity}
                                        </div>
                                    </div>
                                );
                            }
                            return null;
                        })
                    )}
                </div>
            </section>
        </div>

    );
};

export default Main;
