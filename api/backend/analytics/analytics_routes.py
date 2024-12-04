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
    """
    Returns a JSON object with the following structure:
        {
        "success": true,
        "data": {
                "top_companies": [
                    {
                        "company": "Company Name",
                        "questions": 15,
                        "stories": 10,
                        "total_interactions": 25
                    },
                    // ... more companies
                ],
                "user_distribution": [
                    {
                        "type": "Student",
                        "count": 150
                    },
                    // ... other user types
                ],
                "monthly_trends": [
                    {
                        "month": "2024-03",
                        "sessions": 45
                    },
                    // ... more months
                ]
            }
    }
    """
    try:
        # Get most popular companies based on number of questions and peer stories
        company_popularity = """
            SELECT 
                c.companyName,
                COUNT(DISTINCT q.questionID) as question_count,
                COUNT(DISTINCT ps.peerStoryID) as story_count,
                COUNT(DISTINCT q.questionID) + COUNT(DISTINCT ps.peerStoryID) as total_interactions
            FROM Company c
            LEFT JOIN Question_comp qc ON c.companyID = qc.companyID
            LEFT JOIN Question q ON qc.questionID = q.questionID
            LEFT JOIN Story_comp sc ON c.companyID = sc.companyID
            LEFT JOIN PeerStory ps ON sc.peerStoryID = ps.peerStoryID
            GROUP BY c.companyID, c.companyName
            ORDER BY total_interactions DESC
            LIMIT 10
        """
        
        # Get user type distribution
        user_distribution = """
            SELECT 
                userType,
                COUNT(*) as count
            FROM User
            GROUP BY userType
        """
        
        # Get interview preparation trends over time
        interview_trends = """
            SELECT 
                DATE_FORMAT(date, '%Y-%m') as month,
                COUNT(*) as prep_sessions
            FROM Stu_Iprep
            GROUP BY DATE_FORMAT(date, '%Y-%m')
            ORDER BY month DESC
            LIMIT 12
        """

        # Execute queries
        companies = db.session.execute(company_popularity).fetchall()
        users = db.session.execute(user_distribution).fetchall()
        trends = db.session.execute(interview_trends).fetchall()

        # Format response
        analytics_data = {
            "top_companies": [
                {
                    "company": company[0],
                    "questions": company[1],
                    "stories": company[2],
                    "total_interactions": company[3]
                } for company in companies
            ],
            "user_distribution": [
                {
                    "type": user[0],
                    "count": user[1]
                } for user in users
            ],
            "monthly_trends": [
                {
                    "month": trend[0],
                    "sessions": trend[1]
                } for trend in trends
            ]
        }

        return jsonify({
            "success": True,
            "data": analytics_data
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500
    
