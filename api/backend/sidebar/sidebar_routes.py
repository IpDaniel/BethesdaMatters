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
        cursor = connection.cursor()
        
        # Add debug logging
        current_app.logger.info("Attempting to fetch sidebar widgets")
        
        query = """
            SELECT id, widget_type, title, content, 
                   updated_at, created_at
            FROM sidebar_widgets
            ORDER BY id
        """
        
        cursor.execute(query)
        results = cursor.fetchall()
        
        # If no widgets found, return empty list instead of error
        if not results:
            current_app.logger.info("No widgets found, returning empty list")
            return jsonify([]), 200
        
        # Convert results to list of dictionaries
        widgets = []
        for row in cursor.fetchall():
            # Get column names from cursor description
            columns = [desc[0] for desc in cursor.description]
            # Create dictionary by zipping column names with row values
            row_dict = dict(zip(columns, row))
            
            widget = {
                'id': row_dict['id'],
                'widget_type': row_dict['widget_type'],
                'title': row_dict['title'],
                'content': row_dict['content'],
                'updated_at': row_dict['updated_at'].strftime("%Y-%m-%dT%H:%M:%S") if row_dict['updated_at'] else None,
                'created_at': row_dict['created_at'].strftime("%Y-%m-%dT%H:%M:%S") if row_dict['created_at'] else None
            }
            widgets.append(widget)
        
        cursor.close()
        return jsonify(widgets), 200
        
    except Exception as e:
        current_app.logger.error(f"Error fetching sidebar widgets: {str(e)}")
        import traceback
        current_app.logger.error(f"Full traceback: {traceback.format_exc()}")
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
