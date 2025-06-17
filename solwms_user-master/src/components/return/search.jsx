import React, { useState, useEffect } from 'react';
import { searchProduct } from "./returnApi.js";

const Search = () => {
    const [searchTerm, setSearchTerm] = useState('');
    const [products, setProducts] = useState([]); // 전체 제품 목록
    const [filteredProducts, setFilteredProducts] = useState([]); // 검색된 제품 목록
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    // ✅ 모든 제품 정보를 불러오기 (초기 렌더링 시)
    useEffect(() => {
        const fetchAllProducts = async () => {
            setLoading(true);
            try {
                const data = await searchProduct(); // 전체 제품 목록 가져오기
                if (data && data.products) {
                    setProducts(data.products); 
                    setFilteredProducts(data.products); // 🔥 초기 상태에서 전체 제품을 표시
                }
            } catch (error) {
                console.error("데이터 로드 실패:", error);
                setError("제품 목록을 불러오는 데 실패했습니다.");
            } finally {
                setLoading(false);
            }
        };
        fetchAllProducts();
    }, []);

    // ✅ 검색 버튼 클릭 시 필터링 적용
    const handleSearch = (event) => {
        event.preventDefault();
        if (!searchTerm) {
            setFilteredProducts(products); // 🔥 검색어 없으면 전체 제품 유지
            return;
        }

        const filtered = products.filter(product =>
            product.product_name.toLowerCase().includes(searchTerm.toLowerCase()) // 🔥 product_name 기준 검색
        );
        setFilteredProducts(filtered);
    };

    const selectProduct = (product) => {
    window.opener.postMessage({ 
        product_name: product.product_name, 
        product_id: product.product_id,
        warehouseNumber: product.warehouseNumber, // ✅ 창고번호 추가
        detail: product.detail, // ✅ 상세 정보 추가
        model_name: product.model_name, // ✅ 모델명 추가
        category: product.category, // ✅ 카테고리 추가
        quantity: product.quantity
    }, window.location.origin);
    window.close();
};

    return (
        <div style={containerStyle}>
            <h2>자재 검색</h2>
            <form onSubmit={handleSearch} style={formStyle}>
                <input
                    type="text"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    placeholder="자재명 입력"
                    style={inputStyle}
                />
                <button type="submit"  style={buttonStyle} onMouseEnter={(e) => e.target.style.backgroundColor = buttonHoverStyle.backgroundColor} onMouseLeave={(e) => e.target.style.backgroundColor = buttonStyle.backgroundColor} >검색</button> {/* 🔥 검색 버튼 추가 */}
            </form>

            {loading && <p>🔄 로딩 중...</p>}
            {error && <p style={{ color: "red" }}>{error}</p>}

            {filteredProducts.length > 0 ? (
                <table style={tableStyle}>
                    <thead>
                        <tr>
                            <th style={thStyle}>창고번호</th>
                            <th style={thStyle}>제품 ID</th>
                            <th style={thStyle}>식별번호</th>   
                            <th style={thStyle}>제품명</th>
                            <th style={thStyle}>재고수량</th>
                            <th style={thStyle}>선택</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredProducts.map((product) => (
                            <tr key={product.product_id}>
                                <td style={tdStyle}>{product.warehouseNumber}</td>
                                <td style={tdStyle}>{product.model_name}</td>
                                <td style={tdStyle}>{product.product_id}</td>
                                <td style={tdStyle}>{product.product_name}</td>
                                <td style={tdStyle}>{product.quantity}</td>
                                <td style={tdStyle}>
                                    <button onClick={() => selectProduct(product)} style={buttonStyle} onMouseEnter={(e) => e.target.style.backgroundColor = buttonHoverStyle.backgroundColor} onMouseLeave={(e) => e.target.style.backgroundColor = buttonStyle.backgroundColor}>
                                        선택
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            ) : (
                !loading && <p>🔍 검색 결과가 없습니다.</p>
            )}
        </div>
    );
};

// ✅ 스타일 정의
const containerStyle = {
    fontFamily: "Arial, sans-serif",
    padding: "10px",
    textAlign: "center",
    backgroundColor: "#f9f9f9",
    width: "100%",
    height: "100%",
    overflow: "auto",
};

const formStyle = {
    display: "flex",
    justifyContent: "center",
    gap: "10px",
    marginBottom: "20px"
};

const inputStyle = {
    padding: "10px",
    width: "250px",
    border: "1px solid #ccc",
    borderRadius: "5px"
};

const buttonStyle = {
    padding: "10px 15px",
    backgroundColor: "#333",
    color: "white",
    border: "none",
    borderRadius: "5px",
    cursor: "pointer",
    fontWeight: "bold",
    transition: "0.3s",
};

const tableStyle = {
    width: '100%',
    borderCollapse: 'collapse',
    marginTop: '10px',
    boxShadow: '0 0 10px rgba(0, 0, 0, 0.1)', // 테이블 테두리 그림자 추가
    backgroundColor: '#ffffff',
};

const thStyle = {
    backgroundColor: '#333', // 헤더 배경색 (파란색 계열)
    color: 'white',
    padding: '12px',
    textAlign: 'center',
    borderBottom: '2px solid #2980b9',
};

const tdStyle = {
    padding: '10px',
    textAlign: 'center',
    borderBottom: '1px solid #ddd',
};

const selectButtonStyle = {
    padding: "5px 10px",
    backgroundColor: "#28a745",
    color: "white",
    border: "none",
    borderRadius: "10px",
    cursor: "pointer",
    fontWeight: "bold",
    transition: "0.3s",
};
const buttonHoverStyle = {
    backgroundColor: '#2280f9',
};
export default Search;
