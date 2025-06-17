package solwms.app.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import solwms.app.dto.InoutHistory;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface InoutHistoryDao {

    @Select("SELECT COUNT(*) FROM InoutHistory")
    int count();

    @Select("SELECT ih.*, pi.category, pi.product_name, pi.model_name " +
            "FROM InoutHistory ih " +
            "JOIN ProductInventory pi ON ih.product_id = pi.product_id " +
            "ORDER BY ih.number desc LIMIT #{start}, #{count}")
    List<InoutHistory> selectAll(Map<String, Object> m);

    @Select("SELECT COUNT(*)" +
            "FROM InoutHistory ih " +
            "JOIN ProductInventory pi ON ih.product_id = pi.product_id " +
            "WHERE pi.category LIKE CONCAT('%', #{category}, '%') " +
            "AND ( " +
            "    (#{date1} IS NULL AND #{date2} IS NULL) " +   // 둘 다 NULL이면 모든 날짜 허용
            "    OR (#{date1} IS NOT NULL AND #{date2} IS NULL AND ih.date >= #{date1}) " +  // 시작 날짜만 있을 경우
            "    OR (#{date1} IS NULL AND #{date2} IS NOT NULL AND ih.date <= DATE_ADD(#{date2}, INTERVAL 1 DAY)) " +  // 종료 날짜만 있을 경우
            "    OR (#{date1} IS NOT NULL AND #{date2} IS NOT NULL AND ih.date BETWEEN #{date1} AND DATE_ADD(#{date2}, INTERVAL 1 DAY)) " +  // 둘 다 있을 경우
            ") " +
            "AND (pi.product_name LIKE CONCAT('%', #{searchKeyword}, '%') " +
            "     OR pi.model_name LIKE CONCAT('%', #{searchKeyword}, '%')) " +
            "AND ih.wareName LIKE CONCAT('%', #{wareName}, '%') " +
            "AND ih.state LIKE CONCAT('%', #{state}, '%')")
    int countSearchInoutHistory(
            @Param("category") String category,
            @Param("date1") String date1,
            @Param("date2") String date2,
            @Param("searchKeyword") String searchKeyword,
            @Param("wareName") String wareName,
            @Param("state") String state
    );

    @Select("SELECT ih.*, pi.category, pi.product_name, pi.model_name " +
            "FROM InoutHistory ih " +
            "JOIN ProductInventory pi ON ih.product_id = pi.product_id " +
            "WHERE pi.category LIKE CONCAT('%', #{category}, '%') " +
            "AND ( " +
            "    (#{date1} IS NULL AND #{date2} IS NULL) " +   // 둘 다 NULL이면 모든 날짜 허용
            "    OR (#{date1} IS NOT NULL AND #{date2} IS NULL AND ih.date >= #{date1}) " +  // 시작 날짜만 있을 경우
            "    OR (#{date1} IS NULL AND #{date2} IS NOT NULL AND ih.date <= #{date2}) " +  // 종료 날짜만 있을 경우
            "    OR (#{date1} IS NOT NULL AND #{date2} IS NOT NULL AND ih.date BETWEEN #{date1} AND #{date2}) " +  // 둘 다 있을 경우
            ") " +
            "AND (pi.product_name LIKE CONCAT('%', #{searchKeyword}, '%') " +
            "     OR pi.model_name LIKE CONCAT('%', #{searchKeyword}, '%')) " +
            "AND ih.wareName LIKE CONCAT('%', #{wareName}, '%') " +
            "AND ih.state LIKE CONCAT('%', #{state}, '%') "+
            "ORDER BY ih.number desc LIMIT #{start}, #{count}")
    List<InoutHistory> searchInoutHistory(
            @Param("category") String category,
            @Param("date1") String date1,
            @Param("date2") String date2,
            @Param("searchKeyword") String searchKeyword,
            @Param("wareName") String wareName,
            @Param("state") String state,
            @Param("start") int start,
            @Param("count") int count
    );

    @Insert("INSERT INTO InoutHistory(product_id, date, state, quantity, wareName) " +
            "VALUES(#{productId}, #{date}, #{state}, #{quantity},#{wareName})")
    void saveInoutHistory(@Param("productId") int productId,
                          @Param("date") LocalDate date,
                          @Param("state") String state,
                          @Param("quantity") int quantity,
                          @Param("wareName") String wareName
                          );

    @Select("SELECT product_id FROM ProductInventory WHERE product_name = #{productName} AND warehouseNumber = #{warehouseNumber}")
    int findProductId(@Param("productName") String productName, @Param("warehouseNumber") int warehouseNumber);
}