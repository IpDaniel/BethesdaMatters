from flask import Blueprint, request, jsonify, render_template, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required
from werkzeug.security import check_password_hash
from ..db_connection import db
from .models import User
from urllib.parse import urlparse, urljoin

auth = Blueprint('auth', __name__)

def is_safe_url(target):
    ref_url = urlparse(request.host_url)
    test_url = urlparse(urljoin(request.host_url, target))
    return test_url.scheme in ('http', 'https') and ref_url.netloc == test_url.netloc

@auth.route('/login', methods=['GET', 'POST'])
def login():
    # Handle GET request - show login page
    if request.method == 'GET':
        next_page = request.args.get('next')
        return render_template('login.html', next=next_page)
    
    # Handle POST request - process login
    data = request.get_json() if request.is_json else request.form
    email = data.get('email')
    password = data.get('password')
    
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM employee_accounts WHERE email = %s', (email,))
    user_data = cursor.fetchone()
    cursor.close()

    if user_data and check_password_hash(user_data['password_hash'], password):
        user = User(
            id=user_data['id'],
            email=user_data['email'],
            role=user_data['role']
        )
        login_user(user)
        
        # Get the next page from form data or args
        next_page = request.form.get('next') or request.args.get('next')
        
        # Validate the next URL to prevent redirect attacks
        if not next_page or not is_safe_url(next_page):
            next_page = url_for('main.index')  # Replace with your default route
            
        return redirect(next_page)
    
    # Handle failed login
    if request.is_json:
        return jsonify({'message': 'Invalid credentials'}), 401
    flash('Invalid email or password')
    return redirect(url_for('auth.login'))

@auth.route('/logout')
@login_required
def logout():
    logout_user()
    return jsonify({'message': 'Logged out successfully'})