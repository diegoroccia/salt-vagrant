#!python3
import requests, pprint
session = requests.Session()

session.post("http://localhost:8000/login", json={
    "username": "vagrant",
    "password": "vagrant",
    "eauth": "pam"
}) 

pprint.pprint (session.post("http://localhost:8000/", json={ 
    'client': 'local',
    'tgt': '*',
    'fun': 'test.ping'  
}).json() )
