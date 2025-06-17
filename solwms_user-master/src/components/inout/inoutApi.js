import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const fetchInoutHistory = async (pageNum =1) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/userProductHistory?p=${pageNum}`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}

export const fetchSearchInoutHistory = async (category = "" , date1 = "" , date2 = "" , searchKeyword = "" , state = "" , pageNum =1,) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/searchProductHistory?category=${category}&date1=${date1}&date2=${date2}&searchKeyword=${searchKeyword}&state=${state}&p=${pageNum}`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}