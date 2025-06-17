import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;


export const fetchInoutHistory = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/userProductHistory`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}

export const fetchReturnHistory = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/return`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}



// ✅ 반납 데이터 제출
export const submitReturnData = async (returnData) => {
    try {
        const response = await fetch("http://localhost:8081/api/return/submit", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: new URLSearchParams(returnData).toString(),
            mode: "cors", // 🔥 CORS 모드 추가
            credentials: "include", // 🔥 쿠키 포함 (필요 시)
        });

        if (!response.ok) {
            throw new Error("반납 요청 실패");
        }
        return await response.json();
    } catch (error) {
        console.error("반납 요청 중 오류 발생:", error);
        throw error;
    }
};



export const userSelectProduct  = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/return/select`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}

export const searchProduct  = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/return/search`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}
