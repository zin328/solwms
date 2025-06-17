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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import solwms.app.dto.Stock;
import solwms.app.qr.QRCodeGenerator;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.StockService;
import solwms.app.service.WareHouseService;


@Controller

public class StockController {
	
	@Autowired
	private StockService sservice;

    @Autowired
    private InoutHistoryService ihservice;

    @Autowired
    private WareHouseService whservice;
    
	//상품 조회 조회페이지
	// ✅ 전체 재고 조회 (페이징 포함)
	@GetMapping("/stock/stockall")
	public String CheckStock(@RequestParam(name = "p", defaultValue = "1") int page, Model m) {
	    
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
		
	    int count = sservice.countStock(employeeNumber); // 전체 재고 개수 조회
	    
	    int perPage = 10; // 한 페이지당 10개
	    int startRow = (page - 1) * perPage;

	    List<Stock> slist = new ArrayList<>();
	    
	    if (count > 0) {
	        slist = sservice.CheckStockPaginated(employeeNumber,startRow, perPage);
	    }

	    // ✅ 페이징 네비게이션 계산
	    int pageNum = 5;
	    int totalPages = (int) Math.ceil((double) count / perPage);
	    
	    int begin = ((page - 1) / pageNum) * pageNum + 1;
	    int end = begin + pageNum - 1;
	    if (end > totalPages) {
	        end = totalPages;
	    }

	    // ✅ JSP에서 사용할 데이터 전달
	    m.addAttribute("CheckStock", slist);
	    m.addAttribute("begin", begin);
	    m.addAttribute("end", end);
	    m.addAttribute("pageNum", pageNum);
	    m.addAttribute("totalPages", totalPages);
	    m.addAttribute("currentPage", page);
	    m.addAttribute("count", count);

	    return "stock/stockall";
	}

	@GetMapping("/stock/search")
	public String checkStock(
	        @RequestParam(value = "searchType", required = false, defaultValue = "product_name") String searchType,
	        @RequestParam(value = "search", required = false, defaultValue = "") String search,
	        @RequestParam(name = "p", defaultValue = "1") int page,
	        Model m) {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        
	    // ✅ 검색 타입 매핑
	    Map<String, String> columnMapping = Map.of(
	        "productName", "product_name",
	        "model_name", "model_name",
	        "category", "category",
	        "detail", "detail"
	    );
	    searchType = columnMapping.getOrDefault(searchType, "product_name");

	    int count = sservice.countSearchStock(employeeNumber,searchType, search);
	    List<Stock> stockList = new ArrayList<>();

	    int perPage = 10;
	    int startRow = (page - 1) * perPage;

	    if (count > 0) {
	        stockList = sservice.searchStock(employeeNumber,searchType, search, startRow, perPage);
	    }

	    int pageNum = 5;
	    int totalPages = (int) Math.ceil((double) count / perPage);
	    
	    int begin = ((page - 1) / pageNum) * pageNum + 1;
	    int end = begin + pageNum - 1;
	    if (end > totalPages) {
	        end = totalPages;
	    }

	    // ✅ JSP에서 사용할 데이터 추가
	    m.addAttribute("CheckStock", stockList);
	    m.addAttribute("begin", begin);
	    m.addAttribute("end", end);
	    m.addAttribute("pageNum", pageNum);
	    m.addAttribute("totalPages", totalPages);
	    m.addAttribute("currentPage", page);
	    m.addAttribute("searchType", searchType);
	    m.addAttribute("search", search);
	    m.addAttribute("count", count);

	    return "stock/stockall";
	}

	
	@GetMapping("stock/request")
    public String stockRequest(Model model) {
        // orderquantity가 0보다 큰 재고 목록 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        List<Stock> stockList = sservice.getStockWithOrderQuantity(employeeNumber);
        model.addAttribute("stockList", stockList);
        return "stock/request"; // Thymeleaf 템플릿 연결
    }

//    @PostMapping("stock/updateOrderQuantity")
//    public String updateOrderQuantity(@RequestParam("productId") int productId,
//                                      @RequestParam("orderquantity") int orderquantity) {
//        // 주문 수량 업데이트
//    	sservice.updateOrderQuantity(productId, orderquantity);
//        return "redirect:/stock/request"; // 수정 후 목록으로 리다이렉트
//    }
    
