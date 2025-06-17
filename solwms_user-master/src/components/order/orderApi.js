import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

/**
 * 페이지별 주문 목록을 가져옵니다.
 *
 * @param {number} page - 현재 페이지 (기본값: 1)
 * @param {number} size - 페이지 당 항목 수 (기본값: 20)
 * @returns {Promise<{ orders: Array, currentPage: number, totalPages: number }>}
 *  - orders: 주문 목록
 *  - currentPage: 현재 페이지
 *  - totalPages: 전체 페이지 수
 */
export async function getAllOrders(page = 1, size = 10) {
    try {
        // 컨트롤러의 엔드포인트가 "/api/order/all"로 변경됨
        const response = await axios.get(`${API_BASE_URL}/order/all`, {
            params: { page, size },
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching orders:', error);
        throw error;
    }
}

/**
 * 특정 조건으로 주문을 검색합니다.
 *
 * @param {number} [orderNumber] - 주문번호 (옵션)
 * @param {number} [employeeNumber] - 사번 (옵션)
 * @param {string} [orderDate] - 주문 날짜(YYYY-MM-DD) (옵션)
 * @returns {Promise<Array>} 검색된 주문 목록
 */
export async function searchOrders(orderNumber, employeeNumber, orderDate) {
    try {
        const params = {};
        if (orderNumber) params.orderNumber = orderNumber;
        if (employeeNumber) params.employeeNumber = employeeNumber;
        if (orderDate) params.orderDate = orderDate;

        // 컨트롤러의 엔드포인트가 "/api/order/search"로 변경됨
        const response = await axios.get(`${API_BASE_URL}/order/search`, {
            params,
            withCredentials: true,
        });
        return response.data;
    } catch (error) {
        console.error('Error searching orders:', error);
        throw error;
    }
}
