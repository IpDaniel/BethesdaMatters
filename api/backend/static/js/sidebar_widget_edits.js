document.addEventListener('DOMContentLoaded', function() {
    const widgetList = document.querySelector('.widget-list');
    const addWidgetBtn = document.getElementById('add-widget-btn');
    let nextNewId = 100; // Starting ID for new widgets

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
                <p>New widget content</p>
            </div>
            <div class="widget-edit-form">
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
        const content = card.querySelector('.widget-content');
        
        // Update the visible content
        content.querySelector('h3').textContent = titleInput.value;
        content.querySelector('p').textContent = contentInput.value;
        
        // Prepare the data for the API
        const data = {
            title: titleInput.value,
            content: contentInput.value
        };
        
        // If it's a new widget (ID >= 100), use POST, otherwise PUT
        const isNew = widgetId >= 100;
        const method = isNew ? 'POST' : 'PUT';
        const url = isNew 
            ? '/api/sidebar-widgets'
            : `/api/sidebar-widgets/${widgetId}`;
            
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
});