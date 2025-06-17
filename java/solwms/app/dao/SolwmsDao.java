package solwms.app.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.transaction.annotation.Transactional;


import solwms.app.dto.ReturnDto;




@Mapper
public interface SolwmsDao {
	@Select("SELECT * \r\n"
			+ "FROM ProductInventory \r\n"
			+ "WHERE product_name LIKE CONCAT('%', #{productName}, '%') \r\n"
			+ "   OR model_name LIKE CONCAT('%', #{productName}, '%')")
	List<ReturnDto> SearchProduct(String productName);
	
	
	@Update("UPDATE ProductInventory SET quantity = quantity - #{returnQuantity} WHERE product_id = #{productId} AND quantity >= #{returnQuantity}")
	void updateProductInventory(@Param("productId") int productId, @Param("returnQuantity") int returnQuantity);
	
	//창고재고증가
	@Update("UPDATE ProductInventory SET quantity = quantity + #{returnQuantity} WHERE warehouseNumber = #{returnWareHouseNumber} AND product_name = #{productName}")
	int updateWarehouseInventory(@Param("returnWareHouseNumber") int returnWareHouseNumber, 
	                             @Param("productName") String productName, 
	                             @Param("returnQuantity") int returnQuantity);

	// 3. 업데이트 실패 시, 새로운 제품 추가
	@Insert("INSERT INTO ProductInventory (warehouseNumber, product_name, quantity,  model_name, category,detail ) " +
	        "VALUES (#{returnWareHouseNumber}, #{productName}, #{returnQuantity},  #{modelName},#{category}, #{detail})")
	void insertNewProductInventory(@Param("returnWareHouseNumber") int returnWareHouseNumber,
	                               @Param("productName") String productName,
	                               @Param("returnQuantity") int returnQuantity,
	                               @Param("modelName") String modelName,
	                               @Param("category") String category,  // 카테고리 순서 변경
	                               @Param("detail") String detail
	                               );



	@Insert("INSERT INTO returnHistory (" +
	        "employeeNumber, " +
	        "product_id, " +
	        "product_name, " +
	        "returnQuantity, " +
	        "returnWareHouseNumber, " +
	        "warehouseNumber, " +
	        "returnReason, " +
	        "returnDate) " +
	        "VALUES (" +
	        "#{employeeNumber}, " +
	        "#{productId}, " +
	        "#{productName}, " +
	        "#{returnQuantity}, " +
	        "#{returnWareHouseNumber}, " +
	        "#{originWarehouseNumber}, " +
	        "#{returnReason}, " +
	        "CURDATE())") // 날짜만 저장
	void insertReturnHistory(@Param("employeeNumber") String employeeNumber,
	                         @Param("productId") int productId,
	                         @Param("productName") String productName,
	                         @Param("returnQuantity") int returnQuantity,
	                         @Param("originWarehouseNumber") int originWarehouseNumber,  // 원래 창고
	                         @Param("returnWareHouseNumber") int returnWareHouseNumber,  // 반납 창고
	                         @Param("returnReason") String returnReason);
	
	
	@Select("select count(*) from returnHistory")
	int count();
	

	@Select("select rh.*, wi.wareName from returnHistory rh JOIN WarehouseInformation wi ON rh.warehouseNumber = wi.warehouseNumber order by  rh.returnNumber DESC limit #{start} , #{count}")
	List<ReturnDto> ReturnList(Map<String, Object> m);
	
	@Select("SELECT rh.*, wi.wareName " +
	        "FROM returnHistory rh " +
	        "JOIN WarehouseInformation wi ON rh.warehouseNumber = wi.warehouseNumber " +
	        "WHERE rh.employeeNumber = #{username} " +
	        "ORDER BY rh.returnNumber DESC")
	List<ReturnDto> returnListEmployeeNumber(String username);

	
	@Select("select count(*) from InoutHistory where product_id=#{productId}")
	int countprouct(int productId);
	//제품 입출고 내역 페이징
	@Select("select * from InoutHistory where product_id = #{productId} order by date asc limit #{start}, #{count}")
	List<ReturnDto> productInoutPage(Map<String, Object> m);

	
	
	@Select("select * from InoutHistory order by date desc limit #{start} , #{count}")
	List<ReturnDto> productInout(Map<String, Object> m);
	
	@Select("SELECT * FROM ProductInventory WHERE warehouseNumber = (" +
	        "    SELECT warehouseNumber FROM WarehouseInformation WHERE employeeNumber = #{loggedInUser})")
	List<ReturnDto> showUserProductInventory(@Param("loggedInUser") String loggedInUser);

	@Select("select wareName from WarehouseInformation where warehouseNumber=#{warehouseNumber}")
	String originwarehouseName(int warehouseNumber);
	@Select("select wareName from WarehouseInformation where warehouseNumber=#{returnWarehouseNumber}")
	String returnwarehouseName(int returnWarehouseNumber);
	
	@Select("select * from ProductInventory")
	List<ReturnDto> showProductInventory();
	
	@Select("select rh.*, wi.wareName from returnHistory rh JOIN WarehouseInformation wi ON rh.warehouseNumber = wi.warehouseNumber")
	List<ReturnDto> showReturnHistory();
	
	@Select("select * from returnHistory where employeeNumber=#{employeeNumber}")
	List<ReturnDto> showUserReturnHistory(String employeeNumber);
	
	@Select("select * from WarehouseInformation")
	List<ReturnDto> showWarehouseInfo();
	
	
	@Select("SELECT pi.*, wi.* FROM ProductInventory pi JOIN WarehouseInformation wi ON pi.warehouseNumber = wi.warehouseNumber WHERE pi.product_id = #{product_id}")
	List<ReturnDto> detailProduct(int productId);
//	@Select("select pi.*, wi.wareName from ProductInventory pi JOIN WarehouseInformation wi ON pi.warehouseNumber wi.warehouseNumber where product_id = #{productId}")

	@Select("select * from InoutHistory where product_id =#{productId}")
	List<ReturnDto> productHistory(int productId);
	
}
