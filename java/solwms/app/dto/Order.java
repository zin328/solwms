package solwms.app.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Order {
    private int orderNumber;
    private String employeeNumber;
    private String quantity;
    private LocalDateTime orderDate;
    private String state;
    private String deliveryAddress;
    private String shippingAddress;
    private LocalDateTime arrivalDate;
    private String orderDateFormatted;
}
