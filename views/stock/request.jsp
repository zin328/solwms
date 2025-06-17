<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    
    <title>재고 추가 목록</title>

    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>재고 신청 목록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
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
             top: -60px; /* ✅ 위로 20px 이동 */
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
        .update-form {
            display: flex;
            gap: 10px;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        /* 검색창 스타일 */
        .search-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            width: 100%;
            max-width: 1200px;
            margin-bottom: 5px;
            position: relative;
        }
        .search-container input {
            height: 30px; /* ✅ 높이 유지 */
		    width: auto;
		    min-width: 250px; /* ✅ 최소 너비 증가 */
		    max-width: 330px; /* ✅ 최대 너비 증가 */
		    padding: 3px 10px; /* ✅ 내부 여백 그대로 유지 */
		    font-size: 11px; /* ✅ 글씨 크기 유지 */
		    border: 1px solid #ccc;
		    background-color: #f9f9f9;
		    color: #333;
		    outline: none;
		    text-align: left; /* ✅ 내부 글자 왼쪽 정렬 */
		    border-radius: 4px; /* 라운드 형태 적용 */
		    position: relative;
    		top: -4px; /* 위로 3px 이동 */
        }
        .search-container button {
            height: 38px;
            padding: 8px 16px;
            font-size: 16px;
            border: 2px solid #333;
		    background-color: #333;
		    color: white;
		    border-radius: 6px;
		    cursor: pointer;
		    white-space: nowrap; /* ✅ 버튼 내부 글자가 줄 바꿈되지 않도록 설정 */
        }
        
        .result {
		    display: flex;
		    justify-content: center; /* ✅ 버튼을 가운데 정렬 */
		    align-items: center; /* ✅ 세로 중앙 정렬 */
		}
		
		.result button {
		    display: flex; /* ✅ 내부 글자를 중앙 정렬하기 위해 flex 사용 */
		    justify-content: center; /* ✅ 버튼 내부 글자 가로 중앙 정렬 */
		    align-items: center; /* ✅ 버튼 내부 글자 세로 중앙 정렬 */
		    height: 50px; /* ✅ 버튼 높이 증가 */
		    padding: 16px 32px; /* ✅ 상하 패딩 증가 */
		    font-size: 18px; 
		    border: 2px solid #333;
		    background-color: #333;
		    color: white;
		    border-radius: 6px;
		    cursor: pointer;
		    white-space: nowrap; /* ✅ 버튼 내부 글자가 줄 바꿈되지 않도록 설정 */
		}

        .search-container button:hover {
			    background-color: #555; /* ✅ 파란색 */
			    border: 2px solid #555;
			    color: white;
			}
    </style>
</head>
<body>
    <h2>재고 추가 목록</h2>
    <div class="search-container">
        <form action="/stock/find" method="GET">
            <input type="text" name="search" placeholder="상품명을 입력하세요..." value="${search}">
            <button type="submit">검색</button>
        </form>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>상품명</th>
                <th>모델명</th>
                <th>수량</th>
                <th>주문 수량</th>
            </tr>
        </thead>
        <tbody>
		    <form id="bulkUpdateForm" action="/stock/updateAllOrderQuantities" method="post">
		       <c:forEach var="stock" items="${stockList}">
		         <tr id="row_${stock.productId}">
		            <td>${stock.productName}</td>
		            <td>${stock.modelname}</td>
		            <td>${stock.quantity}</td>
		            <td>
		                <input type="number" id="orderQuantityInput_${stock.productId}" 
		                       name="orderQuantities[${stock.productId}]" 
		                       value="${stock.orderquantity}" min="0"
		                       class="orderquantity-input"
		                       data-productid="${stock.productId}"
		                       onchange="updateOrderQuantity(${stock.productId})">
		            </td>
		        </tr>
		    </c:forEach>
		    </form>
		</tbody>

    </table>

    <div class = "result">
        <button onclick="sendOrderQuantitiesToServer()">전체 주문</button>
    </div>

    <script>

 // ✅ 브라우저가 새로 열리면 sessionStorage 초기화
    window.addEventListener("load", function() {
        if (!sessionStorage.getItem("sessionInitialized")) {
            console.log("🔄 새 세션 감지: 주문 수량을 0으로 초기화합니다.");
            sessionStorage.clear(); // ✅ 모든 데이터 초기화
            sessionStorage.setItem("sessionInitialized", "true"); // ✅ 세션 초기화 완료 표시
        }
    });
    window.onload = function() {
        document.querySelectorAll(".orderquantity-input").forEach(inputField => {
            let productId = inputField.id.replace("orderQuantityInput_", "");
            let row = document.getElementById("row_" + productId);
            let storedQuantity = sessionStorage.getItem("orderquantity_" + productId);

            // ✅ sessionStorage 값이 없으면 기본값 0으로 설정
            let quantity = storedQuantity !== null ? parseInt(storedQuantity, 10) : 0;

            if (quantity === 0) {
                row.style.display = "none";
            } else {
                row.style.display = "";
            }

            inputField.value = quantity; // ✅ 기본값 적용
        });
    };



        function enableEdit(productId) {
            let textSpan = document.getElementById("orderQuantityText_" + productId);
            let inputField = document.getElementById("orderQuantityInput_" + productId);

            textSpan.style.display = "none";  
            inputField.style.display = "inline"; 
            inputField.focus(); 
        }

        function sendOrderQuantitiesToServer() {
            let stocks = [];

            document.querySelectorAll(".orderquantity-input").forEach(inputField => {
                let productId = inputField.getAttribute("data-productid");  
                let quantity = parseInt(inputField.value.trim(), 10); 

                if (!isNaN(quantity) && quantity > 0) {  
                    stocks.push({ productId: parseInt(productId, 10), orderquantity: quantity });
                }
            });

            if (stocks.length === 0) {
                alert("🚨 주문할 상품이 없습니다!");
                return;
            }

            let csrfTokenMeta = document.querySelector("meta[name='_csrf']");
            let csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");
            
            let csrfToken = csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : "";
            let csrfHeader = csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : "";

            let headers = { "Content-Type": "application/json" };
            if (csrfHeader && csrfToken) {
                headers[csrfHeader] = csrfToken;
            }

            fetch("/stock/createOrder", {
                method: "POST",
                headers: headers,
                body: JSON.stringify(stocks)
            }).then(response => response.text())
              .then(data => {
                  alert(data);
                  if (window.opener) {
                      window.opener.postMessage({ action: "resetOrderQuantities" }, "*");
                  }
                  window.close();
              })
              .catch(error => {
                  alert("❌ 주문 저장 중 오류가 발생했습니다.");
              });
        }


        // ✅ 버튼 이벤트 리스너 등록
        document.addEventListener("DOMContentLoaded", function() {
            let button = document.getElementById("sendOrderButton");
            if (button) {
                button.addEventListener("click", sendOrderQuantitiesToServer);
            }
        });



    </script>

</body>
</html>
