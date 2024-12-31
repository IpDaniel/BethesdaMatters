from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from flask import render_template
from backend.db_connection import db
from backend.articles.article_helpers import text_content_crop, get_featured_articles
from datetime import datetime

articles = Blueprint('articles', __name__)

from flask import render_template

@articles.route('/<article_id>')
def article(article_id):
    query = """
        SELECT 
            a.id,
            a.title,
            a.image_url as cover_image,
            a.created_at,
            CONCAT(au.first_name, ' ', au.last_name) as author_name
        FROM articles a
        LEFT JOIN article_authors aa ON a.id = aa.article_id
        LEFT JOIN authors au ON aa.author_id = au.id
        WHERE a.id = %s
    """

    content_query = """
        SELECT 
            element_type as type,
            text_content as value,
            image_url as url,
            image_url as alt,
            text_content as caption
        FROM article_elements
        WHERE article_id = %s
        ORDER BY ordering_index
    """

    try:
        connection = db.get_db()
        cursor = connection.cursor()
        
        # Fetch main article data
        cursor.execute(query, (article_id,))
        article_result = cursor.fetchone()
        
        if not article_result:
            return jsonify({'error': 'Article not found'}), 404
            
        # Fetch article content elements
        cursor.execute(content_query, (article_id,))
        content_elements = cursor.fetchall()
        
        # Format the content elements
        formatted_content = []
        for element in content_elements:
            if element['type'] == 'text':
                formatted_content.append({
                    'type': 'text',
                    'value': element['value']
                })
            elif element['type'] == 'image':
                formatted_content.append({
                    'type': 'image',
                    'url': element['url'],
                    'alt': element['alt'],
                    'caption': element['caption']
                })

        article_data = {
            'title': article_result['title'],
            'cover_image': article_result['cover_image'],
            'cover_image_caption': article_result['title'],  # You might want to add this as a column in your database
            'author': article_result['author_name'] or 'Anonymous',
            'date': article_result['created_at'].strftime("%B %d, %Y"),
            'read_time': '5',  # You might want to calculate this based on content length
            'content': formatted_content
        }

        cursor.close()
        return render_template('article.html', article=article_data), 200
        
    except Exception as e:
        current_app.logger.error(f"Error fetching article {article_id}: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500


@articles.route('/featured-articles')
def featured_articles():
    featured_articles_data = [
        {
            "id": "1",
            "title": "Breaking News: Local Community Center Receives Major Renovation Grant",
            "author": "Sarah Johnson",
            "date": "March 15, 2024",
            "readTime": "5 min read",
            "excerpt": "The Bethesda Community Center has been awarded a $2 million grant for renovations and expansion...",
            "imageUrl": "https://www.ymcadc.org/wp-content/uploads/2022/06/YMCA-BCC-scaled.jpg",
            "imageAlt": "Community Center Renovation"
        }
    ]
    featured_articles_data = get_featured_articles()
    featured_articles_data[0]['excerpt'] = text_content_crop(featured_articles_data[0]['id'], 600)
    return jsonify(featured_articles_data), 200