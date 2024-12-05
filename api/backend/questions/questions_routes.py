from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

questions = Blueprint('questions', __name__)

#------------------------------------------------------------
# Get all questions with optional filters for company, role and type
@questions.route('/questions', methods=['GET'])
def get_questions():
    current_app.logger.info('GET /questions route')

    # Get optional filter parameters
    company_id = request.args.get('companyID')
    question_type = request.args.get('questionType')
    user_id = request.args.get('userID')

    cursor = db.get_db().cursor()

    # Build query based on filters
    query = '''SELECT q.questionID, q.questionType as Question_Type, q.companyID as ID_of_company_who_asked, q.userID as ID_of_user_who_added_the_question
               FROM interview_prep_system.Question q'''
    
    conditions = []
    params = []

    if company_id:
        conditions.append('q.companyID = %s')
        params.append(company_id)
    if question_type:
        conditions.append('q.questionType = %s') 
        params.append(question_type)
    if user_id:
        conditions.append('q.userID = %s')
        params.append(user_id)

    if conditions:
        query += ' WHERE ' + ' AND '.join(conditions)

    try:
        cursor.execute(query, tuple(params))
        questions_data = cursor.fetchall()
        
        response = make_response(jsonify(questions_data))
        response.status_code = 200
        return response

    except Exception as e:
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Add a new interview question
@questions.route('/questions', methods=['POST'])
def create_question():
    """ 
    Expects the following JSON body:
    {
        "companyID": int,
        "questionType": string,
        "userID": int
    }
    """
    current_app.logger.info('POST /questions route')
    question_info = request.json

    # Extract question info from request
    company_id = question_info.get('companyID')
    question_type = question_info['questionType']
    user_id = question_info['userID']

    # Insert into Question table
    cursor = db.get_db().cursor()
    query = 'INSERT INTO Question (companyID, questionType, userID) VALUES (%s, %s, %s)'
    data = (company_id, question_type, user_id)
    
    try:
        cursor.execute(query, data)
        db.get_db().commit()
        
        # Return the ID of newly created question
        new_question_id = cursor.lastrowid
        response = make_response(jsonify({"questionID": new_question_id}))
        response.status_code = 201
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Update interview question details
@questions.route('/questions', methods=['PUT'])
def update_question():
    """ 
    Expects the following JSON body:
    {
        "questionID": int,
        "companyID": int,
        "questionType": string,
        "userID": int
    }
    """
    current_app.logger.info('PUT /questions route')
    question_info = request.json
    question_id = question_info['questionID']
    
    # Build update query dynamically based on provided fields
    update_fields = []
    update_values = []
    
    if 'companyID' in question_info:
        update_fields.append('companyID = %s')
        update_values.append(question_info['companyID'])
        
    if 'questionType' in question_info:
        update_fields.append('questionType = %s')
        update_values.append(question_info['questionType'])
        
    if 'userID' in question_info:
        update_fields.append('userID = %s')
        update_values.append(question_info['userID'])
        
    if not update_fields:
        response = make_response(jsonify({"error": "No fields to update"}))
        response.status_code = 400
        return response
        
    # Construct and execute update query
    query = 'UPDATE Question SET ' + ', '.join(update_fields) + ' WHERE questionID = %s'
    update_values.append(question_id)
    
    cursor = db.get_db().cursor()
    try:
        cursor.execute(query, tuple(update_values))
        db.get_db().commit()
        
        response = make_response(jsonify({"message": "Question updated successfully"}))
        response.status_code = 200
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Delete an interview question (Admin only)
@questions.route('/questions/<int:question_id>', methods=['DELETE'])
def delete_question(question_id):
    current_app.logger.info('DELETE /questions/{} route'.format(question_id))
    
    cursor = db.get_db().cursor()
    try:
        # Delete the question with the given ID
        query = 'DELETE FROM Question WHERE questionID = %s'
        cursor.execute(query, (question_id,))
        db.get_db().commit()
        
        if cursor.rowcount == 0:
            # No question was found with this ID
            response = make_response(jsonify({"error": "Question not found"}))
            response.status_code = 404
            return response
            
        response = make_response(jsonify({"message": "Question deleted successfully"}))
        response.status_code = 200
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Get specific question details
@questions.route('/questions/<int:question_id>', methods=['GET'])
def get_question(question_id):
    current_app.logger.info('GET /questions/{} route'.format(question_id))
    
    cursor = db.get_db().cursor()
    try:
        # Get question with the specified ID
        cursor.execute('''SELECT questionID, companyID as ID_of_company_who_asked, questionType as Question_Type, userID as ID_of_user_who_added_the_question
                         FROM Question 
                         WHERE questionID = %s''', (question_id,))
        
        question = cursor.fetchone()
        
        if not question:
            response = make_response(jsonify({"error": "Question not found"}))
            response.status_code = 404
            return response
            
        response = make_response(jsonify(question))
        response.status_code = 200
        return response
        
    except Exception as e:
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

#------------------------------------------------------------
# Edit specific question for typos
@questions.route('/questions/<int:question_id>', methods=['PUT'])
def edit_question(question_id):
    current_app.logger.info('PUT /questions/{} route'.format(question_id))
    
    question_info = request.json
    cursor = db.get_db().cursor()
    
    try:
        # Validate that question exists first
        cursor.execute('SELECT questionID FROM Question WHERE questionID = %s', (question_id,))
        if cursor.fetchone() is None:
            response = make_response(jsonify({"error": "Question not found"}))
            response.status_code = 404
            return response
            
        # Update question information
        query = '''UPDATE Question 
                  SET companyID = %s,
                      questionType = %s,
                      userID = %s
                  WHERE questionID = %s'''
                  
        data = (question_info['companyID'],
                question_info['questionType'],
                question_info['userID'],
                question_id)
                
        cursor.execute(query, data)
        db.get_db().commit()
        
        response = make_response(jsonify({"message": "Question updated successfully"}))
        response.status_code = 200
        return response
        
    except Exception as e:
        db.get_db().rollback()
        response = make_response(jsonify({"error": str(e)}))
        response.status_code = 400
        return response

