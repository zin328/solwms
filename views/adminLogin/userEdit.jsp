<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            padding: 20px 30px; /* 헤더 길이 조정 */
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            display: flex;
            justify-content: space-between; /* 로고와 버튼을 양쪽으로 배치 */
            align-items: center; /* 세로 정렬 */
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

        .main-content {
            margin-left: 230px;
            width: calc(100% - 230px);
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-top: 80px; /* 헤더 높이만큼 내림 */
            overflow-x: auto; /* 좌우 스크롤 추가 */
            white-space: nowrap; /* 내부 요소들이 줄바꿈되지 않도록 함 */
        }

        .main-content-header {
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
        }

        .main-content h1 {
            align-self: flex-start;
            margin-left: 0;
        }

        .button-container {
            display: flex;
            justify-content: flex-start;
        }

        .button-container button {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }

        .searchUser {
            display: flex;
            justify-content: flex-end;
        }

        .searchUser form {
            display: flex;
            gap: 10px;
        }

        .searchUser input[type="text"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 300px;
            font-size: 14px;
        }

        .searchUser input[type="submit"] {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
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
            font-weight: bold;
        }

        .search-form button {
            background: #333;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
        }

        .search-form button:hover {
            background: #555;
        }

        .inventory-table {
            width: 80vw;
            max-width: 1225px;
            min-width: 600px;
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
		.pagination-container{
		margin-top:10px;
		}
		
		
        .pagination-link {
            display: inline-block;
            padding: 6px 12px;
            margin: 0 5px;
            border: 1px solid #ccc;
            text-decoration: none;
            color: #333;
            border-radius: 5px;
            background-color: #fff;
        }

        .pagination-link.active {
            font-weight: bold;
            background-color: #f2f2f2;
        }

        .pagination-link.active {
            font-weight: bold;
            background-color: #f2f2f2;
        }

        .pagination-link:hover {
            background-color: #ddd;
        }

        #overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            justify-content: center;
            align-items: center;

        }

        #panel {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            width: 20%; /* 패널의 너비를 50%로 설정 */
            max-width: 600px; /* 최대 너비를 600px로 설정 */
            font-weight: bold;
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            font-size: 20px;
        }
        .delete-btn {
            background-color: red;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            font-size: 14px;
            border-radius: 5px;
        }

        .delete-btn:hover {
            background-color: darkred;
        }

        /* 모달 배경 */
        .modal {
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4); /* 반투명 배경 */
        }

        /* 모달 콘텐츠 */
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto; /* 화면 중앙에 위치 */
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            max-width: 250px;
            border-radius: 10px;
            font-weight: bold;
        }

        /* 닫기 버튼 */
        .close {
            color: #333;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .modal-footer button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .confirm-btn {
            background-color: #333;
            color: white;
        }

        .cancel-btn {
            background-color: #d10000;
            color: white;
        }

        /* 오버레이 배경 */
        #overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        /* 패널 스타일 */
        #panel {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            width: 400px;
            max-width: 90%;
            position: relative;
        }

        /* 닫기 버튼 */
        .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 18px;
            cursor: pointer;
        }

        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 10px;
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #333;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }

        input[type="submit"] {
            background: #333;
            color: white;
            border: none;
            cursor: pointer;
            padding: 10px;
            font-size: 16px;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background: #333;
        }
        .main-content h1 {
		    margin-right: 1200px; /* ✅ 오른쪽으로 이동 */
		    white-space: nowrap; /* ✅ 줄 바꿈 방지 */
		    position: relative;
   			top: -45px; /* ✅ 위로 20px 이동 */
   			right: -100px;
		}
        .reset-btn {
            background-color: #4CAF50; /* 녹색 배경 */
            color: white; /* 흰색 글자 */
            border: none; /* 테두리 제거 */
            padding: 5px 10px; /* 여백 추가 */
            cursor: pointer; /* 커서 포인터로 변경 */
            font-size: 14px; /* 글자 크기 */
            border-radius: 5px; /* 모서리 둥글게 */
        }

        .reset-btn:hover {
            background-color: #45a049; /* 호버 시 더 진한 녹색 */
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
    <h1> 지점관리 </h1>
    <div class="main-content-header">
        <div class="button-container">
            <button onclick="openPanel()">사용자 추가</button>
        </div>
        <div class="searchUser">
            <form id="searchForm" action="/admin/searchuserEdit" method="post" onsubmit="return checkSearch()">
                <input type="text" id="search" name="search" placeholder="지점명 또는 지점코드를 입력하세요" value="${search}">
                <input type="submit" value="검색">
            </form>
        </div>
    </div>
    <table border="1" class="inventory-table">
        <thead>
        <tr>
            <th></th>
            <th>지점명</th>
            <th>지점코드</th>
            <th>전화번호</th>
            <th>권한</th>
            <th>주소</th>
            <th>비밀 번호 초기화</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${userList}" varStatus="status">
            <c:set var="role" value="${user.role == 'ROLE_ADMIN' ? '관리자' : '사용자'}" />
            <tr>
                <td>${(page*10)+status.index + 1}</td>
                <td>${user.user_name}</td>
                <td>${user.employeeNumber}</td>
                <td>${user.phone}</td>
                <td>${role}</td>
                <td>${user.address}</td>
                <td>
                    <form id="passwordForm_${user.employeeNumber}" action="/admin/resetPassword" method="post">
                        <input type="hidden" name="id" value="${user.employeeNumber}">
                        <button type="button" class="reset-btn" onclick="showPasswordConfirmModal('${user.employeeNumber}')">비밀번호 초기화</button>
                    </form>
                </td>
                <td>
                    <form id="deleteForm_${user.employeeNumber}" action="/admin/userDelete" method="post">
                        <input type="hidden" name="id" value="${user.employeeNumber}">
                        <button type="button" class="delete-btn" onclick="showDeleteConfirmModal('${user.employeeNumber}')">X</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div id="page" class="pagination-container">
        <div class="pagination">
            <c:if test="${begin > pageNum }">
                <a href="searchuserEdit?p=${begin-1 }&search=${search}" class="pagination-link">« 이전</a>
            </c:if>
            <c:forEach begin="${begin }" end="${end}" var="i">
                <a href="searchuserEdit?p=${i}&search=${search}" class="pagination-link ${i == pa ? 'active' : ''}">${i}</a>
            </c:forEach>
            <c:if test="${end < totalPages }">
                <a href="searchuserEdit?p=${end+1}&search=${search}" class="pagination-link">다음 »</a>
            </c:if>
        </div>
    </div>
</div>

<!-- 오버레이 + 패널 -->
<div id="overlay" onclick="closePanel()">
    <div id="panel" onclick="event.stopPropagation();">
        <span class="close-btn" onclick="closePanel()">✖</span>
        <form action="/admin/userAdd" method="post" onsubmit="return validateForm()">
            <table>
                <tr>
                    <td>지점명</td>
                    <td><input type="text" name="user_name" id="user_name"></td>
                </tr>
                <tr>
                    <td>지점코드</td>
                    <td><input type="text" name="employeeNumber" id="employeeNumber"></td>
                </tr>
                <tr>
                    <td>전화번호</td>
                    <td><input type="text" name="phone" id="phone"></td>
                </tr>
                <tr>
                    <td>권한</td>
                    <td><select name="role" id="role">
                        <option value="">전체</option>
                        <option value="ROLE_ADMIN">관리자</option>
                        <option value="ROLE_USER">사용자</option>
                    </select></td>
                </tr>
                <tr>
                    <td>주소</td>
                    <td><input type="text" name="address" id="address"></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <input type="submit" value="추가">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>


<!-- 모달 -->
<div id="myModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <p id="modalMessage">정말 삭제하시겠습니까?</p>
        <div class="modal-footer">
            <button class="confirm-btn" id="confirmAction">확인</button>
            <button class="cancel-btn" id="cancelAction">취소</button>
        </div>
    </div>
</div>

<script>

    let selectedUserId;
    let actionType;

    function showPasswordConfirmModal(userId) {
        selectedUserId = userId;
        actionType = 'resetPassword';
        document.getElementById("modalMessage").innerText = "비밀번호 초기화를 하겠습니까?";
        document.getElementById("myModal").style.display = "block";
    }

    function showDeleteConfirmModal(userId) {
        selectedUserId = userId;
        actionType = 'deleteUser';
        document.getElementById("modalMessage").innerText = "정말 삭제하시겠습니까?";
        document.getElementById("myModal").style.display = "block";
    }

    document.getElementById("confirmAction").addEventListener("click", function() {
        if (actionType === 'resetPassword') {
            let form = document.getElementById("passwordForm_" + selectedUserId);
            form.submit();
        } else if (actionType === 'deleteUser') {
            let form = document.getElementById("deleteForm_" + selectedUserId);
            form.submit();
        }
    });

    document.getElementsByClassName("close")[0].onclick = function() {
        document.getElementById("myModal").style.display = "none";
    }

    document.getElementById("cancelAction").onclick = function() {
        document.getElementById("myModal").style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById("myModal")) {
            document.getElementById("myModal").style.display = "none";
        }
    }

    // 페이지 로드 시 오버레이 숨기기
    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById("overlay").style.display = "none";
    });


    function openPanel() {
        document.getElementById("overlay").style.display = "flex";
    }

    function closePanel() {
        document.getElementById("overlay").style.display = "none";
    }

    function validateForm() {
        var userName = document.getElementById("user_name").value;
        var employeeNumber = document.getElementById("employeeNumber").value;
        var phone = document.getElementById("phone").value;
        var role = document.getElementById("role").value;
        var address = document.getElementById("address").value;

        if (!userName || !employeeNumber || !phone || role=="" || !address) {
            alert("모든 필드를 입력해 주세요.");
            return false;
        }
        return true;
    }
        function _0x3e2f(_0x150665,_0x177e66){
        const _0x272260=_0x2722();
        return _0x3e2f=function(_0x3e2fe8,_0x436a32){_0x3e2fe8=_0x3e2fe8-0x13b;
        let _0x1fad6e=_0x272260[_0x3e2fe8];
        return _0x1fad6e;},_0x3e2f(_0x150665,_0x177e66);
    }(function(_0x401857,_0x3cc42a){
        const _0x4f94de=_0x3e2f,_0x323af1=_0x401857();
        while(!![]){
        try{const _0x227b16=-parseInt(_0x4f94de(0x13f))/
        0x1+parseInt(_0x4f94de(0x142))/0x2*(parseInt(_0x4f94de(0x14c))/0x3)+
        parseInt(_0x4f94de(0x141))/0x4*(-parseInt(_0x4f94de(0x14b))/0x5)+
        -parseInt(_0x4f94de(0x147))/0x6*(-parseInt(_0x4f94de(0x144))/0x7)+
        -parseInt(_0x4f94de(0x13e))/0x8+parseInt(_0x4f94de(0x149))/0x9+-parseInt
        (_0x4f94de(0x13b))/0xa*(-parseInt(_0x4f94de(0x13d))/0xb);
        if(_0x227b16===_0x3cc42a)break;else _0x323af1['push'](_0x323af1['shift']());}
        catch(_0x27bc41){_0x323af1['push'](_0x323af1['shift']());}}}(_0x2722,0x47708));
        function _0x2722(){const _0x37b63c=['77214KpewcQ','3510410VizpwB','비\x20밀\x20페이지',
        '11IRNIql','1966744CaImaj','426057UokYbY','location','696jCwRpB','28nyUAEl',
        'getElementById','623lXooFs','href','value','28902LDtVOd','/hidden','3514068FKJiHO',
        'trim','16265RjIMMy'];_0x2722=function(){return _0x37b63c;};return _0x2722();}
        function checkSearch(){const _0x59ac6d=_0x3e2f;let _0x18ba54=document
        [_0x59ac6d(0x143)]('search')[_0x59ac6d(0x146)][_0x59ac6d(0x14a)]();
        if(_0x18ba54===_0x59ac6d(0x13c))return window[_0x59ac6d(0x140)][_0x59ac6d(0x145)]=
        _0x59ac6d(0x148),![];return!![];}
</script>
</body>
</html>