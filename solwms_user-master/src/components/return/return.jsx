import React, { useState, useEffect } from 'react';
import { fetchReturnHistory, submitReturnData } from "./returnApi.js"; // API 호출 함수

import "./return.css"

let popupRef = null; // ✅ 전역 변수로 팝업 창 참조

const Return = () => {
    const [employeeNumber, setEmployeeNumber] = useState('');
    const [productName, setProductName] = useState('');
    const [productId, setProductId] = useState('');
    const [returnQuantity, setReturnQuantity] = useState('');
    const [returnWareHouseNumber, setReturnWareHouseNumber] = useState('');
    const [returnReason, setReturnReason] = useState('');
    const [returnHistoryList, setReturnHistoryList] = useState([]);
    const [paginatedHistory, setPaginatedHistory] = useState([]);
    const [totalPages, setTotalPages] = useState(1);
    const [currentPage, setCurrentPage] = useState(1);
    const [loading, setLoading] = useState(true);
    const [loggedInUser, setLoggedInUser] = useState('');
    const [originWarehouseNumber, setOriginWarehouseNumber] = useState('');
    const [warehouseNumber, setWarehouseNumber] = useState('');
    const [detail, setDetail] = useState('');
    const [modelName, setModelName] = useState('');
    const [category, setCategory] = useState('');
    const [quantity,setQuantity] = useState('');
    const [wareName,setWareName] =useState('');

    const itemsPerPage = 10;

    // ✅ 반납 내역 가져오기 (API 요청)
    useEffect(() => {
        const getData = async () => {
            setLoading(true);
            try {
                const data = await fetchReturnHistory();
                if (data) {
                    setLoggedInUser(data.loggedInUser);
                    setEmployeeNumber(data.employeeNumber);
                    setReturnHistoryList(data.returnHistoryList || []);
                    setTotalPages(Math.ceil(data.returnHistoryList.length / itemsPerPage));
                    setCurrentPage(1);
                }
            } catch (error) {
                console.error("데이터 로드 실패:", error);
            } finally {
                setLoading(false);
            }
        };
        getData();
    }, []);

    // ✅ 페이지 변경 시 데이터 갱신
    useEffect(() => {
        paginateHistory();
    }, [currentPage, returnHistoryList]);

    // ✅ 페이징 처리
    const paginateHistory = () => {
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        setPaginatedHistory(returnHistoryList.slice(startIndex, endIndex));
    };

    // ✅ 페이지 변경 처리
    const handlePageChange = (page) => {
        if (page >= 1 && page <= totalPages) {
            setCurrentPage(page);
        }
    };

    // ✅ 반납 폼 제출 처리
    const handleSubmit = async (event) => {
        event.preventDefault();
        console.log("🚀 현재 수량:", quantity);
        console.log("🚀 반납 수량:", returnQuantity);
        if (!productName || !returnQuantity || !returnWareHouseNumber || !returnReason) {
            alert("모든 필드를 입력하세요.");
            return;

        }
        else if (parseInt(returnQuantity) > parseInt(quantity)){
            alert ("현재 수량보다 반납수량이 많습니다 \n 현재수량 " +quantity+"개"+"\n 반납수량 "+returnQuantity+"개");
            return;
        }

        const returnData = {
            employeeNumber:loggedInUser,
            productName,
            productId,
            returnQuantity,
            OriginwarehouseNumber:originWarehouseNumber, // 🔥 팝업에서 가져온 창고번호 반영
            returnWareHouseNumber,
            returnReason,
            detail, // 🔥 팝업에서 가져온 상세 정보 반영
            modelName, // 🔥 팝업에서 가져온 모델명 반영
            category, // 🔥 팝업에서 가져온 카테고리 반영
            warehouseNumber: originWarehouseNumber,
            quantity,
        };

        console.log("🚀 전송할 데이터:", returnData);
        try {
            await submitReturnData(returnData);
            alert("반납이 완료되었습니다.");
            console.log()

            // ✅ 반납 내역 다시 불러오기
            const updatedData = await fetchReturnHistory();
            setReturnHistoryList(updatedData.returnHistoryList || []);
            setTotalPages(Math.ceil(updatedData.returnHistoryList.length / itemsPerPage));
            setCurrentPage(1);
        } catch (error) {
            console.error("반납 실패:", error);
            alert("반납 처리 중 오류가 발생했습니다.");
        }
    };

    // 페이지 열기
    const openProductSearchPopup = () => {
        const popupUrl = '/return/search';
        const popupOptions = 'width=1100,height=800';

        if (popupRef && !popupRef.closed) {
            // ✅ 이미 열린 경우, 기존 창을 앞으로 가져오기
            popupRef.focus();
        } else {
            // ✅ 새로운 창 열기
            popupRef = window.open(popupUrl, '_blank', popupOptions);
            if (popupRef) {
                popupRef.focus();
            }
        }
    };

    // ✅ 팝업에서 선택된 데이터 수신
    useEffect(() => {
        const receiveMessage = (event) => {
            if (event.origin !== window.location.origin) return; // 보안 처리
            if (event.data && event.data.product_name && event.data.product_id) {
                setProductName(event.data.product_name);
                setProductId(event.data.product_id);
                setOriginWarehouseNumber(event.data.warehouseNumber); // ✅ 창고번호 설정
                setWarehouseNumber(event.data.warehouseNumber); // ✅ 같은 값으로 업데이트
                setDetail(event.data.detail); // ✅ 상세 정보 설정
                setModelName(event.data.model_name); // ✅ 모델명 설정
                setCategory(event.data.category); // ✅ 카테고리 설정
                setQuantity(event.data.quantity);
            }
        };

        window.addEventListener("message", receiveMessage);
        return () => window.removeEventListener("message", receiveMessage);
    }, []);

    if (loading) {
        return <div>Loading...</div>;
    }

    return (
            <div className="inner-wrapper" style={{ paddingTop: "200px" }}>
             <div className="return-main">
                    <form id="returnForm" onSubmit={handleSubmit} className="form-container">
                        <h2>기자재 반납</h2>
                        <div className="form-group">
                            <label htmlFor="employeeNumber">신청인</label>
                            <input type="text" id="employeeNumber" className="form-control" value={loggedInUser} readOnly />
                        </div>

                        <div className="form-group">
                            <label htmlFor="productName">자재명</label>
                            <input type="text" id="productName" className="form-control" value={productName} readOnly placeholder='검색을 통해 자재명 입력'/>
                        </div>
                        <div>
                            <button type="button" onClick={openProductSearchPopup} className="btn-search">검색</button>
                        </div>

                        <div className="form-group">
                            <label htmlFor="productId">제품번호</label>
                            <input type="text" id="productId" className="form-control" value={productId} readOnly placeholder='검색을 통해 제품번호 입력' />
                        </div>

                        <div className="form-group">
                            <label htmlFor="returnQuantity">반납 수량</label>
                            <input type="number" id="returnQuantity" className="form-control" value={returnQuantity} onChange={(e) => setReturnQuantity(e.target.value)} required placeholder='반납 수량 입력' />
                        </div>

                        <div className="form-group">
                            <label htmlFor="returnWareHouseNumber">반납 위치</label>
                            <select id="returnWareHouseNumber" className="form-control" value={returnWareHouseNumber} onChange={(e) => setReturnWareHouseNumber(e.target.value)} required>
                                <option value="">창고 위치 선택</option>
                                <option value="20">관리자 창고</option>
                                {/* <option value="2">예비물류센터</option>/ */}
                            </select>
                        </div>

                        <div className="form-group">
                            <label htmlFor="returnReason">반납 사유</label>
                            <input type="text" id="returnReason" className="form-control" value={returnReason} onChange={(e) => setReturnReason(e.target.value)} placeholder="반납 사유 입력" />
                        </div>

                        <div>
                            <button type="submit" className="button">반납</button>
                        </div>
                    </form>

                    <h2>반납 기록</h2>
                    <table className="table">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>사원 번호</th>
                                <th>제품 ID</th>
                                <th>제품명</th>
                                <th>반납 수량</th>
                                <th>기존 창고 위치</th>
                                <th>반납 창고 위치</th>
                                <th>반납 사유</th>
                                <th>반납 날짜</th>
                            </tr>
                        </thead>
                        <tbody>
                            {paginatedHistory.map((history, index) => (
                                <tr key={index}>
                                    <td>{(currentPage - 1) * itemsPerPage + index + 1}</td>
                                    <td>{history.employeeNumber}</td>
                                    <td>{history.product_id}</td>
                                    <td>{history.product_name}</td>
                                    <td>{history.returnQuantity}</td>
                                    <td>{history.wareName}</td>
                                    <td>관리자 창고</td>
                                    <td>{history.returnReason}</td>
                                    <td>{new Date(history.returnDate).toLocaleDateString('ko-KR', {
                                        year: 'numeric',
                                        month: 'long',
                                        day: 'numeric'
                                    })}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    <div className="pagination">
                        {/* 이전, 다음 버튼이 5개 이상의 페이지일 때만 보이도록 */}
                        {totalPages >= 5 && (
                            <>
                                <button disabled={currentPage === 1} onClick={() => handlePageChange(currentPage - 1)}>이전</button>
                                <button disabled={currentPage === totalPages} onClick={() => handlePageChange(currentPage + 1)}>다음</button>
                            </>
                        )}
                        {/* 페이지 번호는 항상 보이도록 */}
                        {[...Array(totalPages)].map((_, index) => (
                            <button
                                key={index + 1}
                                onClick={() => handlePageChange(index + 1)}
                                className={currentPage === index + 1 ? "active" : ""}
                            >
                                {index + 1}
                            </button>
                        ))}
                    </div>    
                </div> 
            </div>
        
    );
    
};

export default Return;
