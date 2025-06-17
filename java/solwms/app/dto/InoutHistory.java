package solwms.app.dto;

import lombok.Data;

import java.util.Date;

@Data
public class InoutHistory {
    private int number;
    private String state;
    private int product_id;
    private Date date;
    private int quantity;
    private String category;
    private String product_name;
    private String model_name;
    private String wareName;
}
