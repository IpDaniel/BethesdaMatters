from flask import Flask
from flask_login import LoginManager

from backend.db_connection import db
from backend.companies.companies_routes import companies
from backend.navigation.navigation_routes import navigation
from backend.articles.article import articles
from backend.writers.writers import writers
from backend.services.weather import weather
from backend.auth.routes import auth
from backend.sidebar.sidebar_routes import sidebar
from backend.auth.models import User

import os
from dotenv import load_dotenv
from datetime import timedelta

def create_app():
    app = Flask(__name__)

    # Load environment variables
    # This function reads all the values from inside
    # the .env file (in the parent folder) so they
    # are available in this file.  See the MySQL setup 
    # commands below to see how they're being used.
    load_dotenv()

    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    # app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

    # Add these new session duration settings
    app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=5)  # How long sessions last - Make this 2 hours in practice
    app.config['REMEMBER_COOKIE_DURATION'] = timedelta(minutes=30)    # How long "remember me" lasts - Make this 1 day in practice
    """
    The idea here is that if someone logs in with the remember me option,
    they will be logged in for 1 day And they can close the tab and it wont log them out. 
    If they don't use the remember me option, they will be logged in for 2 hours no matter what.
    """

    # # these are for the DB object to be able to connect to MySQL. 
    # app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_USER'] = os.getenv('DB_USER').strip()
    app.config['MYSQL_DATABASE_PASSWORD'] = os.getenv('MYSQL_ROOT_PASSWORD').strip()
    app.config['MYSQL_DATABASE_HOST'] = os.getenv('DB_HOST').strip()
    app.config['MYSQL_DATABASE_PORT'] = int(os.getenv('DB_PORT').strip())
    app.config['MYSQL_DATABASE_DB'] = os.getenv('DB_NAME').strip()  # Change this to your DB name

    # Initialize the database object with the settings above. 
    app.logger.info('current_app(): starting the database connection')
    db.init_app(app)

    # Initialize Flask-Login
    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'

    @login_manager.user_loader
    def load_user(user_id):
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM employee_accounts WHERE id = %s', (user_id,))
        user_data = cursor.fetchone()
        cursor.close()
        
        if user_data:
            return User(
                id=user_data['id'],
                email=user_data['email'],
                role=user_data['primary_role']
            )
        return None

    # Register the routes from each Blueprint with the app object
    # and give a url prefix to each
    app.logger.info('current_app(): registering blueprints with Flask app object.')   
    app.register_blueprint(companies,   url_prefix='/co')
    app.register_blueprint(navigation)
    app.register_blueprint(articles,  url_prefix='/articles')
    app.register_blueprint(writers,  url_prefix='/writers')
    app.register_blueprint(weather,  url_prefix='/weather')
    app.register_blueprint(auth,  url_prefix='/auth')
    app.register_blueprint(sidebar,  url_prefix='/sidebar')

    # Don't forget to return the app object
    return app