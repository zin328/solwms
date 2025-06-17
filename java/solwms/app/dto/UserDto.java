package solwms.app.dto;

import lombok.Data;

@Data
public class UserDto {
    private String employeeNumber;
    private String user_name;
    private String user_password;
    private String phone;
    private String address;
    private Role role;

}
