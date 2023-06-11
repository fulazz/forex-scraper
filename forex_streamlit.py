# Import modules
import streamlit as st
import pymongo as pm
import pandas as pd

# ------------------------ MONGO DB ATLAS ------------------------

# Define database connection

con = pm.MongoClient(st.secrets["ATLAS_URL"])
db = con[st.secrets["ATLAS_DB"]]
collection1 = db[st.secrets["ATLAS_COLLECTION1"]]

con = pm.MongoClient(st.secrets["ATLAS_URL"])
db = con[st.secrets["ATLAS_DB"]]
collection2 = db[st.secrets["ATLAS_COLLECTION2"]]

con = pm.MongoClient(st.secrets["ATLAS_URL"])
db = con[st.secrets["ATLAS_DB"]]
collection3 = db[st.secrets["ATLAS_COLLECTION3"]]

# Test get all data
vec_result = []
for x in collection.find():
vec_result.append(x)
  
# ------------------------ STREAMLIT ------------------------

# Configuration
st.set_page_config(
    page_title="Forex Trading Information Project",
    page_icon=":money:"
    layout='wide',
)

