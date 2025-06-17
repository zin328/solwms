import {BrowserRouter, Link, Route, Routes} from "react-router-dom";
import InoutHistory from "./inout/inoutHistory.jsx";
import Return from "./return/return.jsx";
import Search from "./return/search.jsx"; // ✅ 주문 페이지 추가
import Detail from "./return/detail.jsx";
import Main from "./main/Main.jsx";
import StockAll from "./stock/stockall";
import OrderPage from "./stock/orderpage";
import "./MainRoute.css";
import Order from "./order/order.jsx";
import OrderDetail from "./order/orderDetail.jsx";
import Notice from "./notice/notice.jsx";
import NoticeDetail from "./notice/noticeDetail.jsx";
import Suggestion from "./suggestion/suggestion.jsx";
import SuggestionDetail from "./suggestion/suggestionDetail.jsx";
import PassWordChange from "./userEdit/passWordChange.jsx";
import UserInfoPage from "./userEdit/userInfo.jsx";

function MainRoute() {
    const userName = sessionStorage.getItem('name');

    console.log(userName);
    if (userName == null || userName == "undefined") {
        window.location.href = 'http://localhost:8081/logout';
    }
    return (
        <BrowserRouter basename="/"> {/* ✅ basename 설정 추가 */}
            <Routes>

                <Route path="/return/search" element={<Search/>}/>
                <Route path="/order-page" element={<OrderPage/>}/>


                {/* ✅ 기본 레이아웃이 필요한 페이지들 */}
                <Route
                    path="/*"
                    element={
                        <div className="app">
                            <header className="header">
                                <h1><Link to="/adminMain">OH! WMS</Link></h1>
                                <div className="header-links">
                                    <Link to="/passwordChange" className="password-change-link">비밀번호 변경</Link>
                                    <span className="logout-text" onClick={() => {
                                        sessionStorage.clear();
                                        window.location.href = 'http://localhost:8081/logout';
                                    }} style={{cursor: 'pointer'}}>로그아웃</span>
                                </div>
                            </header>
                            <aside className="sidebar">
                                <br/>
                                <br/>

                                <h2>
                                    <Link to="/userInfo">{userName.split(" ").map((word, index) => (
                                    <span key={index}>
                                        {word}
                                        <br/>
                                    </span>
                                ))}
                                    </Link>
                                </h2>
                                <ul>
                                    <li><Link to="/adminMain">메인 화면</Link></li>
                                    <li><Link to="/stock/stockall">재고 확인</Link></li>
                                    <li><Link to="/return">재고 반납</Link></li>
                                    <li><Link to="/order/all">주문현황</Link></li>
                                    <li><Link to="/inoutHistory">입출고내역</Link></li>
                                </ul>
                            </aside>
                            <div className="main-content">
                                <Routes>

                                    <Route path="/" element={<Main/>}/>
                                    <Route path="/adminMain" element={<Main/>}/>
                                    <Route path="/stock/stockall" element={<StockAll/>}/>
                                    <Route path="/order/all" element={<Order/>}/>
                                    <Route path="/return" element={<Return/>}/>
                                    <Route path="/detail/:productId" element={<Detail/>}/>
                                    <Route path="/inoutHistory" element={<InoutHistory/>}/>
                                    <Route path="/orderdetail" element={<OrderDetail/>}/>\
                                    <Route path="/notices" element={<Notice/>}/>
                                    <Route path="/adminMain/announceContent" element={<NoticeDetail/>}/>
                                    <Route path="/suggestion" element={<Suggestion/>}/>
                                    <Route path="/adminMain/suggContent" element={<SuggestionDetail/>}/>
                                    <Route path="/passwordChange" element={<PassWordChange/>}/>
                                    <Route path="/userInfo" element={<UserInfoPage/>}/>
                                </Routes>
                            </div>
                        </div>
                    }
                />
            </Routes>

        </BrowserRouter>
    );
}

export default MainRoute;
