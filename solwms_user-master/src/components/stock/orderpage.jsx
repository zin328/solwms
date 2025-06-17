import { useEffect, useState } from "react";
import { createOrder } from "../stock/stockapi"; // 🔹 API 호출 함수 임포트

// 스타일 객체 정의
const containerStyle = {
  maxWidth: '800px',
  margin: '0 auto',
  padding: '20px',
  fontFamily: 'Arial, sans-serif',
};

const headerStyle = {
  textAlign: 'center',
  marginBottom: '20px',
};

const searchContainerStyle = {
  display: 'flex',
  gap: '10px',
  marginBottom: '10px',
  justifyContent: 'flex-end',
};

const searchInputStyle = {
  height: '30px', // 높이 유지
  minWidth: '250px',
  maxWidth: '330px',
  padding: '3px 10px',
  fontSize: '11px',
  border: '1px solid #ccc',
  backgroundColor: '#f9f9f9',
  color: '#333',
  outline: 'none',
};

const searchButtonStyle = {
  height: '38px',
  padding: '8px 16px',
  fontSize: '15px',
  border: '2px solid #333',
  backgroundColor: '#333',
  color: 'white',
  borderRadius: '6px',
  cursor: 'pointer',
};

const tableStyle = {
  width: '100%',
  borderCollapse: 'collapse',
  background: '#fff',
  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
  borderRadius: '8px',
  overflow: 'hidden',
  marginBottom: '20px'
};

const thStyle = {
  background: '#333',
  color: 'white',
  padding: '12px',
  textAlign: 'center',
  border: 'none' // 선 제거
};

const tdStyle = {
  padding: '12px',
  textAlign: 'center',
  border: 'none' // 선 제거
};

const fixedColStyle = {
  width: '200px',
  overflow: 'hidden',
  whiteSpace: 'nowrap',
  textOverflow: 'ellipsis'
};

const orderButtonStyle = {
  backgroundColor: '#333',
  color: 'white',
  padding: '10px 20px',
  fontSize: '16px',
  border: 'none',
  borderRadius: '6px',
  cursor: 'pointer',
  display: 'block',
  margin: '0 auto'
};

const OrderPage = () => {
  const [orders, setOrders] = useState([]);
  const [searchQuery, setSearchQuery] = useState(""); // 입력 상태
  const [filteredOrders, setFilteredOrders] = useState([]); // 검색된 데이터 저장

  useEffect(() => {
    try {
      // localStorage에서 모든 주문 데이터 불러오기
      const storedOrders = JSON.parse(localStorage.getItem("orderData")) || [];
      console.log("📌 불러온 주문 데이터:", storedOrders);

      if (Array.isArray(storedOrders)) {
        setOrders(storedOrders);
        setFilteredOrders(storedOrders); // 초기 데이터 저장
      } else {
        setOrders([]);
        setFilteredOrders([]);
      }
    } catch (error) {
      console.error("🚨 주문 데이터 파싱 오류:", error);
      setOrders([]);
      setFilteredOrders([]);
    }
  }, []);

  // 주문 수량 변경 핸들러
  const handleQuantityChange = (index, value) => {
    setFilteredOrders(prevOrders => {
      const updatedOrders = [...prevOrders];
      updatedOrders[index].orderquantity = parseInt(value) || 0;
      // 변경된 값 localStorage에 즉시 반영
      localStorage.setItem("orderData", JSON.stringify(updatedOrders));
      return updatedOrders;
    });
  };

  // 검색 버튼 클릭 시 실행되는 함수
  const handleSearch = () => {
    const filtered = orders.filter(order =>
      order.productName.toLowerCase().includes(searchQuery.toLowerCase())
    );
    setFilteredOrders(filtered);
  };

  // 전체 주문 버튼 클릭 시 실행 (createOrder API 호출)
  const handleSubmitOrder = async () => {
    if (window.confirm("전체 주문을 완료하시겠습니까?")) {
      // 주문 수량이 주문 가능 수량보다 많은 항목 체크
      const invalidOrders = filteredOrders.filter(order => order.orderquantity > order.quantity);

      if (invalidOrders.length > 0) {
        let errorMsg = "주문 수량이 주문 가능 수량보다 많은 상품이 있습니다:\n";
        invalidOrders.forEach(order => {
          errorMsg += `${order.productName} - 주문 수량: ${order.orderquantity}, 주문 가능 수량: ${order.quantity}\n`;
        });
        alert(errorMsg);
        return; // 주문 진행 중단
      }

      // 모든 주문 항목이 유효할 경우 주문 데이터 구성
      const updatedOrders = filteredOrders.map(order => ({
        productId: order.productId,
        productName: order.productName,
        modelname: order.modelname,
        orderquantity: order.orderquantity,
        quantity: order.quantity  // 주문 가능 수량 정보 포함
      }));

      console.log("🚀 최종 전송 데이터:", updatedOrders);

      const result = await createOrder(updatedOrders); // createOrder 호출

      if (result.success) {
        alert("✅ 전체 주문이 성공적으로 저장되었습니다!");
        // 주문 데이터 초기화 (localStorage, sessionStorage 비우기)
        localStorage.removeItem("orderData");
        sessionStorage.removeItem("orderQuantities");
        // 상태 초기화 (주문 내역 비우기)
        setOrders([]);
        setFilteredOrders([]);
        // 부모 창에도 주문 수량 초기화 반영
        if (window.opener) {
          window.opener.postMessage({ action: "clearOrderQuantities" }, "*");
        }
        window.close(); // 팝업 닫기
      } else {
        alert("❌ 주문 저장 실패! " + result.message);
      }
    }
  };

  return (
    <div className="order-container" style={containerStyle}>
      <h2 style={headerStyle}>📋 주문 내역</h2>

      {/* 검색 입력창 + 검색 버튼 */}
      <div style={searchContainerStyle}>
        <input
          type="text"
          placeholder="상품명 검색."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          style={searchInputStyle}
        />
        <button onClick={handleSearch} style={searchButtonStyle}>
          🔍 검색
        </button>
      </div>

      <table style={tableStyle}>
        <thead>
          <tr>
            <th style={{ ...thStyle, ...fixedColStyle }}>상품명</th>
            <th style={thStyle}>모델명</th>
            <th style={thStyle}>주문 가능 수량</th>
            <th style={thStyle}>주문 수량</th>
          </tr>
        </thead>
        <tbody>
          {filteredOrders.length > 0 ? (
            filteredOrders.map((order, index) => (
              <tr key={index}>
                <td style={fixedColStyle}>{order.productName}</td>
                <td style={tdStyle}>{order.modelname}</td>
                <td style={tdStyle}>{order.quantity}</td>
                <td style={tdStyle}>
                  <input
                    type="number"
                    value={order.orderquantity}
                    onChange={(e) => handleQuantityChange(index, e.target.value)}
                    style={{ width: "60px", textAlign: "center" }}
                  />
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan="4" style={{ textAlign: "center" }}>
                🚨 검색된 상품이 없습니다.
              </td>
            </tr>
          )}
        </tbody>
      </table>

      <button style={orderButtonStyle} onClick={handleSubmitOrder}>
        ✅ 전체 주문
      </button>
    </div>
  );
};

export default OrderPage;
