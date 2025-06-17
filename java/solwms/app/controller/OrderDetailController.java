package solwms.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import solwms.app.dto.*;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.OrderDetailService;
import solwms.app.service.WareHouseService;

import java.util.List;

@Controller
@RequestMapping("/orderdetail")
public class OrderDetailController {

    @Autowired
    private OrderDetailService orderDetailService;

    @Autowired
    private InoutHistoryService inoutHistoryService;


    // 주문 상세 페이지 조회
    @GetMapping
    public String getOrderDetails(@RequestParam(name = "orderNumber") int orderNumber, Model model) {
        List<OrderDetail> orderDetails = orderDetailService.getOrderDetailsByOrderNumber(orderNumber);
        Order order = orderDetailService.getOrderByOrderNumber(orderNumber);

        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("order", order);

        return "order/orderDetail";
    }

    // 주문 취소
    @GetMapping("/cancel/{orderNumber}")
    public String cancelOrder(@PathVariable("orderNumber") int orderNumber, RedirectAttributes redirectAttributes) {
        orderDetailService.cancelOrder(orderNumber);
        redirectAttributes.addFlashAttribute("message", "주문이 취소되었습니다.");
        return "redirect:/orderdetail?orderNumber=" + orderNumber;
    }

    // 주문 접수
    @GetMapping("/receive/{orderNumber}")
    public String confirmOrder(@PathVariable("orderNumber") int orderNumber, RedirectAttributes redirectAttributes) {
        List<OrderDetail> orderDetails = orderDetailService.getOrderDetailsByOrderNumber(orderNumber);
        Order orderInfo = orderDetailService.getOrderByOrderNumber(orderNumber);

        // 주문 수량이 재고 수량을 초과하는 경우 주문을 취소
        for (OrderDetail order : orderDetails) {

            ProductDto productInventory = orderDetailService.getProductInventoryByProductName(order.getProductName());

            // 재고 수량이 주문 수량보다 적으면 주문 접수 불가
            if (productInventory != null && productInventory.getQuantity() < order.getQuantity()) {
                // 주문 취소
                orderDetailService.cancelOrder(orderNumber);

                // 에러 메시지 설정
                redirectAttributes.addFlashAttribute("errorMessage",
                        "주문 수량이 재고 수량을 초과하여 주문이 취소되었습니다. 다시 확인해주세요.");
                return "redirect:/orderdetail?orderNumber=" + orderNumber;
            }
        }

        // 재고 차감 및 입출고 처리: 모든 주문에 대해 재고 수량 검사가 끝난 후에 진행
        for (OrderDetail order : orderDetails) {
            // 재고에서 수량 빼기 (out 처리)
            Stock stock = new Stock();
            stock.setQuantity(order.getQuantity());
            stock.setWareName(orderInfo.getDeliveryAddress());
            int productId = inoutHistoryService.findProductId(order.getProductName(), 20);
            stock.setProductId(productId);
            // 재고 수량 차감
            orderDetailService.decreaseProductInventory(order.getProductName(), order.getQuantity());
            inoutHistoryService.saveInoutHistory(stock, "out");
        }

        // 주문 상태를 접수로 업데이트
        orderDetailService.confirmOrder(orderNumber);

        redirectAttributes.addFlashAttribute("message", "주문이 접수되었습니다.");
        return "redirect:/orderdetail?orderNumber=" + orderNumber;
    }



    // 배송 출발
    @GetMapping("/ship/{orderNumber}")
    public String startShipping(@PathVariable("orderNumber") int orderNumber, RedirectAttributes redirectAttributes) {
        orderDetailService.startShipping(orderNumber);
        redirectAttributes.addFlashAttribute("message", "배송이 출발하였습니다.");
        return "redirect:/orderdetail?orderNumber=" + orderNumber;
    }

    // 배송 완료
    @GetMapping("/deliver/{orderNumber}")
    public String completeDelivery(@PathVariable("orderNumber") int orderNumber, RedirectAttributes redirectAttributes) {
        // 배송 완료 처리
        orderDetailService.completeDelivery(orderNumber);

        // 주문 상세 정보 조회
        List<OrderDetail> orderDetails = orderDetailService.getOrderDetailsByOrderNumber(orderNumber);
        Order orderinfo = orderDetailService.getOrderByOrderNumber(orderNumber);

        // 현재 로그인한 사용자의 정보 가져오기

        String employeeNumber = orderinfo.getEmployeeNumber();

        WareHouse wareHouse = orderDetailService.getWarehouseByEmployeeNumber(employeeNumber);

        if (wareHouse != null) {

            // 각 제품에 대해 재고 수량을 해당 창고에 추가
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
        } else {
            // 해당 직원 번호에 맞는 창고가 없으면 오류 처리
            redirectAttributes.addFlashAttribute("errorMessage", "해당 직원 번호에 맞는 창고를 찾을 수 없습니다.");
            return "redirect:/orderdetail?orderNumber=" + orderNumber;
        }

        // 배송 완료 메시지
        redirectAttributes.addFlashAttribute("message", "배송이 완료되었습니다.");
        return "redirect:/orderdetail?orderNumber=" + orderNumber;
    }

}