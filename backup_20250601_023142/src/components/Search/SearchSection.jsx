import React from 'react';
import { Search, X } from 'lucide-react';

const SearchSection = ({ searchQuery, setSearchQuery, onClearSearch }) => {
  return (
    <div className="search-container">
      <Search className="search-icon" size={20} />
      <input
        type="text"
        placeholder="Search venues, types, or locations..."
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        className="search-input"
      />
      {searchQuery && (
        <button
          onClick={onClearSearch}
          className="clear-search-button"
        >
          <X size={16} />
        </button>
      )}
    </div>
  );
};

export default SearchSection;
