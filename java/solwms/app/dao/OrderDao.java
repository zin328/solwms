package solwms.app.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import solwms.app.dto.Order;

import java.time.LocalDate;
import java.util.List;
@Mapper
public interface OrderDao {

    @Select("SELECT orderNumber, employeeNumber, orderDate, state, deliveryAddress, shippingAddress, arrivalDate " +
            "FROM OrderHistory " +
            "ORDER BY orderNumber DESC")
    List<Order> getAllOrders();


    @Select("<script>" +
            "SELECT orderNumber, employeeNumber, orderDate, state, deliveryAddress, shippingAddress, arrivalDate " +
            "FROM OrderHistory " +
            "WHERE 1=1 " +
            "<if test='orderNumber != null'> AND orderNumber = #{orderNumber} </if>" +
            "<if test='employeeNumber != null'> AND employeeNumber = #{employeeNumber} </if>" +
            "<if test='orderDate != null'> AND DATE(orderDate) = #{orderDate} </if>" +
            "ORDER BY orderNumber DESC" +
            "</script>")
    List<Order> searchOrders(@Param("orderNumber") Integer orderNumber,
                             @Param("employeeNumber") String employeeNumber,
                             @Param("orderDate") LocalDate orderDate);

    // 페이징 처리된 주문 목록 조회
    @Select("SELECT * FROM OrderHistory ORDER BY orderNumber DESC LIMIT #{offset}, #{limit}")
    List<Order> getOrdersPaginated(@Param("offset") int offset, @Param("limit") int limit);


    // 총 주문 개수 조회
    @Select("SELECT COUNT(*) FROM OrderHistory")
    int getTotalOrderCount();

    @Select("SELECT orderNumber, employeeNumber, orderDate, state, deliveryAddress, shippingAddress, arrivalDate " +
            "FROM OrderHistory " +
            "WHERE employeeNumber = #{employeeNumber} "+
            "ORDER BY orderNumber DESC")
    List<Order> getAllOrdersByEmployeeNumber(@Param("employeeNumber") String employeeNumber);


    @Select("<script>" +
            "SELECT orderNumber, employeeNumber, orderDate, state, deliveryAddress, shippingAddress, arrivalDate " +
            "FROM OrderHistory " +
            "WHERE 1=1 " +
            "<if test='orderNumber != null'> AND orderNumber = #{orderNumber} </if>" +
            "<if test='orderDate != null'> AND DATE(orderDate) = #{orderDate} </if>" +
            "ORDER BY orderNumber DESC" +
            "</script>")
    List<Order> searchOrdersUser(@Param("orderNumber") Integer orderNumber,
                             @Param("orderDate") LocalDate orderDate);

    @Select("SELECT COUNT(*) FROM OrderHistory WHERE employeeNumber = #{employeeNumber}")
    int getTotalOrderCountUser(@Param("employeeNumber") String employeeNumber);

}