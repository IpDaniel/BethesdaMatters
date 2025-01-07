from flask import Blueprint, jsonify, request, render_template
from flask import current_app
from backend.db_connection import db

sidebar = Blueprint('sidebar', __name__)

@sidebar.route('/edit-sidebar-widgets', methods=['GET'])
def get_sidebar_widgets_page():
    return render_template('sidebar_widget_edit.html')

@sidebar.route('/get-sidebar-widgets', methods=['GET'])
def get_sidebar_widgets():
    try:
        connection = db.get_db()
        cursor = connection.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT id, widget_type, title, content, 
                   updated_at, created_at
            FROM sidebar_widgets
            ORDER BY id
        """)
        
        widgets = cursor.fetchall()
        
        # Convert datetime objects to strings for JSON serialization
        for widget in widgets:
            widget['updated_at'] = widget['updated_at'].isoformat()
            widget['created_at'] = widget['created_at'].isoformat()
        
        cursor.close()
        return jsonify(widgets), 200
        
    except Exception as e:
        current_app.logger.error(f"Error fetching sidebar widgets: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@sidebar.route('/update-sidebar-widget/<int:widget_id>', methods=['PUT'])
def update_sidebar_widget(widget_id):
    try:
        widget_data = request.get_json()
        
        connection = db.get_db()
        cursor = connection.cursor()
        
        update_query = """
            UPDATE sidebar_widgets 
            SET title = %s,
                content = %s
            WHERE id = %s
        """
        
        cursor.execute(update_query, (
            widget_data['title'],
            widget_data['content'],
            widget_id
        ))
        
        connection.commit()
        cursor.close()
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Widget not found'}), 404
            
        return jsonify({'message': 'Widget updated successfully'}), 200
        
    except KeyError as e:
        current_app.logger.error(f"Missing required field: {str(e)}")
        return jsonify({'error': f'Missing required field: {str(e)}'}), 400
    except Exception as e:
        current_app.logger.error(f"Error updating sidebar widget: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@sidebar.route('/create-sidebar-widget', methods=['POST'])
def create_sidebar_widget():
    try:
        widget_data = request.get_json()
        
        connection = db.get_db()
        cursor = connection.cursor()
        
        insert_query = """
            INSERT INTO sidebar_widgets 
            (widget_type, title, content)
            VALUES (%s, %s, %s)
        """
        
        cursor.execute(insert_query, (
            widget_data['widget_type'],
            widget_data['title'],
            widget_data['content']
        ))
        
        connection.commit()
        new_widget_id = cursor.lastrowid
        cursor.close()
        
        return jsonify({
            'message': 'Widget created successfully',
            'id': new_widget_id
        }), 201
        
    except KeyError as e:
        current_app.logger.error(f"Missing required field: {str(e)}")
        return jsonify({'error': f'Missing required field: {str(e)}'}), 400
    except Exception as e:
        current_app.logger.error(f"Error creating sidebar widget: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500
