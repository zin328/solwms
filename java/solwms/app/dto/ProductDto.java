package solwms.app.dto;

import lombok.Data;

@Data
public class ProductDto {
	
	private int productId;
	private String productName;
	private int quantity;


	
	@Override
    public String toString() {
        return String.format("ProductDto{id=%d, name='%s', quantity=%d}", productId, productName, quantity);
    }
}
