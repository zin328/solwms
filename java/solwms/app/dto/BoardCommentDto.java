package solwms.app.dto;

import lombok.Data;

@Data
public class BoardCommentDto {

    private int commentNumber;
    private int sugNumber;
    private String commentContent;
    private String employeeNumber;
    private String user_name;

}

