import os
import secrets
import requests
from flask import jsonify, Blueprint, request
from flask_login import login_required
from backend.db_connection import db 

newsletter = Blueprint('newsletter', __name__)

@newsletter.route('/add-recipient-email', methods=['POST'])
def add_email():
    data = request.get_json()
    email = data.get('email')
    if not email:
        return jsonify({'error': 'Email is required'}), 400
    
    cursor = None
    try:
        # Generate a random unsubscribe token
        unsubscribe_token = secrets.token_urlsafe(48)
        
        # Get database connection and cursor
        connection = db.get_db()
        cursor = connection.cursor()
        
        # Insert the new subscriber
        cursor.execute(
            """INSERT INTO newsletter_subscribers (email, unsubscribe_token)
               VALUES (%s, %s)""",
            (email, unsubscribe_token)
        )
        connection.commit()
        return jsonify({'message': 'Email added to newsletter list'}), 200
        
    except Exception as e:
        if connection:
            connection.rollback()
        # Handle duplicate email error
        if 'Duplicate entry' in str(e):
            return jsonify({'error': 'Email already subscribed'}), 400
        return jsonify({'error': 'Failed to add email'}), 500
    finally:
        # Always close the cursor
        if cursor:
            cursor.close()

@newsletter.route('/get-newsletter-recipients', methods=['GET'])
@login_required
def get_recipients():
    connection = db.get_db()
    cursor = connection.cursor()
    cursor.execute("SELECT email FROM newsletter_subscribers")
    recipients = cursor.fetchall()
    cursor.close()
    return str(recipients), 200
