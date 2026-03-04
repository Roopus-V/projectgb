from flask import Flask
import os

app = Flask(__name__) #initializing the app

VERSION = os.getenv("APP_VERSION", "Version 1 - Blue") #get env varible
#print(VERSION)

@app.route("/")
def home():
    return f"Hello! {VERSION}"

@app.route("/health")
def health():
    return f"Ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

