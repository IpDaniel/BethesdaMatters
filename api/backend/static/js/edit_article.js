console.log('edit_article.js loaded');

let elementCount = 0;
let authors = [];

// Load the article data when the page loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOMContentLoaded event fired');
    const articleId = document.getElementById('articleId').value;
    console.log('Article ID:', articleId);
    
    // First fetch authors, then fetch article data
    fetch('/writers/author-ids', {
        method: 'GET'
    })
    .then(response => {
        console.log('Author response received:', response.status);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Author data received:', data);
        authors = data;
        
        // Now fetch article data
        return fetch(`/articles/edit-article/${articleId}`, {
            method: 'GET'
        });
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Article data received:', data); // Debug log
        
        // Populate form fields
        document.getElementById('title').value = data.title;
        document.getElementById('mainImage').value = data.cover_image;
        document.getElementById('mainImageCaption').value = data.cover_image_caption;
        document.getElementById('summary').value = data.summary;
        
        // Clear existing content elements
        document.getElementById('articleElements').innerHTML = '';
        
        // Add each content element
        data.content.forEach(element => {
            if (element.type === 'text') {
                addTextElement(element.value);
            } else if (element.type === 'image') {
                addImageElement(element.url, element.caption);
            }
        });

        // Store the article's current genres for later use
        window.articleGenres = data.genre_tags || [];
        
        // Initialize author selects with the current authors
        initializeAuthorSelects(data.author_ids || []);
        
        // Fetch and populate genre options
        return fetch('/writers/genre-tag-options', {
            method: 'GET'
        });
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(genres => {
        console.log('Genre data received:', genres); // Debug log
        const genreOptionsContainer = document.querySelector('.genre-options');
        console.log('Genre container found:', genreOptionsContainer); // Debug log
        genreOptionsContainer.innerHTML = createGenreOptions(genres);
        console.log('Genre HTML created:', genreOptionsContainer.innerHTML); // Debug log
        
        // Check the genres that were previously selected
        if (window.articleGenres) {
            console.log('Applying genres:', window.articleGenres); // Debug log
            window.articleGenres.forEach(genre => {
                const checkbox = document.querySelector(`input[value="${genre}"]`);
                if (checkbox) {
                    checkbox.checked = true;
                } else {
                    console.warn(`No checkbox found for genre: ${genre}`); // Debug log
                }
            });
        }
    })
    .catch(error => {
        console.error('Detailed error:', error); // More detailed error logging
        alert(`Error loading article data: ${error.message}`);
    });
});

// Keep all the same functions from article_builder.js but modify these:

function addTextElement(value = '') {
    const container = document.createElement('div');
    container.className = 'element-container';
    container.innerHTML = `
        <textarea name="elements[${elementCount}][content]" placeholder="Enter text content" required>${value}</textarea>
        <input type="hidden" name="elements[${elementCount}][type]" value="text">
        <input type="hidden" name="elements[${elementCount}][order]" value="${elementCount}">
        <div class="element-controls">
            <button type="button" class="control-button" onclick="moveUp(this)">Move Up</button>
            <button type="button" class="control-button" onclick="moveDown(this)">Move Down</button>
            <button type="button" class="control-button" onclick="removeElement(this)">Remove</button>
        </div>
    `;
    document.getElementById('articleElements').appendChild(container);
    elementCount++;
}

function addImageElement(url = '', caption = '') {
    const container = document.createElement('div');
    container.className = 'element-container';
    container.innerHTML = `
        <input type="url" name="elements[${elementCount}][image_url]" placeholder="Enter image URL" required value="${url}">
        <textarea name="elements[${elementCount}][caption]" placeholder="Enter image caption">${caption}</textarea>
        <input type="hidden" name="elements[${elementCount}][type]" value="image">
        <input type="hidden" name="elements[${elementCount}][order]" value="${elementCount}">
        <div class="element-controls">
            <button type="button" class="control-button" onclick="moveUp(this)">Move Up</button>
            <button type="button" class="control-button" onclick="moveDown(this)">Move Down</button>
            <button type="button" class="control-button" onclick="removeElement(this)">Remove</button>
        </div>
    `;
    document.getElementById('articleElements').appendChild(container);
    elementCount++;
}

