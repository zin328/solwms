import { useEffect, useState } from 'react';
import './inout.css';
import { fetchSearchInoutHistory } from "./inoutApi.js";

function InoutHistory() {
    const [inoutHistoryList, setInoutHistoryList] = useState([]);
    const [pageNum, setPageNum] = useState(1);
    const [totalPages, setTotalPages] = useState(0);
    const [loading, setLoading] = useState(false);
    const [filters, setFilters] = useState({
        category: '',
        date1: '',
        date2: '',
        searchKeyword: '',
        state: ''
    });

    useEffect(() => {
        setLoading(true);
        fetchSearchInoutHistory().then(data => {
            if (data && data.inoutHistoryList) {
                setInoutHistoryList(data.inoutHistoryList);
                setTotalPages(data.totalPages);
            } else {
                setInoutHistoryList([]);
                setTotalPages(0);
            }
            setLoading(false);
        });
    }, []);

    const handleSearch = (e) => {
        e.preventDefault();
        setLoading(true);
        fetchSearchInoutHistory(filters.category, filters.date1, filters.date2, filters.searchKeyword, filters.state, 1)
            .then(data => {
                setInoutHistoryList(data?.inoutHistoryList || []);
                setTotalPages(data?.totalPages || 0);
                setLoading(false);
            });
    };

    const handlePageChange = (newPageNum) => {
        setPageNum(newPageNum);
        setLoading(true);
        fetchSearchInoutHistory(filters.category, filters.date1, filters.date2, filters.searchKeyword, filters.state, newPageNum)
            .then(data => {
                setInoutHistoryList(data?.inoutHistoryList || []);
                setTotalPages(data?.totalPages || 0);
                setLoading(false);
            });
    };

    return (
        <div className="inout-history-wrapper" >
            <div className="inout-content">
                <h2>입출고 내역</h2>
                <form className="search-filters" onSubmit={handleSearch}>
                    <input type="text" placeholder="카테고리" value={filters.category} onChange={(e) => setFilters({ ...filters, category: e.target.value })} />
                    <input type="date" value={filters.date1} onChange={(e) => setFilters({ ...filters, date1: e.target.value })} />
                    <input type="date" value={filters.date2} onChange={(e) => setFilters({ ...filters, date2: e.target.value })} />
                    <input type="text" placeholder="자재/모델명" value={filters.searchKeyword} onChange={(e) => setFilters({ ...filters, searchKeyword: e.target.value })} />
                    <select value={filters.state} onChange={(e) => setFilters({ ...filters, state: e.target.value })}>
                        <option value="">전체</option>
                        <option value="in">입고</option>
                        <option value="out">출고</option>
                    </select>
                    <button type="submit">검색</button>
                </form>

                {loading ? <div>로딩 중...</div> : (
                    <table className="table">
                        <thead>
                        <tr>
                            <th>구분</th>
                            <th>카테고리</th>
                            <th>자재명</th>
                            <th>모델명</th>
                            <th>물류 센터</th>
                            <th>처리 일시</th>
                            <th>입/출고 량</th>
                        </tr>
                        </thead>
                        <tbody>
                        {inoutHistoryList.length > 0 ? (
                            inoutHistoryList.map((history, index) => (
                                <tr key={index}>
                                    <td className={history.state === 'in' ? 'in-state' : 'out-state'} style={{ color: 'white' }} >
                                    {history.state === 'in' ? '입고' : '출고'}
                                    </td>

                                    <td>{history.category}</td>
                                    <td>{history.product_name}</td>
                                    <td>{history.model_name}</td>
                                    <td>{history.wareName}</td>
                                    <td>{new Date(history.date).toLocaleDateString('ko-KR')}</td>
                                    <td>{history.quantity}</td>
                                </tr>
                            ))
                        ) : (
                            <tr>
                                <td colSpan="7">검색 결과가 없습니다.</td>
                            </tr>
                        )}
                        </tbody>
                    </table>
                )}

                <div className="pagination">
                    {[...Array(totalPages).keys()].map(i => (
                        <button key={i} onClick={() => handlePageChange(i + 1)}>{i + 1}</button>
                    ))}
                </div>
            </div>
        </div>
    );
}

export default InoutHistory;
