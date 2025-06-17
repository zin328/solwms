<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
	<link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>관리자 메인 페이지</title>
    <style>
        /* 상단 헤더 */
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
            margin-left: 220px; /* 사이드바 너비만큼 왼쪽 여백 추가 */
            padding: 20px;
            box-sizing: border-box;
            display: flex;
            justify-content: space-between;
            gap: 90px; /* 공지사항과 재고현황 사이의 간격 */
        }

        /* 공지사항 스타일 */
        .notice {
            width: 400px; /* 공지사항 박스의 너비를 지정 */
            height: 200px;
            background-color: #fff;
            padding: 20px;
            padding-bottom : 20px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        /* 재고현황 스타일 */
        .inventory {
            width: 600px; 
            height: 500px;
            background-color: #fff;
            padding: 20px;
            padding: 20px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 8px;
        }

        /* 공지사항 항목 스타일 */
        .notice ul {
            list-style: none;
            padding: 10px;
            color: #555;
        }

        .notice li {
            margin-bottom: 10px;
        }

        /* 재고 상태 바 스타일 */
        .progress-bar {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .bar {
            color: white;
            padding: 10px;
            text-align: center;
        }

        .highlight {
            background-color: #ff9800;
        }

        .bar {
            width: 100%;
            background-color: green;
        }

        .bar:nth-child(2) {
            background-color: blue;
        }

        .bar:nth-child(3) {
            background-color: orange;
        }

        .bar:nth-child(4) {
            background-color: #2196f3;
        }
        
        .bar:nth-child(5) {
            background-color: #2196f3;
        }
        
        .bar:nth-child(6) {
            background-color: skyblue;
        }
        .bar:nth-child(7) {
            background-color: red;
        }
        .bar:nth-child(8) {
            background-color: green;
        }
			/* ✅ 전체 컨텐츠 중앙 정렬 */
			.main-content {
				overflow-x: auto;
			    display: flex;
			    flex-direction: column;
			    justify-content: center; /* 세로 중앙 정렬 */
			    align-items: center; /* 가로 중앙 정렬 */
			    width: 100%;
			    height: 100vh; /* 화면 중앙 배치 *
			}
			
			/* ✅ 테이블을 감싸는 컨테이너 */
			.table-container {
			    width: 95%;
			    max-width: 1200px;
			    margin: auto;
			    text-align: center;
			    position: relative;
			}
			
			table {
            width: 100%;
            max-width: 1200px;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
	        }
	        
	        h1 {
			    margin-right: 1200px; /* ✅ 오른쪽으로 이동 */
			    white-space: nowrap; /* ✅ 줄 바꿈 방지 */
			    position: relative;
    			top: -45px; /* ✅ 위로 20px 이동 */
			}
			thead tr{
				background-color:#555;
			}
				        
	        th, td {
	            padding: 12px;
	            text-align: center;
	            border: none;
	        }
	        th {
	        background: #333;
            color: white;
            font-weight: bold;
            }
	        
	        
	        /* ✅ 링크 기본 스타일 수정 */
			td a {
			    text-decoration: none; /* ✅ 밑줄 제거 */
			    color: inherit; /* ✅ 기본 글자색 유지 (필요하면 변경 가능) */
			}
			
			td a:hover {
			    color: #007bff; /* ✅ 마우스를 올렸을 때 색상 변경 (파란색) */
			}
	        
	        tr {
	            background-color: #f4f4f4;
	        }
			
			/* ✅ 검색 입력창 스타일 (가로 길이만 더 늘림) */
			.search-container input {
			    height: 30px; /* ✅ 높이 유지 */
			    width: auto;
			    min-width: 250px; /* ✅ 최소 너비 증가 */
			    max-width: 330px; /* ✅ 최대 너비 증가 */
			    padding: 3px 10px; /* ✅ 내부 여백 그대로 유지 */
			    font-size: 12px; /* ✅ 글씨 크기 유지 */
			    border: 1px solid #ccc;
			    background-color: #f9f9f9;
			    color: #333;
			    outline: none;
			    text-align: left; /* ✅ 내부 글자 왼쪽 정렬 */
			    border-radius: 4px; /* 라운드 형태 적용 */
			}

			
			/* ✅ 입력창 포커스 효과 */
			.search-container input:focus {
			    border: 2px solid #555;
			    background-color: #fff;
			}
		
			.search-container button {
			    height: 38px;
			    padding: 8px 16px;
			    font-size: 15px;
			    border: 2px solid #333;
			    background-color: #333;
			    color: white;
			    border-radius: 6px;
			    cursor: pointer;
			    white-space: nowrap; /* ✅ 버튼 내부 글자가 줄 바꿈되지 않도록 설정 */
			}

			.search-container button:hover {
			    background-color: #555; /
			    border: 2px solid #555;
			    color: white;
			}

			
			
			/* ✅ 검색창 & 버튼 컨테이너 (반응형 적용) */
			.search-container {
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
	            max-width: 1180px;
			}
			
			/* ✅ 페이징 네비게이션 */
			.pagination-container {
			    display: flex;
			    justify-content: center;
			    margin-top: 10px;
			}
			
			/* ✅ 페이징 스타일 */
			.pagination {
			    display: flex;
			    gap: 10px;
			}
			
			.pagination a {
			    display: inline-block;
			    padding: 6px 12px; /* ✅ 버튼 크기 약간 증가 */
			    margin: 0 5px;
			    border: 1px solid #ccc;
			    text-decoration: none;
			    color: #333;
			    border-radius: 5px;
			    background-color: #fff;
			}
			
			.pagination a.active {
			    font-weight: bold;
			    background-color: #f2f2f2;
			}
			
			.pagination a:hover {
			    background-color: #ddd;
			}
			
			/* ✅ 왼쪽 정렬: 재고 신청 & 입고 버튼 */
			.stock-request-container {
			    display: flex;
			    align-items: center;
			    gap: 10px; /* 버튼 간격 */
			}
						
			/* ✅ 공통 버튼 스타일 */
			.stock-request-btn {
			    text-align: center;
			    text-decoration: none; /* 밑줄 제거 */
			    padding: 12px 20px;
			    font-size: 15px;
			    border: 2px solid #888888;
			    background-color: #d9d9d9;
			    color: #333;
			    border-radius: 6px;
			    cursor: pointer;
			    height: 45px;
			    display: inline-block;
			    white-space: nowrap; /* ✅ 버튼 내부 글자가 줄 바꿈되지 않도록 설정 */
			    min-width: 120px; /* ✅ 버튼 최소 너비 */
			}
			
			/* ✅ 버튼 호버 효과 */
			.stock-request-btn:hover {
			    background-color: #bfbfbf;
			}
			
			/* ✅ 업데이트 폼 크기 축소 */
        .update-form {
            display: flex;
            gap: 5px;
            justify-content: center;
            align-items: center;
        }

        .update-form input {
            width: 40px;
            padding: 4px;
            font-size: 12px;
            text-align: center;
        }

        .update-form button {
            padding: 4px 8px;
            font-size: 12px;
            border: 1px solid #888888;
            background-color: #d9d9d9;
            color: #333;
            border-radius: 4px;
            cursor: pointer;
        }

        .update-form button:hover {
            background-color: #bfbfbf;
        }
        
        
	    </style>
</head>


<script>
//재고 신청 창 
// 재고 신청 창 
function openSearchWindow() {
    let valid = false;
    
    // 모든 주문 수량 입력 필드를 순회하면서 값이 비어있지 않고 0이 아닌 경우가 있는지 확인
    $(".orderquantity-input").each(function() {
        let quantity = $(this).val().trim();
        if (quantity !== "" && quantity !== "0") {
            valid = true;
            return false; // 조건을 만족하면 반복문 종료
        }
    });
    
    // 입력값이 없으면 팝업 메시지 출력 후 함수 종료
    if (!valid) {
        alert("주문할 상품을 선택하세요!");
        return;
    }
    
    // 입력값이 있을 경우 재고 신청 창 오픈
    let searchWindow = window.open("/stock/request", "stockRequestWindow", "width=1000,height=800");
    if (searchWindow) {
        searchWindow.focus();
    }
}


//재고 입고 창
function openRestockWindow() {
    window.open("/stock/restock", "restockWindow", "width=600,height=600");
}


</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
$(document).ready(function() {
    // ✅ 페이지 로드 시 orderquantity 값을 불러오기 (없으면 0으로 초기화)
    $(".orderquantity-input").each(function() {
        let inputField = $(this);
        let productId = inputField.data("productid");
        let savedValue = sessionStorage.getItem("orderquantity_" + productId);

        if (savedValue !== null && savedValue !== "") {
            inputField.val(savedValue); // ✅ 세션에서 값이 있으면 불러오기
        } else {
            inputField.val(0); // ✅ 세션 값이 없으면 기본값 0 설정
            sessionStorage.setItem("orderquantity_" + productId, "0"); // ✅ 기본값 저장 (문자열)
        }
    });

    // ✅ 입력값 변경 시, 세션과 서버에 저장
    $(".orderquantity-input").on("input", function() {
        let inputField = $(this);
        let productId = inputField.data("productid");
        let newQuantity = inputField.val().trim();

        // ✅ 숫자가 입력되지 않으면 기본값 0 설정
        if (newQuantity === "" || isNaN(newQuantity)) {
            newQuantity = "0";
        }

        // ✅ 세션에 값 저장 (항상 문자열로 저장)
        sessionStorage.setItem("orderquantity_" + productId, newQuantity);

        // ✅ 서버에 값 저장 (옵션)
        $.ajax({
            type: "POST",
            url: "/stock/saveOrderQuantitySession",  // 서버 엔드포인트
            data: {
                productId: productId,
                orderquantity: newQuantity
            },
            success: function(response) {
                console.log("✅ Order quantity saved successfully.");
            },
            error: function(xhr, status, error) {
                console.error("❌ Error saving order quantity:", error);
            }
        });
    });

    // ✅ 브라우저를 완전히 닫을 때만 sessionStorage 초기화
    $(window).on("beforeunload", function(event) {
        if (navigator.userAgent.indexOf("Firefox") !== -1) {
            event.preventDefault(); // Firefox에서 경고 방지
        }

        // ✅ 창이 닫히는 경우만 초기화
        if (window.closed) {
            $(".orderquantity-input").each(function() {
                let productId = $(this).data("productid");
                sessionStorage.removeItem("orderquantity_" + productId); // 저장된 값 제거
            });
        }
    });
});

//✅ 브라우저가 닫혔다가 다시 열리면 sessionStorage 초기화
window.addEventListener("load", function() {
    if (!sessionStorage.getItem("sessionInitialized")) {
        console.log("🔄 새 세션 감지: 주문 수량을 0으로 초기화합니다.");
        sessionStorage.clear(); // ✅ 모든 데이터 초기화
        sessionStorage.setItem("sessionInitialized", "true"); // ✅ 세션이 초기화되었음을 기록
    }
});

//✅ request.jsp에서 메시지를 받아 주문 수량을 초기화
// ✅ "전체 주문" 메시지를 request.jsp에서 수신하여 모든 orderquantity 값을 0으로 변경
window.addEventListener("message", function(event) {
    if (event.data && event.data.action === "resetOrderQuantities") {
        console.log("✅ stockall.jsp: 모든 주문 수량을 0으로 초기화합니다.");

        // ✅ sessionStorage의 모든 orderquantity 값을 0으로 변경
        Object.keys(sessionStorage).forEach(key => {
            if (key.startsWith("orderquantity_")) {
                sessionStorage.setItem(key, "0");
            }
        });

        // ✅ 화면의 입력 필드 값도 0으로 변경
        document.querySelectorAll(".orderquantity-input").forEach(inputField => {
            inputField.value = "0";
        });
    }
});

// ✅ 페이지가 로드될 때 sessionStorage의 값을 적용 (페이징 이동 시에도 반영)
window.onload = function() {
    console.log("🔄 stockall.jsp: 페이지 로드 시 sessionStorage 적용");

    document.querySelectorAll(".orderquantity-input").forEach(inputField => {
        let productId = inputField.dataset.productid;
        let savedValue = sessionStorage.getItem("orderquantity_" + productId);

        if (savedValue !== null) {
            inputField.value = savedValue; // ✅ sessionStorage 값 적용
        } else {
            inputField.value = "0"; // ✅ 기본값 0 설정
        }
    });
};

document.getElementById("returnLink").href = window.location.origin + "/return";

function updatePlaceholder() {
    var searchType = document.getElementById("searchType").value;
    var searchInput = document.getElementById("searchInput");

    // ✅ 선택된 searchType에 따라 placeholder 변경
    var placeholderMap = {
        "product_name": "상품명을 입력하세요.",
        "model_name": "모델명을 입력하세요.",
        "category": "카테고리를 입력하세요.",
        "detail": "설명을 입력하세요."
    };

    searchInput.placeholder = placeholderMap[searchType];
}

// ✅ 페이지 로드 시 선택된 searchType에 맞게 placeholder 초기화
document.addEventListener("DOMContentLoaded", updatePlaceholder);

function redirectToDetail(productId) {
	window.location.href = '/detail/' + productId;
}
</script>
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
    <!-- ✅ 테이블을 감싸는 컨테이너 (중앙 정렬) -->
    <div class="table-container">
    <h1>재고 확인</h1>
    	<!-- ✅ 검색창 (테이블 위에 위치) -->
		<div class="search-container" style="display: flex; align-items: center; gap: 10px;">
		    
		    <!-- ✅ 주문 수량 아래 재고 신청 버튼 -->
		    <div class="stock-request-container">
		        <button class="stock-request-btn" onclick="openSearchWindow()">재고 추가</button>
		        <button class="stock-request-btn" onclick="openRestockWindow()">재고 등록</button>
		    </div>
		
		
			<form action="/stock/search" method="GET" style="display: flex; gap: 5px;">
			    <!-- ✅ 검색창과 옵션을 하나의 그룹으로 정렬 -->
			    <div style="display: flex; align-items: center; gap: 5px;">
			        <!-- ✅ 검색 입력창 바로 왼쪽에 옵션 추가 -->
			        <select id="searchType" name="searchType"
			                style="height: 38px; font-size: 15px; border-radius: 6px; border: 2px solid #ccc; padding: 6px;"
			                onchange="updatePlaceholder()">
			            <option value="product_name" ${searchType == 'product_name' ? 'selected' : ''}>상품명</option>
			            <option value="model_name" ${searchType == 'model_name' ? 'selected' : ''}>모델명</option>
			            <option value="category" ${searchType == 'category' ? 'selected' : ''}>카테고리</option>
			            <option value="detail" ${searchType == 'detail' ? 'selected' : ''}>설명</option>
			        </select>
			    </div>
			
			    <!-- ✅ 검색 입력창 & 검색 버튼 -->
			    <input type="text" id="searchInput" name="search" placeholder="상품명을 입력하세요." value="${search}">
			    <button type="submit">검색</button>
			</form>
		
		</div>

        <!-- ✅ 현재 페이지 번호 기반으로 시작 인덱스 설정 -->
<c:set var="startIndex" value="${(currentPage - 1) * 10}" />

<table>
    <thead>
        <tr>
            <th>no</th>  <!-- ✅ 번호 추가 -->
            <th>상품명</th>
            <th>모델명</th>
            <th>카테고리</th>
            <th>설명</th>
            <th>수량</th>
            <th>주문 수량</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${CheckStock}" var="Stock" varStatus="status">
            <tr >
                <td onclick="redirectToDetail(${Stock.productId})" style="cursor: pointer;">${startIndex + status.index + 1}</td>  <!-- ✅ 페이지별 번호 계산 -->
                <td onclick="redirectToDetail(${Stock.productId})" style="cursor: pointer;">${Stock.productName}</td>
                <td onclick="redirectToDetail(${Stock.productId})" style="cursor: pointer;">${Stock.modelname}</td>
                <td onclick="redirectToDetail(${Stock.productId})" style="cursor: pointer;">${Stock.category}</td>
                <td onclick="redirectToDetail(${Stock.productId})" style="cursor: pointer;">${Stock.detail}</td>
                <td onclick="redirectToDetail(${Stock.productId})" style="cursor: pointer;">${Stock.quantity}</td>
                <td>
                    <form class="update-form" style="display: inline;">
                        <input type="hidden" name="productId" value="${Stock.productId}">
                        <input type="number" class="orderquantity-input" 
                               data-productid="${Stock.productId}" 
                               min="1" value="${Stock.orderquantity}" required>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>




        <!-- ✅ 페이징 네비게이션 -->
		<div class="pagination-container">
		    <div class="pagination">
		        <c:if test="${begin > 1}">
		            <c:choose>
		                <c:when test="${not empty search}">
		                    <a href="/stock/search?searchType=${searchType}&search=${search}&p=${begin - 1}">« 이전</a>
		                </c:when>
		                <c:otherwise>
		                    <a href="/stock/search?searchType=${searchType}&p=${begin - 1}">« 이전</a>
		                </c:otherwise>
		            </c:choose>
		        </c:if>
		
		        <c:forEach var="i" begin="${begin}" end="${end}">
		            <c:choose>
		                <c:when test="${not empty search}">
		                    <a href="/stock/search?searchType=${searchType}&search=${search}&p=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
		                </c:when>
		                <c:otherwise>
		                    <a href="/stock/search?searchType=${searchType}&p=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
		                </c:otherwise>
		            </c:choose>
		        </c:forEach>
		
		        <c:if test="${end < totalPages}">
		            <c:choose>
		                <c:when test="${not empty search}">
		                    <a href="/stock/search?searchType=${searchType}&search=${search}&p=${end + 1}">다음 »</a>
		                </c:when>
		                <c:otherwise>
		                    <a href="/stock/search?searchType=${searchType}&p=${end + 1}">다음 »</a>
		                </c:otherwise>
		            </c:choose>
		        </c:if>
		    </div>
		</div>
   
    </div>
</div>
	

</body>
</html>