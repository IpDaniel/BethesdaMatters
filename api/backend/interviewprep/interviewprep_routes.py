from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

interviewprep = Blueprint('interview-prep', __name__)

#------------------------------------------------------------
# Get all interviewprep from the system 
# TESTED
@interviewprep.route('/interviewprep', methods=['GET'])
def get_interviewpreps():
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT i.interviewPrepID as sessionID, s.userID as studentID, t.UserID as taID, i.QuestionID as questionID, s.date as meetingDate
                        FROM interview_prep_system.Stu_Iprep s
                        JOIN interview_prep_system.Ta_Iprep t on s.interviewPrepID = t.interviewPrepID
                        JOIN interview_prep_system.InterviewPrep i on i.interviewPrepID = s.interviewPrepID
                        ORDER BY sessionID
    ''')
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Add a new interview-prep
# TODO: need to test
@interviewprep.route('/interviewprep', methods=['POST'])
def create_interviewprep():
    current_app.logger.info('POST /interviewprep route')
    interviewprep_info = request.json
    studentID = interviewprep_info['studentID']
    taID = interviewprep_info['taID']
    questionID = interviewprep_info['questionID']
    meetingDate = interviewprep_info['meetingDate']

    cursor = db.get_db().cursor()
    
    # Insert into InterviewPrep table
    query = 'INSERT INTO InterviewPrep (questionID) VALUES (%s)'
    data = (questionID,)
    cursor.execute(query, data)
    
    interviewPrepID = cursor.lastrowid

    # Insert into Stu_Iprep table
    query = 'INSERT INTO Stu_Iprep (interviewPrepID, userID, date) VALUES (%s, %s, %s)'
    data = (interviewPrepID, studentID, meetingDate)
    cursor.execute(query, data)

    # Insert into Ta_Iprep table
    query = 'INSERT INTO Ta_Iprep (interviewPrepID, userID) VALUES (%s, %s)'
    data = (interviewPrepID, taID)
    cursor.execute(query, data)

    db.get_db().commit()
    return 'Interview prep added successfully!'

#------------------------------------------------------------
# Update interview-prep info for specific interviewPrepID
# TODO: need to test
@interviewprep.route('/interviewprep', methods=['PUT'])
def update_interviewprep():
    current_app.logger.info('PUT /interviewprep route')
    interviewprep_info = request.json
    interviewPrepID = interviewprep_info['interviewPrepID']
    studentID = interviewprep_info['studentID']
    taID = interviewprep_info['taID']
    questionID = interviewprep_info['questionID']
    meetingDate = interviewprep_info['meetingDate']

    cursor = db.get_db().cursor()
    
    # Update InterviewPrep table
    query = 'UPDATE InterviewPrep SET questionID = %s WHERE interviewPrepID = %s'
    data = (questionID, interviewPrepID)
    cursor.execute(query, data)

    # Update Stu_Iprep table
    query = 'UPDATE Stu_Iprep SET userID = %s, date = %s WHERE interviewPrepID = %s'
    data = (studentID, meetingDate, interviewPrepID)
    cursor.execute(query, data)

    # Update Ta_Iprep table
    query = 'UPDATE Ta_Iprep SET userID = %s WHERE interviewPrepID = %s'
    data = (taID, interviewPrepID)
    cursor.execute(query, data)

    db.get_db().commit()
    return 'Interview prep updated successfully!'

#------------------------------------------------------------
# Get interview-prep for specific interviewPrepID
# TODO: Need to test ALSO NEED COMFIRMATION OF CHANGING TO /interviewprep/{id}
@interviewprep.route('/interviewprep/<interviewPrepID>', methods=['DELETE'])
def delete_interviewprep(interviewPrepID):
    current_app.logger.info(f'DELETE /interviewprep/{interviewPrepID} route')
    
    cursor = db.get_db().cursor()
    
    # Delete from Stu_Iprep
    delete_stu_query = 'DELETE FROM interview_prep_system.Stu_Iprep WHERE interviewPrepID = %s'
    cursor.execute(delete_stu_query, (interviewPrepID,))
    
    # Delete from Ta_Iprep
    delete_ta_query = 'DELETE FROM interview_prep_system.Ta_Iprep WHERE interviewPrepID = %s'
    cursor.execute(delete_ta_query, (interviewPrepID,))
    
    # Delete from InterviewPrep
    delete_interviewprep_query = 'DELETE FROM interview_prep_system.InterviewPrep WHERE interviewPrepID = %s'
    cursor.execute(delete_interviewprep_query, (interviewPrepID,))
    
    db.get_db().commit()
    return 'Interview prep deleted successfully!'

#------------------------------------------------------------
# Get interview-prep for specific interviewPrepID
# TESTED
@interviewprep.route('/interviewprep/<interviewPrepID>', methods=['GET'])
def get_specific_interviewprep(interviewPrepID):
    current_app.logger.info(f'GET /interviewprep/{interviewPrepID} route')
    
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT i.interviewPrepID as sessionID, s.userID as studentID, t.UserID as taID, i.QuestionID as questionID, s.date as meetingDate
                        FROM interview_prep_system.Stu_Iprep s
                        JOIN interview_prep_system.Ta_Iprep t on s.interviewPrepID = t.interviewPrepID
                        JOIN interview_prep_system.InterviewPrep i on i.interviewPrepID = s.interviewPrepID
                        WHERE i.interviewPrepID = %s
                        ORDER BY sessionID
    ''', (interviewPrepID,))
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get interview-prep for specific studentID
# TESTED
@interviewprep.route('/interviewprep/student/<studentID>', methods=['GET'])
def get_specific_interviewprep_student(studentID):
    current_app.logger.info(f'GET /interviewprep/student/{studentID} route')
    
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT i.interviewPrepID as sessionID, s.userID as studentID, t.UserID as taID, i.QuestionID as questionID, s.date as meetingDate
                        FROM interview_prep_system.Stu_Iprep s
                        JOIN interview_prep_system.Ta_Iprep t on s.interviewPrepID = t.interviewPrepID
                        JOIN interview_prep_system.InterviewPrep i on i.interviewPrepID = s.interviewPrepID
                        WHERE s.userID = %s
                        ORDER BY sessionID
    ''', (studentID,))
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Get interview-prep for specific taID
# TESTED
@interviewprep.route('/interviewprep/ta/<taID>', methods=['GET'])
def get_specific_interviewprep_TA(taID):
    current_app.logger.info(f'GET /interviewprep/ta/{taID} route')
    
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT i.interviewPrepID as sessionID, s.userID as studentID, t.UserID as taID, i.QuestionID as questionID, s.date as meetingDate
                        FROM interview_prep_system.Stu_Iprep s
                        JOIN interview_prep_system.Ta_Iprep t on s.interviewPrepID = t.interviewPrepID
                        JOIN interview_prep_system.InterviewPrep i on i.interviewPrepID = s.interviewPrepID
                        WHERE t.userID = %s
                        ORDER BY sessionID
    ''', (taID,))
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Update interview-prep info for specific interviewPrepID
# TODO: Need to test
@interviewprep.route('/interviewprep/<interviewPrepID>', methods=['PUT'])
def update_specific_interviewprep(interviewPrepID):
    current_app.logger.info('PUT /interviewprep/<interviewPrepID> route')
    interviewprep_info = request.json
    studentID = interviewprep_info['studentID']
    taID = interviewprep_info['taID']
    questionID = interviewprep_info['questionID']
    meetingDate = interviewprep_info['meetingDate']

    cursor = db.get_db().cursor()
    
    # Update InterviewPrep table
    query = 'UPDATE InterviewPrep SET questionID = %s WHERE interviewPrepID = %s'
    data = (questionID, interviewPrepID)
    cursor.execute(query, data)

    # Update Stu_Iprep table
    query = 'UPDATE Stu_Iprep SET userID = %s, date = %s WHERE interviewPrepID = %s'
    data = (studentID, meetingDate, interviewPrepID)
    cursor.execute(query, data)

    # Update Ta_Iprep table
    query = 'UPDATE Ta_Iprep SET userID = %s WHERE interviewPrepID = %s'
    data = (taID, interviewPrepID)
    cursor.execute(query, data)

    db.get_db().commit()
    return 'Interview prep updated successfully!'
