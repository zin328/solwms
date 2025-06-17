package solwms.app.dto;

import lombok.Data;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
public class OrderDetail {
    private int orderDetailId;
    private int orderNumber;
    private int productId;
    private String productName;
    private int quantity;
    private String category;
    private String modelName;
}
