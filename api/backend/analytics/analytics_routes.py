from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

analytics = Blueprint('analytics', __name__)

#------------------------------------------------------------
# Get analytics/trends for interview topics, companies, and roles
@analytics.route('/analytics', methods=['GET'])
def get_trends():
    raise NotImplementedError("not implemented")
