from flask import Blueprint, jsonify, request, render_template
from flask import current_app
from backend.db_connection import db
import logging
from flask_login import login_required
# Set up logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Add a stream handler to see logs in console
handler = logging.StreamHandler()
handler.setLevel(logging.INFO)
logger.addHandler(handler)

sidebar = Blueprint('sidebar', __name__)

@sidebar.route('/edit-sidebar-widgets', methods=['GET'])
@login_required
def get_sidebar_widgets_page():
    return render_template('sidebar_widget_edit.html')

@sidebar.route('/get-sidebar-widgets', methods=['GET'])
def get_sidebar_widgets():
    try:
        connection = db.get_db()
        cursor = connection.cursor()
        
        query = """
            SELECT id, widget_type, title, content, 
                   updated_at, created_at
            FROM sidebar_widgets
            ORDER BY id
        """
        
        cursor.execute(query)
        results = cursor.fetchall()
        
        # Log raw results
        logger.info("Raw results from database: %s", results)
        
        if not results:
            logger.info("No widgets found, returning empty list")
            return jsonify([]), 200
        
        # Since we're getting dictionaries, we can just pass them through
        # with minimal processing for the dates
        widgets = []
        for row in results:
            # Log the raw row for debugging
            logger.info("Processing raw row: %s", row)
            
            # Just format the dates and pass through the rest
            row['updated_at'] = row['updated_at'].strftime("%Y-%m-%dT%H:%M:%S") if row['updated_at'] else None
            row['created_at'] = row['created_at'].strftime("%Y-%m-%dT%H:%M:%S") if row['created_at'] else None
            widgets.append(row)
            
            # Log each processed widget
            logger.info("Processed widget: %s", row)
        
        cursor.close()
        
        # Log final response
        logger.info("Sending response with %d widgets: %s", len(widgets), widgets)
        return jsonify(widgets), 200
        
    except Exception as e:
        logger.error("Error fetching sidebar widgets: %s", str(e))
        import traceback
        logger.error("Full traceback: %s", traceback.format_exc())
        return jsonify({'error': 'Internal server error'}), 500

@sidebar.route('/update-sidebar-widget/<int:widget_id>', methods=['PUT'])
@login_required
def update_sidebar_widget(widget_id):
    try:
        widget_data = request.get_json()
        
        connection = db.get_db()
        cursor = connection.cursor()
        
        update_query = """
            UPDATE sidebar_widgets 
            SET title = %s,
                content = %s,
                widget_type = %s
            WHERE id = %s
        """
        
        cursor.execute(update_query, (
            widget_data['title'],
            widget_data['content'],
            widget_data['widget_type'],
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
@login_required
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

@sidebar.route('/get-widget-types', methods=['GET'])
def get_widget_types():
    try:
        connection = db.get_db()
        cursor = connection.cursor()
        
        # Query to get enum values from the information schema
        query = """
            SELECT COLUMN_TYPE
            FROM information_schema.COLUMNS 
            WHERE TABLE_SCHEMA = 'bethesda_matters'
            AND TABLE_NAME = 'sidebar_widgets' 
            AND COLUMN_NAME = 'widget_type'
        """
        
        cursor.execute(query)
        result = cursor.fetchone()
        cursor.close()
        
        if not result:
            return jsonify({'error': 'Could not fetch widget types'}), 500
            
        # Parse the enum string into a list
        # Input looks like: "enum('traffic','events','sports')"
        enum_str = result['COLUMN_TYPE']
        # Remove "enum(" from start and ")" from end
        enum_str = enum_str[5:-1]
        # Split by comma and clean up quotes
        widget_types = [t.strip("'") for t in enum_str.split(',')]
        
        return jsonify(widget_types), 200
        
    except Exception as e:
        logger.error("Error fetching widget types: %s", str(e), exc_info=True)
        return jsonify({'error': 'Internal server error'}), 500

@sidebar.route('/delete-sidebar-widget/<int:widget_id>', methods=['DELETE'])
@login_required
def delete_sidebar_widget(widget_id):
    try:
        connection = db.get_db()
        cursor = connection.cursor()
        
        delete_query = "DELETE FROM sidebar_widgets WHERE id = %s"
        cursor.execute(delete_query, (widget_id,))
        
        connection.commit()
        
        if cursor.rowcount == 0:
            cursor.close()
            return jsonify({'error': 'Widget not found'}), 404
            
        cursor.close()
        return jsonify({'message': 'Widget deleted successfully'}), 200
        
    except Exception as e:
        logger.error("Error deleting sidebar widget: %s", str(e), exc_info=True)
        return jsonify({'error': 'Internal server error'}), 500
