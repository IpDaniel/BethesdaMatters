from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from flask import render_template
from backend.db_connection import db
from flask import redirect, url_for

navigation = Blueprint('navigation', __name__)

@navigation.route('/', methods=['GET'])
def get_navigation():
    return render_template('index.html')

@navigation.route('/find-articles', methods=['GET'])
def get_find_articles():
    return render_template('find_articles.html')

