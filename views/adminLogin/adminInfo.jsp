<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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

        /* 메인 컨텐츠 영역 */
        .main-content {
            margin-left: 230px;
            width: calc(100% - 230px);
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-top: 80px; /* 헤더 높이만큼 내림 */
            white-space: nowrap; /* 내부 요소들이 줄바꿈되지 않도록 함 */
        }

        .search-form {
            background: #fff;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            gap: 10px;
            height: 40px;
            width: 100%;
            max-width: 1200px;
            min-width: 800px; /* 최소 너비 설정 */
            overflow-x: auto; /* 좌우 스크롤 추가 */
        }

        .search-form label {
            font-size: 15px;
            font-weight: bold;
        }

        .search-form input, .search-form select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 12%;
            font-size: 12px;
            font-weight: bold;/* 글자 크기 변경 */
        }

        .search-form button {
            background: #333;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px; /* 글자 크기 변경 */
            font-weight: bold;
        }

        .search-form button:hover {
            background: #333;
        }

        .inventory-table {
            width: 100%;
            max-width: 1225px;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .main-content h1 {
            align-self: flex-start;
            margin-left: 0;
        }

        .inventory-table {
            width: 90%; /* 테이블 가로 길이를 줄임 */
            max-width: 1100px; /* 최대 가로 길이 설정 */
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .inventory-table th, .inventory-table td {
            padding: 12px;
            text-align: center;
            border: none;
        }

        .inventory-table th {
            background: #333;
            color: white;
            font-weight: bold;
        }

        .inventory-table tr:hover {
            background: #f1f1f1;
        }

        .main-content h1 {
            margin-right: 1200px; /* ✅ 오른쪽으로 이동 */
            white-space: nowrap; /* ✅ 줄 바꿈 방지 */
            position: relative;
            top: -45px; /* ✅ 위로 20px 이동 */
            right: -100px;
        }
        .info {
            font-weight: bold;
            width: 30%;
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

<aside class="sidebar">
    <h2 style="font-size: 18px; margin-top: 0;"><a href="/adminInfo" style="text-decoration: none; color: inherit;"> &nbsp;&nbsp;&nbsp;관리자 페이지</a></h2>
    <ul>
        <li><a href="/adminMain">메인 화면</a></li>
        <li><a href="/stock/stockall">재고 확인</a></li>
        <li><a href="/return">재고 반납</a></li>
        <li><a href="/order/all">주문현황</a></li>
        <li><a href="/productHistory">입출고내역</a></li>
        <li><a href="/admin/userEdit">지점 관리</a></li>
    </ul>
</aside>

<div class="main-content">
    <h1>회원 정보</h1>

    <table class="inventory-table">
        <thead>
        <tr>
            <th></th>
            <th></th>

        </tr>
        </thead>
        <tbody>
            <tr>
                <td class="info">이름</td>
                <td>${user.user_name}</td>
            </tr>

            <tr>
                <td class="info">사번</td>
                <td>${user.employeeNumber}</td>
            </tr>
            <tr>
                <td class="info">번호</td>
                <td>${user.phone}</td>
            </tr>
            <tr>
                <td class="info"d>주소</td>
                <td>${user.address}</td>
            </tr>
            <tr>
                <td class="info">창고 이름</td>
                <td>${wareName}</td>
            </tr>
            <tr>
                <td class="info">권한</td>
                <td>${user.role}</td>
            </tr>

        </tbody>
    </table>


</div>

</body>
</html>