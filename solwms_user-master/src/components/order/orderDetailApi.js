import axios from 'axios';
import * as bootstrap from 'bootstrap';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

let selectedOrderNumber;
let selectedAction;

export function showConfirmModal(orderNumber, actionType) {
    selectedOrderNumber = orderNumber;
    selectedAction = actionType;

    let message = "";
    switch (actionType) {
        case "cancel":
            message = "주문을 취소하시겠습니까?";
            break;
        case "receive":
            message = "주문을 접수하시겠습니까?";
            break;
        case "ship":
            message = "배송을 출발하시겠습니까?";
            break;
        case "deliver":
            message = "배송을 완료하시겠습니까?";
            break;
        default:
            message = "작업을 진행하시겠습니까?";
    }

    const modalMessageElem = document.getElementById("confirmModalMessage");
    if (modalMessageElem) {
        modalMessageElem.innerText = message;
    }

    const modalElement = document.getElementById("confirmModal");
    const confirmModal = new bootstrap.Modal(modalElement);
    confirmModal.show();
}

export function attachConfirmButtonListener() {
    const confirmButton = document.getElementById("confirmAction");
    if (confirmButton) {
        // **중복 등록 방지**를 원한다면, 등록 전 removeEventListener를 해주는 식으로 처리 가능
        confirmButton.addEventListener("click", handleConfirmAction);
    }
}

async function handleConfirmAction() {
    const url = `${API_BASE_URL}/orderdetail/${selectedAction}/${selectedOrderNumber}`;
    try {
        const response = await axios.get(url, { withCredentials: true });
        console.log("API 응답:", response.data);

        // 모달 닫기
        const modalElement = document.getElementById("confirmModal");
        const confirmModal = bootstrap.Modal.getInstance(modalElement);
        if (confirmModal) {
            confirmModal.hide();
        }

        // 새로고침 or 페이지 이동
        window.location.href = `/orderdetail?orderNumber=${selectedOrderNumber}`;
    } catch (error) {
        console.error("Error performing action:", error);
    }
}

export function redirectToProductDetail(productId) {
    window.location.href = `/productdetail?productId=${productId}`;
}