    @GetMapping("/stock/find")
    public String findStock(
            @RequestParam(value = "search", required = false) String search, 
            Model model) {
    	
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        
        List<Stock> stockList;

        if (search == null || search.trim().isEmpty()) {
            stockList = sservice.getStockWithOrderQuantity(employeeNumber); // 전체 데이터
        } else {
            stockList = sservice.searchStockWithoutPagination(employeeNumber,search); // 검색된 상품 리스트
        }

        model.addAttribute("stockList", stockList);
        model.addAttribute("search", search);
        return "stock/request"; // 기존 JSP 파일 사용
    }
    
    @PostMapping("/stock/createOrder")
    public ResponseEntity<?> createOrder(@RequestBody List<Stock> stocks) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();

        if (stocks == null || stocks.isEmpty()) {
            return ResponseEntity.badRequest().body("🚨 주문할 상품이 없습니다!");
        }

        try {
            sservice.createOrder(employeeNumber, stocks);
            return ResponseEntity.ok("✅ 주문이 성공적으로 저장되었습니다!");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("❌ 주문 저장 실패!");
        }
    }

    @GetMapping("/stock/restock")
    public String showRestockPage(Model model) {
    	
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        // ✅ 창고 번호 목록을 가져와서 모델에 추가
        List<Integer> warehouseNumbers = sservice.getAllWarehouseNumbers(employeeNumber);
        
        model.addAttribute("stock", new Stock());  // 기존 Stock 객체
        model.addAttribute("warehouseNumbers", warehouseNumbers);  // 창고 번호 목록 추가

        return "stock/restock";  // ✅ JSP 파일 경로 (stock/restock.jsp)
    }

    
    @PostMapping("/stock/add")
    public ResponseEntity<String> addStock(
            @RequestParam("productName") String productName,
            @RequestParam("detail") String detail,
            @RequestParam("quantity") int quantity,
            @RequestParam(value = "orderquantity", required = false, defaultValue = "0") int orderquantity,
            @RequestParam("category") String category,
            @RequestParam("modelname") String modelname,
            @RequestParam("warehouseNumber") int warehouseNumber,
            @RequestParam(value = "image", required = false) MultipartFile imageFile) {
        
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        
        try {
            // 상품명 중복 여부 확인
            if (sservice.isProductNameExists(productName, employeeNumber)) {
                return ResponseEntity.badRequest().body("❌ 이미 존재하는 상품명입니다!");
            }
            
            // Stock 객체 생성
            Stock stock = new Stock();
            stock.setProductName(productName);
            stock.setDetail(detail);
            stock.setQuantity(quantity);
            stock.setOrderquantity(orderquantity);
            stock.setCategory(category);
            stock.setModelname(modelname);
            stock.setWarehouseNumber(warehouseNumber);
            stock.setWareName(whservice.findWareNameById(warehouseNumber));
            // QR 코드 생성 (상품명 | 모델명 | 창고번호 포함)
            String qrData = productName + " | " + modelname + " | 창고번호: " + warehouseNumber;
            String qrCodeBase64 = QRCodeGenerator.generateQRCodeBase64(qrData);
            if (qrCodeBase64 != null) {
                stock.setQrCode(qrCodeBase64);
            }
            
            // 서비스 호출 → int productId 반환
            int productId = sservice.addStock(employeeNumber, stock, imageFile);
            System.out.println("product_id: " + productId);
            stock.setProductId(productId);
            ihservice.saveInoutHistory(stock, "in");
            
            return ResponseEntity.ok("✅ 입고가 성공적으로 완료되었습니다!");
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("❌ 입고 저장 중 오류 발생!");
        }
    }

    
    @PostMapping("/stock/saveOrderQuantitySession")
    @ResponseBody
    public String saveOrderQuantitySession(@RequestParam("productId") int productId, 
                                           @RequestParam("orderquantity") int orderquantity,
                                           HttpSession session) {
        // 세션에 주문 수량 저장
        session.setAttribute("orderquantity_" + productId, orderquantity);
        return "success";
    }

}