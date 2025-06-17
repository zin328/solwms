package solwms.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import solwms.app.dao.WareHouseDao;
import solwms.app.dto.WareHouse;

@Service
public class WareHouseService {

    @Autowired
    private WareHouseDao wareHouseDao;

    public String findWareHouse(String id){
      return wareHouseDao.findWarehouse(id);
    }

    public void createWareHouse(WareHouse wareHouse){wareHouseDao.createWarehouse(wareHouse);}

    public String findWareNameById(int warehouseNumber){return wareHouseDao.findWareNameById(warehouseNumber);}
}
