let isLoading = false;
let page = 1;
let hasMoreArticles = true;

function createArticleCard(article) {
    return `
        <article class="article-card" data-priority-score="${article.priority_score}">
            <img src="${article.cover_image}" alt="Article image" class="article-image">
            <div class="article-info">
                <h2 class="article-title">${article.title}</h2>
                <div class="article-meta">
                    <span>By ${article.authors.map(a => a.name).join(', ')}</span>
                    <span>${article.published_date}</span>
                    <span>${article.read_time}</span>
                </div>
                <p class="article-description">${article.summary}</p>
            </div>
        </article>
    `;
}

function loadMoreArticles() {
    if (isLoading || !hasMoreArticles) return;
    
    isLoading = true;
    const searchText = document.querySelector('.search-bar').value;
    const selectedGenres = Array.from(document.querySelectorAll('#genre-checkboxes input:checked')).map(cb => cb.value);
    const selectedAuthors = Array.from(document.querySelectorAll('#author-checkboxes input:checked')).map(cb => parseInt(cb.value));
    
    // Get the lowest priority score from all loaded articles
    const allArticles = document.querySelectorAll('.article-card');
    let priorPriorityScore = 100;
    if (allArticles.length > 0) {
        priorPriorityScore = Math.min(...Array.from(allArticles).map(article => 
            parseFloat(article.dataset.priorityScore)
        ));
    }
    
    const package = {
        constraints: {
            genre_matches: selectedGenres.length > 0 ? selectedGenres : null,
            author_id_matches: selectedAuthors.length > 0 ? selectedAuthors : null,
            text_contains: searchText ? searchText.split(' ').filter(word => word.length > 0) : null
        },
        prior_priority_score: priorPriorityScore,
        number_requested: 2
    };

    const params = new URLSearchParams();
    params.append('package', JSON.stringify(package));

    fetch(`/articles/metadata/search-order?${params.toString()}`, {
        method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
        if (data.articles && data.articles.length > 0) {
            const articlesList = document.querySelector('.articles-list');
            data.articles.forEach(article => {
                articlesList.insertAdjacentHTML('beforeend', createArticleCard(article));
            });
        }
        
        // Update hasMoreArticles based on response
        hasMoreArticles = data.has_more;
        
        // Optionally show a message when there are no more articles
        if (!hasMoreArticles) {
            const articlesList = document.querySelector('.articles-list');
            articlesList.insertAdjacentHTML('beforeend', `
                <div class="no-more-articles" style="text-align: center; padding: 20px; color: #666;">
                    No more articles to load
                </div>
            `);
        }
        
        isLoading = false;
    })
    .catch(error => {
        console.error('Error:', error);
        isLoading = false;
    });
}

// Detect when user scrolls near bottom
window.addEventListener('scroll', () => {
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 1000) {
        loadMoreArticles();
    }
});

// Debounce helper function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Add this function to load initial articles
function loadInitialArticles() {
    document.querySelector('.articles-list').innerHTML = '<div>Loading...</div>';
    
    const package = {
        constraints: {
            genre_matches: [],
            author_id_matches: [],
            text_contains: []
        },
        prior_priority_score: 100,
        number_requested: 2,
        page: 1
    };

    // Convert to URL parameters properly
    const params = new URLSearchParams();
    params.append('package', JSON.stringify(package));

    fetch(`/articles/metadata/search-order?${params.toString()}`, {
        method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
        const articlesList = document.querySelector('.articles-list');
        articlesList.innerHTML = '';
        data.articles.forEach(article => {
            articlesList.insertAdjacentHTML('beforeend', createArticleCard(article));
        });
        page++;
    })
    .catch(() => {
        document.querySelector('.articles-list').innerHTML = '<div>Error loading articles</div>';
    });
}

function loadAuthors() {
    fetch('/writers/author-ids', {
        method: 'GET'
    })
    .then(response => response.json())
    .then(authors => {
        const authorCheckboxes = document.querySelector('#author-checkboxes');
        authorCheckboxes.innerHTML = ''; // Clear existing checkboxes
        authors.forEach(author => {
            const label = document.createElement('label');
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.value = author.id;
            label.appendChild(checkbox);
            label.appendChild(document.createTextNode(author.Name));
            authorCheckboxes.appendChild(label);
        });
    })
    .catch(error => {
        console.error('Error loading authors:', error);
    });
}

// Add this new function to load genres
function loadGenres() {
    fetch('/articles/all-genres', {
        method: 'GET'
    })
    .then(response => response.json())
    .then(data => {
        const genreCheckboxes = document.querySelector('#genre-checkboxes');
        genreCheckboxes.innerHTML = ''; // Clear existing checkboxes
        data.genres.forEach(genre => {
            const label = document.createElement('label');
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.value = genre;
            label.appendChild(checkbox);
            label.appendChild(document.createTextNode(genre));
            genreCheckboxes.appendChild(label);
        });
    })
    .catch(error => {
        console.error('Error loading genres:', error);
    });
}

// Modify the DOMContentLoaded event listener to include genre loading
document.addEventListener('DOMContentLoaded', () => {
    // Load genres for the checkboxes
    loadGenres();
    
    // Load authors for the select dropdown
    loadAuthors();
    
    // Initialize the page number
    page = 1;
    // Load initial articles
    loadInitialArticles();
    
    // Add manual search button handler
    document.querySelector('.search-button').addEventListener('click', () => {
        hasMoreArticles = true;
        page = 1;
        document.querySelector('.articles-list').innerHTML = '';
        loadMoreArticles();
    });
    
    // Existing event listeners that you may want to comment out later
    // document.querySelector('.search-bar').addEventListener('input', debounce(() => {
    //     hasMoreArticles = true;
    //     page = 1;
    //     document.querySelector('.articles-list').innerHTML = '';
    //     loadMoreArticles();
    // }, 300));

    // // Update genre checkbox event listeners
    // document.querySelector('#genre-checkboxes').addEventListener('change', () => {
    //     hasMoreArticles = true;
    //     page = 1;
    //     document.querySelector('.articles-list').innerHTML = '';
    //     loadMoreArticles();
    // });

    // // Update author checkbox event listeners
    // document.querySelector('#author-checkboxes').addEventListener('change', () => {
    //     hasMoreArticles = true;
    //     page = 1;
    //     document.querySelector('.articles-list').innerHTML = '';
    //     loadMoreArticles();
    // });
});