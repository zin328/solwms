const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const passwordChangeapi = async (newPassword) => {
    try {
        const response = await fetch(`${API_BASE_URL}/changePassword`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: new URLSearchParams({ newPassword }).toString(),
            mode: "cors",
            credentials: "include",
        });

        if (!response.ok) {
            throw new Error("비밀번호 변경 요청 실패");
        }

        const responseText = await response.text();
        const data = responseText ? JSON.parse(responseText) : {};

        return { success: true, data };
    } catch (error) {
        console.error("비밀번호 변경 요청 중 오류 발생:", error);
        return { success: false, error: error.message };
    }
};