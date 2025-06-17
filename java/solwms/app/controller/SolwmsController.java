package solwms.app.controller;

import solwms.app.dto.ReturnDto;
import solwms.app.dto.Stock;
import solwms.app.service.InoutHistoryService;
import solwms.app.service.SolwmsService;
import solwms.app.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import solwms.app.service.WareHouseService;

import java.util.List;

@Controller
public class SolwmsController {

    @Autowired
    private SolwmsService solService;
    
    @Autowired
    private WareHouseService wareHouseService;

    @Autowired
    private InoutHistoryService inoutHistoryService;

    @RequestMapping("/return")
    public String returnProduct(@RequestParam(value = "selectedProduct", required = false) String selectedProduct, 
                                @RequestParam(name="p", defaultValue = "1") int page, 
                                Model model,HttpSession session) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = "Anonymous"; // 기본값 설정
        
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            username = userDetails.getUsername(); // 현재 로그인한 사용자의 ID 또는 username
        }

        // ✅ 세션에 사용자 정보 저장 (필요 시 JSP에서도 사용 가능)
        session.setAttribute("loggedInUser", username);
        // 선택한 제품 정보 추가
        if (selectedProduct != null) {
            model.addAttribute("selectedProduct", selectedProduct);
        }

        // 반납 내역 개수 조회
        int count = solService.count();
        if (count > 0) {
            int perPage = 10; // 한 페이지에 표시할 반납 내역 수
            int startRow = (page - 1) * perPage;

            // 페이징된 반납 내역 조회
            List<ReturnDto> returnHistoryList = solService.returnList(startRow);
            System.out.println(returnHistoryList.get(0).getWareName());
            model.addAttribute("returnHistoryList", returnHistoryList);

            int pageNum = 5;
            int totalPages = count / perPage + (count % perPage > 0 ? 1 : 0); // 전체 페이지 수

            int begin = (page - 1) / pageNum * pageNum + 1;
            int end = begin + pageNum - 1;
            if (end > totalPages) {
                end = totalPages;
            }

            model.addAttribute("begin", begin);
            model.addAttribute("end", end);
            model.addAttribute("pageNum", pageNum);
            model.addAttribute("totalPages", totalPages);
        }
       
        model.addAttribute("count", count);
        model.addAttribute("pa",page);
      
        return "return/return"; // /WEB-INF/views/return/return.jsp 반환
    }


    // 📌 검색 페이지 (search.jsp)
    @GetMapping("/return/search")
    public String showSearchPage(@RequestParam(value = "product_name", required = false) String product_name, Model model) {
        List<ReturnDto> products;

        if (product_name != null && !product_name.trim().isEmpty()) {
            products = solService.SearchProduct(product_name); // 검색된 제품 리스트
        } else {
            products = solService.showProductInventory(); // 전체 제품 리스트
        }

        model.addAttribute("products", products);
        return "return/search"; // /WEB-INF/views/return/search.jsp 반환
    }


    // 📌 검색 결과 선택 후 return.jsp로 데이터 전달
    @GetMapping("/return/select")
    public String selectProduct(@RequestParam("selectedProduct") String selectedProduct,
                                 @RequestParam("selectedProductId") int selectedProductId, // product_id도 추가
                                 RedirectAttributes redirectAttributes) {
        // `selectedProduct` (자재명)과 `selectedProductId` (제품 ID)를 함께 전달
        redirectAttributes.addAttribute("selectedProduct", selectedProduct);
        redirectAttributes.addAttribute("selectedProductId", selectedProductId);
        return "redirect:/return"; // 반납 페이지로 리다이렉트 (return.jsp)
    }
    @PostMapping("return/submit")
    public String returnSubmit(@RequestParam("employeeNumber") String employeeNumber,
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

        return "redirect:/return"; // 재고 현황 페이지로 리다이렉트
    }
    @GetMapping("detail/{productId}")
    public String productDetail(@PathVariable("productId") int productId,@RequestParam(name="p", defaultValue = "1") int page,Model m) {
    	List<ReturnDto> Plist=solService.detailProduct(productId);
    	
    	List<ReturnDto> PHlist=solService.productHistory(productId);
    	
    	
    	m.addAttribute("Plist", Plist);
    	m.addAttribute("PHlist",PHlist);
    	return "detail/detail";
    }
  

    
    
    
    
}
