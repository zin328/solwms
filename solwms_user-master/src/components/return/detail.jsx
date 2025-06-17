import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { productDetail } from "./detailApi.js"; // ✅ 새 API 호출 함수 사용
import './detail.css'; // 스타일 시트 불러오기

const Detail = () => {
    const { productId } = useParams(); // URL에서 productId 받아오기
    const [data, setData] = useState({ Plist: [], PHlist: [] });
    const [imageUrl, setImageUrl] = useState(""); // 이미지 URL 상태 추가

    useEffect(() => {
        const fetchProductDetails = async () => {
            const response = await productDetail(productId, 1); // 새 API 호출
            if (response) {
                setData(response);
                if (response.Plist.length > 0 && response.Plist[0].imageUrl) {
                    setImageUrl(response.Plist[0].imageUrl); // 백엔드에서 제공한 imageUrl 사용
                }
            }
        };

        fetchProductDetails();
    }, [productId]);

    if (!data.Plist?.length) {
        return <div>Loading... (혹은 데이터 없음)</div>;
    }

    return (
        <div className="detail-container">
            <h1 className="title">제품 상세 페이지</h1>

            {data.Plist.map((product, index) => (
                <section key={index} className="section">
                    <div className="product-info">
                        {/* 상품명과 세부사항 */}
                        <div className="product-details">
                            <p className="product-title">제품명: {product.product_name}</p>
                            <p className="product-detail">모델명: {product.model_name}</p>
                            <p className="product-detail">상세사항: {product.detail}</p>
                            <p className="product-category">카테고리: {product.category}</p>
                            <p className="product-detail">Product ID: {productId}</p>
                            
                            
                        </div>

                        {/* 상품 이미지 */}
                        {product.image_name && (
                            <div className="image-container">
                                <img src={product.image_name} alt="제품 이미지" className="image" />
                            </div>
                        )}
                    </div>
                </section>
            ))}

            <h2 className="title">입출고 내역</h2>
            <table className="table">
                <thead>
                    <tr>
                        
                        <th className="th">상태</th>
                        <th className="th">번호</th>
                        <th className="th">제품 ID</th>
                        <th className="th">날짜</th>
                        <th className="th">수량</th>
                    </tr>
                </thead>
                <tbody>
                    {data.PHlist.map((history, index) => (
                        <tr key={index}>
                            
                            <td className="td">
                                <span
                                    className={history.state === "in" ? "in-state" : (history.state === "out" ? "out-state" : "")}
                                >
                                    {history.state === "in" ? "입고" : (history.state === "out" ? "출고" : "")}
                                </span>
                                </td>
                                <td className="td">{history.number}</td>
                            <td className="td">{history.product_id}</td>
                            <td className="td">
                                {new Date(history.date).toLocaleDateString('ko-KR', {
                                    year: 'numeric',
                                    month: 'long',
                                    day: 'numeric'
                                })}
                            </td>
                            <td className="td">{history.quantity}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default Detail;