// Add this function to create the genre options HTML
function createGenreOptions(genres) {
    return genres.map(genre => `
        <div class="genre-option">
            <input type="checkbox" id="${genre.toLowerCase().replace(/\s+/g, '')}" 
                   name="genres" value="${genre}">
            <label for="${genre.toLowerCase().replace(/\s+/g, '')}">${genre}</label>
        </div>
    `).join('');
}

// Modify the form submit handler
document.getElementById('articleForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const articleId = document.getElementById('articleId').value;
    
    // Validate required fields
    const title = document.getElementById('title').value.trim();
    const coverImage = document.getElementById('mainImage').value.trim();
    const coverImageCaption = document.getElementById('mainImageCaption').value.trim() || '';
    const summary = document.getElementById('summary').value.trim();
    
    // Check basic fields
    if (!title || !coverImage || !summary) {
        alert('Please fill in all required fields (Title, Cover Image, and Summary)');
        return;
    }

    // Check genres
    const genreCheckboxes = document.querySelectorAll('input[name="genres"]:checked');
    if (genreCheckboxes.length === 0) {
        alert('Please select at least one genre');
        return;
    }
    const genres = Array.from(genreCheckboxes).map(cb => cb.value);
    
    // Check authors
    const authorSelects = document.querySelectorAll('[id^="author"]');
    const authorIds = Array.from(authorSelects)
        .map(select => parseInt(select.value))
        .filter(id => !isNaN(id));
    
    if (authorIds.length === 0) {
        alert('Please select at least one author');
        return;
    }
    
    // Check content elements
    const contentElements = document.querySelectorAll('.element-container');
    if (contentElements.length === 0) {
        alert('Please add at least one content element (text or image)');
        return;
    }

    // Validate each content element
    let isValid = true;
    contentElements.forEach(container => {
        const type = container.querySelector('input[name$="[type]"]').value;
        if (type === 'text') {
            const textContent = container.querySelector('textarea').value.trim();
            if (!textContent) {
                alert('Please fill in all text content areas');
                isValid = false;
            }
        } else if (type === 'image') {
            const imageUrl = container.querySelector('input[type="url"]').value.trim();
            if (!imageUrl) {
                alert('Please provide URL for all images');
                isValid = false;
            }
        }
    });

    if (!isValid) return;
    
    // Get content elements
    const contentElementsArray = Array.from(contentElements)
        .sort((a, b) => {
            return parseInt(a.querySelector('input[name$="[order]"]').value) - 
                   parseInt(b.querySelector('input[name$="[order]"]').value);
        })
        .map(container => {
            const type = container.querySelector('input[name$="[type]"]').value;
            if (type === 'text') {
                return {
                    type: 'text',
                    value: container.querySelector('textarea').value
                };
            } else {
                return {
                    type: 'image',
                    url: container.querySelector('input[type="url"]').value,
                    caption: container.querySelector('textarea').value.trim() || ''
                };
            }
        });

    // Create the payload
    const payload = {
        title,
        cover_image: coverImage,
        cover_image_caption: coverImageCaption,
        summary,
        genre_tags: genres,
        author_ids: authorIds,
        content: contentElementsArray
    };

    // Send the update request
    fetch(`/articles/update-article/${articleId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload)
    })
    .then(response => response.json())
    .then(data => {
        if (data.article_id) {
            // Redirect to the updated article
            window.location.href = `/articles/${data.article_id}`;
        } else {
            alert('Error updating article: ' + data.error);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error updating article. Please try again.');
    });
});

function createAuthorSelect(index, selectedAuthorId = null) {
    return `
        <div class="form-group author-select">
            <label for="author${index}">Author ${index + 1}</label>
            <select name="authors[${index}]" id="author${index}" required>
                <option value="">Select an author</option>
                ${authors.map(author => 
                    `<option value="${author.id}" ${author.id === selectedAuthorId ? 'selected' : ''}>
                        ${author.Name}
                    </option>`
                ).join('')}
            </select>
            ${index > 0 ? `<button type="button" class="control-button" onclick="removeAuthorSelect(this)">Remove</button>` : ''}
        </div>
    `;
}

function removeAuthorSelect(button) {
    const container = button.closest('.author-select');
    container.remove();
    
    // Show the "Add Co-Author" button if we're below 3 authors
    const currentSelects = document.querySelectorAll('.author-select');
    if (currentSelects.length < 3) {
        document.getElementById('addAuthorBtn').style.display = '';
    }
    
    // Update the remaining author labels
    currentSelects.forEach((select, index) => {
        select.querySelector('label').textContent = `Author ${index + 1}`;
    });
    
    // Rerun validation to update disabled options
    setupAuthorSelectionValidation();
}

function initializeAuthorSelects(selectedAuthorIds = []) {
    const authorsContainer = document.getElementById('authorSelects');
    
    authorsContainer.innerHTML = `
        <div class="form-group">
            <label>Article Authors (Select up to 3)</label>
            <div id="authorSelectsInner">
                ${selectedAuthorIds.map((authorId, index) => 
                    createAuthorSelect(index, authorId)
                ).join('')}
            </div>
            <button type="button" class="control-button" onclick="addAuthorSelect()" id="addAuthorBtn">
                Add Co-Author
            </button>
        </div>
    `;

    // If no authors were selected, add one empty select
    if (selectedAuthorIds.length === 0) {
        document.getElementById('authorSelectsInner').innerHTML = createAuthorSelect(0);
    }

    // Hide the "Add Co-Author" button if we already have 3 authors
    if (selectedAuthorIds.length >= 3) {
        document.getElementById('addAuthorBtn').style.display = 'none';
    }

    setupAuthorSelectionValidation();
}

// Add this function to handle author selection validation
function setupAuthorSelectionValidation() {
    const selects = document.querySelectorAll('[id^="author"]');
    selects.forEach(select => {
        select.addEventListener('change', function() {
            const selectedValue = this.value;
            
            // Reset all options in all selects
            selects.forEach(otherSelect => {
                Array.from(otherSelect.options).forEach(option => {
                    option.disabled = false;
                });
            });
            
            // Disable selected values in other selects
            selects.forEach(otherSelect => {
                if (otherSelect !== this && otherSelect.value) {
                    const selectedInOther = otherSelect.value;
                    Array.from(this.options).forEach(option => {
                        if (option.value === selectedInOther) {
                            option.disabled = true;
                        }
                    });
                }
            });
        });
    });
}

function removeElement(button) {
    button.closest('.element-container').remove();
    updateOrder();
}

function moveUp(button) {
    const container = button.closest('.element-container');
    const previous = container.previousElementSibling;
    if (previous) {
        container.parentNode.insertBefore(container, previous);
        updateOrder();
    }
}

function moveDown(button) {
    const container = button.closest('.element-container');
    const next = container.nextElementSibling;
    if (next) {
        container.parentNode.insertBefore(next, container);
        updateOrder();
    }
}

function updateOrder() {
    const elements = document.querySelectorAll('.element-container');
    elements.forEach((element, index) => {
        element.querySelector('input[name$="[order]"]').value = index;
    });
}

function addAuthorSelect() {
    const container = document.getElementById('authorSelectsInner');
    const currentSelects = container.querySelectorAll('.author-select');
    
    if (currentSelects.length < 3) {
        container.insertAdjacentHTML('beforeend', createAuthorSelect(currentSelects.length));
        
        if (currentSelects.length + 1 >= 3) {
            document.getElementById('addAuthorBtn').style.display = 'none';
        }
        
        setupAuthorSelectionValidation();
    }
}