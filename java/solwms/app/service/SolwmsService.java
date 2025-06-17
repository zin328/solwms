package solwms.app.service;

import java.awt.image.DataBufferInt;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import solwms.app.dao.SolwmsDao;
import solwms.app.dto.ReturnDto;

@Service
public class SolwmsService {
	@Autowired
	SolwmsDao dao;
	
	public List<ReturnDto> SearchProduct(String productName){
		return dao.SearchProduct(productName);
	}
	public List<ReturnDto> showReturnHistory(){
		return dao.showReturnHistory();
	}
	public List<ReturnDto> showUserReturnHistory(String employeeNumber){
		return dao.showUserReturnHistory(employeeNumber);
	}
	public List<ReturnDto> showProductInventory(){
		return dao.showProductInventory();
	}
	public List<ReturnDto> showUserProductInventory(@Param("loggedInUser") String loggedInUser){
		return dao.showUserProductInventory(loggedInUser);
	}
	public List<ReturnDto> detailProduct(int productId){
		return dao.detailProduct(productId);
	}
	public List<ReturnDto> productHistory(int productId){
		return dao.productHistory(productId);
		
	}
	public List<ReturnDto> showWarehouseInfo(){
		return dao.showWarehouseInfo();
	}
	
	
	
	
	public void saveReturnHistory(String employeeNumber, int productId, String productName, 
            int returnQuantity, int originWarehouseNumber, int returnWarehouseNumber,
            String returnReason, String category, String modelName, String detail) 
		{
		// 1. 기존 창고에서 제품 재고 차감
		dao.updateProductInventory(productId, returnQuantity);
		
		// 2. 반납 창고에 제품이 있는지 확인 후 업데이트
		int updatedRows = dao.updateWarehouseInventory(returnWarehouseNumber, productName, returnQuantity);
		
		// 3. 창고에 해당 제품이 없으면 새롭게 추가
		if (updatedRows == 0) { 
		dao.insertNewProductInventory(returnWarehouseNumber, productName, returnQuantity,  modelName,category, detail);
		}
		
		// 4. 반납 기록 저장 (원래 창고와 반납 창고를 올바르게 매핑)
		dao.insertReturnHistory(employeeNumber, productId, productName, returnQuantity, originWarehouseNumber, returnWarehouseNumber, returnReason);
		}
	public int count() {
		return dao.count();
	}
	public int countprouct(int productId) {
		return dao.countprouct(productId);
	}
	public List<ReturnDto> returnList(int start){
		
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("start", start);
		m.put("count", 10);
		return dao.ReturnList(m);
	}
	public List<ReturnDto> productInout(int start){
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("start", start);
		m.put("count", 10);
		return dao.productInout(m);
	}
	public List<ReturnDto> returnListEmployeeNumber(String username){
		return dao.returnListEmployeeNumber(username);
	}
	
}
