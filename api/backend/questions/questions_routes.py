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
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Add a new interview question
@questions.route('/questions', methods=['POST'])
def create_question():
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Update interview question details
@questions.route('/questions', methods=['PUT'])
def update_question():
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Delete an interview question (Admin only)
@questions.route('/questions', methods=['DELETE'])
def delete_question():
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Get specific question details
@questions.route('/questions/<int:question_id>', methods=['GET'])
def get_question(question_id):
    raise NotImplementedError("not implemented")

#------------------------------------------------------------
# Edit specific question for typos
@questions.route('/questions/<int:question_id>', methods=['PUT'])
def edit_question(question_id):
    raise NotImplementedError("not implemented")

