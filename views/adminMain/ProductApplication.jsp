<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>자재신청 페이지</title>
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
            padding: 30px;
            box-sizing: border-box;
            position: fixed;
            top: 70px; /* 헤더 밑에 위치 */
            bottom: 0; /* 화면 아래까지 이어짐 */
            left: 0;
            height: calc(100vh - 70px); /* 화면의 전체 높이에서 헤더 높이만큼 빼고 채움 */
        }

        /* 메뉴 항목 스타일 */
        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        /* 사이드바 메뉴 항목 간격 늘리기 */
        .sidebar li {
            margin-bottom: 20px; /* 메뉴 항목 간의 간격을 넓힘 */
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
            margin-top: 45px;
            margin-right: 90px;
            margin-left: 250px;
            margin-bottom: 70px; /* 사이드바 너비만큼 왼쪽 여백 추가 */
            padding-top: 20px;
            padding-right: 20px;
            padding-left: 50px;
            padding-bottom : 20px;
            box-sizing: border-box;
            display: flex;
            justify-content: space-between;
            gap: 70px; /* 공지사항과 재고현황 사이의 간격 */
        }
	

        /* 공지사항 스타일 */
        .notice {
            width: 1100px; /* 공지사항 박스의 너비를 지정 */
            height: 500px;
            background-color: #fff;
            padding-top: 0px;
            padding-right: 20px;
            padding-left: 20px;
            padding-bottom : 20px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
            
        }
        
        
        

       
    </style>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f4f4f4;">

    <!-- 상단 고정된 헤더 -->
    <header>
        <h1 style="margin: 0;">soldesk</h1>
        <a href="/logout" style="color: white; font-weight: bold; text-decoration: none;">로그아웃</a>
    </header>

    <!-- 사이드바 -->
    <aside class="sidebar">
        <h2 style="font-size: 18px; margin-top: 0;"><a href="/adminInfo" style="text-decoration: none; color: inherit;"> &nbsp;&nbsp;&nbsp;관리자 페이지</a></h2>
        <ul style="padding: 20;">
            <li><a href="/adminMain" style="text-decoration: none; color: inherit;">메인 화면</a></li>
            <li><a href="#" style="text-decoration: none; color: inherit;">재고 확인</a></li>
            <li><a href="#" style="text-decoration: none; color: inherit;">재고 반납</a></li>
            <li><a href="#" style="text-decoration: none; color: inherit;">타지역 창고 신청</a></li>
            <li><a href="#" style="text-decoration: none; color: inherit;">주문현황</a></li>
            <li><a href="#" style="text-decoration: none; color: inherit;">입출고내역</a></li>
        </ul>
    </aside>

    <!-- 메인 컨텐츠 -->
    <div class="main-content">
        <div class="notice-container">
        	<section class="notice">
            	<h2 style="font-size: 22px; color: #333;">
            	<a>자재신청</a></h2>
            	<ul style="list-style: none; padding: 0; color: #555;">
                	<li>1. 2025.01.09</li>
                	<li>2. 2024.11.12</li>
                	<li>3. 2024.07.10</li>
                	<li>4. 2024.05.02</li>
            	</ul>
        	</section>
        
        	</div>
    </div>

</body>
</html>