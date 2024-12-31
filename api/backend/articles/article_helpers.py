from flask import current_app
from backend.db_connection import db

def get_featured_articles():
    """
    Fetches the 6 articles with highest priority scores from the database.
    Returns a list of article dictionaries with required fields for the featured articles view.
    """
    query = """
        SELECT 
            a.id,
            a.title,
            a.image_url,
            a.summary,
            a.created_at,
            CONCAT(au.first_name, ' ', au.last_name) as author_name
        FROM articles a
        LEFT JOIN article_authors aa ON a.id = aa.article_id
        LEFT JOIN authors au ON aa.author_id = au.id
        ORDER BY a.priority_score DESC
        LIMIT 6
    """
    
    articles = []
    try:
        connection = db.get_db()
        cursor = connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        
        if not results:
            current_app.logger.warning("No articles found in database")
            return []
            
        for row in results:
            articles.append({
                "id": str(row['id']),
                "title": row['title'],
                "imageUrl": row['image_url'],
                "excerpt": row['summary'],
                "author": row['author_name'] or 'Anonymous',
                "date": row['created_at'].strftime("%B %d, %Y"),
                "readTime": "5 min read",
                "imageAlt": row['title']
            })
        
        cursor.close()
        return articles
    except Exception as e:
        current_app.logger.error(f"Error fetching featured articles: {str(e)}")
        return []

def text_content_crop(article_id, character_limit=None):
    """
    Returns a string containing the first N characters from an article's text content,
    where N is the character_limit. If no limit is specified, returns all text content.
    """
    query = """
        SELECT text_content
        FROM article_elements
        WHERE article_id = %s 
        AND element_type = 'text'
        ORDER BY ordering_index
    """
    
    try:
        connection = db.get_db()
        cursor = connection.cursor()
        cursor.execute(query, (article_id,))
        results = cursor.fetchall()
        cursor.close()
        
        if not results:
            return ""
            
        # Concatenate all text blocks
        full_text = " ".join(row['text_content'] for row in results)
        
        # If no character limit specified or text is shorter than limit,
        # return the full text
        if not character_limit or len(full_text) <= character_limit:
            return full_text
            
        # Find the last space before the character limit to avoid cutting words
        cropped_text = full_text[:character_limit]
        last_space = cropped_text.rfind(' ')
        
        return cropped_text[:last_space] + "..."
        
    except Exception as e:
        current_app.logger.error(f"Error cropping text content for article {article_id}: {str(e)}")
        return ""
