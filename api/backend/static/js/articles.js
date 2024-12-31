async function loadArticles() {
    try {
        // Fetch articles from your API endpoint
        const response = await fetch('/featured-articles');
        const articles = await response.json();

        // Split articles into main, side, and row articles
        const [mainArticle, ...otherArticles] = articles;
        const sideArticles = otherArticles.slice(0, 2);
        const rowArticles = otherArticles.slice(2, 5);

        // Populate main article
        document.querySelector('.articles-grid .featured-article:not(.side-article)').innerHTML = `
            <div class="article-image-container">
                <img src="${mainArticle.imageUrl}" alt="${mainArticle.imageAlt}">
            </div>
            <h2><a href="/articles/${mainArticle.id}">${mainArticle.title}</a></h2>
            <div class="article-meta">
                <span>By <a href="#">${mainArticle.author}</a></span>
                <span>Published ${mainArticle.date}</span>
                <span>${mainArticle.readTime}</span>
            </div>
            <p>${mainArticle.excerpt}</p>
            <a href="/articles/${mainArticle.id}" class="read-more">Read More →</a>
        `;

        // Populate side articles
        const sideArticlesHTML = sideArticles.map(article => `
            <article class="featured-article side-article">
                <div class="article-image-container">
                    <img src="${article.imageUrl}" alt="${article.imageAlt}">
                </div>
                <h2><a href="/articles/${article.id}">${article.title}</a></h2>
                <div class="article-meta">
                    <span>By <a href="#">${article.author}</a></span>
                    <span>${article.date}</span>
                </div>
                <p>${article.excerpt}</p>
            </article>
        `).join('');
        document.querySelector('.side-articles').innerHTML = sideArticlesHTML;

        // Populate row articles
        const rowArticlesHTML = rowArticles.map(article => `
            <article class="featured-article row-article">
                <div class="article-image-container">
                    <img src="${article.imageUrl}" alt="${article.imageAlt}">
                </div>
                <h2><a href="/articles/${article.id}">${article.title}</a></h2>
                <div class="article-meta">
                    <span>By <a href="#">${article.author}</a></span>
                    <span>${article.date}</span>
                </div>
                <p>${article.excerpt}</p>
            </article>
        `).join('');
        document.querySelector('.articles-row').innerHTML = rowArticlesHTML;

    } catch (error) {
        console.error('Error loading articles:', error);
    }
}

// Load articles when the page loads
document.addEventListener('DOMContentLoaded', loadArticles); 