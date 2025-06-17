package solwms.app;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan("solwms.app.dao")
@SpringBootApplication
public class SolWmsApplication {

	public static void main(String[] args) {
		SpringApplication.run(SolWmsApplication.class, args);
	}

}
