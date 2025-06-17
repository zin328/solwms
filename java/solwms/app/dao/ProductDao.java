package solwms.app.dao;


import java.util.List;




import org.apache.ibatis.annotations.*;


import solwms.app.dto.ProductDto;

import java.util.List;

@Mapper
public interface ProductDao {
    

	@Select("SELECT product_id, product_name, quantity FROM ProductInventory WHERE warehouseNumber = #{wareNum}")
	@Results({
	    @Result(property = "productId", column = "product_id"),
	    @Result(property = "productName", column = "product_name")
	})
	List<ProductDto> getProductInventory(@Param("wareNum") int wareNum);


    
    @Select("SELECT * FROM Product WHERE product_id = #{productId}")
    ProductDto getProductById(int productId);
    
	@Select("SELECT product_id, product_name, quantity FROM ProductInventory WHERE warehouseNumber = #{wareNum} ORDER BY quantity ASC")
    @Results({
        @Result(property = "productId", column = "product_id"),
        @Result(property = "productName", column = "product_name")
    })
    List<ProductDto> getUserProductInventory(@Param("wareNum") int wareNum);



	@Select("SELECT pi.product_id, pi.product_name, pi.quantity " +
	        "FROM ProductInventory pi " +
	        "JOIN WarehouseInformation wi ON pi.warehouseNumber = wi.warehouseNumber " +
	        "WHERE wi.employeeNumber = #{employeeNumber} " +
	        "ORDER BY pi.quantity ASC")
    @Results({
	    @Result(property = "productId", column = "product_id"),
	    @Result(property = "productName", column = "product_name")
	})
    List<ProductDto> getUserInventory(@Param("employeeNumber") String employeeNumber);

}
