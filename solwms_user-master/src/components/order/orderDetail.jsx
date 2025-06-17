import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import * as bootstrap from 'bootstrap'; // Bootstrap 모듈 사용
import './OrderDetail.css';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

function OrderDetail() {
    const [searchParams] = useSearchParams();
    const orderNumberParam = searchParams.get('orderNumber');

    const [order, setOrder] = useState(null);
    const [orderDetails, setOrderDetails] = useState([]);
    const [message, setMessage] = useState("");
    const [errorMessage, setErrorMessage] = useState("");
    const [loading, setLoading] = useState(true);

    // 모달 상태 관리
    const [modalAction, setModalAction] = useState('');
    const [showModal, setShowModal] = useState(false);

    useEffect(() => {
        const flashMessage = sessionStorage.getItem("flashMessage");
        if (flashMessage) {
            setMessage(flashMessage);
            sessionStorage.removeItem("flashMessage");
        }

        if (orderNumberParam) {
            setLoading(true);
            axios
                .get(`${API_BASE_URL}/orderdetail`, {
                    params: { orderNumber: orderNumberParam },
                    withCredentials: true,
                })
                .then((response) => {
                    const data = response.data; // { order, orderDetails } 형태
                    setOrder(data.order);
                    setOrderDetails(data.orderDetails);
                    setLoading(false);
                })
                .catch((err) => {
                    console.error(err);
                    setErrorMessage("주문 상세 정보를 불러오는 데 실패했습니다.");
                    setLoading(false);
                });
        } else {
            setErrorMessage("주문번호가 제공되지 않았습니다.");
            setLoading(false);
        }
    }, [orderNumberParam]);

    const getStatusLabel = (state) => {
        switch (state) {
            case 'ORDER_PENDING': return '주문 대기';
            case 'RECEIVED': return '주문 접수';
            case 'CANCELED': return '주문 취소';
            case 'SHIPPING': return '배송 중';
            case 'DELIVERED': return '배송 완료';
            default: return '상태 없음';
        }
    };

    // 상품 상세 페이지 새 창에서 열기
    const openProductDetail = (productId) => {
        window.open(`http://localhost:5173/detail/${productId}`, '_blank');
    };

    // 모달 열기
    const handleShowModal = (action) => {
        setModalAction(action);
        setShowModal(true);
    };

    // 모달에서 '확인' 버튼 클릭 시 실행될 함수
    const handleConfirmAction = () => {
        if (modalAction === 'deliver') {
            axios
                .get(`${API_BASE_URL}/orderdetail/deliver/${orderNumberParam}`, { withCredentials: true })
                .then(() => {
                    // 배송 완료 후 flashMessage를 sessionStorage에 저장 후 페이지 리로드
                    sessionStorage.setItem("flashMessage", "배송이 완료되었습니다.");
                    window.location.reload(); // 페이지 새로고침
                })
                .catch((error) => {
                    console.error(error);
                    setErrorMessage("배송 완료 처리에 실패했습니다.");
                });
        }
        setShowModal(false);
    };

    if (loading) return <div>로딩 중...</div>;
    if (errorMessage && !order) return <div>{errorMessage}</div>;
    if (!order) return <div>주문 정보가 없습니다.</div>;

    return (
        <div>
            <div className="main-content">
                {/* Flash 메시지 표시 */}
                {message && (
                    <div className="alert alert-success alert-dismissible fade show" role="alert">
                        {message}
                        <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                )}
                {errorMessage && (
                    <div className="alert alert-danger alert-dismissible fade show" role="alert">
                        {errorMessage}
                        <button type="button" className="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                )}

                <div className="order-detail">
                    <h2>
                        주문번호 (<strong>{order.orderNumber}</strong>) <span>주문 현황</span>
                    </h2>
                    <p><strong>주문자 ID:</strong> {order.employeeNumber}</p>
                    <p><strong>신청일자:</strong> {order.orderDateFormatted}</p>
                    <p>
                        <strong>주문 상황:</strong>
                        <span className={`status ${order.state}`}>
                            {getStatusLabel(order.state)}
                        </span>
                    </p>
                    <p><strong>출발지:</strong> {order.deliveryAddress}</p>
                    <p><strong>도착지:</strong> {order.shippingAddress}</p>

                    <table className="order-table">
                        <thead>
                        <tr>
                            <th>식별코드</th>
                            <th>카테고리</th>
                            <th>자재명</th>
                            <th>모델명</th>
                            <th>신청 수량</th>
                        </tr>
                        </thead>
                        <tbody>
                        {orderDetails.map((detail, index) => (
                            <tr
                                key={index}
                                onClick={() => openProductDetail(detail.productId)}
                                style={{ cursor: 'pointer' }}
                            >
                                <td>{detail.productId}</td>
                                <td>{detail.category}</td>
                                <td>{detail.productName}</td>
                                <td>{detail.modelName}</td>
                                <td>{detail.quantity}</td>
                            </tr>
                        ))}
                        </tbody>
                    </table>

                    <div className="order-actions">
                        {order.state === 'SHIPPING' && (
                            <button className="btn btn-success" onClick={() => handleShowModal('deliver')}>
                                배송 완료
                            </button>
                        )}
                    </div>
                </div>
            </div>

            {showModal && (
                <div
                    style={{
                        position: 'fixed',
                        top: '50%',
                        left: '50%',
                        transform: 'translate(-50%, -50%)',
                        border: '1px solid #ccc',
                        borderRadius: '8px',
                        background: '#fff',
                        width: '400px',
                        boxShadow: '0 2px 10px rgba(0,0,0,0.2)',
                        zIndex: 9999,
                        padding: '1rem',
                    }}
                >
                    {/* 모달 헤더 */}
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <h5 style={{ margin: 0 }}>확인</h5>
                        <button
                            type="button"
                            className="btn-close"
                            onClick={() => setShowModal(false)}
                        ></button>
                    </div>

                    {/* 모달 바디 */}
                    <div style={{ marginTop: '1rem' }}>
                        <p>정말 배송 완료 처리하시겠습니까?</p>
                    </div>

                    {/* 모달 푸터 */}
                    <div style={{ marginTop: '1rem', textAlign: 'right' }}>
                        <button
                            type="button"
                            className="btn btn-primary"
                            onClick={handleConfirmAction}
                            style={{ marginRight: '0.5rem' }}
                        >
                            확인
                        </button>
                        <button
                            type="button"
                            className="btn btn-secondary"
                            onClick={() => setShowModal(false)}
                        >
                            취소
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}

export default OrderDetail;


