from prometheus_client import Counter, generate_latest
from flask import Response, Flask
import os

#Defining counting metrics
REQUEST_COUNT = Counter(
    "app_requests_total",
    "Total App Requests",
    ["container"]
)


app = Flask(__name__) #initializing the app

#VERSION = os.getenv("APP_VERSION", "Version 1 - Blue") #get env varible
color = os.getenv("COLOR", "UNKNOWN") #get env varible
#print(VERSION)

@app.route("/")
def home():
    REQUEST_COUNT.labels(container=color).inc()
    return f"{color} deployment"

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype="text/plain")

@app.route("/health")
def health():
    return f"Ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

