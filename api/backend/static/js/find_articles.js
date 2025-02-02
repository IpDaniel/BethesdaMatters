let isLoading = false;
let page = 1;
let hasMoreArticles = true;

function getUrlParameter(name) {
    const params = new URLSearchParams(window.location.search);
    return params.get(name);
}

function createArticleCard(article) {
    return `
        <a href="/articles/${article.id}" class="article-card-link">
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
        </a>
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
        method: 'GET',
        credentials: 'include'
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
    
    const searchText = document.querySelector('.search-bar').value;
    const selectedGenres = Array.from(document.querySelectorAll('#genre-checkboxes input:checked')).map(cb => cb.value);
    const selectedAuthors = Array.from(document.querySelectorAll('#author-checkboxes input:checked')).map(cb => parseInt(cb.value));
    
    const package = {
        constraints: {
            genre_matches: selectedGenres.length > 0 ? selectedGenres : null,
            author_id_matches: selectedAuthors.length > 0 ? selectedAuthors : null,
            text_contains: searchText ? searchText.split(' ').filter(word => word.length > 0) : null
        },
        prior_priority_score: 100,
        number_requested: 2,
        page: 1
    };

    const params = new URLSearchParams();
    params.append('package', JSON.stringify(package));

    fetch(`/articles/metadata/search-order?${params.toString()}`, {
        method: 'GET',
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        const articlesList = document.querySelector('.articles-list');
        articlesList.innerHTML = '';
        if (data.articles && data.articles.length > 0) {
            data.articles.forEach(article => {
                articlesList.insertAdjacentHTML('beforeend', createArticleCard(article));
            });
            hasMoreArticles = data.has_more;
        } else {
            articlesList.innerHTML = '<div class="no-articles">No articles found</div>';
            hasMoreArticles = false;
        }
        page++;
    })
    .catch(() => {
        document.querySelector('.articles-list').innerHTML = '<div>Error loading articles</div>';
    });
}

function loadAuthors() {
    fetch('/writers/author-ids', {
        method: 'GET',
        credentials: 'include'
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
        method: 'GET',
        credentials: 'include'
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
    // Get URL parameters first
    const genreParam = getUrlParameter('genre');
    const authorParam = getUrlParameter('author');

    // Show filters if we have any parameters
    if (genreParam || authorParam) {
        const filterControls = document.querySelector('.filter-controls');
        filterControls.style.display = 'block';
        filterControls.classList.add('visible');
    }

    // Create a promise-based function to load and set genres
    const setupGenres = () => {
        return new Promise((resolve) => {
            loadGenres();
            if (genreParam) {
                setTimeout(() => {
                    const genreCheckboxes = document.querySelectorAll('#genre-checkboxes input[type="checkbox"]');
                    genreCheckboxes.forEach(checkbox => {
                        if (checkbox.value === genreParam) {
                            checkbox.checked = true;
                        }
                    });
                    resolve();
                }, 500);
            } else {
                resolve();
            }
        });
    };

    // Create a promise-based function to load and set authors
    const setupAuthors = () => {
        return new Promise((resolve) => {
            loadAuthors();
            if (authorParam) {
                setTimeout(() => {
                    const authorCheckboxes = document.querySelectorAll('#author-checkboxes input[type="checkbox"]');
                    authorCheckboxes.forEach(checkbox => {
                        if (checkbox.value === authorParam) {
                            checkbox.checked = true;
                        }
                    });
                    resolve();
                }, 500);
            } else {
                resolve();
            }
        });
    };

    // Wait for both setups to complete before loading articles
    Promise.all([setupGenres(), setupAuthors()]).then(() => {
        if (genreParam || authorParam) {
            hasMoreArticles = true;
            page = 1;
            document.querySelector('.articles-list').innerHTML = '';
            loadMoreArticles();
        } else {
            page = 1;
            loadInitialArticles();
        }
    });

    // Add manual search button handler
    document.querySelector('.search-button').addEventListener('click', () => {
        hasMoreArticles = true;
        page = 1;
        document.querySelector('.articles-list').innerHTML = '';
        loadMoreArticles();
    });

    // Add filter toggle functionality
    const filtersToggle = document.querySelector('.filters-toggle');
    const filterControls = document.querySelector('.filter-controls');
    
    filtersToggle.addEventListener('click', () => {
        filterControls.classList.toggle('visible');
        if (filterControls.classList.contains('visible')) {
            filterControls.style.display = 'block';
        } else {
            filterControls.style.display = 'none';
        }
    });
});