package solwms.app.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import solwms.app.dto.Stock;
import solwms.app.qr.QRCodeGenerator;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.StockService;


@RestController  // ✅ 기존 @Controller → @RestController 변경
@RequestMapping("/api/stock")  // ✅ 공통 API 경로 설정
public class userStockController {
    
    @Autowired
    StockService sservice;

    @Autowired
    InoutHistoryService ihservice;

    // ✅ 전체 재고 조회 (페이징 포함)
    @GetMapping("/stockall")
    public ResponseEntity<Map<String, Object>> usercheckStock(
            @RequestParam(name = "p", defaultValue = "1") int page) {

    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
    	
        int count = sservice.countStock(employeeNumber);
        int perPage = 10;
        int startRow = (page - 1) * perPage;
        List<Stock> slist = count > 0 ? sservice.CheckStockPaginated(employeeNumber,startRow, perPage) : new ArrayList<>();

        Map<String, Object> response = new HashMap<>();
        response.put("CheckStock", slist);
        response.put("totalPages", (int) Math.ceil((double) count / perPage));
        response.put("currentPage", page);
        response.put("count", count);

        return ResponseEntity.ok(response);
    }

    // ✅ 검색 기능 (페이징 포함)
    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> usercheckStock(
            @RequestParam(value = "searchType", required = false, defaultValue = "product_name") String searchType,
            @RequestParam(value = "search", required = false, defaultValue = "") String search,
            @RequestParam(name = "p", defaultValue = "1") int page) {
    	
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
    	
        // ✅ 검색 타입 매핑
        Map<String, String> columnMapping = Map.of(
            "productName", "product_name",
            "modelname", "model_name",
            "category", "category",
            "detail", "detail"
        );
        searchType = columnMapping.getOrDefault(searchType, "product_name");

        int count = sservice.countSearchStock(employeeNumber,searchType, search);
        int perPage = 10;
        int startRow = (page - 1) * perPage;
        
        List<Stock> stockList = count > 0 ? sservice.searchStock(employeeNumber,searchType, search, startRow, perPage) : new ArrayList<>();

        // ✅ 페이징 계산
        int totalPages = (int) Math.ceil((double) count / perPage);
        int pageNum = 5;
        int begin = ((page - 1) / pageNum) * pageNum + 1;
        int end = Math.min(begin + pageNum - 1, totalPages);

        // ✅ JSON 응답 객체 생성
        Map<String, Object> response = new HashMap<>();
        response.put("CheckStock", stockList);
        response.put("begin", begin);
        response.put("end", end);
        response.put("pageNum", pageNum);
        response.put("totalPages", totalPages);
        response.put("currentPage", page);
        response.put("searchType", searchType);
        response.put("search", search);
        response.put("count", count);

        return ResponseEntity.ok(response);
    }


    // ✅ 재고 요청 (발주할 수량이 있는 재고)
    @GetMapping("/request")
    public ResponseEntity<List<Stock>> userstockRequest() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        List<Stock> stockList = sservice.getStockWithOrderQuantity(employeeNumber);
        return ResponseEntity.ok(stockList);
    }

    // ✅ 주문 수량 업데이트
    @PostMapping("/createOrder")
    public ResponseEntity<String> usercreateOrder(@RequestBody List<Stock> stocks) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();

        if (stocks == null || stocks.isEmpty()) {
            return ResponseEntity.badRequest().body("🚨 주문할 상품이 없습니다!");
        }
        try {
            sservice.usercreateOrder(employeeNumber, stocks); // ❌ 리턴값을 받지 않음 (void)
            return ResponseEntity.ok("✅ 주문이 성공적으로 저장되었습니다!"); // ✅ 문자열 응답 유지
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("❌ 주문 저장 실패!");
        }
    }
    
    @GetMapping("/mainStock")
    public ResponseEntity<List<Map<String, Object>>> mainStockSummary() {
        List<Map<String, Object>> summary = sservice.getMainWarehouseSummary();
        return ResponseEntity.ok(summary);
    }

}
