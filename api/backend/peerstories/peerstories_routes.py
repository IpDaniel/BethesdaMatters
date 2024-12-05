from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

peerstories = Blueprint('peerstories', __name__)

#------------------------------------------------------------
# Get all interviewprep from the system 
# TESTED
@peerstories.route('/peerstories', methods=['GET'])
def get_peerstories():
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT peerStoryID, review, userID, companyID
                        FROM interview_prep_system.PeerStory
    ''')
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Add a new peer story
# TODO: havent completed implementation
@peerstories.route('/peerstories', methods=['POST'])
def create_peerstory():
    current_app.logger.info('POST /peerstories route')
    peerstory_info = request.json
    review = peerstory_info['review']
    userID = peerstory_info['userID']
    companyID = peerstory_info['companyID']

    query = 'INSERT INTO PeerStory (review, userID, companyID) VALUES (%s, %s, %s)'
    data = (review, userID, companyID)
    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()
    return 'peer story added!'

#------------------------------------------------------------
# Update peer story info for specific peerStoryID
# TODO: Need to test
@peerstories.route('/peerstories', methods=['PUT'])
def update_peerstory():
    current_app.logger.info('PUT /peerstories route')
    peerstory_info = request.json
    peerStoryID = peerstory_info['peerStoryID']
    review = peerstory_info['review']
    userID = peerstory_info['userID']
    companyID = peerstory_info['companyID']
    
    cursor = db.get_db().cursor()

    query = 'UPDATE PeerStory SET review = %s, userID = %s, companyID = %s WHERE peerStoryID = %s'
    data = (review, userID, companyID, peerStoryID)
    cursor.execute(query, data)
    db.get_db().commit()
    return 'peer story updated!'
  
#------------------------------------------------------------
# Delete peer story info for specific peerStoryID
# TODO: Need to test ALSO NEED COMFIRMATION OF CHANGING TO /peerstories/{id}
@peerstories.route('/peerstories/<peerStoryID>', methods=['DELETE'])
def delete_peerstory(peerStoryID):
    current_app.logger.info('DELETE /peerstories/{peerStoryID} route')

    cursor = db.get_db().cursor()

    query = 'DELETE FROM PeerStory WHERE peerStoryID = %s'
    data = (peerStoryID)

    cursor.execute(query, data)
    db.get_db().commit()
    return 'peer story deleted!'

#------------------------------------------------------------
# Get peer story info for specific peerStoryID
# TODO: Need to test
@peerstories.route('/peerstories/<peerStoryID>', methods=['GET'])
def get_peerstory(peerStoryID):
    current_app.logger.info('GET /peerstories/<peerStoryID> route')
    cursor = db.get_db().cursor()
    cursor.execute('SELECT peerStoryID, review, userID, companyID FROM PeerStory WHERE peerStoryID = {0}'.format(peerStoryID))
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Update peer story info for specific peerStoryID
# TODO: Need to test
@peerstories.route('/peerstories/<int:peerStoryID>', methods=['PUT'])
def update_specific_peerstory(peerStoryID):
    current_app.logger.info(f'PUT /peerstories/{peerStoryID} route')
    peerstory_info = request.json

    review = peerstory_info.get('review')
    userID = peerstory_info.get('userID')
    companyID = peerstory_info.get('companyID')

    if review is None or userID is None or companyID is None:
        response = make_response(jsonify({"error": "Missing required fields: review, userID, and companyID"}))
        response.status_code = 400
        return response

    cursor = db.get_db().cursor()

    try:
        cursor.execute('SELECT peerStoryID FROM PeerStory WHERE peerStoryID = %s', (peerStoryID,))
        if cursor.fetchone() is None:
            response = make_response(jsonify({"error": "PeerStory not found"}))
            response.status_code = 404
            return response

        cursor.execute('SELECT userID FROM User WHERE userID = %s', (userID,))
        if cursor.fetchone() is None:
            response = make_response(jsonify({"error": "UserID does not exist"}))
            response.status_code = 400
            return response

        cursor.execute('SELECT companyID FROM Company WHERE companyID = %s', (companyID,))
        if cursor.fetchone() is None:
            response = make_response(jsonify({"error": "CompanyID does not exist"}))
            response.status_code = 400
            return response

        query = 'UPDATE PeerStory SET review = %s, userID = %s, companyID = %s WHERE peerStoryID = %s'
        data = (review, userID, companyID, peerStoryID)
        cursor.execute(query, data)
        db.get_db().commit()

        response = make_response(jsonify({"message": "PeerStory updated successfully"}))
        response.status_code = 200
        return response

    except Exception as e:
        db.get_db().rollback()
        current_app.logger.error(f"Error updating PeerStory: {str(e)}")
        response = make_response(jsonify({"error": "An error occurred while updating the PeerStory."}))
        response.status_code = 500
        return response
