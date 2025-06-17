package solwms.app.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.UpdateProvider;

import solwms.app.dto.Stock;
import solwms.app.dto.Stock.OrderDetail;
import solwms.app.dto.Stock.OrderHistory;

@Mapper
public interface StockDao {

    // 전체 재고 개수 조회 (페이징을 위한 COUNT 쿼리)
	@Select("SELECT COUNT(*) FROM ProductInventory p " +
	        "JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber " +
	        "WHERE w.employeeNumber = #{employeeNumber}")
    int countStock(@Param("employeeNumber") String employeeNumber);

    // 전체 재고 목록 조회 (페이징 X, 기존 코드 유지)
	@Select("""
		    SELECT p.product_id AS productId, 
		           p.product_name AS productName, 
		           p.detail, 
		           p.quantity, 
		           p.orderquantity, 
		           p.category, 
		           p.model_name AS modelname 
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE w.employeeNumber = #{employeeNumber}
		    """)
    List<Stock> CheckStock(@Param("employeeNumber") String employeeNumber);

    // 페이징 처리된 재고 목록 조회 (페이징 O)
	@Select("""
		    SELECT p.product_id AS productId, 
		           p.product_name AS productName, 
		           p.detail, 
		           p.quantity, 
		           p.orderquantity, 
		           p.category, 
		           p.model_name AS modelname 
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE w.employeeNumber = #{employeeNumber}
		    ORDER BY p.product_id DESC
		    LIMIT #{start}, #{count}
		    """)
    List<Stock> getStockListPaginated(@Param("employeeNumber") String employeeNumber, 
            @Param("start") int start, 
            @Param("count") int count);
    
    	// ✅ 검색 타입에 따라 검색 (동적 SQL 적용)
	@Select("""
		    SELECT COUNT(*) 
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE w.employeeNumber = #{employeeNumber} 
		    AND ${searchType} LIKE CONCAT('%', #{search}, '%')
		    """)
		int countSearchStock(@Param("employeeNumber") String employeeNumber, 
		                     @Param("searchType") String searchType, 
		                     @Param("search") String search);


	@Select("""
		    SELECT p.product_id AS productId, 
		           p.product_name AS productName, 
		           p.model_name AS modelname,
		           p.category, 
		           p.detail, 
		           p.quantity, 
		           p.orderquantity
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE w.employeeNumber = #{employeeNumber}
		    AND ${searchType} LIKE CONCAT('%', #{search}, '%')
		    ORDER BY p.product_id DESC
		    LIMIT #{start}, #{count}
		    """)
		List<Stock> searchStock(@Param("employeeNumber") String employeeNumber,
		                        @Param("searchType") String searchType, 
		                        @Param("search") String search, 
		                        @Param("start") int start, 
		                        @Param("count") int count);




    
	@Select("""
		    SELECT p.product_id AS productId, 
		           p.product_name AS productName, 
		           p.model_name AS modelname,
		           p.quantity,
		           p.orderquantity 
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE w.employeeNumber = #{employeeNumber}
		    """)
		List<Stock> findStockWithOrderQuantity(@Param("employeeNumber") String employeeNumber);

    
	@Select("""
		    SELECT p.product_id AS productId, 
		           p.product_name AS productName, 
		           p.model_name AS modelname,
		           p.quantity,
		           p.orderquantity
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE w.employeeNumber = #{employeeNumber}
		    AND p.product_name LIKE CONCAT('%', #{search}, '%')
		    """)
		List<Stock> searchStockWithoutPagination(@Param("employeeNumber") String employeeNumber, 
		                                         @Param("search") String search);


	@Insert("INSERT INTO OrderHistory (orderDate, state, deliveryAddress, shippingAddress, arrivalDate, employeeNumber) " +
	        "VALUES (DATE_ADD(NOW(), INTERVAL 9 HOUR), 'RECEIVED', '관리자 창고', " +
	        "(SELECT wareName FROM WarehouseInformation WHERE employeeNumber = #{employeeNumber}), " +
	        "DATE_ADD(DATE_ADD(NOW(), INTERVAL 9 HOUR), INTERVAL 7 DAY), #{employeeNumber})")
	@Options(useGeneratedKeys = true, keyProperty = "orderNumber")
	void insertOrderHistory(OrderHistory orderHistory);


	
	@Insert("INSERT INTO OrderHistory (orderDate, state, deliveryAddress, shippingAddress, arrivalDate, employeeNumber) " +
	        "VALUES (DATE_ADD(NOW(), INTERVAL 9 HOUR), 'ORDER_PENDING', '관리자 창고', " +
	        "(SELECT wareName FROM WarehouseInformation WHERE employeeNumber = #{employeeNumber}), " +
	        "DATE_ADD(DATE_ADD(NOW(), INTERVAL 9 HOUR), INTERVAL 7 DAY), #{employeeNumber})")
	@Options(useGeneratedKeys = true, keyProperty = "orderNumber")
	void userinsertOrderHistory(OrderHistory orderHistory);

	@Insert({
	    "<script>",
	    "INSERT INTO OrderDetail (orderNumber, product_id, product_name, model_name, category, quantity) VALUES ",
	    "<foreach collection='orderDetails' item='detail' separator=','>",
	    "(#{detail.orderNumber}, #{detail.productId}, ",
	    "(SELECT product_name FROM ProductInventory WHERE product_id = #{detail.productId}), ",
	    "(SELECT model_name FROM ProductInventory WHERE product_id = #{detail.productId}), ",
	    "(SELECT category FROM ProductInventory WHERE product_id = #{detail.productId}), ",
	    "#{detail.quantity})",
	    "</foreach>",
	    "</script>"
	})
	void insertOrderDetails(@Param("orderDetails") List<OrderDetail> orderDetails);



	@Insert("""
		    INSERT INTO ProductInventory (product_name, detail, quantity, orderquantity, category, model_name, warehouseNumber, image_name, qrCode)
		    SELECT #{stock.productName}, #{stock.detail}, #{stock.quantity}, #{stock.orderquantity}, 
		           #{stock.category}, #{stock.modelname}, 
		           (SELECT warehouseNumber FROM WarehouseInformation WHERE employeeNumber = #{employeeNumber} LIMIT 1), 
		           #{stock.imageName}, #{stock.qrCode}
		    WHERE NOT EXISTS (
		        SELECT 1 FROM ProductInventory WHERE product_name = #{stock.productName}
		    )
		    """)
		@Options(useGeneratedKeys = true, keyProperty = "stock.productId", keyColumn = "product_id")
		void insertStock(@Param("employeeNumber") String employeeNumber, 
		                 @Param("stock") Stock stock);

	@Select("""
		    SELECT DISTINCT w.warehouseNumber 
		    FROM WarehouseInformation w
		    WHERE w.employeeNumber = #{employeeNumber}
		    """)
		List<Integer> getAllWarehouseNumbers(@Param("employeeNumber") String employeeNumber);
	
	@Select("""
		    SELECT COUNT(*) 
		    FROM ProductInventory p
		    JOIN WarehouseInformation w ON p.warehouseNumber = w.warehouseNumber
		    WHERE p.product_name = #{productName} 
		    AND w.employeeNumber = #{employeeNumber}
		""")
		int countByProductName(@Param("productName") String productName, @Param("employeeNumber") String employeeNumber);

	@Select("SELECT p.product_name AS productName, SUM(p.quantity) AS quantity " +
	        "FROM ProductInventory p " +
	        "WHERE p.warehouseNumber = 20 " +
	        "GROUP BY p.product_name")
	List<Map<String, Object>> getMainWarehouseSummary();

    
}