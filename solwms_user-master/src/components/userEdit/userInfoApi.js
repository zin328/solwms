import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const userInfoApi = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/userinfo`, { withCredentials: true });
        return response.data;
    } catch (error) {
        console.error("Error fetching data:", error);
        return null;
    }
}
