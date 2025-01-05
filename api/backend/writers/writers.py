from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from flask import render_template
from backend.db_connection import db

writers = Blueprint('writers', __name__)

@writers.route('/write-article')
def writers_page():
    return render_template('write_article.html')

@writers.route('/author-ids', methods=['GET'])
def author_ids():
    """Route to get all authors and their ids. 
    Returns a list of dictionaries with the following structure:
    [
        {
            "id": 1,
            "Name": "Sarah Johnson"
        },
        {
            "id": 2,
            "Name": "Michael Chen"
        },
        {
            "id": 3,
            "Name": "Emily Rodriguez"
        },
        {
            "id": 4,
            "Name": "David Smith"
        }
    ]
    """
    # Get database connection
    conn = db.get_db()
    cursor = conn.cursor()
    
    # Query to get all authors
    query = "SELECT id, CONCAT(first_name, ' ', last_name) as Name FROM authors"
    cursor.execute(query)
    authors = cursor.fetchall()
    cursor.close()

    # Format the results into the desired structure
    author_list = [{"id": author["id"], "Name": author["Name"]} for author in authors]
    
    return jsonify(author_list)

@writers.route('/edit-article/<int:article_id>', methods=['GET'])
def edit_article(article_id):
    return render_template('edit_article.html', article_id=article_id)

@writers.route('/genre-tag-options', methods=['GET'])
def genre_tag_options():
    """Returns a list of all available genre tags by querying the database schema.
    
    Returns:
        JSON array of strings: ["Local News", "Politics", "Business", "Sports", "Culture", "Opinion"]
    """
    conn = db.get_db()
    cursor = conn.cursor()
    
    # Query to get enum values from the database schema
    query = """
        SELECT SUBSTRING(COLUMN_TYPE, 6, LENGTH(COLUMN_TYPE) - 6) as enum_values
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'bethesda_matters'
        AND TABLE_NAME = 'genre_tags' 
        AND COLUMN_NAME = 'genre'
    """
    
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    
    # Parse the enum string into a list
    # Convert "('Local News','Politics','Business','Sports','Culture','Opinion')" into a list
    enum_string = result['enum_values']
    genres = [genre.strip("'") for genre in enum_string.split(',')]
    
    return jsonify(genres)

