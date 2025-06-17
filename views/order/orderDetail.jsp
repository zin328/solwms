<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>관리자 메인 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* 상단 헤더 */
        header {
            background-color: #333;
            color: white;
            padding: 20px;
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            display: flex;
            justify-content: space-between; /* 로고와 버튼을 양쪽으로 배치 */
            align-items: center; /* 세로 정렬 */
            padding: 20px 30px;
        }

        header h1 {
            color: white;
            text-shadow: 3px 3px 0 #656262; /* 텍스트 아래와 오른쪽에 테두리 추가 */
        }

        /* 헤더의 높이를 포함한 바디 여백 설정 */
        body {
            margin-top: 80px; /* 헤더 높이만큼 여백 추가 */
            display: flex;
        }

        /* 사이드바 스타일 */
        .sidebar {
            background-color: #333;
            color: white;
            width: 200px;
            padding: 0px;
            box-sizing: border-box;
            position: fixed;
            top: 70px; /* 헤더 밑에 위치 */
            bottom: 0; /* 화면 아래까지 이어짐 */
            left: 0;
            height: calc(100vh - 70px); /* 화면의 전체 높이에서 헤더 높이만큼 빼고 채움 */
        }
        .sidebar h2 {
            margin-top: 10px; /* 원하는 상단 여백 설정 */
            margin-bottom: 10px; /* 원하는 하단 여백 설정 */
            color: white;
            border-top: 9px solid #656262; /* 윗줄 추가 */
            border-bottom: 2px solid #656262; /* 밑줄 추가 */
            padding-top: 10px; /* 윗줄과 텍스트 사이 여백 추가 */
            padding-bottom: 15px; /* 밑줄과 텍스트 사이 여백 추가 */
            width: 100%; /* 가로 길이를 사이드바에 꽉 차게 설정 */

        }

        /* 메뉴 항목 스타일 */
        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        /* 사이드바 메뉴 항목 간격 늘리기 */
        .sidebar li {
            margin-bottom: 20px; /* 메뉴 항목 간의 간격을 넓힘 */
            margin-left: 25px;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 15px 0; /* 메뉴 항목의 위아래 여백을 넓힘 */
        }

        .sidebar a:hover {
            background-color: #555;
        }


        /* 메인 컨텐츠 영역 */
        .main-content {
            display: flex;
            flex-direction: column;
            align-items: center; /* 중앙 정렬 */
            justify-content: center;
            width: 100%;
            padding: 100px;
            position: relative;
            top: -50px;
            left: 100px;
        }

        .order-detail {
            background-color: #fff;
            padding: 2vw;
            border-radius: 1vw;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 80vw;
            max-width: 1200px;
            min-width: 600px;
        }

        /* 테이블 스타일 */
        .order-table {
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
            width: 100%;
            margin-top: 20px;
        }

        .order-table th{
            background-color: #333;
            color: white;
        }

        .order-table th, .order-table td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .order-table tbody tr {
            background-color: white;
        }

        .order-table tbody tr:hover {
            background-color: #f1f1f1 !important;
        }


        /* 버튼 위치 설정 */
        .order-actions {
            padding-top: 10px;
            right: 20px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }

        /* 모달 중앙 정렬 */
        .modal-dialog {
            max-width: 400px;
            margin: auto;
        }

        .modal-content {
            text-align: center;
        }

        .modal-footer {
            justify-content: center;
        }

        /* 상태 컬러 강조 */
        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
            min-width: 80px;
        }

        .status.ORDER_PENDING {
            background: #ffc107;
            color: #fff;
        }

        .status.SHIPPING {
            background: #007bff;
            color: #fff;
        }

        .status.DELIVERED {
            background: #28a745;
            color: #fff;
        }

        .status.CANCELED {
            background: #dc3545;
            color: #fff;
        }

        .status.RECEIVED {
            background: #17a2b8;
            color: #fff;
        }
    </style>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f4f4f4;">

<!-- 상단 고정된 헤더 -->
<header>
    <h1 style="margin: 0;">
        <a href="/adminMain" style="text-decoration: none; color: inherit;">OH! WMS</a>
    </h1>
    <div style="display: flex; align-items: center;">
        <a href="/admin/changePassword" style="color: white; font-weight: bold; text-decoration: none; margin-right: 30px;">비밀번호 변경</a>
        <a href="/logout" style="color: white; font-weight: bold; text-decoration: none;">로그아웃</a>
    </div>
</header>

