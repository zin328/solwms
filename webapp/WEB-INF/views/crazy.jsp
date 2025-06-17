<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개 화려한 JSP 페이지</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 🔥 배경 애니메이션 */
        @keyframes crazyBackground {
            0% { background: #ff0000; }
            25% { background: #ff00ff; }
            50% { background: #0000ff; }
            75% { background: #00ff00; }
            100% { background: #ff0000; }
        }

        body {
            animation: crazyBackground 5s infinite;
            text-align: center;
            font-family: Arial, sans-serif;
            color: white;
            overflow: hidden;
            position: relative;
        }

        /* 번쩍이는 텍스트 */
        @keyframes neonText {
            0% { text-shadow: 0 0 10px #fff, 0 0 20px #ff00ff, 0 0 30px #ff00ff; }
            50% { text-shadow: 0 0 20px #fff, 0 0 30px #00ffff, 0 0 40px #00ffff; }
            100% { text-shadow: 0 0 10px #fff, 0 0 20px #ff00ff, 0 0 30px #ff00ff; }
        }

        h1 {
            font-size: 50px;
            animation: neonText 1s infinite alternate;
        }

        /* 버튼 효과 */
        .crazy-btn {
            font-size: 24px;
            padding: 15px 30px;
            border: none;
            cursor: pointer;
            background: linear-gradient(45deg, #ff00ff, #00ffff);
            color: white;
            font-weight: bold;
            border-radius: 10px;
            box-shadow: 0 0 10px #fff;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .crazy-btn:active {
            transform: scale(1.2);
            box-shadow: 0 0 20px #fff;
        }

        /* 마우스 따라 빛나는 효과 */
        .glow {
            position: absolute;
            width: 20px;
            height: 20px;
            background: radial-gradient(circle, rgba(255,255,255,1) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            opacity: 0.8;
        }

    </style>
</head>
<body>

<h1>🔥 개 화려한 JSP 페이지 🔥</h1>

<button class="crazy-btn" onclick="crazyAction()">눌러봐!</button>

<!-- 마우스 빛나는 효과 -->
<div id="glowEffect"></div>

<script>
    function crazyAction() {
        alert("🔥 개쩌는 버튼 클릭! 🔥");
    }

    // 마우스 따라 다니는 빛나는 효과
    $(document).mousemove(function(event) {
        let glow = $("<div class='glow'></div>");
        glow.css({ top: event.pageY, left: event.pageX });
        $("body").append(glow);

        setTimeout(() => { glow.remove(); }, 500);
    });

</script>

</body>
</html>
