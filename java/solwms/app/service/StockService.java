package solwms.app.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import solwms.app.dao.StockDao;
import solwms.app.dto.Stock;
import solwms.app.dto.Stock.OrderDetail;
import solwms.app.dto.Stock.OrderHistory;
import solwms.app.qr.QRCodeGenerator;



@Service
public class StockService {

	@Autowired
	private StockDao dao; //DAO구현 객체 주입
	
	// 로그인한 사용자의 창고 재고 목록 조회 (페이징 X)
    public List<Stock> CheckStock(String employeeNumber) {
        return dao.CheckStock(employeeNumber);
    }

    // 로그인한 사용자의 창고 재고 개수 조회 (페이징을 위한 총 개수 확인)
    public int countStock(String employeeNumber) {
        return dao.countStock(employeeNumber);
    }

    // 로그인한 사용자의 창고 재고 목록 조회 (페이징 O)
    public List<Stock> CheckStockPaginated(String employeeNumber, int start, int count) {
        return dao.getStockListPaginated(employeeNumber, start, count);
    }
    
    public List<Stock> searchStock(String employeeNumber,String searchType, String search, int start, int count) {
        return dao.searchStock(employeeNumber,searchType, search, start, count);
    }

    public int countSearchStock(String employeeNumber,String searchType, String search) {
        return dao.countSearchStock(employeeNumber,searchType, search);
    }

    
    public List<Stock> getStockWithOrderQuantity(String employeeNumber) {
        return dao.findStockWithOrderQuantity(employeeNumber);
    }
    
    public List<Stock> searchStockWithoutPagination(String employeeNumber,String search) {
        return dao.searchStockWithoutPagination(employeeNumber, "%" + search + "%");
    }
    
    @Transactional
    public void createOrder(String employeeNumber, List<Stock> stocks) {
        if (stocks == null || stocks.isEmpty()) {
            throw new IllegalArgumentException("🚨 주문할 상품이 없습니다!");
        }

        // 1️⃣ OrderHistory 추가
        OrderHistory orderHistory = new OrderHistory();
        orderHistory.setEmployeeNumber(employeeNumber);
        dao.insertOrderHistory(orderHistory); // 실행 후 orderNumber가 자동 설정됨

        int orderNumber = orderHistory.getOrderNumber(); // 새로 생성된 주문번호 가져오기

        // 2️⃣ OrderDetail 추가
        List<OrderDetail> orderDetails = new ArrayList<>();
        for (Stock stock : stocks) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderNumber(orderNumber);
            detail.setProductId(stock.getProductId());
            detail.setQuantity(stock.getOrderquantity());
            orderDetails.add(detail);
        }

        if (!orderDetails.isEmpty()) {
            dao.insertOrderDetails(orderDetails);
        }
    }

    @Transactional
    public void usercreateOrder(String employeeNumber, List<Stock> stocks) {
        if (stocks == null || stocks.isEmpty()) {
            throw new IllegalArgumentException("🚨 주문할 상품이 없습니다!");
        }

        // 1️⃣ OrderHistory 추가
        OrderHistory orderHistory = new OrderHistory();
        orderHistory.setEmployeeNumber(employeeNumber);
        dao.userinsertOrderHistory(orderHistory); // 실행 후 orderNumber가 자동 설정됨

        int orderNumber = orderHistory.getOrderNumber(); // 새로 생성된 주문번호 가져오기

        // 2️⃣ OrderDetail 추가
        List<OrderDetail> orderDetails = new ArrayList<>();
        for (Stock stock : stocks) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderNumber(orderNumber);
            detail.setProductId(stock.getProductId());
            detail.setQuantity(stock.getOrderquantity());
            orderDetails.add(detail);
        }

        if (!orderDetails.isEmpty()) {
            dao.insertOrderDetails(orderDetails);
        }
    }
    
    private final ServletContext servletContext;

    public StockService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    @Transactional
    public int addStock(String employeeNumber, Stock stock, MultipartFile imageFile) throws IOException {
        // ✅ QR 코드 자동 생성 (상품명 | 모델명 | 창고번호 포함)
        String qrData = stock.getProductName() + " | " + stock.getModelname() + " | 창고번호: " + stock.getWarehouseNumber();
        String qrCodeBase64 = QRCodeGenerator.generateQRCodeBase64(qrData);
        if (qrCodeBase64 != null) {
            stock.setQrCode(qrCodeBase64);
        }

        // ✅ 이미지 저장 처리
        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename(); // ✅ 중복 방지

            // ✅ 절대 경로 가져오기 (실제 배포 경로)
            String uploadDir = servletContext.getRealPath("/resources/images/");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs(); // ✅ 경로 없으면 생성
            }

            File destFile = new File(uploadDir, fileName);
            imageFile.transferTo(destFile); // ✅ 파일 저장

            System.out.println("✅ 이미지 저장 경로: " + destFile.getAbsolutePath());

            stock.setImageName(fileName);
        }

        // ✅ DB 저장 (MyBatis의 insertStock 메서드가 자동 생성된 product_id를 stock 객체에 설정)
        dao.insertStock(employeeNumber, stock);

        // 저장 후 stock 객체에서 product_id만 반환
        return stock.getProductId();
    }


   
    public List<Integer> getAllWarehouseNumbers(String employeeNumber) {
        return dao.getAllWarehouseNumbers(employeeNumber); // ✅ 창고 번호만 반환하도록 변경
    }

    
    public boolean isProductNameExists(String productName, String employeeNumber) {
        return dao.countByProductName(productName, employeeNumber) > 0;
    }

    public List<Map<String, Object>> getMainWarehouseSummary() {
        return dao.getMainWarehouseSummary();
    }

}
