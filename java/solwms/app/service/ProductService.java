package solwms.app.service;

import java.util.Collections;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import solwms.app.dao.ProductDao;
import solwms.app.dao.UserDao;
import solwms.app.dao.WareHouseDao;
import solwms.app.dto.ProductDto;
import solwms.app.dto.UserDto;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductDao productdao;
    
    @Autowired
    private WareHouseDao waredao;
    

    public List<ProductDto> getInventoryList() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        try {
            int wareNum = Integer.parseInt(employeeNumber);  // employeeNumber가 숫자 문자열일 경우
            List<ProductDto> products = productdao.getProductInventory(wareNum);
            return (products != null) ? products : Collections.emptyList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }



    public List<ProductDto> getUserInventory(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
        try {
            List<ProductDto> products = productdao.getUserInventory(employeeNumber);
            return (products != null) ?

                    products : Collections.emptyList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
    
    public ProductDto getProductById(int productId) {
        return productdao.getProductById(productId);
    }
    
    public List<ProductDto> getUserInventoryList() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String employeeNumber = authentication.getName();
    	int wareNum = waredao.findWareNum(employeeNumber);
    	
    	
        try {
            List<ProductDto> products = productdao.getUserProductInventory(wareNum);
            return (products != null) ? products : Collections.emptyList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

}
    
    
