import React from 'react';
import { Search, X } from 'lucide-react';
const SearchBar = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="search-bar-container">
      <div className="search-input-wrapper">
        <Search className="search-icon" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search venues, vibes, or locations..."
          className="search-input"
        />
        {searchQuery && (
          <button
            onClick={onClearSearch}
            className="search-clear"
            title="Clear search"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>
    </div>
  );
};
export default SearchBar;
