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

@articles.route('/write-article', methods=['POST'])
def write_article():
    """Inserts a new article into the database
    expecting json with the following structure:
    {
    "title": "How to Build a Modern Web Application",
    "cover_image": "https://example.com/images/web-dev.jpg",
    "cover_image_caption": "A comprehensive guide to building web applications using modern technologies",
    "summary": "A comprehensive guide to building web applications using modern technologies",
    "date": "March 20, 2024",
    "genre_tags": [
        "Technology", 
        "Web Development"
    ],
    "author_ids": [
        2,
        3
    ],
    "content": [
            {
                "type": "text",
                "value": "In this article, we'll explore the fundamental concepts of modern web development..."
            },
            {
                "type": "image",
                "url": "https://example.com/images/architecture-diagram.png",
                "caption": "Typical web application architecture"
            },
            {
                "type": "text",
                "value": "Let's start by examining the frontend components..."
            }
        ]
    }"""
    # try:
    article_data = request.get_json()
    
    # Add debug logging
    current_app.logger.debug(f"Received article data: {article_data}")
    
    # Insert main article record
    article_query = """
        INSERT INTO articles (
            title, 
            image_url, 
            summary,
            content,
            priority_score,
            created_at
        )
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    
    connection = db.get_db()
    cursor = connection.cursor()
    
    # Get the highest priority_score and increment by 1
    cursor.execute("SELECT COALESCE(MAX(priority_score), 0) + 1 as next_score FROM articles")
    next_priority_score = cursor.fetchone()['next_score']
    
    # Add debug logging for content processing
    current_app.logger.debug(f"Processing content elements: {article_data['content']}")
    
    # Combine all text content for the main content field
    full_content = '\n\n'.join(
        element['value'] for element in article_data['content'] 
        if element['type'] == 'text'
    )
    
    # Add debug logging for insert values
    insert_values = (
        article_data['title'],
        article_data['cover_image'],
        article_data.get('summary', ''),
        full_content,
        next_priority_score,
        datetime.strptime(article_data['date'], "%B %d, %Y")
    )
    current_app.logger.debug(f"Inserting article with values: {insert_values}")
    
    cursor.execute(article_query, insert_values)
    
    article_id = cursor.lastrowid
    
    # Insert author relationships
    author_query = """
        INSERT INTO article_authors (article_id, author_id)
        VALUES (%s, %s)
    """
    for author_id in article_data['author_ids']:
        cursor.execute(author_query, (article_id, author_id))
    
    # Insert content elements
    element_query = """
        INSERT INTO article_elements 
        (article_id, element_type, text_content, image_url, ordering_index)
        VALUES (%s, %s, %s, %s, %s)
    """
    
    for index, element in enumerate(article_data['content']):
        if element['type'] == 'text':
            cursor.execute(element_query, (
                article_id,
                'text',
                element['value'],
                None,
                index
            ))
        elif element['type'] == 'image':
            cursor.execute(element_query, (
                article_id,
                'image',
                element['caption'],
                element['url'],
                index
            ))
    
    connection.commit()
    cursor.close()
    
    return jsonify({
        'message': 'Article created successfully',
        'article_id': article_id
    }), 201
        
    # except KeyError as e:
    #     current_app.logger.error(f"Missing required field: {str(e)}")
    #     return jsonify({
    #         'error': f'Missing required field: {str(e)}',
    #         'data_received': article_data
    #     }), 400
    # except Exception as e:
    #     import traceback
    #     error_traceback = traceback.format_exc()
    #     current_app.logger.error(f"Error creating article: {str(e)}\n{error_traceback}")
    #     return jsonify({
    #         'error': 'Internal server error',
    #         'details': str(e),
    #         'traceback': error_traceback
    #     }), 500

