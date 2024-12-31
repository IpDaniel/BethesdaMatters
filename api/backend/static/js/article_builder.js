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
        <textarea name="elements[${elementCount}][caption]" placeholder="Enter image caption" required></textarea>
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

// Fetch authors when the page loads
fetch('/writers/author_ids', {
    method: 'GET'
})
.then(response => response.json())
.then(data => {
    authors = data;
    initializeAuthorSelects();
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