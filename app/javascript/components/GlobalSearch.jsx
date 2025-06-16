import React, { useState } from "react";

const GlobalSearch = () => {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState({ trails: [], profiles: [], fandoms: [] });
  const [showResults, setShowResults] = useState(false);

  const handleChange = async (e) => {
    const value = e.target.value;
    setQuery(value);

    if (value.length < 2) {
      setShowResults(false);
      return;
    }

    const response = await fetch(`/search.json?q=${encodeURIComponent(value)}`);
    if (response.ok) {
      const data = await response.json();
      setResults(data);
      setShowResults(true);
    }
  };

  const handleBlur = () => {
    setTimeout(() => setShowResults(false), 200); // Delay to allow click
  };

  return (
    <div className="global-search-react">
      <input
        type="text"
        value={query}
        onChange={handleChange}
        onFocus={() => setShowResults(true)}
        onBlur={handleBlur}
        placeholder="Поиск..."
        className="global-search-input"
      />
      {showResults && (results.trails.length > 0 || results.profiles.length > 0 || results.fandoms.length > 0) && (
        <div className="global-search-results">
          {results.trails.length > 0 && (
            <>
              <h4>Маршруты</h4>
              <ul>
                {results.trails.map(trail => (
                  <li key={`trail-${trail.id}`}>
                    <a href={`/trails/${trail.id}`}>{trail.title}</a>
                  </li>
                ))}
              </ul>
            </>
          )}
          {results.profiles.length > 0 && (
            <>
              <h4>Профили</h4>
              <ul>
                {results.profiles.map(profile => (
                  <li key={`profile-${profile.id}`}>
                    <a href={`/profiles/${profile.id}`}>{profile.nickname}</a>
                  </li>
                ))}
              </ul>
            </>
          )}
          {results.fandoms.length > 0 && (
            <>
              <h4>Фандомы</h4>
              <ul>
                {results.fandoms.map(fandom => (
                  <li key={`fandom-${fandom.id}`}>
                    <a href={`/fandoms/${fandom.id}`}>{fandom.name}</a>
                  </li>
                ))}
              </ul>
            </>
          )}
        </div>
      )}
    </div>
  );
};

export default GlobalSearch;
