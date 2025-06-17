package solwms.app.service;

import com.fasterxml.jackson.databind.introspect.TypeResolutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import solwms.app.dao.OrderDetailDao;
import solwms.app.dao.ProductDao;
import solwms.app.dto.*;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class OrderDetailService {

    @Autowired
    private OrderDetailDao orderDetailDao;

    public List<OrderDetail> getOrderDetailsByOrderNumber(int orderNumber) {
        return orderDetailDao.getOrderDetailsByOrderNumber(orderNumber);
    }

    public Order getOrderByOrderNumber(int orderNumber) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        Order order = orderDetailDao.getOrderByOrderNumber(orderNumber);
        if (order != null && order.getOrderDate() != null) {
            order.setOrderDateFormatted(order.getOrderDate().format(formatter));
        }
        return order;
    }

    public void cancelOrder(int orderNumber) {
        orderDetailDao.updateOrderState(orderNumber, "CANCELED");
    }

    public void confirmOrder(int orderNumber) {
        orderDetailDao.updateOrderState(orderNumber, "RECEIVED");
    }

    public void startShipping(int orderNumber) {
        orderDetailDao.updateOrderState(orderNumber, "SHIPPING");
    }

    public void completeDelivery(int orderNumber) {
        orderDetailDao.updateOrderState(orderNumber, "DELIVERED");
    }

    public ProductDto  getProductInventoryByProductName(String product_name) {
        return orderDetailDao.getProductInventoryByProductName(product_name);
    }

    public void decreaseProductInventory(String ProductName, int quantity) {
        orderDetailDao.decreaseProductQuantity(ProductName, quantity);
    }

    public WareHouse getWarehouseByEmployeeNumber(String employeeNumber) {
        return orderDetailDao.getWarehouseByEmployeeNumber(employeeNumber);
    }

    public void increaseProductQuantity(String productName, int quantity, int warehouseNumber) {
        boolean exists = orderDetailDao.existsByProductNameAndWarehouse(productName, warehouseNumber);

        if (exists) {
            orderDetailDao.increaseProductQuantity(productName, quantity, warehouseNumber);
        } else {
            Stock stock = orderDetailDao.stockAll(productName);



            Stock newStock = new Stock();
            newStock.setProductName(stock.getProductName());
            newStock.setQuantity(quantity);
            newStock.setOrderquantity(stock.getOrderquantity());
            newStock.setWarehouseNumber(warehouseNumber);
            newStock.setCategory(stock.getCategory());
            newStock.setModelname(stock.getModelname());
            newStock.setDetail(stock.getDetail());
            newStock.setImageName(stock.getImageName());
            newStock.setQrCode(stock.getQrCode());
            newStock.setWareName(stock.getWareName());

            orderDetailDao.insertStock(newStock);
        }
    }

}
