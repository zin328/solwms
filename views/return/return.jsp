<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>


<meta charset="UTF-8">
<link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
<title>기자재반납</title>
<script>
    function openSearchWindow() {
        window.open("/return/search", "검색 결과", "width=1200,height=800");
    }

        function confirmSubmission(event) {
            event.preventDefault(); // 기본 제출 동작 방지

            let Quantity = parseInt(document.getElementById("quantity").value);
            let returnQuantity = parseInt(document.getElementById("returnQuantity").value);

            if (isNaN(Quantity) || isNaN(returnQuantity)) {
                alert("올바른 반납 수량을 입력하세요.");
                return;
            }

            if (returnQuantity > Quantity) {
                alert("반납 수량이 현재 보유한 수량보다 많습니다.\n\n" +
                      "현재 보유 수량: " + Quantity + "개\n" +
                      "입력한 반납 수량: " + returnQuantity + "개\n\n" +
                      "다시 입력해주세요.");
                return;
            }

            alert("반납이 완료되었습니다.");
            document.getElementById("returnForm").submit();
        }
    </script>


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
            margin-left: 200px;
            padding: 20px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 0px;
        }
		.form-group {
		        margin-bottom: 15px; /* 간격 추가 */
		        width: 100%;
		        max-width: 600px; /* 최대 너비 설정 */
		        align-items:left;
		    }

		    label {
		        font-weight: bold;
		        font-size: 14px;
		        margin-bottom: 5px;
		        display: block;
		    }

		    .form-control {
		        width: 100%;
		        padding: 10px;
		        font-size: 14px;
		        border: 1px solid #ccc;
		        border-radius: 8px;
		        
		        box-sizing: border-box;
		    }

		    /* 검색 버튼 스타일 */
		    .btn-search {
		        background-color: #333;
		        color: white;
		        padding: 8px 16px;
		        border: none;
		        border-radius: 5px;
		        cursor: pointer;
		        margin-top: 5px;
		        font-size: 14px;
		    }

		    .btn-search:hover {
		        background-color: #ec971f;
		    }

		    /* 제출 버튼 스타일 */
		    .btn-submit {
		        background-color: #333;
		        color: white;
		        padding: 10px 20px;
		        border: none;
		        border-radius: 5px;
		        cursor: pointer;
		        font-size: 14px;
		        margin-top: 20px;
		    }

		    .btn-submit:hover {
		        background-color: #218838;
		    }

		    /* 창고 위치 선택 스타일 */
		    select.form-control {
		        width: 100%;
		        padding: 10px;
		        font-size: 14px;
		        border: 1px solid #ccc;
		        border-radius: 8px;
		        box-sizing: border-box;
		    }

		    /* 반납 폼 레이아웃 */
		    .form-group input,
		    .form-group select {
		        margin-bottom: 15px; /* 항목 간 간격 추가 */
		    }

		    .form-group input[type="number"] {
		        -moz-appearance: textfield;
		    }
		    .form-group input[type="number"]::-webkit-outer-spin-button,
		    .form-group input[type="number"]::-webkit-inner-spin-button {
		        -webkit-appearance: none;
		        margin: 0;
		    }
        /* 페이지 네비게이션 스타일 */
        
        .pagination-container{
            display: flex;
		    justify-content: center;
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

        .pagination-link:hover {
            background-color: #ddd;
        }

        /* 반납 기록 테이블 스타일 */
        .inventory-table {
            width: 100%;
            max-width: 1200px;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
            margin-top:0px;
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

       

    </style>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f4f4f4;">

      <header>
      <h1 style="margin: 0;">
         <a href="/adminMain" style="text-decoration: none; color: inherit;">OH! WMS</a>
      </h1>
      <div style="display: flex; align-items: center;">
         <a href="/admin/changePassword" style="color: white; font-weight: bold; text-decoration: none; margin-right: 30px;">비밀번호 변경</a>
         <a href="/logout" style="color: white; font-weight: bold; text-decoration: none;">로그아웃</a>
      </div>
   </header>

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

	<div class="main-content">
	    <h1>기자재반납</h1>

	    <form id="returnForm" action="return/submit" method="POST" onsubmit="confirmSubmission(event)">
	        <input type="hidden" name="_csrf" value="${_csrf.token}">

	        <div class="form-group">
	            <label for="employeeNumber">신청인</label>
	            <input type="text" id="employeeNumber" name="employeeNumber" class="form-control" value="${sessionScope.loggedInUser}" readonly>
	        </div>

	        <div class="form-group">
	            <label for="productName">자재명</label>
	            <input type="text" id="productName" name="productName" class="form-control" readonly placeholder="검색을 통해 자재명을 입력">
	            <button type="button" onclick="openSearchWindow()" class="btn btn-search">검색</button>
	        </div>

	        <div class="form-group">
	            <label for="productId">제품번호</label>
	            <input type="text" id="productId" name="productId" class="form-control" readonly placeholder="제품번호 자동 입력">
	        </div>

	        <div class="form-group">
	            <label for="returnQuantity">반납 수량</label>
	            <input type="number" id="returnQuantity" name="returnQuantity" class="form-control" required placeholder="반납할 수량을 입력">
	        </div>

	        <div class="form-group">
	            <label for="returnWareHouseNumber">반납 위치</label>
	            
	            <select name="returnWareHouseNumber" id="returnWareHouseNumber" class="form-control" required>
	                <option value="">창고위치 선택</option>
	                <option value="20">관리자 창고</option>
	                
	            </select>
	        </div>

	        <div class="form-group">
	            <label for="returnReason">반납 사유</label>
	            <input type="text" name="returnReason" id="returnReason" class="form-control" placeholder="반납 사유를 입력">
	        </div>

	        <input type="hidden" name="category" id="category">
	        <input type="hidden" name="detail" id="detail">
	        <input type="hidden" name="modelName" id="modelName">
	        <input type="hidden" name="OriginwarehouseNumber" id="OriginwarehouseNumber">
	        <input type="hidden" name="quantity" id="quantity">

	        <div class="form-group">
	            <input type="submit" value="반납" class="btn btn-submit">
	        </div>
	    </form>

        <div class="table">
            <h2>반납 기록</h2>
            <table class="inventory-table">
                <thead>
                    <tr>
                        <th>no</th>
                        <th>사원 번호</th>
                        <th>제품 ID</th>
                        <th>제품명</th>
                        <th>반납 수량</th>                        
                        <th>기존 창고 위치</th>
						<th>반납 창고 위치</th>
                        <th>반납 사유</th>
                        <th>반납 날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="returnHistory" items="${returnHistoryList}">
                        <tr>
                            <td>${returnHistory.returnNumber}</td>
                            <td>${returnHistory.employeeNumber}</td>
                            <td>${returnHistory.product_id}</td>
                            <td>${returnHistory.product_name}</td>
                            <td>${returnHistory.returnQuantity}</td>
							<td>
							    ${returnHistory.wareName}
							</td>
							<td>
								관리자 창고
							</td>
							                            
							
							
							
                            <td>${returnHistory.returnReason}</td>   
                            <td><fmt:formatDate value="${returnHistory.returnDate}" pattern="yyyy년 MM월 dd일" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div id="page" class="pagination-container">
            <c:if test="${begin > pageNum }">
                <a href="return?p=${begin-1 }" class="pagination-link">« 이전</a>
            </c:if>
            <c:forEach begin="${begin }" end="${end}" var="i">
                <a href="return?p=${i}" class="pagination-link ${i == pa ? 'active' : ''}">${i}</a>
            </c:forEach>
            <c:if test="${end < totalPages }">
                <a href="return?p=${end+1}" class="pagination-link">다음 »</a>
            </c:if>
        </div>
    </div>

</body>
</html>
