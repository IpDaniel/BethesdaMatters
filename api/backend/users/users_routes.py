from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

users = Blueprint('users', __name__)

#------------------------------------------------------------
# Get all users with optional userType filter
@users.route('/users', methods=['GET'])
def get_users():
    current_app.logger.info('GET /users route')
    
    cursor = db.get_db().cursor()
   
    raise NotImplementedError("query not implemented")

    cursor.execute(query)
        
    users_data = cursor.fetchall()
    
    response = make_response(jsonify(users_data))
    response.status_code = 200
    return response

#------------------------------------------------------------
# Register a new user
@users.route('/users', methods=['POST']) 
def create_user():
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Update user profile
@users.route('/users', methods=['PUT'])
def update_user():
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Delete user profile (Admin only)
@users.route('/users', methods=['DELETE'])
def delete_user():
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Get specific user details
@users.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Update specific user details
@users.route('/users/<int:user_id>', methods=['PUT'])
def update_specific_user(user_id):
    raise NotImplementedError("not implemented")
