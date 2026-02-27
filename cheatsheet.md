# ProjectGB Blue/Green Deployment Cheat Sheet

## Project Structure
projectgb/
│
├── app.py           # Flask application
├── requirements.txt # Python dependencies
├── Dockerfile       # Docker instructions
└── cheatsheet.md    # This cheat sheet

## Flask App (Python) – app.py
from flask import Flask
import os

# Initialize Flask app
app = Flask(__name__)

# Get version from environment variable, default to "Version 1 - Blue"
VERSION = os.getenv("APP_VERSION", "Version 1 - Blue")

# Root route - shows current app version
@app.route("/")
def home():
    return f"Hello! {VERSION}"

# Health check endpoint - used by load balancers / Kubernetes
@app.route("/health")
def health():
    return "OK", 200

# Run the app
if __name__ == "__main__":
    # host=0.0.0.0 exposes app outside container/VM
    app.run(host="0.0.0.0", port=5000)

**Key Concepts:**
- `os.getenv()` → Reads environment variables, allows different versions without changing code
- `host="0.0.0.0"` → Required to expose Flask app outside VM/container
- `/health` → Health check endpoint for load balancers/Kubernetes

## Python Dependencies – requirements.txt
Flask==2.3.2
- Only installs Flask needed to run the app
- Keep it minimal for deployment demos

## Dockerfile
# Base Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy Python dependencies
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask app code
COPY app.py .

# Expose port 5000
EXPOSE 5000

# Default environment variable for version
ENV APP_VERSION="Version 1 - Blue"

# Run the Flask app
CMD ["python", "app.py"]

**Key Docker Concepts:**
- `FROM` → Base image (Python)
- `WORKDIR` → Container working directory
- `COPY` → Copy files into container
- `RUN pip install ...` → Install dependencies
- `EXPOSE` → Expose container port for networking
- `ENV` → Set default environment variable (Blue version)
- `CMD` → Command executed when container runs

## Docker Commands

### Build Docker Image
docker build -t projectgb:blue .
- `-t projectgb:blue` → Tag the image as "blue"
- `.` → Current folder as build context

### Run Blue Version
docker run -p 5000:5000 projectgb:blue
- `-p host:container` → Map container port 5000 → host port 5000
- Default version is used from Dockerfile

### Run Green Version (Override ENV Variable)
docker run -p 5001:5000 -e APP_VERSION="Version 2 - Green" projectgb:blue
- `-e APP_VERSION=...` → Override default environment variable for Green version
- Allows Blue/Green deployment testing locally

### Push Image to DockerHub
docker tag projectgb:blue projectgb/projectgb:blue
docker push projectgb/projectgb:blue
- Tag and push the image to DockerHub under your account/project

## Test URLs
- Blue → http://localhost:5000 → Hello! Version 1 - Blue
- Green → http://localhost:5001 → Hello! Version 2 - Green
- Health → http://localhost:5000/health or http://localhost:5001/health → OK, 200

## Key DevOps Notes
- Blue/Green deployment principle: same image, different environment variable → different “version”
- `/health` endpoint → used by load balancers/Kubernetes to check if pod/container is healthy
- Use environment variables to configure app behavior without changing code
- host="0.0.0.0" → critical for exposing Flask app in containers or VMs
- Port mapping `-p host:container` → allows host to access container ports
- Keep app simple for learning deployment strategy
- Docker images can be reused in Kubernetes for actual Blue/Green deployment

## Pro Tips
- Always test both Blue & Green versions locally before pushing
- Use small, lightweight Python images for faster builds (`python:3.11-slim`)
- Commit your cheat sheet in the project folder to save learning notes
- `/health` endpoint should always return 200 if app is healthy
- Environment variables make the deployment flexible without code changes
