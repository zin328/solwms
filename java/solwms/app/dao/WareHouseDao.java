package solwms.app.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import solwms.app.dto.WareHouse;

@Mapper
public interface WareHouseDao {
    @Insert("insert into WarehouseInformation(wareName, address, employeeNumber) values(#{wareName}, #{address}, #{employeeNumber}) ")
    int createWarehouse(WareHouse wareHouse);

    @Select("select wareName from WarehouseInformation where employeeNumber = #{id}")
    String findWarehouse(@Param("id") String id);


    
    @Select("select warehouseNumber from WarehouseInformation where employeeNumber = #{id}")
    int findWareNum(@Param("id") String id);


    @Select("select wareName from WarehouseInformation where warehouseNumber = #{warehouseNumber}")
    String findWareNameById(@Param("warehouseNumber") int warehouseNumber);


    
	/*
	 * @Select("select warehouseNumber from WarehouseInformation where employeeNumber = #{id}"
	 * ) int findWareNum(@Param("id") String id);
	 * 
	 * @Select("select wareName from WarehouseInformation where warehouseNumber = #{warehouseNumber}"
	 * ) String findWareNameById(@Param("warehouseNumber") int warehouseNumber);
	 */

}
