package solwms.app.dao;

import org.apache.ibatis.annotations.*;
import solwms.app.dto.*;

import java.util.List;

@Mapper
public interface OrderDetailDao {

    @Select("""
        SELECT orderDetail_id AS orderDetailId, 
               orderNumber, 
               product_id AS productId, 
               product_name AS productName, 
               quantity,  
               model_name AS modelName, 
               category 
        FROM OrderDetail 
        WHERE orderNumber = #{orderNumber}
    """)
    List<OrderDetail> getOrderDetailsByOrderNumber(@Param("orderNumber") int orderNumber);

    @Select("""
        SELECT orderNumber, 
               employeeNumber, 
               orderDate AS orderDateFormatted,
               state,
               deliveryAddress,
               shippingAddress 
        FROM OrderHistory 
        WHERE orderNumber = #{orderNumber}
    """)
    Order getOrderByOrderNumber(@Param("orderNumber") int orderNumber);

    @Update("""
        UPDATE OrderHistory 
        SET state = #{state} 
        WHERE orderNumber = #{orderNumber}
    """)
    void updateOrderState(@Param("orderNumber") int orderNumber, @Param("state") String state);

    @Select("""
    SELECT product_id, product_name, quantity
    FROM ProductInventory
    WHERE product_name = #{productName} AND warehouseNumber = 20
""")
    ProductDto getProductInventoryByProductName(@Param("productName") String productName);


    @Update("""
    UPDATE ProductInventory
    SET quantity = quantity - #{quantity}
    WHERE product_name = #{productName} AND warehouseNumber = 20
""")
    void decreaseProductQuantity(@Param("productName") String productName, @Param("quantity") int quantity);


    @Select("""
    SELECT *
    FROM WarehouseInformation
    WHERE employeeNumber = #{employeeNumber}
""")
    WareHouse getWarehouseByEmployeeNumber(@Param("employeeNumber") String employeeNumber);


    @Update("""
        UPDATE ProductInventory
        SET quantity = quantity + #{quantity}
        WHERE product_name = #{productName} AND warehouseNumber = #{warehouseNumber}
    """)
    void increaseProductQuantity(@Param("productName") String productName,
                                 @Param("quantity") int quantity,
                                 @Param("warehouseNumber") int warehouseNumber);

    @Select("SELECT EXISTS (SELECT 1 FROM ProductInventory WHERE product_name = #{productName} AND warehouseNumber = #{warehouseNumber})")
    boolean existsByProductNameAndWarehouse(@Param("productName") String productName, @Param("warehouseNumber") int warehouseNumber);


    @Select("""
    SELECT * FROM ProductInventory
    WHERE product_name = #{productName} AND warehouseNumber = 20
""")
    @Results({
            @Result(property = "productId", column = "product_id"),
            @Result(property = "productName", column = "product_name"),
            @Result(property = "quantity", column = "quantity"),
            @Result(property = "detail", column = "detail"),
            @Result(property = "warehouseNumber", column = "warehouse_number"),
            @Result(property = "orderquantity", column = "orderquantity"),
            @Result(property = "category", column = "category"),
            @Result(property = "modelname", column = "model_name"),
            @Result(property = "imageName", column = "image_name"),
            @Result(property = "qrCode", column = "qrCode"),
    })
    Stock stockAll(@Param("productName") String productName);

    @Insert("""
    INSERT INTO ProductInventory 
    (product_name, quantity, orderquantity, warehouseNumber, category, model_name, detail, image_name, qrCode) 
    VALUES 
    (#{productName}, #{quantity}, #{orderquantity}, #{warehouseNumber}, #{category}, #{modelname}, #{detail}, #{imageName}, #{qrCode})
""")
    void insertStock(Stock stock);

}

