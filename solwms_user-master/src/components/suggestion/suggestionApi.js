import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const fetchSuggestion = async (page = 1, search = "") => {
    try {
        const response = await axios.get(`${API_BASE_URL}/suggestion`, {
            params: {
                page: page,
                search: search
            },
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error(" API 요청 중 오류 발생:", error);
        return null;
    }
};

// 건의사항 상세 
export const fetchSuggestionDetail = async (sugNumber) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/adminMain/suggContent`, {
            params: { sugNumber: sugNumber },
            withCredentials: true,
        });
        return response.data; // API에서 받은 데이터를 반환
    } catch (error) {
        console.error(" 공지사항 상세 정보 요청 중 오류 발생:", error);
        return null; // 오류 발생 시 null 반환
    }
};


// 건의사항 추가
export const addSuggestion = async (sugTitle, sugContent) => {
    try {
        const response = await axios.post(`${API_BASE_URL}/adminMain/addSuggestion`, {
            suggestionTitle: sugTitle,  // JSON 형태로 보내는 데이터의 키
            suggestionContent: sugContent,
        }, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("API 요청 중 오류 발생:", error);
        return null;
    }
};


//건의사항 수정
export const updateSuggestion = async (sugNumber, sugTitle, sugContent) => {
    try {
        const response = await axios.post(`${API_BASE_URL}/adminMain/updateSuggestion`, {
            sugNumber,
            suggestionTitle: sugTitle,  // 서버에서 받는 필드명과 맞추기
            suggestionContent: sugContent
        }, { withCredentials: true });

        return response.data;
    } catch (error) {
        console.error("API 요청 중 오류 발생:", error);
        return null;
    }
};

//건의사항 삭제
export const deleteSuggestion = async (sugNumber) => {
    try {
        const response = await axios.post(`${API_BASE_URL}/adminMain/deleteSuggestion`, {
            sugNumber: sugNumber,
        }, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("API 요청 중 오류 발생:", error);
        return null;
    }
};

//댓글 추가 
export const addComment = async (sugNumber, commentContent) => {
    try {
        const response = await axios.post(`${API_BASE_URL}/adminMain/addComment`, {
            sugNumber: sugNumber,
            commentContent: commentContent,
        }, {
            headers: {
                'Content-Type': 'application/json',
            },
            withCredentials: true,
        });

        if (response.status === 200) {
            console.log("댓글이 추가되었습니다.");
            return response.data;  // Return the response with the updated data
        } else {
            console.log("댓글 추가 실패:", response.data.message);
            return null;
        }
    } catch (error) {
        console.error("댓글 추가 중 오류 발생:", error);
        return null;
    }
};


//댓글 삭제
export const deleteComment = async (commentNumber, sugNumber) => {
    try {
        const response = await axios.post(`${API_BASE_URL}/adminMain/deleteComment`, {
            commentNumber: commentNumber,
            sugNumber: sugNumber,
        }, { withCredentials: true });

        if (response.status === 200) {
            console.log("댓글이 삭제되었습니다.");
            return response.data;
        } else {
            console.log("댓글 삭제 실패:", response.data.message);
        }
    } catch (error) {
        console.error("댓글 삭제 중 오류 발생:", error);
        return null;
    }
};