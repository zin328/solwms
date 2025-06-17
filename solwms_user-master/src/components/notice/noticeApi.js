import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const fetchNotices = async (page = 1, search = "") => {
    try {
        const response = await axios.get(`${API_BASE_URL}/notices`, {
            params: {
                page: page,
                search: search
            },
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error("🚨 API 요청 중 오류 발생:", error);
        return null;
    }
};

// 공지사항 상세 정보 가져오기
export const fetchNoticeDetail = async (postNumber) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/adminMain/announceContent`, {
            params: { postNumber: postNumber },
            withCredentials: true,
        });
        return response.data; // API에서 받은 데이터를 반환
    } catch (error) {
        console.error("🚨 공지사항 상세 정보 요청 중 오류 발생:", error);
        return null; // 오류 발생 시 null 반환
    }
};