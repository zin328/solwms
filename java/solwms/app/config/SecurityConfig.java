package solwms.app.config;

import jakarta.servlet.DispatcherType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.flyway.FlywayDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import solwms.app.service.UserService;

import static org.springframework.security.config.Customizer.withDefaults;

import java.util.List;

@EnableWebSecurity
@Configuration
public class SecurityConfig{


    @Autowired
    private UserDetailsService UserDetailService;

    @Autowired
    private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    @Bean
    SecurityFilterChain filterChain(HttpSecurity security) throws Exception {

        security
        .csrf(csrf -> csrf.disable())  // ✅ CSRF 비활성화
        .cors(cors -> cors.configurationSource(corsConfigurationSource())) // ✅ CORS 설정 적용 위에 두 줄 변경했는데 ㄱㅊ?물어보기
                .authorizeHttpRequests(request -> request
                        .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                        .requestMatchers(new AntPathRequestMatcher("/admin/**")).hasRole("ADMIN")
                        .requestMatchers("/resources/icon/**").permitAll()  // /resources/icon 경로 허용
                        .anyRequest().authenticated()	// 어떠한 요청이라도 인증필요
                )
                .formLogin(login -> login	// form 방식 로그인 사용
                        .loginPage("/login")	// 로그인 페이지
                        .successHandler((request, response, authentication) -> {
                            String role = authentication.getAuthorities().iterator().next().getAuthority();

                            if (role.equals("ROLE_USER")) {
                                response.sendRedirect("http://localhost:5173"); // JWT를 React로 전달
                            } else {
                                response.sendRedirect("/adminMain");
                            }
                        })
                        .failureUrl("/login?error=true")  // 로그인 실패 시 이동할 URL
                        .permitAll()	// 대시보드 이동이 막히면 안되므로 얘는 허용
                )
                .logout(withDefaults())
                .exceptionHandling((exception) -> exception.accessDeniedPage("/"));


        security.userDetailsService(UserDetailService);

        return security.build();
    }
    

    // ✅ CORS 정책 설정 추가
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:5173")); // ✅ 프론트엔드 도메인 허용
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS")); // ✅ 허용할 HTTP 메서드
        configuration.setAllowedHeaders(List.of("*")); // ✅ 모든 헤더 허용
        configuration.setAllowCredentials(true); // ✅ 쿠키 포함 허용 (필요시)

      
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration); // ✅ 모든 경로에 대해 CORS 적용
        return source;
    } 
    

    @Bean
    public PasswordEncoder passwordEncoder() {
        //return NoOpPasswordEncoder.getInstance();
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }
    

    @Bean
    public HttpFirewall allowUrlEncodedSlashHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedDoubleSlash(true);
        return firewall;
    }
    

    
}

