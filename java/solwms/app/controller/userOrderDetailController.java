package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import solwms.app.dto.*;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.OrderDetailService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orderdetail")
public class userOrderDetailController {

    @Autowired
    private OrderDetailService orderDetailService;

    @Autowired
    private InoutHistoryService inoutHistoryService;

    // 주문 상세 페이지 조회 (JSON 반환)
    @GetMapping
    public ResponseEntity<Map<String, Object>> getOrderDetails(@RequestParam(name = "orderNumber") int orderNumber) {
        List<OrderDetail> orderDetails = orderDetailService.getOrderDetailsByOrderNumber(orderNumber);
        Order order = orderDetailService.getOrderByOrderNumber(orderNumber);

        Map<String, Object> response = new HashMap<>();
        response.put("orderDetails", orderDetails);
        response.put("order", order);

        return ResponseEntity.ok(response);
    }

    // 주문 취소 (JSON 반환)
    @GetMapping("/cancel/{orderNumber}")
    public ResponseEntity<Map<String, Object>> cancelOrder(@PathVariable("orderNumber") int orderNumber) {
        orderDetailService.cancelOrder(orderNumber);

        Map<String, Object> response = new HashMap<>();
        response.put("message", "주문이 취소되었습니다.");
        response.put("orderNumber", orderNumber);

        return ResponseEntity.ok(response);
    }

    // 주문 접수 (JSON 반환)
    @GetMapping("/receive/{orderNumber}")
    public ResponseEntity<Map<String, Object>> confirmOrder(@PathVariable("orderNumber") int orderNumber) {
        List<OrderDetail> orderDetails = orderDetailService.getOrderDetailsByOrderNumber(orderNumber);
        Order orderInfo = orderDetailService.getOrderByOrderNumber(orderNumber);
        for (OrderDetail order : orderDetails) {
            ProductDto productInventory = orderDetailService.getProductInventoryByProductName(order.getProductName());
            if (productInventory != null && productInventory.getQuantity() < order.getQuantity()) {
                orderDetailService.cancelOrder(orderNumber);
                Map<String, Object> response = new HashMap<>();
                response.put("errorMessage", "주문 수량이 재고 수량을 초과하여 주문이 취소되었습니다. 다시 확인해주세요.");
                response.put("orderNumber", orderNumber);
                return ResponseEntity.ok(response);
            }
        }

        // 재고 차감 및 입출고 처리
        for (OrderDetail order : orderDetails) {
            Stock stock = new Stock();
            stock.setProductName(order.getProductName());
            stock.setQuantity(order.getQuantity());
            stock.setWareName(orderInfo.getShippingAddress());
            inoutHistoryService.saveInoutHistory(stock, "out");

            orderDetailService.decreaseProductInventory(order.getProductName(), order.getQuantity());
        }

        // 주문 상태를 접수로 업데이트
        orderDetailService.confirmOrder(orderNumber);

        Map<String, Object> response = new HashMap<>();
        response.put("message", "주문이 접수되었습니다.");
        response.put("orderNumber", orderNumber);
        return ResponseEntity.ok(response);
    }

    // 배송 출발 (JSON 반환)
    @GetMapping("/ship/{orderNumber}")
    public ResponseEntity<Map<String, Object>> startShipping(@PathVariable("orderNumber") int orderNumber) {
        orderDetailService.startShipping(orderNumber);

        Map<String, Object> response = new HashMap<>();
        response.put("message", "배송이 출발하였습니다.");
        response.put("orderNumber", orderNumber);
        return ResponseEntity.ok(response);
    }

    // 배송 완료 (JSON 반환)
    @GetMapping("/deliver/{orderNumber}")
    public ResponseEntity<Map<String, Object>> completeDelivery(@PathVariable("orderNumber") int orderNumber) {
        // 배송 완료 처리
        orderDetailService.completeDelivery(orderNumber);

        List<OrderDetail> orderDetails = orderDetailService.getOrderDetailsByOrderNumber(orderNumber);
        Order orderInfo = orderDetailService.getOrderByOrderNumber(orderNumber);
        String employeeNumber = orderInfo.getEmployeeNumber();

        WareHouse wareHouse = orderDetailService.getWarehouseByEmployeeNumber(employeeNumber);
        if (wareHouse == null) {
            Map<String, Object> response = new HashMap<>();
            response.put("errorMessage", "해당 직원 번호에 맞는 창고를 찾을 수 없습니다.");
            response.put("orderNumber", orderNumber);
            return ResponseEntity.ok(response);
        }

        for (OrderDetail order : orderDetails) {
            Stock stock = new Stock();
            stock.setQuantity(order.getQuantity());
            stock.setWareName(wareHouse.getWareName());

            orderDetailService.increaseProductQuantity(order.getProductName(), order.getQuantity(), wareHouse.getWarehouseNumber());

            int productId = inoutHistoryService.findProductId(order.getProductName(), wareHouse.getWarehouseNumber());
            stock.setProductId(productId);
            // 창고의 재고 수량 업데이트 (in 처리)
            inoutHistoryService.saveInoutHistory(stock, "in");
        }


        Map<String, Object> response = new HashMap<>();
        response.put("message", "배송이 완료되었습니다.");
        response.put("orderNumber", orderNumber);
        return ResponseEntity.ok(response);
    }
}
