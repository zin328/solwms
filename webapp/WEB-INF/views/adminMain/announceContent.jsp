<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>공지사항 상세 보기</title>
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
        
        .content-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 700px;
            height: 730px;
            margin: auto;
            margin-top: 100px;
            margin-left: 700px;
            position: relative;
        }
        .content-header {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }
        .notice-box {
        	height: 520px;
    		border: 2px solid #ddd;
    		border-radius: 10px;
    		padding: 20px;
    		background-color: #fff;
    		margin-bottom: 20px;
		}
		.notice-box p {
    		font-size: 18px;
    		font-weight: bold;
    		line-height: 1.8;
    		margin: 10px 0;
		}
        .content-body {
            font-size: 18px;
            line-height: 1.6;
        }
        .modal {
        	display: none; /* 기본적으로 숨김 */
    		position: fixed;
    		z-index: 1000;
    		left: 0;
    		top: 0;
    		width: 100%;
    		height: 100%;
    		background-color: rgba(0, 0, 0, 0.5);
        }
        /* 모달 콘텐츠 */
		.modal-content {
    		position: absolute;
    		top: 50%;
    		left: 50%;
   	 		transform: translate(-50%, -50%);
    		background-color: white;
    		padding: 20px;
    		width: 90%;
    		height: 750px;
    		max-width: 700px; /* 최대 너비 설정 */
    		border-radius: 10px;
    		box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
		}
		/* 제목 스타일 */
.modal h2 {
    margin-bottom: 20px;
    text-align: center;
}
.edit-title, .edit-content {
	font-size: 16px;
	font-weight: bold;
}

/* 폼 입력 스타일 */
.form-input {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 16px;
    font-weight: bold;
    box-sizing: border-box;
}

/* 수정 버튼과 취소 버튼 */
.button-container {
    display: flex;
    justify-content: flex-end;
    gap: 5px;
    margin-top: 20px;
}

.button-container2 {
    display: flex;
    justify-content: flex-end;
    gap: 5px;
    margin-top: 20px;
}


/* 버튼 스타일 */
.edit-btn, .delete-btn, .back-btn {
    padding: 10px 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
}

.cancel-btn, .save-btn{
	padding: 10px 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
}

.edit-btn {
   background-color: #333;
    color: white;
}

.delete-btn {
    background-color: #333;
    color: white;
}

.back-btn {
    background-color: #333;
    color: white;
}

.save-btn {
    background-color: #333;
    color: white;
}
.cancel-btn {
    background-color: #333;
    color: white;
}

/* 버튼 호버 효과 */
.edit-btn:hover {
   background-color: #ddd;
}
.delete-btn:hover {
    background-color: #ddd;
}
.back-btn:hover {
    background-color: #ddd;
}
.save-btn:hover {
    background-color: #ddd;
}
.cancel-btn:hover {
    background-color: #ddd;
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

<div class="content-container">
    <div class="content-header">공지사항 상세</div>

    <c:choose>
        <c:when test="${not empty notice}">
        	<div class="notice-box">
            	<p><strong>제목:</strong> ${notice.title}</p>
            	<p><strong>내용:</strong> ${notice.content}</p>
         	</div>
        </c:when>
        <c:otherwise>
            <p>해당 공지사항을 찾을 수 없습니다.</p>
        </c:otherwise>
    </c:choose>
	
	<div class="button-container">
    	<button class="edit-btn" onclick="openEditModal()">수정하기</button>
    	<form action="/adminMain/deleteNotice" method="post" style="display:inline">
			<input type="hidden" name="postNumber" value="${notice.postNumber}" />
        	<button type="submit" class="delete-btn" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</button>
    	</form>
		<button class="back-btn" onclick="location.href='/notices'">뒤로가기</button>
	</div>
	
	<!-- 수정 모달 -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <h2>공지사항 수정</h2>
        <form id="editNoticeForm" method="post" action="/adminMain/updateNotice">
            <input type="hidden" name="postNumber" value="${notice.postNumber}" />
            <div class="edit-titles">
                <label for="edit-title">제목:</label>
                <input type="text" id="edit-title" name="notice-title" class="form-input" value="${notice.title}" required />
            </div>
            <div class="edit-contents">
                <label for="edit-content">내용:</label>
                <textarea id="edit-content" name="notice-content" class="form-input" rows="6" required>${notice.content}</textarea>
            </div>
            <div class="button-container2">
            	<button type="submit" class="save-btn">저장</button>
             	<button type="button" class="cancel-btn" onclick="closeEditModal()">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 모달 열기
    function openEditModal() {
        document.getElementById("editModal").style.display = "block";
    }

    // 모달 닫기
    function closeEditModal() {
        document.getElementById("editModal").style.display = "none";
    }
</script>
</div>
</body>
</html>
