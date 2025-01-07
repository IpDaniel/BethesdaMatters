let elementCount = 0;
let authors = [];

function addTextElement() {
    const container = document.createElement('div');
    container.className = 'element-container';
    container.innerHTML = `
        <textarea name="elements[${elementCount}][content]" placeholder="Enter text content" required></textarea>
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

function addImageElement() {
    const container = document.createElement('div');
    container.className = 'element-container';
    container.innerHTML = `
        <input type="url" name="elements[${elementCount}][image_url]" placeholder="Enter image URL" required>
        <textarea name="elements[${elementCount}][caption]" placeholder="Enter image caption"></textarea>
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

// Add this to your existing page load fetch operations
document.addEventListener('DOMContentLoaded', function() {
    // Existing authors fetch
    fetch('/writers/author-ids', {
        method: 'GET',
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        authors = data;
        initializeAuthorSelects();
    });

    // New genres fetch
    fetch('/writers/genre-tag-options', {
        method: 'GET',
        credentials: 'include'
    })
    .then(response => response.json())
    .then(genres => {
        const genreOptionsContainer = document.querySelector('.genre-options');
        genreOptionsContainer.innerHTML = createGenreOptions(genres);
    })
    .catch(error => {
        console.error('Error fetching genre options:', error);
    });
});

function createAuthorSelect(index) {
    return `
        <div class="form-group author-select">
            <label for="author${index}">Author ${index + 1}</label>
            <select name="authors[${index}]" id="author${index}" required>
                <option value="">Select an author</option>
                ${authors.map(author => 
                    `<option value="${author.id}">${author.Name}</option>`
                ).join('')}
            </select>
            ${index > 0 ? `<button type="button" class="control-button" onclick="removeAuthorSelect(this)">Remove</button>` : ''}
        </div>
    `;
}

function initializeAuthorSelects() {
    // Find or create the authors container
    let authorsContainer = document.getElementById('authorSelects');
    if (!authorsContainer) {
        authorsContainer = document.createElement('div');
        authorsContainer.id = 'authorSelects';
        // Insert it after the genre tags section
        const genreSection = document.querySelector('.genre-options').parentElement;
        genreSection.parentNode.insertBefore(authorsContainer, genreSection.nextSibling);
    }

    // Create the authors section
    authorsContainer.innerHTML = `
        <div class="form-group">
            <label>Article Authors (Select up to 3)</label>
            <div id="authorSelectsInner">
                ${createAuthorSelect(0)}
            </div>
            <button type="button" class="control-button" onclick="addAuthorSelect()" id="addAuthorBtn">
                Add Co-Author
            </button>
        </div>
    `;

    // Add event listeners to handle author selection
    setupAuthorSelectionValidation();
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

document.getElementById('articleForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
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
    
    // If validation passes, create the payload and submit
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
        date: new Date().toLocaleDateString('en-US', { 
            month: 'long',
            day: 'numeric',
            year: 'numeric'
        }),
        genre_tags: genres,
        author_ids: authorIds,
        content: contentElementsArray
    };

    // Send the request
    fetch('/articles/write-article', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify(payload)
    })
    .then(response => response.json())
    .then(data => {
        if (data.article_id) {
            // Redirect to the new article
            window.location.href = `/articles/${data.article_id}`;
        } else {
            alert('Error creating article: ' + data.error);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error creating article. Please try again.');
    });
});