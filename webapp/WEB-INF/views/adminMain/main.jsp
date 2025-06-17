<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        	margin-top: 150px;
            margin-left: 450px;  /* 사이드바 너비만큼 왼쪽 여백 추가 */
            padding-top: 20px;
            padding-right: 20px;
            padding-left: 20px;
            padding-bottom : 20px;
            box-sizing: border-box;
            display: flex;
            justify-content: space-between;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
            gap: 20px; /* 공지사항과 재고현황 사이의 간격 */
            
        }
		.notice-container {
    		display: flex;
    		flex-direction: column; /* 요소들을 세로로 배치 */
    		gap: 20px; /* 공지사항과 공지사항2 사이의 간격 */
    		
		}
		
		.notice-container h2{
			border-bottom: 1px solid #ddd;
		}
		
	

        /* 공지사항 스타일 */
        .notice {
            width: 500px; /* 공지사항 박스의 너비를 지정 */
            height: 300px;
            background-color: #fff;
            padding-top: 20px;
            padding-right: 20px;
            padding-left: 20px;
            padding-bottom : 20px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.1); 
            
        }
        
        .notice2 {
            width: 500px;
            height: 300px;
            background-color: #fff;
            padding-top: 20px;
            padding-right: 20px;
            padding-left: 20px;
            padding-bottom : 20px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
             box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.1); 
        }
        

        /* 재고현황 스타일 */
        .inventory {
            width: 600px; 
            height: 620px;
            background-color: #fff;
            padding: 20px;
            padding: 20px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
            display: flex;
    		flex-direction: column;
    		 box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.1); 
            
        }
.inventory h2 {
	border-bottom: 1px solid #ddd;
    margin-bottom: 20px;
    flex-shrink: 0; /* 제목이 크기에 영향을 받지 않도록 고정 */
}

        /* 재고 상태 바 전체 컨테이너 */
.progress-bar {
    display: flex;
    margin-top: 15px;
    flex-direction: column;
    gap: 22px;
    width: 100%;
    overflow: auto;
}

/* 한 줄에 제품명 + 바 배치 */
.progress-bar-item {
    display: flex;
    align-items: center;
    gap: 18px;
    width: 100%;
}

/* 제품명 스타일 (왼쪽 정렬) */
.product-name {
    width: 150px;
    font-size: 15px;
    font-weight: bold;
    color: #333;
    text-align: left;
    padding-left: 10px;

}

.product-name:hover {
	color: #ddd !important;
}


