package solwms.app.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Stock {
	private int productId;
	private String productName;
	private String detail;
	private int quantity;
	private int orderquantity;
	private String category;
	private String modelname;
	private int warehouseNumber;
	private String imageName;
	private String qrCode;
	private String wareName;
	private String employeeNumber;
	
    @Data
    public static class OrderHistory {
        private int orderNumber;  // 자동 증가되는 PK
        private LocalDateTime orderDate;  // 주문 날짜
        private String state;  // 주문 상태 (기본값: ORDER_PENDING)
        private String deliveryAddress;  // 배송 주소 (물류창고)
        private String shippingAddress;  // 사용자 주소 (User 테이블에서 가져옴)
        private LocalDateTime arrivalDate;  // 도착 예정 날짜 (주문 날짜 + 7일)
        private String employeeNumber;  // 주문한 직원의 ID
    }

    // ✅ OrderDetail 추가
    @Data
    public static class OrderDetail {
        private int orderDetailId;  // 자동 증가되는 PK
        private int orderNumber;  // OrderHistory의 orderNumber (FK)
        private int productId;  // ProductInventory의 product_id (FK)
        private String productName;  // 상품명
        private String modelName;  // 모델명
        private String category;  // 카테고리
        private int quantity;  // 주문한 수량
    }
}
