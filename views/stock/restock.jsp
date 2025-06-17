<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>재고 등록</title>
    <link rel="icon" href="/resources/icon/wmsicon.png" type="image/png"/>
    <title>재고 입고</title>
    <meta name="_csrf" content="${_csrf.token}" />
	<meta name="_csrf_header" content="${_csrf.headerName}" />

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
        }
        .form-container {
            width: 100%;
            max-width: 400px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
            text-align: center;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
            text-align: left;
        }
        input, button {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .image-preview {
            width: 100%;
            max-height: 200px;
            object-fit: cover;
            margin-top: 10px;
            display: none;
        }
        
        select#warehouseNumber {
	        width: 100%; /* 전체 너비 사용 */
	        max-width: 400px; /* 최대 너비 지정 */
	        height: 40px; /* 높이 조정 */
	        font-size: 16px; /* 글자 크기 증가 */
	        padding: 5px; /* 내부 여백 */
	        border: 1px solid #ccc; /* 테두리 스타일 */
	        border-radius: 5px; /* 모서리 둥글게 */
	        background-color: #fff; /* 배경색 */
	    }
    </style>

    <script>
    function submitRestockForm(event) {
        event.preventDefault(); // ✅ 기본 폼 제출 방지

        let formData = new FormData();
        formData.append("productName", document.getElementById("productName").value);
        formData.append("modelname", document.getElementById("modelname").value);
        formData.append("category", document.getElementById("category").value);
        formData.append("detail", document.getElementById("detail").value);

        let quantity = parseInt(document.getElementById("quantity").value, 10);
        if (isNaN(quantity) || quantity < 1) {
            alert("❌ 수량은 1 이상이어야 합니다.");
            return;
        }
        formData.append("quantity", quantity);

        let warehouseNumber = document.getElementById("warehouseNumber").value;
        if (!warehouseNumber) {
            alert("🚨 창고를 선택하세요!");
            return;
        }
        formData.append("warehouseNumber", warehouseNumber);

        let fileInput = document.getElementById("productImage");
        if (fileInput.files.length > 0) {
            formData.append("image", fileInput.files[0]); // ✅ 이미지 파일 추가
        }

        // ✅ CSRF 토큰 가져오기
        let csrfTokenMeta = document.querySelector("meta[name='_csrf']");
        let csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");

        if (!csrfTokenMeta || !csrfHeaderMeta) {
            alert("❌ 보안 문제 발생: 페이지를 새로고침하세요.");
            return;
        }

        let csrfToken = csrfTokenMeta.getAttribute("content");
        let csrfHeader = csrfHeaderMeta.getAttribute("content");

        // ✅ AJAX 요청 (입고 완료 요청)
        fetch("/stock/add", {
            method: "POST",
            headers: csrfHeader && csrfToken ? { [csrfHeader]: csrfToken } : {}, // ✅ CSRF 헤더가 있을 때만 추가
            body: formData
        }).then(response => {
            if (response.ok) {
                return response.text();
            } else {
                throw new Error("❌ 입고 저장 실패!");
            }
        }).then(message => {
            alert(message);
            window.opener.location.reload(); // ✅ 부모 창(stockall.jsp) 새로고침
            window.close(); // ✅ 현재 창 닫기
        }).catch(error => {
            console.error("❌ 오류 발생:", error);
            alert("❌ 이미 등록 되어있는 상품입니다!");
        });
    }
    function previewImage(event) {
        let file = event.target.files[0];
        if (file) {
            let reader = new FileReader();
            reader.onload = function(e) {
                let imagePreview = document.getElementById("imagePreview");
                imagePreview.src = e.target.result;
                imagePreview.style.display = "block"; // 미리보기 표시
            };
            reader.readAsDataURL(file);
        }
    }

    // ✅ 폼 제출 이벤트 리스너 추가
    document.addEventListener("DOMContentLoaded", function() {
        let form = document.getElementById("restockForm");
        if (form) {
            form.addEventListener("submit", submitRestockForm);
        }
    });


    </script>
</head>
<body>
    <div class="form-container">
        <h2>재고 등록</h2>
        <form onsubmit="submitRestockForm(event)">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        	<label for="productImage">상품 이미지</label>
            <input type="file" id="productImage" name="productImage" accept="image/*" onchange="previewImage(event)">
            <img id="imagePreview" class="image-preview" alt="이미지 미리보기">
        
            <label for="productName">상품명</label>
            <input type="text" id="productName" name="productName" required>
        
            <label for="modelname">모델명</label>
            <input type="text" id="modelname" name="modelname" required>
        
            <label for="category">카테고리</label>
            <input type="text" id="category" name="category">
        
            <label for="detail">설명</label>
            <input type="text" id="detail" name="detail">
        
            <label for="quantity">수량</label>
            <input type="number" id="quantity" name="quantity" required min="1">
        
            <label for="warehouseNumber">창고 선택</label>
			<select id="warehouseNumber" name="warehouseNumber" required>
			    <option value="">창고를 선택하세요</option>
			    <c:forEach var="warehouseNumber" items="${warehouseNumbers}">
			        <option value="${warehouseNumber}">${warehouseNumber}</option>
			    </c:forEach>
			</select>


        
            <button type="submit">등록 완료</button>
        </form>
    </div>
</body>
</html>
