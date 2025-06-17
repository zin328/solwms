import {useEffect, useState} from 'react';
import './userInfo.css';
import {userInfoApi} from "./userInfoApi.js";

function UserInfoPage() {
    const [userInfo, setuserInfo] = useState([]);
    const [wareName, setwareName] = useState("");
    const [loading, setLoading] = useState(false);


    useEffect(() => {
        setLoading(true);
        userInfoApi().then(data => {
            if (data) {
                setuserInfo(data.userInfo);
                setwareName(data.wareName);
            } else {
                setuserInfo([]);
                setwareName("");
            }
            setLoading(false);
        });
    }, []);


    return (
        <div className="main-content">
            <h1>회원 정보</h1>

            {loading ? <div>로딩 중...</div> : (
                <table className="user-info-table">
                    <tbody>
                    <tr>
                        <td className="info">이름</td>
                        <td className="data">{userInfo.user_name}</td>
                    </tr>

                    <tr>
                        <td className="info">사번</td>
                        <td className="data">{userInfo.employeeNumber}</td>
                    </tr>
                    <tr>
                        <td className="info">번호</td>
                        <td className="data">{userInfo.phone}</td>
                    </tr>
                    <tr>
                        <td className="info">주소</td>
                        <td className="data">{userInfo.address}</td>
                    </tr>
                    <tr>
                        <td className="info">창고 이름</td>
                        <td className="data">{wareName}</td>
                    </tr>
                    <tr>
                        <td className="info">권한</td>
                        <td className="data">{userInfo.role}</td>
                    </tr>
                    </tbody>
                </table>
            )}


        </div>
    );
}
export default UserInfoPage;
