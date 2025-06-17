package solwms.app.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import solwms.app.dto.ProductDto;
import solwms.app.service.ProductService;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productservice;

    @GetMapping("/inventory")
    public List<ProductDto> getInventory() {
        return productservice.getUserInventory(); // 재고 목록을 반환
    }
    
    
    @GetMapping("/product/{productId}")
    public ProductDto getProductDetail(@PathVariable int productId) {
        return productservice.getProductById(productId);
    } 
    
    
    
    
}
