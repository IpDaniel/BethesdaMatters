let elementCount = 0;
let authors = [];

// Load the article data when the page loads
document.addEventListener('DOMContentLoaded', function() {
    const articleId = document.getElementById('articleId').value;
    
    // Fetch article data
    fetch(`/articles/edit-article/${articleId}`, {
        method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
        // Populate form fields
        document.getElementById('title').value = data.title;
        document.getElementById('mainImage').value = data.cover_image;
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
    })
    .catch(error => {
        console.error('Error loading article:', error);
        alert('Error loading article data');
    });
    
    // Fetch authors (keep the same as article_builder.js)
    fetch('/writers/author_ids', {
        method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
        authors = data;
        initializeAuthorSelects();
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
        <textarea name="elements[${elementCount}][caption]" placeholder="Enter image caption" required>${caption}</textarea>
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

// Modify the form submit handler
document.getElementById('articleForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const articleId = document.getElementById('articleId').value;
    
    // Get all form elements (same as article_builder.js)
    const title = document.getElementById('title').value;
    const coverImage = document.getElementById('mainImage').value;
    const coverImageCaption = document.getElementById('mainImageCaption').value;
    const summary = document.getElementById('summary').value;
    
    // Get selected genres
    const genreCheckboxes = document.querySelectorAll('input[name="genres"]:checked');
    const genres = Array.from(genreCheckboxes).map(cb => cb.value);
    
    // Get selected authors
    const authorSelects = document.querySelectorAll('[id^="author"]');
    const authorIds = Array.from(authorSelects)
        .map(select => parseInt(select.value))
        .filter(id => !isNaN(id));
    
    // Get content elements
    const contentElements = Array.from(document.querySelectorAll('.element-container'))
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
                    caption: container.querySelector('textarea').value
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
        content: contentElements
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