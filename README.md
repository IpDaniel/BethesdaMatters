# Welcome to NUReady

NUReady is a Flask-based web application designed to assist users of Northeastern University in preparing for interviews. It provides functionality for managing interview questions, peer stories, analytics, and user profiles, along with administrative controls for companies and interview preparation sessions. The app is modular, scalable, and uses a MySQL database for persistence.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Setup and Installation](#setup-and-installation)
- [Project Structure](#project-structure)
- [Endpoints](#endpoints)
- [Environment Variables](#environment-variables)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### Core Functionalities:
- **Users**: Register, update, and manage user profiles.
- **Questions**: Add, update, and retrieve interview questions with filters for companies, roles, and question types.
- **Companies**: Manage company information, including creating, updating, and deleting records.
- **Peer Stories**: Add and manage user-submitted interview experiences with peer reviews.
- **Interview Preparation**: Track and manage interview preparation sessions, linking students and teaching assistants.
- **Analytics**: Get insights into popular companies, user distributions, and interview preparation trends.

### Additional Features:
- RESTful API structure with blueprints for modular code organization.
- Error handling for better debugging and user feedback.
- Logging for request tracking and debugging.
- MySQL database for persistence.
- Secure configuration using environment variables.

---

## Technologies Used

- **Backend**: Flask (Python)
- **Database**: MySQL
- **ORM**: Flask-MySQL
- **Deployment**: Docker (planned), Flask built-in server for development
- **Additional Tools**:
  - `dotenv` for environment variable management
  - `pymysql` for database interactions
  - REST API design principles

---

## Setup and Installation

### Prerequisites
- Python 3.8 or higher
- MySQL Server
- Virtual Environment (optional but recommended)
- Docker (optional for containerized deployment)

### Steps
1. **Clone the Repository**:
    ```bash
    git clone <repository-url>
    cd interview-prep-system
    ```

2. **Set up the Environment**:
    - Create a virtual environment:
      ```bash
      python3 -m venv venv
      source venv/bin/activate  # On Windows: venv\Scripts\activate
      ```
    - Install dependencies:
      ```bash
      pip install -r requirements.txt
      ```

3. **Database Setup**:
    - Create a MySQL database:
      ```sql
      CREATE DATABASE interview_prep_system;
      ```
    - Populate the `.env` file with database credentials:
      ```
      DB_USER=<your-db-username>
      MYSQL_ROOT_PASSWORD=<your-db-password>
      DB_HOST=127.0.0.1
      DB_PORT=3306
      DB_NAME=interview_prep_system
      SECRET_KEY=<your-secret-key>
      ```

4. **Run the Application**:
    ```bash
    export FLASK_APP=run.py
    flask run
    ```
    The app will run at `http://127.0.0.1:5000`.

5. **Test the Endpoints**:
    Use tools like Postman, cURL, or Swagger (if configured) to interact with the API.

---

## Project Structure

```plaintext
.
├── backend/
│   ├── __init__.py
│   ├── db_connection.py      # Database connection setup
│   ├── customers/            # Blueprint for customer routes
│   │   └── customer_routes.py
│   ├── questions/            # Blueprint for question routes
│   │   └── questions_routes.py
│   ├── analytics/            # Blueprint for analytics routes
│   │   └── analytics_routes.py
│   ├── users/                # Blueprint for user routes
│   │   └── users_routes.py
│   ├── companies/            # Blueprint for company routes
│   │   └── companies_routes.py
│   ├── peerstories/          # Blueprint for peer story routes
│   │   └── peerstories_routes.py
│   └── interviewprep/        # Blueprint for interview prep routes
│       └── interviewprep_routes.py
├── run.py                    # Main entry point of the application
├── .env                      # Environment variables
├── requirements.txt          # Python dependencies
└── README.md                 # Project documentation
