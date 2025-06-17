import { useEffect, useState } from 'react';
import { getAllOrders, searchOrders } from './orderApi';
import { useNavigate } from 'react-router-dom';
import "./order.css";

function OrderPage() {
    const navigate = useNavigate();

    const [orders, setOrders] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);

    // 검색 폼 상태
    const [orderNumber, setOrderNumber] = useState('');
    const [employeeNumber, setEmployeeNumber] = useState('');
    const [orderDate, setOrderDate] = useState('');

    const [loading, setLoading] = useState(false);
    const [isSearching, setIsSearching] = useState(false);

    // 주문 목록 불러오기
    useEffect(() => {
        setLoading(true);
        if (isSearching) {
            // 검색 모드일 경우, 검색 API 호출
            searchOrders(orderNumber, employeeNumber, orderDate)
                .then(data => {
                    setOrders(data);
                    setTotalPages(1); // 검색 결과는 페이징 없음
                    setCurrentPage(1);
                })
                .catch(err => console.error(err))
                .finally(() => setLoading(false));
        } else {
            // 일반 모드일 경우, 전체 주문 목록 호출
            getAllOrders(currentPage, 10)
                .then(data => {
                    setOrders(data.orders);
                    setTotalPages(data.totalPages);
                })
                .catch(err => console.error(err))
                .finally(() => setLoading(false));
        }
    }, [currentPage, isSearching]); // isSearching, currentPage가 변경될 때 실행

    // 검색 처리
    const handleSearch = (e) => {
        e.preventDefault();
        setIsSearching(true);
        setCurrentPage(1); // 검색 시 첫 페이지로 이동
    };

    // 전체 목록 보기로 리셋하는 함수
    const handleReset = () => {
        setOrderNumber('');
        setEmployeeNumber('');
        setOrderDate('');
        setIsSearching(false);
        setCurrentPage(1);
    };

    // 페이지 변경 함수
    const handlePageChange = (page) => {
        if (page !== currentPage) {
            setCurrentPage(page);
        }
    };

    return (
        <div className="main">
            <h1>주문 현황</h1>

            {/* 검색 폼 */}
            <form className="search-form" onSubmit={handleSearch}>
                <label>
                    주문번호:
                    <input
                        type="number"
                        value={orderNumber}
                        onChange={e => setOrderNumber(e.target.value)}
                    />
                </label>
                <label>
                    주문 날짜:
                    <input
                        type="date"
                        value={orderDate}
                        onChange={e => setOrderDate(e.target.value)}
                    />
                </label>
                <button type="submit">검색</button>
                {isSearching && (
                    <button type="button" onClick={handleReset}>
                        전체 목록
                    </button>
                )}
            </form>

            {loading ? (
                <div>로딩 중...</div>
            ) : (
                <table className="order-table">
                    <thead>
                    <tr>
                        <th>주문번호</th>
                        <th>사번</th>
                        <th>주문 날짜</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody>
                    {orders.length > 0 ? (
                        orders.map(order => (
                            <tr
                                key={order.orderNumber}
                                onClick={() => navigate(`/orderdetail?orderNumber=${order.orderNumber}`)}
                                style={{ cursor: 'pointer' }}
                            >
                                <td>{order.orderNumber}</td>
                                <td>{order.employeeNumber}</td>
                                <td>{order.orderDateFormatted}</td>
                                <td>
                                    {order.state === 'ORDER_PENDING' && (
                                        <span className="status ORDER_PENDING">주문 대기</span>
                                    )}
                                    {order.state === 'SHIPPING' && (
                                        <span className="status SHIPPING">배송 중</span>
                                    )}
                                    {order.state === 'DELIVERED' && (
                                        <span className="status DELIVERED">배송 완료</span>
                                    )}
                                    {order.state === 'CANCELED' && (
                                        <span className="status CANCELED">주문 취소</span>
                                    )}
                                    {order.state === 'RECEIVED' && (
                                        <span className="status RECEIVED">주문 접수</span>
                                    )}
                                </td>
                            </tr>
                        ))
                    ) : (
                        <tr>
                            <td colSpan={4}>검색 결과가 없습니다.</td>
                        </tr>
                    )}
                    </tbody>
                </table>
            )}

            {/* 전체 목록일 때만 페이징 네비게이션 표시 */}
            {!isSearching && totalPages > 1 && (
                <div className="pagination">
                    {(() => {
                        const pageNum = 5;
                        const begin = Math.floor((currentPage - 1) / pageNum) * pageNum + 1;
                        const end = Math.min(begin + pageNum - 1, totalPages);

                        return (
                            <>
                                {begin > 1 && (
                                    <button onClick={() => handlePageChange(begin - 1)}>
                                        « 이전
                                    </button>
                                )}

                                {Array.from({ length: end - begin + 1 }, (_, i) => begin + i).map(page => (
                                    <button
                                        key={page}
                                        onClick={() => handlePageChange(page)}
                                        className={page === currentPage ? "active" : ""}
                                        disabled={page === currentPage}
                                    >
                                        {page}
                                    </button>
                                ))}

                                {end < totalPages && (
                                    <button onClick={() => handlePageChange(end + 1)}>
                                        다음 »
                                    </button>
                                )}
                            </>
                        );
                    })()}
                </div>
            )}
        </div>
    );
}

export default OrderPage;
