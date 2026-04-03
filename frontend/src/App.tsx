import { NavLink, Route, Routes } from "react-router-dom";
import { SearchPage } from "./pages/SearchPage";
import { OpportunityDetailPage } from "./pages/OpportunityDetailPage";
import { SavedSearchesPage } from "./pages/SavedSearchesPage";

function App() {
  return (
    <div className="shell">
      <header className="shell__header">
        <div>
          <p className="eyebrow">Government Opportunity Intelligence</p>
          <h1>Gov Contract Crawler</h1>
        </div>
        <nav className="shell__nav">
          <NavLink to="/">Search</NavLink>
          <NavLink to="/saved">Saved</NavLink>
        </nav>
      </header>

      <main className="shell__main">
        <Routes>
          <Route path="/" element={<SearchPage />} />
          <Route path="/opportunities/:id" element={<OpportunityDetailPage />} />
          <Route path="/saved" element={<SavedSearchesPage />} />
        </Routes>
      </main>
    </div>
  );
}

export default App;
