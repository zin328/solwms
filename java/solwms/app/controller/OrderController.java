package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import solwms.app.dto.Order;
import solwms.app.service.OrderService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // 주문 목록 페이지 (페이징 처리)
    @GetMapping("/all")
    public String getAllOrders(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "size", defaultValue = "10") int size,
            Model model) {

        // 전체 주문 개수 조회
        int totalOrders = orderService.getTotalOrders();
        int totalPages = (int) Math.ceil((double) totalOrders / size); // 전체 페이지 수

        // 잘못된 페이지 값 처리
        if (page < 1) {
            page = 1;
        } else if (page > totalPages) {
            page = totalPages;
        }

        // 모든 주문을 가져옴
        List<Order> orders = orderService.getAllOrders();

        // fromIndex가 음수가 되지 않도록 조정
        int fromIndex = Math.max(0, (page - 1) * size);
        int toIndex = Math.min(fromIndex + size, orders.size());

        // 페이징 적용
        List<Order> paginatedOrders = orders.subList(fromIndex, toIndex);

        // 페이지 블록 계산 (1~5 범위 유지)
        int pageNum = 5; // 한 번에 보여줄 페이지 개수
        int begin = (page - 1) / pageNum * pageNum + 1;
        int end = begin + pageNum - 1;
        if (end > totalPages) {
            end = totalPages;
        }

        // 모델에 데이터 추가
        model.addAttribute("orders", paginatedOrders);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("begin", begin);
        model.addAttribute("end", end);
        model.addAttribute("pageNum", pageNum);

        return "order/order";
    }





    @GetMapping("/search")
    public String searchOrders(
            @RequestParam(name = "orderNumber",required = false) Integer orderNumber,
            @RequestParam(name = "employeeNumber",required = false) String employeeNumber,
            @RequestParam(name = "orderDate",required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate orderDate,
            Model model) {

        List<Order> orders = orderService.searchOrders(orderNumber, employeeNumber, orderDate);
        model.addAttribute("orders", orders);
        return "order/order";
    }
}