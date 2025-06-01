import React from 'react';
import { Search, X } from 'lucide-react';

const SearchBar = ({ 
  searchQuery, 
  setSearchQuery, 
  onClearSearch,
  placeholder = "Search venues, areas, or vibes..." 
}) => {
  const handleClear = () => {
    setSearchQuery('');
    if (onClearSearch) {
      onClearSearch();
    }
  };

  return (
    <div className="search-bar-container">
      <div className="search-bar">
        <Search className="search-icon" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder={placeholder}
          className="search-input"
        />
        {searchQuery && (
          <button
            onClick={handleClear}
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
