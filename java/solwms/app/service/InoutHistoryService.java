package solwms.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import solwms.app.dao.InoutHistoryDao;
import solwms.app.dto.InoutHistory;
import solwms.app.dto.Stock;

import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class InoutHistoryService {

    @Autowired
    private InoutHistoryDao inoutHistoryDao;

    public int count() {
        return inoutHistoryDao.count();
    }

    public List<InoutHistory> selectInoutAll(int start) {

        Map<String, Object> m = new HashMap<String, Object>();
        m.put("start", start);
        m.put("count", 10);
        return inoutHistoryDao.selectAll(m);
    }

    public int countSearchInoutHistory(String category, String date1, String date2, String searchKeyword, String wareName, String state) {
         return inoutHistoryDao.countSearchInoutHistory(category, date1, date2, searchKeyword, wareName, state);
    }

    public List<InoutHistory> searchInout(String category, String date1, String date2, String searchKeyword, String wareName, String state, int start) {
       return inoutHistoryDao.searchInoutHistory(category, date1, date2, searchKeyword, wareName, state, start, 10);
    }


    public void saveInoutHistory(Stock stock, String state) {
        inoutHistoryDao.saveInoutHistory(
                stock.getProductId(),  // ✅ productName 전달 확인
                LocalDate.now(),
                state,
                stock.getQuantity(),
                stock.getWareName()
        );
    }

    public int findProductId(String productName, int warehouseNumber){
        return inoutHistoryDao.findProductId(productName, warehouseNumber);
    }
}
