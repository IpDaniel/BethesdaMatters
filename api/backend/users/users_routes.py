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

    userType = request.args.get('userType')
    
    cursor = db.get_db().cursor()
   
    if userType:
        query = '''SELECT userID, userName, email, userType 
                   FROM interview_prep_system.User
                   WHERE userType = %s'''
    else:
        query = '''SELECT userID, userName, email, userType 
                   FROM interview_prep_system.User'''

    cursor.execute(query)
        
    users_data = cursor.fetchall()
    
    response = make_response(jsonify(users_data))
    response.status_code = 200
    return response

#------------------------------------------------------------
# Register a new user
@users.route('/users', methods=['POST']) 
def create_user():
    current_app.logger.info('POST /users route')
    user_info = request.json

    # Extract user info from request
    username = user_info['userName']
    email = user_info['email'] 
    user_type = user_info['userType']

    # Insert into User table
    cursor = db.get_db().cursor()
    query = 'INSERT INTO User (userName, email, userType) VALUES (%s, %s, %s)'
    data = (username, email, user_type)
    
    try:
        cursor.execute(query, data)
        db.get_db().commit()
        
        # Return the ID of newly created user
        new_user_id = cursor.lastrowid
        response = make_response(jsonify({"userID": new_user_id}))
        response.status_code = 201
        return response
        
    except Exception as e:
        # Handle errors like duplicate email
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Update user profile
@users.route('/users', methods=['PUT'])
def update_user():
    raise RuntimeError("probably better to use the user-specific route here. If not for whatever reason, go ahead and delete this error.")
    current_app.logger.info('PUT /users route')
    user_info = request.json
    user_id = user_info['userID']
    
    # Build update query dynamically based on provided fields
    update_fields = []
    update_values = []
    
    if 'userName' in user_info:
        update_fields.append('userName = %s')
        update_values.append(user_info['userName'])
        
    if 'email' in user_info:
        update_fields.append('email = %s') 
        update_values.append(user_info['email'])
        
    if 'userType' in user_info:
        update_fields.append('userType = %s')
        update_values.append(user_info['userType'])
        
    if not update_fields:
        response = make_response(jsonify({"error": "No fields to update"}))
        response.status_code = 400
        return response
        
    # Construct and execute update query
    query = 'UPDATE User SET ' + ', '.join(update_fields) + ' WHERE userID = %s'
    update_values.append(user_id)
    
    cursor = db.get_db().cursor()
    try:
        cursor.execute(query, tuple(update_values))
        db.get_db().commit()
        
        response = make_response(jsonify({"message": "User updated successfully"}))
        response.status_code = 200
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Delete user profile (Admin only)
@users.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    current_app.logger.info('DELETE /users/{} route'.format(user_id))
    
    cursor = db.get_db().cursor()
    try:
        # Delete the user with the given ID
        query = 'DELETE FROM User WHERE userID = %s'
        cursor.execute(query, (user_id,))
        db.get_db().commit()
        
        if cursor.rowcount == 0:
            # No user was found with this ID
            response = make_response(jsonify({"error": "User not found"}))
            response.status_code = 404
            return response
            
        response = make_response(jsonify({"message": "User deleted successfully"}))
        response.status_code = 200
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Get specific user details
@users.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    current_app.logger.info('GET /users/{} route'.format(user_id))
    
    cursor = db.get_db().cursor()
    try:
        # Get user with the specified ID
        cursor.execute('''SELECT userID, userName, email, userType 
                         FROM User 
                         WHERE userID = %s''', (user_id,))
        
        user = cursor.fetchone()
        
        if not user:
            response = make_response(jsonify({"error": "User not found"}))
            response.status_code = 404
            return response
            
        response = make_response(jsonify(user))
        response.status_code = 200
        return response
        
    except Exception as e:
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Update specific user details
@users.route('/users/<int:user_id>', methods=['PUT'])
def update_specific_user(user_id):
    current_app.logger.info('PUT /users/{} route'.format(user_id))
    
    user_info = request.json
    cursor = db.get_db().cursor()
    
    try:
        # Validate that user exists first
        cursor.execute('SELECT userID FROM User WHERE userID = %s', (user_id,))
        if cursor.fetchone() is None:
            response = make_response(jsonify({"error": "User not found"}))
            response.status_code = 404
            return response
            
        # Update user information
        query = '''UPDATE User 
                  SET userName = %s,
                      email = %s, 
                      userType = %s
                  WHERE userID = %s'''
                  
        data = (user_info['userName'],
                user_info['email'],
                user_info['userType'],
                user_id)
                
        cursor.execute(query, data)
        db.get_db().commit()
        
        response = make_response(jsonify({"message": "User updated successfully"}))
        response.status_code = 200
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response
