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
    current_app.logger.info('GET /analytics route')
    
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT companyID, companyName, location
                      FROM interview_prep_system.Company
    ''')
    
    companies_data = cursor.fetchall()
    
    response = make_response(jsonify(companies_data))
    response.status_code = 200
    return response
    
