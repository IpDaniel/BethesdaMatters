from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from flask import render_template
from backend.db_connection import db

writers = Blueprint('writers', __name__)

@writers.route('/write_article')
def writers_page():
    return render_template('write_article.html')

