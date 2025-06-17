import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

// ✅ 전체 재고 목록 가져오기
export const fetchMain = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/adminMain`, {
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error("🚨 API 요청 중 오류 발생:", error);
        return null;
    }
};