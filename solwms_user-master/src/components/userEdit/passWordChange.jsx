import { useEffect, useState } from 'react';
import './passWordChange.css';
import { passwordChangeapi } from "./passWordChangeApi.js";
import { useNavigate } from "react-router-dom";

function PassWordChange() {
    const navigate = useNavigate();
    const [id, setId] = useState("");
    const [newPassword, setNewPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [error, setError] = useState("");

    useEffect(() => {
        setId(sessionStorage.getItem("ID"));
    }, []);

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (newPassword !== confirmPassword) {
            setError("비밀번호가 일치하지 않습니다.");
            return;
        }
        setError("");
        const result = await passwordChangeapi(newPassword);
        if (result) {
            alert("비밀번호가 성공적으로 변경되었습니다.");
            navigate("/adminMain", { replace: true });
        } else {
            setError(result.error || "비밀번호 변경에 실패했습니다.");
        }
    };

    return (
        <div className="main-content">
            <form method="post" onSubmit={handleSubmit}>
                <table>
                    <tbody>
                    <tr>
                        <td className="label">본인 사번</td>
                        <td>{id}</td>
                    </tr>
                    <tr>
                        <td className="label">새 비밀번호</td>
                        <td><input type="password" name="newPassword" id="newPassword" value={newPassword} onChange={(e) => setNewPassword(e.target.value)} required /></td>
                    </tr>
                    <tr>
                        <td className="label">새 비밀번호 확인</td>
                        <td><input type="password" name="confirmPassword" id="confirmPassword" value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)} required /></td>
                    </tr>
                    {error && (
                        <tr>
                            <td colSpan="2" className="error">{error}</td>
                        </tr>
                    )}
                    <tr>
                        <td colSpan="2" align="center">
                            <input type="submit" value="비밀번호 변경" className="submit-button" />
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form>
        </div>
    );
}

export default PassWordChange;