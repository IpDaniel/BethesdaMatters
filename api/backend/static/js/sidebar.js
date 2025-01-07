document.addEventListener('DOMContentLoaded', function() {
    loadSidebarWidgets();
});

async function loadSidebarWidgets() {
    try {
        const response = await fetch('/sidebar/get-sidebar-widgets');
        const widgets = await response.json();
        
        const widgetsContainer = document.getElementById('dynamic-sidebar-widgets');
        
        if (!widgets || widgets.length === 0) {
            widgetsContainer.innerHTML = ''; // Clear any existing content
            return;
        }

        const widgetsHTML = widgets.map(widget => `
            <div class="sidebar-item">
                <div class="sidebar-item-content">
                    <h4>${widget.title}</h4>
                    ${formatWidgetContent(widget.content)}
                </div>
            </div>
        `).join('');

        widgetsContainer.innerHTML = widgetsHTML;
    } catch (error) {
        console.error('Error loading sidebar widgets:', error);
    }
}

function formatWidgetContent(content) {
    // Split content by newlines and wrap each line in a <p> tag
    return content.split('\n')
        .filter(line => line.trim() !== '') // Remove empty lines
        .map(line => `<p>${line}</p>`)
        .join('');
}