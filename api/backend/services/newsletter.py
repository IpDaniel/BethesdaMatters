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
    
    try:
        # Generate a random unsubscribe token
        unsubscribe_token = secrets.token_urlsafe(48)
        
        # Insert the new subscriber
        cursor = db.cursor()
        cursor.execute(
            """INSERT INTO newsletter_subscribers (email, unsubscribe_token)
               VALUES (%s, %s)""",
            (email, unsubscribe_token)
        )
        db.commit()
        cursor.close()
        
        return jsonify({'message': 'Email added to newsletter list'}), 200
    except Exception as e:
        # Handle duplicate email error
        if 'Duplicate entry' in str(e):
            return jsonify({'error': 'Email already subscribed'}), 400
        return jsonify({'error': 'Failed to add email'}), 500

@newsletter.route('/get-newsletter-recipients', methods=['GET'])
@login_required
def get_recipients():
    cursor = db.cursor()
    cursor.execute("SELECT email FROM newsletter_subscribers")
    recipients = cursor.fetchall()
    cursor.close()
    return jsonify(recipients), 200
