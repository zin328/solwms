<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>관리자 메인 페이지</title>
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



        /* 메인 컨텐츠 중앙 정렬 */
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
        .main-content h1{
            margin-right: 60%;
            padding-bottom: 30px;
        }

        /* 검색 폼 스타일 */
        .search-form {
            background: #fff;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: inline-block;
            text-align: right;
            flex-wrap: wrap; /* 반응형 조정 */
            gap: 10px;
            width: 80vw; /* 반응형 너비 */
            max-width: 1200px;
        }

        /* 검색 입력 스타일 */
        .search-form label {
            font-weight: bold;
        }

        .search-form input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        /* 검색 버튼 스타일 */
        .search-form button {
            background: #333;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
        }

        .search-form button:hover {
            background: #0056b3;
        }

        /* 주문 테이블 스타일 */
        .order-table {
            width: 80vw; /* 반응형 크기 */
            max-width: 1200px; /* 최대 크기 */
            min-width: 600px; /* 최소 크기 */
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .order-table th, .order-table td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .order-table th {
            background: #333;
            color: white;
            font-weight: bold;
        }

        .order-table tr:hover {
            background: #f1f1f1;
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

        /* 주문 대기 (노랑) */
        .status.ORDER_PENDING {
            background: #ffc107;
            color: #fff;
        }

        /* 배송 중 (파랑) */
        .status.SHIPPING {
            background: #007bff;
            color: #fff;
        }

        /* 배송 완료 (초록) */
        .status.DELIVERED {
            background: #28a745;
            color: #fff;
        }

        /* 주문 취소 (빨강) */
        .status.CANCELED {
            background: #dc3545;
            color: #fff;
        }

        /* 주문 접수 (청록색) */
        .status.RECEIVED {
            background: #17a2b8;
            color: #fff;
        }

        /* 페이징 네비게이션 */
        .pagination-container {
            display: flex !important;
            justify-content: center !important;
            width: 110% !important;
            margin-top: 20px !important; /* 필요에 따라 여백 조절 */
        }


        /* 페이징 네비게이션 */
        .pagination-link {
            display: inline-block !important;
            padding: 6px 12px !important;
            margin: 0 5px !important;
            border: 1px solid #ccc !important;
            text-decoration: none !important;
            color: #333 !important;
            border-radius: 5px !important;
            background-color: white;
        }

        .pagination-link.active {
            font-weight: bold;
            background-color:#ddd !important;
            color: #333 !important;
        }

        .pagination-link:hover{
            background-color: #ddd !important;
            color : #333;
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

<!-- 주문 현황 -->
<div class="main-content">
    <h1>주문 현황</h1>

    <!-- 주문내역 검색 -->
    <form action="/order/search" method="GET" class="search-form">
        <label for="orderNumber">주문번호:</label>
        <input type="number" id="orderNumber" name="orderNumber">

        <label for="employeeNumber">사번:</label>
        <input type="text" id="employeeNumber" name="employeeNumber">

        <label for="orderDate">주문 날짜:</label>
        <input type="date" id="orderDate" name="orderDate">

        <button type="submit">검색</button>
    </form>

    <!-- 주문 테이블 -->
    <table class="order-table">
        <thead>
        <tr>
            <th>주문번호</th>
            <th>신청인</th>
            <th>주문 날짜</th>
            <th>진행 상황</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="order" items="${orders}">
            <tr onclick="location.href='<c:url value='/orderdetail?orderNumber=${order.orderNumber}'/>'" style="cursor: pointer;">
                <td>${order.orderNumber}</td>
                <td>${order.employeeNumber}</td>
                <td>${order.orderDateFormatted}</td>
                <td>
                    <c:choose>
                        <c:when test="${order.state == 'ORDER_PENDING'}">
                            <span class="status ORDER_PENDING">주문 대기</span>
                        </c:when>
                        <c:when test="${order.state == 'SHIPPING'}">
                            <span class="status SHIPPING">배송 중</span>
                        </c:when>
                        <c:when test="${order.state == 'DELIVERED'}">
                            <span class="status DELIVERED">배송 완료</span>
                        </c:when>
                        <c:when test="${order.state == 'CANCELED'}">
                            <span class="status CANCELED">주문 취소</span>
                        </c:when>
                        <c:when test="${order.state == 'RECEIVED'}">
                            <span class="status RECEIVED">주문 접수</span>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>

    </table>

    <!-- 페이징 네비게이션 -->
    <div id="page" class="pagination-container">
        <c:if test="${begin > pageNum}">
            <a href="?page=${begin - 1}" class="pagination-link">« 이전</a>
        </c:if>

        <c:forEach var="i" begin="${begin}" end="${end}">
            <a href="?page=${i}" class="pagination-link ${i == currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>

        <c:if test="${end < totalPages}">
            <a href="?page=${end + 1}" class="pagination-link">다음 »</a>
        </c:if>
    </div>




</div>
</body>
</html>
