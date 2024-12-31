let elementCount = 0;

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