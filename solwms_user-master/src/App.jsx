import './App.css';
import MainRoute from './components/MainRoute';
import { useEffect, useState } from 'react';
import { username } from './api.js';

function App() {
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const data = await username();
                if (data == null) {
                    window.location.href = 'http://localhost:8081/logout';
                } else {
                    sessionStorage.setItem('ID', data.id);
                    sessionStorage.setItem('name', data.name);
                    setLoading(false);
                }
            } catch (error) {
                console.error('Error fetching data:', error);
                window.location.href = 'http://localhost:8081/logout';
            }
        };

        fetchData();

    }, []);

    if (loading) {
        return <div>로딩 중...</div>;
    }

    return <MainRoute />;
}

export default App;