<!-- 사이드바 -->
<aside class="sidebar">
    <h2 style="font-size: 18px; margin-top: 0;"><a href="/adminInfo" style="text-decoration: none; color: inherit;"> &nbsp;&nbsp;&nbsp;관리자 페이지</a></h2>

    <ul style="padding: 20;">
        <li><a href="/adminMain">메인 화면</a></li>
        <li><a href="/stock/stockall">재고 확인</a></li>
        <li><a href="/return">재고 반납</a></li>
        <li><a href="/order/all">주문현황</a></li>
        <li><a href="/productHistory">입출고내역</a></li>
        <li><a href="/admin/userEdit">지점 관리</a></li>

    </ul>
</aside>

<!-- 메인 컨텐츠 -->
<div class="main-content">
    <!-- Flash 메시지 표시 -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert" style="background-color: red; color: white;">
                ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="order-detail">
        <h2>주문번호 (<strong>${order.orderNumber}</strong>) <span>주문 현황</span></h2>
        <p><strong>주문자 ID:</strong> ${order.employeeNumber}</p>
        <p><strong>신청일자:</strong> ${order.orderDateFormatted}</p>
        <p><strong>주문 상황:</strong>
            <span class="status ${order.state}">
                <c:choose>
                    <c:when test="${order.state eq 'ORDER_PENDING'}">주문 대기</c:when>
                    <c:when test="${order.state eq 'RECEIVED'}">주문 접수</c:when>
                    <c:when test="${order.state eq 'CANCELED'}">주문 취소</c:when>
                    <c:when test="${order.state eq 'SHIPPING'}">배송 중</c:when>
                    <c:when test="${order.state eq 'DELIVERED'}">배송 완료</c:when>
                    <c:otherwise>상태 없음</c:otherwise>
                </c:choose>
            </span>
        </p>
        <p><strong>출발지:</strong> ${order.deliveryAddress}</p>
        <p><strong>도착지:</strong> ${order.shippingAddress}</p>

        <table class="order-table">
            <thead style="background: #007bff; color: white; font-weight: bold;">
            <tr>
                <th>식별코드</th>
                <th>카테고리</th>
                <th>자재명</th>
                <th>모델명</th>
                <th>신청 수량</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="detail" items="${orderDetails}">
                <tr onclick="redirectToProductDetail('${detail.productId}')" style="cursor: pointer;">
                    <td>${detail.productId}</td>
                    <td>${detail.category}</td>
                    <td>${detail.productName}</td>
                    <td>${detail.modelName}</td>
                    <td>${detail.quantity}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <!-- 주문 상태에 따른 버튼 -->
        <div class="order-actions">
            <c:choose>
                <c:when test="${order.state eq 'ORDER_PENDING'}">
                    <button class="btn btn-primary" onclick="showConfirmModal(${order.orderNumber}, 'receive')">주문 접수</button>
                    <button class="btn btn-danger" onclick="showConfirmModal(${order.orderNumber}, 'cancel')">주문 취소</button>
                </c:when>
                <c:when test="${order.state eq 'RECEIVED'}">
                    <c:if test="${order.employeeNumber eq '0001'}">
                        <button class="btn btn-success" onclick="showConfirmModal(${order.orderNumber}, 'deliver')">배송 완료</button>
                    </c:if>
                    <c:if test="${order.employeeNumber ne '0001'}">
                        <button class="btn btn-info" onclick="showConfirmModal(${order.orderNumber}, 'ship')">배송 출발</button>
                    </c:if>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>


<!-- 모달 -->
<div class="modal fade" id="confirmModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body" id="confirmModalMessage">작업을 진행하시겠습니까?</div>
            <div class="modal-footer">
                <button class="btn btn-primary" id="confirmAction">확인</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script>
    let selectedOrderNumber;
    let selectedAction;

    function showConfirmModal(orderNumber, actionType) {
        selectedOrderNumber = orderNumber;
        selectedAction = actionType;

        let message = "";
        switch (actionType) {
            case "cancel": message = "주문을 취소하시겠습니까?"; break;
            case "receive": message = "주문을 접수하시겠습니까?"; break;
            case "ship": message = "배송을 출발하시겠습니까?"; break;
            case "deliver": message = "배송을 완료하시겠습니까?"; break;
        }

        document.getElementById("confirmModalMessage").innerText = message;
        const confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
        confirmModal.show();
    }

    document.getElementById("confirmAction").addEventListener("click", function() {
        let url = "/orderdetail/" + selectedAction + "/" + selectedOrderNumber;
        window.location.href = url;
    });

    function redirectToProductDetail(productId) {
        window.open('http://localhost:8081/detail/' + productId, '_blank');
    }

</script>

</body>
</html>
