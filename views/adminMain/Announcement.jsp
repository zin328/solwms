<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>공지사항</title>
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
    	
        /* ✅ 공지사항 전체 컨테이너 */
        .notice-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 750px;
            height : 800px;
            margin: auto;
            margin-top: 50px;
            position: relative;
        }

        /* ✅ 공지사항 제목 (가운데 정렬) */
        .notice-title2 {
            text-align: center;
            width: 100%;
            margin-bottom: 20px;
        }

        /* ✅ 검색창과 추가 버튼을 공지사항 제목 아래, 테이블 위쪽에 배치 */
        .search-container {
            display: flex;
            justify-content: flex-end; /* ✅ 오른쪽 정렬 */
            align-items: center;
            margin-right: 50px;
            margin-bottom: 15px; /* ✅ 테이블과 간격 조정 */
            gap: 10px; /* 버튼 간격 조정 */
        }
		.search-bar input {
		 height:40px;
		}
        /* ✅ 검색 입력창 스타일 */
        .search-bar input[type="text"] {
            height: 30px;
            font-size: 14px;
            padding: 5px 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        /* ✅ 검색 버튼 스타일 */
        .search-bar button {
            height: 42px;
            font-size: 14px;
            padding: 5px 15px;
            border-radius: 8px;
            border: 1px solid #ddd;
            background-color: #333;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .search-bar button:hover {
            background-color: #ddd;
        }

        /* ✅ 추가 버튼 스타일 */
        .add-notice-btn {
            width: 40px;
            height: 40px;
            font-size: 24px;
            border: none;
            border-radius: 8px;
            background-color: #333;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease;
             margin-bottom: 1px;
        }

        .add-notice-btn:hover {
            background-color: #ddd;
            color: black;
        }

        /* ✅ 테이블이 검색창과 겹치지 않도록 여백 조정 */
        .notice-table {
            width: 700px;
            
            border-collapse: collapse;
            margin-top: 10px; /* ✅ 검색창과의 간격 */
            height: 30px;
        }
        .notice-table thead th {
    		background-color: #333; /* 배경색 */
    		color: white; /* 글자색 */
		}
        
        /* ✅ 열 크기 조정 */
		.notice-table th:nth-child(1),
		.notice-table td:nth-child(1) {
    		width: 15%;
		}

		.notice-table th:nth-child(2),
		.notice-table td:nth-child(2) {
    		width: 65%;
		}	

		.notice-table th:nth-child(3),
		.notice-table td:nth-child(3) {
    		width: 20%;
		}

        /* ✅ 테이블 스타일 */
        .notice-table th, .notice-table td {
            border: 1px solid #ddd;
            padding: 4px 8px;
            text-align: center;
            font-weight: bold;
            line-height: 1.5;
            text-overflow: ellipsis;
        }

        /* ✅ 공지사항 제목 스타일 */
        .notice-title {
            color: black;
            text-decoration: none; /* 밑줄 제거 */
            transition: color 0.3s ease-in-out;
        }

        /* ✅ 마우스를 올렸을 때 색상 변경 */
        .notice-title:hover {
             color: #ddd;
        }

        /* ✅ 모달 스타일 */
        .modal {
            display: none;
            position: fixed;
            top: 20%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            margin-top: 300px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
            z-index: 1001;
            width: 500px;
            height: 600px;
        }

        .modal h2 {
            margin-bottom: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        .modal input[type="text"], .modal textarea {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            box-sizing: border-box;
          
        }

        .modal textarea {
            height: 400px;
            resize: vertical;
        }

        .modal .save-btn, .modal .cancel-btn {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .modal .save-btn {
            background-color: #333;
            color: white;
            border: none;
        }

        .modal .cancel-btn {
            background-color: #333;
    		color: white;
            border: none;
        }

        .modal .save-btn:hover {
            background-color: #ddd;
            color: #333
        }

        .modal .cancel-btn:hover {
            background-color: #ddd;
            color: #333
        }
        .modal .button-container {
   			display: flex;
    		justify-content: space-between; /* 버튼을 양쪽으로 정렬 */
    		gap: 10px; /* 버튼 사이 간격 */
		}

        /* ✅ 페이지네이션 스타일 */
        .pagination {
            margin-top: 20px;
            text-align: center;
        }

        .pagination a {
			font-weight: bold;
            margin: 0 5px;
            padding: 5px 10px;
            text-decoration: none;
            color: black;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .pagination a:hover {
            background-color: #ddd;
            color: #333
        }
        
        .pagination a:focus {
    		outline: none !important;
    		box-shadow: none !important;
    		background-color: #ddd !important;
    		color: black !important;
		}
		
		.pagination a:active {
    		font-weight: bold;
    		background-color: #ddd !important;
    		color: #333 !important;
		}
        .pagination strong {
        font-weight: bold;
        margin: 0 5px;
        padding: 5px 10px;
        text-decoration: none;
        color: black;
        border: 1px solid #ddd;
        border-radius: 5px;
    }
    .pagination strong.active{
    	font-weight: bold;
    	background-color: #ddd;
    	color: #333;
    	border: 1px solid #ddd;
    }
    .pagination strong:hover{
    	 background-color: #ddd;
            color: #333
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

<div class="notice-container">
    <h2 class="notice-title2">공지사항</h2> 

    <div class="search-container">
        <form class="search-bar" method="get" action="/notices">
            <input type="text" id="search-title" name="search" placeholder="검색" value="${search}" />
            <button type="submit" class="search-btn">검색</button>
        </form>
        <button id="addNoticeBtn" class="add-notice-btn">+</button>
    </div>

    <table class="notice-table">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="notice" items="${noticeList}">
                <tr>
                    <td>${notice.postNumber}</td>
                    <td>
                        <a href="/adminMain/announceContent?postNumber=${notice.postNumber}" class="notice-title">
                            ${notice.title}
                        </a>
                    </td>
                    <td>${notice.user_name}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
     <!-- ✅ 페이지네이션 -->
    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="/notices?page=${currentPage - 1}&search=${search}&p=${currentPage - 1}">« 이전</a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="pageNum">
            <c:choose>
                <c:when test="${pageNum == currentPage}">
                    <strong class="active">${pageNum}</strong>
                </c:when>
                <c:otherwise>
                    <a href="/notices?page=${pageNum}&search=${search}">${pageNum}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="/notices?page=${currentPage + 1}&search=${search}&p=${currentPage + 1}">다음 »</a>
        </c:if>
    </div>
</div>

<!-- ✅ 모달 창 유지 -->
<div class="modal" id="notice-modal">
    <form method="post" action="/adminMain/addNotice">
        <h2>공지사항 추가</h2>
        <input type="text" name="notice-title" placeholder="제목">
        <textarea name="notice-content" placeholder="내용"></textarea>
        <div class="button-container">
    		<button type="submit" class="save-btn">저장</button>
    		<button type="button" class="cancel-btn" onclick="closeModal()">취소</button>
		</div>
    </form>
</div>

<script>
document.getElementById("addNoticeBtn").addEventListener("click", function() {
    document.getElementById("notice-modal").style.display = "block";
});

function closeModal() {
    document.getElementById("notice-modal").style.display = "none";
}
</script>

</body>
</html>
