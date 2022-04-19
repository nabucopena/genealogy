import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import useSWR from 'swr';

const root = ReactDOM.createRoot(document.getElementById('root'));
const API = "http://localhost:9292"
const fetcher = (path) => fetch(`${API}${path}`).then(res => res.json());

function Profile () {
  const [searchName, setSearchName] = React.useState("")
  const [searchLastName, setSearchLastName] = React.useState("")
  let searchParams = [
    searchName ? 'name=' + encodeURIComponent(searchName) : '',
    searchLastName ? 'lastname=' + encodeURIComponent(searchLastName) : ''
  ].filter(x => x.length > 0).join('&');
  const {error, data} = useSWR(`/find_people?${searchParams}`, fetcher)

  // render data
  return <div>
    <input value={searchName} onChange={e => setSearchName(e.target.value)} />
    <input value={searchLastName} onChange={e => setSearchLastName(e.target.value)} />
     {error ? `ERROR ${error}}` : data ? JSON.stringify(data) : "cargando"}</div>
}

function Hi(props) {
  return (
    <h1>
      Hi
    </h1>
  );
}

root.render(
  <React.StrictMode>
    <Profile/>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
