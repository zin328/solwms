package solwms.app.service;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import solwms.app.dao.OrderDao;
import solwms.app.dto.Order;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {

    @Autowired
    private OrderDao orderDao;

    public List<Order> getAllOrders() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        return orderDao.getAllOrders().stream()
                .peek(order -> {
                    if (order.getOrderDate() != null) {
                        order.setOrderDateFormatted(order.getOrderDate().format(formatter));
                    }
                })
                .collect(Collectors.toList());
    }

    public List<Order> searchOrders(Integer orderNumber, String employeeNumber, LocalDate orderDate) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        return orderDao.searchOrders(orderNumber, employeeNumber, orderDate).stream()
                .peek(order -> {
                    if (order.getOrderDate() != null) {
                        order.setOrderDateFormatted(order.getOrderDate().format(formatter));
                    }
                })
                .collect(Collectors.toList());
    }

    // 총 주문 개수 반환
    public int getTotalOrders() {
        return orderDao.getTotalOrderCount();
    }


    public int getTotalOrdersUser(String employeeNumber) {
        return orderDao.getTotalOrderCountUser(employeeNumber);
    }


    public List<Order> getAllOrdersByEmployeeNumber(String employeeNumber) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        return orderDao.getAllOrdersByEmployeeNumber(employeeNumber).stream()
                .peek(order -> {
                    if (order.getOrderDate() != null) {
                        order.setOrderDateFormatted(order.getOrderDate().format(formatter));
                    }
                })
                .collect(Collectors.toList());
    }
    public List<Order> searchOrdersUser(Integer orderNumber, LocalDate orderDate) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        return orderDao.searchOrdersUser(orderNumber, orderDate).stream()
                .peek(order -> {
                    if (order.getOrderDate() != null) {
                        order.setOrderDateFormatted(order.getOrderDate().format(formatter));
                    }
                })
                .collect(Collectors.toList());
    }
}