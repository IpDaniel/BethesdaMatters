from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from flask import render_template
from backend.db_connection import db

navigation = Blueprint('navigation', __name__)

@navigation.route('/', methods=['GET'])
def get_navigation():
    return render_template('index.html')

