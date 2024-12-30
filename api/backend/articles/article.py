from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from flask import render_template
from backend.db_connection import db

articles = Blueprint('articles', __name__)

from flask import render_template

@articles.route('/<article_id>')
def article(article_id):
    # This would typically come from a database
    article_data = {
        'title': 'Breaking News: Local Community Center Receives Major Renovation Grant',
        'cover_image': 'https://www.ymcadc.org/wp-content/uploads/2022/06/YMCA-BCC-scaled.jpg',
        'cover_image_caption': 'The Bethesda Community Center will undergo major renovations',
        'author': 'Sarah Johnson',
        'date': 'March 15, 2024',
        'read_time': '5',
        'content': [
            {
                'type': 'text',
                'value': 'The Bethesda Community Center has been awarded a $2 million grant for comprehensive renovations and upgrades. This transformative funding, announced during Tuesday\'s town hall meeting, marks a significant milestone in the center\'s 25-year history. Local officials and community leaders gathered to celebrate this unprecedented investment in community infrastructure. The grant, provided by the Regional Development Foundation in partnership with several corporate donors, will enable the facility to expand its current programs and introduce new services that residents have long requested. Among the planned improvements are a state-of-the-art fitness center, modernized meeting spaces, enhanced accessibility features, and an expanded children\'s area. Community center director Maria Rodriguez expressed her enthusiasm, noting that these renovations will allow the center to serve an additional 500 families per month. The project also includes sustainability upgrades, with solar panels and energy-efficient systems expected to reduce operating costs by 40% annually...'
            },
            {
                'type': 'image',
                'url': 'https://images.adsttc.com/media/images/5f62/71c8/63c0/179b/5800/036c/original/1.gif?1600287170',
                'alt': 'Renovation Plans',
                'caption': 'Architectural rendering of the proposed renovations'
            },
            {
                'type': 'text',
                'value': 'Construction is expected to begin this summer...'
            }
        ]
    }

    return render_template('article.html', article=article_data)


@articles.route('/featured-articles')
def featured_articles():
    featured_articles_data = [
        {
            "id": "1",
            "title": "Breaking News: Local Community Center Receives Major Renovation Grant",
            "author": "Sarah Johnson",
            "date": "March 15, 2024",
            "readTime": "5 min read",
            "excerpt": "The Bethesda Community Center has been awarded a $2 million grant for renovations and expansion...",
            "imageUrl": "https://www.ymcadc.org/wp-content/uploads/2022/06/YMCA-BCC-scaled.jpg",
            "imageAlt": "Community Center Renovation"
        },
        {
            "id": "2",
            "title": "New Bike Lanes Transform Downtown Traffic Flow",
            "author": "Michael Chen",
            "date": "March 14, 2024",
            "readTime": "4 min read",
            "excerpt": "City planners celebrate the completion of dedicated bike lanes throughout the downtown area...",
            "imageUrl": "https://example.com/bike-lanes.jpg",
            "imageAlt": "New Downtown Bike Lanes"
        },
        {
            "id": "3",
            "title": "Local Farm-to-Table Restaurant Opens Second Location",
            "author": "Emily Rodriguez",
            "date": "March 13, 2024",
            "readTime": "3 min read",
            "excerpt": "The popular Harvest Table restaurant announces expansion plans with a new location...",
            "imageUrl": "https://example.com/restaurant.jpg",
            "imageAlt": "Harvest Table Restaurant"
        },
        {
            "id": "4",
            "title": "Local Tech Startup Secures Major Investment",
            "author": "David Park",
            "date": "March 12, 2024",
            "readTime": "6 min read",
            "excerpt": "Bethesda-based AI startup SecureFlow announces $10 million Series A funding round...",
            "imageUrl": "https://example.com/startup.jpg",
            "imageAlt": "SecureFlow Team Celebration"
        },
        {
            "id": "5",
            "title": "Historic Theater Announces Summer Arts Program",
            "author": "Lisa Martinez",
            "date": "March 11, 2024",
            "readTime": "4 min read",
            "excerpt": "The Strand Theater unveils an ambitious summer program featuring local artists and performers...",
            "imageUrl": "https://example.com/theater.jpg",
            "imageAlt": "The Strand Theater"
        },
        {
            "id": "6",
            "title": "New Environmental Initiative Launches in Schools",
            "author": "James Wilson",
            "date": "March 10, 2024",
            "readTime": "5 min read",
            "excerpt": "Local schools implement innovative recycling and sustainability programs to reduce carbon footprint...",
            "imageUrl": "https://example.com/school-environment.jpg",
            "imageAlt": "Students Participating in Recycling Program"
        }
    ]
    
    return jsonify(featured_articles_data)
