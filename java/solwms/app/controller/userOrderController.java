package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import solwms.app.dto.Order;
import solwms.app.service.OrderService;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class userOrderController {

    @Autowired
    private OrderService orderService;

    // 주문 목록 페이지 (JSON 반환 + ResponseEntity)
    @GetMapping("/order/all")
    public ResponseEntity<Map<String, Object>> getAllOrders(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "size", defaultValue = "10") int size
    ) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();

        // 유저의 총 주문 개수
        int totalOrders = orderService.getTotalOrdersUser(employeeNumber);
        // 전체 페이지 수 계산
        int totalPages = (int) Math.ceil((double) totalOrders / size);

        // 잘못된 페이지 값 처리
        if (page < 1) {
            page = 1;
        } else if (page > totalPages) {
            page = totalPages;
        }

        // 모든 주문 목록 가져오기
        List<Order> orders = orderService.getAllOrdersByEmployeeNumber(employeeNumber);

        // 페이징 적용
        int fromIndex = Math.max(0, (page - 1) * size);
        int toIndex = Math.min(fromIndex + size, orders.size());
        List<Order> paginatedOrders = orders.subList(fromIndex, toIndex);

        // 한 번에 표시할 페이지 개수 (5개)
        int pageNum = 5;
        int begin = ((page - 1) / pageNum) * pageNum + 1;
        int end = Math.min(begin + pageNum - 1, totalPages);

        // JSON으로 반환할 데이터 구성
        Map<String, Object> response = new HashMap<>();
        response.put("orders", paginatedOrders);
        response.put("currentPage", page);
        response.put("totalPages", totalPages);
        response.put("begin", begin);
        response.put("end", end);

        // ResponseEntity.ok()를 통해 200 OK + Body 전달
        return ResponseEntity.ok(response);
    }


    // 주문 검색 (JSON 반환 + ResponseEntity)
    @GetMapping("/order/search")
    public ResponseEntity<List<Order>> searchOrders(
            @RequestParam(name = "orderNumber", required = false) Integer orderNumber,
            @RequestParam(name = "orderDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate orderDate
    ) {
        // 검색 조건으로 주문 목록 조회
        List<Order> orders = orderService.searchOrdersUser(orderNumber, orderDate);

        // List<Order>를 그대로 JSON으로 반환 (200 OK)
        return ResponseEntity.ok(orders);
    }
}
