<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>자재 검색</title>
	<script>
	    function selectProduct(productName, productId, category, detail, modelName, OriginwarehouseNumber,quantity) {
	        // 부모 창이 존재하는지 확인
	        if (window.opener && !window.opener.closed) {
	            // 부모 창의 input 필드에 값 설정
	            var inputFieldName = window.opener.document.getElementById("productName");
	            var inputFieldId = window.opener.document.getElementById("productId");
	            var inputFieldCategory = window.opener.document.getElementById("category");
	            var inputFieldDetail = window.opener.document.getElementById("detail");
	            var inputFieldModelName = window.opener.document.getElementById("modelName");
				var inputFieldWarehouseNumber = window.opener.document.getElementById("OriginwarehouseNumber");
				var inputFieldQuantity = window.opener.document.getElementById("quantity");

	            if (inputFieldName && inputFieldId && inputFieldCategory && inputFieldDetail && inputFieldModelName && inputFieldWarehouseNumber && inputFieldQuantity) {
	                // 각 필드에 값 설정
	                inputFieldName.value = productName; // 자재명
	                inputFieldId.value = productId;     // 제품 ID
	                inputFieldCategory.value = category; // 카테고리
	                inputFieldDetail.value = detail;    // 상세설명
	                inputFieldModelName.value = modelName; // 모델명
					inputFieldWarehouseNumber.value = OriginwarehouseNumber; // 창고번호
					inputFieldQuantity.value=quantity;
	            } else {
	                alert("부모 창에서 input 필드를 찾을 수 없습니다.");
	            }

	            // 창 닫기
	            window.close();
	        } else {
	            alert("부모 창이 존재하지 않습니다.");
	        }
	    }
	</script>

	<style>
	    table {
	        width: 100%;
	        max-width: 1200px;
	        border-collapse: collapse;
	        background: #fff;
	        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	        border-radius: 8px;
	        overflow: hidden;
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

	    tr {
	        background-color: #f4f4f4;
	    }

	    tr:hover {
	        background-color: #e9e9e9; /* Hover effect for rows */
	    }

	    td a {
	        text-decoration: none;
	        color: inherit;
	    }

	    td a:hover {
	        color: #007bff; /* Change link color on hover */
	    }
		/* 검색 버튼 스타일 */
		   .btn-search {
		       background-color: #333;
		       color: white;
		       padding: 12px 24px;
		       border: none;
		       border-radius: 6px;
		       cursor: pointer;
		       font-size: 15px;
		       margin-top: 5px;
		       transition: background-color 0.3s ease; /* 부드러운 색상 전환 */
		   }

		   .btn-search:hover {
		       background-color: #ec971f;
		   }

		   /* 제출 버튼 스타일 */
		   .btn-submit {
		       background-color: #333;
		       color: white;
		       padding: 12px 24px;
		       border: none;
		       border-radius: 6px;
		       cursor: pointer;
		       font-size: 15px;
		       margin-top: 20px;
		       transition: background-color 0.3s ease; /* 부드러운 색상 전환 */
		   }

		   .btn-submit:hover {
		       background-color: #218838;
		   }
	</style>

</head>
<body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
    <h2>자재 검색</h2>

    <form method="GET" action="/return/search" style="display: flex; gap: 10px; align-items: center;">
        검색어: 
        <input type="text" name="product_name" value="${param.product_name}" placeholder="모델/자재명으로 검색" style="padding: 8px; border-radius: 6px; border: 1px solid #ccc; font-size: 14px;">
        <button type="submit" class="btn-search">검색</button>
    </form>

    <!-- 검색 결과가 없는 경우, 전체 제품을 표시 -->
    <c:choose>
        <c:when test="${not empty products}">
            <table>
                <thead>
                    <tr>
                        <th>창고번호</th>
                        <th>제품 ID</th> 
                        <th>식별번호</th> 
                        <th>제품명</th> 
                        <th>재고 수량</th> 
                        <th>선택</th> 
                    </tr> 
                </thead> 
                <tbody> 
                    <c:forEach var="product" items="${products}"> 
                        <tr>
                            <td>${product.warehouseNumber}</td>
                            <td>${product.model_name}</td>
                            <td>${product.product_id}</td>
                            <td>${product.product_name}</td>
                            <td>${product.quantity}</td>
                            <td>
                                <!-- 제품명과 ID를 전달하도록 수정 -->
                                <button type="button" onclick="selectProduct('${product.product_name}', '${product.product_id}', '${product.detail}', '${product.category}', '${product.model_name}', '${product.warehouseNumber}','${product.quantity}')" class="btn-submit">
                                    선택
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when> 
        <c:otherwise> 
            <p>❌ 검색 결과가 없습니다.</p> 
        </c:otherwise> 
    </c:choose> 
</body> 
 
</html>
