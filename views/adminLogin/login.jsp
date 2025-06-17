<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>OH! WMS LOGIN</title>
    <style>
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

        body {
            margin-top: 80px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }

        .login-form {
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .login-form table {
            width: 100%;
        }

        .login-form td {
            padding: 10px;
        }

        .login-form input[type="text"],
        .login-form input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            position: relative;
            box-sizing: border-box;
        }

        .password-container {
            position: relative;
            width: 100%;
        }

        .password-container input[type="password"],
        .password-container input[type="text"] {
            padding-right: 40px;
            width: 100%;
            box-sizing: border-box;
        }

        .password-container img {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            height: 20px;
            cursor: pointer;
        }
        .login-form input[type="submit"] {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .login-form input[type="submit"]:hover {
            background-color: #555;
        }
    </style>
    <script>
        function showErrorPopup(message) {
            alert(message);
        }

        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('error')) {
                showErrorPopup('로그인 실패! 다시 시도하세요.');
            }
            loadUsername();
        };

        function saveUsername() {
            var username = document.getElementById("username").value;
            var rememberMe = document.getElementById("rememberMe").checked;
            if (rememberMe) {
                localStorage.setItem("savedUsername", username);
            } else {
                localStorage.removeItem("savedUsername");
            }
        }

        function loadUsername() {
            var savedUsername = localStorage.getItem("savedUsername");
            if (savedUsername) {
                document.getElementById("username").value = savedUsername;
                document.getElementById("rememberMe").checked = true;
            }
        }

        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            var passwordIcon = document.getElementById("passwordIcon");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                passwordIcon.src = "/resources/icon/eye.svg";
            } else {
                passwordField.type = "password";
                passwordIcon.src = "/resources/icon/eye-closed.svg";
            }
        }

    </script>
</head>

<body>
<header>
    <h1 style="color: white;">OH! WMS</h1>
</header>

<div class="login-form">
    <h1>로그인</h1>
    <form method="post" onsubmit="saveUsername()">
        <table>
            <tr>
                <td class="label">아이디</td>
                <td><input type="text" name="username" id="username" /></td>
            </tr>
            <tr>
                <td class="label">비밀번호</td>
                <td>
                    <div class="password-container">
                        <input type="password" name="password" id="password" />
                        <img src="/resources/icon/eye-closed.svg" id="passwordIcon" onclick="togglePasswordVisibility()" />
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="checkbox" id="rememberMe" /> 아이디 저장
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="로그인" />
                </td>
            </tr>
        </table>
    </form>
</div>
</body>

</html>
