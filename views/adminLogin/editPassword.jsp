<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>비밀번호 변경</title>
    <style>
        /* 상단 헤더 */
        header {
            background-color: #333;
            color: white;
            padding: 20px 30px;
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h1 {
            color: white;
            text-shadow: 3px 3px 0 #656262;
        }

        /* 헤더의 높이를 포함한 바디 여백 설정 */
        body {
            margin-top: 80px;
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
            top: 70px;
            bottom: 0;
            left: 0;
            height: calc(100vh - 70px);
        }

        .sidebar h2 {
            margin-top: 10px;
            margin-bottom: 10px;
            color: white;
            border-top: 9px solid #656262;
            border-bottom: 2px solid #656262;
            padding-top: 10px;
            padding-bottom: 15px;
            width: 100%;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin-bottom: 20px;
            margin-left: 25px;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 15px 0;
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
            margin-top: 80px;
            overflow-x: auto;
            white-space: nowrap;
        }

        .main-content h1 {
            align-self: flex-start;
            margin-left: 0;
            font-size: 24px;
            color: #333;
        }

        .form-container {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }

        .form-container table {
            width: 100%;
            border-collapse: collapse;
        }

        .form-container td {
            padding: 10px;
        }

        .form-container .label {
            text-align: right;
            font-weight: bold;
            color: #333;
        }

        .form-container input[type="password"],
        .form-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-container input[type="submit"] {
            background-color: #333;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .form-container input[type="submit"]:hover {
            background-color: #555;
        }
        
        .main-content h1 {
			    margin-right: 1200px; /* ✅ 오른쪽으로 이동 */
			    white-space: nowrap; /* ✅ 줄 바꿈 방지 */
			    position: relative;
    			left: 630px;
    			
			}
    </style>
    <script>
        function validateForm() {
            var newPassword = document.getElementById("newPassword").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            if (newPassword !== confirmPassword) {
                alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
                return false;
            }
            return true;
        }
    </script>
</head>

<body>
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
    <h1>비밀번호 변경</h1>
    <div class="form-container">
        <form method="post" onsubmit="return validateForm()">
            <table>
                <tr>
                    <td class="label">본인 사번</td>
                    <td>${id}</td>
                </tr>
                <tr>
                    <td class="label">새 비밀번호</td>
                    <td><input type="password" name="newPassword" id="newPassword" required/></td>
                </tr>
                <tr>
                    <td class="label">새 비밀번호 확인</td>
                    <td><input type="password" name="confirmPassword" id="confirmPassword" required/></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="비밀번호 변경"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
</body>

</html>