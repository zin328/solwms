package solwms.app.dao;

import org.apache.ibatis.annotations.*;
import org.springframework.web.bind.annotation.RequestParam;
import solwms.app.dto.UserDto;
import java.util.List;

@Mapper
public interface UserDao {



    @Select("select * from User where employeeNumber =#{id}")
    UserDto fingById(String id);

    @Update("update User set user_password=#{user_password} where employeeNumber= #{employeeNumber}")
    int updateUser(UserDto user);

    @Select("select count(*) from User ")
    int countUser();

    @Select("select * from User ORDER BY employeeNumber desc LIMIT #{start}, 10")
    List<UserDto> selectUserAll(int start);

    @Select("select count(*) from User where user_name like CONCAT('%', #{search}, '%') or employeeNumber like concat('%',#{search},'%' )")
    int countSearch(@Param("search") String search);

    @Select("select * from User where user_name like CONCAT('%', #{search}, '%') or employeeNumber like concat('%',#{search},'%' ) order by employeeNumber desc LIMIT #{start}, 10")
    List<UserDto> searchUser(@Param("search") String search, @Param ("start")int start);

    @Insert("insert into User(employeeNumber, user_name, user_password, role, phone, address) values(#{employeeNumber}, #{user_name}, #{user_password}, #{role}, #{phone}, #{address})")
    int insertUser(UserDto user);

    @Delete("DELETE FROM User WHERE employeeNumber = #{id}")
    void deleteUser(@Param("id") String id);

}
