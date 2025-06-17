import { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { fetchNoticeDetail } from "./noticeApi.js";
import "../notice/notice.css";

const NoticeDetail = () => {
    const [noticeDetail, setNoticeDetail] = useState(null);
    const [loading, setLoading] = useState(true);
    const location = useLocation();
    const navigate = useNavigate();

    useEffect(() => {
        const queryParams = new URLSearchParams(location.search);
        const postNumber = queryParams.get("postNumber");

        if (postNumber) {
            fetchNoticeDetail(postNumber).then((data) => {
                if (data && data.notice) {
                    setNoticeDetail(data.notice);
                } else {
                    console.error('해당 공지사항을 찾을 수 없습니다.');
                }
                setLoading(false);
            });
        } else {
            setLoading(false);
        }
    }, [location]);

    if (loading) {
        return <p>로딩 중...</p>;
    }

    if (!noticeDetail) {
        return <p>해당 공지사항을 찾을 수 없습니다.</p>;
    }

    return (
        <div className="notice-detail-container">
            <div className="content-header">공지사항 상세</div>
            <div className="notice-detail-content">
                <p>제목 : {noticeDetail.title}</p>
                <p>내용 : {noticeDetail.content}</p>
            </div>
            <button onClick={() => navigate('/notices')} className="back-btn">뒤로가기</button>

        </div>
    );
};

export default NoticeDetail;