/* 바 스타일 */
.bar {
    background-color: #007bff;
    color: white;
    padding: 5px;
    border-radius: 5px;
    text-align: center;
    font-weight: bold;
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 30px;  /* 최소 너비 */
    max-width: 450px; /* 최대 너비 */
    height: 30px
}
.topNotice-item {
	margin-bottom: 12px;
}
.topNotice-link {
	text-decoration: none; 
	color:black;
	font-size: 18px; /* 글자 크기 */
    font-weight: bold; /* 글자 굵기 */
    transition: color 0.3s ease-in-out;
}
.topNotice-link:hover {
    color: #ddd !important;
}
.topSuggestion-item {
	margin-bottom: 12px;
}
.topSuggestion-link {
	text-decoration: none; 
	color:black;
	font-size: 18px; /* 글자 크기 */
    font-weight: bold; /* 글자 굵기 */
    transition: color 0.3s ease-in-out;
}
.topSuggestion-link:hover {
    color: #ddd !important;
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
        <!-- 공지사항 -->
        <div class="notice-container">
        	<section class="notice">
            	<h2 style="font-size: 22px; color: #333;">
				    공지사항
				    &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
				    <a href="/notices" style="text-decoration: none; color: inherit; font-size: 14px;"
				       onmouseover="this.style.color='#ddd'" onmouseout="this.style.color='inherit'">
				       더보기+
				    </a>
				</h2>

            	<ul class="topNotice-list" style="list-style: none; padding: 0; color: #555;">
                	<c:forEach var="topNotices" items="${topNotices}">
                	<li class="topNotice-item"> 
                		<a href="/adminMain/announceContent?postNumber=${topNotices.postNumber}" class="topNotice-link">
   							${topNotices.title}
						</a>

                	</li>
                	</c:forEach>
            	</ul>
        	</section>
        
        	<!-- 건의사항 -->
        	<section class="notice2">
            	<h2 style="font-size: 22px; color: #333;">
	            	건의사항
	            	&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
	            	<a href="/suggestion" style="text-decoration: none; color: inherit; font-size: 14px;"
	            	onmouseover="this.style.color='#ddd'" onmouseout="this.style.color='inherit'">
	            	더보기+
	            	</a>
            	</h2>

            	<ul class="topSuggestion" style="list-style: none; padding: 0; color: #555;">
                	<c:forEach var="topSuggestion" items="${topSuggestion}">
                	<li class="topSuggestion-item"> 
                		<a href="/adminMain/suggContent?sugNumber=${topSuggestion.sugNumber}" class="topSuggestion-link">
   							 ${topSuggestion.sugTitle}
						</a>

                	</li>
                	</c:forEach>
           	</ul>
        	</section>
        </div>

        <!-- 재고현황 -->
        <section class="inventory">
    		<h2 style="font-size: 22px; color: #333;">재고현황</h2>
    		<div class="progress-bar" id="progress-bar"></div>
		</section>

		<script>
		document.addEventListener("DOMContentLoaded", function() {
		    fetch('/api/inventory')
		        .then(response => response.json())
		        .then(data => {
		            console.log("📌 서버에서 받은 데이터 개수:", data.length);

		            let progressBar = document.getElementById("progress-bar");
		            progressBar.innerHTML = "";

		            // 📌 최대 재고값을 찾음 (20 이하의 수량만 필터링)
		            let filteredData = data.filter(item => item.quantity <= 20);

		            if (filteredData.length === 0) {
		                progressBar.innerHTML = "<p>20 이하의 재고가 없습니다.</p>";
		                return;
		            }

		            let maxQuantity = Math.max(...filteredData.map(item => item.quantity), 1);  // 최대 값 설정

		            filteredData.forEach(item => {
		                if (!item.productName || item.quantity === undefined) {
		                    console.warn("누락된 데이터 발견:", item);
		                    return; // 제품명이 없거나, 재고 값이 undefined면 제외
		                }

		                // 제품명 + 바를 한 줄에 배치하는 div
		                let progressBarItem = document.createElement("div");
		                progressBarItem.classList.add("progress-bar-item");

		                // 제품명 div 생성 (박스 왼쪽에 붙이기)
		                let productName = document.createElement("div");
		                productName.classList.add("product-name");
		              /*   productName.textContent = item.productName; */
		                const productId = item.productId;
		             // product_name을 클릭하면 product_id 기반의 상세 페이지로 이동
		                let link = document.createElement("a");
		               
		                link.href = `/detail/`+productId;

		                link.textContent = item.productName;
		                link.style.textDecoration = 'none';
		                link.style.color = 'inherit';

		                productName.appendChild(link);


		                // 바 div 생성
		                let bar = document.createElement("div");
		                bar.classList.add("bar");

		                // 동적 너비 계산 (비율 조정)
		                let width = (item.quantity / maxQuantity) * 300; // 최대 300px까지 설정
		                width = Math.max(width, 20); // 최소 너비 20px 보장

		                bar.style.width = width + "px"; // 길이 적용
		                bar.textContent = item.quantity; // 중앙에 수량 표시
						
		                
		                // 수량에 따른 색상 변경
		                if(item.quantity >= 10){
		                	bar.style.backgroundColor = "#FFA500"
		                } else{
		                	bar.style.backgroundColor = "red"; // 10미만이면 빨간색
		                }
		                

		                // 요소 조립
		                progressBarItem.appendChild(productName);
		                progressBarItem.appendChild(bar);

		                // 전체 컨테이너에 추가
		                progressBar.appendChild(progressBarItem);
		            });
		        })
		        .catch(error => {
		            console.error("재고 데이터를 불러오는 중 오류 발생:", error);
		            document.getElementById("progress-bar").innerHTML = 
		                "<p style='color: red;'>재고 데이터를 불러오지 못했습니다.</p>";
		        });
		});




</script>

</div>
</body>
</html>
