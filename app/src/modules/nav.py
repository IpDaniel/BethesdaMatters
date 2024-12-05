# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st

#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Home.py", label="Home", icon="🏠")


# def AboutPageNav():
#     st.sidebar.page_link("pages/30_About.py", label="About", icon="🧠")


#### ------------------------ Role of student ------------------------
def StudentHomeNav():
    st.sidebar.page_link(
        "pages/00_Student_Home.py", label="Student Home", icon="👤"
    )

def StudentQuestionBank():
    st.sidebar.page_link(
        "pages/01_Question_Bank.py", label="Question Bank", icon="🏦"
    )

def StudentInterviewPrep():
    st.sidebar.page_link(
        "pages/02_Interview_Prep.py", label="Interview Prep", icon="🎤"
    )

def StudentPeerStories():
    st.sidebar.page_link(
        "pages/03_Peer_Stories.py", label="Peer Stories", icon="📖"
    )

def StudentCompanies():
    st.sidebar.page_link(
        "pages/04_Companies.py", label="Companies", icon="🏢"
    )

def StudentAnalytics():
    st.sidebar.page_link(
        "pages/05_Analytics.py", label="Analytics", icon="📈"
    )

# def MapDemoNav():
#     st.sidebar.page_link("pages/02_Map_Demo.py", label="Map Demonstration", icon="🗺️")


#### ------------------------ Role of Alumni ------------------------
def AlumniHomeNav():
    st.sidebar.page_link(
        "pages/10_Alumni_Home.py", label="Alumni Home", icon="👤"
    )


# def PredictionNav():
#     st.sidebar.page_link(
#         "pages/11_Prediction.py", label="Regression Prediction", icon="📈"
#     )


# def ClassificationNav():
#     st.sidebar.page_link(
#         "pages/13_Classification.py", label="Classification Demo", icon="🌺"
#     )

#### ------------------------ Role of Advisor ------------------------
def AdvisorHomeNav():
    st.sidebar.page_link(
        "pages/20_Advisor_Home.py", label="Advisor Home", icon="👤"
    )


# def PredictionNav():
#     st.sidebar.page_link(
#         "pages/11_Prediction.py", label="Regression Prediction", icon="📈"
#     )


# def ClassificationNav():
#     st.sidebar.page_link(
#         "pages/13_Classification.py", label="Classification Demo", icon="🌺"
#     )

#### ------------------------ Role of Teaching Assistant ------------------------
def TAHomeNav():
    st.sidebar.page_link(
        "pages/30_Teaching_Assistant_Home.py", label="TA Home", icon="👤"
    )


# def PredictionNav():
#     st.sidebar.page_link(
#         "pages/11_Prediction.py", label="Regression Prediction", icon="📈"
#     )


# def ClassificationNav():
#     st.sidebar.page_link(
#         "pages/13_Classification.py", label="Classification Demo", icon="🌺"
#     )

# #### ------------------------ System Admin Role ------------------------
# If user role is ADMIN how users, questions, peer stories, and companies.
# def AdminPageNav():
#     st.sidebar.page_link("pages/20_Admin_Home.py", label="System Admin", icon="🖥️")
#     st.sidebar.page_link(
#         "pages/21_ML_Model_Mgmt.py", label="ML Model Management", icon="🏢"
#     )

def AdminNav():
    st.sidebar.page_link(
        "pages/40_Admin_Home.py", label="Admin Home", icon="👤"
    )


# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """

    # add a logo to the sidebar always
    st.sidebar.image("assets/logo.png", width=150)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        # Show the Home page link (the landing page)
        HomeNav()

    # Show the other page navigators depending on the users' role.
    if st.session_state["authenticated"]:

        # If the user role is a student, redirect to the student home page
        if st.session_state["role"] == "student":
            StudentHomeNav()
            StudentQuestionBank()
            StudentInterviewPrep()
            StudentPeerStories()
            StudentCompanies()
            StudentAnalytics()
      
        # If the user role is a alumni, redirect to the alumni home page
        if st.session_state["role"] == "alumni":
            AlumniHomeNav()

        # If the user role is a advisor, redirect to the advisor home pag
        if st.session_state["role"] == "advisor":
            AdvisorHomeNav()

        # If the user role is TA, redirect to the TA home page
        if st.session_state["role"] == "teachingassitant":
            TAHomeNav()

        # If the user is an administrator, give them access to the administrator pages
        if st.session_state["role"] == "administrator":
            AdminNav()

    # Always show the About page at the bottom of the list of links
    # AboutPageNav()

    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")