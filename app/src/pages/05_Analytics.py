import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.title("View Analytics")
st.write('')
st.write('')
st.write('### What kind of data would you like to inquire today?')

# TODO: Need help implementing this cos idk what its about tbh
