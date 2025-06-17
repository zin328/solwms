package solwms.app.controller;

import solwms.app.dto.ReturnDto;
import solwms.app.dto.Stock;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.SolwmsService;
import solwms.app.service.StockService;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import solwms.app.service.WareHouseService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class userSolwmsController {

    @Autowired
    SolwmsService solService;
    
    @Autowired
    private WareHouseService wareHouseService;

    @Autowired
    private InoutHistoryService inoutHistoryService;

    @RequestMapping("/return")
    public ResponseEntity<Map<String, Object>> userReturnProduct(
            @RequestParam(value = "selectedProduct", required = false) String selectedProduct,
            Model model, 
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        
        // 로그인한 사용자 정보를 SecurityContextHolder에서 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = "Anonymous"; // 기본값 설정

        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            username = userDetails.getUsername();
        }

        // 세션에 로그인한 사용자 정보를 저장
        session.setAttribute("loggedInUser", username);
        response.put("loggedInUser", username); // 응답에도 로그인 정보 포함

        // 선택한 제품 정보가 있을 경우, 응답에 포함
        if (selectedProduct != null) {
            response.put("selectedProduct", selectedProduct);
        }

        // 반납 내역 개수 조회
        int count = solService.count();
        response.put("count", count);

        if (count > 0) {
            // ✅ 모든 반납 내역 조회 (페이징 제거)
            List<ReturnDto> returnHistoryList = solService.returnListEmployeeNumber(username); // 새로운 메서드 사용
            response.put("returnHistoryList", returnHistoryList);
        }

        return ResponseEntity.ok(response); // 모든 데이터를 반환
    }



    // 📌 검색 페이지 (search.jsp)
    @GetMapping("/return/search")
    public ResponseEntity<Map<String, Object>> userShowSearchPage(HttpServletRequest request,@RequestParam(value = "product_name", required = false) String product_name, Model model) {
    	Map<String,Object> response= new HashMap<>();
    	List<ReturnDto> products;
    	String loggedInUser = (String) request.getSession().getAttribute("loggedInUser");
    	System.out.println("로그인 된 유저"+loggedInUser);
        if (product_name != null && !product_name.trim().isEmpty()) {
            products = solService.SearchProduct(product_name); // 검색된 제품 리스트
        } else {
            products = solService.showUserProductInventory(loggedInUser); //로그인한 유저가 가지고있는 제품창고 가져오기
        }

        response.put("products", products);
        return ResponseEntity.ok(response); // /WEB-INF/views/return/search.jsp 반환
    }


    // 📌 검색 결과 선택 후 return.jsp로 데이터 전달
    @GetMapping("/return/select")
    public ResponseEntity<Map<String, Object>> userSelectProduct(@RequestParam("selectedProduct") String selectedProduct,
                                 @RequestParam("selectedProductId") int selectedProductId, // product_id도 추가
                                 RedirectAttributes redirectAttributes) {
    	Map<String,Object> response= new HashMap<>();
        // `selectedProduct` (자재명)과 `selectedProductId` (제품 ID)를 함께 전달
    	response.put("selectedProduct", selectedProduct);
    	response.put("selectedProductId", selectedProductId);
        return ResponseEntity.ok(response); // 반납 페이지로 리다이렉트 (return.jsp)
    }
    @PostMapping("return/submit")
    public ResponseEntity<Map<String, Object>> userReturnSubmit(@RequestParam("employeeNumber") String employeeNumber,
                               @RequestParam("productName") String productName,
                               @RequestParam("productId") int productId,
                               @RequestParam("returnQuantity") int returnQuantity,
                               @RequestParam("OriginwarehouseNumber") int OriginwarehouseNumber,
                               @RequestParam("returnWareHouseNumber") int returnWareHouseNumber,
                               @RequestParam("returnReason") String returnReason,
                               @RequestParam("detail") String detail,  // 추가된 필드
                               @RequestParam("modelName") String modelName,  // 추가된 필드
                               @RequestParam("category") String category  // 추가된 필드
                              ) {
    	Map<String,Object> response= new HashMap<>();
    	
        // 반납 내역을 서비스로 저장
        solService.saveReturnHistory(employeeNumber, productId, productName, returnQuantity,OriginwarehouseNumber, 
                                     returnWareHouseNumber, returnReason, detail, modelName, category);
        Stock stock = new Stock();

        stock.setQuantity(returnQuantity);
        stock.setWareName("관리자 창고");
        int outproductId = inoutHistoryService.findProductId(productName, returnWareHouseNumber);
        stock.setProductId(outproductId);
        // 창고의 재고 수량 업데이트 (in 처리)
        inoutHistoryService.saveInoutHistory(stock, "in");
        String wareName = wareHouseService.findWareHouse(employeeNumber);
        stock.setQuantity(returnQuantity);
        stock.setWareName(wareName);
        stock.setProductId(productId);
        // 창고의 재고 수량 업데이트 (in 처리)
        inoutHistoryService.saveInoutHistory(stock, "out");
        return ResponseEntity.ok(response); // 재고 현황 페이지로 리다이렉트
    }
    @GetMapping("detail/{productId}")
    public ResponseEntity<Map<String, Object>> userProductDetail(
            @PathVariable("productId") int productId,
            @RequestParam(name="p", defaultValue = "1") int page) {

        Map<String, Object> response = new HashMap<>();
        
        List<ReturnDto> Plist = solService.detailProduct(productId);
        List<ReturnDto> PHlist = solService.productHistory(productId);

        // 이미지 URL을 Plist에 추가
        for (ReturnDto product : Plist) {
            if (product.getImage_name() != null && !product.getImage_name().isEmpty()) {
                // 이미지 URL 생성
                String imageUrl = ServletUriComponentsBuilder
                        .fromCurrentContextPath()
                        .path("/resources/images/")
                        .path(product.getImage_name())
                        .toUriString();
                product.setImage_name(imageUrl); // 새로운 필드 imageUrl 추가
                System.out.println(imageUrl);
            }
        }
       

        response.put("Plist", Plist);
        response.put("PHlist", PHlist);

        return ResponseEntity.ok(response);
    }


    
    
    
    
}
