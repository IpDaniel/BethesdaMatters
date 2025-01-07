let isLoading = false;
let page = 1;
let hasMoreArticles = true;

function createArticleCard(article) {
    return `
        <article class="article-card" data-article-id="${article.id}" data-priority-score="${article.priority_score}">
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
            <div class="article-actions">
                <div class="action-group">
                    <a href="/writers/edit-article/${article.id}" class="btn btn-edit">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <a href="/articles/${article.id}" class="btn btn-view" target="_blank">
                        <i class="fas fa-external-link-alt"></i> View
                    </a>
                </div>
                <div class="priority-controls">
                    <button class="btn btn-priority" onclick="movePriority(${article.id}, 'up')">
                        <i class="fas fa-arrow-up"></i>
                    </button>
                    <button class="btn btn-priority" onclick="movePriority(${article.id}, 'down')">
                        <i class="fas fa-arrow-down"></i>
                    </button>
                </div>
            </div>
        </article>
    `;
}

function loadMoreArticles() {
    if (isLoading || !hasMoreArticles) return;
    
    isLoading = true;
    
    // Get the lowest priority score from all loaded articles
    const allArticles = document.querySelectorAll('.article-card');
    let priorPriorityScore = 100;
    if (allArticles.length > 0) {
        priorPriorityScore = Math.min(...Array.from(allArticles).map(article => 
            parseFloat(article.dataset.priorityScore)
        ));
    }
    
    const package = {
        prior_priority_score: priorPriorityScore,
        number_requested: 10
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
        
        hasMoreArticles = data.has_more;
        
        if (!hasMoreArticles) {
            const articlesList = document.querySelector('.articles-list');
            articlesList.insertAdjacentHTML('beforeend', `
                <div class="no-more-articles">
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

async function movePriority(articleId, direction) {
    const articleCard = document.querySelector(`.article-card[data-article-id="${articleId}"]`);
    if (!articleCard) return;

    const currentPriority = parseFloat(articleCard.dataset.priorityScore);
    
    // Find the adjacent article based on direction
    const allArticles = Array.from(document.querySelectorAll('.article-card'));
    const currentIndex = allArticles.indexOf(articleCard);
    
    const adjacentArticle = direction === 'up' 
        ? allArticles[currentIndex - 1]  // previous article
        : allArticles[currentIndex + 1]; // next article
    
    if (!adjacentArticle) return; // No article to swap with
    
    const adjacentId = parseInt(adjacentArticle.dataset.articleId);
    const adjacentPriority = parseFloat(adjacentArticle.dataset.priorityScore);

    try {
        const endpoint = direction === 'up' 
            ? `/writers/increase-priority/${articleId}`
            : `/writers/lower-priority/${articleId}`;
            
        const response = await fetch(endpoint, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                this_article_priority: currentPriority,
                [`next_${direction === 'up' ? 'highest' : 'lowest'}_article_id`]: adjacentId,
                [`next_${direction === 'up' ? 'highest' : 'lowest'}_article_priority`]: adjacentPriority
            })
        });

        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.error || 'Failed to update priority');
        }

        // Swap the articles in the DOM
        const parent = articleCard.parentNode;
        if (direction === 'up') {
            parent.insertBefore(articleCard, adjacentArticle);
        } else {
            parent.insertBefore(adjacentArticle, articleCard);
        }

        // Update the priority scores in the dataset
        articleCard.dataset.priorityScore = adjacentPriority;
        adjacentArticle.dataset.priorityScore = currentPriority;

    } catch (error) {
        alert(`Error: ${error.message}`);
        console.error('Error updating priority:', error);
    }
}

// Load initial articles when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadMoreArticles();
});

// Detect when user scrolls near bottom
window.addEventListener('scroll', () => {
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 1000) {
        loadMoreArticles();
    }
});