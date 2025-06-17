import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;


export const productDetail = async (productId, page = 1) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/detail/${productId}`, {
            params: { p: page }, // 페이지 번호 추가
            withCredentials: true, // 쿠키 포함 (필요한 경우)
        });
        console.log("✅ API Response Data:", response.data); // 응답 데이터 확인
        return response.data;
    } catch (error) {
        console.error("❌ Error fetching product details:", error);
        return null;
    }
};
