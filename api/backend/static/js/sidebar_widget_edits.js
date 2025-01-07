document.addEventListener('DOMContentLoaded', function() {
    const widgetList = document.querySelector('.widget-list');
    const addWidgetBtn = document.getElementById('add-widget-btn');
    let nextNewId = 100; // Starting ID for new widgets
    let widgetTypes = []; // Will store available widget types

    // Modified to return a promise
    function loadWidgetTypes() {
        return fetch('/sidebar/get-widget-types')
            .then(response => response.json())
            .then(types => {
                widgetTypes = types;
                return types;
            })
            .catch(error => {
                console.error('Error loading widget types:', error);
                return [];
            });
    }

    // Modified to wait for widget types
    function loadWidgets() {
        fetch('/sidebar/get-sidebar-widgets')
            .then(response => response.json())
            .then(widgets => {
                widgetList.innerHTML = ''; // Clear existing widgets
                
                // Check if widgets array is empty
                if (!widgets || widgets.length === 0) {
                    const emptyMessage = document.createElement('div');
                    emptyMessage.className = 'empty-widgets-message';
                    emptyMessage.innerHTML = `
                        <p>No widgets found. Click the "Add New Widget" button below to create one!</p>
                    `;
                    widgetList.appendChild(emptyMessage);
                    return;
                }

                // If we have widgets, display them
                widgets.forEach(widget => {
                    const widgetElement = document.createElement('div');
                    widgetElement.className = 'widget-card';
                    widgetElement.dataset.id = widget.id;
                    
                    // Create dropdown options from widgetTypes
                    const typeOptions = widgetTypes.map(type => 
                        `<option value="${type}" ${type === widget.widget_type ? 'selected' : ''}>${type}</option>`
                    ).join('');
                    
                    widgetElement.innerHTML = `
                        <div class="widget-content">
                            <h3>${widget.title}</h3>
                            <p class="widget-type">Type: ${widget.widget_type}</p>
                            <p>${widget.content}</p>
                        </div>
                        <div class="widget-edit-form hidden">
                            <select class="widget-type-select">
                                ${typeOptions}
                            </select>
                            <input type="text" class="widget-title-input" value="${widget.title}">
                            <textarea class="widget-content-input">${widget.content}</textarea>
                            <div class="edit-buttons">
                                <button class="save-btn">Save</button>
                                <button class="cancel-btn">Cancel</button>
                            </div>
                        </div>
                        <div class="widget-actions">
                            <button class="edit-btn">Edit</button>
                            <button class="delete-btn">Delete</button>
                        </div>
                    `;
                    
                    widgetList.appendChild(widgetElement);
                });
            })
            .catch(error => {
                console.error('Error loading widgets:', error);
                // Add error message to the UI
                widgetList.innerHTML = `
                    <div class="error-message">
                        <p>Error loading widgets. Please try refreshing the page.</p>
                    </div>
                `;
            });
    }

    // Initialize the page: load types first, then widgets
    loadWidgetTypes()
        .then(() => {
            loadWidgets();
        });

    // Handle edit button clicks
    widgetList.addEventListener('click', function(e) {
        if (e.target.classList.contains('edit-btn')) {
            const card = e.target.closest('.widget-card');
            const content = card.querySelector('.widget-content');
            const form = card.querySelector('.widget-edit-form');
            
            content.style.display = 'none';
            form.classList.remove('hidden');
            e.target.style.display = 'none';
        }
        
        if (e.target.classList.contains('cancel-btn')) {
            const card = e.target.closest('.widget-card');
            cancelEdit(card);
        }
        
        if (e.target.classList.contains('save-btn')) {
            const card = e.target.closest('.widget-card');
            saveWidget(card);
        }
        
        if (e.target.classList.contains('delete-btn')) {
            const card = e.target.closest('.widget-card');
            const widgetId = card.dataset.id;
            
            if (confirm('Are you sure you want to delete this widget?')) {
                deleteWidget(widgetId, card);
            }
        }
    });

    // Add new widget
    addWidgetBtn.addEventListener('click', function() {
        const newWidget = createNewWidget();
        widgetList.appendChild(newWidget);
    });

    function createNewWidget() {
        const widget = document.createElement('div');
        widget.className = 'widget-card';
        widget.dataset.id = nextNewId++;
        
        widget.innerHTML = `
            <div class="widget-content" style="display: none;">
                <h3>New Widget</h3>
                <p class="widget-type">Type: Not selected</p>
                <p>New widget content</p>
            </div>
            <div class="widget-edit-form">
                <select class="widget-type-select" required>
                    <option value="">Select a type...</option>
                    ${widgetTypes.map(type => 
                        `<option value="${type}">${type}</option>`
                    ).join('')}
                </select>
                <input type="text" class="widget-title-input" value="New Widget">
                <textarea class="widget-content-input">New widget content</textarea>
                <div class="edit-buttons">
                    <button class="save-btn">Save</button>
                    <button class="cancel-btn">Cancel</button>
                </div>
            </div>
            <button class="edit-btn" style="display: none;">Edit</button>
        `;
        
        return widget;
    }

    function saveWidget(card) {
        const widgetId = card.dataset.id;
        const titleInput = card.querySelector('.widget-title-input');
        const contentInput = card.querySelector('.widget-content-input');
        const typeSelect = card.querySelector('.widget-type-select');
        const content = card.querySelector('.widget-content');
        
        // Validate widget type is selected for new widgets
        if (!typeSelect.value) {
            alert('Please select a widget type');
            return;
        }

        // Update the visible content
        content.querySelector('h3').textContent = titleInput.value;
        content.querySelector('.widget-type').textContent = `Type: ${typeSelect.value}`;
        content.querySelector('p:last-child').textContent = contentInput.value;
        
        // Prepare the data for the API
        const data = {
            title: titleInput.value,
            content: contentInput.value,
            widget_type: typeSelect.value
        };
        
        // If it's a new widget (ID >= 100), use POST, otherwise PUT
        const isNew = widgetId >= 100;
        const method = isNew ? 'POST' : 'PUT';
        const url = isNew 
            ? '/sidebar/create-sidebar-widget'
            : `/sidebar/update-sidebar-widget/${widgetId}`;
            
        fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(data => {
            if (isNew && data.id) {
                card.dataset.id = data.id; // Update the card's ID with the new one from the server
            }
            // Show the updated content and hide the form
            content.style.display = 'block';
            card.querySelector('.widget-edit-form').classList.add('hidden');
            card.querySelector('.edit-btn').style.display = 'block';
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to save widget. Please try again.');
        });
    }

    function cancelEdit(card) {
        const content = card.querySelector('.widget-content');
        const form = card.querySelector('.widget-edit-form');
        const editBtn = card.querySelector('.edit-btn');
        
        // If this is a new widget that hasn't been saved yet, remove it
        if (card.dataset.id >= 100 && content.style.display === 'none') {
            card.remove();
            return;
        }
        
        // Otherwise just hide the form and show the content
        content.style.display = 'block';
        form.classList.add('hidden');
        editBtn.style.display = 'block';
    }

    function deleteWidget(widgetId, card) {
        // Don't try to delete from server if it's a new, unsaved widget
        if (widgetId >= 100) {
            card.remove();
            return;
        }

        fetch(`/sidebar/delete-sidebar-widget/${widgetId}`, {
            method: 'DELETE'
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            card.remove();
            
            // Check if there are any widgets left
            if (widgetList.children.length === 0) {
                const emptyMessage = document.createElement('div');
                emptyMessage.className = 'empty-widgets-message';
                emptyMessage.innerHTML = `
                    <p>No widgets found. Click the "Add New Widget" button below to create one!</p>
                `;
                widgetList.appendChild(emptyMessage);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to delete widget. Please try again.');
        });
    }
});