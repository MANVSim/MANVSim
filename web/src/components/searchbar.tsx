import { useState } from 'react';
import { BaseDataStripped } from '../types';

import "./searchbar.css"

interface SearchableDropdownProps {
    data: BaseDataStripped[];
    className: string
    onAddItem: (item: BaseDataStripped) => void;  // Function to handle adding new items
}

const SearchableDropdown: React.FC<SearchableDropdownProps> = ({ data, className = '', onAddItem }) => {
    const [searchInput, setSearchInput] = useState('');
    const [filteredSuggestions, setFilteredSuggestions] = useState<BaseDataStripped[]>([]);
    const [showSuggestions, setShowSuggestions] = useState(false);
    // Handle input change
    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>): void => {
        const input = e.target.value;
        setSearchInput(input);

        if (input.length >= 0) {
            const filtered = data.filter((item) =>
                item.name.toLowerCase().includes(input.toLowerCase())
            );
            setFilteredSuggestions(filtered);
            setShowSuggestions(true);
        } else {
            setShowSuggestions(false);
        }
    };

    // Handle input focus
    const handleInputFocus = (): void => {
        if (searchInput.length === 0) {
            setFilteredSuggestions(data);
            setShowSuggestions(true);
        }
    };

    // Handle input blur
    const handleInputBlur = (): void => {
        // Add a small delay to allow for click event on suggestions before hiding the dropdown
        setTimeout(() => {
            setShowSuggestions(false);
        }, 100);
    };

    return (
        <div className={`searchable-dropdown ${className}`}>
            <div className='d-flex'>
                <input
                    type="text"
                    value={searchInput}
                    onChange={handleInputChange}
                    onFocus={handleInputFocus} // Show all suggestions on first click with no input
                    onBlur={handleInputBlur} // Hide suggestions when input loses focus
                    placeholder="Search..."
                    className="form-control search-input"
                />
            </div>

            {showSuggestions && filteredSuggestions.length > 0 && (
                <ul className="list-group suggestions-list bg-white rounded mt-2">
                    {filteredSuggestions.map((suggestion) => (
                        <div className='d-flex w-100 mt-1'>
                            <li
                                key={suggestion.id}
                                className="suggestion-item w-100 ps-2"
                            >
                                {suggestion.name}
                            </li>
                            <button type="button" onClick={() => onAddItem(suggestion)} className="ms-3 me-2 btn btn-primary btn-sm">+</button>
                        </div>
                    ))}
                </ul>
            )}
        </div>
    );
};

export default SearchableDropdown;