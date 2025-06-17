import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

// ✅ 전체 재고 목록 가져오기
export const fetchStockData = async (page = 1) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/stock/stockall?p=${page}`, {
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error("🚨 API 요청 중 오류 발생:", error);
        return null;
    }
};
// 검색창
export const fetchSearchStock = async (search = "", searchType = "productName", page = 1) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/stock/search`, {
            params: {
                searchType,
                search,
                p: page
            },
            withCredentials: true
        });
        return response.data;
    } catch (error) {
        console.error("Error fetching search data:", error.response ? error.response.data : error.message);
        return null;
    }

};

export const fetchStockRequest = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/stock/request`, {
            withCredentials: true
        });
        return response.data;
    } catch (error) {
        console.error("Error fetching stock request data:", error.response ? error.response.data : error.message);
        return null;
    }
};

export const createOrder = async (orders) => {
    console.log("🚀 서버로 보낼 주문 데이터:", orders);

    try {
        const response = await axios.post(`${API_BASE_URL}/stock/createOrder`, orders, {
            headers: {
                "Content-Type": "application/json",
            },
            withCredentials: true, // ✅ 인증 정보 포함
        });

        console.log("📌 서버 응답 상태 코드:", response.status);
        console.log("📌 서버 응답 결과:", response.data);

        return { success: true, message: response.data }; // ✅ 성공 응답
    } catch (error) {
        console.error("🚨 주문 저장 실패:", error);

        if (error.response) {
            console.error("❌ 서버 응답 오류:", error.response.data);
            return { success: false, message: error.response.data };
        }

        return { success: false, message: "서버 연결 실패" };
    }
};

export const fetchMainStockSummary = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/stock/mainStock`, {
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error("🚨 메인 창고 요약 데이터 요청 중 오류 발생:", error.response ? error.response.data : error.message);
        return null;
    }
};