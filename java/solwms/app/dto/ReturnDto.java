package solwms.app.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ReturnDto {
	private int product_id;
	private String product_name;
	private String quantity;
	private Date inDate;
	private Date outDate;
	private String detail;
	private int warehouseNumber;
	private Date useDate;
	private String category;
	private String model_name;
	private int returnQuantity;
	private String returnReason;
	private Date returnDate;
	private int returnWareHouseNumber;
	private int originWarehouseNumber;
	private int returnNumber;
	//다른코드에서 사용
	private int number;
	private String state;
	private Date date;
	private String image_name;
	private String imageUrl;
	private String wareName;
	//user
	private String employeeNumber;
	private String user_name;
	
	
}
