package solwms.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor // 기본 생성자 추가
@AllArgsConstructor
public class SuggDto {
    private int sugNumber;
    private String sugTitle;
    private String sugContent;
    private String employeeNumber;
    private String user_name;
}
