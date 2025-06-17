<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
<title>제품상세페이지</title>

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
				margin-top: 15px; /* 원하는 상단 여백 설정 */
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
    margin-left: 220px; /* 사이드바 여백 */
    padding: 20px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-top: 20px;
}

/* 제목 스타일 */
.main-content h1 {
    font-size: 28px;
    color: #333;
    margin-left: 10px; /* 왼쪽 정렬 유지 */
    margin-bottom: 10px;
}

/* 제품 정보 & 이미지 정렬 */
.product-details {
    width: 100%;
    display: flex;
    justify-content: space-between; /* 왼쪽 정보, 오른쪽 이미지 */
    align-items: center;
    gap: 20px;
}

/* 제품 정보 스타일 */
.product-text {
    flex: 1;
    min-width: 300px;
    max-width: 500px;
    padding: 15px;
    
    border-radius: 8px;
    
}

.product-text p {
    font-size: 16px;
    color: #555;
    margin-bottom: 10px;
}

/* 제품 이미지 스타일 */
.product-image {
    flex: 1;
    min-width: 300px;
    max-width: 500px;
    text-align: center;
}

.product-image img {
    max-width: 100%;
    height: auto;
    border-radius: 8px;
    border: 1px solid #ddd;
}

/* 테이블 스타일 */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

thead th {
    background-color: #333;
    text-align: left;
   color: white;
}

th, td {
    border: 1px solid #ddd;
    padding: 10px;
}

        .status-in {
            background-color: #28a745; /* 초록색 */
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
            min-width: 80px;
        }

        .status-out {
            background-color: #dc3545; /* 빨강색 */
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
            min-width: 80px;
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
    <h1>제품상세페이지</h1>
    
    <c:forEach var="Plist" items="${Plist}">
        <div class="product-details">
            <!-- 제품 텍스트 정보 -->
            <div class="product-text">
                <p class="product-info">제품명: ${Plist.product_name}</p>
                <p class="product-info">모델명: ${Plist.model_name}</p>
                <p class="product-info">상세사항: ${Plist.detail}</p>
                <p class="product-info">카테고리: ${Plist.category}</p>
                <p class="product-info">현재위치: 
				    <c:choose>
				        <c:when test="${Plist.warehouseNumber == '1'}">물류센터</c:when>
				        <c:when test="${Plist.warehouseNumber == '2'}">예비 물류센터</c:when>
				        <c:otherwise>${Plist.wareName}</c:otherwise>
				    </c:choose>
				</p>

            </div>

            <!-- 제품 이미지 -->
            <div class="product-image">
                <c:if test="${not empty Plist.image_name}">
                    <p>${Plist.product_name}</p>
                    <img src="<c:url value='/resources/images/${Plist.image_name}'/>" alt="제품 이미지">
                </c:if>
            </div>
        </div>
    </c:forEach>

    <h2>입출고 내역</h2>
   
   	 <table border="1">
    <thead>
        <tr>
            <th>상태</th>
            <th>번호</th>
            <th>창고 이름</th>
            <th>날짜</th>
            <th>수량</th>
            
        </tr>
    </thead>
    <tbody>
        <c:forEach var="PHlist" items="${PHlist}">
            <c:set var="st" value="${PHlist.state == 'in' ? '입고' : '출고'}" />
            <tr>
                <td><span class="${PHlist.state == 'in' ? 'status-in' : 'status-out'}">${st}</span></td>
                <td>${PHlist.number}</td>
                <td>${PHlist.wareName}</td>
                <td><fmt:formatDate value="${PHlist.date}" pattern="yyyy년 MM월 dd일" /></td>
				
                <td>${PHlist.quantity}</td>
            </tr>
        </c:forEach>
        
    </tbody>
</table>
</div>




        
</body>
</html>
