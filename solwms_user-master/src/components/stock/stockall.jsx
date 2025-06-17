import { useState, useEffect, useRef } from "react";
import PropTypes from "prop-types";
import { fetchStockData, fetchSearchStock, fetchMainStockSummary } from "../stock/stockapi";
import { useNavigate } from "react-router-dom"; // Link 대신 useNavigate 사용
import "../stock/StockAll.css"; // stock 폴더 안의 CSS 파일 import

// PaginationLink 컴포넌트 (CSS 클래스 사용)
const PaginationLink = ({ children, onClick, isActive }) => (
  <a
    href="#"
    onClick={(e) => { e.preventDefault(); onClick(); }}
    className={`pagination-link ${isActive ? "active" : ""}`}
  >
    {children}
  </a>
);

PaginationLink.propTypes = {
  children: PropTypes.node.isRequired,
  onClick: PropTypes.func.isRequired,
  isActive: PropTypes.bool,
};

const StockAll = () => {
  const navigate = useNavigate();
  const [stockList, setStockList] = useState([]);
  const [mainStockSummary, setMainStockSummary] = useState([]);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [searchType, setSearchType] = useState("productName");
  const [pendingSearchType, setPendingSearchType] = useState("productName");
  const [isSearch, setIsSearch] = useState(false);
  const [orderQuantities, setOrderQuantities] = useState(
    JSON.parse(sessionStorage.getItem("orderQuantities")) || {}
  );
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const orderWindowRef = useRef(null);
  const pageGroupSize = 5;

  // 재고 데이터 및 검색 관련 useEffect
  useEffect(() => {
    const getStockData = async () => {
      try {
        const data = await fetchStockData(currentPage);
        if (data) {
          setStockList(data.CheckStock || []);
          setTotalPages(data.totalPages || 1);
        }
      } catch (error) {
        console.error("🚨 재고 데이터 불러오기 실패:", error);
      }
    };

    const getSearchStockData = async () => {
      try {
        const data = await fetchSearchStock(search, searchType, currentPage);
        if (data) {
          setStockList(data.CheckStock || []);
          setTotalPages(data.totalPages || 1);
        }
      } catch (error) {
        console.error("🚨 검색 데이터 불러오기 실패:", error);
      }
    };

    if (isSearch) {
      getSearchStockData();
    } else {
      getStockData();
    }
  }, [isSearch, search, searchType, currentPage]);

  // 메인 창고 요약 데이터 fetch
  useEffect(() => {
    const getMainStockSummary = async () => {
      try {
        const data = await fetchMainStockSummary();
        if (data) {
          setMainStockSummary(data);
        }
      } catch (error) {
        console.error("🚨 메인 창고 요약 데이터 불러오기 실패:", error);
      }
    };
    getMainStockSummary();
  }, []);

  useEffect(() => {
    const handleMessage = (event) => {
      if (event.data?.action === "clearOrderQuantities") {
        console.log("🚀 전체 주문 후 주문 수량 초기화");
        sessionStorage.removeItem("orderQuantities");
        setOrderQuantities({});
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  // 컴포넌트 언마운트 시 주문 수량 데이터 초기화
  useEffect(() => {
    return () => {
      sessionStorage.removeItem("orderQuantities");
    };
  }, []);

  const currentGroup = Math.floor((currentPage - 1) / pageGroupSize);
  const startPage = currentGroup * pageGroupSize + 1;
  const endPage = Math.min(startPage + pageGroupSize - 1, totalPages);

  const handlePageChange = (newPage) => {
    if (newPage >= 1 && newPage <= totalPages) {
      setCurrentPage(newPage);
    }
  };

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    setIsSearch(true);
    setSearch(searchInput);
    setSearchType(pendingSearchType);
    setCurrentPage(1);
  };

  const handleSearchTypeChange = (e) => {
    setPendingSearchType(e.target.value);
  };

  // 주문 수량 입력 시 (주문 가능 수량에 기반)
  const handleOrderQuantityChange = (productId, value) => {
    setOrderQuantities((prev) => {
      const updatedQuantities = { ...prev, [productId]: parseInt(value) || 0 };

      const storedOrders = JSON.parse(sessionStorage.getItem("orderQuantities")) || {};
      const currentStock = stockList.find(stock => stock.productId === productId);
      const mainStock = mainStockSummary.find(
        (item) => item.productName === currentStock?.productName
      );
      const availableQuantity = mainStock ? mainStock.quantity : 0;

      if (updatedQuantities[productId] > 0) {
        storedOrders[productId] = {
          productId,
          productName: currentStock?.productName || "",
          modelname: currentStock?.modelname || "",
          orderquantity: updatedQuantities[productId],
          quantity: availableQuantity
        };
      } else {
        delete storedOrders[productId];
      }

      sessionStorage.setItem("orderQuantities", JSON.stringify(storedOrders));
      console.log("📌 최신 주문 데이터:", storedOrders);
      return updatedQuantities;
    });
  };

  const handleOrderRequest = () => {
    const storedOrders = JSON.parse(sessionStorage.getItem("orderQuantities")) || {};
    const allOrders = Object.values(storedOrders).filter(order => order.orderquantity > 0);

    if (allOrders.length === 0) {
      alert("🚨 주문할 상품을 선택하세요!");
      return;
    }

    console.log("📌 최종 주문 데이터 (저장 전):", allOrders);
    localStorage.setItem("orderData", JSON.stringify(allOrders));

    window.addEventListener("message", (event) => {
      if (event.data?.action === "clearOrderQuantities") {
        setOrderQuantities({});
        sessionStorage.removeItem("orderQuantities");
      }
    });

    if (!orderWindowRef.current || orderWindowRef.current.closed) {
      orderWindowRef.current = window.open("/order-page", "_blank", "width=600,height=400");
    } else {
      orderWindowRef.current.focus();
    }
  };

  return (
    <div className="stock-all-wrapper">
      <div className="stock-all-container">
        <h2>재고 목록</h2>
        {/* 컨트롤러: 왼쪽은 주문 신청, 오른쪽은 검색 컨트롤 */}
        <div className="control-container">
          <div className="left-control">
            <button onClick={handleOrderRequest} className="button-style">
              주문 신청
            </button>
          </div>
          <div className="right-control">
            <select value={pendingSearchType} onChange={handleSearchTypeChange} className="select-style">
              <option value="productName">상품명</option>
              <option value="modelname">모델명</option>
              <option value="category">카테고리</option>
            </select>
            <input
              type="text"
              placeholder="검색어 입력"
              value={searchInput}
              onChange={(e) => setSearchInput(e.target.value)}
              className="input-style"
            />
            <button onClick={handleSearchSubmit} className="button-style">
              검색
            </button>
          </div>
        </div>

        <table className="table-style">
          <thead>
            <tr>
              <th className="th-style fixed-col">상품명</th>
              <th className="th-style">모델명</th>
              <th className="th-style">카테고리</th>
              <th className="th-style">수량</th>
              <th className="th-style">주문 가능 수량</th>
              <th className="th-style th-quantity">주문 수량</th>
            </tr>
          </thead>
          <tbody>
            {stockList.map((stock) => {
              const mainStock = mainStockSummary.find(
                (item) => item.productName === stock.productName
              );
              const availableQuantity = mainStock ? mainStock.quantity : 0;
              return (
                <tr
                  key={stock.productId}
                  onClick={() => navigate(`/detail/${stock.productId}`)}
                  style={{ cursor: "pointer" }}
                >
                  <td className="td-style fixed-col">{stock.productName}</td>
                  <td className="td-style">{stock.modelname}</td>
                  <td className="td-style">{stock.category}</td>
                  <td className="td-style">{stock.quantity}</td>
                  <td className="td-style">{availableQuantity}</td>
                  {/* 주문 수량 입력 셀: 셀 전체에 onClick 이벤트 전파를 막아 링크 이동이 발생하지 않도록 함 */}
                  <td
                  className="td-style td-quantity"
                  onClick={(e) => e.stopPropagation()}
                  style={{ cursor: "default" }} // 기본 커서로 오버라이드
                >
                  <input
                    type="number"
                    value={orderQuantities[stock.productId] || ""}
                    onChange={(e) =>
                      handleOrderQuantityChange(stock.productId, e.target.value)
                    }
                    className="input-style number-input"
                  />
                </td>

                </tr>
              );
            })}
          </tbody>
        </table>

        <div className="pagination-container">
          {startPage > 1 && (
            <PaginationLink onClick={() => handlePageChange(startPage - 1)}>
              ⏪ 이전
            </PaginationLink>
          )}

          {Array.from({ length: endPage - startPage + 1 }, (_, index) => startPage + index).map((num) => (
            <PaginationLink
              key={num}
              isActive={num === currentPage}
              onClick={() => handlePageChange(num)}
            >
              {num}
            </PaginationLink>
          ))}

          {endPage < totalPages && (
            <PaginationLink onClick={() => handlePageChange(endPage + 1)}>
              다음 ⏩
            </PaginationLink>
          )}
        </div>
      </div>
    </div>
  );
};

export default StockAll;
